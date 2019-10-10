package org.lared.desinventar.system;

import java.io.*;
import java.sql.*;
import java.util.*;

public class Sys
{
  // PROPERTIES OF THE SYSTEM
  private static Properties pSystemProps = null;
  public static int nJVMbits=32;  // default for DI
  
  // CONSTANT: Properties file name. HARDCODED, MUST EXIST IN THE SERVER's FILE SYSTEM
  public static String strPropertiesFile = "/etc/desinventar/desinventar.properties";
  // External MS Access driver default connection strings
  public static String sAccess64DefaultString="jdbc:ucanaccess://";
  public static String sDefaultIZMADOString="jdbc:izmado:Provider=Microsoft.Jet.OleDB.4.0;data source=";
  public static String sDefaultODBCtring="jdbc:odbc:Driver={Microsoft Access Driver (*.mdb)};DriverID=22;READONLY=false;DBQ=";
  
  public static String sDefaultAccessString=sDefaultIZMADOString+"c:/databases/COUNTRY/inventXXX.mdb;";
  public static String sDefaultAccessMainString=sDefaultIZMADOString+"/etc/DesInventar/DesInventar.mdb;";

  public static String sAccess64Driver=	"net.ucanaccess.jdbc.UcanaccessDriver";                       
  public static String sAccessIzmadoDriver="com.inzoom.jdbcado.Driver";
  public static String sAccessODBCDriver="sun.jdbc.odbc.JdbcOdbcDriver";
  
  // -------------------------------------------------------------------------------
  // DATABASE CONSTANTS
  // 0-> Oracle
  // 1-> ODBC no username/password (MS ACCESS);
  // 2-> MS SQL;
  // 3-> MySQl
  // 4-> ODBC Generic (using username/password)
  // 5-> Type 4 Generic JDBC driver, with username & password
  // -------------------------------------------------------------------------------

  public static final int iOracleDb = 0; // oracle
  public static final int iAccessDb = 1; // ODBC, no username/password normally access
  public static final int iMsSqlDb = 2; // SQL server, using JTurbo driver
  public static final int iMySqlDb = 3; // My SQL
  public static final int iODBCDb = 4; // ODBC username/password.
  public static final int iPostgress = 5; // Postgress
  public static final int iDerbyDb = 6; // Postgress
  public static final int iSqliteDb = 7; // Postgress
  public static final int iJDBCwAuth = 8; // JDBC with username/password.
  public static final String[] strDatabaseType =
      {
      "Oracle",
      "MS ACCESS NO AUTH.",
      "MS SQL Server",
      "MySQL",
      "MS ACCESS - AUTH",
      "PostgreSQL",
      "Derby",
      "SQLite",
      "JDBC/Generic AUTH"
  };

//-----------------------------------------------------------------------------------------------------------------
// this code is platform independent and have been tested in:
  public static String strPlatform = "Windows/Linux/HP UX/SUN Solaris 8";
//-----------------------------------------------------------------------------------------------------------------

//  This system can run without login by Anonimous user  
//  NOTE: this is provided initially as false to allow anonimous to enter and setup the system
//        in the case of a pubicly run environment, or symply open when run in a private worstation 
  public static boolean bRequireLogin=false;
  
//-----------------------------------------------------------------------------------------------------------------
  // THIN/THICK JDBC DRIVERS DATABASE CONSTANTS
  // Database default dbname
  public static String sDataBaseName = sDefaultAccessMainString;
  // DesInventar main user/schema/database (depending on DB platform)
  static public String sDbUserName = "";
  // default password
  static public String sDbPassword = "";
  // maximum connections to be allocated in pool
  static public String sMaxConnections = "250";
  // Connection pool file name
  static public String sDbPoolLogFile = "/etc/desinventar/connection.log";
  // type of database
  public static int iDatabaseType = iAccessDb;
  // JDBC DRIVERS FOR DATABASE
  public static String sDbDriverName = sAccess64Driver; // 64 bit direct - no authentication (MS Access)

  //----------------------------------------------------------------------------------------------------------------
  // oracle.jdbc.driver.OracleDriver    // Oracle
  // "com.inzoom.jdbcado.Driver"        // IZMADO direct - no authentication (MS Access)
  // "sun.jdbc.odbc.JdbcOdbcDriver"     // ODBC Bridge
  // "com.ashna.jturbo.driver.Driver"   // SQL Server- JTURBO Drivers
  // "com.microsoft.jdbc.sqlserver.SQLServerDriver"   // SQL Server- Microsoft Drivers
  // "com.mysql.jdbc.Driver"            // MySQL
  // "sun.jdbc.odbc.JdbcOdbcDriver"     // ODBC with authentication
  // "jdbc.typeIV.driver.noauth"        // JDBC generic no authentication
  // "jdbc.typeIV.driver.auth"          // JDBC generic with authentication

