package org.lared.desinventar.util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;

import javax.servlet.jsp.*;

import java.io.*;
import java.sql.*;

import org.apache.poi.hssf.usermodel.HSSFRow;
import org.lared.desinventar.system.Sys;
import org.lared.desinventar.webobject.*;

public class Di8Import 
{

	public HashMap<String,String> sLoadMap=new HashMap<String,String> ();
	public HashMap<String,String> hEvents=new HashMap<String,String> ();
	public HashMap<String,String> hCauses=new HashMap<String,String> ();
	public HashMap<String,Integer> hStatus=new HashMap<String,Integer> ();
	
	public boolean bDebug=true;

	public JspWriter out=null;

	HSSFRow row=null;
	fichas datacard=new fichas();
	extension extended=new extension();

	Statement qstmt=null;
	ResultSet rset=null;


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
		int nRet=webObject.extendedParseInt(sVal);
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


	private void importLevels(Connection con, JspWriter out) throws SQLException, IOException 
	{
		rset=qstmt.executeQuery("select GeoLevelId, GeoLevelName  from GeoLevel order by GeoLevelId");
		// warning: levels SHOULD exist in ALL DI6 and DI7 databases...
		niveles lLevel=new niveles();
		while (rset.next())
		{
			try
			{
				lLevel.nivel=rset.getInt("GeoLevelId");
				lLevel.descripcion=rset.getString("GeoLevelName");
				lLevel.descripcion_en=lLevel.descripcion;
				lLevel.longitud=lLevel.nivel*2+2;
				int nr=lLevel.updateWebObject(con);
				if (nr==0)
					lLevel.addWebObject(con);
			}
			catch(Exception e)
			{
				// log here the error type
				debug("ADDING LEVELs: ["+lLevel.descripcion+"]  <!--"+e.toString()+"-->");
			}			
		}
	}


	private void importEvents(Connection con, JspWriter out) throws SQLException, IOException 
	{
		rset=qstmt.executeQuery("select EventId,EventName,EventDesc from Event order by EventId");
		// warning: levels SHOULD exist in ALL DI6 and DI7 databases...
		eventos eEvent=new eventos();
		int j=0;
		while (rset.next())
		{
			try
			{
				eEvent.serial=++j;
				eEvent.nombre_en=rset.getString("EventId");
				eEvent.nombre=rset.getString("EventName");
				// save this ID, will come in Disaster table
				hEvents.put(eEvent.nombre_en, eEvent.nombre);
				// eventid is a UUID, use the spanish name
				if (eEvent.nombre_en.length()>=30 && eEvent.nombre_en.indexOf(" ")<0 && eEvent.nombre_en.indexOf("-")<10 && eEvent.nombre.length()>0)
					eEvent.nombre_en=eEvent.nombre;
				if (eEvent.nombre.length()==0)
					{
					eEvent.nombre=eEvent.nombre_en;					
					hEvents.put(eEvent.nombre_en, eEvent.nombre);
					}
				eEvent.descripcion=rset.getString("EventDesc");
				eEvent.addWebObject(con);
			}
			catch(Exception e)
			{
				// log here the error type
				debug("<br>ADDING EVENTS: ["+eEvent.nombre+"]  <!--"+e.toString()+"-->");
			}			
		}
	}

	private void importCauses(Connection con, JspWriter out) throws SQLException, IOException 
	{
		rset=qstmt.executeQuery("select CauseId,CauseName from Cause order by CauseId");
		// warning: levels SHOULD exist in ALL DI6 and DI7 databases...
		causas cCausa=new causas();
		while (rset.next())
		{
			try
			{
				cCausa.causa_en=rset.getString("CauseId");
				cCausa.causa=rset.getString("CauseName");
				// save this ID, will come in Disaster table
				hCauses.put(cCausa.causa_en, cCausa.causa);
				// eventid is a UUID, use the spanish name
				if (cCausa.causa_en.length()>=30 && cCausa.causa_en.indexOf(" ")<0 && cCausa.causa_en.indexOf("-")<10 && cCausa.causa.length()>0)
					cCausa.causa_en=cCausa.causa;				
				if (cCausa.causa.length()==0)
					{
					cCausa.causa=cCausa.causa_en;				
					hCauses.put(cCausa.causa_en, cCausa.causa);
					}
				cCausa.addWebObject(con);
			}
			catch(Exception e)
			{
				// log here the error type
				debug("<br>ADDING CAUSE: ["+cCausa.causa+"]  <!--"+e.toString()+"-->");
			}			
		}
	}

