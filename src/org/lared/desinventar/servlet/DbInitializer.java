package org.lared.desinventar.servlet;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.lared.desinventar.map.BufferedImageFactory;
import org.lared.desinventar.map.MapUtil;
import org.lared.desinventar.system.Sys;
import org.lared.desinventar.util.FileCopy;
import org.lared.desinventar.util.dbConnection;
import org.lared.desinventar.util.dbutils;
import org.lared.desinventar.webobject.country;

public class DbInitializer 
                             extends HttpServlet
{

	public String getServletInfo()
	{
		return "DesInventar Database Startup servlet";
	}

	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException
	{
	}

	/** Initialisation method called on server startup
	 */
	public void init() 
	{

		//Database Connection Objects
		dbConnection dbcDatabase; // country database
		dbConnection dbmDatabase; // main database
		Connection con = null;
		Connection m_connection = null;
		boolean bConnectionMade;
		String strConnectionError;

		String sSql; // string holding SQL statement
		Statement stmt=null; // Main SQL statement object
		ResultSet rset=null; // Main SQL resultset

		
		int retCode = 0; // return code from account object methods
		String sCountryCode = "";
		String sGeoCode = "";
		int nLevel = 0;
		int nCodes = 0;
		String sTable, sName, sCode, sParent;

		ServletContext sc = getServletConfig().getServletContext();
		String sVirtualServer=getServletContext().getInitParameter("properties");
		if (null!=sVirtualServer && sVirtualServer.length()>0)
			Sys.getProperties(sVirtualServer);
		else
			Sys.getProperties();

		BufferedImageFactory.getFactoryInstance().initiate();
		String sProgFiles=null;
		try{
			 sProgFiles=System.getenv("ProgramFiles");
			 if (sProgFiles!=null)
				 sProgFiles=sProgFiles.substring(0,13);
		}
		catch (Exception ei){}		
		if (sProgFiles==null)
			sProgFiles="Program Files";
		if (Sys.iDatabaseType==Sys.iAccessDb && Sys.sDataBaseName.indexOf(sProgFiles)>0)
		{
			// move Access main database out of program files, to /etc/desinventar
			File fEtcFolder=new File("/etc");
			try{fEtcFolder.mkdir();} catch (Exception e){}
			fEtcFolder=new File("/etc/desinventar");
			try{fEtcFolder.mkdirs();} catch (Exception e){}
			boolean bEtcOK=(fEtcFolder.exists()&& fEtcFolder.isDirectory());
			if (bEtcOK)
			{
				String sBasePath= "/etc/desinventar/desinventar.mdb";
				String sSourcePath=Sys.sDataBaseName.substring(Sys.sDataBaseName.lastIndexOf("=")+1);
				if (sSourcePath.endsWith(";"))
					sSourcePath=sSourcePath.substring(0,sSourcePath.length()-1);
				boolean bTrasfered=true;
				try {
					FileCopy.copy(sSourcePath,sBasePath);
				} 
				catch (IOException e) {
					bTrasfered=false;
				}
				if (bTrasfered)
				{
					// before doing it, saves the properties file..
					Sys.sDataBaseName = Sys.sDefaultAccessMainString;
					Sys.sDbDriverName = Sys.sAccessODBCDriver; 
					Sys.saveProps();
					System.out.println("DI9: WARNING: Main database moved from Program Files to \\etc\\desinventar folder..");
				}
			}

		}

		System.out.println("DI9: Initializing Database pool, updating datamodels if required..");

		// for debugging process.
		// try {Thread.sleep(5000);}	catch (Exception e)	{}

		// gets a connection from the pool; this should initialise  it!!			
		dbmDatabase = new dbConnection();
		bConnectionMade = dbmDatabase.dbGetConnectionStatus();
		// Gets the country parameters in order to open its database;
		if (bConnectionMade)
		{
			try{
				con = dbmDatabase.dbGetConnection();
				// transfer of the MAP DATABASE regiones table!!!	

				// if the previous line query works, then we have a DI database...
				dbutils.applyModelMigration(con, Sys.iDatabaseType, sc.getRealPath("scripts/main"));

				// Query the account name & password
				country aCountry=new country();	      
				sSql = "select * from country";
				stmt = con.createStatement ();
				rset = stmt.executeQuery(sSql);
				while (rset.next())
				{
					// Query the account name & password
					try
					{
						aCountry.loadWebObject(rset);
						aCountry.dbType=aCountry.ndbtype;
						// Now, gets a connection for the country from the pool!!!
						dbcDatabase = new dbConnection(aCountry.sdriver,aCountry.sdatabasename,aCountry.susername,aCountry.spassword);
						bConnectionMade = dbcDatabase.dbGetConnectionStatus();
						// processes the function
						if (bConnectionMade)
						{
							m_connection = dbcDatabase.dbGetConnection();
							// Verify and update the data model
							System.out.println("[DI9]: Processing country: "+aCountry.scountryid+" - "+aCountry.scountryname);
							Statement st=m_connection.createStatement();
							ResultSet rs=null;
							try{
								rs=st.executeQuery("select lev0_cod from lev0");
								// if the previous line query works, then we have a DI database...

								// The following two removed - should be moved to somewhere else, maybe an option in Adminpages. Taking TOO long to start some DBs
								// st.executeUpdate("insert into extension (clave_ext) select clave as clave_ext from fichas where clave not in (select clave_ext from extension)");
								// st.executeUpdate("delete from extension where clave_ext not in (select clave from fichas)");

								dbutils.updateDataModelRevision(dbcDatabase, aCountry.ndbtype, sc.getRealPath("scripts"));
							}
							catch (Exception eNotDI)
							{
								System.out.println("[DI9] error, database not initialized.");	
							}
							finally
							{
								try{rs.close();}catch(Exception eIgn){}
								try{st.close();}catch(Exception eIgn){}
							}
							dbcDatabase.close();
						}
					}
					catch (Exception e)
					{
						System.out.println("DI9: Exception[1]: " + e.toString());
					}
				}	
				stmt.close();
			}
			catch (Exception e)
			{
				System.out.println("DI9: Exception[1]: " + e.toString());
			}
			// these will actually fail once these dbTypes are already there
			try
			{
				stmt=con.createStatement();
				stmt.executeUpdate("insert into DbTypes (DBType ,DbTypeDescription) values (6,'Derby')");
				stmt.executeUpdate("insert into DbTypes (DBType ,DbTypeDescription) values (7,'SQLite')");

			}
			catch (Exception eIgnore)
			{ // ignore 	 
			}
			finally{
				try{rset.close();} catch (Exception ex){}			
				try{stmt.close();} catch (Exception ex){}			
			}
			dbmDatabase.close();
			dbmDatabase.resetPool();
		}
	}


}
