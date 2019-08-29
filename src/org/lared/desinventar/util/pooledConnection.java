package org.lared.desinventar.util;

import java.io.*;
import java.sql.*;
import java.util.*;

import org.lared.desinventar.util.*;
import org.lared.desinventar.system.*;
import org.lared.desinventar.webobject.*;

public class pooledConnection
{
  public String sDriver = "";
  public String sDatasource =Sys.sDefaultAccessMainString;
  public String sUsername = "";
  public String sPassword = "";
  public int iDbType = 1;
  public boolean bTaken = false;
  public boolean bStatus = false;
  public java.util.Calendar  dSince = Calendar.getInstance();
  public Connection connection;
  public String strConnectionError = "";

  public String toString()
  {
    String sToStr = "";

    if (connection==null)
      sToStr = "[NOT CONNECTED]";
    sToStr = "<tr><td>sDriver=" + sDriver +
        "</td><td>sDatasource=" + sDatasource +
        "</td><td> Taken=" + bTaken +
        "</td><td> Status=" + bStatus + sToStr +
        "</td><td> Since=" + dSince.getTime().toGMTString()+
        "</td><td> Errors="+strConnectionError +
        "</td></tr>";

    //    " connection="+ connection.toString();

    return sToStr;
  }

  /*********************************************************************
   * private methods:  connection to ODBC databases
   ***********************************************************************/

  public String get64StringFrom32(String sString32)
  {
	  String sString64=  Sys.sAccess64DefaultString+sString32.substring(sString32.lastIndexOf("=")+1);
	  return sString64;
  }


  // establish a connection to a JDBC database, NO authentication
  protected boolean jdbcConnection(String sDriver, String strDatasource)
  {
    boolean retValue;

    retValue = true;
    if (strDatasource.length() == 0)
      strDatasource = Sys.sDefaultAccessMainString;
    try
    {

      //Load the JDBC Driver and register it.
      Class.forName(sDriver);
      // creates a database connection object using the DriverManager.getConnection method.
      connection = DriverManager.getConnection(strDatasource);

      // Sets the auto-commit property as whatever. By default it is true.
      connection.setAutoCommit(true);
    }
    catch (Exception ex)
    { //Trap SQL errors
      retValue = false;
      strConnectionError +=" -" + ex.toString() + " SRC=" + strDatasource;
      if (strDatasource.contains("izmado") || strDatasource.contains("odbc" ) )
      
      {
      try{
        	  Class.forName(sDriver=Sys.sAccess64Driver);
              connection = DriverManager.getConnection(strDatasource=get64StringFrom32(strDatasource));
              // Sets the auto-commit property as whatever. By default it is true.
              Sys.nJVMbits=64;
              connection.setAutoCommit(true);  
        	  strConnectionError="";
          }
          catch (Exception e2)
          {
        	  strConnectionError +=" 2nd try with UCanAccess-" + e2.toString() + " SRC 64=" + strDatasource;
                
          }  
      }
    }

    return retValue;
  }

  /**
   * boolean jdbcConnection:
       *  Creates a database connection object using a JDBC driver, a connection string
   *  and the username and password provided
   *
   * @param sDriver String
   * @param strDatasource String
   * @param sUserName String
   * @param sPassword String
   *
   * @return boolean
   */
  private boolean jdbcConnection(String sDriver, String strDatasource,
                                 String sUserName, String sPassword)
  {
    boolean retValue;

    retValue = true;
    if (strDatasource.length() == 0)
    	strDatasource = Sys.sDefaultAccessMainString;    
    try
    {
      Class.forName(sDriver);
      connection = DriverManager.getConnection(strDatasource, sUserName, sPassword);
      // Sets the auto-commit property as false. By default it is true.
      connection.setAutoCommit(true);
    }
    catch (Exception ex)
    { //Trap SQL errors
      retValue = false;
      strConnectionError +=" -" + ex.toString() + " SRC=" + strDatasource;
    }

    return retValue;
  }

  // reconnect the physical connection object
  public Connection dbReConnect()
  {
    bStatus = getConnection();
    return connection;
  }



  /**
   * Tests a given JDBC connection, whether it is alive
   * or not.
   * This test tries to fetch all user table names from the
   * database.
   * If all went fine, the method returns normally without
   * a return value, otherwise an exception will be thrown.
   *   *
   */
  public boolean testConnection()
  {

    DatabaseMetaData metaData = null;
    ResultSet rs = null;

    try
    {
      metaData = connection.getMetaData();
      // We only try to get the user table names
      String[] types ={"TABLE"};

      // Try to get the table names and ignore the result.
      // An exception will be thrown, if this operation fails.
      rs = metaData.getTables("", // Catalog
                              "", // Schema
                              "", // Tables ("%")
                              types); // Types
      bStatus=true;

    }
    catch (Exception sqle)
    {
      bStatus = false;
      if (strConnectionError.length()<1000)
        strConnectionError += " -"+ sqle.toString() + " SRC=" + this.sDatasource;
    }
    finally
    {
      try
      {
        rs.close();
      }
      catch (Exception e)
      {}
    }

  return bStatus;
  }

 public void close()
 {
	 try
	 {
		 connection.close();
	 }
	 catch (Exception e)
	 {
		 // do nothing
	 }
	 bTaken = false;
     bStatus = false;
     dSince = Calendar.getInstance();
     
 }
  
  public boolean getConnection()
  {
    boolean bConnectionMade = false;

    connection = null;
    // strConnectionError = "NO Error: Connected";

    boolean bAuthenticate = sUsername != null;
    if (bAuthenticate)
      bAuthenticate = sUsername.length() > 0;

    if (bAuthenticate)
      bConnectionMade = jdbcConnection(this.sDriver, this.sDatasource,
                                       this.sUsername, this.sPassword);
    else
      bConnectionMade = jdbcConnection(this.sDriver, this.sDatasource);
    return bConnectionMade;
  }

  public pooledConnection(String sDriver, String sDatasource, String sUsername,
                          String sPassword)
  {
    this.sDatasource = sDatasource;
    this.sDriver = sDriver;
    this.sUsername = sUsername;
    this.sPassword = sPassword;
    bTaken = true;
    bStatus = false;
    dSince = Calendar.getInstance();
    connection = null;
  }

}