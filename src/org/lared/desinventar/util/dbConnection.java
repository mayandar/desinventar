package org.lared.desinventar.util;

import java.sql.*;
import java.util.*;
import org.lared.desinventar.system.*;

public class dbConnection
{
  // *** Connection pool Singleton ********************
  public static Vector<pooledConnection> vPool = null;

  // ****** Database Connection Object ******
  public pooledConnection m_connection;

  /*****************************************************************
   * class interface (public) methods
   ******************************************************************/

  // gets the string with last error description
  public String dbGetConnectionError()
  {
    if (m_connection!=null)
      return m_connection.strConnectionError;
    else
      return "NOT CONECTED...";
  }

  // returns true if the connection is OK
  public boolean dbGetConnectionStatus()
  {
    return m_connection.bStatus;
  }

  // returns the physical connection object
  public Connection dbGetConnection()
  {
    return m_connection.connection;
  }

  // reconnect the physical connection object
  public Connection dbReConnect()
  {
    m_connection.bStatus = m_connection.getConnection();
    return m_connection.connection;
  }

  public Connection validateConnectionStatus()
  {
  if (!m_connection.testConnection())
    return  dbReConnect();
  else
    return m_connection.connection;
  }



// Releases the connection to the pool
  public void close()
  {
    m_connection.bTaken = false;
  }

  /*****************************************************************
   * Connection Pool managment methods
   ******************************************************************/

  public static String dumpStatus()
  {
    int j;
    String sRet = "";
    if (vPool == null)
      sRet = "NO POOL<br>";
    else
    {
      sRet = "CONNECTION POOL: " + vPool.size() + " connections allocated <br>";
      sRet +="<table border=1 cellspacing=0 cellpadding=2>";
      for (j = 0; j < vPool.size(); j++)
      {
        sRet += ( (pooledConnection) vPool.elementAt(j)).toString();
      }
      sRet +="</table>";
    }

    return sRet;
  }
  
  /*
   * This methods is designed to physicaly close all connections to the same database
   * so that the DataModel Upgrade process and Extension manager have all table locks 
   * released and is able to perform changes to the tables 
   */
  public void closeAllConnections()
  {
	  String strDataSource=m_connection.sDatasource;
	  String strUsername=m_connection.sUsername;
	  
	  pooledConnection pConn;
	  
      // looks for all available or not connections to the same datasource
	  int j;
      for (j = 0; j < vPool.size(); j++)
      {
        if ( ( (pooledConnection) vPool.elementAt(j)).sDatasource.equals(strDataSource)
             && ( (pooledConnection) vPool.elementAt(j)).sUsername.equalsIgnoreCase(strUsername))
	      { // got one free connection to that datasource
        	pConn = (pooledConnection) vPool.elementAt(j);
        	try{
        		pConn.connection.close();
        		pConn.bStatus=pConn.getConnection();
        	}
        	catch (Exception e)
        	{
        		System.out.println("dbConnection: closing all:" +e.toString());
        	}
	      }
      }

  }

  public static void resetPool()
  {
    int j;
    if (vPool != null)
    {
      for (j = 0; j < vPool.size(); j++)
      {
        try
        {
          ( (pooledConnection) vPool.elementAt(j)).connection.close();
        }
        catch (Exception e) {}
      }
     vPool=null;
    }

  }



  public static void checkPoolConnectionStatus()
  {
    int j;
    if (vPool != null)
    {
      for (j = 0; j < vPool.size(); j++)
      {
        if ( ( (pooledConnection) vPool.elementAt(j)).testConnection())
          ( (pooledConnection) vPool.elementAt(j)). dbReConnect();
      }
    }
  }

  /** 
   * Returns the name of the local directory based on the results of a call to getClassName() 
   * 
   * @param none 
   * @return Name of directory that contains the executing class 
   */ 
  public String getLocalDirName() 
  { 

     //Use that name to get a URL to the directory we are executing in 
     String localDirName; 
     //Open a URL to the class file 
     java.net.URL myURL = this.getClass().getResource("dbConnection.class"); 

     //Clean up the URL and make a String with absolute path name 
     localDirName = myURL.getPath();  //Strip path to URL object out 
     localDirName = myURL.getPath().replaceAll("%20", " ");  //change %20 chars to spaces 
     //Get the current execution directory 
     localDirName = localDirName.substring(0,localDirName.lastIndexOf("/"));  //clean off the file name 
     if (localDirName.startsWith("/"))
    	 localDirName=localDirName.substring(1);

     return localDirName; 
  } 