  // JDBC-ODBC bridge: "jdbc:odbc:ODBC_DATASOURCE_NAME"
  //                   "jdbc:odbc:inventco"
  // MS ACCESS,64 Ucan "jdbc:ucanaccess://path_to_DesInventar.mdb;"; 
  // Oracle driver:    "jdbc:oracle:thin:@IP_OF_SERVER:PORT:SID
  // Oracle localhost: "jdbc:oracle:thin:@127.0.0.1:1521:ORCL"
  //                   "jdbc:oracle:thin:@"+sServerIp+":"+sServerPort+":"+sDataBaseName
  // SQLServer JTURBO: "jdbc:JTurbo://IP_OF_SERVER:PORT/DATABASENAME/sql70=true"
  // MS SQL SERVER:    "jdbc:microsoft:sqlserver://SERVER:1433","username","password";
  // SQLServer acerra: "jdbc:JTurbo://127.0.0.1:1433/desinventar/sql70=true"
  //                   "jdbc:JTurbo://"+sServerIp+":"+sServerPort+"/"+sDataBaseName+"/sql70=true"
  //                                        ,"jdbc:odbc:"+sDataBaseName
  // MYSQL jdbc driver:"jdbc:mysql://"+sDataBaseName+"?user=" + sDbUserName + "&password=" + sDbPassword +
  //                    "&autoReconnect=true&maxReconnects=99&initialTimeout=1&relaxAutocommit=true"
  // PostgreSQL       :"jdbc:postgresql://localhost:port/databasename"

  //-----------------------------------------------------------------------------------------------------------------

// OTHER PROPERTIES OF THE SYSTEM:

  // mail server constants
  static public String sMailUserName = "desinventar";
  static public String sMailPassword = "password";
  public static String sMailInServerIp = "localhost";
  public static String sMailOutServerIp = "localhost";
  public static String sMailInServerPort = "110";
  public static String sMailOutServerPort = "25";
  public static String sMailInProtocol = "POP3";
  public static String sMailOutProtocol = "SMTP";

  // -------------------------------------------------------------------------------
  // DIRECTORIES  REQUIRED IN THE ENVIRONMENT
  // -------------------------------------------------------------------------------

  // prefix to all template files, dependent on the file system
  public static String strFilePrefix = "/desinventar";
  // drive prefix to all files, dependent on the file system
  public static String strAbsPrefix = "";
  // Absolute WEB APP DIRECTORY
  public static String sDefaultDir = "/desinventar";
  // Directory for mail daemon
  public static String strMailDir = "/desinventar";

  public static String sLastError = "";

  public static String sGoogleKey="ABQIAAAAhd44-6kCwRi5MmbzS9iplRT2yXp_ZAY8_ufC3CFXhHIE1NvwkxTAgprKkxYALJMxLqtTkIj7RlOcPg";

  
  public static boolean bForceLoading = getProperties();

  public Sys()
  {
    getProperties();
  }

  public static void saveProps()
  {
    pSystemProps.put("platform", strPlatform);
    pSystemProps.put("db.type", Integer.toString(iDatabaseType));
    pSystemProps.put("db.name", sDataBaseName);
    pSystemProps.put("db.username", sDbUserName);
    pSystemProps.put("db.password", sDbPassword);
    pSystemProps.put("db.logfile", sDbPoolLogFile);
    pSystemProps.put("db.maxconnections", sMaxConnections);
    pSystemProps.put("db.driver", sDbDriverName);
    pSystemProps.put("template.prefix", strFilePrefix);
    pSystemProps.put("absolute.prefix", strAbsPrefix);
    pSystemProps.put("default.directory", sDefaultDir);
    pSystemProps.put("mail.directory", strMailDir);
    pSystemProps.put("mail.user", sMailUserName);
    pSystemProps.put("mail.password", sMailPassword);
    pSystemProps.put("mail.in.IP", sMailInServerIp);
    pSystemProps.put("mail.out.IP", sMailOutServerIp);
    pSystemProps.put("mail.in.port", sMailInServerPort);
    pSystemProps.put("mail.out.port", sMailOutServerPort);
    pSystemProps.put("mail.in.protocol", sMailInProtocol);
    pSystemProps.put("mail.out.protocol", sMailOutProtocol);
    pSystemProps.put("RequireLogin", Boolean.toString(bRequireLogin));
    pSystemProps.put("GoogleKey", sGoogleKey);
    try
    {
        File fEtcFolder=new File("/etc");
		try{fEtcFolder.mkdir();} catch (Exception e){}
    	fEtcFolder=new File("/etc/desinventar");
		try{fEtcFolder.mkdirs();} catch (Exception e){}
	    boolean bEtcOK=(fEtcFolder.exists()&& fEtcFolder.isDirectory());
        if (bEtcOK)
        	{
        	FileOutputStream fosPropFile = new FileOutputStream(strPropertiesFile);
        	pSystemProps.store(fosPropFile, "System Properties");
        	fosPropFile.close();
        	}    	
    }
    catch (Exception eio)
    {
      sLastError = "Error loading/resaving properties: " + eio.toString();
    }

  }

