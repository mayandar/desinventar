package org.lared.desinventar.dbase;

import java.util.*;
import java.sql.*;

/**
* Class to hold information for a sql statement as found by the parser.
*/
public class SQLStatement
{
	/**
	 *Select statement.
	 */
	public static final int STATEMENT_SELECT = 0;

	/**
	* Update statement.
	*/
	public static final int STATEMENT_UPDATE = 1;

	/**
	* Insert statement.
	*/
	public static final int STATEMENT_INSERT = 2;
	
	/**
	* Delete statement.
	*/
	public static final int STATEMENT_DELETE = 3;

	public int type;		// Type of statement.
	public String sqlSource;	// Original sql statement text.
	public PairList fieldValue;	// Pair lists for updates.

	public ArrayList fields;		// List for fields from insert.
	ArrayList values;	// List for values from insert.

	public ArrayList tableName;	// Table name list.

	public ArrayList whereList;	// List of where conditions.

	public SQLStatement()
	{
		fields = new ArrayList();
		values = new ArrayList();
		tableName = new ArrayList();
		whereList = new ArrayList();
	}

	/**
	* Complete the statement tidying things up.
	*/
	public void complete() throws SQLException
	{
		int i;
		fieldValue = new PairList();
		fields.trimToSize();
		values.trimToSize();

		// Modify the fields and values into a pair list for certain statements.
		if (type == STATEMENT_UPDATE || type == STATEMENT_INSERT)
		{
			if (fields.size() != values.size())
				throw new SQLException("Mismatched field & value count: Fields = " + fields.size() + " values = " + values.size());

			int flen = fields.size();
			for (i = 0; i < flen; i++)
				fieldValue.add(fields.get(i), values.get(i));
			fields = null;
			values = null;
		}
	}

	public String toString()
	{
		int i;
		StringBuffer sb = new StringBuffer();
		
		tableName.trimToSize();
		sb.append("Tables:\n");
		for (i = 0; i < tableName.size(); i++)
			sb.append("  ").append(tableName.get(i)).append('\n');
	
		// If the PairList has been created list it.
		if (fieldValue.size() > 0)
		{
			sb.append(fieldValue);
			
		} else {
			fields.trimToSize();
			sb.append("Fields:\n");
			for (i = 0; i < fields.size(); i++)
				sb.append("  ").append(fields.get(i)).append('\n');
			
			fields.trimToSize();
			sb.append("Values:\n");
			for (i = 0; i < values.size(); i++)
				sb.append("  ").append(values.get(i)).append('\n');
		}
			
		whereList.trimToSize();
		if (whereList.size() == 0)
			sb.append("No Where Clause\n");
		else {
			sb.append("Where Clause:\n");
			for (i = 0; i < whereList.size(); i++)
				sb.append(whereList.get(i)).append('\n');
		}
		
		return sb.toString();
	}
}