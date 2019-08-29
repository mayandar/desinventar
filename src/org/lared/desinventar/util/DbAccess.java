package org.lared.desinventar.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParsePosition;
import java.util.Hashtable;

import org.lared.desinventar.system.Sys;

public class DbAccess implements DbImplementation
{
	/* Hashtable with DB-specific function names */
	static Hashtable<String, String> loadTranslations() 
	{
		Hashtable<String, String>  htTranslation = new Hashtable<String, String> ();
		htTranslation.put("ISNULL", "NVL");
		// numeric
		htTranslation.put("ABS", "ABS");
		htTranslation.put("ACOS", "COSH");
		htTranslation.put("ASIN", "SINH");
		htTranslation.put("ATAN", "ATN");
		htTranslation.put("ATN2", "ATN");
		htTranslation.put("CEILING", "INT");
		htTranslation.put("COS", "COS");
		htTranslation.put("COT", "TAN");
		htTranslation.put("EXP", "EXP");
		htTranslation.put("FLOOR", "INT");
		htTranslation.put("LOG", "LOG");
		htTranslation.put("GREATEST", "GREATEST");
		htTranslation.put("PI", "3.141592");
		htTranslation.put("POWER", "POWER");
		htTranslation.put("RAND", "RND");
		htTranslation.put("ROUND", "ROUND");
		htTranslation.put("SIGN", "SIGN");
		htTranslation.put("SIN", "SIN");
		htTranslation.put("SQRT", "SQRT");
		htTranslation.put("TAN", "TAN");
		htTranslation.put("ASCII", "ASC");
		htTranslation.put("CHAR", "CHR");
		htTranslation.put("LEFT", "LEFT");
		htTranslation.put("LEAST", "LEAST");
		htTranslation.put("LEN", "LENGTH");
		htTranslation.put("LOWER", "LCASE");
		htTranslation.put("LTRIM", "LTRIM");
		htTranslation.put("NCHAR", "CSTR");
		htTranslation.put("REPLACE", "REPLACE");
		htTranslation.put("REPLICATE", "SPACE");
		htTranslation.put("RTRIM", "RTRIM");
		htTranslation.put("SOUNDEX", "SOUNDEX");
		htTranslation.put("STR", "CSTR");
		htTranslation.put("SUBSTRING", "MID");
		htTranslation.put("UPPER", "UCASE");
		htTranslation.put("@@ERROR", "SQLERRM");
		htTranslation.put("@@IDENTITY", "LAST");
		htTranslation.put("@@ROWCOUNT", "RecordCount");
		htTranslation.put("CURRENT_TIMESTAMP", "NOW");
		htTranslation.put("CURRENT_USER", "'USER'");
		htTranslation.put("DATALENGTH", "LEN");
		htTranslation.put("HOST_NAME", "'HOSTNAME'");
		htTranslation.put("IDENT_CURRENT", "'USER'");
		htTranslation.put("NULLIF", "NULLIF");
		htTranslation.put("DATENAME", "CSTR");
		htTranslation.put("ISNUMBER", "isnumeric");

		return htTranslation;
	}

	static Hashtable<String, String> htSqlTranslation = loadTranslations();

	public String sGetSQLFunction(String sFunctionName)
	{
		String sFunc=null;
		if (null==(sFunc=htSqlTranslation.get(sFunctionName)))
			return sFunc;
		else
			return htSqlTranslation.get(sFunctionName);
	}

	  //--------------------------------------------------------------------------------
	  // generic method to produce a SQL acceptable date string in default database
	  //--------------------------------------------------------------------------------
	  public String sqlDate(String strParameter)
	  {
	    String sDateString = new String(strParameter);
	    sDateString=sDateString.replace('/','-');
	    if (sDateString.indexOf("-")>0)  // is a constant
	      	        sDateString = "'"+sDateString+"'";
	    sDateString = "cDate(" + sDateString + ")";
	    return sDateString;
	  }


