package org.lared.desinventar.dbase;

import java.io.*;
import java.sql.*;
import java.text.*;
import java.util.*;

import org.lared.desinventar.dbase.*;

/**
* Class to read and write DBase II, DBase III+, DBase IV and some aspects of FoxProV2.
* <P>
* Much of this API is similar to the JDBC API, making it feel more familiar to JDBC programmers.
* However, this is not a JDBC implementation.  One major reason is simply that most products using
* DBase are brain dead and don't have any form of SQL access from Java or outside world programs.
*<P>
* All data types can be read from a table (one table per constructor), even memo fields.
* <P><B>Note: Columns start at 0, not 1 like a ResultSet.</B>
* <P>
* An effort was made a caching records but there was no really significant speed increase.  The reason
* for this unexpected behavior hasn't been investigated, but since it runs slightly faster with caching
* so the code's been left in place.
* <p>
* There is no support for indices.  If you have index files they will not be in sync with changed table
* data.
* Some applications will rebuild their index tables if they notice them missing (like Lotus Approach)
* and to this end a pair of methods are available - {@link #killIndex()} and {@link #killIndex(String table)}.
*<P>
* All the above database tables have the same layout but the difference lies in their memo file structure
* (*dbt and in the case of FoxPro *.ftp).  Without examining the structure of the memo file it's difficult
* to determine the differences.  The headers offer very little help. For most people it will be a matter of
* trial and error using the method {@link #setMemoHandler(String handler) setMemoHandler()}.
*<P>
* FoxPro support does not include the P, Y, T, and I fields yet.
* <p>
* Copyright December 12, 2000 Michael Lecuyer.
* This code may be used under the Gnu General Public License [http://www.gnu.org/copyleft/gpl.html].
* <p> Example of use:
* <pre>
* DBase db = new DBase("/database/dbase");
* // Optional, specify how Memo data is read and written.
* // The default is to use DBASE IV Memo fields.
* // Enable the next line to handle DBASE III memo fields.
*
* // db.setMemoHandler("DBASEIIIMemoHandler");
*
* String sql = "select PRODUCTNUM, DESCRIP, NAME from Products where PRODUCTNUMBER='S9834'";
* db.exec(sql);
*
* // Get column names if we want them.
* String [] column = db.getColumnNames();
*
* while (db.next()) {
*	for (i = 0; i < column.length; i++)
*		System.out.print(db.getString(column[i]));
* }
*</pre>
* A simple way to perform SELECT * FROM table:
* <pre>
* db.openTable("products");
* while (db.next()) {
* 	...
* }
* db.closeTable();
* </pre>
* <p>
* The parser is not smart enough to perform joins of multiple tables.
* This SQL understands the statements INSERT, UPDATE, SELECT, and DELETE.  The SELECT statement handles column names and '*'.
* The WHERE clause understands comparison operators  "<>", "<=",  ">=", ">". "<", and "=".  It also understands AND, OR, and NOT.
* It does not handle grouping by parenthesis.
* There is no ORDER BY clause.
*/
public class DBase
{
	/**
	* DBase software version number ({@value})
	*/
	public final static String Version = "2.02";

	/**
	* FoxPro V2 Memo handler - {@value}.
	*/
	public static final String FOXPRO2 = "FOXPRO2MemoHandler";

	/**
	* DBASE III+ Memo handler - {@value}.
	*/
	public static final String DBASEIII = "DBASEIIIMemoHandler";

	/**
	* DBASE IV Memo handler - {@value}.
	*/
	public static final String DBASEIV = "DBASEIVMemoHandler";

	long records = 0;		// Number of records in DB. Unfortunately this will not be updated in all instances of DBase
							// since each DBase is table sensitive.  We may have a global table object, one for
							// each table to track these things.
	String fName[] = null;	// Field names.
	long recnum = -1;			// Record number we're sitting at.
	int headerSize;			// Length of header data.
	int recordSize;			// Length of each record.
	ByteArrayOutputStream memo;	// Memo data.
	String currentMemoName = null;	// Field name associated with this memo data.
	Record record;				// Record object.
	int columnCount = 0;		// Column count.
	String tableName;			// Table name.
	String dbPath;				// Path to tables.
	RandomAccessFile dbtf = null;	// Database memo file.
	RandomAccessFile dbff = null;	// Database table file.
	long resultList[] = null;		// This is the result list to be used by beforeFirst() / next(). If null, the entire record list is
								// used, otherwise only the records in the list are used.
	int resultListIndex = 0;		// Used when the result list isn't null to advance through the list.

	private SQLStatement selectStatement;	// Information from the last SELECT statement

	// Handler for memo fields - default is for Lotus Approach.
	private MemoHandler memoHandler;

	/**
	* Constructor to handle a DBase directory.
	*
	* @param path Path to the DBase directory holding dbase tables.
	* @throws SQLException if the default memo handler can't be found.
	*/
	public DBase(String path) throws SQLException
	{
		dbPath = path;
		memoHandler = MemoHandler.getInstance("DBASEIVMemoHandler");
		memoHandler.setBlockSize(Record.BLOCKSIZE);
	}

	/**
	* Set a specific memo file handler based on database type.
	* Known handlers are DBASEIVMemoHandler, DBASEIIIMemoHandler, and FOXPRO2MemoHandler.
	* The string to use is the class name of the handler.  If the class is outside the package the full
	* class path will have to be specified.
	* <p>
	* The default handler is the 'DBASEIVMemoHandler'. The other choices are
	* 'DBASEIIIMemoHandler' and 'FOXPRO2MemoHandler'.
	* <p>
	* How do you know which to use? Try to read the database until one works with memo data.
	* If you attempt to read a database memo field and are missing the first eight characters
	* then you should be using the DBASEIIIMemoHandler.  Under no circumstance try writing
	* to a memo field until you are <b>sure</b> your choice is correct.
	* <p>
	* For convenience you may use {@link #FOXPRO2}, {@link #DBASEIII} , or {@link #DBASEIV}
	* instead of the longer class names.
	* @param handler Memo handler class name.
	* @throws SQLException if the handler can't be found.
	*
	* @since 2.01
	*/
	public void setMemoHandler(String handler) throws SQLException
	{
		memoHandler = MemoHandler.getInstance(handler);
		memoHandler.setBlockSize(Record.BLOCKSIZE);
	}

	/**
	* Constructor to read the DBASE table.
	* <P>
	*The constructor returns something akin to a ResultSet which resembles
	* the result of a 'select * from table'.
	* Since the database is meant to be read sequentially for a copy some methods
	* for driving around are missing like absolute(), afterLast(), and so on.
	*
	* @param table Name of the table in the DBase directory (no extension - assumed to be .dbf).
	*/
	public void openTable(String table) throws SQLException
	{
		String dbf = dbPath + File.separator + table +  ".dbf";
		String dbt = dbPath + File.separator + table +  ".dbt";
		tableName = table;

		File f = new File(dbf);
		if (! f.exists())
			throw new SQLException("Table " + table + " doesn't exist. Can't create it with this version of DBase.");

		try {
			dbff = new RandomAccessFile(dbf, "rw");
			f = new File(dbt);
			if (f.exists())
				dbtf = new RandomAccessFile(dbt, "rw");
			else {
				// Maybe this is a FoxPro V2 system.
				dbt = dbPath + File.separator + table +  ".fpt";
				f = new File(dbt);
				if (f.exists())
					dbtf = new RandomAccessFile(dbt, "rw");
			}

			record = new Record(table, dbff, dbtf);
			records = record.getRecordCount();
			fName = record.getColumnNames();
		} catch (Exception e) {
			throw new SQLException("Error reading table " + table + ", probably empty or not a DBase table.\n" + getStackTrace(e));
		}
		memo = null;	// Invalidate the memo data.
	}

