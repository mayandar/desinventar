package org.lared.desinventar.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParsePosition;
import java.util.Hashtable;

import org.lared.desinventar.webobject.webObject;

public class DbJDBC implements DbImplementation
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
		htTranslation.put("GREATEST", "GREATEST_");
		htTranslation.put("PI", "3.141592");
		htTranslation.put("POWER", "POWER");
		htTranslation.put("RAND", "dbms_random.random");
		htTranslation.put("ROUND", "ROUND");
		htTranslation.put("SIGN", "SIGN");
		htTranslation.put("SIN", "SIN");
		htTranslation.put("SQRT", "SQRT");
		htTranslation.put("TAN", "TAN");
		htTranslation.put("ASCII", "ASCII");
		htTranslation.put("CHAR", "CHR");
		htTranslation.put("LEFT", "SUBSTR");
		htTranslation.put("LEAST", "LEAST_");
		htTranslation.put("LEN", "LENGTH");
		htTranslation.put("LOWER", "LOWER");
		htTranslation.put("LTRIM", "LTRIM");
		htTranslation.put("NCHAR", "util.to_utf");
		htTranslation.put("REPLACE", "REPLACE");
		htTranslation.put("REPLICATE", "LPAD");
		htTranslation.put("RTRIM", "RTRIM");
		htTranslation.put("SOUNDEX", "SOUNDEX");
		htTranslation.put("STR", "TO_CHAR");
		htTranslation.put("SUBSTRING", "SUBSTR");
		htTranslation.put("UPPER", "UPPER");
		htTranslation.put("@@ERROR", "SQLERRM");
		htTranslation.put("@@IDENTITY", "seq.CURRVAL");
		htTranslation.put("@@ROWCOUNT", "SQL%ROWCOUNT");
		htTranslation.put("CURRENT_TIMESTAMP", "SYSDATE");
		htTranslation.put("CURRENT_USER", "USER");
		htTranslation.put("DATALENGTH", "LENGTHB");
		htTranslation.put("HOST_NAME", "UTL_INADDR.get_host_name");
		htTranslation.put("IDENT_CURRENT", "USER");
		htTranslation.put("NULLIF", "NULLIF");
		htTranslation.put("DATENAME", "to_char");
		htTranslation.put("ISNUMBER", "util.isnumber");

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
	    // date manager
	    java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy-MM-dd"); //("yyyy-MM-dd-HH:mm");

	    if (sDateString.length() > 0)
	    {
	      formatter.setLenient(true);
	      java.util.Date tmpDate = formatter.parse(sDateString, new ParsePosition(0));
	      if (tmpDate != null)
	      {
	        sDateString = formatter.format(tmpDate);
          sDateString = "to_date('" + sDateString + "','YYYY-MM-DD')";
	      }
	      else
	        sDateString = "NULL";
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
	      if (tmpDate != null)
	      {
	        sDateString = formatter.format(tmpDate);
	        sDateString = "to_date('" + sDateString + "','YYYY-MM-DD HH24:MI')";
	      }
	      else
	        sDateString = "NULL";
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
		    return  "cast(" + strParameter + " as varchar)";
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
			    return  "to_char(" + strParameter + ",'yyyy-mm-dd HH24:mi:ss')";
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
	   return " nvl(" + strParameter + "," + strParameter1 + ") ";
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
	   // recommended
	   public String sqlConcat(String strParameter, String strParameter1) 
	   {
		   return strParameter + "||" +strParameter1;
	   }
	   
	   public String sqlConcat()
	   {
		   return "||";
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
	    *  Note a DI-date may have month or day null.   a DI-date may be of the form 20030000	    *  
	    */
	   public String sqlDI_date()
	   {
		   String sRet="(fechano*10000 + NVL(fechames,0)*100 +NVL(fechadia,0))";		   
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
	           sSql = "select " + sSequence + ".nextval from dual";
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
		   String sRet="clave";
		   
		   return sRet;
	   }

	   /** gets a (database specific) Large text object: FROM NTEXT, simply a getString */
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
		   String sSql="update F "+sSetStatements+" FROM fichas F JOIN extension E ON clave=clave_ext";
		   if (sWhereStatement.length()>0)
			   sSql+=" where "+sWhereStatement;

		   return sSql;
	   }
 
	   /** constructs an update statement on EXTENSION from a join FICHAS-Extension */
	   public String updateExtensionJoin(String sSetStatements, String sWhereStatement)
	   {
		   String sSql="update E "+sSetStatements+" FROM fichas F JOIN extension E ON clave=clave_ext";
		   if (sWhereStatement.length()>0)
			   sSql+=" where "+sWhereStatement;		   
		   return sSql;
	   }

	   /** constructs an update statement on two tables, with querynames t1 and t2, updating variables on the first! */
	   public String updateFromJoin(String sTable1, String sTable2, String sJoinExpression, String sSetStatements, String sWhereStatement)
	   {
		   String sSql="update t1 "+sSetStatements+" FROM "+sTable1+" t1 JOIN "+sTable2+" t2 ON "+sJoinExpression;
		   if (sWhereStatement.length()>0)
			   sSql+=" where "+sWhereStatement;

		   return sSql;
	   }
	   
	   /** creates a sequence or equivalent object */
	   public String sCreateSequence(String sSequenceName)
	   {
		   return "create table "+sSequenceName+" (nextval int IDENTITY(1,1), dum integer, primary key (nextval))";
	   }

	   /** drops a sequence or equivalent object */
	   public String sDropSequence(String sSequenceName)
	   {
		   return "drop table"+sSequenceName;
	   }
	   
}
