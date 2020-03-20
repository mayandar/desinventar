/*
 * Created on 9-Jan-2006
 *
 * */
package org.lared.desinventar.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.*;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.io.*;
import java.sql.*;
import org.lared.desinventar.webobject.*;
import org.lared.desinventar.util.DbImplementation;
import org.lared.desinventar.dbase.DBase;
import org.lared.desinventar.map.MapUtil;
import org.lared.desinventar.system.Sys;

/**
 * @author Julio Serje
 *
 * Contains several database utilities.
 */
public class dbutils extends webObject
{
	// INFO: THIS VERSION OF DESINVENTAR RUNS ON DATAMODEL VERSION:
	public static int currentDataModel=15;

	final static int Types_Oracle_Date = 93; // this is what oracle 9 returns instead of Types.Date
	final static int Types_Oracle_CLOB = 1111; // this is what oracle returns instead of Types.CLOB

	static boolean bConsolidateUniverse=false;
	static boolean bGenerateMaps=false;

	// global variables of this object, to reduce parameter passing :-)
	Statement stmt=null;
	ResultSet rset=null;
	PreparedStatement pstmt=null;
	//query stmt and rset:
	Statement qstmt=null;  
	int nMaxTab=0;
	int j;
	HashMap<String, Integer> sExistingTabs=new HashMap<String, Integer>();
	HashMap<Integer,String> sNewTabs=new HashMap<Integer,String>();


	// table of event name translation
	public  static HashMap<String,String> htEventEnglish = new HashMap<String,String>();
	public  static HashMap<String,String> htCauseEnglish = new HashMap<String,String>();

	public static int createTranslations()
	{
		htEventEnglish = new HashMap();
		htEventEnglish.put("INUNDACION", "FLOOD");
		htEventEnglish.put("DESLIZAMIENTO", "LANDSLIDE");
		htEventEnglish.put("AVENIDA", "FLASH FLOOD");
		htEventEnglish.put("AVENIDA TORRENCIAL", "FLASH FLOOD");
		htEventEnglish.put("LLUVIAS", "RAINS");
		htEventEnglish.put("VENDAVAL", "STRONG WIND");
		htEventEnglish.put("TEMPESTAD", "STORM");
		htEventEnglish.put("MAREJADA", "HIGH TIDE");
		htEventEnglish.put("SISMO", "EARTHQUAKE");
		htEventEnglish.put("HURACAN", "HURRICANE");
		htEventEnglish.put("SEDIMENTACION", "SEDIMENTATION");
		htEventEnglish.put("HELADA", "FROST");
		htEventEnglish.put("GRANIZADA", "HAILSTORM");
		htEventEnglish.put("SEQUIA", "DROUGHT");
		htEventEnglish.put("LITORAL", "COASTLINE");
		htEventEnglish.put("CAMBIO LITORAL", "COASTLINE");
		htEventEnglish.put("ALUVION", "ALLUVION");
		htEventEnglish.put("ALUD", "AVALANCHE");
		htEventEnglish.put("TSUNAMI", "TSUNAMI");
		htEventEnglish.put("LICUACION", "LIQUEFACTION");
		htEventEnglish.put("FALLA", "FAILURE");
		htEventEnglish.put("INCENDIO", "FIRE");
		htEventEnglish.put("FORESTAL", "FOREST FIRE");
		htEventEnglish.put("INCENDIO FORESTAL", "FOREST FIRE");
		htEventEnglish.put("EXPLOSION", "EXPLOSION");
		htEventEnglish.put("ESCAPE", "LEAK");
		htEventEnglish.put("ESTRUCTURA", "STRUCTURE");
		htEventEnglish.put("COLAPSO ESTRUCTURAL", "STRUCTURE");
		htEventEnglish.put("PANICO", "PANIC");
		htEventEnglish.put("EPIDEMIA", "EPIDEMIC");
		htEventEnglish.put("PLAGA", "PLAGUE");
		htEventEnglish.put("ACCIDENTE", "ACCIDENT");
		htEventEnglish.put("OTROS", "OTHER");
		htEventEnglish.put("BIOLOGICO", "BIOLOGICAL");
		htEventEnglish.put("ERUPCION", "ERUPTION");
		htEventEnglish.put("ACTIVIDAD VOLCANICA", "ERUPTION");
		htEventEnglish.put("CONTAMINACION", "CONTAMINATION");
		htEventEnglish.put("TORMENTA E.", "ELECTRIC STORM");
		htEventEnglish.put("NEVADA", "SNOWSTORM");
		htEventEnglish.put("OLA DE CALOR", "HEAT WAVE");
		htEventEnglish.put("OLA DE FRIO", "COLD WAVE");
		htEventEnglish.put("OLA FRIA", "COLD WAVE");
		htEventEnglish.put("TORNADO", "TORNADO");
		htEventEnglish.put("NEBLINA", "FOG");
		htEventEnglish.put("INTOXICACION", "INTOXICATION");
		htEventEnglish.put("EPIZOOTIA", "EPIZOOTIC");

		// for causes
		htCauseEnglish.put("COND. ATMOS.", "Atmos.Cond.");
		htCauseEnglish.put("CONTAMINACION", "Contamination");
		htCauseEnglish.put("CORTOCIRCUITO", "Short circuit");
		htCauseEnglish.put("DEPRESION TROPI", "Tropical Depr.");
		htCauseEnglish.put("DEPRESION TROPICAL", "Tropical Depr.");
		htCauseEnglish.put("DESBORDAMIENTO", "River overflow");
		htCauseEnglish.put("DESCONOCIDA", "Unknown");
		htCauseEnglish.put("DESLIZAMIENTO", "Landslide");
		htCauseEnglish.put("DETERIORO", "Deterioration");
		htCauseEnglish.put("DISENO", "Design");
		htCauseEnglish.put("EL NINO", "El Nino");
		htCauseEnglish.put("EROSION", "Erosion");
		htCauseEnglish.put("ERROR HUMANO", "Human error");
		htCauseEnglish.put("ERUPCION", "Eruption");
		htCauseEnglish.put("ESCAPE", "Leak");
		htCauseEnglish.put("EXPLOSION", "Explosion");
		htCauseEnglish.put("FALLA", "Failure");
		htCauseEnglish.put("INUNDACION", "Flood");
		htCauseEnglish.put("INV. TERMICA", "Thermal Inv.");
		htCauseEnglish.put("INVERSION TERMICA", "Thermal Inv.");
		htCauseEnglish.put("LA NINA", "La Nina");
		htCauseEnglish.put("LLUVIAS", "Rains");
		htCauseEnglish.put("LOCALIZACION", "Localization");
		htCauseEnglish.put("NEBLINA", "Fog");
		htCauseEnglish.put("NEGLIGENCIA", "Negligence");
		htCauseEnglish.put("OTRA CAUSA", "Other cause");
		htCauseEnglish.put("PLAGA", "Plague");
		htCauseEnglish.put("SEQUIA", "Drought");
		htCauseEnglish.put("SISMO", "Earthquake");
		htCauseEnglish.put("SOBREEXPLOT", "Overexploit");
		htCauseEnglish.put("TALA", "Logging");
		htCauseEnglish.put("TEMPESTAD", "Storm");
		htCauseEnglish.put("VENDAVAL", "Wind");
		htCauseEnglish.put("COMPORTAMIENTO", "Behaviour");


		return 0;

	}


	public String set_null(String sCol)
	{
		if (sCol==null)
			return sCol;
		else
		{
			sCol=sCol.trim();
			if (sCol.length()>0)
				return sCol;
			else
				return null;
		}
	}

	public static void checkDiccionary(Connection con)
	{
		// check for internal database types in the diccionary...
		try
		{
			Statement stmt=null; 
			ResultSet rset=null; 
			stmt=con.createStatement();
			rset=stmt.executeQuery("select * from diccionario");
			Statement estmt=con.createStatement ();
			ResultSet erset=estmt.executeQuery("select * from extension where clave_ext=-1");
			/// gets the metadata of the resultset
			ResultSetMetaData meta = erset.getMetaData();
			int nCurrentFieldType=0;
			int nCurrentFieldSize=30;
			while (rset.next())
			{
				diccionario dct =new diccionario();
				dct.loadWebObject(rset);
				dct.nombre_campo=dct.nombre_campo.toUpperCase();
				if (dct.fieldtype==0)
				{
					String sFieldName=dct.nombre_campo;
					nCurrentFieldType=0;
					nCurrentFieldSize=30;			
					int nField=0;
					// look for the column..
					for  (int j=1; j<=meta.getColumnCount() && nField==0; j++)
						if (meta.getColumnName(j).equalsIgnoreCase(sFieldName))
							nField=j; 
					// get the DesInventar closest Type.
					int nType=meta.getColumnType(nField);
					switch (nType)
					{
					case Types.CLOB:							   	
					case 1111: // type reported by Oracle for BLOB types...
					case -1: // type reported by ACCESS for MEMO types...
					case Types.BLOB:
						nCurrentFieldType=5;
						nCurrentFieldSize=9999;			  
						break;
					case Types.DATE:
						nCurrentFieldType=4;
						nCurrentFieldSize=16;			  
						break;
					case Types.DECIMAL:
					case Types.DOUBLE:
					case Types.FLOAT:
					case Types.REAL:
					case Types.NUMERIC:
						nCurrentFieldType=2;
						nCurrentFieldSize=8;
						if (meta.isCurrency(nField) || meta.getPrecision(nField)==2)
							nCurrentFieldType=3;
						break;
					case Types.SMALLINT:
					case Types.INTEGER:
					case Types.BIGINT:
					case Types.TINYINT:
						nCurrentFieldType=1;
						nCurrentFieldSize=4;			  
						break;
					case Types.VARCHAR:
						nCurrentFieldType=0;
						nCurrentFieldSize=meta.getColumnDisplaySize(nField);			  
						break;
					}
					dct.fieldtype=nCurrentFieldType;
					if (dct.lon_x!=nCurrentFieldSize)
						dct.lon_x=nCurrentFieldSize;
					dct.updateWebObject(con);
				}

			}
			try{rset.close();}catch(Exception e){/* do nothing for now */ }
			try{stmt.close();}catch(Exception e){/* do nothing for now */ }
			try{erset.close();}catch(Exception e){/* do nothing for now */ }
			try{estmt.close();}catch(Exception e){/* do nothing for now */ }

		}
		catch (Exception e2)
		{
			System.out.println("[DI9] dbutils/CheckDictionary: "+e2.toString());
		}

	}

	public static void checkGlideField(Connection con)
	{
		// check for GLIDE field. It's on-line version specific, would fail only on DI-6 MS Access..
		Statement stmt=null; 
		ResultSet rset=null; 
		try
		{
			stmt=con.createStatement();
			try
			{
				rset=stmt.executeQuery("select glide from fichas where clave=-999");
				rset.close();
			} 
			catch (Exception e1)
			{
				try
				{
					stmt.executeUpdate("alter table fichas add glide text(30)");
				}
				catch (Exception e2)
				{
				}
			}
			// Thanks to OSSO. would fail only on DI-6 MS Access.. columns needed if datamodel is less than 11.
			try
			{
				rset=stmt.executeQuery("select observa2 from fichas where clave=-999");
				rset.close();
			} 
			catch (Exception e1)
			{
				try
				{
					stmt.executeUpdate("alter table fichas add observa2 text(255)");
					stmt.executeUpdate("alter table fichas add observa3 text(255)");
				}
				catch (Exception e2)
				{
					System.out.println("[DI9] dbutils/checkGlideField: "+e2.toString());
				}
			}

			stmt.close();
		}
		catch (Exception e3)
		{
			System.out.println("DI9] dbutils/checkGlideField.2: "+e3.toString());
		}

	}

