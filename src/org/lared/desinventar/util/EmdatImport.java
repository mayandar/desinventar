package org.lared.desinventar.util;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.Date;
import java.util.HashMap;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.StringTokenizer;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

import java.io.*;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.*;

import org.lared.desinventar.webobject.*;
import org.lared.desinventar.system.Sys;

import org.json.JSONArray;
import org.json.JSONObject;

public class EmdatImport
{

	public HashMap<String,String> sLoadMap=new HashMap<String,String>();
	public boolean bDebug=true;

	public JspWriter out=null;

	fichas datacard=new fichas();
	extension extended=new extension();
	eventos tstEvent=new eventos();
	causas tstCausa=new causas();
	lev0 tstLev0=new lev0();
	lev1 tstlev1=new lev1();
	lev2 tstlev2=new lev2();

	int nEvents=0;
	int jRow=0;

	Connection con=null; 
	Statement stmt=null; 
	ResultSet rset=null;

	// improve. get JSON object from http://www.emdat.be/disaster_list/php/listDisasterGroups.php
	String[] saGroups={"Biological","Climatological","Complex Disasters","Geophysical","Hydrological","Meteorological","Technological"};

	// improve. get JSON from http://www.emdat.be/disaster_list/php/listRegions.php
	String[] saRegions={"Eastern Africa","Middle Africa","Northern Africa","Southern Africa","Western Africa","Caribbean",
			"Central America","Northern America","South America","Central Asia","Eastern Asia","South-Eastern Asia",
			"Southern Asia","Western Asia","Eastern Europe","Northern Europe","Russian Federation","Southern Europe",
			"Western Europe","Australia and New Zealand","Melanesia","Micronesia","Polynesia"};

    HashMap<String,String> hmCountries=new HashMap<String,String>();
    HashMap<String,String> hmCodes=new  HashMap<String,String>();
	
	public void setOut(JspWriter outstream)
	{
		out=outstream;
	}

	public void setDebug(boolean stat)
	{
		bDebug=stat;
	}

	public void debug(String sMessage)
	{
		System.out.println("DI9: "+sMessage);
		try
		{
			if (out!=null)
				out.println(sMessage+"<br/>");
		}
		catch (Exception e)
		{}
	}


	int getCheckboxValue(String sVal)
	{
		int nRet=datacard.extendedParseInt(sVal);
		if (nRet>0)
			nRet=0;
		return nRet;
	}

	int getCheckboxValue(int nRet)
	{
		if (nRet>=0)
			nRet=0;
		else
			nRet=-1;
		return nRet;
	}

	int getInt(String sTok)
    {
    return webObject.extendedParseInt(sTok);
    }

    double getDouble(String sTok)
    {
    return webObject.extendedParseDouble(sTok);
    }

    public void extendedParseDate(String strNumber)
	{

		int y=0,m=0,d=0;
		try
		{ 

			if (strNumber == null)
			{	  
				java.util.Date uDate=new java.util.Date();
				strNumber=datacard.formatter.format(uDate);
			}
			// hopefully dates will come as yyyy-MM-dd, but may come in any other format. This will heuristically identify Y M D components
			strNumber=strNumber.replace('/','-');

			int pos=strNumber.indexOf("-");
			String s1=strNumber.substring(0,pos);
			strNumber=strNumber.substring(pos+1);
			pos=strNumber.indexOf("-");
			String s2=strNumber.substring(0,pos);
			strNumber=strNumber.substring(pos+1);
			int n1=webObject.extendedParseInt(s1);
			int n2=webObject.extendedParseInt(s2);
			int n3=webObject.extendedParseInt(strNumber);
			if (n1>31) // this is the year
			{
				y=n1;
				if (n2>12) // this is the day
				{
					d=n2;
					m=n3;
				}
				else if (n3>12)
				{
					d=n3;    			  
					m=n2;
				}
				else // default Y M D.  TODO: Improve this to get the local setting
				{
					m=n2;
					d=n3;
				}
			}
			else if (n3>31) // case either DMY or MDY (n3 is the year)
			{
				y=n3;
				if (n1>12) // this is the day
				{
					d=n1;
					m=n2;
				}
				else if (n2>12)
				{
					d=n2;    			  
					m=n1;
				}
				else // assumes DMY, European standard. TODO: Improve this to get the local setting
				{
					d=n1;
					m=n2;
				}

			}
			else if (n2>31) // Strange case with the year in the middle
			{
				y=n2;
				if (n1>12) // this is the day
				{
					m=n3;
					d=n1;
				}
				else if (n3>12)
				{
					m=n1;
					d=n3;    			  
				}
				else // assumes M Y D
				{
					m=n2;
					d=n3;
				}

			}
			else // no number seems to be the year: Assummes MDY
			{
				if (n1>12) // this is the day
				{
					d=n1;
					m=n2;
					y=n3;
				}
				else if (n3>12)
				{
					d=n3;    			  
					m=n2;
					y=n1;
				}
				else // assumes M D Y
				{
					m=n1;
					d=n2;
					y=n3;
				}    		  
			}
			if (y<100)
				y+=1900;
		}
		catch (Exception e)
		{
		}
		datacard.fechano=y;
		datacard.fechames=m;
		datacard.fechadia=d;
	}



