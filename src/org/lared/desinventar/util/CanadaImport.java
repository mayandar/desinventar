/**
 * 
 */
package org.lared.desinventar.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.*;

import javax.servlet.jsp.JspWriter;

import org.lared.desinventar.system.Sys;
import org.lared.desinventar.webobject.*;
import org.lared.desinventar.util.*;

/**
 * @author Julio Serje
 *
 */
public class CanadaImport
{
	Connection con=null;
	Connection canada=null;
	public int dbType=Sys.iAccessDb;  //.iMsSqlDb;
	private boolean bDebug=true;
	private boolean buildAll=false;


	ResultSet rset=null;
	Statement stmt=null;
	Statement ustmt=null;
	String sError="";
	int nRows=0;

	String[] asCanadaTabs={"GENERAL","HUMAN","ECONOMIC"};

	String[] asCanadaVariables={
			"EVENT CATEGORY",	
			"EVENT GROUP",	
			"EVENT SUBGROUP",	
			"EVENT TYPE",
			"PLACE",
			"EVENT START DATE",
			"COMMENTS",	
			"FATALITIES",	
			"INJURED_INFECTED",
			"EVACUATED",	
			"ESTIMATED TOTAL COST",	
			"NORMALIZED TOTAL COST",	
			"EVENT END DATE",	
			"FEDERAL DFAA PAYMENTS",	
			"PROVINCIAL DFAA PAYMENTS",	
			"PROVINCIAL DEPARTMENT PAYMENTS",	
			"MUNICIPAL COSTS",	
			"OGD COSTS",	
			"INSURANCE PAYMENTS",	
			"NGO PAYMENTS",	
			"UTILITY - PEOPLE AFFECTED",	
			"MAGNITUDE"			
	};

	int[] asCanadaVarTypes={
			Types.VARCHAR,
			Types.VARCHAR,
			Types.VARCHAR,
			Types.VARCHAR,
			Types.VARCHAR,
			Types.VARCHAR,
			Types.CLOB,
			Types.INTEGER,
			Types.INTEGER,
			Types.INTEGER,
			Types.DOUBLE,
			Types.DOUBLE,
			Types.VARCHAR,
			Types.DOUBLE,
			Types.DOUBLE,
			Types.DOUBLE,
			Types.DOUBLE,
			Types.DOUBLE,
			Types.DOUBLE,
			Types.DOUBLE,
			Types.INTEGER,
			Types.VARCHAR		
	};


	int[] asCanadaVarLengths={
			50,
			50,
			50,
			50,
			255,
			20,
			255,
			8,
			8,
			8,
			12,
			12,
			20,
			12,
			12,
			12,
			12,
			12,
			12,
			12,
			8,
			50			
	};


	HashMap<String,String> hmEvents=new HashMap<String,String>();
	HashMap<String,Integer> hmTabs=new HashMap<String,Integer>();
	
	HashMap<String,String> hmProvinces=new HashMap<String,String>();
	HashMap<String,String> hmProvinceNames=new HashMap<String,String>();
	ArrayList<String> laProvinces=new ArrayList<String>();

	HashMap<String,String> hmCounty=new HashMap<String,String>();
	HashMap<String,String> hmCountyNames=new HashMap<String,String>();	
	ArrayList<String> laCounties=new ArrayList<String>();

	
	public void setConnection(Connection cn, int type)
	{
		con=cn;
		dbType=type;
		try{
			ustmt=con.createStatement();
		}
		catch (Exception e)
		{
			System.out.println(e.toString());
		}
		try{
			ustmt.executeUpdate("delete from extensiontabs");
			ustmt.executeUpdate("drop table extension");
			ustmt.executeUpdate("CREATE TABLE extension (clave_ext int NOT NULL)");
			ustmt.executeUpdate("ALTER TABLE extension ADD CONSTRAINT PK_extension PRIMARY KEY (clave_ext)");   
			ustmt.executeUpdate("ALTER TABLE extension ADD CONSTRAINT FK_extension_fichas FOREIGN KEY (clave_ext) REFERENCES fichas (clave)"); 
			ustmt.executeUpdate("delete from wordsdocs");
			ustmt.executeUpdate("delete from words");
			ustmt.executeUpdate("delete from fichas");
			ustmt.executeUpdate("delete from diccionario");
			if (buildAll)
			{
				ustmt.executeUpdate("delete from regiones");
				ustmt.executeUpdate("delete from lev2");
				ustmt.executeUpdate("delete from lev1");
				ustmt.executeUpdate("delete from lev0");
			}
			// canadian database has its own events
			ustmt.executeUpdate("delete from eventos");				
		} 
		catch (Exception e)	
		{  
			System.out.println(e.toString());		
		}
	}