	public static boolean executeFileScript(String strFileName, Connection con)
	{
		boolean bUpgradeAvailable=true;

		File f=new File(strFileName);
		if (f.exists())
		{
			try{

				//FileReader javaIn = new FileReader(f);  				
				BufferedReader javaIn = new BufferedReader(new InputStreamReader(new FileInputStream(strFileName),"UTF-8"));

				int nSize = (int) f.length();
				char[] cBuffer = new char[nSize];
				int nRead = javaIn.read(cBuffer, 0, nSize);
				String sScript=new String(cBuffer);

				// the following statements are for buggy implementations of reading the header of UTF-8 files, Linux and Windows
				if (sScript.startsWith("﻿") ||((cBuffer[0] & 0xff)==0xEF && (cBuffer[1] & 0xff)==0xBB && (cBuffer[2] & 0xff)==0xBF))
					sScript=sScript.substring(3);
				int i=cBuffer[0];
				if ( ((int)(cBuffer[0]))<32  || i==65279)
					sScript=sScript.substring(1);

				System.out.println("[DI9] PROCESSING SCRIPT: " + strFileName + " Size= " + nSize + "  read=" + nRead);
				executeScript(sScript, con);				
				javaIn.close();
			}
			catch (Exception e4)
			{
			}
		}
		else
			bUpgradeAvailable=false;

		return 	bUpgradeAvailable;
	}


	public static void applyModelMigration(Connection con, int idatabaseType, String sScriptFolder)
	{
		// check for GLIDE field. It's on-line version specific, would fail only on MS Access..
		Statement stmt=null; 
		ResultSet rset=null; 
		int model=0;

		// now check on-going upgrades
		try
		{	
			stmt=con.createStatement();
			try
			{
				rset=stmt.executeQuery("select * from datamodel");
				if (rset.next())
					model=rset.getInt("revision");
				rset.close();
			} 
			catch (Exception e1)
			{
				try
				{
					model=0;
				}
				catch (Exception e2)
				{
				}
			}
			stmt.close();

			//if (model==15) 
			//	model=14;

			int prevmodel=model;

			// If datamodel is not current, apply ALL migration scripts
			boolean bUpgradeAvailable=true;
			while (bUpgradeAvailable)
			{
				// next upgrade
				model++;
				// first tries i a generic version of the script exists. Handy for seed data.  
				String strFileName=sScriptFolder+"/migrate_"+model+".sql";
				File f =new File(strFileName);
				if (!f.exists())
					strFileName=sScriptFolder+"/"+DbImplementation.FolderNames[idatabaseType]+"/migrate_"+model+".sql";
				// and updates the data model revision
				bUpgradeAvailable=executeFileScript(strFileName, con);
				if (bUpgradeAvailable)
				{
					stmt=con.createStatement();
					stmt.executeUpdate("delete from datamodel");
					stmt.executeUpdate("insert into datamodel (revision,build) values ("+model+",0)");
					stmt.close();			
				}
			}
			try{ stmt.close(); } catch (Exception e4)	{}
		}
		catch (Exception e3)
		{
		}

	}


	public static void updateDataModelRevision(dbConnection dbCon, int idatabaseType, String sScriptFolder)
	{
		// check for GLIDE field. It's on-line version specific, would fail only on MS Access..
		Statement stmt=null; 
		ResultSet rset=null; 
		int model=0;

		// now check on-going upgrades
		try
		{	
			Connection con=dbCon.dbGetConnection();
			stmt=con.createStatement();
			try
			{
				rset=stmt.executeQuery("select * from datamodel");
				if (rset.next())
					model=rset.getInt("revision");
				rset.close();
			} 
			catch (Exception e1)
			{
				try
				{
					model=0;
				}
				catch (Exception e2)
				{
				}
			}
			stmt.close();


			int prevmodel=model;

			if (model<8 && idatabaseType==Sys.iAccessDb)  // only MS-ACCESS, DI 6 or before databases
			{
				// check for GLIDE and OBSERVA fields. It's DI-6 specific, would fail only on MS Access.. all on-line versions start after
				dbutils.checkGlideField(con);
				// Check the existence full-text indexes!!! also DI-6 specific, would fail only on MS Access.. all on-line versions start after
				indexer Indexer = new indexer();
				Indexer.checkIndexes(con);
			}


			// verify the dictionary - all fields must have valid lengths
			dbutils.checkDiccionary(con);

			// apply all migration scripts
			applyModelMigration(con, idatabaseType, sScriptFolder);

			if (prevmodel<model)
			{
				stmt = populateEnglishFields(con);		
			}


			try{ stmt.close(); } catch (Exception e4)	{}
		}
		catch (Exception e3)
		{
		}

	}



	private static Statement populateEnglishFields(Connection con)
	throws SQLException {
		Statement stmt;
		ResultSet rset;
		// makes sure all _en fields have something
		stmt=con.createStatement();
		try{ stmt.executeUpdate("update lev0 set lev0_name_en=lev0_name where lev0_name_en='' or lev0_name_en is null"); } catch (Exception e4)	{}
		try{ stmt.executeUpdate("update lev1 set lev1_name_en=lev1_name where lev1_name_en='' or lev1_name_en is null"); } catch (Exception e4)	{}
		try{ stmt.executeUpdate("update lev2 set lev2_name_en=lev2_name where lev2_name_en='' or lev2_name_en is null"); } catch (Exception e4)	{}
		try{ stmt.executeUpdate("update eventos set nombre_en=nombre where nombre_en='' or nombre_en is null"); } catch (Exception e4)	{}
		try{ stmt.executeUpdate("update causas set causa_en=causa where causa_en='' or causa_en is null"); } catch (Exception e4)	{}
		try{ stmt.executeUpdate("update extensioncodes set svalue_en=svalue where svalue_en='' or svalue_en is null"); } catch (Exception e4)	{}
		try{ stmt.executeUpdate("update extensiontabs set svalue_en=svalue where svalue_en='' or svalue_en is null"); } catch (Exception e4)	{}
		try{
			createTranslations();
			Statement estmt=con.createStatement();
			rset=estmt.executeQuery("select * from eventos");
			while(rset.next())
			{
				String sOriginalEvent=rset.getString("nombre");
				String sEvent=sOriginalEvent.toUpperCase();
				String sEvent_en=not_null(rset.getString("nombre_en")).toUpperCase();
				// if it may be a Spanish event with default translation and it hasn't been translated
				if (sEvent.equals(sEvent_en) || sEvent_en.length()==0)
				{
					// tries with and without accents
					if (htEventEnglish.get(sEvent)==null)
						sEvent=htmlServer.removeAccents(sEvent);
					if (htEventEnglish.get(sEvent)!=null)
					{
						try{ 
							stmt.executeUpdate("update eventos set nombre_en='"+check_quotes(htEventEnglish.get(sEvent))+"' where nombre='"+check_quotes(sOriginalEvent)+"'"); 
						} 
						catch (Exception e4)	{}        		
					}
				}			
			}
			rset=estmt.executeQuery("select * from causas");
			while(rset.next())
			{
				String sCausa=rset.getString("causa");
				String sCausa_en=rset.getString("causa_en");
				// if it is a Spanish event with default translation and it hasn't been translated
				if (htCauseEnglish.get(sCausa.toUpperCase())!=null && sCausa.equalsIgnoreCase(sCausa_en))
				{
					try{ stmt.executeUpdate("update causas set causa_en='"+check_quotes(htCauseEnglish.get(sCausa.toUpperCase()))+"' where causa='"+check_quotes(sCausa)+"'"); } catch (Exception e4)	{}        		
				}

			}
			rset.close();
		}
		catch (Exception e5)	{}

		try{ stmt.executeUpdate("update diccionario set label_campo_en=label_campo where label_campo_en='' or label_campo_en is null"); } catch (Exception e4)	{}
		return stmt;
	}




	public static String removeComments(String sScript)
	{
		int j = 0;
		int start=0;
		// skips all comments
		while (j < sScript.length()-1) // search for line comments
		{
			start=j;
			if (j < sScript.length()-1 && sScript.charAt(j) == '#' || sScript.substring(j,j+2).equals("--")) // line comments
			{
				while (j < sScript.length() && sScript.charAt(j) != '\n' && sScript.charAt(j) != '\r')
					j++;
				while (j < sScript.length() && 
						((sScript.charAt(j) == '\n') ||
								(sScript.charAt(j) == '\t') ||
								(sScript.charAt(j)== '\r') ||
								(sScript.charAt(j) == ' ')))
					j++;
				sScript = sScript.substring(0,start) + sScript.substring(j);
				j=start;
			}
			else
				j++;
		}

		return sScript;	
	}

	public static boolean isBeginEnd(String sScript,int j, String word)
	{
		boolean isBeginOrEnd=false;
		char a;

		if (sScript.length()>j+word.length())
			if (sScript.substring(j,j+word.length()).equalsIgnoreCase(word))
			{
				if (j==0) 
					isBeginOrEnd=true;
				else
				{
					isBeginOrEnd=true;
					int k=j+word.length();
					if (k>sScript.length())
						k=j-1;
					if ((sScript.charAt(j-1)>='A' && sScript.charAt(j-1)<='Z') || 
							(sScript.charAt(j-1)>='a' && sScript.charAt(j-1)<='z') ||	
							(sScript.charAt(j-1)>='0' && sScript.charAt(j-1)<='9') ||	
							(sScript.charAt(j-1)=='_') ||
							(sScript.charAt(k)>='A' && sScript.charAt(k)<='Z') || 
							(sScript.charAt(k)>='a' && sScript.charAt(k)<='z') ||	
							(sScript.charAt(k)>='0' && sScript.charAt(k)<='9') ||	
							(sScript.charAt(k)=='_')	
					)	
						isBeginOrEnd=false;
				}
			}
		return isBeginOrEnd;
	}

	public static boolean executeScript(String sScript, Connection con)
	{

		boolean bRet=true;
		String sSql="";
		int iFirst=0;
		int j = 0;
		// remove all comments
		if (sScript.indexOf("--")>=0 ||sScript.indexOf("#")>0)
			sScript=removeComments(sScript);
		try
		{
			while (iFirst<sScript.length()-1)
			{
				boolean found = false;
				boolean lit = false;
				int begin = 0;
				char clit = '\'';
				// skips initial blanks
				while (j < sScript.length()-1 && 
						((sScript.charAt(j) == '\n') ||
								(sScript.charAt(j) == '\t') ||
								(sScript.charAt(j) == '\r') ||
								(sScript.charAt(j) == ' ')))
					j++;

				iFirst = j;

				// looks for a ; or an EOF
				while (j < sScript.length()-1 && !found)
				{
					if (lit)
					{
						if (sScript.charAt(j) == clit)
							lit = false;
						j++;
					}
					else if (begin>0)
					{
						if (isBeginEnd(sScript,j,"end;")) // found end token in code snippet 
						{
							begin--;
							j+=4; // include the semicolon!!!
							if (begin==0)
								found = true;            	   		
						}
						else
							if (isBeginEnd(sScript,j,"begin")) // we have a code snippet - mostly Triggers, etc which have to be executed as a block
							{
								begin++;
								j+=4;
							}        		   
							else
								j++;   
					}
					else if (sScript.charAt(j) == ';')
					{
						found = true;
						j++;
					}
					else
					{
						if (sScript.charAt(j) == '\'' || sScript.charAt(j) == '"')
						{
							lit = true;
							clit = sScript.charAt(j);
						}
						else
							if (isBeginEnd(sScript,j,"begin")) // we have a code snippet - mostly Triggers, etc which have to be executed as a block
							{
								begin++;
								j+=4;
							}        		   
						j++;
					} 
				}
				if (j > iFirst)
				{
					if (sScript.charAt(j-1)==';')
						sSql = sScript.substring(iFirst, j-1);
					else
						sSql = sScript.substring(iFirst, j);

				}
				else
				{
					sSql = "";
					sScript = "";
				}
				// execute the sSql now...
				try
				{
					if (sSql.length()>3)
					{
						if (sSql.charAt(0)<' ')
							sSql=sSql.substring(1);
						//System.out.println("[DI9] SQL Command: "+sSql);
						Statement stmt=con.createStatement();
						if (sSql.indexOf("CREATE OR REPLACE")>=0)
						{
							stmt.executeUpdate(sSql);
							con.commit();
						}
						else
							stmt.executeUpdate(sSql);
					}
				}
				catch (Error E)
				{
					bRet=false;
					System.out.println("[DI9] JVM Extreme Error in script[1] SQL: "+sSql+"\n - "+E.toString());

				}
				catch (Exception e)
				{
					bRet=false;
					System.out.println("[DI9] Error in script[1] SQL: "+sSql + "\n EXCP: "+e.toString());
				}

			}   	  
		}
		catch (Exception e)
		{
			bRet=false;
			System.out.println("[DI9] Java Error executing script[1] SQL: "+sScript);
			System.out.println("[DI9] Java Error executing script[2] EXCP: "+e.toString());

		}
		return bRet;
	}


