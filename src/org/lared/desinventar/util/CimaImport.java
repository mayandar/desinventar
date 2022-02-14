package org.lared.desinventar.util;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.io.*;
import java.sql.*;
import java.net.*;
import java.util.ArrayList;
import java.util.HashMap;

import org.lared.desinventar.util.*;
import org.lared.desinventar.map.*;
import org.lared.desinventar.webobject.*;
import org.lared.desinventar.system.Sys;
import org.lared.desinventar.system.*;

public class CimaImport 
{
	static HashMap<String, country> hmCountries=new HashMap<String, country>();
	DICountry countrybean=new DICountry();


	public CimaImport() 
	{

	}


	private dbConnection openCountryDatabase(String sCountryCode)
	{

		dbConnection dbCon=null;
		// this is just a shortcut, easier to remember

		country co = hmCountries.get(sCountryCode);
		// opens the database 
		dbCon=new dbConnection(co.sdriver,co.sdatabasename, co.susername,co.spassword);
		return dbCon;
	}

	private boolean downloadXMLexport(String sCountryCode, String sTargetFolder) 
	{

		Retriever  retriever=new Retriever();
		// downloads the html page that forces the re-generation of the ZIP file
		boolean bOk=retriever.bCacheFileOK("https://www.desinventar.net/DesInventar/download_base.jsp?countrycode="+sCountryCode, sTargetFolder+"DI_export_page.html");

		// downloads the ZIP file itself
		if (bOk)
			bOk=retriever.bCacheFileOK("https://www.desinventar.net/DesInventar/download/DI_export_"+sCountryCode+".zip", sTargetFolder+"DI_export_"+sCountryCode+".zip");


		return bOk;
	}


	private void doImportToCimaServer(String sCountryCode) 
	{

		country co = hmCountries.get(sCountryCode);
		countrybean.init();
		countrybean.country=co;
		countrybean.countrycode=sCountryCode;
		countrybean.countryname=countrybean.country.scountryname;
		countrybean.dbType=co.dbType=co.ndbtype;

		// open country database
		dbConnection dbConn=openCountryDatabase(sCountryCode);

		Connection con=null;
		boolean bConnectionOK=dbConn.dbGetConnectionStatus();
		if (bConnectionOK)
		{	
			con=dbConn.dbGetConnection();
		}

		// if all is OK, proceed to import:
		if (bConnectionOK && con!=null)
		{
			System.out.println("[DI] database OK for "+sCountryCode);

			String sTargetFolder=co.getSjetfilename();
			sTargetFolder=sTargetFolder.replace('\\', '/');
			if (!sTargetFolder.endsWith("/"))
				sTargetFolder+="/";

			System.out.println("[DI] starting download of XML import data package for "+sCountryCode);

			// first obtain the export file from www.desinventar.net
			boolean downloadOK=downloadXMLexport(sCountryCode,sTargetFolder);

			if (downloadOK)
			{
				System.out.println("[DI] downloaded XML import OK for "+sCountryCode);

				// unzip it inside the country folder
				String sFilename=sTargetFolder+"DI_export_"+sCountryCode+".zip";				
				ZipUtil.unzip(sFilename, sTargetFolder);
				
				// if all is OK, clean up all database tables
				dbutils.cleanDatabase( con,   countrybean);

				System.out.println("[DI] cleaning database OK for "+sCountryCode);
				
				String sXMLFilename=sTargetFolder+"DI_export_"+sCountryCode+".xml";
				// import the XML file
				try {
					XmlReader Xml = new XmlReader(sXMLFilename);
					Xml.setOptions("Y", "Y","Y","Y","Y","Y","Y","Y","Y");
					Xml.setCountryCode (sCountryCode);
					try {
						System.out.println("[DI] starting parser of XML for "+sCountryCode);

						Xml.start(con,countrybean.dbType);					
					}
					catch (Exception exml)
					{
						System.out.println("[DI] Error 1 reported by XML importer:"+exml.toString());
					}
					
				}
				catch (Exception e)
				{
					System.out.println("[DI] Error 0 reported by XML importer:"+e.toString());
					
				}
			}
			// verify the paths of the map in the Level_Maps table
			System.out.println("[DI] verifying maps from import data package for "+sCountryCode);

			updateMapPaths(con);
			countrybean.getLevelsFromDB(con);
			// integrate the new maps
			MapUtil map = new MapUtil();
	    	map.regenerateRegions(con, countrybean.country.sjetfilename, countrybean);

		}

		// close all objects
		dbConn.close();

		System.out.println("[DI] IMPORT FINISHED - "+sCountryCode);

	}