	/**
	* Remove Lotus Approach index file for the given table.
	* <p>
	* This should be done if changes have been made to the database.
	* If you have an Approach application it will be recreated automatically.
	* Note that if the index file is not updated or deleted the Approach
	* application will not notice any data that has changed by an external
	* program (like this one).
	*
	* @param table Name of table without extension or database path.
	*/
	public void killIndex(String table)
	{
		File f = new File(table + ".adx");
		f.delete();
	}

	/**
	* Remove Lotus Approach index file for the current table
	* This should be done when changes have been made to the database.
	*/
	public void killIndex()
	{
		if (tableName == null)
			return;

		// Delete the file.  This is safe even if the file doesn't exist.
		File f = new File(tableName + ".adx");
		f.delete();
	}

	/**
	* Close a table releasing it's resources.
	*/
	public void closeTable() throws SQLException
	{
		if (dbff == null)
			return;	// Already closed or never opened.

		try {
			dbff.close();
			if (dbtf != null)
				dbtf.close();

			tableName = null;
			dbtf = null;
			dbff = null;
		} catch (IOException ioe) {
			throw new SQLException(getStackTrace(ioe));
		}
	}

	/**
	* Show table data.
	* @return A string displaying a table.
	*/
	public String showTable(String table) throws SQLException
	{
		int i;

		closeTable();
		openTable(table);

		String cName[] = getColumnNames();
		int cSize[] = getColumnWidths();
		char cType[] = getColumnTypes();

		// Find the widest field name.
		int max = 0;
		for (i = 0; i < cName.length; i++)
		{
			if (cName[i].length() > max)
				max = cName[i].length();
		}
		max += 2;

		StringBuffer sb = new StringBuffer();
		sb.append("Table: ").append(table).append('\n');
		for (i = 0; i < cName.length; i++)
		{
			String field = fmt(cName[i], max);
			if (cType[i] == 'M')
				sb.append("     ").append(field).append("Large").append(" (").append(cType[i]).append(')').append('\n');
			else
				sb.append("     ").append(field).append(cSize[i]).append(" (").append(cType[i]).append(')').append('\n');
		}

		closeTable();

		return sb.toString();
	}

	/**
	* Show table names in this database.
	*
	* @return array of table names.
	*/
	public String showTableNames() throws SQLException
	{
		int i;
		StringBuffer sb = new StringBuffer();
		sb.append("Tables in ").append(dbPath).append('\n');

		File dir = new File(dbPath);
		String dirList[] = dir.list();

		for (i = 0; i < dirList.length; i++)
		{
			if (dirList[i].toLowerCase().endsWith(".dbf"))
				sb.append(dirList[i].substring(0, dirList[i].length() - 4)).append('\n');
		}

		return sb.toString();
	}

	/**
	* Format a value to fit a given width.
	*/
	public String fmt(String value, int width)
	{
		int vLen = value.length();
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < width; i++)
		{
			if (i < vLen)
				sb.append(value.charAt(i));
			else
				sb.append(' ');
		}