	String removeAccents(String strParameter)
	{
		int pos=0;	
		String sReturn=strParameter.toUpperCase();
		String sAccents =     "ÁÉÍÓÚÀÈÌÒÙÂÊÎÔÛ";
		String sReplaceWith = "AEIOUAEIOUAEIOU";

		for (int j=0; j<sReturn.length(); j++)
		{
			if ((pos=sAccents.indexOf(sReturn.charAt(j)))>=0)
				sReturn=sReturn.replace(sAccents.charAt(pos), sReplaceWith.charAt(pos));
		}
		return sReturn;
	}

	 public int calcDays(java.util.Date date, java.util.Date date2) 
	 {

	        double theCalcDays = (double) ((date.getTime() - date2.getTime()) / (1000.0 * 60 * 60 * 24));
	        return (int) Math.round(theCalcDays);

	    }


	public void LoadDatacard(String sLine, DICountry countrybean)
	{
		// {"success":true,"data":[{"start_date":"0\/0\/1981","end_date":"0\/0\/1983","country_name":"Algeria","location":"","dis_type":"Drought","dis_subtype":"Drought","killed":"0","total_affected":"0","total_dam":"0","disaster_no":"1981-9118"},
        //		                   {"start_date":"0\/8\/1994","end_date":"0\/8\/1994","country_name":"Algeria","location":"","dis_type":"Wildfire","dis_subtype":"Forest fire","killed":"22","total_affected":"0","total_dam":"0","disaster_no":"1994-0306"},...
		
		int pos=0;

		datacard.dbType=countrybean.dbType;
		extended.dbType=countrybean.dbType;

		try {

			JSONObject obj = new JSONObject(sLine);

			JSONArray arr = obj.getJSONArray("data");
			// browse them in descending order so to get the background first
			for (int i = 0; i<arr.length(); i++)
			{

				jRow++;
				if (jRow % 100 ==0)
					debug("Processing Row "+jRow);

			datacard.init();


			datacard.serial=arr.getJSONObject(i).getString("disaster_no"); //String.valueOf(jRow); 

			String sEndDate= arr.getJSONObject(i).getString("end_date");
			this.extendedParseDate(sEndDate);
			Calendar calEnd= new GregorianCalendar();
			calEnd.set(datacard.fechano, datacard.fechames, datacard.fechadia);

			
			String sDecimalDate= arr.getJSONObject(i).getString("start_date");
			this.extendedParseDate(sDecimalDate);
			Calendar calStart= new GregorianCalendar();
			calStart.set(datacard.fechano, datacard.fechames, datacard.fechadia);

			datacard.duracion= calcDays(calEnd.getTime(), calStart.getTime());
			
			datacard.evento=arr.getJSONObject(i).getString("dis_type");
			datacard.descausa=arr.getJSONObject(i).getString("dis_subtype") + " "+ arr.getJSONObject(i).getString("associated_dis2");
			
			datacard.name0=arr.getJSONObject(i).getString("country_name");
			datacard.level0=arr.getJSONObject(i).getString("iso");
			if (datacard.level0==null ||  datacard.level0.length()==0)
				datacard.level0=hmCountries.get(datacard.name0);
			if (datacard.level0==null)
				datacard.level0=datacard.name0;	

			datacard.lugar=arr.getJSONObject(i).getString("location");
			datacard.fuentes="EM-DAT: The OFDA/CRED International Disaster Database – www.emdat.be, Université Catholique de Louvain, Brussels (Belgium)";
			datacard.di_comments=arr.getJSONObject(i).getString("event_name") + "   ["+ arr.getJSONObject(i).getString("dis_mag_scale")+ ": "+arr.getJSONObject(i).getString("dis_mag_scale")+ "]";

			datacard.muertos=getInt(arr.getJSONObject(i).getString("total_deaths"));
			datacard.afectados=getInt(arr.getJSONObject(i).getString("total_affected"));
			datacard.valorus=getDouble(arr.getJSONObject(i).getString("total_dam"));
			datacard.valorloc=getDouble(arr.getJSONObject(i).getString("insured_losses"));

			datacard.latitude=getDouble(arr.getJSONObject(i).getString("latitude"));
			datacard.longitude=getDouble(arr.getJSONObject(i).getString("longitude"));

			datacard.fechapor="DI-importer";
			datacard.fechafec="28-08-2014";

			datacard.glide=datacard.serial;

			// checkboxes, no negative values
			datacard.hay_muertos=getCheckboxValue(datacard.muertos);
			datacard.hay_afectados=getCheckboxValue(datacard.afectados);
			datacard.muertos=Math.max(0,datacard.muertos);
			datacard.afectados=Math.max(0,datacard.afectados);
			datacard.valorus=Math.max(0,datacard.valorus);
			 


			// Test and import events 
			tstEvent.nombre=datacard.not_null(datacard.evento);
			if (tstEvent.nombre.length()>=30)
				tstEvent.nombre=tstEvent.nombre.substring(0,30);
			int nr=tstEvent.getWebObject(con);
			if (nr==0)
			{
				tstEvent.serial=++nEvents;
				tstEvent.nombre_en=removeAccents(tstEvent.nombre);
				tstEvent.nombre=tstEvent.nombre_en;
				tstEvent.addWebObject(con);
				debug("Added [ev]: "+tstEvent.nombre);
			}

			// Test and import Geography  

			tstLev0.lev0_cod=datacard.level0;
			nr=tstLev0.getWebObject(con);
			if (nr==0)
			{
				tstLev0.lev0_name=datacard.name0;
				tstLev0.lev0_name_en=tstLev0.lev0_name;
				tstLev0.addWebObject(con);
			}


			datacard.checkLengths();
			int nrows=datacard.addWebObject(con);
			if (nrows==0)
				debug("Not added - DC:"+datacard.lastError);
			// adds corresponding extended datacard
			extended.clave_ext=datacard.clave;
			extended.checkLengths();
			nrows=extended.addWebObject(con); 
			if (nrows==0)
				debug("Not added - EX:"+datacard.lastError);
				

			}// for each JSON array entry
		
		}
		catch (Exception DCloading)
		{
			debug("Error importing DI8  FAKE EXCEL loading datacard: "+DCloading.toString());

		}

	}


