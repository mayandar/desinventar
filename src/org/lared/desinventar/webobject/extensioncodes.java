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
public class extensioncodes extends webObject
{

	// DATA MEMBERS OF THE CLASS. THEY ARE EXACT MAPPING OF DB. RECORD.
	public 	int      nsort;
	public 	String svalue;
	public 	String svalue_en;
	public 	String field_name;
	public 	String code_value;

	//--------------------------------------------------------------------------------
	// creates a hash table with field values of the data members
	//--------------------------------------------------------------------------------

	public void updateHashTable() {
		// FIELD NAMES VECTOR
		asFieldNames.put("nsort", String.valueOf(nsort));
		asFieldNames.put("svalue", svalue);
		asFieldNames.put("svalue_en", svalue_en);
		asFieldNames.put("field_name", field_name);
		asFieldNames.put("code_value", code_value);

	}

	//--------------------------------------------------------------------------------
	// update data members with values stored in hash table
	//--------------------------------------------------------------------------------

	public void updateMembersFromHashTable() {
		// REVERSE FIELD NAMES VECTOR
		setNsort((String)asFieldNames.get("nsort"));
		setSvalue((String)asFieldNames.get("svalue"));
		setSvalue_en((String)asFieldNames.get("svalue_en"));
		setField_name((String)asFieldNames.get("field_name"));
		setCode_value((String)asFieldNames.get("code_value"));

	}

	//--------------------------------------------------------------------------------
	// constructor of the class. it initializes the object variables
	//--------------------------------------------------------------------------------

	// CONSTRUCTOR
	public void init() {
		lastError="No errors detected";
		fieldNullState.put("nsort", new Boolean(true));
		nsort = 0;
		svalue = "";
		svalue_en = "";
		field_name = "";
		code_value = "";
		updateHashTable();
	}

	public extensioncodes() {
		super("Extensioncodes object");
		init();
	}
//--------------------------------------------------------------------------------
// getter and setter methods of the elements of the class
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
// Access methods for database field 'nsort'
	public String getNsort() {
		return Integer.toString(nsort);
	}

	public void setNsort(String sParameter) {
		nsort = extendedParseInt(sParameter);
		if (not_null(sParameter).length()>0) {
			fieldNullState.put("nsort", false);
		}
	}

	public void setNsort(int sParameter) {
		nsort = sParameter;
		fieldNullState.put("nsort", false);
	}
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
// Access methods for database field 'svalue'
	public String getSvalue() {
		return svalue;
	}

	public void setSvalue(String sParameter) {
		svalue = sParameter;
	}
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
// Access methods for database field 'svalue_en'
	public String getSvalue_en() {
		return svalue_en;
	}

	public void setSvalue_en(String sParameter) {
		svalue_en = sParameter;
	}
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
// Access methods for database field 'field_name'
	public String getField_name() {
		return field_name;
	}

	public void setField_name(String sParameter) {
		field_name = sParameter;
	}
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
// Access methods for database field 'code_value'
	public String getCode_value() {
		return code_value;
	}

	public void setCode_value(String sParameter) {
		code_value = sParameter;
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
		setNsort(req.getParameter(assignName("nsort")));
		setSvalue(not_null_safe(req.getParameter(assignName("svalue"))));
		setSvalue_en(not_null_safe(req.getParameter(assignName("svalue_en"))));
		setField_name(not_null_safe(req.getParameter(assignName("field_name"))));
		setCode_value(not_null_safe(req.getParameter(assignName("code_value"))));

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
				nsort = rset.getInt("nsort");

				fieldNullState.put("nsort", new Boolean(rset.wasNull()));
			} catch (Exception ex) {
				lastError = "<-- error attempting to access field nsort -->";
				System.out.println(ex.toString());
			}

			try {
				svalue = not_null(rset.getString("svalue"));

			} catch (Exception ex) {
				lastError = "<-- error attempting to access field svalue -->";
				System.out.println(ex.toString());
			}

			try {
				svalue_en = not_null(rset.getString("svalue_en"));

			} catch (Exception ex) {
				lastError = "<-- error attempting to access field svalue_en -->";
				System.out.println(ex.toString());
			}

			try {
				field_name = not_null(rset.getString("field_name"));

			} catch (Exception ex) {
				lastError = "<-- error attempting to access field field_name -->";
				System.out.println(ex.toString());
			}