	public void importDI6 (Connection con, Connection diCon, JspWriter out, DICountry countrybean,
			String clean_database,String events,String causes,String levels,String geography,String data,String definition,String sExtension, 
			String shiftlevel, String newlev0, String newlev0_name, String newlev0_name_en)
	{
		try
		{
			//	 updater stmt
			stmt=con.createStatement();
			rset=null;
			boolean isDI=false;
			try
			{
				qstmt=diCon.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
				rset=qstmt.executeQuery("select serial  from fichas,extension,lev0 where fichas.serial='' and fichas.clave=clave_ext and level0=lev0_cod and clave=-1");
				isDI=true;
				rset.close();
			}
			catch (Exception e)	
			{// todo: log here the error.
				System.out.println("[DI9] Error testing DI database:" +e.toString());
			}	
			String sName="";
			String sName_en="";
			if (isDI)
			{
				// ALL TRANSFERS BASED ON PREPARED STATEMENTS FOR SIMPLICITY AND SPEED!!!

				// transfer events
				if (events.equals("Y"))
					sName = importEvents(con, out, sName);
				// transfer causes
				if (causes.equals("Y"))
					sName = importCauses(con, out, sName);		
				// transfer levels
				int nLevel=0;
				int nShift=extendedParseInt(shiftlevel); //, String newlev00;
				if (levels.equals("Y"))
					importLevels(con, diCon, out, nShift);

				if (geography.equals("Y"))
				{
					sName = importLevel0(con, out, newlev0, newlev0_name, newlev0_name_en, sName, nShift);
					sName = importLevel1(con, out, newlev0, sName, nShift);			
					sName = importLevel2(con, out, newlev0, sName, nShift);	
					importRegiones(con, out, countrybean, newlev0, sName, nShift);
				}

				importMetadataTables(con, diCon, out, countrybean, clean_database);


				// transfer NON-Sendai extension definition...
				if (definition.equals("Y"))
					sName = importExtensionDefinition(con, diCon, out, countrybean,	sName);
				else
					// transfer Sendai extension definition...
					importSendaiExtensionDefinition(con, diCon, out, countrybean, clean_database);



				extension woExtension=new extension();
				// loads the extension definition
				woExtension.dbType=countrybean.dbType;
				// fixed: this would mean losing fields in target DB. woExtension.loadExtension(con,countrybean);

				woExtension.loadExtension(diCon,countrybean);
				

				// transfer fichas and extension
				if (sExtension.equals("Y") || data.equals("Y"))
				{
					// loads an arraylist of all extension variables to be transferred

					rset=qstmt.executeQuery("select nombre_campo from diccionario order by orden");
					ArrayList vars=new ArrayList();
					while (rset.next())
					{
						vars.add(rset.getString("nombre_campo"));
					}
					// prepares the statement to return the newly inserted primary key (which is an autoincrement field)
					PreparedStatement qestmt=con.prepareStatement("select clave from fichas where uu_id=?");
					PreparedStatement pestmt=null;
					pestmt=con.prepareStatement("insert into extension (clave_ext) values(?)");
					// the actual query to be transferred	
					qstmt=diCon.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
					rset=qstmt.executeQuery("select * from fichas left join extension on fichas.clave = extension.clave_ext"); // order by clave");
					/// gets the metadata of the resultset
					ResultSetMetaData meta = rset.getMetaData();
					// and runs the transfer cycle...
					int nrec=0;
					fichas DataCard=new fichas();
					DataCard.dbType=countrybean.dbType;
					while (rset.next())
					{
						try
						{		
							nrec++;
							DataCard.init();
							woExtension.init();				
							DataCard.serial=String.valueOf(DataCard.getSequence("fichas_seq", con));

							DataCard.loadWebObject(rset);
							if (nrec % 200==0)
							{
								System.out.println("[DI9] Transfering record #"+nrec+" serial "+DataCard.serial);
								if (out!=null)
									out.println("<br>Transfering record #"+nrec+" serial "+DataCard.serial);
							}

							if (DataCard.di_comments.length()==0) // if it's not blank, it's ok
							{
								// tries to get older version 
								try
								{
									DataCard.di_comments=not_null(rset.getString("observa"));
									DataCard.di_comments+=not_null(rset.getString("observa2"));
									DataCard.di_comments+=not_null(rset.getString("observa3"));
								}
								catch (Exception nobs2)
								{// do nothing
								}
							}

							if (nShift==1)
							{
								if (DataCard.level2.length()>0)
									DataCard.lugar=DataCard.name2+(DataCard.lugar.length()>0?", ":"")+DataCard.lugar;							
								if (DataCard.level1.length()>0)
									DataCard.level2=newlev0+DataCard.level1;
								else
									DataCard.level2="";
								DataCard.name2=DataCard.name1;
								DataCard.level1=newlev0+DataCard.level0;
								DataCard.name1=DataCard.name0;
								DataCard.level0=newlev0;
								DataCard.name0=newlev0_name;						
							}
							else if (nShift==-1)
							{
								DataCard.level0=DataCard.level1;
								DataCard.name0=DataCard.name1;
								DataCard.level1=DataCard.level2;
								DataCard.name1=DataCard.name2;
								DataCard.level2="";
								DataCard.name2="";
							}

							try{
								DataCard.clave=0;
								// this is needed only when a database is being synched, when datacards may already exist
								if (!bConsolidateUniverse || !clean_database.equals("Y"))
									if (DataCard.uu_id.length()>0)
									{
										// datacard trasferred, get the generated primary key 
										qestmt.setString(1, DataCard.uu_id);
										ResultSet erset=qestmt.executeQuery();
										if (erset.next())
											DataCard.clave=erset.getInt("clave");
									}

								int nrows=0;
								if (DataCard.clave==0)
								{
									nrows=DataCard.addWebObject(con);
									if (nrows==0)
										System.out.println("[DI9]: DATACARD NOT ADDED !!");
									// inserts an empty extension to guarantee the pair!!!
									pestmt.setInt(1,DataCard.clave);
									nrows=pestmt.executeUpdate();							
									if (nrows==0)
										System.out.println("[DI9]: EXTENSION NOT ADDED !!");
								}
								else							
								{
									nrows=DataCard.updateWebObject(con);
									if (nrows==0)
										System.out.println("[DI9]: DATACARD NOT UPDATED!!");
									woExtension.init();
									woExtension.clave_ext=DataCard.clave;
									woExtension.getWebObject(con);
								}

								// if the extension is to be passed, updates the rest of the fields
								if (sExtension.equals("Y") && vars.size()>0)
								{
									// note the set of existing data must be preserved in case of sync with a db with a different set of extension vars.
									woExtension.loadWebObject(rset);
									try {
										woExtension.clave_ext=DataCard.clave;
										nrows=woExtension.updateWebObject(con);
									}
									catch (Exception e)
									{
										if (out!=null)
											out.println("<br>EXTENSION  [Serial="+DataCard.serial+" EV="+DataCard.evento+" L0="+DataCard.level0+" L1="+DataCard.level1+" L2="+DataCard.level2+"] "+ e.toString());
										System.out.println("[DI9] EXTENSION  [Serial="+DataCard.serial+" EV="+DataCard.evento+" L0="+DataCard.level0+" L1="+DataCard.level1+" L2="+DataCard.level2+"] "+ e.toString());
									}
								}
							}
							catch (Exception e)
							{
								if (out!=null)
									out.println("<br>DATA  [Serial="+DataCard.serial+" EV="+DataCard.evento+" L0="+DataCard.level0+" L1="+DataCard.level1+" L2="+DataCard.level2+"] "+ e.toString());
								System.out.println("[DI9] DATA  [Serial="+DataCard.serial+" EV="+DataCard.evento+" L0="+DataCard.level0+" L1="+DataCard.level1+" L2="+DataCard.level2+"] "+ e.toString());

							}
						}
						catch(Exception e)
						{
							// log here the error type
							// log here the error type
							if (out!=null)
								out.println("<br>DATA/EXTENSION  [Serial="+DataCard.serial+" EV="+DataCard.evento+" L0="+DataCard.level0+" L1="+DataCard.level1+" L2="+DataCard.level2+"] "+ e.toString());
							System.out.println("[DI9] DATA/EXTENSION  [Serial="+DataCard.serial+" EV="+DataCard.evento+" L0="+DataCard.level0+" L1="+DataCard.level1+" L2="+DataCard.level2+"] "+ e.toString());
						}			
					}	
					pestmt.close();
				}	
			}
			stmt.close();
			pstmt.close();
			// CLOSE THE DI DATABASE
			diCon.close();
		}
		catch (Exception emain)
		{
			emain.printStackTrace();
		}

		// removes the entry from tips - it will not show real data
		CountryTip.getInstance().remove(countrybean.countrycode);

	}


	private void importMetadataTables(Connection con, Connection diCon, JspWriter out, DICountry countrybean, String clean_database)
	throws SQLException, IOException 
	{
		if (bConsolidateUniverse)
		{
			// in GAR consolidated database original country codes are kept in the metadata
			copyTables(diCon, con,  "metadata_national","metadata_country <>'@@@'", null,null);
			copyTables(diCon, con,  "metadata_national_values","metadata_country <>'@@@'", null,null);
			copyTables(diCon, con,  "metadata_national_lang","metadata_country <>'@@@'", null,null);		

			copyTables(diCon, con,  "metadata_element","metadata_country <>'@@@'", null,null);
			copyTables(diCon, con,  "metadata_element_costs","metadata_country <>'@@@'", null,null); 
			copyTables(diCon, con,  "metadata_element_lang","metadata_country <>'@@@'", null,null);
			copyTables(diCon, con,  "metadata_element_indicator","metadata_country <>'@@@'", null,null);			
		}
		else
		{

			// on normal transfer of data in import, the @@@ country entries need to be transferred if we are cleaning the database
			if (clean_database.equals("Y"))
			{

				copyTables(diCon, con,  "metadata_indicator",null, null,null);
				copyTables(diCon, con,  "metadata_indicator_lang",null, null,null);

				copyTables(diCon, con,  "metadata_national","metadata_country='@@@'", null,null);
				copyTables(diCon, con,  "metadata_national_values","metadata_country='@@@'", null,null);
				copyTables(diCon, con,  "metadata_national_lang","metadata_country='@@@'", null,null);		

				copyTables(diCon, con,  "metadata_element","metadata_country='@@@'", null,null);
				copyTables(diCon, con,  "metadata_element_costs","metadata_country='@@@'", null,null); 
				copyTables(diCon, con,  "metadata_element_lang","metadata_country='@@@'", null,null);
				copyTables(diCon, con,  "metadata_element_indicator","metadata_country='@@@'", null,null);
			}

			// on normal transfer of data in import, the country code needs to be converted into the current country code
			copyTables(diCon, con,  "metadata_national","metadata_country <>'@@@'", "metadata_country",countrybean.countrycode);
			copyTables(diCon, con,  "metadata_national_values","metadata_country <>'@@@'", "metadata_country",countrybean.countrycode);
			copyTables(diCon, con,  "metadata_national_lang","metadata_country <>'@@@'", "metadata_country",countrybean.countrycode);		

			copyTables(diCon, con,  "metadata_element","metadata_country <>'@@@'", "metadata_country",countrybean.countrycode);
			copyTables(diCon, con,  "metadata_element_costs","metadata_country <>'@@@'", "metadata_country",countrybean.countrycode); 
			copyTables(diCon, con,  "metadata_element_lang","metadata_country <>'@@@'", "metadata_country",countrybean.countrycode);
			copyTables(diCon, con,  "metadata_element_indicator","metadata_country <>'@@@'", "metadata_country",countrybean.countrycode);

		}

		// NOT NEEDED: copyTables(diCon, con,  "metadata_indicator","");		
		//             copyTables(diCon, con,  "metadata_indicator_lang","");

	}