		return sb.toString();
	}

	/**
	* Execute a sql statement.
	*
	* @param sql SQL statement.
	*/
	public void exec(String sql) throws SQLException
	{
		SQLStatement statement = null;
		selectStatement = null;			// Information from the select statement, initially none.

		try {
			SQL parser = new SQL(sql);
			parser.Statement();
			statement = parser.getStatement();
			statement.complete();
		} catch (ParseException pe) {
			throw new SQLException(getStackTrace(pe));
		}

		openTable( (String)statement.tableName.get(0));

		resultList = null;	// Kill any old searches on this table.

		switch (statement.type)
		{
			case SQLStatement.STATEMENT_SELECT:
				selectStatement = null;
				select(statement);
				selectStatement = statement;
				break;

			case SQLStatement.STATEMENT_UPDATE:
				update(statement);
				break;

			case SQLStatement.STATEMENT_INSERT:
				insert(statement);
				break;

			case SQLStatement.STATEMENT_DELETE:
				delete(statement);
				break;

			default:
				closeTable();
				throw new SQLException("Unknown statement type: " + statement.type + ": " + statement.sqlSource);
		}
	}

	/**
	* Perform the SELECT statement.
	* Because of the nature of the 'result set' all SELECT's act as though they returned '*'.
	*
	* @param statement SQLStatement action definition.
	*/
	private void select(SQLStatement statement) throws SQLException
	{
		where(statement);
		beforeFirst();
	}

	/**
	* Perform the INSERT statement.
	*
	* @param statement SQLStatement action definition.
	*/
	private void insert(SQLStatement statement) throws SQLException
	{
		int i;
		Pair pr;

		// First get a buffer to merge data.
		createRecord();

		// Loop through the field list assigning values.
		PairList pl = statement.fieldValue;
		Pair p;
		for (pl.first(); (p = pl.next()) != null; )
		{
			FieldValue fValue = (FieldValue)p.value;
			if (fValue.isString())
				putField(p.name, fValue.getString());
			else if (fValue.isDouble())
			{
				putField(p.name, ("" + fValue.getDouble()));
			}
		}
		appendRecord();
	}

	/**
	* Perform the UPDATE statement.
	*
	* @param statement SQLStatement action definition.
	*/
	private void update(SQLStatement statement) throws SQLException
	{
		where(statement);

		beforeFirst();
		while (next())
		{
			PairList pl = statement.fieldValue;
			Pair p;
			for (pl.first(); (p = pl.next()) != null; )
			{
				FieldValue fValue = (FieldValue)p.value;
				if (fValue.isString())
					putField(p.name, fValue.getString());
				else if (fValue.isDouble())
					putField(p.name, ("" + fValue.getDouble()));
			}

			deleteRecord();
			appendRecord();
		}
	}

	/**
	* Perform the DELETE statemrent.
	*
	* @param statement SQLStatement action definition.
	*/
	private void delete(SQLStatement statement) throws SQLException
	{
		where(statement);

		beforeFirst();
		while (next())
			deleteRecord();
	}

	/**
	* Where clause.
	* Sets it's resultList for the beforeFirst() & next() methods.
	*
	* @param statement SQLStatement action definition.
	* @return list of record numbers matching the where criteria.
	* Side effect is that resultList controlling beforeFirst() & next() is affected.
	*/
	private long [] where(SQLStatement statement) throws SQLException
	{
		ArrayList recList = new ArrayList();
		int whereLen = statement.whereList.size();

		// If there's no where, return the complete list of records.
		if (whereLen == 0)
		{
			resultList = null;
			return resultList;
		}

		for (int i = 0; i < whereLen; i++)
		{
			// Currently the tabeList is limited to one element.
			long rList[] = search( (String)statement.tableName.get(0), (Where)statement.whereList.get(i));
			recList.add(rList);
		}

		resultList = mergeWhereLists(recList, statement.whereList);

		return resultList;
	}

	/**
	* Get column count.
	*
	* @return column count.
	*/
	public int getColumnCount()
	{
		if (selectStatement == null)
			return record.getColumnCount();

		int columnCount = selectStatement.fields.size();
		if (((String)selectStatement.fields.get(0)).equals("*"))
			return record.getColumnCount();

		return columnCount;
	}

	/**
	* Get a list of column names
	*
	* @return array of Strings containing column names.
	*/
	public String [] getColumnNames()
	{
		// If there was no select statement return everything.
		if (selectStatement == null)
			return record.getColumnNames();

		int fieldSize = selectStatement.fields.size();

		// Check for the special field name '*'.
		if (((String)selectStatement.fields.get(0)).equals("*"))
			return record.getColumnNames();

		String cn[] = new String[fieldSize];
		for (int i = 0; i < fieldSize; i++)
			cn[i] = (String)selectStatement.fields.get(i);

		return cn;
	}

	/**
	* Get a list of column widths
	*
	* @return array of ints containing column widths.
	*/
	public int [] getColumnWidths() throws SQLException
	{
		// If there was no select statement return everything.
		if (selectStatement == null)
			return record.getColumnWidths();

		// Find the field index in the column names list and get the width value.
		String fieldName[] = getColumnNames();

		// Check for the special field name '*'.
		if (((String)selectStatement.fields.get(0)).equals("*"))
			return record.getColumnWidths();

		int numfields = selectStatement.fields.size();
		int width[] = new int[numfields];
		int allWidth[] = record.getColumnWidths();

		for (int i = 0; i < fieldName.length; i++)
		{
			int col = findColumn(fieldName[i]);
			width[i] = allWidth[col];
		}

		return width;

	}

	/**
	* Get a list of column types
	*
	* @return array of ints containing column widths.
	*/
	public char [] getColumnTypes() throws SQLException
	{
		// If there was no select statement return everything.
		if (selectStatement == null)
			return record.getColumnTypes();

		// Find the field index in the column names list and get the width value.
		String fieldName[] = getColumnNames();

		// Check for the special field name '*'.
		if (((String)selectStatement.fields.get(0)).equals("*"))
			return record.getColumnTypes();

		int numfields = selectStatement.fields.size();
		char type[] = new char[numfields];
		char allType[] = record.getColumnTypes();

		for (int i = 0; i < fieldName.length; i++)
		{
			int col = findColumn(fieldName[i]);
			type[i] = allType[col];
		}

		return type;

	}

	/**
	* Get the number of records found by a select.
	* This takes the place of a count(*) in a select.
	*/
	public int count()
	{
		return (resultList != null) ? resultList.length : (int)records;
	}

	/**
	* Advance to the next record.
	*/
	public boolean next() throws SQLException
	{
		memo = null;	// Invalidate the cached memo data.

		// If there's no list, use the entire table.
		if (resultList == null)
		{
			while (recnum < records && record.getRecord(++recnum) == false)
				;

			if (recnum < records)
				return true;

			return false;
		}

		// There's a list, advance through it.
		while (resultListIndex < resultList.length)
		{
			recnum = resultList[resultListIndex++];

			if (record.getRecord(recnum) == false)
				continue;	// Skip missing records.
			else
				return true;
		}
		return false;

	}

	/**
	* Move the record to the beginning before using the next method.
	*/
	public void beforeFirst()
	{
		if (resultList == null)
			recnum = -1;
		else
			resultListIndex = 0;

		memo = null;	// Invalidate the memo data.
	}

	/**
	* Move to an absolute record number.
	*
	* @param recnum Record number required.
	* @return true if the record was found, false otherwise.
	*/
	public boolean absolute(long recnum) throws SQLException
	{
		return record.getRecord(recnum);
	}

	/**
	* Put byte data into a particular field.
	* All fields hold readable strings (numbers, dates, floating point).  This is what should be passed into a field.
	* The data that goes into the field looks just like the byte data that came out.
	*
	* @param name Field name.
	* @param contents Field contents
	*/
	public void putField(String name, byte contents[]) throws SQLException
	{
		int idx = findColumn(name);
		record.putField(idx, contents);
	}

	/**
	* Create a record buffer for building a new record.
	* All fields have default values of nothing or 0.
	*/
	void createRecord()
	{
		record.createRecordBuffer();
	}

	/**
	* Delete the current record.
	*/
	void deleteRecord() throws SQLException
	{
		record.deleteRecord(recnum);
	}