	private void importGeo(Connection con, JspWriter out) throws SQLException, IOException 
	{
		rset=qstmt.executeQuery("select GeographyCode,GeographyName,GeographyFQName from Geography where geographylevel=0 order by GeographyCode");
		// warning: levels SHOULD exist in ALL DI6 and DI7 databases...
		lev0 lLevel0=new lev0();
		while (rset.next())
		{
			try
			{
				lLevel0.lev0_cod=rset.getString("GeographyCode");
				lLevel0.lev0_name=rset.getString("GeographyName");
				lLevel0.lev0_name_en=rset.getString("GeographyFQName");
				lLevel0.addWebObject(con);
			}
			catch(Exception e)
			{
				// log here the error type
				debug("ADDING LEVEL0: ["+lLevel0.lev0_name+"]  <!--"+e.toString()+"-->");
			}			
		}

		lev1 lLevel1=new lev1();
		rset=qstmt.executeQuery("select l0.GeographyCode as level0,"+
				" l1.GeographyCode as level1, l1.GeographyName as name1, l1.GeographyFQName as name1_en "+
		" from geography l0 join geography l1 on  l0.geographyid =substr(l1.geographyid,1,5) and l1.geographylevel=1");
		while (rset.next())
		{
			try
			{
				lLevel1.lev1_cod=rset.getString("level1");
				lLevel1.lev1_name=rset.getString("name1");
				lLevel1.lev1_name_en=lLevel1.lev1_name;
				lLevel1.lev1_lev0=rset.getString("level0");
				lLevel1.addWebObject(con);
			}
			catch(Exception e)
			{
				// log here the error type
				debug("ADDING LEVEL1: ["+lLevel1.lev1_name+"]  <!--"+e.toString()+"-->");
			}			
		}

		lev2 lLevel2=new lev2();
		rset=qstmt.executeQuery("select l1.GeographyCode as level1,"+
				" l2.GeographyCode as level2, l2.GeographyName as name2, l2.GeographyFQName as name2_en "+
		" from geography l1 join geography l2 on  l1.geographyid =substr(l2.geographyid,1,10) and l2.geographylevel=2");
		while (rset.next())
		{
			try
			{
				lLevel2.lev2_cod=rset.getString("level2");
				lLevel2.lev2_name=rset.getString("name2");
				lLevel2.lev2_name_en=lLevel2.lev2_name;
				lLevel2.lev2_lev1=rset.getString("level1");
				lLevel2.addWebObject(con);
			}
			catch(Exception e)
			{
				// log here the error type
				debug("ADDING LEVEL2: ["+lLevel2.lev2_name+"]  <!--"+e.toString()+"-->");
			}			
		}

	}

