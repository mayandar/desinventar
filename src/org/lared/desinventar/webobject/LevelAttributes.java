//PACKAGE NAME
package org.lared.desinventar.webobject;

import java.io.*;
import java.util.*;
import java.sql.*;
import java.math.*;
import java.text.*;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;


//CLASS NAME
// generated by WebObjectGenerator...
public class LevelAttributes extends webObject
{

	// DATA MEMBERS OF THE CLASS. THEY ARE EXACT MAPPING OF DB. RECORD.
	public 	int      table_level;
	public 	String table_name;
	public 	String table_code;

	//--------------------------------------------------------------------------------
	// creates a hash table with field values of the data members
	//--------------------------------------------------------------------------------

	public void updateHashTable() {
		// FIELD NAMES VECTOR
		asFieldNames.put("table_level", String.valueOf(table_level));
		asFieldNames.put("table_name", table_name);
		asFieldNames.put("table_code", table_code);

	}

	//--------------------------------------------------------------------------------
	// update data members with values stored in hash table
	//--------------------------------------------------------------------------------

	public void updateMembersFromHashTable() {
		// REVERSE FIELD NAMES VECTOR
		setTable_level((String)asFieldNames.get("table_level"));
		setTable_name((String)asFieldNames.get("table_name"));
		setTable_code((String)asFieldNames.get("table_code"));

	}
	//--------------------------------------------------------------------------------
	// constructor of the class. it initializes the object variables
	//--------------------------------------------------------------------------------

	// CONSTRUCTOR
	public void init() {
		lastError="No errors detected";
		fieldNullState.put("table_level", new Boolean(true));
		table_level = 0;
		table_name = "";
		table_code = "";
		updateHashTable();
	}

	public LevelAttributes() {
		super("LevelAttributes object");
		init();
	}
//--------------------------------------------------------------------------------
// getter and setter methods of the elements of the class
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
// Access methods for database field 'table_level'
	public String getTable_level() {
		return Integer.toString(table_level);
	}

	public void setTable_level(String sParameter) {
		table_level = extendedParseInt(sParameter);
		if (not_null(sParameter).length()>0) {
			fieldNullState.put("table_level", false);
		}
	}

	public void setTable_level(int sParameter) {
		table_level = sParameter;
		fieldNullState.put("table_level", false);
	}
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
// Access methods for database field 'table_name'
	public String getTable_name() {
		return table_name;
	}

	public void setTable_name(String sParameter) {
		table_name = sParameter;
	}
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
// Access methods for database field 'table_code'
	public String getTable_code() {
		return table_code;
	}

	public void setTable_code(String sParameter) {
		table_code = sParameter;
	}
//--------------------------------------------------------------------------------


	//----------------------------------------------------------------
	// Operational methods any webObject must have. Abstract class
	// provides templates and default behaviour (return error)
	//----------------------------------------------------------------

	//--------------------------------------------------------------------------------
	// retrieves object info from HTML form fields
	//--------------------------------------------------------------------------------
	public int getForm(HttpServletRequest req, HttpServletResponse resp, Connection con) {

		// GET_FORM()
		setTable_level(req.getParameter(assignName("table_level")));
		setTable_name(not_null_safe(req.getParameter(assignName("table_name"))));
		setTable_code(not_null_safe(req.getParameter(assignName("table_code"))));

		
		updateHashTable();
		return 0;
	}

	//--------------------------------------------------------------------------------
	// loads an object from a record read from database
	//--------------------------------------------------------------------------------
	public void loadWebObject(ResultSet rset) {
		try {
			// SQL_LOAD

			try {
				table_level = rset.getInt("table_level");

				fieldNullState.put("table_level", new Boolean(rset.wasNull()));
			} catch (Exception ex) {
				lastError = "<-- error attempting to access field table_level -->";
				System.out.println(ex.toString());
			}

			try {
				table_name = not_null(rset.getString("table_name"));

			} catch (Exception ex) {
				lastError = "<-- error attempting to access field table_name -->";
				System.out.println(ex.toString());
			}

			try {
				table_code = not_null(rset.getString("table_code"));

			} catch (Exception ex) {
				lastError = "<-- error attempting to access field table_code -->";
				System.out.println(ex.toString());
			}

		} catch (Exception e) {
			lastError = "<!-- Error loading WebObject: " + e.toString() + " : " + sSql + " -->";
		}
		updateHashTable();
	}

