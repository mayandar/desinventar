package org.lared.desinventar.util;

import java.sql.Connection;
import java.sql.ResultSet;
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
import org.lared.desinventar.webobject.*;
import org.lared.desinventar.util.DbImplementation;
import org.lared.desinventar.system.Sys;

public class JdbcLoader 
{

	// exposed variables:

	public String sTableName="";
	public HashMap<String,Integer> sLoadMap=new HashMap();
	public boolean bDebug=true;

	fichas datacard=new fichas();
	extension extended=new extension();
	// this is a large number of columns for any database table.
	final int nMaxCols=9999;
	int nSerial=1;
	int nLastCol=0;
	Statement stmt=null;
	ResultSet rset=null;


	public void setDebug(boolean stat)
	{
		bDebug=stat;
	}

	public void debug(String sMessage)
	{
		if (bDebug)
			System.out.println("[DI9] "+sMessage);
	}





	public void createExtension(HttpServletRequest request,Connection con, DICountry countrybean)
	{
		int nCurrentFieldType=0;
		int nCurrentFieldSize=30;
		String sFieldName="";
		int nField=0;
		int maxcols=webObject.extendedParseInt(request.getParameter("maxcols"));
		extended.dbType=countrybean.dbType;
		extended.loadExtension(con, countrybean);
		try{
			Statement stmt=con.createStatement();
			for (int j=1; j<=maxcols; j++)
			{
				boolean bCreateThis="Y".equals(request.getParameter("chkcol"+j));
				if (bCreateThis)
				{
					try	{
						sFieldName=request.getParameter("namecol"+j).toUpperCase();
						if (extended.asFieldNames.get(sFieldName)!=null)
							sFieldName="FIELD_DB_"+(extended.vFields.size()+j+1);
						nCurrentFieldType=0;
						nCurrentFieldSize=30;			
						nField=0;
						int nType=webObject.extendedParseInt(request.getParameter("field_type"+j));
						int nSize=webObject.extendedParseInt(request.getParameter("field_size"+j));
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
							break;
						}
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
							System.out.println("<br>EXTENSION DEFINITION ["+nField+"-"+sFieldName+"("+DbImplementation.typeNames[countrybean.country.ndbtype][nCurrentFieldType]+")) <!--"+ e.toString()+"-->");
						}
						// if it reached here, the field has just been added to the table OK

						diccionario dct=new diccionario();
						dct.orden=extended.vFields.size()+j+1;
						dct.nombre_campo=sFieldName;
						dct.label_campo=sFieldName;
						dct.label_campo_en=sFieldName;
						dct.descripcion_campo=sFieldName;
						dct.lon_x=nCurrentFieldSize;
						dct.fieldtype=nType;
						dct.addWebObject(con);						
						// and adds the variable to the loader's map
						sLoadMap.put(sFieldName,j);
					}
					catch(Exception e)
					{
						// log here the error type
						System.out.println("<br>EXTENSION DEFINITION  ["+nField+"-"+sFieldName+"("+DbImplementation.typeNames[countrybean.country.ndbtype][nCurrentFieldType]+")) <!--"+ e.toString()+"-->");
					}			

				}
			}

		}
		catch (Exception eload)
		{
			System.out.println("<br>EXTENSION DEFINITION_2  ["+nField+"-"+sFieldName+"("+DbImplementation.typeNames[countrybean.country.ndbtype][nCurrentFieldType]+")) <!--"+ eload.toString()+"-->");			
		}
	}

	private String getColumn(int nVariable)
	{
		String sRet="";
		try{
			if (nVariable<nMaxCols)
				sRet=rset.getString(nVariable);
		}
		catch (Exception e)
		{// nothing for now			
			System.out.println("[DI9] Exception getting column: "+e.toString());
		}
		return sRet;
	}

	public void loadFile (String sTableToLoad, Connection con, DICountry countrybean, HttpServletRequest request)
	{
		debug("Now starting import using spreadsheet/table "+sTableToLoad); 


		eventos tstEvent=new eventos();
		causas tstCausa=new causas();
		lev0 tstLev0=new lev0();
		lev1 tstlev1=new lev1();
		lev2 tstlev2=new lev2();

		datacard.dbType=countrybean.dbType;
		extended.dbType=countrybean.dbType;
		extended.loadExtension(con, countrybean);

		try{
			stmt=con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			rset=stmt.executeQuery("select * from "+sTableToLoad);
			// gets the metadata of the resultset
			ResultSetMetaData meta = rset.getMetaData();

			nLastCol=meta.getColumnCount();

			/* Debug code
    		String s1=sLoadMap.get("serial").toString();
	    	String s2=sLoadMap.get("level0").toString();
	    	String s3=sLoadMap.get("evento").toString();
	    	String s4=sLoadMap.get("fechano").toString()+sLoadMap.get("date").toString()+webObject.not_null(request.getParameter("serial_auto"));
			 */
			boolean bImportEvents=request.getParameter("events")!=null;
			boolean bImportGeo=request.getParameter("geography")!=null;
			boolean bImportCauses=request.getParameter("causes")!=null;

			boolean bser=request.getParameter("serial_auto")!=null;
			boolean beve=request.getParameter("evento_fixed")!=null;
			boolean bdat=request.getParameter("date_fixed")!=null;


			if (sLoadMap.get("level0")<nMaxCols && 
					(sLoadMap.get("serial")<nMaxCols || request.getParameter("serial_auto")!=null) &&
					(sLoadMap.get("evento")<nMaxCols || request.getParameter("evento_fixed")!=null) &&
					(sLoadMap.get("fechano")<nMaxCols || sLoadMap.get("date")<nMaxCols || request.getParameter("date_fixed")!=null))
			{
				int jRow=0;
				while (rset.next())
				{

					/* Debug code
    	    	s1=getColumn(sLoadMap.get("serial"));
    	    	s2=getColumn(sLoadMap.get("level0"));
    	    	s3=getColumn(sLoadMap.get("evento"));
    	    	s4=getColumn(sLoadMap.get("fechano"))+getColumn(sLoadMap.get("date"));
					 */

					// Save row info    	    	         
					boolean bProceed=( getColumn(sLoadMap.get("serial"))!=null  || request.getParameter("serial_auto")!=null) &&
					getColumn(sLoadMap.get("level0"))!=null  &&
					(getColumn(sLoadMap.get("evento"))!=null  || request.getParameter("evento_fixed")!=null) &&
					(getColumn(sLoadMap.get("fechano"))!=null || getColumn(sLoadMap.get("date"))!=null || webObject.not_null(request.getParameter("date_fixed")).length()>1);    
					if (bProceed)
					{
						debug ("Processing  Row "+(++jRow));
						if (bImportEvents && request.getParameter("evento_fixed")==null )
						{
							tstEvent.nombre=getColumn(sLoadMap.get("evento"));
							int nr=tstEvent.getWebObject(con);
							if (nr==0)
							{
								tstEvent.serial=tstEvent.getMaximum("serial", "eventos", con)+1;
								tstEvent.nombre_en=tstEvent.nombre;
								tstEvent.addWebObject(con);
								debug("Added [ev]: "+tstEvent.nombre);
							}
						}
						if (bImportCauses)
						{
							tstCausa.causa=tstCausa.not_null(getColumn(sLoadMap.get("causa")));
							if (tstCausa.causa.length()>0){
								int nr=tstCausa.getWebObject(con);
								if (nr==0)
								{
									tstCausa.causa_en=tstCausa.causa;
									tstCausa.addWebObject(con);
									debug("Added [ca]: "+tstCausa.causa);
								}
							}

						}
						if (bImportGeo)
						{
							tstLev0.lev0_cod=getColumn(sLoadMap.get("level0"));
							int nr=tstLev0.getWebObject(con);
							if (nr==0)
							{
								tstLev0.lev0_name=getColumn(sLoadMap.get("name0"));
								tstLev0.lev0_name_en=tstLev0.lev0_name;
								tstLev0.addWebObject(con);
							}    	    			
							if (tstLev0.not_null(getColumn(sLoadMap.get("level1"))).length()>0)
							{
								tstlev1.lev1_cod=getColumn(sLoadMap.get("level1"));
								nr=tstlev1.getWebObject(con);
								if (nr==0)
								{
									tstlev1.lev1_lev0=getColumn(sLoadMap.get("level0"));
									tstlev1.lev1_name=getColumn(sLoadMap.get("name1"));
									tstlev1.lev1_name_en=tstlev1.lev1_name;
									tstlev1.addWebObject(con);
								}    	    			  					   		 
								if (tstLev0.not_null(getColumn(sLoadMap.get("level2"))).length()>0)
								{
									tstlev2.lev2_cod=getColumn(sLoadMap.get("level2"));
									nr=tstlev2.getWebObject(con);
									if (nr==0)
									{
										tstlev2.lev2_lev1=getColumn(sLoadMap.get("level1"));
										tstlev2.lev2_name=getColumn(sLoadMap.get("name2"));
										tstlev2.lev2_name_en=tstlev2.lev2_name;
										tstlev2.addWebObject(con);
									}    	    			  					   		 
								}
							}
						}
						datacard.init();
						datacard.serial=String.valueOf(datacard.getSequence("fichas_seq", con));
						LoadDatacard(request);
						loadExtended();
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
					}
				}
			}  
			else
				debug ("NO LOADING:  essential fields missing !!! ");

		}
		catch (Exception e){
			debug ("Exception loading: "+e.toString());
		}

		// removes the entry from tips - it will not show real data
		CountryTip.getInstance().remove(countrybean.countrycode);
	}

	public int loadExtended()
	{

		// allocates a dictionary object to read each field
		Dictionary dct = new Dictionary();
		for (int j = 0; j < extended.vFields.size(); j++)
		{
			dct = (Dictionary) extended.vFields.get(j);
			dct.sValue=getColumn(sLoadMap.get(dct.nombre_campo));
			switch (dct.nDataType)
			{
			case Types.DATE:
			case extension.Types_Oracle_Date:
				java.sql.Date dt=null;
				try{
					dt=rset.getDate(sLoadMap.get(dct.nombre_campo));
				} catch (Exception e){}
				dct.sValue=webObject.strDate(dt);
				break;
			case Types.DECIMAL:
			case Types.DOUBLE:
			case Types.FLOAT:
			case Types.NUMERIC:
			case Types.REAL:
				dct.dNumericValue=dct.extendedParseDouble(dct.sValue);
				break;
			case Types.SMALLINT:
			case Types.INTEGER:
			case Types.BIGINT:
				dct.dNumericValue=dct.extendedParseInt(dct.sValue);
				break;
			}
		}
		return 0;
	}

	public void LoadDatacard(HttpServletRequest request)
	{
		if (request.getParameter("serial_auto")==null) 
			datacard.serial=getColumn(sLoadMap.get("serial"));
		datacard.level0=datacard.not_null(getColumn(sLoadMap.get("level0")));
		datacard.level1=datacard.not_null(getColumn(sLoadMap.get("level1")));
		datacard.level2=datacard.not_null(getColumn(sLoadMap.get("level2")));
		datacard.name0=datacard.not_null(getColumn(sLoadMap.get("name0")));
		datacard.name1=datacard.not_null(getColumn(sLoadMap.get("name1")));
		datacard.name2=datacard.not_null(getColumn(sLoadMap.get("name2")));
		if (request.getParameter("evento_fixed")!=null) 
			datacard.evento=datacard.not_null(request.getParameter("evento_fixed"));
		else
			datacard.evento=datacard.not_null(getColumn(sLoadMap.get("evento")));
		datacard.lugar=datacard.not_null(getColumn(sLoadMap.get("lugar")));
		datacard.fechano=datacard.extendedParseInt(getColumn(sLoadMap.get("fechano")));
		datacard.fechames=datacard.extendedParseInt(getColumn(sLoadMap.get("fechames")));
		datacard.fechadia=datacard.extendedParseInt(getColumn(sLoadMap.get("fechadia")));
		if (sLoadMap.get("date")<nMaxCols)
		{
			java.sql.Date dt=null;
			String sOriginalDate=getColumn(sLoadMap.get("date"));
			try{
				dt=datacard.extendedParseDate(sOriginalDate);
			} catch (Exception e){}
			GregorianCalendar cal=new GregorianCalendar();
			if (dt!=null)
				cal.setTime(dt);
			datacard.fechano=cal.get(Calendar.YEAR);
			datacard.fechames=cal.get(Calendar.MONTH)+1;
			datacard.fechadia=cal.get(Calendar.DATE);
		}
		else if (request.getParameter("date_fixed")!=null)
		{
			String sDecimalDate=request.getParameter("date_fixed");
			java.sql.Date dt=webObject.extendedParseDate(sDecimalDate);
			GregorianCalendar cal=new GregorianCalendar();
			if (dt!=null)
				cal.setTime(dt);
			datacard.fechano=cal.get(Calendar.YEAR);
			datacard.fechames=cal.get(Calendar.MONTH)+1;
			datacard.fechadia=cal.get(Calendar.DATE);
		}



		datacard.muertos=datacard.extendedParseInt(getColumn(sLoadMap.get("muertos")));		
		datacard.heridos=datacard.extendedParseInt(getColumn(sLoadMap.get("heridos")));
		datacard.desaparece=datacard.extendedParseInt(getColumn(sLoadMap.get("desaparece")));
		datacard.afectados=datacard.extendedParseInt(getColumn(sLoadMap.get("afectados")));
		datacard.vivdest=datacard.extendedParseInt(getColumn(sLoadMap.get("vivdest")));
		datacard.vivafec=datacard.extendedParseInt(getColumn(sLoadMap.get("vivafec")));
		datacard.otros=datacard.not_null(getColumn(sLoadMap.get("otros")));
		datacard.di_comments=datacard.not_null(getColumn(sLoadMap.get("di_comments")));
		datacard.uu_id=datacard.not_null(getColumn(sLoadMap.get("uu_id")));
		if (request.getParameter("fuentes_fixed")!=null) 
			datacard.fuentes=datacard.not_null(request.getParameter("fuentes_fixed"));
		else
			datacard.fuentes=datacard.not_null(getColumn(sLoadMap.get("fuentes")));
		if (request.getParameter("glide_fixed")!=null) 
			datacard.glide=datacard.not_null(request.getParameter("glide_fixed"));
		else
			datacard.glide=datacard.not_null(getColumn(sLoadMap.get("glide")));
		datacard.valorloc=datacard.extendedParseDouble(getColumn(sLoadMap.get("valorloc")));
		datacard.valorus=datacard.extendedParseDouble(getColumn(sLoadMap.get("valorus")));
		if (request.getParameter("fechapor_fixed")!=null) 
			datacard.fechapor=datacard.not_null(request.getParameter("fechapor_fixed"));
		else
			datacard.fechapor=datacard.not_null(getColumn(sLoadMap.get("fechapor")));
		if (request.getParameter("fechafec_fixed")!=null) 
			datacard.fechapor=datacard.not_null(request.getParameter("fechafec_fixed"));
		else
			datacard.fechafec=datacard.not_null(getColumn(sLoadMap.get("fechafec")));
		datacard.hay_muertos=datacard.extendedParseInt(getColumn(sLoadMap.get("hay_muertos")));
		datacard.hay_heridos=datacard.extendedParseInt(getColumn(sLoadMap.get("hay_heridos")));
		datacard.hay_deasparece=datacard.extendedParseInt(getColumn(sLoadMap.get("hay_deasparece")));
		datacard.hay_afectados=datacard.extendedParseInt(getColumn(sLoadMap.get("hay_afectados")));
		datacard.hay_vivdest=datacard.extendedParseInt(getColumn(sLoadMap.get("hay_vivdest")));
		datacard.hay_vivafec=datacard.extendedParseInt(getColumn(sLoadMap.get("hay_vivafec")));
		datacard.hay_otros=datacard.extendedParseInt(getColumn(sLoadMap.get("hay_otros")));
		datacard.socorro=datacard.extendedParseInt(getColumn(sLoadMap.get("socorro")));
		datacard.salud=datacard.extendedParseInt(getColumn(sLoadMap.get("salud")));
		datacard.educacion=datacard.extendedParseInt(getColumn(sLoadMap.get("educacion")));
		datacard.agropecuario=datacard.extendedParseInt(getColumn(sLoadMap.get("agropecuario")));
		datacard.industrias=datacard.extendedParseInt(getColumn(sLoadMap.get("industrias")));
		datacard.acueducto=datacard.extendedParseInt(getColumn(sLoadMap.get("acueducto")));
		datacard.alcantarillado=datacard.extendedParseInt(getColumn(sLoadMap.get("alcantarillado")));
		datacard.energia=datacard.extendedParseInt(getColumn(sLoadMap.get("energia")));
		datacard.comunicaciones=datacard.extendedParseInt(getColumn(sLoadMap.get("comunicaciones")));
		if (request.getParameter("causa_fixed")!=null) 
			datacard.causa=datacard.not_null(request.getParameter("causa_fixed"));
		else
			datacard.causa=datacard.not_null(getColumn(sLoadMap.get("causa")));
		if (request.getParameter("descausa_fixed")!=null) 
			datacard.descausa=request.getParameter("descausa_fixed");
		else
			datacard.descausa=getColumn(sLoadMap.get("descausa"));
		datacard.transporte=datacard.extendedParseInt(getColumn(sLoadMap.get("transporte")));
		if (request.getParameter("magnitud2_fixed")!=null) 
			datacard.magnitud2=request.getParameter("magnitud2_fixed");
		else
			datacard.magnitud2=getColumn(sLoadMap.get("magnitud2"));
		datacard.nhospitales=datacard.extendedParseInt(getColumn(sLoadMap.get("nhospitales")));
		datacard.nescuelas=datacard.extendedParseInt(getColumn(sLoadMap.get("nescuelas")));
		datacard.nhectareas=datacard.extendedParseDouble(getColumn(sLoadMap.get("nhectareas")));
		datacard.cabezas=datacard.extendedParseInt(getColumn(sLoadMap.get("cabezas")));
		datacard.kmvias=datacard.extendedParseDouble(getColumn(sLoadMap.get("kmvias")));
		if (request.getParameter("duracion_fixed")!=null) 
			datacard.duracion=datacard.extendedParseInt(request.getParameter("duracion_fixed"));
		else
			datacard.duracion=datacard.extendedParseInt(getColumn(sLoadMap.get("duracion")));
		datacard.damnificados=datacard.extendedParseInt(getColumn(sLoadMap.get("damnificados")));
		datacard.evacuados=datacard.extendedParseInt(getColumn(sLoadMap.get("evacuados")));
		datacard.hay_damnificados=datacard.extendedParseInt(getColumn(sLoadMap.get("hay_damnificados")));
		datacard.hay_evacuados=datacard.extendedParseInt(getColumn(sLoadMap.get("hay_evacuados")));
		datacard.hay_reubicados=datacard.extendedParseInt(getColumn(sLoadMap.get("hay_reubicados")));
		datacard.reubicados=datacard.extendedParseInt(getColumn(sLoadMap.get("reubicados")));		
	}



	void startMap()
	{
		sLoadMap.put("serial", nMaxCols);
		sLoadMap.put("level0", nMaxCols);
		sLoadMap.put("level1", nMaxCols);
		sLoadMap.put("level2", nMaxCols);
		sLoadMap.put("name0", nMaxCols);
		sLoadMap.put("name1", nMaxCols);
		sLoadMap.put("name2", nMaxCols);
		sLoadMap.put("evento", nMaxCols);
		sLoadMap.put("lugar", nMaxCols);
		sLoadMap.put("fechano", nMaxCols);
		sLoadMap.put("fechames", nMaxCols);
		sLoadMap.put("fechadia", nMaxCols);
		sLoadMap.put("date", nMaxCols);
		sLoadMap.put("muertos", nMaxCols);
		sLoadMap.put("heridos", nMaxCols);
		sLoadMap.put("desaparece", nMaxCols);
		sLoadMap.put("afectados", nMaxCols);
		sLoadMap.put("vivdest", nMaxCols);
		sLoadMap.put("vivafec", nMaxCols);
		sLoadMap.put("otros", nMaxCols);
		sLoadMap.put("fuentes", nMaxCols);
		sLoadMap.put("valorloc", nMaxCols);
		sLoadMap.put("valorus", nMaxCols);
		sLoadMap.put("fechapor", nMaxCols);
		sLoadMap.put("fechafec", nMaxCols);
		sLoadMap.put("hay_muertos", nMaxCols);
		sLoadMap.put("hay_heridos", nMaxCols);
		sLoadMap.put("hay_deasparece", nMaxCols);
		sLoadMap.put("hay_afectados", nMaxCols);
		sLoadMap.put("hay_vivdest", nMaxCols);
		sLoadMap.put("hay_vivafec", nMaxCols);
		sLoadMap.put("hay_otros", nMaxCols);
		sLoadMap.put("socorro", nMaxCols);
		sLoadMap.put("salud", nMaxCols);
		sLoadMap.put("educacion", nMaxCols);
		sLoadMap.put("agropecuario", nMaxCols);
		sLoadMap.put("industrias", nMaxCols);
		sLoadMap.put("acueducto", nMaxCols);
		sLoadMap.put("alcantarillado", nMaxCols);
		sLoadMap.put("energia", nMaxCols);
		sLoadMap.put("comunicaciones", nMaxCols);
		sLoadMap.put("causa", nMaxCols);
		sLoadMap.put("descausa", nMaxCols);
		sLoadMap.put("transporte", nMaxCols);
		sLoadMap.put("magnitud2", nMaxCols);
		sLoadMap.put("nhospitales", nMaxCols);
		sLoadMap.put("nescuelas", nMaxCols);
		sLoadMap.put("nhectareas", nMaxCols);
		sLoadMap.put("cabezas", nMaxCols);
		sLoadMap.put("kmvias", nMaxCols);
		sLoadMap.put("duracion", nMaxCols);
		sLoadMap.put("damnificados", nMaxCols);
		sLoadMap.put("evacuados", nMaxCols);
		sLoadMap.put("hay_damnificados", nMaxCols);
		sLoadMap.put("hay_evacuados", nMaxCols);
		sLoadMap.put("hay_reubicados", nMaxCols);
		sLoadMap.put("reubicados", nMaxCols);
		sLoadMap.put("glide", nMaxCols);
		sLoadMap.put("di_comments", nMaxCols);
		sLoadMap.put("uu_id", nMaxCols);
		sLoadMap.put("latitude", nMaxCols);
		sLoadMap.put("longitude", nMaxCols);

	}
	// Myanmar
	public  void protoMap()
	{	
		startMap();	
	}


	public  void initProtoMap(Connection con, DICountry countrybean)
	{	

		startMap();	
		extended.loadExtension(con, countrybean);
		// allocates a dictionary object to read each field, puts all extended fields in the load map
		Dictionary dct = new Dictionary();
		for (int j = 0; j < extended.vFields.size(); j++)
		{
			dct = (Dictionary) extended.vFields.get(j);
			sLoadMap.put(dct.nombre_campo, nMaxCols);
		}

	}

	public JdbcLoader()
	{
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		//String sTableToLoad="C:/bases_6/Indonesia1996/Indonesia Disaster Data 2002_2006.xls";

		JdbcLoader elLoader=new JdbcLoader();

		String sTableToLoad="testTable";		

		String sDbDriverName = "com.microsoft.jdbc.sqlserver.SQLServerDriver";
		pooledConnection pc=new pooledConnection(sDbDriverName, "jdbc:microsoft:sqlserver://localhost:1433;DatabaseName=ponja","sa","c98");


		pc.getConnection();
		Connection con=pc.connection;

		DICountry countrybean= new DICountry();
		countrybean.country.scountryid="PO";
		countrybean.countryname="Myanmar";
		countrybean.dbType=Sys.iMsSqlDb;
		countrybean.setLanguage("EN");



		// not needed in the unit test: 
		elLoader.initProtoMap(con, countrybean);
		// unit test: 
		elLoader.protoMap();
		HttpServletRequest request=null;
		elLoader.loadFile (sTableToLoad, con, countrybean, null);
	}

}
