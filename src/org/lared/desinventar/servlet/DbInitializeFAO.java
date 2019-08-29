package org.lared.desinventar.servlet;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
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
import org.lared.desinventar.webobject.MetadataElement;
import org.lared.desinventar.webobject.MetadataElementCosts;
import org.lared.desinventar.webobject.MetadataElementIndicator;
import org.lared.desinventar.webobject.MetadataElementLang;
import org.lared.desinventar.webobject.country;

public class DbInitializeFAO 
{


	/** Initialisation method called on server startup
	 */
	public static void main(String[] args) 
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

		Sys.getProperties();

		System.out.println("DI9: Initializing Database pool, adding FAO data.");


		// gets a connection from the pool; this should initialise  it!!
		dbmDatabase = new dbConnection();
		bConnectionMade = dbmDatabase.dbGetConnectionStatus();
		// Gets the country parameters in order to open its database;
		if (bConnectionMade)
		{
			try{
				m_connection = dbmDatabase.dbGetConnection();
				country aCountry=new country();	      
				// cycle over all countries
				sSql = "select * from country";
				stmt = m_connection.createStatement ();
				rset = stmt.executeQuery(sSql);
				while (rset.next())
				{
					// Query the country metadata tables
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
							con = dbcDatabase.dbGetConnection();
							// Verify and update the data model
							System.out.println("[DI9]: Processing country: "+aCountry.scountryid+" - "+aCountry.scountryname);
							Statement st=m_connection.createStatement();
							ResultSet rs=null;
							MetadataElement metaElement=new MetadataElement();
							metaElement.init();
							metaElement.dbType=aCountry.dbType;
							MetadataElementIndicator metaElementIndicator=new MetadataElementIndicator();
							MetadataElementLang metalang=new MetadataElementLang();
							int indicator_key=1;
							try{
								rs=st.executeQuery("select * from  metadata_default_items where metadata_country='"+aCountry.scountryid.toUpperCase()+"'");
								while (rs.next()) 
								{
									metaElement.metadata_element_key=rs.getInt("metadata_element_key");
									indicator_key=rs.getInt("metadata_indicator");
									// verifies it does not have it already
									metaElement.metadata_country=aCountry.scountryid.toLowerCase();
									int nRows=metaElement.getWebObject(con);
									if (nRows<1)  // does not exist in country
									{
										metaElement.metadata_element_key=rs.getInt("metadata_element_key");
										// gets the model from @@@
										metaElement.metadata_country="@@@";
										nRows=metaElement.getWebObject(con);
										// saves it in the country space
										if (nRows>0)
										{
											metaElement.metadata_country=aCountry.scountryid.toLowerCase();
											metaElement.addWebObject(con);
											// with the same indicator
											metaElementIndicator.indicator_key=indicator_key;
											metaElementIndicator.metadata_element_key=metaElement.metadata_element_key;
											metaElementIndicator.metadata_country=metaElement.metadata_country;
											metaElementIndicator.addWebObject(con);
											
											// copies all translations to this country
											Statement stmt2=con.createStatement();
											ResultSet rset2=stmt2.executeQuery("select * from metadata_element_lang where metadata_country='@@@' and metadata_element_key="+metaElement.metadata_element_key);
											while (rset2.next())
												{
												metalang.loadWebObject(rset2);
												metalang.metadata_country=metaElement.metadata_country;
												metalang.addWebObject(con);
												}
											dbutils.generateMetadataExtensions(con,metaElement);
											
										}
									}
									
								}


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
						}

					dbcDatabase.close();
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