	public void setDebug(boolean bdeb)
	{
		bDebug=bdeb;
	}
	// debug logger
	public void log(String msg)
	{
		if (bDebug) 
			System.out.println(msg);
	}

	public void importEvent(String sEvent)
	{
		// -----------------------------------------------------------------------------
		// create a new entry in table of events
		if (!hmEvents.containsKey(sEvent))
		{
			eventos ev=new eventos();
			ev.dbType=dbType;
			try{
				// note this goes against DANA!
				ev.nombre=sEvent;
				ev.nombre_en=sEvent;
				ev.descripcion=sEvent;
				ev.serial=hmEvents.size()+1;
				nRows=ev.addWebObject(con);
				hmEvents.put(ev.descripcion, ev.nombre);
			}
			catch (Exception e)
			{
				sError="Importing EVENTS"+e.toString();
				System.out.println(sError);
			}		
		}	
	}

	public void importGroups()
	{
		// -----------------------------------------------------------------------------
		// create table of events
		extensiontabs ev=new extensiontabs();
		ev.dbType=dbType;

		try{
			for (int j=0; j<this.asCanadaTabs.length; j++)
			{
				ev.svalue=asCanadaTabs[j];
				ev.svalue_en=asCanadaTabs[j];
				ev.ntab=j;
				ev.nsort=j;
				nRows=ev.addWebObject(con);
				hmTabs.put(ev.svalue,new Integer(ev.nsort));
			}
		}
		catch (Exception e)
		{
			sError="Importing EXTENSION TABS "+e.toString();
			System.out.println(sError);
		}

	}

	/*
	public void importGeography_3l()
	{
		// -----------------------------------------------------------------------------
			lev0 l0=new lev0();
			rset=stmt.executeQuery("Select * fr4Cod_Prov , Provincia from  T_provincias_comunidades Order By Cod_CCAA, Cod_Prov");
			while (rset.next())
			{
				l0.lev0_cod=rset.getString("Cod_Prov");
				l0.lev0_name=rset.getString("Provincia");
				l0.lev0_name_en=l0.lev0_name;
				nRows=l0.addWebObject(con);
			}

			l0.lev0_cod="99";  // unknown
			l0.lev0_name="Provincia no definida";
			l0.lev0_name_en="Province not defined";
			nRows=l0.addWebObject(con);

			rset=stmt.executeQuery("Select Cod_INE, Cod_Prov , Municipio from T_municipios_provincias Order By  Cod_INE");
			lev2 l2=new lev2();
			l2.dbType=dbType;
			while (rset.next())
			{
				l2.lev2_cod=rset.getString("Cod_INE");
				l2.lev2_lev1=rset.getString("Cod_Prov");
				l2.lev2_name=rset.getString("Municipio");
				l2.lev2_name_en=l2.lev2_name;
				nRows=l2.addWebObject(con);
			}			
		}
		catch (Exception e)
		{
			sError="Importing LEVELS"+e.toString();
			System.out.println(sError);
		}

	}
	 */