	//--------------------------------------------------------------------------------
	// reads an object from the database
	//--------------------------------------------------------------------------------
	public int getWebObject(Connection con) {
		try {		
			// SQL_GET
			int f=1;
			sSql = "SELECT * FROM level_attributes";
			sSql += " WHERE (table_level = ?)";
			pstmt = con.prepareStatement(sSql);

			if (table_level==0 && (Boolean)fieldNullState.get("table_level"))
				pstmt.setNull(f++, java.sql.Types.INTEGER);
			else
				pstmt.setInt(f++, table_level);


			rset = pstmt.executeQuery();
			int nrows = 1;
			if (rset.next()) {
				loadWebObject(rset);
			}
			else {
				nrows = 0;
			}
			
			// releases the statement object
			pstmt.close();
			lastError = ""; // "NO ERROR. sql="+sSql;
			return nrows;
		} catch (Exception ex) {
			//Trap and report SQL errors
			lastError = "<!-- Error getting webObject: " + ex.toString() + " : " + sSql
					+ " -->";
		}

		return -1;
	}

	//--------------------------------------------------------------------------------
	// adds a new object to the database
	//--------------------------------------------------------------------------------
  public int addWebObject(Connection con)
    {
		try {
			// SQL_INSERT
			int f=1;
			sSql = "insert into level_attributes (";
			sSql += "table_level, table_name, table_code)";
			sSql += "VALUES (?, ?, ?)";
			pstmt = con.prepareStatement(sSql);

			if (table_level==0 && (Boolean)fieldNullState.get("table_level")) 
				pstmt.setNull(f++, java.sql.Types.INTEGER);
			else
				pstmt.setInt(f++, table_level);
			if (table_name==null || table_name.length()==0)
				pstmt.setNull(f++, java.sql.Types.VARCHAR);
			else
				pstmt.setString(f++, table_name);
			if (table_code==null || table_code.length()==0)
				pstmt.setNull(f++, java.sql.Types.VARCHAR);
			else
				pstmt.setString(f++, table_code);


			int nrows = pstmt.executeUpdate();
			
			// releases the statement object
			pstmt.close();
			lastError = ""; // "NO ERROR. sql="+sSql;
			return nrows;
		} catch (Exception ex) {
			//Trap and report SQL errors
			System.out.println("ERROR (adding web object): "+ex.toString());
			lastError = "<!-- Error adding webObject: " + ex.toString() + " : " + sSql + " -->";
			return -1;
		}
	}

	//--------------------------------------------------------------------------------
	// updates an existing object in the database
	//--------------------------------------------------------------------------------
  public int updateWebObject(Connection con)
    {
		try {
			// SQL_UPDATE
			int f=1;
			sSql = "UPDATE level_attributes SET ";
			sSql += "table_name = ?";
			sSql += ", table_code = ?";
			sSql += " WHERE (table_level = ?)";
			pstmt = con.prepareStatement(sSql);

			if (table_name==null || table_name.length()==0)
				pstmt.setNull(f++, java.sql.Types.VARCHAR);
			else 
				pstmt.setString(f++, table_name);
			if (table_code==null || table_code.length()==0)
				pstmt.setNull(f++, java.sql.Types.VARCHAR);
			else 
				pstmt.setString(f++, table_code);


			if (table_level==0 && (Boolean)fieldNullState.get("table_level"))
				pstmt.setNull(f++, java.sql.Types.INTEGER);
			else
				pstmt.setInt(f++, table_level);


			int nrows = pstmt.executeUpdate();
			// releases the statement object
			pstmt.close();
			lastError = ""; // "NO ERROR. sql="+sSql;
			return nrows;
		} catch (Exception ex) {
			//Trap and report SQL errors
			lastError = "<!-- Error updating webObject: " + ex.toString() + " : " + sSql + " -->";
		}

		return -1;
	}

	//-------------------------------------------------------------------------------
	// deletes an existing object in the database
	//--------------------------------------------------------------------------------
	public int deleteWebObject(Connection con) {

		try {
			// SQL_DELETE
			int f=1;
			sSql = "DELETE FROM level_attributes";
			sSql += " WHERE (table_level = ?)";
			pstmt = con.prepareStatement(sSql);

			if (table_level==0 && (Boolean)fieldNullState.get("table_level"))
				pstmt.setNull(f++, java.sql.Types.INTEGER);
			else
				pstmt.setInt(f++, table_level);


			int nrows = pstmt.executeUpdate();
			// releases the statement object
			pstmt.close();
			lastError = ""; // "NO ERROR. sql="+sSql;
			return nrows;
		} catch (Exception ex) {
			//Trap and report SQL errors
			lastError = "<!-- Error deleting webObject: " + ex.toString() + " : " + sSql + " -->";
		}
		return -1;
	}
}

/*    HTML TEMPLATE
<table border=0 cellspacing=0 cellpadding=0>
<tr><td>table_level:</td><td>  <INPUT type='TEXT' size='5' maxlength='22' name='table_level' VALUE="<%=beanName.table_level%>"></td></tr>
<tr><td>table_name:</td><td>  <INPUT type='TEXT' size='50' maxlength='50' name='table_name' VALUE="<%=beanName.table_name%>"></td></tr>
<tr><td>table_code:</td><td>  <INPUT type='TEXT' size='50' maxlength='50' name='table_code' VALUE="<%=beanName.table_code%>"></td></tr>
</table>
END HTML TEMPLATE */
