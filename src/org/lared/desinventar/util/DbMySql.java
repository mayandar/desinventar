package org.lared.desinventar.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParsePosition;
import java.util.Hashtable;

public class DbMySql implements DbImplementation
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
		htTranslation.put("COT", "TAN");
		htTranslation.put("EXP", "EXP");
		htTranslation.put("FLOOR", "FLOOR");
		htTranslation.put("LOG", "LN");
		htTranslation.put("GREATEST", "GREATEST");
		htTranslation.put("PI", "3.141592");
		htTranslation.put("POWER", "POWER");
		htTranslation.put("RAND", "RAND");
		htTranslation.put("ROUND", "ROUND");
		htTranslation.put("SIGN", "SIGN");
		htTranslation.put("SIN", "SIN");
		htTranslation.put("SQRT", "SQRT");
		htTranslation.put("TAN", "TAN");
		htTranslation.put("ASCII", "ASCII");
		htTranslation.put("CHAR", "CHAR");
		htTranslation.put("LEFT", "LEFT");
		htTranslation.put("LEAST", "LEAST_");
		htTranslation.put("LEN", "LENGTH");
		htTranslation.put("LOWER", "LOWER");
		htTranslation.put("LTRIM", "LTRIM");
		htTranslation.put("NCHAR", "");
		htTranslation.put("REPLACE", "REPLACE");
		htTranslation.put("REPLICATE", "REPEAT");
		htTranslation.put("RTRIM", "RTRIM");
		htTranslation.put("SOUNDEX", "SOUNDEX");
		htTranslation.put("STR", "BIN");
		htTranslation.put("SUBSTRING", "SUBSTRING");
		htTranslation.put("UPPER", "UPPER");
		htTranslation.put("@@ERROR", "SQLERRM");
		htTranslation.put("@@IDENTITY", "LAST_INSERT_ID()");
		htTranslation.put("@@ROWCOUNT", "ROW_COUNT()");
		htTranslation.put("CURRENT_TIMESTAMP", "CURDATE()");
		htTranslation.put("CURRENT_USER", "USER()");
		htTranslation.put("DATALENGTH", "CHAR_LENGTH");
		htTranslation.put("HOST_NAME", "(select concat(user, '@', host) from mysql.user)");
		htTranslation.put("IDENT_CURRENT", "USER");
		htTranslation.put("NULLIF", "NULLIF");
		htTranslation.put("DATENAME", "");
		htTranslation.put("ISNUMBER", "");

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
	    // date manager
	    java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy-MM-dd"); //("yyyy-MM-dd-HH:mm");

	    if (sDateString.length() > 0)
	    {
	      formatter.setLenient(true);
	      java.util.Date tmpDate = formatter.parse(sDateString, new ParsePosition(0));
	      if (tmpDate != null) // could convert to std date
	          sDateString = "'"+formatter.format(tmpDate)+"'";
	        else  if (sDateString.indexOf("-")>0)  // is a constant
	      	        sDateString = "'"+sDateString+"'";
          sDateString = "STR_TO_DATE(" + sDateString + ",'%Y-%m-%d')";
	    }
	    else
	      sDateString = "null";
	    return sDateString;
	  }


	  //--------------------------------------------------------------------------------
	  // generic method to produce a SQL acceptable datetime stamp string in default database
	  //--------------------------------------------------------------------------------
	  public String sqlDateTime(String strParameter)
	  {
	    String sDateString = new String(strParameter);
	    sDateString=sDateString.replace('/','-');
	    // date manager
	    java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm");

	    if (sDateString.length() > 0)
	    {
	      formatter.setLenient(true);
	      java.util.Date tmpDate = formatter.parse(sDateString, new ParsePosition(0));
	      if (tmpDate != null) // could convert to std date
	          sDateString = "'"+formatter.format(tmpDate)+"'";
	        else  if (sDateString.indexOf("-")>0 && sDateString.indexOf("'")<0)  // is an unquoted constant
	      	        sDateString = "'"+sDateString+"'";
           sDateString = "STR_TO_DATE(" + sDateString + ",'%Y-%m-%d %H:%i')";
	    }
	    else
	      sDateString = "null";
	    return sDateString;
	  }


	  //--------------------------------------------------------------------------------
	  // generic method to produce a SQL acceptable number string in default database
	  //--------------------------------------------------------------------------------
	  public String sqlNumber(String strParameter)
	  {
	    if (strParameter.length() > 0)
	    {
	    	return "cast(" + strParameter + " as decimal)";
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
			    return "FORMAT_DATE(" + strParameter + ",'%Y-%m-%d %H:%i')";
		    }
		    else
		    	return "null";
	  }

	  //--------------------------------------------------------------------------------
	  // generic method to produce a SQL acceptable  string from a numeric field
	  //--------------------------------------------------------------------------------
	  public String sqlCharNumber(String strParameter)
	  {
			    return  "cast(" + strParameter + " as char)";		  
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
	   return " ifnull(" + strParameter + "," + strParameter1 + ") ";
	  }


	  //--------------------------------------------------------------------------------
	  // an SQL acceptable trunc function in default database
	  //--------------------------------------------------------------------------------
	  public String sqlTrunc()
	  {
	    return " truncate(";
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
		   return "concat("+strParameter + "," +strParameter1+")";
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
		   
		   String sRet="(fechano*10000 + ifnull(fechames,0)*100 +ifnull(fechadia,0))";		   
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
		   String sRet="UUID()";
		   
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
		   return "create table "+sSequenceName+" (nextval int(10) NOT NULL auto_increment, dum int(10)  NULL,  PRIMARY KEY words_seq (nextval)) ENGINE=InnoDB";
	   }

	   /** drops a sequence or equivalent object */
	   public String sDropSequence(String sSequenceName)
	   {
		   return "drop table "+sSequenceName;
	   }

}