//	/**
//	* Write the current record over the current record number.
//	* This over writes the current record (used with UPDATE).
//	*/
//	void writeRecord() throws SQLException
//	{
//		record.writeRecord(recnum);
//	}

	/**
	* Append the record created by createRecord();
	* All new an updated records are appended.  This allows transaction recovery by
	* rolling back all deleted records involved in the transaction.
	*/
	void appendRecord() throws SQLException
	{
		record.appendRecord();
		records++;	// Add this new record to the total number of records.
	}

	/**
	* Put byte data into a particular field.
	* All DBASE fields contain strings, including numbers and dates.
	* Attempts to load more data into a field than it can hold results in the truncation of your data.
	* <p>
	* <table border="1" width="100%" cellspacing="0">
	* <tr>
	* <td width="100%" colspan="2" ><strong>Field types and values for DBASE Data Types</strong></td>
	* </tr>
	* <tr>
	* <td valign="top" nowrap >Type </td>
	* <td valign="top" >Input </td>
	* </tr>
	* <tr>
	* <td valign="top" nowrap >C (Character) </td>
	* <td valign="top" >Characters (strings). </td>
	* </tr>
	* <tr>
	* <td valign="top" nowrap >D (Date) </td>
	* <td valign="top" >Stored as 8 digits in YYYYMMDD format. </td>
	* </tr>
	* <tr>
	* <td valign="top" nowrap >N (Numeric) </td>
	* <td valign="top" > Using the characters - . 0 1 2 3 4 5 6 7 8 9 </td>
	* </tr>
	* <tr>
	* <td valign="top" nowrap >L (Logical) </td>
	* <td valign="top" >One of the following characters: ? Y y N n T t F f (? when not
	* initialized). </td>
	* </tr>
	* <tr>
	* <td valign="top" nowrap >M (Memo) </td>
	* <td valign="top" >Characters.  Note it's difficult to store binary data since a byte value of 0 marks the end of data in some
	* systems (Lotus Approach) and '0x1A 0x1A' marks it in others (Foxpro), and some systems mark it with just one 0x1A.
	* </td>
	* </tr>
	* </table>
	*
	* @param name Field name.
	* @param contents Field contents
	*/
	public void putField(String name, String contents) throws SQLException
	{
		putField(name, contents.getBytes());
	}

	/**
	* Write a record out to the database.
	*
	* @param recnum Record number to write.
	*/
	public void writeRecord(long recnum) throws IOException, SQLException
	{
		record.writeRecord(recnum);
	}

	/**
	* Get a memo field's data.
	* If this is called instead of getString() (which will work just fine), the memo is cached
	* instead of being reread.  getString() will not cache the memo.
	* This only really matters if you reread the same memo field several times instead of assigning it.
	* It's a convenience method from the early days of the DBase class where it only reads the memo
	* fields.
	*
	* @param name Name of the field that holds the memo data.
	* @return the memo as a string or null if something went wrong.
	*/
	public String getMemo(String name) throws SQLException
	{
		// Memo's get special treatment.  They're cached.

		String pName = properName(name);

		// See if they're asking for the same memo in the same field and record.
		if (currentMemoName != null && currentMemoName.equalsIgnoreCase(pName))
			if (memo != null)
				return memo.toString();

		currentMemoName = pName;	// Save the field name in case of repeat reference.
		int idx = findColumn(name);
		record.getMemoData(idx);

		if (memo == null)
			return null;

		return memo.toString();
	}

	/**
	* Return the index of a field name.
	*
	* @param name of a field.
	* @return index of the field.
	*/
	public int findColumn(String name) throws SQLException
	{
		int i;

		name = properName(name);

		for (i = 0; i < fName.length; i++)
			if (fName[i].equalsIgnoreCase(name))
				break;

		if (i >= fName.length)
		{
			currentMemoName = null;
			throw new SQLException("Couldn't find field name " + name);
		}

		return i;
	}

	/**
	* Derive a proper name from any old name that's passed.
	* DBase names are uppercase with a limit of 10 chars.
	*
	* @param field name.
	* @return proper field name.
	*/
	private String properName(String name)
	{
		String pName = name; // .toUpperCase();
		if (pName.length() > 10)
			pName = pName.substring(0, 10);

		return pName;
	}

	/**
	* Return string data from the field with the given name.
	*
	* @param name Field name.
	* @return field index.
	*/
	public String getString(String name) throws SQLException
	{
		return getString(findColumn(name));
	}

	/**
	* Return integer data from the field with the given name.
	*
	* @param name Field name.
	* @return integer value
	*/
	public int getInt(String name) throws SQLException
	{
		return getInt(findColumn(name));
	}

	/**
	* Return double data from the field with the given name.
	*
	* @param name Field name.
	* @return double value
	*/
	public double getDouble(String name) throws SQLException
	{
		return getDouble(findColumn(name));
	}

	/**
	* Return date data from the field with the given name.
	*
	* @param name Field name.
	* @return date string
	*/
	public Timestamp getDate(String name) throws SQLException
	{
		return getDate(findColumn(name));
	}

	/**
	* Return boolean data (as a char).
	*
	* @param name Field name.
	* @return one of 'F' false, 'T' true, '?' undefined.
	*/
	public char getBooleanChar(String name) throws SQLException
	{
		return getBooleanChar(findColumn(name));
	}

	/**
	* Return boolean data (as  a char)
	* @param idx Field index.
	* @return one of 'F' false, 'T' true, '?' undefined.
	*/
	public char getBooleanChar(int idx) throws SQLException
	{
		return getBooleanChar(idx);
	}

	/**
	* Get a boolean value.
	*
	* @param name Field name.
	* @return boolean or SQLException if undefined.
	*/
	public boolean getBoolean(String name) throws SQLException
	{
		return getBoolean(findColumn(name));
	}

	/**
	* Get a boolean value.
	*
	* @param idx Field index.
	* @return boolean or SQLException if undefined.
	*/
	public boolean getBoolean(int idx) throws SQLException
	{
		switch (record.getBooleanData(idx))
		{
			case 'T':
				return true;
			case 'F':
				return false;
			default:
				throw new SQLException("Boolean value undefined.");
		}
	}

	/**
	* Return string data from the field at the index.
	*
	* @param idx index of the field.
	* @return string value.
	*/
	public String getString(int idx) throws SQLException
	{
		return record.getCharData(idx);
	}

	/**
	* Return integer data from the field at the index.
	*
	* @param idx index of the field.
	* @return integer value.
	*/
	public int getInt(int idx) throws SQLException
	{
		return (int) record.getNumericData(idx);
	}

	/**
	* Return a double from the field at the index.
	*
	* @param idx index of the field.
	* @return double value.
	*/
	public double getDouble(int idx) throws SQLException
	{
		return record.getNumberData(idx);
	}

	/**
	* Return a Date from the field at the index.
	*
	* @param idx index of the field.
	* @return String value.
	*/
	public Timestamp getDate(int idx) throws SQLException
	{
		return record.getDateData(idx);
	}

	/**
	* Get binary data as bytes from a char or memo field.
	* This may be unreliable for memo fields since a zero byte value signals the end of
	* a memo field.  Actual zero bytes would have to be encoded somehow.
	*
	* @param fdidx Column index.
	* @return byte array.
	* @throws SQLException if the data type of the field isn't a type that can return bytes.
	*/
	public byte [] getBytes(int fdidx) throws SQLException
	{
		return record.getByteData(fdidx);
	}

	/**
	* Get binary data as bytes from a char or memo field.
	*
	* @param name Column name.
	* @return byte array.
	* @throws SQLException if the data type of the field isn't a type that can return bytes.
	*/
	public byte [] getBytes(String name) throws SQLException
	{
		return record.getByteData(findColumn(name));
	}

	/**
	* Display something about the DBase table.
	*
	* @return string describing the DBase class.
	*/
	public String toString()
	{
		String msg = "DBase: " + dbPath + ", ";

		if (tableName == null)
			return msg + "No open tables.";

		msg += "Table: " + tableName + '\n';
		msg += record.header.toString() + "\nFields:\n";

		for (int i = 0; i < record.fd.length; i++)
			msg += record.fd[i].toString() + '\n';

		return msg;
	}


	/**
	* Get an int from a byte.
	*
	* @return int.
	*/
	private int getByteLE(ByteIterator bi)
	{
		return (int) bi.readByte() & 0xff;
	}

	private int getShortLE(ByteIterator bi)
	{
		byte b[] = new byte[2];
		bi.read(b);
		return (((b[1])&0xff) << 8) | ((b[0])&0xff);
	}

	private int getIntLE(ByteIterator bi)
	{
		byte b[] = new byte[4];
		bi.read(b);

	 	return (b[3] << 24 ) | (((b[2])&0xff) << 16) | (((b[1])&0xff) << 8) | ((b[0])&0xff);
	}

	/**
	* Inner class to track field data.
	*/
	class FieldData
	{
		String name;	// Field name
		char type;		// Field type (M for memo)
		int position;		// Position within record
		int length;		// Field length
		int decimalCount;	// Decimal count

		public String toString()
		{
			String s;

			s = "Name=" + name;
			s += ", " + "Type=" + type;
			s += ", " + "length=" + length;
			s += ", " + "Position=" + position;
			s += ", " + "Decimals=" + decimalCount;

			return s;
		}
	}

	/**
	* Special form of search - get all undeleted records.
	*
	* @return a list of record numbers that matched.
	*/
	private long[] searchGetAll(String table) throws SQLException
	{
		LongList ll = new LongList();

		beforeFirst();
		while (next())
			ll.add(recnum);

		return ll.get();
	}

	/**
	* Search for the contents of a simple where clause.
	*
	* @param where Where class from the parser.
	*
	* @return a list of record numbers that matched.
	*/
	private long [] search(String table, Where where) throws SQLException
	{
		ArrayList foundList = new ArrayList();
		Object srch = null;

		// Ick!  It's a table scan!

		beforeFirst();

		// Get the index of the table column from the name.
		int idx = findColumn(where.field);
		char columnType = record.fd[idx].type;

		while (next())
		{
			switch (columnType)
			{
				case Record.MEMO:
					throw new SQLException("Can't search memo fields: " + where.field);

				case Record.CHAR:
					srch = record.getCharData(idx);
					break;

				case Record.NUMERIC:
				case Record.FLOATING:
					srch = new Double(record.getNumericData(idx));
					break;

				case Record.DATE:
					srch = record.getCharData(idx);
					break;

				case Record.LOGICAL:
					srch = new Boolean(record.getBooleanData(idx) == 'T');
					break;

				default:
					throw new SQLException("Searching for an unrecognized column type of " + columnType);
			}

			if (where.comparitor(srch))
			{
				foundList.add(new Long(recnum));
			}
		}

		foundList.trimToSize();
		long rLong[] = new long[foundList.size()];
		for (int i = 0; i < rLong.length; i++)
		{
			rLong[i] = ((Long)foundList.get(i)).longValue();
		}

		return rLong;
	}

	/**
	* Merge lists of results based on the conjunction of operations.
	*
	*/
	long [] mergeWhereLists(ArrayList rec, ArrayList whereList)
	{
		// Each rec list matches a where list entry.
		// Possible merges are OR and AND.
		// Currently all conjunctions are equal (no parenthesis binding any together).
		// Eg
		// a=x AND b=y OR b=z AND c=w
		// FIRSTNAME="Michael" OR FIRSTNAME="Mike" AND LASTNAME="Lecuyer"
		// Elements common to A and B are calculated.
		// Process all OR's, then the ANDS.  Then process the two resulting lists.
		// Progressively calculate these things.

		int i;
		int listCount = rec.size();	// Get the total number of lists to merge.
		if (listCount == 1)
			return (long [])rec.get(0);

		LongList  tmpList = new LongList();	// Temporary result list.
		long w1[], w2[];	// Temp  Where record lists.

		Where where1 = (Where)whereList.get(0);
		w1 = (long [])rec.get(0);

		for (i = 1; i < listCount; i++)
		{
			int j;
			Where where2 = (Where)whereList.get(i);
			w2 = (long [])rec.get(i);

			if (where2.conjunction == Where.CONJ_AND)
			{
				// And:  It must be in both lists.
				for (j = 0; j < w1.length; j++)
				{
					if (Arrays.binarySearch(w2, w1[j]) >= 0)
						tmpList.add(w1[j]);
				}
			} else {
				for (j = 0; j < w1.length; j++)
					tmpList.add(w1[j]);
				for (j = 0; j < w2.length; j++)
					tmpList.add(w2[j]);
			}

			where1 = where2;
			w1 = tmpList.get();
		}

		// Uniquely sort the list, there may be duplicates.
		tmpList.usort();
		long wl[] = tmpList.get();

		return wl;
	}

	/**
	* Inner class to handle records and their fields.
	*/
	class Record
	{
		static final char MEMO = 'M';		// Memo type field.
		static final char CHAR = 'C';		// Character field.
		static final char NUMERIC = 'N';	// Numeric
		static final char FLOATING = 'F';	// Floating point
		static final char DATE = 'D';		// Date
		static final char LOGICAL='L';	// Logical - ? Y y N n T t F f (? when not initialized).

		static final long BLOCKSIZE = 512;	// DBT block size.

		int recordSize;				// Length of each record.
		byte recordData[];			// Current record data.
		int currDataRecord;		// Current record data in memory.
		ByteIterator bi;				// Data locator.
		RandomAccessFile dbf;	// file with record data.
		RandomAccessFile dbt;	// file with memo data.
		FieldData fd[];				// Field data information.
		Header header;			// Header information
		RecordBuffer rBuf;			// Record data buffer.
		byte emptyBlock[];	// Empty block for reference when getting the memo field data.
		String tableName;		// Table name for the file.

		/**
		* Constructor to set up record size.
		*/
		Record(String table, RandomAccessFile dbf, RandomAccessFile dbt) throws SQLException
		{
			tableName = table;
			header = new Header(dbf);
			this.recordSize = header.getLength();
			fd = header.getFieldData();
			records = header.getCount();
			headerSize = header.getHeaderLength();

			currDataRecord = -1;
			this.dbf = dbf;
			this.dbt = dbt;
			this.fd = fd;
			recordData = new byte[recordSize];

			rBuf = new RecordBuffer(this.dbf, headerSize, recordSize);

			emptyBlock = new byte[(int) BLOCKSIZE];
		}

		/**
		* Return a record.
		*
		* @param recNum Record number.
		* @return true if the record is good, false if the record is deleted.
		*/
		 boolean getRecord(long recnum) throws SQLException
		{
			// If we already have the record don't return it again.
			if (recnum == currDataRecord)
				return true;

			rBuf.getRecord(recnum);
			bi = rBuf.getData(recnum);

			if (rBuf.isDeleted())
				return false;

			return true;
		}

		/**
		* Get the column count.
		*
		* @return column count
		*/
		public int getColumnCount()
		{
			return fd.length;
		}

		/**
		* Get the record count.
		*
		* @return record count
		*/
		public long getRecordCount()
		{
			return records;
		}

		/**
		* Get column names.
		*
		* @return array of column names.
		*/
		public String [] getColumnNames()
		{
			// This is an intersection of all column names and the columns
			String name[] = new String[fd.length];
			for (int i = 0; i < fd.length; i++)
				name[i] = fd[i].name;

			return name;
		}

		/**
		* Get column widths.
		*
		* @return array of column names.
		*/
		public int [] getColumnWidths()
		{
			int width[] = new int[fd.length];
			for (int i = 0; i < fd.length; i++)
			{
				if (fd[i].type == 'M')
					width[i] = 0xffff;
				else
					width[i] = fd[i].length;
			}

			return width;
		}

		/**
		* get column types.
		*
		* @return array of column types.
		*/
		public char[] getColumnTypes()
		{
			char type[] = new char[fd.length];
			for (int i = 0; i < fd.length; i++)
			{
				type[i] = fd[i].type;
			}

			return type;
		}

		/**
		* Retrieve the memo field from the database.
		*
		* @param fdidx Index to the FieldData array.
		* @return the memo data or null if something went wrong.
		* @throws SQLException if there's no memo file or the field doesn't contain memo data,
		* or the memo data block doesn't exist.
		*/
		private byte [] getMemoData(int fdidx) throws SQLException
		{
			memo = null;	// Invalidate memo data.

			// See if we're expecting memo fields.
			if (dbt == null)
				throw new SQLException("Memo field doesn't exist - .dbt file missing.");

			FieldData fdd = fd[fdidx];
			if (fdd.type != MEMO)
				throw new SQLException("Field " + fdidx + " is not a MEMO.");

			byte info[] = getDataValue(fdd);
			String blockValue = new String(info).trim();

			if (blockValue.equals(""))
				return new byte[0];	// No memo data.

			long block = 0;
			try {
				block = Long.parseLong(blockValue);
			} catch (NumberFormatException nfe) {
				throw new SQLException("GetMemo.getFieldData: The block number [" + block + "] is not a number.");
			}

			memo = memoHandler.getMemoData(dbt, block);
			if (memo == null)
				return null;
			byte b[] = memo.toByteArray();

			return b;
		}

		/**
		* Write a memo.
		* @param buf data to write.
		* @return the block number where the memo starts.
		*/
		int writeMemoData(byte buf[]) throws SQLException
		{
			return memoHandler.writeMemoData(dbt, buf, tableName);
		}

		/**
		* Get a NUMERIC datum.
		*
		* @param fdidx Field index.
		* @return double number
		*/
		public double getNumericData(int fdidx) throws SQLException
		{
			return getNumberData(fdidx);
		}

		/**
		* Get a FLOATING datum.
		*
		* @param fdidx Field index.
		* @return double number
		*/
		public double getFloatingData(int fdidx) throws SQLException
		{
			return getNumberData(fdidx);
		}

		/**
		* Get a number type datum.
		*
		* @param fdidx Field index.
		* @param char Type of data.
		* @return floating point number
		*/
		public double getNumberData(int fdidx) throws SQLException
		{
			FieldData fdd = fd[fdidx];
			if (fdd.type != NUMERIC && fdd.type != FLOATING)
				throw new SQLException("Field " + fdidx + " is not a number.");

			// BCD representation.
			// 1 2 9 = 0001 0010 1001.
			// Convert to string inserting decimal point using java.text.NumberFormat.
			// Use field length, and field decimal length.
			// Get data area.
			int idx = 0;
			byte da[] = getDataValue(fdd);
			String number = new String(da).trim();
			if (number.equals(""))
				return 0.0;
			double v = Double.parseDouble(number);
			return v;
		}

		/**
		* Get Character datum.
		*
		* @param fdidx Field index.
		* @return String
		*/
		public String getCharData(int fdidx) throws SQLException
		{
			FieldData fdd = fd[fdidx];

			switch (fdd.type)
			{
				case CHAR:
					byte b[] = getDataValue(fdd);
					return new String(b).trim();

				case DATE:
					Timestamp tts = record.getDateData(fdidx);
					return tts == null ? null : tts.toString();

				case MEMO:
					record.getMemoData(fdidx);
					if (memo == null)
						return null;
					return memo.toString();

				case FLOATING:
				case NUMERIC:
					return "" + record.getNumberData(fdidx);

				case LOGICAL:
					char bd = record.getBooleanData(fdidx);
					if (bd == 'T')
						return "true";
					else if (bd == 'F')
						return "false";
					else
						return "Undefined";

				default:
					throw new SQLException("Field " +  fdidx + " can't be converted to a string. " + this);
			}
		}

		/**
		* get logical data.
		*
		* @return 'T' for true, 'F' for false, and '?' for undefined.
		*/
		public char getBooleanData(int fdidx) throws SQLException
		{
			FieldData fdd = fd[fdidx];
			if (fdd.type != LOGICAL)
				throw new SQLException("Field " + fdidx + " is not a LOGICAL field.");

			byte da[] = getDataValue(fdd);
			char logical = (char)da[0];

			// One of ? Y y N n T t F f , ? when undefined
			switch (logical)
			{
				case 'Y':
				case 'y':
				case 'T':
				case 't':
					return 'T';

				case 'N':
				case 'n':
				case 'F':
				case 'f':
					return 'F';

				default:
					return '?';
			}
		}

		/**
		* Get a DATE datum.
		*
		* @param fdidx Field index.
		* @return String or null if no valid time value.
		*/
		public Timestamp getDateData(int fdidx) throws SQLException
		{
			FieldData fdd = fd[fdidx];
			if (fdd.type != DATE)
				throw new SQLException("Field " + fdidx + " is not a DATE.");

			// Eight digits describing YYYYMMDD
			byte da[] = getDataValue(fdd);
			String b = new String(da);
			// Convert to a Timestamp.
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
			java.util.Date dt = sdf.parse(b.toString(), new ParsePosition(0));
			if (dt == null)
				return null;

			return new Timestamp(dt.getTime());
		}

		/**
		* Get the data value from the record.
		*
		* @param fdd FieldData value
		* @return byte array of raw data.
		*/
		byte [] getDataValue(FieldData fdd)
		{
			bi.first();
			bi.skipBytes(fdd.position);
			byte info[] = new byte[fdd.length];
			bi.read(info);
			return info;
		}

		/**
		* Get binary data as bytes from a char or memo field.
		*
		* @param fdidx Field index.
		* @return byte array or null if there's no data.
		* @throws SQLException if the data type of the field isn't a type that can return bytes.
		*/
		byte [] getByteData(int fdidx) throws SQLException
		{
			FieldData fdd = fd[fdidx];
			switch (fdd.type)
			{
				case CHAR:
					return record.getDataValue(fdd);

				case MEMO:
					return record.getMemoData(fdidx);

				default:
					throw new SQLException("Cannot return byte data for this field type.");
			}
		}

		/**
		* Put a data field into a buffer.
		*
		* @param fdidx Field index.
		* @param buf Data buffer with data.
		*/
		void putField(int fdidx, byte buf[]) throws SQLException
		{
			FieldData fdd = fd[fdidx];

			// If it's a memo field we'll try to write it out.
			if (fdd.type == 'M')
			{
				// If there's no data the memo data field will be filled with blanks
				// automatically if we do nothing.
				if (buf.length > 0)
				{
					// The block number returned is going to be the data in the memo field.
					// It's an ASCII number.
					int blockNum = writeMemoData(buf);
					buf = ("" + blockNum).getBytes();
				}
			}

			// If the ByteIterator is null or wrong, create a new one with a buffer the length
			// of the record.  This is for inserts.
			// Otherwise we read a record and so should only update those fields being altered.
			bi.first();
			bi.skipBytes(fdd.position);

			// Make sure we offer clean data of the right length to the field.
			// It must be no longer than can fit and old data in the buffer must be completely
			// overwritten.
			byte b[] = new byte[fdd.length];

			int clen = (buf.length > fdd.length) ? fdd.length : buf.length;
			System.arraycopy(buf, 0, b, 0, clen);
			bi.write(b, 0, fdd.length);
		}

		/**
		* Create a buffer for this record, properly filled out with nothing.
		*
		*/
		void createRecordBuffer()
		{
			byte buf[] = new byte[recordSize - 1];	// This version of the record doesn't include the deleted marker.
			Arrays.fill(buf, (byte)' ');	// Fill the record with spaces, as it likes to appear.
			bi = new ByteIterator(buf);
		}

		/**
		* Delete a record.
		*
		* @param recnum Record number to delete.
		*/
		void deleteRecord(long recnum) throws SQLException
		{
			// Write the data.
			rBuf.putRecData(true, recnum, bi.getBuffer());
			// Clear the cache.
			rBuf.clearCache();
		}

		/**
		* Write a record out to the database.
		*
		* @param recnum Record number to write.
		*/
		void writeRecord(long recnum) throws SQLException
		{
			// Write the data.
			rBuf.putRecData(false, recnum, bi.getBuffer());
			// Clear the cache.
			rBuf.clearCache();
		}

		/**
		* Append a new record out to the database.
		*
		* @param recnum Record number to write.
		*/
		void appendRecord() throws SQLException
		{
			// Write the data.
			rBuf.addRecData(bi.getBuffer());
			// Clear the cache.
			rBuf.clearCache();
		}

		/**
		* Produce a string interpretation of this object.
		*
		* @return string.
		*/
		public String toString()
		{
			StringBuffer sb = new StringBuffer();
			sb.append("Record: ");
			sb.append("Size = ").append(recordSize);
			sb.append(", Field Count = ").append(fd.length);
			sb.append(", Current Record = ").append(currDataRecord);
			sb.append('\n');
			for (int i = 0; i < fd.length; i++)
				sb.append("Field[").append(i).append("] ").append(fd[i]).append('\n');

			return sb.toString();
		}

	}

	/**
	* Inner class to hold table header information.
	*/
	class Header
	{
		RandomAccessFile dbf;	// Table file
		FieldData fd[];				// Field data.
		long recordCount;			// Total record count.
		int recordSize;				// Length of each record.
		int headerSize;				// Size of field header;

		Header(RandomAccessFile dbf) throws SQLException
		{
			this.dbf = dbf;
			readHeader();
		}

		/**
		* Get the FieldData array of found fields.
		*
		*@return array of FieldData information.
		*/
		FieldData [] getFieldData()
		{
			return fd;
		}

		/**
		* Get the record length.
		*
		* @return record length.
		*/
		int getLength()
		{
			return recordSize;
		}

		/**
		* Get the header size.
		*
		* @return headerlength.
		*/
		int getHeaderLength()
		{
			return headerSize;
		}

		/**
		* Get the record count.
		*
		* @return count.
		*/
		long getCount()
		{
			return recordCount;
		}

		private void readHeader() throws SQLException
		{
			try {
				byte b[] = new byte[32];

				dbf.seek(0L);
				dbf.read(b);

				ByteIterator bi = new ByteIterator(b);
				byte flag = bi.readByte();
				byte modBytes[] = new byte[3];
 				bi.read(modBytes);

				recordCount = (long) getIntLE(bi);
				headerSize =getShortLE(bi);
				recordSize = getShortLE(bi);

				int fieldCount = (headerSize - 32) / 32;
				fd = new FieldData[fieldCount];
				int fieldposn = 0;

				for (int i = 0; i < fieldCount; i++)
				{
					String fieldName = null;

					dbf.read(b);
					bi = new ByteIterator(b);

					byte fieldNameBytes [] = new byte[11];
					bi.read(fieldNameBytes);
					for (int nz = 0; nz < fieldNameBytes.length; nz++)
						if (fieldNameBytes[nz] == 0)
						{
							fieldName = new String(fieldNameBytes, 0, nz);
							break;
						}
					char type = (char)bi.readByte();
					bi.skipBytes(4);

					FieldData fdd = new FieldData();
					fdd.type = type;
					fdd.name = fieldName;
					fdd.position = fieldposn;
					fdd.length = getByteLE(bi);
					fdd.decimalCount = getByteLE(bi);
					fd[i] = fdd;

					fieldposn  += fdd.length;
				}

			} catch (IOException ioe) {
				throw new SQLException(getStackTrace(ioe));
			}
		}

		public String toString()
		{
			StringBuffer sb = new StringBuffer();

			sb.append("Header: ");
			sb.append("Header Size = ").append(headerSize);
			sb.append(", Record Size = ").append(recordSize);
			sb.append(", Record Count = ").append(recordCount);
			sb.append(", Field Count = ").append(fd.length);

			return sb.toString();
		}

	}

	/**
	* Caching for the record reader, should be especially good for sequential reads.
	* Sadly, In fact, it's not much faster than regular reads, probably because the RandomAccessFile
	* buffers do well enough.
	*/
	class RecordBuffer
	{
		final int RECORDS = 100;	// Number of records cached in memory at one time.

		RandomAccessFile dbf;
		int headerSize;
		byte buffer[];				// Buffer to hold records
		int recordSize;				// Size of each record.
		long currentRec = -1;		// Number of the first record in buffer.
		boolean isDeleted;			// Set true when a record is deleted.
		int hits = 0;					// Cache hits.
		int misses = 0;				// Cache misses.

		/**
		* Constructor to create the database record buffer.
		*
		* @param dbf File to read.
		* @param headerSize Size of the table header.
		* @param recordSize Size of each record.
		*/
		RecordBuffer(RandomAccessFile dbf, int headerSize, int recordSize)  throws SQLException
		{
			this.dbf = dbf;
			this.headerSize = headerSize;
			this.recordSize = recordSize;
			buffer = new byte[recordSize * RECORDS];
			getRecData(0L);	// Get first record data.
		}

		/**
		* Clear the cache.
		* Used if we wrote something and the cache may be corrupted.
		*/
		void clearCache() throws SQLException
		{
			currentRec = -1;
			getRecData(0L);
		}

		/**
		* Collect record data.
		* This performs the buffering, not picking up necessary data.
		*
		* @param recnum Record number.
		*/
		void getRecord(long recnum) throws SQLException
		{
			if (recnum >= currentRec && recnum < currentRec + RECORDS)
			{
				hits++;	// Hit the cache!
				return;
			} else {
				misses++;	// Missed the cache.
				getRecData(recnum);
				getRecord(recnum);
			}
		}

		/**
		* Is the record deleted?
		*
		* Return true if the current record has been deleted.
		*/
		boolean isDeleted()
		{
			return isDeleted;
		}


		/**
		* Return the record data for the particular record.
		*
		* @param recnum Record number.
		* @return Iterator to the data.
		*/
		ByteIterator getData(long recnum)
		{
			int bufpos = recordSize * (int)(recnum - currentRec);
			isDeleted = (int)buffer[bufpos] == 0x2A;

			// If the data isn't deleted grab it.  Otherwise don't waste our time.
			if (!isDeleted)
				return new ByteIterator(buffer, bufpos + 1, recordSize - 1);

			return null;
		}

		/**
		* Read data into the buffer.
		*
		* @param recnum Record number.
		*/
		private void getRecData(long recnum) throws SQLException
		{
			currentRec = recnum;
			try {
				// Seek to the record in the file.
				long posn = (long)headerSize + (long)recordSize * recnum;
				dbf.seek(posn);
				dbf.read(buffer);
			} catch (IOException ioe) {
				throw new SQLException("File read error: " + ioe);
			}
		}

		/**
		* Write record data.
		*
		* @param delete If true delete the record.
		* @param recnum Record number.
		* @param buffer Buffer to write.
		*/
		private void putRecData(boolean delete, long recnum, byte buffer[]) throws SQLException
		{
			try {
				// Seek to the record in the file.
				long posn = (long)headerSize + (long)recordSize * recnum;
				dbf.seek(posn);
				// Write out the marker that says this record is ok.
				if (delete)
					dbf.write(0x2A);
				else {
					dbf.write(0x20);
					dbf.write(buffer);
				}
			} catch (IOException ioe) {
				throw new SQLException("File write error: " + ioe);
			}
		}

		/**
		* Append record data to the end of the file.
		*
		* @param recnum Record number.
		* @param buffer Buffer to write.
		*/
		private void addRecData(byte buffer[]) throws SQLException
		{
			try {
				// Seek to end of the file minus one byte (EOF marker).
				// Really we SHOULD be seeking to the number of records * record size
				// In case something died before the record count could be updated, but a record was written,
				// or partially written.  We could do this by rearranging the order of the operations.

				// Get the latest idea of the number of records from the file.
				dbf.seek(4L);
				int recs = Intel.readShort(dbf);

				// Seek to the end of the file + the length of the header.
				long newRecordPosn = recordSize * (long)recs + headerSize;
				dbf.seek(newRecordPosn);
				// Write out the marker for our record, the record data, and the EOF.
				dbf.write(0x20);
				dbf.write(buffer);
				dbf.write(0x1A);	// End of file marker.

				// Update the record count in the header.
				dbf.seek(4L);
				Intel.writeShort(dbf, ++recs);

			} catch (IOException ioe) {
				throw new SQLException("File write error: " + ioe);
			}
		}

		/**
		* Return a string representation of this object.
		* Returns hits and misses of the buffer.
		*
		* @return string.
		*/
		public String toString()
		{
			StringBuffer sb = new StringBuffer();

			sb.append("RecordBuffer: " );
			sb.append("hits = ").append(hits);
			sb.append(", misses = ").append(misses);

			return sb.toString();
		}

	}

	/**
	* Stripped down ByteIterator class.
	*/
	class ByteIterator
	{
		private byte array[];
		private int current;	// current position in byte array

		/**
		* Construct to set up the byte iterations.
		*
		* @param d Data <code>byte</code> array to use.
		*/
		ByteIterator(byte d[])
		{
			array = d;
			current = 0;
		}

		/**
		* Create a new buffer from a portion of a data buffer.
		* References to the new buffer are zero based.
		*
		* @param data Data <code>byte</code> array to use.
		* @param start Index of the first <code>byte</code>
		* @param length  length to use
		*
		* @see #getBuffer
		*/
		ByteIterator(byte d[], int start, int length)
		{
			array = new byte[length];
			System.arraycopy(d, start, array, 0, length);
			current = 0;
		}

		/**
		* Returns the next <code>byte</code>.
		* Advances the buffer position.
		*
		* @return the <code>byte</code> value.
		*/
		byte readByte()
		{
			byte i = nextByte();
			moveByte();
			return i;
		}

		/**
		* Return the next <code>byte</code>.
		* Does not advance the buffer position.
		*
		* @return the next <code>byte</code> value
		*/
		byte nextByte()
		{
			return array[current];
		}

		/**
		* Advance in the array by one byte
		*/
		void moveByte()
		{
			if (current + 1 <= array.length)
				current++;
		}

		/**
		* Read a buffer full of bytes.  If there are not enough bytes in
		* the ByteIterator the buffer will not be filled.
		* <P>
		* Advances the buffer position by the number of bytes read.
		*
		* @param b buffer to fill.
		*
		* @return number of bytes read.
		*/
		int read(byte b[])
		{
			return read(b, 0, b.length);
		}

		/**
		* Read bytes into a buffer.  If there are not enough bytes in
		* the ByteIterator the requested number of bytes will not be filled.
		* <P>
		* Advances the buffer position by the number of bytes read.
		*
		* @param b buffer to fill.
		* @param offset position in the buffer to start filling.
		* @param count number of bytes to read.
		*
		* @return number of bytes read.
		*/
		int read(byte b[], int offset, int count)
		{
			if (offset + count > b.length)
				count = b.length - offset;

			if (count > array.length - current)
				count = array.length - current;

			if (count <= 0)
				return 0;

			System.arraycopy(array, current, b, offset, count);
			move(count);
			return count;
		}

		/**
		* Returns the first byte of buffer in the data.
		* Sets the current position to zero.
		*
		* @return <code>byte</code>
		*/
		byte first()
		{
			current = 0;
			return array[0];
		}

		/**
		* Skips over bytes.
		* Advances the buffer position.
		*
		* @param count bytes to skip.
		*/
		void skipBytes(int count)
		{
			move(count);
		}

		/**
		* Move current position by an arbitrary number of bytes.
		* If the position exceeds the length, the position is not changed
		*
		* @param count Number of byte to advance
		*/
		void move(int count)
		{
			if (current + count <= array.length)
				current += count;
		}

		/**
		* Write a <code>byte</code> array to the buffer at the current position.
		* <P>
		* Advances the buffer position by the number of bytes written.
		*
		* @param b buffer to write.
		* @param start Start position in buffer.
		* @param length Length of buffer to write.
		* @return amount written or -1 if it doesn't fit in the ByteIterator buffer.
		*/
		public int write(byte b[], int start, int length)
		{
			int blen = b.length;
			if (current + blen > array.length)
				return -1;	// Failed to write.

			System.arraycopy(b, start, array, current, length);
			move(blen);

			return blen;
		}

		/**
		* Return the current data buffer.
		* Useful if you need to retrieve the copied data buffer.
		*
		* @return work buffer
		*/
		public byte [] getBuffer()
		{
			return array;
		}

		/**
		* Dump part of the byte buffer.
		* This is done in the customary way, suitable for framing or wrapping fish.
		* <PRE>
		* 6D 69 73 63 3B 0D 0A 0D - 0A 69 6D 70 6F 72 74 20   misc;... - .import
		* </PRE>
		* Does not advance the buffer position.
		*
		* @param start start position
		* @param length length to dump
		*
		* @return <code>String</code> containing the String representation of the dump.
		*/
		public String dump(int start, int length)
		{
			StringBuffer sb = new StringBuffer();
			int origPosn = current;	// remember original position.
			int here;	// where we are.

			byte b1[] = new byte[8];
			byte b2[] = new byte[8];

			// dump in 16 byte chunks, hex on the left, printables on the right.

			int end = length + start;
			for (here = start; here < end; here += 16)
			{
				int j, br;

				br = read(b1, 0, 8);
				if (br == 8)
				{
					// If we read enough fill the other buffer
					br = read(b2, 0, 8);
					for (j = br; j < 8; j++)
						b2[j] = 0;
				}
				else
				{
					// If too few bytes were read, clear the end of b1 and all of b2
					for (j = 0; j < 8 ; j++)
					{
						if (j >= br) b1[j] = 0;
						b2[j] = 0;
					}
				}

				// write the hex representation.
				sb.append(hexString(b1)).append("- ");
				sb.append(hexString(b2)).append("  ");

				for (j = 0; j < 8; j++)
					if (Ctype.isprint(b1[j]))
					{
						if (Ctype.isspace(b1[j]))
							sb.append(' ');
						else
							 sb.append((char)b1[j]);
					}
					else
						 sb.append('.');

				sb.append(" - ");	// Add a '-' to the byte display as well.

				for (j = 0; j < 8; j++)
					if (Ctype.isprint(b2[j]))
					{
						if (Ctype.isspace(b2[j]))
							sb.append(' ');
						else
							 sb.append((char)b2[j]);
					}
					else
						 sb.append('.');

				sb.append('\n');
			}
			current = origPosn;	// restore starting position.

			return sb.toString();
		}

		// Belongs with hexString().
		private final String hex = "0123456789ABCDEF";
		/**
		* Convert bytes into a hex string.
		* @return string or null if the byte array is null.
		*/
		private String hexString(byte [] vb)
		{
			if (vb == null)
				return null;

			StringBuffer sb = new StringBuffer();

			for (int j = 0; j < vb.length; j++)
			{
				sb.append(hex.charAt((int)(vb[j] >> 4) & 0xf));
				sb.append(hex.charAt((int)(vb[j]) & 0xf));
				sb.append(' ');
			}

			return sb.toString();
		}

	}

// This stuff should go further up into the main part of Dbase.
	/**
	* Build an index for a particular table and field.
	*/
	void buildIndex(String table)
	{

	}

	/**
	* Record position class.
	* This holds both the field value for the record and the record's position in the file.
	* It also implements it's own comparator.
	*/
	class RecordIndex implements Comparator
	{
		String fieldValue;
		long posn;

		public int compare(Object a, Object b)
		{
			long ret = ((RecordIndex)a).posn - ((RecordIndex)b).posn;

			if (ret < 0)
				return -1;
			else if (ret == 0)
				return 0;
			return 1;
		}

		public boolean equals(Object a, Object b)
		{
			return ((RecordIndex)a).posn == ((RecordIndex)b).posn;
		}
	}

	/**
	* Build a stack trace from an exception.
	* This will be used to specifically locate an exception with a pseudo
	* 'caused by' notion made popular in Java 1.4.
	* It will display the true line number of originating exception and
	* place it in the message portion of the exception.
	* @param e Exception
	* @return string version of exception including stack trace.
	*/
	protected static String getStackTrace(Exception e)
	{
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		PrintStream ps = new PrintStream(baos, true);
		e.printStackTrace(ps);
		return baos.toString();
	}

}