	private String importExtensionDefinition(Connection con, Connection diCon, JspWriter out, DICountry countrybean, String sName)
	throws SQLException, IOException 
	{

		importExtensionTabs(con, out);

		String sName_en="";
		rset=qstmt.executeQuery("select * from diccionario");
		Statement estmt=diCon.createStatement ();
		ResultSet erset=estmt.executeQuery("select * from extension");
		/// gets the metadata of the resultset
		ResultSetMetaData meta = erset.getMetaData();
		int nCurrentFieldType=0;
		int nCurrentFieldSize=30;
		pstmt = con.prepareStatement("insert into diccionario(orden,nombre_campo,descripcion_campo,label_campo,pos_x,pos_y,lon_x,lon_y,color,label_campo_en,tabnumber,fieldtype) values (?,?,?,?,?,?,?,?,?,?,?,?)");
		String sFieldName="";
		int nField=0;
		diccionario dict= new diccionario();
		while (rset.next())
		{
			try
			{
				sFieldName=rset.getString("nombre_campo").toUpperCase();
				dict.nombre_campo=sFieldName;
				int nRows=dict.getWebObject(con);
				if (nRows<1)
				{
					nCurrentFieldType=0;
					nCurrentFieldSize=30;			
					nField=0;
					// look for the column..
					for  (j=1; j<=meta.getColumnCount() && nField==0; j++)
						if (meta.getColumnName(j).equalsIgnoreCase(sFieldName))
							nField=j; 
					// get the DesInventar closest Type.
					int nType=meta.getColumnType(nField);
					switch (nType)
					{
					case Types.CLOB:							   	
					case 1111: // type reported by Oracle for BLOB types...
					case -1: // type reported by ACCESS for MEMO types...
					case Types.BLOB:
						nCurrentFieldType=5;
						nCurrentFieldSize=16;			  
						break;
					case Types.DATE:
						nCurrentFieldType=4;
						nCurrentFieldSize=16;			  
						break;
					case Types.DECIMAL:
					case Types.DOUBLE:
					case Types.FLOAT:
					case Types.REAL:
					case Types.NUMERIC:
						nCurrentFieldType=2;
						nCurrentFieldSize=8;
						if (meta.isCurrency(nField) || meta.getPrecision(nField)==2)
							nCurrentFieldType=3;
						break;
					case Types.SMALLINT:
					case Types.INTEGER:
					case Types.BIGINT:
					case Types.TINYINT:
						nCurrentFieldType=1;
						nCurrentFieldSize=4;			  
						break;
					case Types.VARCHAR:
						nCurrentFieldType=0;
						nCurrentFieldSize=meta.getColumnDisplaySize(nField);			  
						break;
					}
					// mySQL requires variable names in lowercase. Others don't really matter
					String sSql="alter table extension add "+sFieldName.toLowerCase()+" "+DbImplementation.typeNames[countrybean.country.ndbtype][nCurrentFieldType];
					if (nCurrentFieldType==0)
						sSql+="("+nCurrentFieldSize+")";
					try
					{
						stmt.executeUpdate(sSql);
					}
					catch (Exception e)
					{
						// log here the error type
						if (out!=null)
							out.println("<br>WARNING: EXTENSION DEFINITION ["+nField+"-"+sFieldName+"("+DbImplementation.typeNames[countrybean.country.ndbtype][nCurrentFieldType]+")] <!--"+ e.toString()+"-->");
						System.out.println("[DI9] WARNING: EXTENSION DEFINITION ["+nField+"-"+sFieldName+"("+DbImplementation.typeNames[countrybean.country.ndbtype][nCurrentFieldType]+")] "+ e.toString());
					}
					// if it reached here, the field has just been added to the table OK
					pstmt.setInt(1, rset.getInt("orden"));
					pstmt.setString(2, sFieldName);
					pstmt.setString(3, rset.getString("descripcion_campo"));
					sName=rset.getString("label_campo");
					pstmt.setString(4, sName);
					pstmt.setInt(5, rset.getInt("pos_x"));
					pstmt.setInt(6, rset.getInt("pos_y"));
					pstmt.setInt(7, rset.getInt("lon_x"));
					pstmt.setInt(8, rset.getInt("lon_y"));
					pstmt.setInt(9, rset.getInt("color"));
					sName_en="";
					try {
						sName_en=rset.getString("label_campo_en");							
					}
					catch (Exception e1){
						sName_en=sName;
					}
					if (sName_en==null)
						sName_en=sName;
					pstmt.setString(10, sName_en);

					int tabnumber=0;
					try{
						tabnumber=rset.getInt("tabnumber");							
					}
					catch (Exception e1){
					}
					try{
						tabnumber=sExistingTabs.get(sNewTabs.get(tabnumber));
					}
					catch (Exception e1){
					}
					pstmt.setInt(11, tabnumber);

					int nFieldType=1;
					try{
						nFieldType=rset.getInt("fieldtype");							
					}
					catch (Exception e1){
						nFieldType=1;
					}
					pstmt.setInt(12, nFieldType);
					pstmt.executeUpdate();

				}

			}
			catch(Exception e)
			{
				// log here the error type
				if (out!=null)
					out.println("<br>EXTENSION DEFINITION  ["+nField+"-"+sFieldName+"("+DbImplementation.typeNames[countrybean.country.ndbtype][nCurrentFieldType]+")] <!--"+ e.toString()+"-->");
			}			
		}
		erset.close();
		estmt.close();

		// everything ready, now get the extension codes
		importExtensionCodes(con, out);
		return sName;
	}

	/** 
	 * imports all of the additional non-standard Metadata - disaggregation related fields of a database
	 * */
	private void importSendaiExtensionDefinition(Connection con, Connection diCon, JspWriter out, DICountry countrybean,  String clean_database)
	throws SQLException, IOException 
	{
		// retrieve list of metadata_elements that may or not be in extension, but should be there if they are defined in the metadata groups  
		rset=qstmt.executeQuery("select * from metadata_element_indicator where metadata_country <>'@@@'");
		MetadataElementIndicator metaElementIndicator=new MetadataElementIndicator();
		MetadataElement metaElement= new MetadataElement();
		// with the same indicator
		while (rset.next())
		{
			metaElementIndicator.loadWebObject(rset);
			// import only if it does not exist already
			diccionario dict=new diccionario(); 
			dict.nombre_campo="LOSS_"+metaElementIndicator.metadata_element_key;			
			int nRows=dict.getWebObject(con);
			if (nRows<=0)
			{
				metaElement.metadata_element_key=metaElementIndicator.metadata_element_key;
				// changes this to current country code
				metaElement.metadata_country=countrybean.countrycode;
				metaElement.getWebObject(con);
				generateMetadataExtensions(con,metaElement);			
			}
		}

	}



	private String importLevel0(Connection con, JspWriter out, String newlev0,
			String newlev0_name, String newlev0_name_en, String sName, int nShift)
	throws SQLException, IOException {
		String sName_en;
		// transfer level0
		pstmt = con.prepareStatement("insert into lev0 (lev0_cod,lev0_name, lev0_name_en) values (?,?,?)");

		if (nShift==1)
		{
			pstmt.setString(1,newlev0.trim());
			sName=newlev0_name;
			pstmt.setString(2, sName);
			sName_en=newlev0_name_en;
			if (sName_en.length()==0)
				sName_en=sName;
			pstmt.setString(3, sName_en);
			try{
				pstmt.executeUpdate();
			}
			catch (Exception el0)
			{
				// log here the error type 
				if (out!=null)
					out.println("<br>LEVEL 0 ignoring add of new root element: ["+not_null(sName)+"]  <!--"+el0.toString()+"-->");				
			}
		}
		else
		{
			rset=qstmt.executeQuery("select * from lev"+(0-nShift));
			while (rset.next())
			{
				try
				{
					sName=rset.getString("lev"+(0-nShift)+"_cod").trim();
					pstmt.setString(1, sName);
					sName=rset.getString("lev"+(0-nShift)+"_name");
					pstmt.setString(2, sName);
					sName_en="";
					try 
					{
						sName_en=rset.getString("lev"+(0-nShift)+"_name_en");							
					}
					catch (Exception e1)
					{
						sName_en=sName;
					}
					if (not_null(sName_en).length()==0)
						sName_en=sName;
					pstmt.setString(3, sName_en);
					pstmt.executeUpdate();
				}
				catch(Exception e)
				{
					// log here the error type 
					if (out!=null)
						out.println("<br>LEVEL 0: ["+not_null(sName)+"]  <!--"+e.toString()+"-->");
				}			
			}

		}
		return sName;
	}


	private String importLevel1(Connection con, JspWriter out, String newlev0,
			String sName, int nShift) throws SQLException, IOException {
		String sName_en;
		// transfer level1
		rset=qstmt.executeQuery("select * from lev"+(1-nShift));
		pstmt = con.prepareStatement("insert into lev1 (lev1_cod,lev1_name,lev1_lev0, lev1_name_en) values (?,?,?,?)");
		while (rset.next())
		{
			try
			{
				sName=rset.getString("lev"+(1-nShift)+"_cod").trim();
				if (nShift==1)
					sName=newlev0+sName;
				pstmt.setString(1, sName);
				sName=rset.getString("lev"+(1-nShift)+"_name");
				pstmt.setString(2, sName);
				if (nShift==1)
					pstmt.setString(3, newlev0);
				else
					pstmt.setString(3, rset.getString("lev"+(1-nShift)+"_lev"+(0-nShift)));
				sName_en="";
				try 
				{
					sName_en=rset.getString("lev"+(1-nShift)+"_name_en");							
				}
				catch (Exception e1)
				{
					sName_en=sName;
				}
				if (not_null(sName_en).length()==0)
					sName_en=sName;
				pstmt.setString(4, sName_en);
				pstmt.executeUpdate();
			}
			catch(Exception e)
			{
				// log here the error type? 
				if (out!=null)
					out.println("<br>LEVEL 1: ["+not_null(sName)+"]  <!--"+e.toString()+"-->");
			}			
		}
		return sName;
	}


	private String importLevel2(Connection con, JspWriter out, String newlev0,
			String sName, int nShift) throws SQLException, IOException {
		String sName_en;
		// transfer level2
		if (nShift>=0) // only in this case...
		{
			rset=qstmt.executeQuery("select * from lev"+(2-nShift));
			pstmt = con.prepareStatement("insert into lev2 (lev2_cod,lev2_name,lev2_lev1, lev2_name_en) values (?,?,?,?)");
			while (rset.next())
			{
				try
				{
					sName=rset.getString("lev"+(2-nShift)+"_cod").trim();
					if (nShift==1)
						sName=newlev0+sName;
					pstmt.setString(1, sName);
					sName=rset.getString("lev"+(2-nShift)+"_name");
					pstmt.setString(2, sName);
					if (nShift==1)
						pstmt.setString(3, newlev0+rset.getString("lev"+(2-nShift)+"_lev"+(1-nShift)));
					else
						pstmt.setString(3, rset.getString("lev"+(2-nShift)+"_lev"+(1-nShift)));
					sName_en="";
					try 
					{
						sName_en=rset.getString("lev"+(2-nShift)+"_name_en");							
					}
					catch (Exception e1)
					{
						sName_en=sName;
					}
					if (not_null(sName_en).length()==0)
						sName_en=sName;
					pstmt.setString(4, sName_en);
					pstmt.executeUpdate();
				}
				catch(Exception e)
				{
					// log here the error type
					if (out!=null)
						out.println("<br>LEVEL 2: ["+not_null(sName)+"]  <!--"+e.toString()+"-->");
				}			
			}

		}
		return sName;
	}