	public void loadGeography()
	{
		// -----------------------------------------------------------------------------
		// load level 1 from database
		try{

			stmt=con.createStatement();
			rset=stmt.executeQuery("Select * from lev1 order by len(lev1_name) desc, lev1_name desc");
			lev1 l1=new lev1();
			l1.dbType=dbType;
			int pos=0;
			while (rset.next())
			{
				l1.loadWebObject(rset);
				hmCountyNames.put(l1.lev1_cod, l1.lev1_name);
				l1.lev1_name=l1.lev1_name.toLowerCase();
				
				if ((pos=l1.lev1_name.indexOf(" county"))>0)
					l1.lev1_name=l1.lev1_name.substring(0,pos);
				if ((pos=l1.lev1_name.indexOf(" district"))>0)
					l1.lev1_name=l1.lev1_name.substring(0,pos);
				if ((pos=l1.lev1_name.indexOf(" division"))>0)
					l1.lev1_name=l1.lev1_name.substring(0,pos);
				if ((pos=l1.lev1_name.indexOf(" regional municipality"))>0)
					l1.lev1_name=l1.lev1_name.substring(0,pos);
				if ((pos=l1.lev1_name.indexOf(" united counties"))>0)
					l1.lev1_name=l1.lev1_name.substring(0,pos);
				if ((pos=l1.lev1_name.indexOf(" regional district"))>0)
					l1.lev1_name=l1.lev1_name.substring(0,pos);
								
				
				hmCounty.put(l1.lev1_name, l1.lev1_cod);
				laCounties.add(l1.lev1_name);
			}
			rset.close();
			stmt.close();
		}
		catch (Exception e)
		{
			sError="Importing LEVELS"+e.toString();
			System.out.println(sError);
		}

	}




	/** Using Calendar - THE CORRECT WAY**/
	//assert: startDate must be before endDate
	public int daysBetween(Calendar startDate, Calendar endDate) 
	{
		Calendar date = (Calendar) startDate.clone();
		int daysBetween = 0;
		while (date.before(endDate)) 
		{
			date.add(Calendar.DAY_OF_MONTH, 1);
			daysBetween++;
		}
		return daysBetween;
	}


	String[] obtainProvince_single(String sProv)
	{
		String[] sProvince=new String[1];
		sProvince[0]="";
		
		String sResult=sProv.trim().toLowerCase();
		int pos=Math.max(sResult.lastIndexOf(" "),sResult.lastIndexOf(","));
		String sLastWord="";
		if (pos>=0)
		{
			sResult=sResult.substring(pos+1).trim();
		}
		
		if (sResult.length()==2)  // province code?
			if (hmProvinces.containsValue(sResult.toUpperCase()))
				sProvince[0]=sResult.toUpperCase();
		if (sProvince[0].length()==0)
		{
			if (hmProvinces.containsKey(sResult))
				sProvince[0]=hmProvinces.get(sResult);			
		}
		
		return sProvince;
	}

	String obtainProvince(String sPlace, String[] aProvinces)
	{		
		String sResult=sPlace.trim().toLowerCase();
		int nProvs=0;
		// brute force..
		for (int j=0; j<laProvinces.size(); j++)
		{
			int pos=sResult.indexOf(laProvinces.get(j));
			if (pos>=0)
			{
				String sPre="";
				String sPost="";
				if (pos>0)
					sPre=sResult.substring(0,pos);
				if (sResult.length()>pos+laProvinces.get(j).length())
					sPost=sResult.substring(pos+laProvinces.get(j).length());
				sResult=(sPre+sPost).trim();				
				aProvinces[nProvs++]=hmProvinces.get(laProvinces.get(j));			
			}
		}		
		return sResult;
	}


	String obtainCounty(String sPlace, String[] aCounties)
	{		
		String sResult=sPlace.trim();
		int nProvs=0;
		if (sResult.endsWith(","))
			sResult=sResult.substring(0,sResult.length()-1);
		// brute force..
		for (int j=0; j<laCounties.size() && sResult.length()>2 ; j++)
		{
			int pos=sResult.indexOf(laCounties.get(j));
			if (pos>=0)
			{
				String sPre="";
				String sPost="";
				if (pos>0)
					sPre=sResult.substring(0,pos);
				if (sResult.length()>pos+laCounties.get(j).length())
					sPost=sResult.substring(pos+laCounties.get(j).length());
				sResult=(sPre+sPost).trim();				
				if (sResult.endsWith(","))
					sResult=sResult.substring(0,sResult.length()-1);
				aCounties[nProvs++]=hmCounty.get(laCounties.get(j));			
			}
		}		
		return sResult;
	}
	
	
	/*
	0			"EVENT CATEGORY",	
	1			"EVENT GROUP",	
	2			"EVENT SUBGROUP",	
	3			"EVENT TYPE",
	4			"PLACE",
	5			"EVENT START DATE",
	6			"COMMENTS",	
	7			"FATALITIES",	
	8			"INJURED_INFECTED",
	9			"EVACUATED",	
	10			"ESTIMATED TOTAL COST",	
	11			"NORMALIZED TOTAL COST",	
	12			"EVENT END DATE",	
	13			"FEDERAL DFAA PAYMENTS",	
	14			"PROVINCIAL DFAA PAYMENTS",	
	15			"PROVINCIAL DEPARTMENT PAYMENTS",	
	16			"MUNICIPAL COSTS",	
	17			"OGD COSTS",	
	18			"INSURANCE PAYMENTS",	
	19			"NGO PAYMENTS",	
	20			"UTILITY - PEOPLE AFFECTED",	
	21			"MAGNITUDE"			
 */
	