	private String openURL(String sUrl) 
	{
		String sContent="";
		URL urlActual=null;
		boolean ok=true;

		//System.setProperty("sun.net.spi.nameservice.provider.0", "dns,sun");
		//System.setProperty("sun.net.spi.nameservice.nameservers", "80.10.246.130,81.253.149.10");


		try { 
			System.out.println("Connecting to Host..." + sUrl);
			urlActual = new URL(sUrl);
		}
		catch (MalformedURLException ioe)
		{
			System.out.println("ERROR: [bad URL]" + ioe.getMessage());
			ok = false;
		}


		if (ok)
			try
		{
				StringBuffer o_data=new StringBuffer();

				BufferedReader in = new BufferedReader(new InputStreamReader(urlActual.openStream()));

				String inputLine;

				try
				{
					while ((inputLine = in.readLine()) != null)
						o_data.append(inputLine);		        
					in.close();
				}
				catch (IOException e)
				{
					System.out.println("TRANSFER ERROR: reading URL...");
				}
				sContent=o_data.toString();

		}
		catch (IOException ioe)
		{
			// System.out.println("ERROR [OpenStream]:" + ioe.getMessage() + " | " +ioe.toString());
			sContent= "ERROR [OpenStream]:" + ioe.getMessage() + " | " +ioe.toString();
			ok = false;
		}
		return sContent;
	}

	
	public void cleanDatabase(Connection con)
	{
		
		try{
			stmt=con.createStatement();
		}
		catch (Exception e)
		{
			System.out.println(e.toString());
		}
		try{
			stmt.executeUpdate("delete from extensiontabs");
			stmt.executeUpdate("drop table extension");
			stmt.executeUpdate("CREATE TABLE extension (clave_ext int NOT NULL)");
			stmt.executeUpdate("ALTER TABLE extension ADD CONSTRAINT PK_extension PRIMARY KEY (clave_ext)");   
			stmt.executeUpdate("ALTER TABLE extension ADD CONSTRAINT FK_extension_fichas FOREIGN KEY (clave_ext) REFERENCES fichas (clave)"); 
			stmt.executeUpdate("delete from wordsdocs");
			stmt.executeUpdate("delete from words");
			stmt.executeUpdate("delete from fichas");
			stmt.executeUpdate("delete from diccionario");
			stmt.executeUpdate("delete from eventos");				
			stmt.executeUpdate("delete from regiones");
			stmt.executeUpdate("delete from lev2");
			stmt.executeUpdate("delete from lev1");
			stmt.executeUpdate("delete from lev0");
		} 
		catch (Exception e)	
		{  
			System.out.println(e.toString());		
		}
	}

	

