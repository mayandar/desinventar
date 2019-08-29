package org.lared.desinventar.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.lared.desinventar.system.Sys;


public interface DbImplementation {
	
	static String[] FolderNames= {"oracle","access","sqlserver","mysql","jdbc","postgres","derby","sqlite","jdbc"};

	  public static final String[][] typeNames =
	  { {"VARCHAR2","NUMBER(9)","FLOAT","FLOAT","DATE","CLOB","NUMBER(9)","NUMBER(9)","NUMBER(9)"}, // iOracleDb
	    {"TEXT","INT","DOUBLE","DOUBLE","DATETIME","MEMO","INT","INT","INT"},     // iAccessDb
	    {"NVARCHAR","INT","FLOAT","FLOAT","DATETIME","NTEXT","INT","INT","INT"}, // iMSSqlDb
	    {"VARCHAR","INT","DOUBLE(53,0)","DOUBLE(53,0)","DATETIME","TEXT","INT","INT","INT"}, // iMySqlDb  TODO:  verify types!!
	    {"TEXT","INT","DOUBLE","DOUBLE","DATETIME","MEMO","INT","INT","INT"},    // IODBCDb== iAccessDb
	    {"VARCHAR","INTEGER","FLOAT","FLOAT","DATE","TEXT","INTEGER","INTEGER","INTEGER"}, // iPostgress  TODO:  verify types!!
	    {"VARCHAR","INT","DOUBLE","DOUBLE","TIMESTAMP","LONG VARCHAR","INT","INT","INT"}, // Derby
	    {"VARCHAR","INT","FLOAT","FLOAT","DATETIME","TEXT","INT","INT","INT"}, // SQLLite
	    {"VARCHAR","INT","FLOAT","FLOAT","DATETIME","TEXT","INT","INT","INT"}
	    }; // iJDBCwAuth  TODO:  verify types!!

	  //--------------------------------------------------------------------------------
	  // generic method to produce a SQL acceptable date string in default database
	  //--------------------------------------------------------------------------------
	  public String sqlDate(String strParameter);
	  //--------------------------------------------------------------------------------
	  // generic method to produce a SQL acceptable datetime stamp string in default database
	  //--------------------------------------------------------------------------------
	  public String sqlDateTime(String strParameter);
	  //--------------------------------------------------------------------------------
	  // generic method to produce a SQL acceptable number string in default database
	  //--------------------------------------------------------------------------------
	  public String sqlNumber(String strParameter);
	  
	  //--------------------------------------------------------------------------------
	  // generic method to produce a SQL acceptable  string from a date in any database
	  //--------------------------------------------------------------------------------
	  public String sqlCharDate(String strParameter);

	  //--------------------------------------------------------------------------------
	  // generic method to produce a SQL acceptable  string from a numeric field
	  //--------------------------------------------------------------------------------
	  public String sqlCharNumber(String strParameter);

	  
	  //--------------------------------------------------------------------------------
	  // generic methods to produce a SQL acceptable modulo column, default database
	  //--------------------------------------------------------------------------------
	  public String sqlMod(String strParameter, String strParameter1);
	  public String sqlMod(int nParameter, int nParameter1);
	  public String sqlMod(String sParameter, int nParameter1);
	  public String sqlMod(int nParameter, String sParameter1);


	  //----------------------------------------------------------------------------------------
	  // generic method to produce a SQL acceptable NVL (as defined in Oracle) in any database
	  //----------------------------------------------------------------------------------------
	  public String sqlNvl(String strParameter, String strParameter1);
	  public String sqlNvl(int nParameter, int nParameter1);
	  public String sqlNvl(String sParameter, int nParameter1);

	  //--------------------------------------------------------------------------------
	  // an SQL acceptable trunc function in default database
	  //--------------------------------------------------------------------------------
	  public String sqlTrunc();


	  //--------------------------------------------------------------------------------
	  // an SQL acceptable XMIN and XMAX names function
	  //--------------------------------------------------------------------------------
	  public String sqlXmin();
	  public String sqlXmax();

	  
	  //--------------------------------------------------------------------------------
	  // an SQL acceptable  STD Deviation  function in default database
	  //--------------------------------------------------------------------------------
	  public String sqlStddev();
	  
	  //--------------------------------------------------------------------------------
	  // an SQL acceptable  Variance  function in default database
	  //--------------------------------------------------------------------------------
	  public String sqlVariance();
	  	  


	  //--------------------------------------------------------------------------------
	   // an SQL acceptable String Concat operator in any database
	   //--------------------------------------------------------------------------------
	   public String sqlConcat(); // WARNING: to be deprecated; MySQL only accepts || as concat op in ANSI mode!
	   
	   public String sqlConcat(String strParameter, String strParameter1); // recommended

	   //--------------------------------------------------------------------------------
	   // an SQL acceptable String Constant delimiter in any database
	   //--------------------------------------------------------------------------------
	   public String sqlStringConstant();
	   
	   
	   /**
	    *  produces the SQL statement to generate a string representation of a DesInventar date
	    *  Note a DI-date may have month or day null.   a DI-date may be of the form 2003-00-00
	    *  
	    */
	   public String sqlDI_date();
	   
	   
	   /**
	    * gets a primary key from a sequence, in default database
	    * @param sSequence
	    * @param con
	    * @return
	    */
	   public int getSequence(String sSequence, Connection con);

	   /** gets a Universal Unique ID */
	   public String getUUID();

	   
	   /** gets a (database specific) Large binary object */
	   public String getClob(ResultSet rset, String sField);

	   /** constructs an update statement on Datacards (FICHAS) from a join FICHAS-Extension */
	   public String updateDatacardJoin(String sSetStatements, String sWhereStatement);
	   
	   /** constructs an update statement on EXTENSION from a join FICHAS-Extension */
	   public String updateExtensionJoin(String sSetStatements, String sWhereStatement);

	   /** constructs an update statement on two tables, with querynames t1 and t2, updating variables on the first! */
	   public String updateFromJoin(String sTable1, String sTable2, String sJoinExpression, String sSetStatements, String sWhereStatement);

	   /** creates a sequence or equivalent object */
	   public String sCreateSequence(String sSequenceName);

	   /** drops a sequence or equivalent object */
	   public String sDropSequence(String sSequenceName);

	   /* returns the equivalent of a SQL Server (reference) function name 
	    * This assumes function will receive same number & type of parameters and will return same type*/
	   public String sGetSQLFunction(String sFunctionName);
	   
}