	private void importRegiones(Connection con, JspWriter out,
			DICountry countrybean, String newlev0, String sName, int nShift)
	throws SQLException, IOException {
		String sName_en;
		boolean bRegionsOK=false;
		try
		{
			String sSql="select * from regiones";
			if (nShift==1)
				sSql+=" where nivel<2";
			if (nShift==-1)
				sSql+=" where nivel>0";
			rset=qstmt.executeQuery(sSql);
			bRegionsOK=true;
		}
		catch (Exception r){}
		String sSql="insert into regiones (codregion,nombre,x,y,angulo,"+countrybean.dbHelper[countrybean.dbType].sqlXmin()+",ymin,"+
		countrybean.dbHelper[countrybean.dbType].sqlXmax()+",ymax,xtext,ytext,nivel,ap_lista,lev0_cod,nombre_en) "+
		"values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		pstmt = con.prepareStatement(sSql);
		while (bRegionsOK && rset.next())
		{
			try
			{
				sName=rset.getString("codregion").trim();
				if (nShift==1)
					sName=newlev0+sName;
				pstmt.setString(1, sName);
				sName=rset.getString("nombre");
				pstmt.setString(2, sName);
				pstmt.setDouble(3, rset.getDouble("x"));
				pstmt.setDouble(4, rset.getDouble("y"));
				pstmt.setDouble(5, rset.getDouble("angulo"));
				pstmt.setDouble(6, rset.getDouble("xmin"));
				pstmt.setDouble(7, rset.getDouble("ymin"));
				pstmt.setDouble(8, rset.getDouble("xmax"));
				pstmt.setDouble(9, rset.getDouble("ymax"));
				pstmt.setDouble(10, rset.getDouble("xtext"));
				pstmt.setDouble(11, rset.getDouble("ytext"));
				pstmt.setInt(12, rset.getInt("nivel")+nShift);
				pstmt.setInt(13, rset.getInt("ap_lista"));
				sName=not_null(rset.getString("lev0_cod"));
				if (nShift==1)
					sName=newlev0+sName;
				pstmt.setString(14, set_null(sName));
				sName_en="";
				try 
				{
					sName_en=rset.getString("nombre_en");							
				}
				catch (Exception e1)
				{
					sName_en=sName;
				}
				if (sName_en==null)
					sName_en=sName;
				pstmt.setString(15, sName_en);
				pstmt.executeUpdate();
			}
			catch(Exception e)
			{
				// log here the error type
				if (out!=null)
					out.println("<br>REGIONS: ["+not_null(sName)+"]  <!--"+e.toString()+"-->");
			}			
		}
	}


	private void importLevels(Connection con,  Connection diCon, JspWriter out,  int nShift) throws SQLException, IOException 
	{
		String sName_en;
		rset=qstmt.executeQuery("select  nivel,descripcion, descripcion_en, longitud  from niveles order by nivel");
		// warning: levels SHOULD exist in ALL DI6 and DI7 databases...
		niveles oLevel=new niveles();
		LevelMaps lmMap=new LevelMaps(); 
		LevelAttributes lmAttr= new LevelAttributes();
		int imaplevel=0;
		int iattrlevel=0;
		while (rset.next())
		{
			try
			{
				oLevel.loadWebObject(rset);
				lmMap.map_level=oLevel.nivel-1;
				imaplevel=lmMap.getWebObject(diCon);
				lmAttr.table_level=oLevel.nivel-1;
				iattrlevel=lmMap.getWebObject(diCon);
				// shift level up or down
				oLevel.nivel+=nShift;
				if (oLevel.nivel>=0 && oLevel.nivel<=3)
				{				
					oLevel.addWebObject(con);
					oLevel.updateWebObject(con);
					// and now transfer associated objects:  level maps, attributes
					if (imaplevel>0)
					{
						lmMap.map_level=oLevel.nivel-1;
						lmMap.addWebObject(con);
						lmMap.updateWebObject(con);
					}
					if (iattrlevel>0)
					{
						lmAttr.table_level=oLevel.nivel-1;
						lmAttr.addWebObject(con);
						lmAttr.updateWebObject(con);
					}					
				}
			}
			catch(Exception e)
			{
				// log here the error type
				if (out!=null)
					out.println("<br>UPDATING LEVEL: ["+oLevel.nivel+"]  <!--"+e.toString()+"-->");
			}			
		}	

		rset=qstmt.executeQuery("select * from info_maps order by layer");		   	
		InfoMaps imlayer=new InfoMaps();
		while (rset.next())
		{
			try
			{
				imlayer.loadWebObject(rset);
				imlayer.addWebObject(con);
				imlayer.updateWebObject(con);
			}
			catch(Exception e)
			{
				// log here the error type
				if (out!=null)
					out.println("<br>Importing map layers: ["+oLevel.nivel+"]  <!--"+e.toString()+"-->");
			}			

		}
	}


	private String importCauses(Connection con, JspWriter out, String sName)
	throws SQLException, IOException {
		String sName_en;
		try
		{   // fix to old bug in DI6 that allows failure in referential integrity.
			qstmt.executeUpdate("insert into causas select distinct causa, causa as causa_en from fichas where causa not in (select causa from causas)");
		}
		catch(Exception e)
		{
			// log here the error type
			if (out!=null)
				out.println("<br>CAUSE: ["+not_null(sName)+"]  <!--"+e.toString()+"-->");
		}			
		rset=qstmt.executeQuery("select * from causas");
		pstmt = con.prepareStatement("insert into causas (causa, causa_en) values (?,?)");
		while (rset.next())
		{
			try
			{
				sName=rset.getString("causa").trim();
				if (sName.length()>25)
					sName=sName.substring(0,25);
				pstmt.setString(1, sName);
				sName_en="";
				try 
				{
					sName_en=rset.getString("causa_en").trim();							
				}
				catch (Exception e1)
				{
					sName_en=sName;
				}
				if (sName_en==null)
					sName_en=sName;
				if (sName_en.length()>25)
					sName_en=sName_en.substring(0,25);
				pstmt.setString(2, sName_en);
				pstmt.executeUpdate();
			}
			catch(Exception e)
			{
				// log here the error type
				if (out!=null)
					out.println("<br>CAUSE: ["+not_null(sName)+"]  <!--"+e.toString()+"-->");
			}			
		}
		return sName;
	}

	private void importExtensionTabs(Connection con, JspWriter out)  
	{
		try{
			nMaxTab=0;

			rset=stmt.executeQuery("select ntab,svalue from extensiontabs order by ntab");
			while (rset.next())
			{
				nMaxTab=rset.getInt("ntabs");
				sExistingTabs.put(rset.getString("svalue"),nMaxTab);
			}
			rset.close();
			rset=qstmt.executeQuery("select ntab, nsort, svalue, svalue_en from extensiontabs");
			pstmt = con.prepareStatement("insert into extensiontabs (ntab, nsort, svalue, svalue_en) VALUES (?, ?, ?, ?)");
			String svalue="";

			while (rset.next())
			{
				try
				{
					int ntab=rset.getInt("ntab");
					sNewTabs.put(ntab,svalue);
					ntab+=nMaxTab;
					int nsort=rset.getInt("nsort");
					svalue=rset.getString("svalue");
					String svalue_en=rset.getString("svalue_en");
					// adds only if is a new tab
					if (sExistingTabs.get(svalue)==null)
					{
						int f=1;
						pstmt.setInt(f++, ntab);
						pstmt.setInt(f++, nsort);
						if (svalue == null || svalue.length() == 0)
							pstmt.setNull(f++, Types.VARCHAR);
						else
							pstmt.setString(f++, svalue);

						if (svalue_en == null || svalue_en.length() == 0)
							pstmt.setNull(f++, Types.VARCHAR);
						else
							pstmt.setString(f++, svalue_en);
						int nrows = pstmt.executeUpdate();
						// saves tab position for future reference
						sExistingTabs.put(svalue,ntab);
					}						
				}
				catch(Exception e)
				{
					// log here the error type
					if (out!=null)
						out.println("<br>TAB:  ["+not_null(svalue)+"]  <!--"+e.toString()+"-->");
				}			
			}
		}
		catch (Exception e)
		{
			try{
				if (out!=null)
					out.println("<br>TAB: No tabs in source database  <!--"+e.toString()+"-->");
			}
			catch (Exception e2)
			{}
		}

	}

	private void importExtensionCodes(Connection con, JspWriter out)  
	{
		try{
			rset=qstmt.executeQuery("select * from extensioncodes");
			pstmt = con.prepareStatement("insert into extensioncodes (nsort, svalue, svalue_en, field_name, code_value) VALUES (?, ?, ?, ?, ?)");
			String svalue="";

			while (rset.next())
			{
				try
				{
					int nsort=rset.getInt("nsort");
					svalue=rset.getString("svalue");
					String svalue_en=rset.getString("svalue_en");
					String field_name=rset.getString("field_name");
					String code_value=rset.getString("code_value");
					int f=1;
					pstmt.setInt(f++, nsort);
					if (svalue==null || svalue.length()==0)
						pstmt.setNull(f++, java.sql.Types.VARCHAR);
					else
						pstmt.setString(f++, svalue);
					if (svalue_en==null || svalue_en.length()==0)
						pstmt.setNull(f++, java.sql.Types.VARCHAR);
					else
						pstmt.setString(f++, svalue_en);
					if (field_name==null || field_name.length()==0)
						pstmt.setNull(f++, java.sql.Types.VARCHAR);
					else
						pstmt.setString(f++, field_name);
					if (code_value==null || code_value.length()==0)
						pstmt.setNull(f++, java.sql.Types.VARCHAR);
					else
						pstmt.setString(f++, code_value);

					int nrows = pstmt.executeUpdate();
				}
				catch(Exception e)
				{
					// log here the error type
					if (out!=null)
						out.println("<br>EXT-Code:  ["+not_null(svalue)+"]  <!--"+e.toString()+"-->");
				}			
			}
		}
		catch (Exception e)
		{
			try{
				if (out!=null)
					out.println("<br>TAB: No extension codes in source database  <!--"+e.toString()+"-->");
			}
			catch (Exception e2)
			{}
		}

	}



	private String importEvents(Connection con, JspWriter out, String sName)
	throws SQLException, IOException {
		String sName_en;
		rset=qstmt.executeQuery("select * from eventos");
		pstmt = con.prepareStatement("insert into eventos (serial,nombre, nombre_en, descripcion) values (?,?,?,?)");
		while (rset.next())
		{
			try
			{
				pstmt.setInt(1, rset.getInt("serial"));
				sName=rset.getString("nombre").trim();
				if (sName.length()>30)
					sName=sName.substring(0,30);
				pstmt.setString(2, sName);
				sName_en="";
				try 
				{
					sName_en=rset.getString("nombre_en").trim();							
				}
				catch (Exception e1)
				{
					sName_en=sName;
				}
				if (sName_en==null)
					sName_en=sName;
				if (sName_en.length()>30)
					sName_en=sName_en.substring(0,30);

				pstmt.setString(3, sName_en);
				pstmt.setString(4, rset.getString("descripcion"));
				pstmt.executeUpdate();
			}
			catch(Exception e)
			{
				// log here the error type
				if (out!=null)
					out.println("<br>EVENT: ["+not_null(sName)+"]  <!--"+e.toString()+"-->");
			}			
		}
		return sName;
	}



