package org.lared.desinventar.util;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.HashMap;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.StringTokenizer;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

import java.io.*;
import java.sql.*;

import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.lared.desinventar.webobject.*;
import org.lared.desinventar.system.Sys;

public class Di8ImportFakeExcel
{

	public HashMap<String,String> sLoadMap=new HashMap();
	public boolean bDebug=true;

	public JspWriter out=null;
	
	HSSFRow row=null;
	fichas datacard=new fichas();
	extension extended=new extension();

	Connection con=null; 
	Statement stmt=null; 
	ResultSet rset=null;
	
	regiones Region=new regiones();
	HashMap<String, regiones> hmGeo=new HashMap<String, regiones>();
	HashMap<String, regiones> hmGeoName=new HashMap<String, regiones>();
	
	FileInputStream htmlFile =null;
	InputStreamReader javaIn=null;
	BufferedReader lnReader=null;
    String sLine="";
    
	
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
	    	  
	    	  if (strNumber.length()<10)
	    		  strNumber+="-0-0-0";
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
	    		  else // assumes MDY, north american starndard. TODO: Improve this to get the local setting
	    		  {
	    			  d=n2;
	    			  m=n1;
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


    String getString(String sTok)
    {
    	if (sTok.startsWith("\""))
    	{
    		sTok=sTok.substring(1,sTok.length()-1);
    	}
    return sTok;
    }
	  
    int getInt(String sTok)
    {
    	if (sTok.startsWith("\""))
    	{
    		sTok=sTok.substring(1,sTok.length()-1);
    	}
    return webObject.extendedParseInt(sTok);
    }

    double getDouble(String sTok)
    {
    	if (sTok.startsWith("\""))
    	{
    		sTok=sTok.substring(1,sTok.length()-1);
    	}
    return webObject.extendedParseDouble(sTok);
    }

    private String sCSV_TokenBuffer="";
    
    private void startCSVStringTokenizer(String sLine)
    {
    	sCSV_TokenBuffer=new String(sLine);
    }
	
    String stk_nextToken()
    {
    	int pos=0;
    	int start=0;
    	String sRet="";
    	try{
    		
        boolean eof=false;
        String eot="\t";
        	if (sCSV_TokenBuffer.charAt(0)=='\"')
            	{
        		eot="\"\t";
        		start=1;
            	}
    	pos=sCSV_TokenBuffer.indexOf(eot,start);	
    	while (pos<=0 && !eof)
    	{
   			String sNewLine=lnReader.readLine(); // next line of data
   			if (sNewLine==null)
   				eof=true;
   			else
   				sCSV_TokenBuffer+=sNewLine; 
   	    	pos=sCSV_TokenBuffer.indexOf(eot,start);	
    	}
    		
     	if (pos>0)
    		sRet=sCSV_TokenBuffer.substring(0,pos+eot.length()-1);
     	
    	if (pos+eot.length()<sCSV_TokenBuffer.length())
    		sCSV_TokenBuffer=sCSV_TokenBuffer.substring(pos+eot.length());
    	else
    		sCSV_TokenBuffer="";
    	}
    	catch (Exception ign)
    	{
    		System.out.print("[DI9]it was here...");
    	}
    	return sRet;
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
    
    public void LoadDatacard(String sLine, DICountry countrybean)
	{
		// 	"Serial"	"Start date"	"Type of event"	"Geography Name"	"Place"	"Sources"	"Observations about the effects"	"Deaths"	"Missing"	"Wounded; sick"	"Victims"	"Affected"	"Evacuees"	"Relocated"	"Homes destroyed"	"Homes affected"	"Crops and woods (Hectares)"	"Routes affected"	"Educational centres"	"Health centres"	"Livestock"	"Loss value $"	"Loss value US$"	"Other losses"	"Transport"	"Communications"	"Aid organisation installations"	"Agriculture and livestock"	"Aqueduct"	"Sewerage"	"Education"	"Energy"	"Industry"	"Health"	"Other"	"Duration"	"Magnitude"	"Type of cause"	"Observations about the cause"	"Geo-Code"	"Latitude"	"Longitude"	"Author"	"Creation date"	"Updated"	"Observation about the event"	"DisasterId"
    	int pos=0;
		try {
			
			startCSVStringTokenizer(sLine);
			
			datacard.serial=getString(stk_nextToken());
			
			String sDecimalDate=getString(stk_nextToken());
			this.extendedParseDate(sDecimalDate);
			datacard.evento=getString(stk_nextToken());
			datacard.name0=getString(stk_nextToken());
			datacard.lugar=getString(stk_nextToken());
			// 	"Sources"	"Observations about the effects"	"Deaths"	"Missing"	"Wounded; sick"	"Victims"	"Affected"	"Evacuees"	"Relocated"	"Homes destroyed"	"Homes affected"	"Crops and woods (Hectares)"	"Routes affected"	"Educational centres"	"Health centres"	"Livestock"	"Loss value $"	"Loss value US$"	"Other losses"	"Transport"	"Communications"	"Aid organisation installations"	"Agriculture and livestock"	"Aqueduct"	"Sewerage"	"Education"	"Energy"	"Industry"	"Health"	"Other"	"Duration"	"Magnitude"	"Type of cause"	"Observations about the cause"	"Geo-Code"	"Latitude"	"Longitude"	"Author"	"Creation date"	"Updated"	"Observation about the event"	"DisasterId"
			datacard.fuentes=getString(stk_nextToken());
			datacard.di_comments=getString(stk_nextToken());
			
			datacard.muertos=getInt(stk_nextToken());
			datacard.desaparece=getInt(stk_nextToken());
			datacard.heridos=getInt(stk_nextToken());
			datacard.damnificados=getInt(stk_nextToken());
			// 	"Affected"	"Evacuees"	"Relocated"	"Homes destroyed"	"Homes affected"	"Crops and woods (Hectares)"	"Routes affected"	"Educational centres"	"Health centres"	"Livestock"	"Loss value $"	"Loss value US$"	"Other losses"	"Transport"	"Communications"	"Aid organisation installations"	"Agriculture and livestock"	"Aqueduct"	"Sewerage"	"Education"	"Energy"	"Industry"	"Health"	"Other"	"Duration"	"Magnitude"	"Type of cause"	"Observations about the cause"	"Geo-Code"	"Latitude"	"Longitude"	"Author"	"Creation date"	"Updated"	"Observation about the event"	"DisasterId"
			datacard.afectados=getInt(stk_nextToken());
			datacard.evacuados=getInt(stk_nextToken());
			datacard.reubicados=getInt(stk_nextToken());
			datacard.vivdest=getInt(stk_nextToken());
			datacard.vivafec=getInt(stk_nextToken());
			datacard.nhectareas=getDouble(stk_nextToken());
			// 	"Routes affected"	"Educational centres"	"Health centres"	"Livestock"	"Loss value $"	"Loss value US$"	"Other losses"	"Transport"	"Communications"	"Aid organisation installations"	"Agriculture and livestock"	"Aqueduct"	"Sewerage"	"Education"	"Energy"	"Industry"	"Health"	"Other"	"Duration"	"Magnitude"	"Type of cause"	"Observations about the cause"	"Geo-Code"	"Latitude"	"Longitude"	"Author"	"Creation date"	"Updated"	"Observation about the event"	"DisasterId"
			datacard.kmvias=getDouble(stk_nextToken());
			datacard.nescuelas=getInt(stk_nextToken());
			datacard.nhospitales=getInt(stk_nextToken());
			datacard.cabezas=getInt(stk_nextToken());			
			datacard.valorloc=getDouble(stk_nextToken());
			datacard.valorus=getDouble(stk_nextToken());
			// 	"Other losses"	"Transport"	"Communications"	"Aid organisation installations"	"Agriculture and livestock"	"Aqueduct"	"Sewerage"	"Education"	"Energy"	"Industry"	"Health"	"Other"	"Duration"	"Magnitude"	"Type of cause"	"Observations about the cause"	"Geo-Code"	"Latitude"	"Longitude"	"Author"	"Creation date"	"Updated"	"Observation about the event"	"DisasterId"
			datacard.otros=getString(stk_nextToken());
			datacard.transporte=getCheckboxValue(getInt(stk_nextToken()));
			datacard.comunicaciones=getCheckboxValue(getInt(stk_nextToken()));
			datacard.socorro=getCheckboxValue(getInt(stk_nextToken()));

			//"Agriculture and livestock"	"Aqueduct"	"Sewerage"	"Education"	"Energy"	"Industry"	"Health"	"Other"	"Duration"	"Magnitude"	"Type of cause"	"Observations about the cause"	"Geo-Code"	"Latitude"	"Longitude"	"Author"	"Creation date"	"Updated"	"Observation about the event"	"DisasterId"
			datacard.agropecuario=getCheckboxValue(getInt(stk_nextToken()));
			datacard.acueducto=getCheckboxValue(getInt(stk_nextToken()));
			datacard.alcantarillado=getCheckboxValue(getInt(stk_nextToken()));
			datacard.educacion=getCheckboxValue(getInt(stk_nextToken()));
			datacard.energia=getCheckboxValue(getInt(stk_nextToken()));
			datacard.industrias=getCheckboxValue(getInt(stk_nextToken()));
			datacard.salud=getCheckboxValue(getInt(stk_nextToken()));
			
			//"Other"	"Duration"	"Magnitude"	"Type of cause"	"Observations about the cause"	"Geo-Code"	"Latitude"	"Longitude"	"Author"	"Creation date"	"Updated"	"Observation about the event"	"DisasterId"
			datacard.hay_otros=getCheckboxValue(stk_nextToken());
			datacard.duracion=getInt(stk_nextToken());
			datacard.magnitud2=getString(stk_nextToken());
			datacard.causa=getString(stk_nextToken());
			datacard.descausa=getString(stk_nextToken());			
			// missing level codes will have to be determined dynamically...
			datacard.name1="";
			datacard.name2="";
			if((pos=datacard.name0.indexOf("/"))>=0)
				{
				datacard.name1=datacard.name0.substring(pos+1);
				datacard.name0=datacard.name0.substring(0,pos);
				}
			if((pos=datacard.name1.indexOf("/"))>=0)
				{
				datacard.name2=datacard.name1.substring(pos+1);
				datacard.name1=datacard.name1.substring(0,pos);
				}			
			datacard.level0="";
			datacard.level1="";
			datacard.level2="";
			if (datacard.name2.length()>0)
				{
				datacard.level2=getString(stk_nextToken());
				datacard.level1=datacard.level2.substring(0, Math.min(datacard.level2.length(),countrybean.anLevelsLen[1]));
				datacard.level0=datacard.level1.substring(0, Math.min(datacard.level1.length(),countrybean.anLevelsLen[0]));
				}
			else if (datacard.name1.length()>0)
				{
				datacard.level1=getString(stk_nextToken());			
				datacard.level0=datacard.level1.substring(0, Math.min(datacard.level1.length(),countrybean.anLevelsLen[0]));
				}
			else 
				datacard.level0=getString(stk_nextToken());
            // now lookup for all codes
			if (datacard.level2.length()>0)
			{
			if (hmGeo.get(datacard.level2)==null)
				{
				Region=new regiones();
				Region.codregion=datacard.level2;
				Region.nivel=2;
				Region.nombre=datacard.name2;
				Region.lev0_cod=datacard.level1;
				hmGeo.put(datacard.level2, Region);
	        	hmGeoName.put("2-"+Region.nombre, Region);
				}
			else
				{
				datacard.level1=hmGeo.get(datacard.level2).lev0_cod;	
				}
			 }
			
		  if (datacard.level1.length()>0)
			{
			Region=new regiones();
			Region.codregion=datacard.level1;
			Region.nivel=1;
			Region.nombre=datacard.name1;
			Region.lev0_cod=datacard.level0;
			if (hmGeo.get(datacard.level1)==null)
				{
				datacard.level0=Region.lev0_cod;
				hmGeo.put(datacard.level1, Region);
				if (datacard.name1.length()>0)
		        	hmGeoName.put("1-"+Region.nombre, Region);
				}
			else
				{
				datacard.level0=hmGeo.get(datacard.level1).lev0_cod;
				if (datacard.level0.length()==0)
					datacard.level0=Region.lev0_cod;
				if (datacard.name1.length()==0)
					datacard.name1=hmGeo.get(datacard.level1).nombre;
				else{
		        	hmGeoName.put("1-"+Region.nombre, Region);
					if (hmGeo.get(datacard.level1).nombre.length()==0)
						{
						Region=hmGeo.get(datacard.level1);
						Region.nombre=datacard.name1;
						hmGeo.put(datacard.level1, Region);
						}
					}
				}
			}
/*
  		  else
		  {
			  if (datacard.name1.length()>0)
				  if (hmGeoName.get("1-"+datacard.name1)!=null)
					  datacard.level1=hmGeoName.get("1-"+datacard.name1).codregion;
		  
		  }
*/
		  if (datacard.level0.length()>0)
		  {
			Region=new regiones();
			Region.codregion=datacard.level0;
			Region.nivel=0;
			Region.nombre=datacard.name0;
			Region.lev0_cod="";
			if (hmGeo.get(datacard.level0)==null)
				{
				hmGeo.put(datacard.level0, Region);				
				if (datacard.name0.length()>0)
		        	hmGeoName.put("0-"+Region.nombre, Region);
				}
			else
				{
				if (datacard.name0.length()==0)
					datacard.name0=hmGeo.get(datacard.level0).nombre;
				else {
		        	hmGeoName.put("0-"+Region.nombre, Region);					
					if (hmGeo.get(datacard.level0).nombre.length()==0)
						{
						Region=hmGeo.get(datacard.level0);
						Region.nombre=datacard.name0;
						hmGeo.put(datacard.level0, Region);
						}
					}
				}
			  
		  }
 /*
		  else
		  {
			  if (datacard.name0.length()>0)
				  if (hmGeoName.get("0-"+datacard.name0)!=null)
					  datacard.level0=hmGeoName.get("0-"+datacard.name0).codregion;
		  
		  }
*/

			  


			//"Latitude"	"Longitude"	"Author"	"Creation date"	"Updated"	"Observation about the event"	"DisasterId"
			datacard.latitude=getDouble(stk_nextToken());
			datacard.longitude=getDouble(stk_nextToken());	
			datacard.fechapor=getString(stk_nextToken());
			datacard.fechafec=getString(stk_nextToken());
			stk_nextToken(); // Updated is ignored			
			datacard.di_comments+=" "+getString(stk_nextToken());		

			//"DisasterId"
			datacard.uu_id=getString(stk_nextToken());	
			
			// datacard.glide=getString("glide"));
			
			// checkboxes
			datacard.hay_muertos=getCheckboxValue(datacard.muertos);
			datacard.hay_heridos=getCheckboxValue(datacard.heridos);
			datacard.hay_deasparece=getCheckboxValue(datacard.desaparece);
			datacard.hay_afectados=getCheckboxValue(datacard.afectados);
			datacard.hay_vivdest=getCheckboxValue(datacard.vivdest);
			datacard.hay_vivafec=getCheckboxValue(datacard.vivafec);
			datacard.hay_damnificados=getCheckboxValue(datacard.damnificados);
			datacard.hay_evacuados=getCheckboxValue(datacard.evacuados);
			datacard.hay_reubicados=getCheckboxValue(datacard.reubicados);		
			// non-normalized form of DI8:  (one day they will read about Normalized form 3 or higher....) 
			datacard.muertos=Math.max(0,datacard.muertos);
			datacard.heridos=Math.max(0,datacard.heridos);
			datacard.desaparece=Math.max(0,datacard.desaparece);
			datacard.afectados=Math.max(0,datacard.afectados);
			datacard.vivdest=Math.max(0,datacard.vivdest);
			datacard.vivafec=Math.max(0,datacard.vivafec);
			datacard.damnificados=Math.max(0,datacard.damnificados);
			datacard.evacuados=Math.max(0,datacard.evacuados);
			datacard.reubicados=Math.max(0,datacard.reubicados);
			datacard.valorloc=Math.max(0,datacard.valorloc);
			datacard.valorus=Math.max(0,datacard.valorus);
			datacard.nhospitales=Math.max(0,datacard.nhospitales);
			datacard.nescuelas=Math.max(0,datacard.nescuelas);
			datacard.nhectareas=Math.max(0,datacard.nhectareas);
			datacard.cabezas=Math.max(0,datacard.cabezas);
			datacard.kmvias=Math.max(0,datacard.kmvias);

		}
		catch (Exception DCloading)
		{
			debug("Error importing DI8  FAKE EXCEL loading datacard: "+DCloading.toString());
			
		}

	}

    public void loadGeography()
    {
    	try{
    	stmt.execute("update regiones set nombre_en=nombre where nombre_en is null or nombre_en=''");
    	rset=stmt.executeQuery("select * from regiones order by codregion");
    	while (rset.next())
    		{
    		Region.loadWebObject(rset);
    		hmGeo.put(Region.codregion, Region);
    		//  ADD: hmGeoName.put(Region.nombre_en, Region);
    		}
    	}
		catch (Exception eImp)
		{
			System.out.println("DI9: error importing DI8 FAKE EXCEL: "+eImp.toString());
		}
   	
    }
	
	public void doImport(String sFileName, DICountry countrybean)
	{
		
		try{
			
		    
			eventos tstEvent=new eventos();
			causas tstCausa=new causas();
			lev0 tstLev0=new lev0();
			lev1 tstlev1=new lev1();
			lev2 tstlev2=new lev2();

			datacard.dbType=countrybean.dbType;
			extended.dbType=countrybean.dbType;
			dbutils.createTranslations();
			
			boolean bConnectionOK=false; 
			// opens the database 
			dbConnection dbCon=new dbConnection(countrybean.country.sdriver,countrybean.country.sdatabasename,
			                      	countrybean.country.susername,countrybean.country.spassword);
			bConnectionOK = dbCon.dbGetConnectionStatus();

			if (bConnectionOK)
				{	
				con=dbCon.dbGetConnection();
				stmt=con.createStatement();


				// now it should read the names of the levels. 
				countrybean.getLevelsFromDB(con);
				extended.loadExtension(con, countrybean);
				
				loadGeography();

		    	try{
			    	boolean bImportEvents=false; // request.getParameter("events")!=null;
			    	boolean bImportGeo=false; // request.getParameter("geography")!=null;
			    	boolean bImportCauses=false; // request.getParameter("causes")!=null;
		    		int jRow=1;
		    		
		            htmlFile = new FileInputStream(sFileName);
		            javaIn=new InputStreamReader(htmlFile, "UTF-8");
		            lnReader=new BufferedReader(javaIn);
		            System.out.println("opened input as UTF-8 stream..."+sFileName);
		            
		            sLine=lnReader.readLine();  // this should bring the header
		            sLine=lnReader.readLine(); // first line of data
		    	    while (sLine!=null)
		    	    {		jRow++;
		    	    		if (jRow % 100 ==0)
		    	    			debug("Processing Row "+jRow);
		    	    		
		    	    		datacard.init();
		    				datacard.serial=String.valueOf(datacard.getSequence("fichas_seq", con));
		    	    		LoadDatacard(sLine, countrybean);
		    	    		
		    	    		// Test and import events 
		    		    	 tstEvent.nombre=datacard.not_null(datacard.evento);
		    		    	 if (tstEvent.nombre.length()>=30)
		    		    		 tstEvent.nombre=tstEvent.nombre.substring(0,30);
		    		    	 int nr=tstEvent.getWebObject(con);
		    		    	 if (nr==0)
		    		    	 	{
		    		    		 tstEvent.serial=tstEvent.getMaximum("serial", "eventos", con)+1;
		    		    		 tstEvent.nombre_en=removeAccents(tstEvent.nombre);
		    		    		 if (dbutils.htEventEnglish.get(tstEvent.nombre_en)!=null)
		    		    			 tstEvent.nombre_en=dbutils.htEventEnglish.get(tstEvent.nombre_en);
		    		    		 else
			    		    		 tstEvent.nombre_en=tstEvent.nombre;
		    		    		 tstEvent.addWebObject(con);
		    		    		 debug("Added [ev]: "+tstEvent.nombre);
		    	    		    }

		    	    		// Test and import events causes
		    	        	 tstCausa.causa=datacard.causa;
		    		    	 if (tstCausa.causa.length()>25)
		    		    		 tstCausa.causa=tstCausa.causa.substring(0,25);
		    		    	 if (tstCausa.causa.length()>0){
		    		    		 nr=tstCausa.getWebObject(con);
		        		    	 if (nr==0)
		     		    	 		{
		        		    		 tstCausa.causa_en=removeAccents(tstCausa.causa);
			    		    		 if (dbutils.htCauseEnglish.get(tstCausa.causa_en)!=null)
			    		    			 tstCausa.causa_en=dbutils.htCauseEnglish.get(tstCausa.causa_en);
			    		    		 else
			        		    		 tstCausa.causa_en=tstCausa.causa; // leave it alone...
		        		    		 tstCausa.addWebObject(con);
		        		    		 debug("Added [cause]: "+tstCausa.causa);
		     		    	 		}
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
		        		    	 else
		        		    	 	{
		        		    		 if (tstLev0.lev0_name.length()==0 && datacard.name0.length()>0)
		        		    		 	{
				              		    tstLev0.lev0_name=datacard.name0;
			        		    		tstLev0.lev0_name_en=tstLev0.lev0_name;
			        		    		tstLev0.updateWebObject(con); 
		        		    		 	}
		        		    	 	}
		        		    	 if (datacard.level1.length()>0)
		  					   	 	{
		  	          		    	 tstlev1.lev1_cod=datacard.level1;
		  	        		    	 nr=tstlev1.getWebObject(con);
		  	        		    	 if (nr==0)
		  	        		    	 	{
		  	              		    	 tstlev1.lev1_lev0=tstLev0.lev0_cod;
		  	              		    	 tstlev1.lev1_name=datacard.name1;
		  	              		    	 tstlev1.lev1_name_en=tstlev1.lev1_name;
		  	        		    		 tstlev1.addWebObject(con);
		  	        		    	 	}    	    			  					   		 
			        		    	 else
			        		    	 	{
			        		    		 if (tstlev1.lev1_name.length()==0 && datacard.name1.length()>0)
			        		    		 	{
			        		    			 tstlev1.lev1_name=datacard.name1;
			        		    			 tstlev1.lev1_name_en=tstlev1.lev1_name;
			        		    			 tstlev1.updateWebObject(con); 
			        		    		 	}
			        		    	 	}
		  	  					   	 if (datacard.level2.length()>0)
			   					   	 	{
			   	          		    	 tstlev2.lev2_cod=datacard.level2;
			   	        		    	 nr=tstlev2.getWebObject(con);
			   	        		    	 if (nr==0)
			   	        		    	 	{
			   	              		    	 tstlev2.lev2_lev1=datacard.level1;
			   	              		    	 tstlev2.lev2_name=datacard.name2;
			   	              		    	 tstlev2.lev2_name_en=tstlev2.lev2_name;
			   	        		    		 tstlev2.addWebObject(con);
			   	        		    	 	}    	    			  					   		 
			   					   	 	}
		  					   	 	}

		        		    	 
		    	    		// NOT FOR NOW, STILL TODO IMPLEMENT: 
		        		    // loadExtended(countrybean);

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
		    	    		
		    	    	sLine=lnReader.readLine(); // first line of data
		    	        } // while (sLine!=null)
		   
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
				System.out.println ("Exception DI ImportFakeExcel. opening main database..."+dbDefaultCon.dbGetConnectionError());
			}
		    Statement stat = pc_connection.createStatement();
		    //ResultSet rs = stat.executeQuery("select * from country where scountryid in ('ar11','bo11','ch11','co11','cr11','eq11','gu11','mx11','pa11','pe11','sa11','ve11')");
		    
		    // rerun of selected countries
		    ResultSet rs = stat.executeQuery("select * from country where scountryid in ('pe11','sa11')");
		    // rerun of three level countries
		    // ResultSet rs = stat.executeQuery("select * from country where scountryid in ('bo11','ch11','cr11','eq11','gu11','pa11','pe11','sa11','ve11')");
		    while (rs.next())
		    	{
		    	countrybean.country.loadWebObject(rs);
		    	countrybean.countrycode=countrybean.country.scountryid;
		    	countrybean.countryname=countrybean.country.scountryname;
				countrybean.country.dbType=countrybean.dbType=countrybean.country.ndbtype;
				countrybean.setLanguage("EN");
		    	System.out.println("Importing: "+countrybean.countrycode+" - "+countrybean.countryname+ " from "+countrybean.country.sjetfilename);		    	
		    	
				Di8ImportFakeExcel diLoader=new Di8ImportFakeExcel();
				diLoader.doImport(countrybean.country.sjetfilename+"\\XXXXFILE.xls", countrybean);

		    	}
			}
		catch (Exception eImp)
			{
			System.out.println("DI9: error importing DI8 FAKE EXCEL: "+eImp.toString());
			}

	}

}