  public static void loadProps()
  {
    strPlatform = not_null(pSystemProps.getProperty("platform"));
    iDatabaseType = extendedParseInt(pSystemProps.getProperty("db.type"));
    sDataBaseName = not_null(pSystemProps.getProperty("db.name"));
    sDbUserName = not_null(pSystemProps.getProperty("db.username"));
    sDbPassword = not_null(pSystemProps.getProperty("db.password"));
    sMaxConnections = not_null(pSystemProps.getProperty("db.maxconnections"));
    sDbDriverName = not_null(pSystemProps.getProperty("db.driver"));
    sDbPoolLogFile = not_null(pSystemProps.getProperty("db.logfile"));
    strFilePrefix = not_null(pSystemProps.getProperty("template.prefix"));
    strAbsPrefix = not_null(pSystemProps.getProperty("absolute.prefix"));
    sDefaultDir = not_null(pSystemProps.getProperty("default.directory"));
    strMailDir = not_null(pSystemProps.getProperty("mail.directory"));
    sMailUserName = not_null(pSystemProps.getProperty("mail.user"));
    sMailPassword = not_null(pSystemProps.getProperty("mail.password"));
    sMailInServerIp = not_null(pSystemProps.getProperty("mail.in.IP"));
    sMailOutServerIp = not_null(pSystemProps.getProperty("mail.out.IP"));
    sMailInServerPort = not_null(pSystemProps.getProperty("mail.in.port"));
    sMailOutServerPort = not_null(pSystemProps.getProperty("mail.out.port"));
    sMailInProtocol = not_null(pSystemProps.getProperty("mail.in.protocol"));
    sMailOutProtocol = not_null(pSystemProps.getProperty("mail.out.protocol"));
    bRequireLogin = strToBool(pSystemProps.getProperty("RequireLogin"));
    sGoogleKey= not_null(pSystemProps.getProperty("GoogleKey"));
    if (sGoogleKey.length()==0)
    	sGoogleKey="ABQIAAAAhd44-6kCwRi5MmbzS9iplRT2yXp_ZAY8_ufC3CFXhHIE1NvwkxTAgprKkxYALJMxLqtTkIj7RlOcPg";
  }

  
  public static boolean getProperties(String sPropFile)
  {
	  strPropertiesFile=sPropFile;
	  return getProperties();
  }
  
  
  public static boolean getProperties()
  {
    FileInputStream fisPropFile = null;

    pSystemProps = new Properties();
    try
    {
      fisPropFile = new FileInputStream(strPropertiesFile);
      // System.out.println("[Di9] getting properties from "+strPropertiesFile);
    }
    catch (java.io.FileNotFoundException  eEtc)
    {
      // properties not found. Create the file in ./
      // saveProps();
      fisPropFile = null;
    }
    if (fisPropFile != null)
    {
      try
      {
        pSystemProps.load(fisPropFile);
        loadProps();
        fisPropFile.close();
        // save any new property...
        /**  COMMENTED TO AVOID RE-CREATION OF PROP FILE */ 
        // saveProps();
      }
      catch (Exception eLoad)
      {
        sLastError = "Error loading/resaving properties: " + eLoad.toString();
      }

    }
    return (fisPropFile == null);
  }

//--------------------------------------------------------------------------------
// generic routines to avoid exceptions when loading null (NEW!)property strings...
// These are copies of similar found in webObject & htmlServer, to keep this module
// Application-independent
//--------------------------------------------------------------------------------
static String not_null(String strParameter)
 {
   return (strParameter == null)?"":strParameter;
 }

static boolean strToBool(String strParameter)
  {
    boolean bRet=false;
    if (strParameter != null)
      return (strParameter.equalsIgnoreCase("Y") || 
      		strParameter.equalsIgnoreCase("true"));
    return bRet;
  }

//--------------------------------------------------------------------------------
// generic routine to parse strings...
//--------------------------------------------------------------------------------
public static int extendedParseInt(String strNumber)
{
  int j = 0;
  String strDigits;

  if (strNumber != null)
      try
      {
      	strNumber=strNumber.trim();
        if (strNumber.length() > 0)
          return Integer.parseInt(strNumber);
        else
          return 0;
      }
      catch (Exception e)
      {
        j = 0;
      }
  return j;
}


}