	public void importDisasters(DICountry countrybean)
	{
		// -----------------------------------------------------------------------------
		// create the fichas/extension tables
		int nRecs=0;
		try{

			fichas datacard=new fichas(); 
			extension e=new extension();
			datacard.dbType=dbType;
			e.dbType=dbType;
			e.loadExtension(con, new DICountry());



			String sInputFileName=countrybean.country.sjetfilename+"CDD.txt";
			BufferedReader in=null; 
			String sLine="";
			File f=new File(sInputFileName);
			if (f.exists() && f.isFile() && f.canRead())
			{
				in = new BufferedReader(new InputStreamReader(new FileInputStream(sInputFileName),"UTF-8"));
				sLine = in.readLine(); // This is the heder ignored for now
				int nLines=0;
				while ((sLine = in.readLine()) != null) 
				{

					String[] result = sLine.split("\t");
					while (result.length<13 && sLine!=null)
					{
						sLine += in.readLine();
						result = sLine.split("\t");
					}



					String[] aResult= new String[22];
					for (int x=0; x<aResult.length; x++)
						aResult[x]="";
					for (int x=0; x<result.length; x++)
						aResult[x]=result[x];

					nLines++;
					e.init();
					datacard.init();
					
					// System.out.print("LINE "+nLines+"["+result.length+" ]");
					//if (result.length!=22)
					//	for (int x=0; x<result.length; x++)
					//		System.out.print(" | "+result[x]);
					//System.out.println();
					
					datacard.serial=String.valueOf(nLines);
					datacard.evento=aResult[3];
					importEvent(datacard.evento);
					// TODO: refine causes

					String sdate=aResult[5];
					datacard.fechadia=Integer.parseInt(sdate.substring(0,2));
					datacard.fechames=Integer.parseInt(sdate.substring(3,5));
					datacard.fechano=Integer.parseInt(sdate.substring(6,10));
					String stodate=aResult[12];

					if (!stodate.equals(sdate))
					{
						try{
							sdate=sdate.substring(6,10)+"-"+sdate.substring(3,5)+"-"+sdate.substring(0,2);
							stodate=stodate.substring(6,10)+"-"+stodate.substring(3,5)+"-"+stodate.substring(0,2);
							java.sql.Date disdate=e.extendedParseDate(sdate);
							Calendar cal=Calendar.getInstance();
							cal.setTime(disdate);
							Calendar tocal=Calendar.getInstance();
							tocal.setTime(disdate);
							datacard.duracion=daysBetween(cal, tocal); 						
						}
						catch (Exception edate)
						{
							// nothing for now.. means day or month are missing. Improve?
						}

					}



					String[] sProvinces=new String[15];  // there are only 13 provinces... 
					String sRes=obtainProvince(aResult[4], sProvinces);
					datacard.level0=webObject.not_null(sProvinces[0]);
					datacard.name0=webObject.not_null(hmProvinceNames.get(datacard.level0));

					String[] sCounties=new String[40];  // there are only 13 provinces...  but many more counties... 
					obtainCounty(sRes, sCounties);
					datacard.level1=webObject.not_null(sCounties[0]);
					datacard.name1=webObject.not_null(hmCountyNames.get(datacard.level1));
					
					if (datacard.level0.length()==0 && datacard.level1.length()>1)
					{
						datacard.level0=datacard.level1.substring(0,2);					
					}

					if (datacard.level0.length()==0)
					{
						datacard.level0="99";
						datacard.name0="Province not defined";
					}

					datacard.di_comments=aResult[6];
					datacard.fuentes="Canadian Disaster Database";
					
					datacard.lugar=aResult[4];
					datacard.approved=0;
					
					datacard.muertos=webObject.extendedParseInt(aResult[7]);
					datacard.heridos=webObject.extendedParseInt(aResult[8]);
					datacard.evacuados=webObject.extendedParseInt(aResult[9]);
					datacard.afectados=webObject.extendedParseInt(aResult[20]);

					datacard.valorloc=webObject.extendedParseInt(aResult[10]);
					datacard.magnitud2=aResult[21];

					importExtension(e, aResult);


					datacard.addWebObject(con);
					e.clave_ext=datacard.clave;
					e.addWebObject(con);

					nRecs++;

					if (datacard.level0.equals("99"))
						System.out.println("[DI9] WARNING: IMPORTED with no georeference ["+datacard.serial+"] "+datacard.descausa);

				}
			}



			rset=null;
			while (rset!=null)
			{

			}    		
		}
		catch (Exception e)
		{
			sError="[DI9] canada / Importing FICHAS:  "+e.toString();
			System.out.println(sError);
		}
		System.out.println("[DI9] canada - Imported FICHAS:  "+nRecs);

	}