	  //--------------------------------------------------------------------------------
	  // generic method to produce a SQL acceptable datetime stamp string in default database
	  //--------------------------------------------------------------------------------
	  public String sqlDateTime(String strParameter)
	  {	    
	    return sqlDate(strParameter);
	  }


	  //--------------------------------------------------------------------------------
	  // generic method to produce a SQL acceptable number string in default database
	  //--------------------------------------------------------------------------------
	  public String sqlNumber(String strParameter)
	  {
	    if (strParameter.length() > 0)
	    {
	          return "int(" + strParameter + ")";
	    }
	    else
	    	return "null";
	  }

	  //--------------------------------------------------------------------------------
	  // generic method to produce a SQL acceptable  string from a date in any database
	  //--------------------------------------------------------------------------------
	  public String sqlCharDate(String strParameter)
	  {
		    if (strParameter.length() > 0)
		    {
			    return  "cStr(" + strParameter + ")";
		    }
		    else
		    	return "null";
	  }

	  //--------------------------------------------------------------------------------
	  // generic method to produce a SQL acceptable  string from a numeric field
	  //--------------------------------------------------------------------------------
	  public String sqlCharNumber(String strParameter)
	  {
			    return  "cStr(" + strParameter + ")";		  
	  }
  

	  //--------------------------------------------------------------------------------
	  // generic methods to produce a SQL acceptable modulo column, default database
	  //--------------------------------------------------------------------------------

	  public String sqlMod(int nParameter, int nParameter1)
	  {
	    return sqlMod(String.valueOf(nParameter), String.valueOf(nParameter1));
	  }

	  public String sqlMod(int nParameter, String sParameter1)
	  {
	    return sqlMod(String.valueOf(nParameter), sParameter1);
	  }

	  public String sqlMod(String sParameter, int nParameter1)
	  {
	    return sqlMod(sParameter, String.valueOf(nParameter1));
	  }

	  //--------------------------------------------------------------------------------
	  // generic method to produce a SQL acceptable modulo column in any database
	  //--------------------------------------------------------------------------------
	  public String sqlMod(String strParameter, String strParameter1)
	  {
      return "(" + strParameter + " mod " + strParameter1 + ")";
	  }

	  //----------------------------------------------------------------------------------------
	  // generic method to produce a SQL acceptable NVL (as defined in Oracle) in any database
	  //----------------------------------------------------------------------------------------
	  public String sqlNvl(int nParameter, int nParameter1)
	  {
	    return sqlNvl(String.valueOf(nParameter), String.valueOf(nParameter1));
	  }

	  public String sqlNvl(String sParameter, int nParameter1)
	  {
	    return sqlNvl(sParameter, String.valueOf(nParameter1));
	  }

	  public String sqlNvl(String strParameter, String strParameter1)
	  {
	   return " iif(isnull(" + strParameter + "), " + strParameter1+ "," + strParameter + ") ";
	  }


	  //--------------------------------------------------------------------------------
	  // an SQL acceptable trunc function in default database
	  //--------------------------------------------------------------------------------
	  public String sqlTrunc()
	  {
	    return " int(";
	  }

	  
	  //--------------------------------------------------------------------------------
	  // an SQL acceptable XMIN and XMAX names function
	  //--------------------------------------------------------------------------------
	  public String sqlXmin()
	  {
	    return "xmin";
	  }
	  public String sqlXmax()
	  {
		    return "xmax";
	  }

	  
	  //--------------------------------------------------------------------------------
	  // an SQL acceptable  STD Deviation  function in default database
	  //--------------------------------------------------------------------------------
	  public String sqlStddev()
	  {
	    return "stdev(";
	  }

	  //--------------------------------------------------------------------------------
	  // an SQL acceptable  Variance  function in default database
	  //--------------------------------------------------------------------------------
	  public String sqlVariance()
	  {
	    return " var(";
	  }


	  


	  //--------------------------------------------------------------------------------
	   // an SQL acceptable String Concat operator in any database
	   //--------------------------------------------------------------------------------
	   public String sqlConcat()
	   {
		   return "&";
	   }

	   // recommended
	   public String sqlConcat(String strParameter, String strParameter1) 
	   {
		   return strParameter + "&" +strParameter1;
	   }