			try {
				code_value = not_null(rset.getString("code_value"));

			} catch (Exception ex) {
				lastError = "<-- error attempting to access field code_value -->";
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
			sSql = "SELECT * FROM extensioncodes";
			sSql += " WHERE (code_value = ?) AND (field_name = ?)";
			pstmt = con.prepareStatement(sSql);


			if (code_value==null || code_value.length() == 0)
				pstmt.setNull(f++, Types.VARCHAR);
			else
				pstmt.setString(f++, code_value);

			if (field_name==null || field_name.length() == 0)
				pstmt.setNull(f++, Types.VARCHAR);
			else
				pstmt.setString(f++, field_name);


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
			sSql = "insert into extensioncodes (";
			sSql += "nsort, svalue, svalue_en, field_name, code_value)";
			sSql += "VALUES (?, ?, ?, ?, ?)";
			pstmt = con.prepareStatement(sSql);

			if (nsort==0 && (Boolean)fieldNullState.get("nsort")) 
				pstmt.setNull(f++, java.sql.Types.INTEGER);
			else
				pstmt.setInt(f++, nsort);
			if (svalue==null || svalue.length()==0)
				pstmt.setNull(f++, java.sql.Types.VARCHAR);
			else
				pstmt.setString(f++, svalue);
			if (svalue_en==null || svalue_en.length()==0)
				pstmt.setNull(f++, java.sql.Types.VARCHAR);
			else
				pstmt.setString(f++, svalue_en);
			if (field_name==null || field_name.length()==0)
				pstmt.setNull(f++, java.sql.Types.VARCHAR);
			else
				pstmt.setString(f++, field_name);
			if (code_value==null || code_value.length()==0)
				pstmt.setNull(f++, java.sql.Types.VARCHAR);
			else
				pstmt.setString(f++, code_value);


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
			sSql = "UPDATE extensioncodes SET ";
			sSql += "nsort = ?";
			sSql += ", svalue = ?";
			sSql += ", svalue_en = ?";
			sSql += " WHERE (code_value = ?) AND (field_name = ?)";
			pstmt = con.prepareStatement(sSql);

			if (nsort==0 && (Boolean)fieldNullState.get("nsort")) 
				pstmt.setNull(f++, java.sql.Types.INTEGER);
			else 
				pstmt.setInt(f++, nsort);
			if (svalue==null || svalue.length()==0)
				pstmt.setNull(f++, java.sql.Types.VARCHAR);
			else 
				pstmt.setString(f++, svalue);
			if (svalue_en==null || svalue_en.length()==0)
				pstmt.setNull(f++, java.sql.Types.VARCHAR);
			else 
				pstmt.setString(f++, svalue_en);



			if (code_value==null || code_value.length() == 0)
				pstmt.setNull(f++, Types.VARCHAR);
			else
				pstmt.setString(f++, code_value);

			if (field_name==null || field_name.length() == 0)
				pstmt.setNull(f++, Types.VARCHAR);
			else
				pstmt.setString(f++, field_name);


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
			sSql = "DELETE FROM extensioncodes";
			sSql += " WHERE (code_value = ?) AND (field_name = ?)";
			pstmt = con.prepareStatement(sSql);


			if (code_value==null || code_value.length() == 0)
				pstmt.setNull(f++, Types.VARCHAR);
			else
				pstmt.setString(f++, code_value);

			if (field_name==null || field_name.length() == 0)
				pstmt.setNull(f++, Types.VARCHAR);
			else
				pstmt.setString(f++, field_name);


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
<tr><td>nsort:</td><td>  <INPUT type='TEXT' size='5' maxlength='11' name='nsort' VALUE="<%=beanName.nsort%>"></td></tr>
<tr><td>svalue:</td><td>  <INPUT type='TEXT' size='41' maxlength='40' name='svalue' VALUE="<%=beanName.svalue%>"></td></tr>
<tr><td>svalue_en:</td><td>  <INPUT type='TEXT' size='41' maxlength='40' name='svalue_en' VALUE="<%=beanName.svalue_en%>"></td></tr>
<tr><td>field_name:</td><td>  <INPUT type='TEXT' size='31' maxlength='30' name='field_name' VALUE="<%=beanName.field_name%>"></td></tr>
<tr><td>code_value:</td><td>  <INPUT type='TEXT' size='11' maxlength='10' name='code_value' VALUE="<%=beanName.code_value%>"></td></tr>
</table>
END HTML TEMPLATE */