	// TODO  MOVE THIS TO EXTENSION CLASS!!!
	public static String getLegalExtensionFieldName(String sFieldName)
	{
		String sRet=sFieldName.toUpperCase();
		int pos=sFieldName.lastIndexOf('.');
		if (pos>=0)
			sRet=sRet.substring(pos+1);
		String sNotAcceptable=" -=+/\\!*";   /// this may be longer if 
		for (int j=0; j<sNotAcceptable.length(); j++)
			if (sRet.indexOf(sNotAcceptable.charAt(j))>=0)
				sRet=sRet.replace(sNotAcceptable.charAt(j), '_');

		if (sRet.length()>30)
			sRet=sRet.substring(0,30);
		return sRet;
	}

	public void importExtension(extension e, String[] rset)
	{
		// ----1-------------------------------------------------------------------------
		// create the extension tables
		try{
			String sFieldName=null;
			// these are required not to disturb the globally declared ones used by the calling method. close them at the end
			for  (int j=0; j<asCanadaVariables.length; j++)
			{
				try
				{
					sFieldName=getLegalExtensionFieldName(asCanadaVariables[j]);
					e.asFieldNames.put(sFieldName, rset[j]);
				}
				catch (Exception ex)
				{
					// log here the error type
					System.out.println("[DI9] WARNING: IMPORTING EXTENSION ["+j+"-"+sFieldName+" msg: "+ ex.toString());
				}
			}

			e.updateMembersFromHashTable();
		}
		catch (Exception ex)
		{
			sError="Importing EXTENSION"+ex.toString();
			System.out.println(sError);
		}    	
	}




