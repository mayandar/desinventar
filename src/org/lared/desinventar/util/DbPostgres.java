package org.lared.desinventar.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParsePosition;
import java.util.Hashtable;

import org.lared.desinventar.system.Sys;

public class DbPostgres implements DbImplementation
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
		htTranslation.put("ATAN", "TANH");
		htTranslation.put("ATN2", "ATAN2");
		htTranslation.put("CEILING", "CEIL");
		htTranslation.put("COS", "COS");
		htTranslation.put("COT", "COT");
		htTranslation.put("EXP", "EXP");
		htTranslation.put("FLOOR", "FLOOR");
		htTranslation.put("LOG", "LN");
		htTranslation.put("GREATEST", "GREATEST_");
		htTranslation.put("PI", "pi()");
		htTranslation.put("POWER", "POWER");
		htTranslation.put("RAND", "random");
		htTranslation.put("ROUND", "ROUND");
		htTranslation.put("SIGN", "SIGN");
		htTranslation.put("SIN", "SIN");
		htTranslation.put("SQRT", "SQRT");
		htTranslation.put("TAN", "TAN");
		// string
		htTranslation.put("ASCII", "ASCII");
		htTranslation.put("CHAR", "CHR");
		htTranslation.put("LEFT", "");
		htTranslation.put("LEAST", "LEAST");
		htTranslation.put("LEN", "LENGTH");
		htTranslation.put("LOWER", "LOWER");
		htTranslation.put("LTRIM", "LTRIM");
		htTranslation.put("NCHAR", "");
		htTranslation.put("REPLACE", "REPLACE");
		htTranslation.put("REPLICATE", "LPAD");
		htTranslation.put("RTRIM", "RTRIM");
		htTranslation.put("SOUNDEX", "SOUNDEX");
		htTranslation.put("STR", "TO_CHAR");
		htTranslation.put("SUBSTRING", "SUBSTRING");
		htTranslation.put("UPPER", "UPPER");
		// misc
		htTranslation.put("@@ERROR", "SQLERRM");
		htTranslation.put("@@IDENTITY", "lastval()");
		htTranslation.put("@@ROWCOUNT", "ROW_COUNT");
		htTranslation.put("CURRENT_TIMESTAMP", "now()");
		htTranslation.put("CURRENT_USER", "USER");
		htTranslation.put("DATALENGTH", "LENGTH");
		htTranslation.put("HOST_NAME", "inet_server_addr()");
		htTranslation.put("IDENT_CURRENT", "USER");
		htTranslation.put("NULLIF", "NULLIF");
		htTranslation.put("DATENAME", "to_char");
		htTranslation.put("ISNUMBER", "util.isnumber");

		return htTranslation;
	}

	static Hashtable<String, String> htSqlTranslation = loadTranslations();

	/* returns the equivalent of a SQL Server (reference) function name 
	  * This assumes function will receive same number & type of parameters and will return same type*/
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
	    if (sDateString.indexOf("-")>0 && sDateString.indexOf("'")<0)  // is an unquoted constant
	      	        sDateString = "'"+sDateString+"'";
	    sDateString =  "cast(" + sDateString + " as date)";
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
	    	return "cast(" + strParameter + " as int)";
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
			    return  "cast(" + strParameter + " as varchar)";
		    }
		    else
		    	return "null";
	  }

	  //--------------------------------------------------------------------------------
	  // generic method to produce a SQL acceptable  string from a numeric field
	  //--------------------------------------------------------------------------------
	  public String sqlCharNumber(String strParameter)
	  {
		    return  "cast(" + strParameter + " as varchar)";
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
      return " mod(" + strParameter + "," + strParameter1 + ") ";
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
	   return " coalesce(" + strParameter + "," + strParameter1 + ") ";
	  }


	  //--------------------------------------------------------------------------------
	  // an SQL acceptable trunc function in default database
	  //--------------------------------------------------------------------------------
	  public String sqlTrunc()
	  {
	    return " trunc(";
	  }

	  
	  //--------------------------------------------------------------------------------
	  // an SQL acceptable XMIN and XMAX names function
	  //--------------------------------------------------------------------------------
	  public String sqlXmin()
	  {
		  return "xmin_";
	  }
	  public String sqlXmax()
	  {
		  return "xmax_";
	  }

	  
	  //--------------------------------------------------------------------------------
	  // an SQL acceptable  STD Deviation  function in default database
	  //--------------------------------------------------------------------------------
	  public String sqlStddev()
	  {
	    return " stddev(";
	  }

	  //--------------------------------------------------------------------------------
	  // an SQL acceptable  Variance  function in default database
	  //--------------------------------------------------------------------------------
	  public String sqlVariance()
	  {
	    return " variance(";
	  }


	  


	  //--------------------------------------------------------------------------------
	   // an SQL acceptable String Concat operator in any database
	   //--------------------------------------------------------------------------------
	   public String sqlConcat()
	   {
		   return "||";
	   }

	   // recommended
	   public String sqlConcat(String strParameter, String strParameter1) 
	   {
		   return strParameter + "||" +strParameter1;
	   }

	   //--------------------------------------------------------------------------------
	   // an SQL acceptable String Concat operator in any database
	   //--------------------------------------------------------------------------------
	   public String sqlStringConstant()
	   {
	     return "N'";
	   }
	   
	   /**
	    *  produces the SQL statement to generate a string representation of a DesInventar date
	    *  Note a DI-date may have month or day null.   a DI-date may be of the form 2003-00-00	    *  
	    */
	   public String sqlDI_date()
	   {
		   String sRet="(fechano*10000 + coalesce(fechames,0)*100 +coalesce(fechadia,0))";		   
		   return sRet;
	   }
	   

	   public int getSequence(String sSequence, Connection con)
	   {
	     Statement stmt=null; // SQL statement object
	     ResultSet rset=null; // SQL resultset
	     String sSql; // SQL statement string
	     int key_id;

	     key_id = 0;
	     try
	     {
	           sSql = "select nextval('" + sSequence + "')";
	           stmt = con.createStatement ();
	           rset = stmt.executeQuery(sSql);
	           if (rset.next())
	             key_id = rset.getInt("nextval");
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
		   String sRet="uuid_generate_v1()";
		   
		   return sRet;
	   }

	   /** gets a (database specific) Large text object: FROM CLOB, try a getString, then getClob */
	   public String getClob(ResultSet rset, String sField)
	   {
		String sResult=null;
		try{
		   sResult=rset.getString(sField);
		   }
		catch (Exception e)
		   {
		    try{
		    	java.sql.Clob cl=rset.getClob(sField);
		    	if (cl!=null)
		    		{
			    	int length = (int) cl.length();
		    		if (length>0)
		    			sResult=cl.getSubString(1, length);
		    		}
		    	}
		    	catch (Exception e2)
		    	{
		    	}
		   }
	    if (sResult==null)
			   sResult="";
		return sResult;
	   }


	   /** constructs an update statement on Datacards (FICHAS) from a join FICHAS-Extension */
	   public String updateDatacardJoin(String sSetStatements, String sWhereStatement)
	   {
		   String sSql="update fichas "+sSetStatements+" from extension where clave=clave_ext";
		   if (sWhereStatement.length()>0)
			   sSql+=" and ("+sWhereStatement+")";
		   return sSql;
	   }
 
	   /** constructs an update statement on EXTENSION from a join FICHAS-Extension */
	   public String updateExtensionJoin(String sSetStatements, String sWhereStatement)
	   {
		   String sSql="update extension "+sSetStatements+" from fichas where clave=clave_ext";
		   if (sWhereStatement.length()>0)
			   sSql+=" and ("+sWhereStatement+")";
		   return sSql;
	   }

	   /** constructs an update statement on two tables */
	   public String updateFromJoin(String sTable1, String sTable2, String sJoinExpression, String sSetStatements, String sWhereStatement)
	   {
		   String sSql="update "+sTable1+" t1 "+sSetStatements+" from "+sTable2+" t2  where ("+sJoinExpression+")";
		   if (sWhereStatement.length()>0)
			   sSql+=" and ("+sWhereStatement+")";
		   return sSql;
	   }

	   /** creates a sequence or equivalent object */
	   public String sCreateSequence(String sSequenceName)
	   {
		   return "create sequence "+sSequenceName;
	   }

	   /** drops a sequence or equivalent object */
	   public String sDropSequence(String sSequenceName)
	   {
		   return "drop sequence "+sSequenceName;
	   }
	   
}