	public void doImport(DICountry countrybean)
	{

		try{
			boolean bConnectionOK=false; 
			// opens the database 
			dbConnection dbCon=new dbConnection(countrybean.country.sdriver,countrybean.country.sdatabasename,
					countrybean.country.susername,countrybean.country.spassword);
			bConnectionOK = dbCon.dbGetConnectionStatus();

			if (bConnectionOK)
			{	
				con=dbCon.dbGetConnection();
				cleanDatabase(con);

				// now it should read the names of the levels. 

				try{
					int jRow=1;
					int jRegion=0;
					int jGroup=0;
					
					
					//  These may give al sort of complaints because of the certificate, etc. Not worth th eeffort.
					// take the URL and manually download the text file, name it country_list.txt
					// put it in the EMDAT database folder
					// String sURL="https://www.emdat.be/emdat_db/php/util/listCountries.php";				
					// String sJsonData=openURL(sURL);
		
					String strFileName=countrybean.country.sjetfilename+"/country_list.txt";
					String sJsonData=load_text_file(strFileName);

					
					
					JSONObject obj = new JSONObject(sJsonData);
					JSONArray arr = obj.getJSONArray("data");
					// browse them in descending order so to get the background first
					for (int i = 0; i<arr.length(); i++)
					{
						String sIsoCode=arr.getJSONObject(i).getString("iso");
						String sCountry=arr.getJSONObject(i).getString("country_name");
						
						hmCountries.put(sCountry, sIsoCode);
						hmCodes.put(sIsoCode, sCountry);

						tstLev0.lev0_cod=sIsoCode;
						tstLev0.lev0_name=sCountry;
						tstLev0.lev0_name_en=sCountry;
						tstLev0.addWebObject(con);
					}

/*
					for (jRegion=0; jRegion<saRegions.length; jRegion++)
						for (jGroup=0; jGroup<saGroups.length; jGroup++)
						{
							sURL="http://www.emdat.be/disaster_list/php/search.php?group="+saGroups[jGroup]+"&region="+saRegions[jRegion];
							sURL=sURL.replace(' ', '+');
							sJsonData=openURL(sURL);
							this.LoadDatacard(sJsonData, countrybean);

						} 
*/

					// These may give al sort of complaints because of the certificate, etc. Not worth th eeffort.
					// get the URL using Chrome, and manually download the text file, name it disaster_list.txt
					// put it in the EMDAT database folder
					// sURL="https://www.emdat.be/emdat_db/php/disaster_list/search.php?_dc=1541320101736&continent=Africa%27&%27Americas%27&%27Asia%27&%27Europe%27&%27Oceania&region=&iso=&from=1900&to=2018&sgroup=Biological%27&%27Climatological%27&%27Extra-terrestrial%27&%27Geophysical%27&%27Hydrological%27&%27Meteorological&type=&options=associated_dis&associated_dis2&total_deaths&total_affected&total_dam&insured_losses&page=1&start=0&limit=25";
					// sURL=sURL.replace(' ', '+');
					// sJsonData=openURL(sURL);

					strFileName=countrybean.country.sjetfilename+"/disaster_list.txt";
					sJsonData=load_text_file(strFileName);
					this.LoadDatacard(sJsonData, countrybean);


				}
				catch (Exception e)
				{
					debug ("Exception loading: "+e.toString());
				}
				// removes the entry from tips - it will not show real data
				CountryTip.getInstance().remove(countrybean.countrycode);
				stmt.close();	    		
				//-----------------------------------
				dbCon.close();
			} // if (bConnection...
		}
		catch (Exception eImp)
		{
			System.out.println("DI9: error importing DI8 FAKE EXCEL: "+eImp.toString());
		}

	}