  /*****************************************************************
   * class constructors
   ******************************************************************/

//  private static synchronized void sdbConnection(String strDriver,
	private synchronized  void sdbConnection(String strDriver,
                                                 String strDataSource,
                                                 String strUsername,
                                                 String strPassword,
                                                 dbConnection thisConn)
  {
    int j;
    int nCon = -1;

    if (vPool == null)
    { // the pool is empty, initializes it, gets a conn returns it
      vPool = new Vector<pooledConnection>(36);
      // before allocating any connection, IZMADO driver must be loaded. As this is only for 
      // Windows machines, this code is within a try catch with no error management
      try
      {
    	  com.inzoom.adojni.DllInit.runRoyaltyFree(643225952);
      }
      catch (Exception eIgnored)
      {
    	  String xErr=eIgnored.toString();
    	  //System.out.println("[DI9] Exception loading IZMADO:"+xErr);
      }
      catch (Error eIgnored)
      {
    	  String xErr=eIgnored.toString();
    	  //System.out.println("[DI9] Err loading IZMADO:"+xErr);
      }
      catch (Throwable eIgnored)
      {
    	  String xErr=eIgnored.toString();
    	  //System.out.println("[DI9] THROWABLE Err loading IZMADO:"+xErr);
      }

      thisConn.m_connection = new pooledConnection(strDriver, strDataSource, strUsername, strPassword);
      thisConn.m_connection.bStatus = thisConn.m_connection.getConnection();
      vPool.add(thisConn.m_connection);
    }
    else
    {
      // looks for idle connections. Max idle time=4 minutes...
      java.util.Calendar  dNow = Calendar.getInstance();
      dNow.add(Calendar.MINUTE , -4);
      for (j = 0; j < vPool.size(); j++)
      {
       if (( (pooledConnection) vPool.elementAt(j)).bTaken && ( (pooledConnection) vPool.elementAt(j)).bStatus)
        if (dNow.after(( (pooledConnection) vPool.elementAt(j)).dSince ))
        {
          ( (pooledConnection) vPool.elementAt(j)).bTaken=false;
        }
      }
      // looks for an available connection to the same datasource
      for (j = 0; (j < vPool.size()) && (nCon < 0); j++)
      {
        if ( ( (pooledConnection) vPool.elementAt(j)).sDatasource.equals(strDataSource)
             && ( (pooledConnection) vPool.elementAt(j)).sUsername.equalsIgnoreCase(strUsername)
             && !( (pooledConnection) vPool.elementAt(j)).bTaken)
          nCon = j;
      }
      if (nCon >= 0)
      { // got one free connection to that datasource
        ( (pooledConnection) vPool.elementAt(nCon)).bTaken = true;
        ( (pooledConnection) vPool.elementAt(nCon)).dSince = Calendar.getInstance();
        thisConn.m_connection = (pooledConnection) vPool.elementAt(nCon);
      }
      else
      {
        // allocates a new connection
        thisConn.m_connection = new pooledConnection(strDriver, strDataSource,
            strUsername, strPassword);
        thisConn.m_connection.bStatus = thisConn.m_connection.getConnection();
        vPool.add(thisConn.m_connection);
      }
    }
  }

  // allocates the connection, taking care of assigning defaults if driver or strdatasoure are missing,
  // but using whatever is passes for username & password allowing this way authenticated or not connections
  public dbConnection(String strDriver, String strDataSource,
                      String strUsername, String strPassword)
  {
    if (strDriver.length()==0)
      strDriver=Sys.sDbDriverName;
    if (strDataSource.length()==0)
      strDataSource=Sys.sDataBaseName;
    sdbConnection(strDriver, strDataSource, strUsername, strPassword, this);
  }

  // allocates the connection, no authentication
  public dbConnection(String strDriver, String strDataSource)
  {
    sdbConnection(strDriver, strDataSource, "", "", this);
  }

  // allocates the connection, which is assumed to be authenticated-less, using the default driver
  public dbConnection(String strDataSource)
  {
    sdbConnection(Sys.sDbDriverName, strDataSource, "", "", this );  // ???Sys.sDbUserName, Sys.sDbPassword, this);
  }

  // default constructor needed for the Singleton...
  public dbConnection()
  {
    // use all defaults!!!
    sdbConnection(Sys.sDbDriverName, Sys.sDataBaseName, Sys.sDbUserName,
                  Sys.sDbPassword, this);
  }



  public static  void  main (String [] args)
  {
    Sys.getProperties();

    // test default connection
    dbConnection dbTest=new dbConnection();
    if (dbTest.dbGetConnectionStatus())
    {
       System.out.println("Status OK...");
       System.out.println("Reported status:"+dbTest.dbGetConnectionError());
       Connection con=dbTest.dbGetConnection();
       if (con==null)
         System.out.println("Status OK, but connection null!!!???");
       System.out.println(dbConnection.dumpStatus());
       dbTest.close();
    }
    else
    {
      System.out.println("Status NOT OK...");
      System.out.println("Reported error:"+dbTest.dbGetConnectionError());
    }

    dbConnection dbTest1=new dbConnection("com.mysql.jdbc.Driver","jdbc:mysql://localhost/inventfl?autoReconnect=true&maxReconnects=99&initialTimeout=1&relaxAutocommit=true"
                                           // ?user=" + sDbUserName + "&password=" + sDbPassword +
                                          ,"root","robotsearch");
    System.out.println(dbConnection.dumpStatus());
    dbConnection dbTest2=new dbConnection("sun.jdbc.odbc.JdbcOdbcDriver","jdbc:odbc:inventpe","","");
    System.out.println(dbConnection.dumpStatus());
    dbConnection dbTest3=new dbConnection("sun.jdbc.odbc.JdbcOdbcDriver","jdbc:odbc:inventco","","");
    System.out.println(dbConnection.dumpStatus());
    dbTest3.close();
    System.out.println(dbConnection.dumpStatus());
    dbConnection dbTest5=new dbConnection("oracle.jdbc.driver.OracleDriver","jdbc:oracle:thin:@127.0.0.1:1521:ROBOT2","desinventar","password");
    System.out.println(dbConnection.dumpStatus());
    dbConnection dbTest4=new dbConnection("oracle.jdbc.driver.OracleDriver","jdbc:oracle:thin:@192.168.0.1:1521:ROBOT","desinventar","password");
    System.out.println(dbConnection.dumpStatus());
    dbTest5.validateConnectionStatus();
    System.out.println(dbConnection.dumpStatus());


  }
  
}