	private void importExtensionDefinition(Connection con,  DICountry countrybean)
	{
		try{
			extension woExtension=new extension();
			woExtension.loadExtension(con, countrybean);
			int nCurrentFieldType=0;
			int nCurrentFieldSize=30;
			PreparedStatement pstmt = con.prepareStatement("insert into diccionario(orden,nombre_campo,descripcion_campo,label_campo,pos_x,pos_y,lon_x,lon_y,color,label_campo_en,tabnumber,fieldtype) values (?,?,?,?,?,?,?,?,?,?,?,?)");
			stmt=con.createStatement();
			String sFieldName=" ";
			String sColumnName="";
			int nField=0;
			for  (int j=0; j<asCanadaVariables.length; j++)
			{
				try
				{
					sColumnName=asCanadaVariables[j];
					sFieldName=getLegalExtensionFieldName(sColumnName);
					if (!woExtension.vMeta.containsKey(sFieldName.toUpperCase()))
					{
						nCurrentFieldType=0;
						nCurrentFieldSize=30;			
						nField=j;
						// get the DesInventar closest Type.
						int nType=asCanadaVarTypes[j];
						switch (nType)
						{
						case Types.CLOB:							   	
						case Types.BLOB:
							nCurrentFieldType=5;
							nCurrentFieldSize=16;			  
							break;
						case Types.DATE:
							nCurrentFieldType=4;
							nCurrentFieldSize=16;			  
							break;
						case Types.DOUBLE:
							nCurrentFieldType=2;
							nCurrentFieldSize=8;
							// nCurrentFieldType=3;
							break;
						case Types.INTEGER:
							nCurrentFieldType=1;
							nCurrentFieldSize=4;			  
							break;
						case Types.VARCHAR:
							nCurrentFieldType=0;
							nCurrentFieldSize=asCanadaVarLengths[j];			  
							break;
						}
						// mySQL requires variable names in lowercase. Others don't really matter
						String sSql="alter table extension add "+sFieldName.toUpperCase()+" "+DbImplementation.typeNames[countrybean.country.ndbtype][nCurrentFieldType];
						if (nCurrentFieldType==0)
							sSql+="("+nCurrentFieldSize+")";
						try
						{
							stmt.executeUpdate(sSql);
							woExtension.vMeta.put(sFieldName, new Integer(j));
							// if it reached here, the field has just been added to the table OK
							pstmt.setInt(1, j);
							pstmt.setString(2, sFieldName);
							sColumnName=sColumnName.replace('_', ' ');
							pstmt.setString(3, sColumnName);
							pstmt.setString(4, sColumnName);
							pstmt.setInt(5, 0);
							pstmt.setInt(6, 0);
							pstmt.setInt(7, nCurrentFieldSize);
							pstmt.setInt(8, 0);
							pstmt.setInt(9, 0);
							pstmt.setString(10, sColumnName);
							pstmt.setInt(11, 0);
							pstmt.setInt(12, nCurrentFieldType);

							pstmt.executeUpdate();
						}
						catch (Exception e)
						{
							// log here the error type
							// out.println("<br>WARNING EXTENSION DEFINITION ["+nField+"-"+sFieldName+"("+DbImplementation.typeNames[countrybean.country.ndbtype][nCurrentFieldType]+")] <!--"+ e.toString()+"-->");
							System.out.println("[DI9] WARNING: EXTENSION DEFINITION ["+nField+"-"+sFieldName+"("+DbImplementation.typeNames[countrybean.country.ndbtype][nCurrentFieldType]+")] "+ e.toString());
						}

					}
				}
				catch(Exception e)
				{
					// log here the error type
					System.out.println("[DI9] EXTENSION DEFINITION  ["+nField+"-"+sFieldName+"("+DbImplementation.typeNames[countrybean.country.ndbtype][nCurrentFieldType]+")] <!--"+ e.toString()+"-->");
				}			
			}

		}
		catch (Exception e)
		{
			// log here the error type
			System.out.println("[DI9] ERROR: EXTENSION DEFINITION -> "+ e.toString());
		}

		// everything ready, now get the extension codes
	}