	public static void cleanDatabase(Connection con,  DICountry countrybean)
	{
		Statement stmt=null; 

		try{
			stmt=con.createStatement();

			try{
				stmt.executeUpdate("truncate table wordsdocs");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from wordsdocs");
			}
			try{
				stmt.executeUpdate("truncate table words");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from words");
			}
			try{
				stmt.executeUpdate("truncate table media_file");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from media_file");
			}
			try{
				stmt.executeUpdate("truncate table extension");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from extension");
			}


			try{
				stmt.executeUpdate("drop table extension");
				stmt.executeUpdate("CREATE TABLE extension (clave_ext "+DbImplementation.typeNames[countrybean.dbType][1]+" NOT NULL ) ");
				stmt.executeUpdate("ALTER TABLE extension ADD CONSTRAINT PK_extension PRIMARY KEY   (clave_ext)  ");
				stmt.executeUpdate("ALTER TABLE extension ADD CONSTRAINT FK_extension_fichas FOREIGN KEY (clave_ext) REFERENCES fichas (clave) ");
			}
			catch (Exception exex)
			{
				System.out.println("[DI9] Exception erasing data, extension table : "+exex.toString());				
			}


			try{stmt.executeUpdate("alter table wordsdocs drop constraint FK_wordsdocs_fichas");}catch (Exception e){}


			try{
				stmt.executeUpdate("truncate table fichas");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from fichas");
			}



			try{
				stmt.executeUpdate("truncate table lev2");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from lev2");
			}
			try{
				stmt.executeUpdate("truncate table lev1");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from lev1");
			}
			try{
				stmt.executeUpdate("truncate table lev0");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from lev0");
			}
			try{
				stmt.executeUpdate("truncate table regiones");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from regiones");
			}
			try {stmt.executeUpdate("delete from event_grouping");}catch (Exception qx){}
			try{
				stmt.executeUpdate("truncate table eventos");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from eventos");
			}
			try{
				stmt.executeUpdate("truncate table causas");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from causas");
			}



			// these don't come from DI8, preserve them for local transfers:
			try{stmt.executeUpdate("delete from info_maps");}catch(Exception el){}
			try{stmt.executeUpdate("delete from level_maps");}catch(Exception el){}
			try{stmt.executeUpdate("delete from level_attributes");}catch(Exception el){}
			try{stmt.executeUpdate("delete from attribute_metadata");}catch(Exception el){}

			try{
				stmt.executeUpdate("truncate table niveles");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from niveles");
			}
			try{
				stmt.executeUpdate("truncate table extensioncodes");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from extensioncodes");
			}
			try{
				stmt.executeUpdate("truncate table extensiontabs");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from extensiontabs");
			}
			try{
				stmt.executeUpdate("truncate table diccionario");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from diccionario");
			}

			/* Reverse Order of Metadata Tables
			 */

			try{
				stmt.executeUpdate("truncate table metadata_element_indicator");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from metadata_element_indicator");
			}
			try{
				stmt.executeUpdate("truncate table metadata_element_lang");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from metadata_element_lang");
			}
			try{
				stmt.executeUpdate("truncate table metadata_element_costs");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from metadata_element_costs");
			}
			try{
				stmt.executeUpdate("truncate table metadata_element");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from metadata_element");
			}

			try{
				stmt.executeUpdate("truncate table metadata_indicator_lang");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from metadata_indicator_lang");
			}
			try{
				stmt.executeUpdate("truncate table metadata_indicator");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from metadata_indicator");
			}

			try{
				stmt.executeUpdate("truncate table metadata_national_lang");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from metadata_national_lang");
			}
			try{
				stmt.executeUpdate("truncate table metadata_national_values");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from metadata_national_values");
			}
			try{
				stmt.executeUpdate("truncate table metadata_national");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from metadata_national");
			}
			try{stmt.executeUpdate("ALTER TABLE wordsdocs ADD CONSTRAINT FK_wordsdocs_fichas FOREIGN KEY (docid) REFERENCES fichas (clave);");}catch (Exception e){}

		}
		catch (Exception e)
		{
			System.out.println("[DI9] Exception erasing data : "+e.toString());
		}
		finally {
			try {stmt.close();}catch (Exception e2){}
		}

	}


