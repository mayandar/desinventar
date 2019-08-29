package org.lared.desinventar.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;


public class DbSqlServer implements DbImplementation
{

	  /* returns the equivalent of a SQL Server (reference) function name 
	  * This assumes function will receive same number & type of parameters and will return same type*/
	public String sGetSQLFunction(String sFunctionName)
	{
		// SQL Server is the reference implementation of this function
		return sFunctionName;
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
        sDateString = "convert(datetime," + sDateString + ")";
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
	    	return "convert(int ," + strParameter + ")";
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
			    return  "convert(varchar," + strParameter + ",120)";
		    }
		    else
		    	return "null";
	  }

	  //--------------------------------------------------------------------------------
	  // generic method to produce a SQL acceptable  string from a numeric field
	  //--------------------------------------------------------------------------------
	  public String sqlCharNumber(String strParameter)
	  {
		    return  "Convert(varchar," + strParameter + ")";
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
      return "(" + strParameter + " % " + strParameter1 + ")";
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
	   return " isnull(" + strParameter + "," + strParameter1 + ") ";
	  }


	  //--------------------------------------------------------------------------------
	  // an SQL acceptable trunc function in default database
	  //--------------------------------------------------------------------------------
	  public String sqlTrunc()
	  {
	    return "convert(int,";
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
		   return "+";
	   }

	   // recommended
	   public String sqlConcat(String strParameter, String strParameter1) 
	   {
		   return strParameter + "+" +strParameter1;
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
	    *  Note a DI-date may have month or day null.   a DI-date may be of the form 20030000
	    *  
	    */
	   public String sqlDI_date()
	   {
		   String sRet="(fechano*10000 + isnull(fechames,0)*100 +isnull(fechadia,0))";		      
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
		   String sRet="newid()";
		   
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