	public void doImport(DICountry countrybean)
	{


		try{
			stmt=canada.createStatement();
		}
		catch (Exception e ){}


		importGroups();	
		
		hmProvinces.put("alberta","AB");
		hmProvinces.put("british columbia","BC");
		hmProvinces.put("columbia","BC");
		hmProvinces.put("manitoba","MB");
		hmProvinces.put("new brunswick","NB");
		hmProvinces.put("brunswick","NB");
		hmProvinces.put("newfoundland and labrador","NL");
		hmProvinces.put("labrador","NL");
		hmProvinces.put("northwest territories","NT");
		hmProvinces.put("territories","NT");
		hmProvinces.put("nova scotia","NS");
		hmProvinces.put("scotia","NS");
		hmProvinces.put("nunavut","NU");
		hmProvinces.put("ontario","ON");
		hmProvinces.put("prince edward island","PE");
		hmProvinces.put("island","PE");
		hmProvinces.put("pei","PE");
		hmProvinces.put("quebec","QC");
		hmProvinces.put("saskatchewan","SK");
		hmProvinces.put("yukon","YT");

		hmProvinces.put(" ab","AB");
		hmProvinces.put(" bc","BC");
		hmProvinces.put(" mb","MB");
		hmProvinces.put(" nb","NB");
		hmProvinces.put(" nl","NL");
		hmProvinces.put(" nt","NT");
		hmProvinces.put(" ns","NS");
		hmProvinces.put(" nu","NU");
		hmProvinces.put(" on","ON");
		hmProvinces.put(" pe","PE");
		hmProvinces.put(" qc","QC");
		hmProvinces.put(" sk","SK");
		hmProvinces.put(" yt","YT");

		
		laProvinces.add("alberta");
		laProvinces.add("british columbia");
		laProvinces.add("manitoba");
		laProvinces.add("new brunswick");
		laProvinces.add("newfoundland and labrador");
		laProvinces.add("northwest territories");
		laProvinces.add("nova scotia");
		laProvinces.add("nunavut");
		laProvinces.add("ontario");
		laProvinces.add("prince edward island");
		laProvinces.add("pei");
		laProvinces.add("quebec");
		laProvinces.add("saskatchewan");
		laProvinces.add("yukon");
		laProvinces.add(" ab");
		laProvinces.add(" bc");
		laProvinces.add(" mb");
		laProvinces.add(" nb");
		laProvinces.add(" nl");
		laProvinces.add(" nt");
		laProvinces.add(" ns");
		laProvinces.add(" nu");
		laProvinces.add(" on");
		laProvinces.add(" pe");
		laProvinces.add(" qc");
		laProvinces.add(" sk");
		laProvinces.add(" yt");

		
		laProvinces.add("columbia");
		laProvinces.add("island");
		laProvinces.add("scotia");
		laProvinces.add("territories");
		laProvinces.add("labrador");
		laProvinces.add("brunswick");
		

		
		hmProvinceNames.put("AB","Alberta");
		hmProvinceNames.put("BC","British Columbia");
		hmProvinceNames.put("MB","Manitoba");
		hmProvinceNames.put("NB","New Brunswick");
		hmProvinceNames.put("NL","Newfoundland and Labrador");
		hmProvinceNames.put("NT","Northwest Territories");
		hmProvinceNames.put("NS","Nova Scotia");
		hmProvinceNames.put("NU","Nunavut");
		hmProvinceNames.put("ON","Ontario");
		hmProvinceNames.put("PE","Prince Edward Island");
		hmProvinceNames.put("QC","Quebec");
		hmProvinceNames.put("SK","Saskatchewan");
		hmProvinceNames.put("YT","Yukon");


		
		
		loadGeography();
		
		// creation of extension fields 
		importExtensionDefinition(con, countrybean);

		importDisasters(countrybean);


	}
	/**
	 * Imports the DANA database into desinventar structure.
	 * @param args
	 */
	public static void main(String[] args) 
	{
		// obtain connections to database
		/*
		String sDbDriverName = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
		pooledConnection pc=new pooledConnection(sDbDriverName, "jdbc:sqlserver://localhost:1433;DatabaseName=canada","sa","c98");				
		/*/
		String sDbDriverName = Sys.sAccess64Driver;
		pooledConnection pc=new pooledConnection(sDbDriverName, Sys.sAccess64DefaultString+"c:\\databases\\Canada\\inventcan.mdb;", null, null);				
		//*/
		pc.getConnection();
		Connection con=pc.connection;


		// Canada 2013 settings in country bean...
		DICountry countrybean=new DICountry();
		countrybean.country.scountryid="can";
		countrybean.countrycode=countrybean.country.scountryid;
		countrybean.countryname="Canada";
		countrybean.dbType=countrybean.country.ndbtype=Sys.iAccessDb;
		countrybean.country.sjetfilename="c:/databases/Canada/";

		CanadaImport can=new CanadaImport();
		can.setConnection(con, Sys.iAccessDb); // .iMsSqlDb);

		System.out.println("Variables:="+can.asCanadaVariables.length);
		System.out.println("VarTypes="+can.asCanadaVarTypes.length);
		System.out.println("VarLengths:="+can.asCanadaVarLengths.length);


		can.doImport(countrybean);

		try{ 
			con.close();
		}
		catch(Exception e)
		{
			// log here the error type
			System.out.println("[DI9] ERROR: EXTENSION DEFINITION -> "+ e.toString());
		}



	}

}