	public static void  migrateToSendai(dbConnection dbCon, Connection con, JspWriter out, DICountry countrybean,ServletContext sc, String dblang) throws IOException
	{
		Statement stmt=null;


		out.write("Verification of a DesInventar database type:  ");

		// if the database type is access
		if (countrybean.country.ndbtype==Sys.iAccessDb)
		{
			out.write("Converting database to Derby  (MS ACCESS IS NOT SUPPORTED)<br/> \r\n");
			// Create the new derby database in the same folder as the default for the country
			String sBasePath= "jdbc:derby:"+countrybean.country.sjetfilename.replace("\\","/");
			if (!sBasePath.endsWith("/"))
				sBasePath+="/";
			sBasePath+="derbyDB_"+countrybean.countrycode+";create=true;";

			pooledConnection derbyDB=new pooledConnection("org.apache.derby.jdbc.EmbeddedDriver",sBasePath, "","");	
			boolean ok=derbyDB.getConnection();
			Connection diCon=derbyDB.connection;	
			// sets the new conditions in the country bean
			countrybean.dbType=countrybean.country.ndbtype=countrybean.country.dbType=Sys.iDerbyDb;
			countrybean.country.sdatabasename=sBasePath;
			countrybean.country.sdriver="org.apache.derby.jdbc.EmbeddedDriver";
			// create all tables and objects	
			String sSourcePath= sc.getRealPath("/scripts/create_derby.sql");
			dbutils.executeFileScript(sSourcePath,  diCon);

			out.write("\r\n\t<br><br>Executed Database creation script: ");
			out.print(sSourcePath);
			out.write("<br/><br/>\r\n");
			out.write("\t\t<br/>");

			//  transfer all the content of the Access DB to Derby
			dbutils importer=new dbutils();
			// just in case the database already exists:
			dbutils.cleanDatabase( diCon,   countrybean);
			importer.importDI6 (diCon, con, out, countrybean, "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "0", "", "", "");
			derbyDB.close();

			// update the Region record
			dbConnection dbDefaultCon=new dbConnection();
			ok = dbDefaultCon.dbGetConnectionStatus();
			if (ok)
			{
				Connection dcon=dbDefaultCon.dbGetConnection();
				countrybean.dbType=countrybean.country.ndbtype=Sys.iDerbyDb;
				countrybean.country.sdatabasename=sBasePath;
				countrybean.country.sdriver="org.apache.derby.jdbc.EmbeddedDriver";
				countrybean.country.updateWebObject(dcon);
				// MUST return this connection!
				dbDefaultCon.close();	
			}

			// close the old access database
			dbCon.close();
			// re-open the new database
			dbCon=new dbConnection(countrybean.country.sdriver,countrybean.country.sdatabasename,
					countrybean.country.susername,countrybean.country.spassword);
			boolean bConnectionOK = dbCon.dbGetConnectionStatus(); 
			if (bConnectionOK)
			{	
				con=dbCon.dbGetConnection();
			}
		} // end of automated conversion of Access

		// we are sure have a compliant database. Execute all the scripts, language dependent
		// execute the creation of all fixed indicators
		String strFileName=sc.getRealPath("/scripts")+"/Sendai_"+countrybean.getLanguage().toLowerCase()+".sql";
		try	{
			File f=new File(strFileName);
			if (!f.exists())
			{
				strFileName=sc.getRealPath("/scripts/Sendai_en.sql");
				f=new File(strFileName);
			}
			dbutils.executeFileScript(strFileName, con);
			out.write("<br><br>Executed Sendai Basic Indicators creation script: ");
			out.print(strFileName);
			stmt=con.createStatement();
			String sSql="insert into metadata_national (metadata_key, metadata_country,metadata_variable, metadata_description, metadata_source, metadata_default_value)" +
			" select metadata_key, '"+countrybean.countrycode.toLowerCase()+"' as metadata_country, metadata_variable, metadata_description, metadata_source, metadata_default_value" +
			" from metadata_national where metadata_country='@@@'";
			int nrows=stmt.executeUpdate(sSql);
			sSql="insert into metadata_national_lang (metadata_key, metadata_country, metadata_lang, metadata_description)" +
			" select metadata_key, '"+countrybean.countrycode.toLowerCase()+"' as metadata_country, metadata_lang, metadata_description" +
			" from metadata_national_lang where metadata_country='@@@'";
			nrows=stmt.executeUpdate(sSql);
			out.write("<br><br>Executed Sendai National metadata parameter creation sql.");	
			out.write("<br><br>");		
			try{stmt.close();}catch (Exception e){}
		}
		catch (Exception excreate)
		{
			out.write("\r\n<br><br>Error while attempting to create Sendai Basic Indicators Data: ");
			out.print(strFileName);
			out.write("<br>\r\nError: ");
			out.print(excreate.toString());
			out.write("        <br><br>");
		}

		// create the HTML templates for Data collection
		String sSourcePath= sc.getRealPath("/html/datacard_UN.html");
		strFileName=sc.getRealPath("/html")+"/datacard_"+countrybean.countrycode.toUpperCase()+".html_";
		try	{
			FileCopy.copy(sSourcePath, strFileName);
			out.write("<br>Created HTML template (remove _ at the end of name to enable): "+strFileName);

			String[] sLanguages={"es","pt","fr","ru","zn","ar","al","id","ir","la","th","mn","sr","vn"};
			for (int j=0; j<sLanguages.length; j++)
			{
				sSourcePath= sc.getRealPath("/html/datacard_UN_"+sLanguages[j]+".html");
				File f=new File(sSourcePath);
				if (f.exists())
				{
					strFileName=sc.getRealPath("/html/datacard_"+countrybean.countrycode.toUpperCase()+"_"+sLanguages[j]+".html_");
					FileCopy.copy(sSourcePath, strFileName);
					out.write("<br/>Created HTML template (remove _ at the end of name to enable): "+strFileName);
				}				
			}

			out.write("<br><br>");		
		}
		catch (Exception excreate)
		{
			out.write("\r\n<br><br>Error while attempting to create Sendai Basic Indicators Data: ");
			out.print(strFileName);
			out.write("<br>\r\nError: ");
			out.print(excreate.toString());
			out.write("        <br><br>");
		}


	}


	public static void  rollBackFromSendai(dbConnection dbCon, Connection con, JspWriter out, DICountry countrybean,ServletContext sc, String dblang) throws IOException
	{
		Statement stmt=null;
		ResultSet rset=null;

		// execute the removal of all fixed indicators
		String strFileName=sc.getRealPath("/scripts")+"/Rollback_Sendai_en.sql";
		try	{
			dbutils.executeFileScript(strFileName, con);
			out.write("<br><br>Executed Sendai Basic Indicators rollback  script: ");
			out.print(strFileName);

			out.write("<br><br>Rolling back metadata-based disaggregation indicators: ");
			stmt=con.createStatement();
			rset=stmt.executeQuery("select * from metadata_element where metadata_country='"+countrybean.countrycode.toLowerCase()+"'");
			String sSql=null;
			int nrows=0;
			MetadataElement metaelement=new	MetadataElement();
			while (rset.next())
			{
				metaelement.loadWebObject(rset);
				removeMetadataExtensions(con,metaelement);
			}

			sSql="delete from  metadata_national_values";
			try{nrows=stmt.executeUpdate(sSql);} catch (Exception e){};
			sSql="delete from  metadata_national_lang";
			try{nrows=stmt.executeUpdate(sSql);} catch (Exception e){};
			sSql="delete from  metadata_national";
			try{nrows=stmt.executeUpdate(sSql);} catch (Exception e){};
			sSql="delete from  metadata_element_costs"; 
			try{nrows=stmt.executeUpdate(sSql);} catch (Exception e){};
			sSql="delete from  metadata_element_lang";
			try{nrows=stmt.executeUpdate(sSql);} catch (Exception e){};
			sSql="delete from  metadata_element_indicator";
			try{nrows=stmt.executeUpdate(sSql);} catch (Exception e){};
			sSql="delete from  metadata_element";
			try{nrows=stmt.executeUpdate(sSql);} catch (Exception e){};
			sSql="delete from  metadata_indicator_lang";
			try{nrows=stmt.executeUpdate(sSql);} catch (Exception e){};
			sSql="delete from  metadata_indicator";
			try{nrows=stmt.executeUpdate(sSql);} catch (Exception e){};


			out.write("<br><br>Executed Sendai National metadata parameter creation sql.");



			out.write("<br><br>");		
		}
		catch (Exception excreate)
		{
			out.write("\r\n<br><br>Error while attempting to create Sendai Basic Indicators Data: ");
			out.print(strFileName);
			out.write("<br>\r\nError: ");
			out.print(excreate.toString());
			out.write("        <br><br>");
		}
		try{rset.close();}catch (Exception e){}
		try{stmt.close();}catch (Exception e){}

		out.write("<br><br>");		


	}


	public static void generateMetadataEntry(int nIndCode, int meta_key, DICountry countrybean, Connection con)
	{
		MetadataElement metaElement= new MetadataElement();
		metaElement.dbType=countrybean.dbType;
		MetadataElementIndicator metaElementIndicator=new MetadataElementIndicator();
		MetadataElementLang metalang=new MetadataElementLang();
		// if we are adding a new member
		metaElement.metadata_element_key=meta_key;
		// gets the model from @@@
		metaElement.metadata_country="@@@";
		metaElement.getWebObject(con);
		// saves it in the country space
		metaElement.metadata_country=countrybean.countrycode;
		metaElement.addWebObject(con);
		// with the same indicator
		metaElementIndicator.indicator_key=nIndCode;
		metaElementIndicator.metadata_element_key=meta_key;
		metaElementIndicator.metadata_country=countrybean.countrycode;
		metaElementIndicator.addWebObject(con);
		try{
			// copies all translations to this country
			Statement stmt=con.createStatement();
			ResultSet rset=stmt.executeQuery("select * from metadata_element_lang where metadata_country='@@@' and metadata_element_key="+metaElement.metadata_element_key);
			while (rset.next())
			{
				metalang.loadWebObject(rset);
				metalang.metadata_country=countrybean.countrycode;
				metalang.addWebObject(con);
			}
			// verifies if national language exists
			metalang.metadata_element_key=metaElement.metadata_element_key;
			metalang.metadata_country="@@@";
			metalang.metadata_lang=countrybean.getLanguage().toLowerCase();
			int nLangRecs=metalang.getWebObject(con);
			// if it isn't covered, then adds the  language.
			if (nLangRecs==0)
			{
				metalang.metadata_lang="en";
				metalang.getWebObject(con);
				metalang.metadata_lang=countrybean.getLanguage().toLowerCase();
				metalang.addWebObject(con);
			}				
			generateMetadataExtensions(con,metaElement);

		}
		catch (Exception e)
		{
			System.out.println("Error adding metadata entry");
		}

	}

	public static void generateMetadataExtensions(Connection con, MetadataElement metaElement) throws SQLException
	{
		String fieldname="";
		String sLabel="";
		diccionario dict=new diccionario(); 
		//MetadataElementIndicator metaElementInd=new MetadataElementIndicator();
		//MetadataIndicator metaInd=new MetadataIndicator();

		int order=metaElement.getMaximum("orden", "diccionario", con)+1;

		Statement stmt=con.createStatement();

		dict.orden=order++;
		// not needed? if (metaElement.metadata_element_sector.length()>49)
		//	metaElement.metadata_element_sector=metaElement.metadata_element_sector.substring(0,49);
		dict.dbType=metaElement.dbType;
		dict.fieldtype=2; // all doubles!
		dict.lon_x=12;
		String sSQLfieldType="double";
		if (dict.dbType==Sys.iOracleDb)
			sSQLfieldType="number(24,6)";
		else if (dict.dbType==Sys.iMsSqlDb || dict.dbType==Sys.iPostgress)
			sSQLfieldType="float";

		try
		{
			dict.nombre_campo="LOSS_"+metaElement.metadata_element_key;
			dict.label_campo=dict.label_campo_en=dict.label_campo_en=dict.descripcion_campo="Loss: "+metaElement.metadata_element_sector;
			boolean derbyTryAgain=false;
			try{stmt.executeUpdate("alter table extension add "+dict.nombre_campo+" "+sSQLfieldType);} 
			catch (Exception e) 
			{derbyTryAgain=true;}
			if (derbyTryAgain)
				stmt.executeUpdate("alter table extension add "+dict.nombre_campo+" "+sSQLfieldType);
			dict.addWebObject(con);

		}
		catch(Exception emeta)
		{
			System.out.println("DI9: error generating metadata extension, variable "+dict.nombre_campo+"-"+dict.label_campo+"  Err: "+emeta.toString());
		}	

		// damage, destroyed and total created in single precision in POSTGRES, to save space.
		if (dict.dbType==Sys.iPostgress)
			sSQLfieldType="real";

		try
		{

			dict.nombre_campo="TOTAL_"+metaElement.metadata_element_key;
			dict.label_campo=dict.label_campo_en=dict.label_campo_en=dict.descripcion_campo="Total: "+metaElement.metadata_element_sector;
			stmt.executeUpdate("alter table extension add "+dict.nombre_campo+" "+sSQLfieldType);
			dict.addWebObject(con);

		}
		catch(Exception emeta)
		{
			System.out.println("DI9: error generating metadata extension, variable "+dict.nombre_campo+"-"+dict.label_campo);
		}	
		try
		{				
			dict.nombre_campo="DAMAGED_"+metaElement.metadata_element_key;
			dict.label_campo=dict.label_campo_en=dict.label_campo_en=dict.descripcion_campo="Damaged: "+metaElement.metadata_element_sector;
			stmt.executeUpdate("alter table extension add "+dict.nombre_campo+" "+sSQLfieldType);
			dict.addWebObject(con);

		}
		catch(Exception emeta)
		{
			System.out.println("DI9: error generating metadata extension, variable "+dict.nombre_campo+"-"+dict.label_campo);
		}	
		try
		{
			dict.nombre_campo="DESTRYD_"+metaElement.metadata_element_key;
			dict.label_campo=dict.label_campo_en=dict.label_campo_en=dict.descripcion_campo="Destroyed: "+metaElement.metadata_element_sector;
			stmt.executeUpdate("alter table extension add "+dict.nombre_campo+" "+sSQLfieldType);
			dict.addWebObject(con);

		}
		catch(Exception emeta)
		{
			System.out.println("DI9: error generating metadata extension, variable "+dict.nombre_campo+"-"+dict.label_campo);
		}	
		try {stmt.close();} catch (Exception e){}

	}


	public static void removeMetadataExtensions(Connection con, MetadataElement metaElement) throws Exception
	{
		diccionario dict=new diccionario(); 
		Statement stmt=con.createStatement();	
		String sDropClause="alter table extension drop column ";

		try
		{
			dict.nombre_campo="LOSS_"+metaElement.metadata_element_key;
			stmt.executeUpdate(sDropClause+dict.nombre_campo);
			dict.deleteWebObject(con);

		}
		catch(Exception emeta)
		{
			System.out.println("DI9: error deleting metadata extension, variable "+dict.nombre_campo+"-"+dict.label_campo+"  Err: "+emeta.toString());
		}	
		try
		{

			dict.nombre_campo="TOTAL_"+metaElement.metadata_element_key;
			stmt.executeUpdate(sDropClause+dict.nombre_campo);
			dict.deleteWebObject(con);

		}
		catch(Exception emeta)
		{
			
			System.out.println("DI9: error deleting metadata extension, variable "+dict.nombre_campo+"-"+dict.label_campo);
		}	
		try
		{				
			dict.nombre_campo="DAMAGED_"+metaElement.metadata_element_key;
			stmt.executeUpdate(sDropClause+dict.nombre_campo);
			dict.deleteWebObject(con);

		}
		catch(Exception emeta)
		{
			System.out.println("DI9: error deleting metadata extension, variable "+dict.nombre_campo+"-"+dict.label_campo);
		}	
		try
		{
			dict.nombre_campo="DESTRYD_"+metaElement.metadata_element_key;
			stmt.executeUpdate(sDropClause+dict.nombre_campo);
			dict.deleteWebObject(con);

		}
		catch(Exception emeta)
		{
			System.out.println("DI9: error deleting metadata extension, variable "+dict.nombre_campo+"-"+dict.label_campo);
		}	
		try {stmt.close();} catch (Exception e){}
	}

	public static void updateMetadataExtensions(Connection con, MetadataElement metaElement) throws Exception
	{
		diccionario dict=new diccionario(); 

		try
		{
			dict.nombre_campo="LOSS_"+metaElement.metadata_element_key;
			dict.getWebObject(con);
			dict.label_campo_en=dict.label_campo_en=dict.descripcion_campo="Loss: "+metaElement.metadata_element_sector;
			dict.updateWebObject(con);

			dict.nombre_campo="TOTAL_"+metaElement.metadata_element_key;
			dict.getWebObject(con);
			dict.label_campo_en=dict.label_campo_en=dict.descripcion_campo="Total: "+metaElement.metadata_element_sector;
			dict.updateWebObject(con);

			dict.nombre_campo="DAMAGED_"+metaElement.metadata_element_key;
			dict.getWebObject(con);
			dict.label_campo_en=dict.label_campo_en=dict.descripcion_campo="Damaged: "+metaElement.metadata_element_sector;
			dict.updateWebObject(con);

			dict.nombre_campo="DESTRYD_"+metaElement.metadata_element_key;
			dict.getWebObject(con);
			dict.label_campo_en=dict.label_campo_en=dict.descripcion_campo="Destroyed: "+metaElement.metadata_element_sector;
			dict.updateWebObject(con);

		}
		catch(Exception emeta)
		{
			System.out.println("DI9: error updating metadata extension, variable "+dict.nombre_campo+"-"+dict.label_campo);
		}	

	}






	public void preProcessMap (Connection con, DICountry countrybean, String newlev0, int nShift)
	{   
		// WARNING:  This folder shoudl exist and have the right permissions
		String sDestFolder="/data/desinventar/databases/"+countrybean.country.scountryid+ "/";
		String sDestFile="";
		String sOrigFolder="";
		String sOrigFile="";
		try
		{
			//	 updater stmt
			stmt=con.createStatement();
			rset=null;
			DBase dbSource=null;
			DBase dbTarget=null;
			LevelMaps map=new LevelMaps();
			// reads the maps table
			qstmt=con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
			rset=qstmt.executeQuery("select * from level_maps order by map_level");
			while (rset.next())
			{
				map.loadWebObject(rset);
				// nShift   level   map to
				// 0        0       1
				//          1       2
				//          2       discard
				// 1        0       discard
				//          1       1
				//          2       2
				if (nShift==1)
					map.map_level+=1;
				
				File fmap=new File(map.filename);
				//				if ((map.map_level==1 || map.map_level==2) && map.filename.length()>4 && fmap.exists())
				if (map.map_level<=2 && map.filename.length()>4 && fmap.exists())
				{
					// automatically redirect maps in Production server config:
					// copy physical maps to GAR13 folder', starting with shapefile
					sDestFile="L"+map.map_level+"_"+newlev0;
					FileCopy.copy(map.filename, sDestFolder+sDestFile+".shp");
					// trim the extension..
					int pos=map.filename.lastIndexOf("/");
					sOrigFolder=map.filename.substring(0,pos+1);
					sOrigFile=map.filename.substring(pos+1,map.filename.length()-4);
					FileCopy.copy(sOrigFolder+sOrigFile+".shx", sDestFolder+sDestFile+".shx");
					// model of Dbase file, with CODIGO and NOMBRE  (sorry, got these easy in Spanish, code and name :-)
					FileCopy.copy(sDestFolder+"dbmodel.dbf", sDestFolder+sDestFile+".dbf");
					// open both dBase files
					dbSource = new DBase(sOrigFolder);				
					dbTarget = new DBase(sDestFolder);				
					String sqlSelect="";
					try {
						sqlSelect="select "+map.lev_code+","+map.lev_name+" from "+sOrigFile;
						dbSource.exec(sqlSelect);
					}
					catch (Exception e)
					{
						System.out.println("[DI9] Exception opening table, 1st attempt:"+e+"");
						try {
							sqlSelect="select "+map.lev_code+","+map.lev_name+" from \""+sOrigFile+"\"";
							dbSource.exec(sqlSelect);
						}
						catch (Exception e2)
						{
							System.out.println("[DI9] Exception opening table, 2nd attempt:"+e2+"");
						}

					}
					// cunttries with shift=0 dont add code				
					String sqlInsert="";
					while (dbSource.next())
					{
						String sCode=webObject.not_null(dbSource.getString(map.lev_code));  // there may be records with nothing in the code (Argentina, for example)						if (sCode.endsWith(".0")) // came from a numeric field!

						if (sCode.endsWith(".0"))
							sCode=sCode.substring(0,sCode.length()-2);
						// fixes Uruguay bad codes (UY instead or URY)
						if (newlev0.equalsIgnoreCase("URY") &&  sCode.startsWith("UY")) // just double checking :-)
							sCode="URY"+sCode.substring(2);
						if (sCode!=null && sCode.length()>0)
							sqlInsert="insert into "+sDestFile +" (CODREGION, NOMBRE) values ('"+check_quotes((nShift==0?"":newlev0)+sCode) + "','"+ check_quotes(dbSource.getString(map.lev_name))+"')";
						else
							sqlInsert="insert into "+sDestFile +" (CODREGION, NOMBRE) values ('','"+ check_quotes(dbSource.getString(map.lev_name))+"')";
						//System.out.println(sqlInsert);
						try{
							dbTarget.exec(sqlInsert);
						}
						catch (Exception iex)
						{
							System.out.println("[DI9] Exception inserting:"+iex+"");
						}
					}

					dbTarget.closeTable();
					dbSource.closeTable();
					// close everything
				}
			}
			rset.close();
			qstmt.close();

		}
		catch (Exception e)
		{

		}
	}


	public static String validateLevel0(Connection con, String sCode)
	{
		String sRetCode="";
		PreparedStatement pstmt=null;
		ResultSet rset=null;

		if (sCode.length()>16)
			sCode=sCode.substring(0,16);

		try{
			pstmt=con.prepareStatement("select lev0_cod from lev0 where lev0_cod=?");
			pstmt.setString(1, sCode);
			rset=pstmt.executeQuery();
			if (rset.next())
			{
				if (sCode.equalsIgnoreCase(rset.getString(1)))
					sRetCode=sCode;
			}			
		}
		catch (Exception e)
		{
			// nothing to do code is not valid
		}
		finally
		{
			try {rset.close();}catch (Exception e){} 
			try {pstmt.close();}catch (Exception e){} 
		}		
		return sRetCode;
	}


	public static String validateHazard(Connection con, String sCode)
	{
		String sRetCode="";
		PreparedStatement pstmt=null;
		ResultSet rset=null;

		if (sCode.length()>32)
			sCode=sCode.substring(0,32);

		try{
			pstmt=con.prepareStatement("select nombre from eventos where nombre=?");
			pstmt.setString(1, sCode);
			rset=pstmt.executeQuery();
			if (rset.next())
			{
				if (sCode.equalsIgnoreCase(rset.getString(1)))
					sRetCode=sCode;
			}			
		}
		catch (Exception e)
		{
			// nothing to do code is not valid
		}
		finally
		{
			try {rset.close();}catch (Exception e){} 
			try {pstmt.close();}catch (Exception e){} 
		}		
		return sRetCode;
	}

	public static String validateCause(Connection con, String sCode)
	{
		String sRetCode="";
		PreparedStatement pstmt=null;
		ResultSet rset=null;

		if (sCode.length()>32)
			sCode=sCode.substring(0,32);

		try{
			pstmt=con.prepareStatement("select causa from causas where causa=?");
			pstmt.setString(1, sCode);
			rset=pstmt.executeQuery();
			if (rset.next())
			{
				if (sCode.equalsIgnoreCase(rset.getString(1)))
					sRetCode=sCode;
			}			
		}
		catch (Exception e)
		{
			// nothing to do code is not valid
		}
		finally
		{
			try {rset.close();}catch (Exception e){} 
			try {pstmt.close();}catch (Exception e){} 
		}		
		return sRetCode;
	}


	/**
	 * 
	 * @param source   JDBC Connection to source database
	 * @param dest  JDBC Connection to destination database 
	 * @param sTable  String table name to copy
	 * @param sWhere  String with a where clause to restrict copy to certain rows
	 * @return
	 */
	public static int copyTables(Connection source, Connection dest, String sTable, String sWhere, String sFieldToConvert, String sConvertValue)
	{
		int nRows=0;

		Statement stmt = null;
		PreparedStatement insertStatement = null;
		try
		{
			stmt = source.createStatement();
			// simple query to get all data in the table
			String sSql="select * from "+sTable;
			if (sWhere!=null && sWhere.length()>0)
				sSql+=" where "+sWhere;

			ResultSet rset = stmt.executeQuery(sSql);

			// Get required metadata information about the table
			ResultSetMetaData rsmd = rset.getMetaData();
			int columnCount = rsmd.getColumnCount();

			// now assemble the insert statement
			StringBuffer sFields= new StringBuffer("insert into ");
			sFields.append(sTable);
			sFields.append(" (");

			StringBuffer sParams= new StringBuffer(") values (");

			// get all column names, count starts from 1
			for (int i = 1; i <= columnCount; i++ ) 
			{
				String name = rsmd.getColumnName(i);
				// add name and parameter to query
				if (i>1)
					sFields.append(",");
				sFields.append(name);
				if (i>1)
					sParams.append(",");
				sParams.append("?");
			}
			sFields.append(sParams);
			sFields.append(")");
			insertStatement = dest.prepareStatement(sFields.toString());
			while (rset.next())
			{
				// Insert a row with these values into table2
				insertStatement.clearParameters();
				// get all column values, count starts from 1
				for (int i = 1; i <= columnCount; i++ ) 
				{
					String sFieldName=rsmd.getColumnName(i);
					switch (rsmd.getColumnType(i))
					{
					case Types.DATE:
					case Types_Oracle_Date:
						insertStatement.setDate(i, rset.getDate(i));
						break;
					case Types.NUMERIC:
					case Types.DECIMAL:
					case Types.DOUBLE:
					case Types.FLOAT:
					case Types.REAL:
						insertStatement.setDouble(i, rset.getDouble(i));
						break;
					case Types.SMALLINT:
					case Types.INTEGER:
					case Types.TINYINT:
						insertStatement.setInt(i, rset.getInt(i));
						break;
					case Types.BIGINT:
						insertStatement.setLong(i, rset.getLong(i));
						break;
					case Types.CLOB:
					case Types_Oracle_CLOB:
						try{
							Clob sClob=rset.getClob(i);
							String sStr=sClob.getSubString(1, (int) sClob.length());
							insertStatement.setString(i, sStr);
						}catch(Exception e){
							System.out.println("[DI9] Error copying CLOB field in record "+nRows+" in generic table "+sTable+" Err:"+e.toString());

						}
						break;
					default:
						if (sFieldName.equalsIgnoreCase(sFieldToConvert))
							insertStatement.setString(i, sConvertValue);
						else
							insertStatement.setString(i, rset.getString(i));
					}									
				}				
				try{
					insertStatement.executeUpdate();
				}
				catch (Exception e)
				{
					System.out.println("[DI9] Error copying record "+nRows+" in generic table "+sTable+" Err:"+e.toString());
				}
				nRows++;
			}
		}
		catch (Exception e)
		{
			System.out.println("[DI9] Error copying generic table "+sTable+" Err:"+e.toString());
		}

		return nRows;
	}



	public static void main(String[] args) 
	{
		Sys.getProperties();
		DICountry countrybean= new DICountry();

		bConsolidateUniverse=true;
		bGenerateMaps=true;



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


			// GAR 2013 settings in country bean...
			countrybean.country.scountryid="g19";
			countrybean.country.getWebObject(pc_connection);
			countrybean.countrycode=countrybean.country.scountryid;
			countrybean.countryname=countrybean.country.scountryname;
			countrybean.dbType=countrybean.country.ndbtype;

			pooledConnection univ=new pooledConnection(countrybean.country.sdriver,countrybean.country.sdatabasename , countrybean.country.susername,countrybean.country.spassword);
			univ.getConnection();
			Connection con=univ.connection;


			if (bConsolidateUniverse)
				cleanDatabase(con,  countrybean);

			copyTables(pc_connection, con,  "metadata_indicator",null, null,null);
			copyTables(pc_connection, con,  "metadata_indicator_lang",null, null,null);
			copyTables(pc_connection, con,  "metadata_national","metadata_country='@@@'", null,null);
			// enable later: copyTables(pc_connection, con,  "metadata_national_values","metadata_country='@@@'", null,null);
			copyTables(pc_connection, con,  "metadata_national_lang","metadata_country='@@@'", null,null);		

			copyTables(pc_connection, con,  "metadata_element","metadata_country='@@@'", null,null);
			// enable later: copyTables(pc_connection, con,  "metadata_element_costs","metadata_country='@@@'", null,null); 
			copyTables(pc_connection, con,  "metadata_element_lang","metadata_country='@@@'", null,null);
			copyTables(pc_connection, con,  "metadata_element_indicator","metadata_country='@@@'", null,null);


			Statement stat = pc_connection.createStatement();
			ResultSet rs = null;
			// List of databases to consolidate:
			String sCountryList="select distinct metadata_country from metadata_national";			
			// Table METADATA_NATIONAL contains ISO3 codes of all countries. Make sure there is at leas one entry for "PAC", add manually if needed
			boolean bHaveCountryData=false;
			try{
				rs=stat.executeQuery(sCountryList);
				bHaveCountryData=rs.next();
			}
			catch(Exception e)
			{ /* intentional ignore */	}

			if (!bHaveCountryData)
				sCountryList=
						"'ago','alb','arg','atg','bfa','blr','blz','bol','brb','btn','bwa','cam','chl','cmr','col','com','cpv','cri','dji','dma','dom','ecu','esp','eth','etm',mne"+
						"'gin','gmb','gnb','gnq','grd','gtm','guy','hnd','idn','irn','jam','jor','kaz','ken','kgz','kna','lao','lbn','lbr','lca','lka','mdg','mdv','mex','mli','mmr',"+
						"'mng','mor','moz','mus','mwi','nam','ner','nic','npl','pac','pak','pan','per','pry','pse','rdo','rwa','sen','slb','sle','slv','som','srb','swz','syc','syr',"+
						"'tgo','tto','tun','tur','tza','uga','ury','vct','ven','vnm','yem','znz'";

				rs.close();
			
			rs = stat.executeQuery("select * from country where upper(scountryid) in (" +	sCountryList + ") order by scountryid");
			boolean bFirst=true;
			
			while (rs.next())
			{
				countrybean.country.loadWebObject(rs);
				countrybean.countrycode=countrybean.country.scountryid;
				countrybean.countryname=countrybean.country.scountryname;
				countrybean.country.dbType=countrybean.dbType=countrybean.country.ndbtype;
				countrybean.setLanguage("EN");
				System.out.println("[DI9] Importing: "+countrybean.countrycode+" - "+countrybean.countryname+ " from "+countrybean.country.sjetfilename);		    	

				dbutils diLoader=new dbutils();

				pooledConnection cnt=new pooledConnection(countrybean.country.sdriver, countrybean.country.sdatabasename,countrybean.country.susername,countrybean.country.spassword);
				boolean bOK=cnt.getConnection();
				if (bOK){
					Connection diCon=cnt.connection;
					String newlev0=countrybean.countrycode.toUpperCase();
					String shiftlevel="1";
					//if (newlev0.charAt(0)=='0' || newlev0.equals("PAC") || // Orissa and Tamil Nadu 019 and 033, Pacific, and Uruguay dont transfer 0 level
					if (newlev0.equalsIgnoreCase("PAC") || // Pacific, and Uruguay dont transfer 0 level
							newlev0.equalsIgnoreCase("URY")
							||   ("'atg','dma','grd','kna','lca','vct'".indexOf(countrybean.countrycode)>0)  // caribbean countries have country level records
					) // || newlev0.equals("LKA"))  // Pacific, Sri Lanka and Uruguay dont transfer 0 level
						shiftlevel="0";
					// dragging this for years. It has to be changed in the main database, but there are permissions also. -> longer process there.
					
					try 
					{
						String sImportEvents="Y";
						String sImportCauses="Y";
						String sImportLevels="N";
						String sImportGeography="Y";
						String sImportData="Y";
						String sImportDefinition="N";
						String sImportExtension="Y";

						if (bFirst) // gets sendai fields from  first database, usually Albania
							sImportDefinition="Y";
						bFirst=false;	
						if (bConsolidateUniverse)
							diLoader.importDI6 (con, diCon,   null , countrybean, "DONTCLEAN",sImportEvents,sImportCauses,
									sImportLevels,sImportGeography,sImportData, sImportDefinition,sImportExtension, shiftlevel, newlev0, countrybean.countryname, countrybean.countryname);
					}
					catch (Exception eImp)
					{
						System.out.println("[DI9] Error consolidating:  "+countrybean.countrycode+" - "+countrybean.countryname +" ; "+eImp.toString());
					}


					if (bGenerateMaps)
						diLoader.preProcessMap (diCon, countrybean, newlev0, extendedParseInt(shiftlevel));

					try {diCon.close();} catch (Exception e){}
				}
				else
					System.out.println("[DI9] Error importing DesInventar [NO DB CONN]: "+countrybean.countrycode+" - "+countrybean.countryname +
							  " Err="+cnt.strConnectionError);

			}
		}
		catch (Exception eImp)
		{
			System.out.println("[DI9] Error importing DesInventar UNIVERSE: "+eImp.toString());
		}

	}


}