	   //--------------------------------------------------------------------------------
	   // an SQL acceptable String Concat operator in any database
	   //--------------------------------------------------------------------------------
	   public String sqlStringConstant()
	   {
	     return "'";
	   }

	   /**
	    *  produces the SQL statement to generate a string representation of a DesInventar date
	    *  Note a DI-date may have month or day null.   a DI-date may be of the form 2003-00-00
	    *  
	    */
	   public String sqlDI_date()
	   {
		   
		   String sRet="(fechano*10000 + iif(isnull(fechames),0,fechames)*100 +iif(isnull(fechadia),0,fechadia))";		   
		   return sRet;
	   }
	   
	   //----------------------------------------------------------------
	   // gets a primary key from a sequence, in default database
	   //----------------------------------------------------------------
	   public int getSequence(String sSequence, Connection con)
	   {
	     Statement stmt=null; // SQL statement object
	     ResultSet rset=null; // SQL resultset
	     String sSql; // SQL statement string
	     int key_id;

	     key_id = 0;
	     try
	     {
	           stmt = con.createStatement ();
	           int nDum = (int) (Math.random() * 99999999);
	           sSql = "insert into " + sSequence + " (dum) values(" + nDum + ")";
	           stmt.executeUpdate(sSql);
	           sSql = "select max(nextval) as newId from " + sSequence + " where dum=" + nDum;
	           rset = stmt.executeQuery(sSql);
	           if (rset.next())
	           {
	             key_id = rset.getInt("newId");
	             stmt.executeUpdate("delete from " + sSequence + " where nextval=" + key_id);
	           }
	     }
	     catch (SQLException e)
	     {
	       // lastError = "<!--" + e.toString() + "-->";
	       //key_id = -1;
	     }
	     finally{
	    	 try {rset.close();}catch(Exception ex){}
	    	 try {stmt.close();}catch(Exception ex){}
	     }
	     return key_id;
	   }

	   public String getUUID()
	   {
		   String sRet="left(clave & int(rnd(clave)*9999999999)& (CDbl(Now())*9999999999+clave),26)";
		   
		   return sRet;
	   }

	   /** gets a (database specific) Large text object: FROM MEMO, simply a getString */
	   public String getClob(ResultSet rset, String sField)
	   {
		String sResult=null;
		try{
		   sResult=rset.getString(sField);
		   }
		catch (Exception e)
		   {
		   }
	    if (sResult==null)
			   sResult="";
	    return sResult;
	   }


	   /** constructs an update statement on Datacards (FICHAS) from a join FICHAS-Extension */
	   public String updateDatacardJoin(String sSetStatements, String sWhereStatement)
	   {
		   String sSql="update fichas, extension "  +sSetStatements+ " where clave=clave_ext";
		   if (sWhereStatement.length()>0)
			   sSql+=" and ("+sWhereStatement+")";
		   return sSql;
	   }

	   /** constructs an update statement on EXTENSION from a join FICHAS-Extension */
	   public String updateExtensionJoin(String sSetStatements, String sWhereStatement)
	   {
		   
		   return updateDatacardJoin(sSetStatements, sWhereStatement);
	   }

	   /** constructs an update statement on two tables */
	   public String updateFromJoin(String sTable1, String sTable2, String sJoinExpression, String sSetStatements, String sWhereStatement)
	   {
		   String sSql="update "+sTable1+" t1, "+sTable2+" t2 "  +sSetStatements+ " where ("+sJoinExpression+")";
		   if (sWhereStatement.length()>0)
			   sSql+=" and ("+sWhereStatement+")";
		   return sSql;
	   }

	   
	   /** creates a sequence or equivalent object */
	   public String sCreateSequence(String sSequenceName)
	   {
		   return "create table "+sSequenceName+" (nextval autoincrement, dum integer,  PRIMARY KEY (nextval))";
	   }

	   /** drops a sequence or equivalent object */
	   public String sDropSequence(String sSequenceName)
	   {
		   return "drop table "+sSequenceName;
	   }
 
}