	/**
	 * @param countrybean
	 */
	private String load_text_file(String strFileName) 
	{
		String sScript="";
		File f=new File(strFileName);
		if (f.exists())
		{
			try{

				//FileReader javaIn = new FileReader(f);  				
				BufferedReader javaIn = new BufferedReader(new InputStreamReader(new FileInputStream(strFileName),"UTF-8"));
				int nSize = (int) f.length();
				char[] cBuffer = new char[nSize];
				int nRead = javaIn.read(cBuffer, 0, nSize);
				sScript=new String(cBuffer);

			    System.out.println("[DI9] PROCESSING TEXT FILE: " + strFileName + " Size= " + nSize + "  read=" + nRead);
				javaIn.close();
			}
			catch (Exception e4)
			{
			}
		}
		return sScript;
	}
	/**
	 * @param args
	 */
	public static void main(String[] args) 
	{

		DICountry countrybean= new DICountry();

		try{
			
			dbConnection dbDefaultCon=new dbConnection();
			boolean bdConnectionOK = dbDefaultCon.dbGetConnectionStatus();
			Connection pc_connection=null;
			if (bdConnectionOK)
			{
				pc_connection=dbDefaultCon.dbGetConnection();
			}  // opening dB!!
			else
			{
				System.out.println ("Exception DI Import. opening main database..."+dbDefaultCon.dbGetConnectionError());
			}

			Statement stat = pc_connection.createStatement();
			ResultSet rs = stat.executeQuery("select * from country where scountryid in ('WO4')");
			while (rs.next())
			{
				countrybean.country.loadWebObject(rs);
				countrybean.countrycode=countrybean.country.scountryid;
				countrybean.countryname=countrybean.country.scountryname;
				countrybean.country.dbType=countrybean.dbType=countrybean.country.ndbtype;
				countrybean.setLanguage("EN");
				System.out.println("Importing: "+countrybean.countrycode+" - "+countrybean.countryname+ " from "+countrybean.country.sjetfilename);		    	

				EmdatImport diLoader=new EmdatImport();
				diLoader.doImport(countrybean);

			}
		}
		catch (Exception eImp)
		{
			System.out.println("DI9: error importing DI8 FAKE EXCEL: "+eImp.toString());
		}

	}

}