	/**
	 * update the paths of the map in the Level_Maps (filename) table to match the current region directory (sjetfilename)
	 * 
	 * @param con the physical connection to the database
	 */
	private void updateMapPaths(Connection con) 
	{
		ResultSet rs=null;
		Statement st=null;
		// Database exists, see if it is a DI main database. 
		try
		{
			// test that country table exists!!!
			st=con.createStatement();
			rs=st.executeQuery("select * from level_maps order by map_level");
			// loads the entire list in memory.
			while (rs.next())
			{
				LevelMaps level=new LevelMaps();
				level.dbType=countrybean.dbType;
				level.loadWebObject(rs);
				String sMapPath=level.filename.replace('\\', '/');
				int pos=sMapPath.lastIndexOf('/');
				sMapPath=sMapPath.substring(pos+1);
				level.filename=countrybean.country.sjetfilename;
				level.filename=level.filename.replace('\\', '/');
				if (!level.filename.endsWith("/"))
					level.filename+="/";
				level.filename+=sMapPath;
				level.updateWebObject(con);
			}
		}
		catch (Exception eNotDI)
		{
			System.out.println("Exception reading Map Levels: "+eNotDI.toString()+" - path not updated! ");
		} 
		finally
		{
			try {rs.close();}	catch (Exception ecls1)	{}	
			try {st.close();}	catch (Exception ecls2)	{}
		}
	}

	/**
	 * Opens the MAIN DesInventar database, and if it is a DI dataset then loads the hashmap with all countries defined
	 * @return   True if the main database is accessible and is a DI database
	 */
	private static boolean openMainDatabase() 
	{
		// open main database and obtain the list of installed regions	
		dbConnection dbCon=null; 
		Connection con=null; 
		boolean bConnectionOK=false; 
		boolean bContainsDesInventar=false;

		// opens the database 
		Sys.getProperties();
		dbCon=new dbConnection();
		bConnectionOK = dbCon.dbGetConnectionStatus();
		if (bConnectionOK)
		{
			con=dbCon.dbGetConnection();
			ResultSet rs=null;
			Statement st=null;
			// Database exists, see if it is a DI main database. 
			try
			{
				// test that country table exists!!!
				st=con.createStatement();
				rs=st.executeQuery("select * from country order by scountryid");
				bContainsDesInventar=true;
				// loads the entire list in memory.
				while (rs.next())
				{
					country co=new country();
					co.loadWebObject(rs);
					hmCountries.put(co.scountryid, co);
				}
			}
			catch (Exception eNotDI)
			{
				System.out.println("Exception opening MAIN database: "+eNotDI.toString()+" - NOT PROCESSING!");
			} 
			finally
			{
				try {rs.close();}	catch (Exception ecls1)	{}	
				try {st.close();}	catch (Exception ecls2)	{}
			}
			dbCon.close();
		}
		else
		{
			System.out.println("[DI] error opening main database: "+dbCon.dbGetConnectionError());	

		}
		return bContainsDesInventar;
	}


	public  static void main(String[] args)
	{
		System.out.println("[DI] Starting automated XML importer");
		boolean bContainsDesInventar = openMainDatabase();

		if (args==null)
		{
			System.out.println("[DI] USAGE:   java -cp . org.lared.desinventar.util.CimaImporter countrycode  [countrycode] ...");
		}
		else
		{
			System.out.println("[DI] importer command line has "+args.length+ " parameters");	
		}
		
		if (!bContainsDesInventar)
		{
			System.out.println("[DI] Error opening main database or no countries defined ");				
		}
		
		// loop through country codes in command line
		if (args!=null && bContainsDesInventar)
			for (int j=0; j<args.length; j++)
			{
				// get code
				String sCountryCode=args[j];
				System.out.println("[DI] importer command line parameter:  "+args[j]);	

				// verify the code exists
				if (hmCountries.get(sCountryCode)!=null)
				{
					System.out.println("[DI] Importing country code "+sCountryCode);
					CimaImport ci=new CimaImport();
					ci.doImportToCimaServer(sCountryCode);
				}
			}	
	}



}