	public void extendedParseDate(String strNumber)
	{

		int y=0,m=0,d=0;
		try
		{ 

			if (strNumber == null)
			{	  
				java.util.Date uDate=new java.util.Date();
				strNumber=webObject.formatter.format(uDate);
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



	public void LoadDatacard(ResultSet rset)
	{
		try {
			String stat=rset.getString("RecordStatus");
			if (stat==null || hStatus.get(stat)==null)
				datacard.approved=4;
			else
				datacard.approved=hStatus.get(stat);

			datacard.level0=webObject.not_null(rset.getString("level0"));
			datacard.name0=webObject.not_null(rset.getString("name0"));
			datacard.level1=webObject.not_null(rset.getString("level1"));
			datacard.name1=webObject.not_null(rset.getString("name1"));
			datacard.level2=webObject.not_null(rset.getString("level2"));
			datacard.name2=webObject.not_null(rset.getString("name2"));
			datacard.serial=webObject.not_null(rset.getString("DisasterSerial"));
			datacard.evento=webObject.not_null(rset.getString("EventId"));
			// get back to the spanish version of the event
			datacard.evento=webObject.not_null(hEvents.get(datacard.evento));
			datacard.lugar=webObject.not_null(rset.getString("DisasterSiteNotes"));
			String sDecimalDate=rset.getString("DisasterBeginTime");
			this.extendedParseDate(sDecimalDate);
			datacard.duracion=webObject.extendedParseInt(rset.getString("EventDuration"));
			datacard.causa=webObject.not_null(rset.getString("CauseId"));
			// get back to the spanish version of the event
			datacard.causa=webObject.not_null(hCauses.get(datacard.causa));			
			datacard.descausa=webObject.not_null(rset.getString("CauseNotes"));
			datacard.fuentes=webObject.not_null(rset.getString("DisasterSource"));
			datacard.muertos=rset.getInt("EffectPeopleDead");		
			datacard.heridos=rset.getInt("EffectPeopleInjured");
			datacard.desaparece=rset.getInt("EffectPeopleMissing");
			datacard.afectados=rset.getInt("EffectPeopleAffected");
			datacard.vivdest=rset.getInt("EffectHousesDestroyed");
			datacard.vivafec=rset.getInt("EffectHousesAffected");
			datacard.damnificados=rset.getInt("EffectPeopleHarmed");
			datacard.evacuados=rset.getInt("EffectPeopleEvacuated");
			datacard.reubicados=rset.getInt("EffectPeopleRelocated");		
			datacard.valorloc=rset.getDouble("EffectLossesValueLocal");
			datacard.valorus=rset.getDouble("EffectLossesValueUSD");
			datacard.nhospitales=rset.getInt("EffectMedicalCenters");
			datacard.nescuelas=rset.getInt("EffectEducationCenters");
			datacard.nhectareas=rset.getDouble("EffectFarmingAndForest");
			datacard.cabezas=rset.getInt("EffectLiveStock");
			datacard.kmvias=rset.getDouble("EffectRoads");

			datacard.hay_muertos=getCheckboxValue(datacard.muertos);
			datacard.hay_heridos=getCheckboxValue(datacard.heridos);
			datacard.hay_deasparece=getCheckboxValue(datacard.desaparece);
			datacard.hay_afectados=getCheckboxValue(datacard.afectados);
			datacard.hay_vivdest=getCheckboxValue(datacard.vivdest);
			datacard.hay_vivafec=getCheckboxValue(datacard.vivafec);

			datacard.hay_otros=getCheckboxValue(rset.getInt("SectorOther"));
			datacard.socorro=getCheckboxValue(rset.getInt("SectorRelief"));

			datacard.hay_damnificados=getCheckboxValue(datacard.damnificados);
			datacard.hay_evacuados=getCheckboxValue(datacard.evacuados);
			datacard.hay_reubicados=getCheckboxValue(datacard.reubicados);		

			datacard.salud=getCheckboxValue(rset.getInt("SectorHealth"));
			datacard.educacion=getCheckboxValue(rset.getInt("SectorEducation"));
			datacard.agropecuario=getCheckboxValue(rset.getInt("SectorAgricultural"));
			datacard.industrias=getCheckboxValue(rset.getInt("SectorIndustry"));
			datacard.acueducto=getCheckboxValue(rset.getInt("SectorWaterSupply"));
			datacard.alcantarillado=getCheckboxValue(rset.getInt("SectorSewerage"));
			datacard.energia=getCheckboxValue(rset.getInt("SectorPower"));
			datacard.comunicaciones=getCheckboxValue(rset.getInt("SectorCommunications"));
			datacard.transporte=getCheckboxValue(rset.getInt("SectorTransport"));

			datacard.magnitud2=webObject.not_null(rset.getString("EventMagnitude"));
			datacard.otros=webObject.not_null(rset.getString("EffectOtherLosses"));
			datacard.di_comments=webObject.not_null(rset.getString("EffectNotes"));

			// datacard.glide=rset.getString("glide"));
			datacard.fechapor=webObject.not_null(rset.getString("RecordAuthor"));
			datacard.fechafec=webObject.not_null(rset.getString("RecordCreation"));
			datacard.latitude=rset.getDouble("DisasterLatitude");		
			datacard.longitude=rset.getDouble("DisasterLongitude");		
			datacard.uu_id=webObject.not_null(rset.getString("DisasterId"));		

			// non-normalized form of DI8:   
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
			debug("Error importing DI8 SqLite loading datacard: "+DCloading.toString());

		}

	}


	void startMap()
	{
		sLoadMap.put("serial", "DisasterSerial");
		sLoadMap.put("level0", "level0");
		sLoadMap.put("level1", "level1");
		sLoadMap.put("level2", "level2");
		sLoadMap.put("name0", "name0");
		sLoadMap.put("name1", "name1");
		sLoadMap.put("name2", "name2");
		sLoadMap.put("evento", "EventId");
		sLoadMap.put("lugar", "DisasterSiteNotes");
		sLoadMap.put("date", "DisasterBeginTime");
		sLoadMap.put("duracion", "EventDuration");
		sLoadMap.put("causa", "CauseId");
		sLoadMap.put("descausa", "CauseNotes");
		sLoadMap.put("muertos", "EffectPeopleDead");
		sLoadMap.put("heridos", "EffectPeopleInjured");
		sLoadMap.put("desaparece", "EffectPeopleMissing");
		sLoadMap.put("afectados", "EffectPeopleAffected");
		sLoadMap.put("vivdest", "EffectHousesDestroyed");
		sLoadMap.put("vivafec", "EffectHousesAffected");
		sLoadMap.put("damnificados", "EffectPeopleHarmed");
		sLoadMap.put("evacuados", "EffectPeopleEvacuated");
		sLoadMap.put("reubicados", "EffectPeopleRelocated");
		sLoadMap.put("nhospitales", "EffectMedicalCenters");
		sLoadMap.put("nescuelas", "EffectEducationCenters");
		sLoadMap.put("nhectareas", "EffectFarmingAndForest");
		sLoadMap.put("cabezas", "EffectLiveStock");
		sLoadMap.put("kmvias", "EffectRoads");
		sLoadMap.put("valorloc", "EffectLossesValueLocal");
		sLoadMap.put("valorus", "EffectLossesValueUSD");
		sLoadMap.put("otros", "EffectOtherLosses");
		sLoadMap.put("fuentes", "DisasterSource");
		sLoadMap.put("magnitud2", "EventMagnitude");

		sLoadMap.put("hay_muertos", "EffectPeopleDeadQ");
		sLoadMap.put("hay_heridos", "EffectPeopleInjuredQ");
		sLoadMap.put("hay_deasparece", "EffectPeopleMissingQ");
		sLoadMap.put("hay_vivdest", "EffectHousesDestroyedQ");
		sLoadMap.put("hay_vivafec", "EffectHousesAffectedQ");
		sLoadMap.put("hay_afectados", "EffectPeopleAffectedQ");
		sLoadMap.put("hay_damnificados", "EffectPeopleHarmedQ");
		sLoadMap.put("hay_evacuados", "EffectPeopleEvacuatedQ");
		sLoadMap.put("hay_reubicados", "EffectPeopleRelocatedQ");

		sLoadMap.put("hay_otros", "SectorOther");
		sLoadMap.put("socorro", "SectorRelief");
		sLoadMap.put("salud", "SectorHealth");
		sLoadMap.put("educacion", "SectorEducation");
		sLoadMap.put("agropecuario", "SectorAgricultural");
		sLoadMap.put("industrias", "SectorIndustry");
		sLoadMap.put("acueducto", "SectorWaterSupply");
		sLoadMap.put("alcantarillado", "SectorSewerage");
		sLoadMap.put("energia", "SectorPower");
		sLoadMap.put("comunicaciones", "SectorCommunications");
		sLoadMap.put("transporte", "SectorTransport");
		// sLoadMap.put("glide", "");
		sLoadMap.put("di_comments", "EffectNotes");
		sLoadMap.put("uu_id", "DisasterId");
		sLoadMap.put("latitude", "DisasterLatitude");
		sLoadMap.put("longitude", "DisasterLongitude");
		sLoadMap.put("fechafec", "RecordCreation");
		sLoadMap.put("fechapor", "RecordAuthor");
		
		hStatus.put("PUBLISHED", 0);
		hStatus.put("DRAFT", 1);
		hStatus.put("READY", 2); // review
		hStatus.put("TRASH", 4); // support
		hStatus.put("DELETED", 3); // rejected
		// missing?:
		hStatus.put("SUPPORT", 4);
		

	}

	public void importExtension(Connection con, DICountry countrybean, JspWriter out)
	{
		HashMap<String,Integer> extTypes=new HashMap<String,Integer>();
		// DI types={"VARCHAR","INTEGER","FLOAT","FLOAT","DATE","TEXT","INTEGER","INTEGER","INTEGER"}, // iPostgress  TODO:  verify types!!

		extTypes.put("STRING",0);
		extTypes.put("INTEGER",1);
		extTypes.put("FLOAT",2);
		extTypes.put("CURRENCY",3);
		extTypes.put("DATE",4);
		extTypes.put("TIME",0);
		extTypes.put("TEXT",5); // cloB?
		extTypes.put("BOOLEAN",6);  // YES/NO
		extTypes.put("N/A2",7); // DROPDOWN
		extTypes.put("N/A/3",8); // CHOICE
		extTypes.put("TBD",9);

		int nCurrentFieldType=0;
		int nCurrentFieldSize=30;
		String sFieldName="";
		String sFieldDesc="";
		String sFieldLabel="";
		int nField=0;
		extended.dbType=countrybean.dbType;


		try{
			Statement stmt=con.createStatement();
			rset=qstmt.executeQuery("select EEFieldID, EEFieldLabel,EEFieldDesc, EEGroupId,EEFieldType, EEFieldSize,EEFieldOrder   from EEField");
			while (rset.next())
			{
				try	{
					sFieldName=rset.getString("EEFieldID").toUpperCase();
					sFieldLabel=countrybean.not_null(rset.getString("EEFieldLabel"));
					sFieldDesc=countrybean.not_null(rset.getString("EEFieldDesc"));
					nCurrentFieldType=0;
					nCurrentFieldSize=30;			
					nField=0;
					int nType=extTypes.get(rset.getString("EEFieldType"));
					int nSize=rset.getInt("EEFieldSize");

					switch (nType)
					{
					case 4: // Types.CLOB:  case 1111: // type reported by Oracle for BLOB types...  case -1: // type reported by ACCESS for MEMO types...						   case Types.BLOB:
						nCurrentFieldType=5;
						nCurrentFieldSize=16;			  
						break;
					case 3:  //Types.DATE:
						nCurrentFieldType=4;
						nCurrentFieldSize=16;			  
						break;
					case 2: // Types.DECIMAL:  case Types.DOUBLE:   case Types.FLOAT:   case Types.REAL:   case Types.NUMERIC:
						nCurrentFieldType=2;
						nCurrentFieldSize=8;
						break;
					case 1: // Types.SMALLINT: case Types.INTEGER:  case Types.BIGINT:   case Types.TINYINT:
						nCurrentFieldType=1;
						nCurrentFieldSize=4;			  
						break;
					case 0:   //Types.VARCHAR:
						nCurrentFieldType=0;
						nCurrentFieldSize=nSize;
						if (nCurrentFieldSize==0)
							nCurrentFieldSize=50;
						break;
					}
					String sSql="alter table extension add "+sFieldName.toLowerCase()+" "+DbImplementation.typeNames[countrybean.country.ndbtype][nCurrentFieldType];
					if (nCurrentFieldType==0)
						sSql+="("+nCurrentFieldSize+")";
					try
					{
						stmt.executeUpdate(sSql);
						// if it reached here, the field has just been added to the table OK, tries to also add a dictionary item.
						//("insert into diccionario(orden,nombre_campo,descripcion_campo,label_campo,pos_x,pos_y,lon_x,lon_y,color,label_campo_en,fieldtype) values (?,?,?,?,?,?,?,?,?,?,?)");
						diccionario dct=new diccionario();
						dct.orden=rset.getInt("EEFieldOrder");
						dct.nombre_campo=sFieldName;
						dct.label_campo=sFieldLabel;
						dct.label_campo_en=sFieldLabel;
						dct.descripcion_campo=sFieldDesc;
						dct.lon_x=nCurrentFieldSize;
						dct.fieldtype=nType;
						dct.addWebObject(con);
						}
					catch (Exception e)
					{
						// log here the error type
						System.out.println("[DI9:] ERROR IN EXTENSION DEFINITION ["+nField+"-"+sFieldName+"("+DbImplementation.typeNames[countrybean.country.ndbtype][nCurrentFieldType]+")) <!--"+ e.toString()+"-->");
					}
				}
				catch(Exception e)
				{
					// log here the error type
					System.out.println("<br>EXTENSION DEFINITION  ["+nField+"-"+sFieldName+"("+DbImplementation.typeNames[countrybean.country.ndbtype][nCurrentFieldType]+")) <!--"+ e.toString()+"-->");
				}			

			}

		}
		catch (Exception eload)
		{
			System.out.println("<br>EXTENSION DEFINITION_2  ["+nField+"-"+sFieldName+"("+DbImplementation.typeNames[countrybean.country.ndbtype][nCurrentFieldType]+")) <!--"+ eload.toString()+"-->");			
		}
	}


   static java.io.PrintWriter pout;
   
	public void doGenerateFIX(DICountry countrybean)
	{

		Connection con=null; 
		Statement stmt=null; 
		ResultSet rset=null; 
		try{
				// ----------------------------------

			boolean bConnectionOK=false; 
			// opens the database 
			dbConnection dbCon=new dbConnection(countrybean.country.sdriver,countrybean.country.sdatabasename,
					countrybean.country.susername,countrybean.country.spassword);
			bConnectionOK = dbCon.dbGetConnectionStatus();
			if (bConnectionOK)
			{	
				//java.io.PrintWriter pout=new java.io.PrintWriter("c:/databases/gar13/maps/"+countrybean.country.scountryid.toUpperCase()+"markOSSOapproved.sql");
				pout.println("--SQL for country "+countrybean.countrycode+" - "+countrybean.countryname+ " from "+countrybean.country.sjetfilename);		    	

				con=dbCon.dbGetConnection();
				stmt=con.createStatement();
				rset=stmt.executeQuery("select approved, uu_id from fichas where approved>0");
				while (rset.next())
				{
					pout.println("update fichas set approved="+rset.getInt("approved")+" where uu_id='"+rset.getString("uu_id")+"';");
				}
//				pout.close();
			}
			dbCon.close();
			}
			catch (Exception e)
			{
				debug ("Exception loading: "+e.toString());
			}
		try {rset.close();}catch (Exception ex){}
		try {stmt.close();}catch (Exception ex){}
			// removes the entry from tips - it will not show real data
	}

	
	public void doImport(String sFileName, DICountry countrybean)
	{

		try{
			startMap();

			Class.forName("org.sqlite.JDBC");
			Connection sqlconn =DriverManager.getConnection("jdbc:sqlite:"+sFileName);

			// ----------------------------------
			qstmt=sqlconn.createStatement();


			eventos tstEvent=new eventos();
			causas tstCausa=new causas();
			lev0 tstLev0=new lev0();
			lev1 tstlev1=new lev1();
			lev2 tstlev2=new lev2();

			datacard.dbType=countrybean.dbType;
			extended.dbType=countrybean.dbType;

			Connection con=null; 
			Statement stmt=null; 
			ResultSet rset=null; 
			ResultSet eset=null; 
			boolean bConnectionOK=false; 
			// opens the database 
			dbConnection dbCon=new dbConnection(countrybean.country.sdriver,countrybean.country.sdatabasename,
					countrybean.country.susername,countrybean.country.spassword);
			bConnectionOK = dbCon.dbGetConnectionStatus();
			if (bConnectionOK)
			{	
				con=dbCon.dbGetConnection();
				// REMOVE THIS!!!
				dbutils.cleanDatabase( con,   countrybean);

				try {importLevels(con, out); } catch (Exception e) {debug(e.toString());}
				try {importCauses(con, out); } catch (Exception e) {debug(e.toString());}	
				try {importEvents(con, out); } catch (Exception e) {debug(e.toString());}	
				try {importGeo(con, out); } catch (Exception e) {debug(e.toString());}
				try {importExtension(con, countrybean, out); } catch (Exception e) {debug(e.toString());}

				// now it should read the names of the levels. 
				countrybean.getLevelsFromDB(con);
				extended.loadExtension(con, countrybean);

				int jRow=1;

				try{

					stmt=sqlconn.createStatement();
					String sSql="select l0.GeographyCode as level0, l0.GeographyName as name0,"+
							" l1.GeographyCode as level1, l1.GeographyName as name1,"+
							" l2.GeographyCode as level2, l2.GeographyName as name2,"+
							" d.*, ex.* from disaster d left join geography l0 on  l0.geographyid =substr(d.geographyid,1,5)"+
							" left join geography l1 on  l1.geographyid =substr(d.geographyid,1,10) and l1.geographylevel=1"+
							" left join geography l2 on  l2.geographyid =substr(d.geographyid,1,15) and l2.geographylevel=2 " +
							" left join EEDATA ex on ex.DisasterId=d.disasterID";
					rset=stmt.executeQuery(sSql);

					while (rset.next())
					{		jRow++;
					if (jRow % 100 ==0)
						debug("Processing Row "+jRow);

					datacard.init();
					datacard.serial=String.valueOf(datacard.getSequence("fichas_seq", con));
					LoadDatacard(rset);

					datacard.checkLengths();
					if (datacard.evento.length()>0 && datacard.level0.length()>0)
						{
						int nrows=datacard.addWebObject(con);
						if (nrows==0)
							debug("Not added - DC:"+datacard.lastError);
						// adds corresponding extended datacard
						// note the set of existing data must be preserved in case of sync with a db with a different set of extension vars.
						extended.loadWebObject(rset);
						extended.clave_ext=datacard.clave;
						extended.checkLengths();
						nrows=extended.addWebObject(con); 
						if (nrows==0)
							debug("Not added - EX:"+datacard.lastError);
						}
					else
						debug("WARNING: uncompliant Datacard NOT added - "+datacard.serial);

					} // while (rset.next())

				}
				catch (Exception e)
				{
					debug ("Exception loading: "+e.toString());
				}
				// removes the entry from tips - it will not show real data
				CountryTip.getInstance().remove(countrybean.countrycode);
				stmt.close();

/*				stmt=con.createStatement();
				try {rset=stmt.executeQuery("update eventos set nombre='LAHAR' where nombre='Lahar'");} catch (Exception exx){}
				try {rset=stmt.executeQuery("update eventos set nombre='SUBSIDENCE' where nombre='Hundimiento'");} catch (Exception exx){}
				try {rset=stmt.executeQuery("update eventos set nombre='SEDIMENTATION' where nombre='Asentamientos'");} catch (Exception exx){}
				try {rset=stmt.executeQuery("update eventos set nombre='FOREST FIRE' where nombre='FORESTFIRE'");} catch (Exception exx){}
				try {rset=stmt.executeQuery("update eventos set nombre='HAIL STORM' where nombre='HAILSTORM'");} catch (Exception exx){}
				try {rset=stmt.executeQuery("update eventos set nombre='HEAT WAVE' where nombre='HEATWAVE'");} catch (Exception exx){}
				try {rset=stmt.executeQuery("update eventos set nombre='CYCLONE' where nombre='HURRICANE'");} catch (Exception exx){}
				try {rset=stmt.executeQuery("update eventos set nombre='RAINS' where nombre='RAIN'");} catch (Exception exx){}
				try {rset=stmt.executeQuery("update eventos set nombre='COASTLINE' where nombre='SEAEROSION'");} catch (Exception exx){}
				try {rset=stmt.executeQuery("update eventos set nombre='SNOW STORM' where nombre='SNOWSTORM'");} catch (Exception exx){}
				try {rset=stmt.executeQuery("update eventos set nombre='FLASH FLOOD' where nombre='SPATE'");} catch (Exception exx){}
				try {rset=stmt.executeQuery("update eventos set nombre='STRONG WIND' where nombre='STRONGWIND'");} catch (Exception exx){}
				try {rset=stmt.executeQuery("update eventos set nombre='SURGE' where nombre='TIDAL WAVE'");} catch (Exception exx){}
				try {rset=stmt.executeQuery("update eventos set nombre='THUNDERSTORM' where nombre='THUNDER STORM'");} catch (Exception exx){}
				try {rset=stmt.executeQuery("update eventos set nombre='ELECTRIC STORM' where nombre='ELECTRICSTORM'");} catch (Exception exx){}

				// these four must be improved based on DB platform and versions of Length and Substr
				try {rset=stmt.executeQuery("UPDATE EVENTOS SET NOMBRE=NOMBRE_EN where len(nombre)=30 and substring(nombre,9,1)='-'");} catch (Exception exx){}
				try {rset=stmt.executeQuery("UPDATE EVENTOS SET NOMBRE=NOMBRE_EN where len(nombre)=30 and substr(nombre,9,1)='-'");} catch (Exception exx){}
				try {rset=stmt.executeQuery("UPDATE EVENTOS SET NOMBRE=NOMBRE_EN where length(nombre)=30 and substr(nombre,9,1)='-'");} catch (Exception exx){}
				try {rset=stmt.executeQuery("UPDATE EVENTOS SET NOMBRE=NOMBRE_EN where length(nombre)=30 and substring(nombre,9,1)='-'");} catch (Exception exx){}

				try {rset=stmt.executeQuery("update eventos set nombre_en=nombre where nombre_en is null  ");} catch (Exception exx){}
				//-----------------------------------
				stmy.close();
 */
				sqlconn.close();
				dbCon.close();
			} // if (bConnection...
		}
		catch (Exception eImp)
		{
			debug("Error importing DI8 SqLite db: "+eImp.toString());
		}

	}
	/**
	 * @param args
	 */
	public static void main(String[] args) 
	{

		Sys.getProperties();
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
				System.out.println ("Exception DI Import. opening main database...");
			}


			Statement stat = pc_connection.createStatement();
			ResultSet rs = stat.executeQuery("select * from country where scountryid in (" +
					"'arg','bol','chl','col','cri','ecu','gtm','guy','hnd','jam','mex','nic','pan','per','ury','ven','nic','pan','per','ury','ven'" +
			")");

		   //pout=new java.io.PrintWriter("c:/databases/gar13/maps/markOSSOapproved.sql");

			while (rs.next())
			{
				countrybean.country.loadWebObject(rs);
				countrybean.countrycode=countrybean.country.scountryid;
				countrybean.countryname=countrybean.country.scountryname;
				countrybean.country.dbType=countrybean.dbType=countrybean.country.ndbtype;
				countrybean.setLanguage("EN");
				System.out.println("Processing: "+countrybean.countrycode+" - "+countrybean.countryname+ " from "+countrybean.country.sjetfilename);		    	

				Di8Import diLoader=new Di8Import();

				// diLoader.doGenerateFIX(countrybean);
				
				diLoader.doImport(countrybean.country.sjetfilename+"desinventar.db", countrybean);

			}
			//pout.close();
	}
		catch (Exception eImp)
		{
			System.out.println("DI9: error importing DI8 SqLite db TEST: "+eImp.toString());
		}

	}

}
