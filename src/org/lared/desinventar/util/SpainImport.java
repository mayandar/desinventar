/**
 * 
 */
package org.lared.desinventar.util;

import java.io.IOException;
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

import geotransform.coords.*;
import geotransform.ellipsoids.*;
import geotransform.transforms.*;

/**
 * @author Julio Serje
 *
 */
public class SpainImport
{
	Connection con=null;
	Connection spain=null;
	public int dbType=Sys.iAccessDb;  //.iMsSqlDb;
	private boolean bDebug=true;
	private boolean buildAll=true;
	

	ResultSet rset=null;
	Statement stmt=null;
	Statement ustmt=null;
	String sError="";
	int nRows=0;
	
	int nSerialExtension=0;

	String[] asSpainTabs={"DATOS GENERALES","VICTIMAS","VIVIENDAS", "SERVICIOS","INDUSTRIAS", "INFRAESTRUCTURAS",
			"AGROPECUARIO","INDEMNIZACIONES S","INDEMNIZACIONES C", 
			"PRECIPITACIÓN",
			"BIBLIOGRAFÍA", "DOCUMENTACIÓN","RIOS"
			};
	String[] asSpainTabs_en={"GENERAL","HUMAN","HOUSING", "UTILITIES","INDUSTRY", "INFRASTRUCTURE",
			"AGRICULTURE","COMPENSATION S","COMPENSATION C", 
			"PRECIPITATION",
			"BIBLIOGRAPHY", "DOCUMENTATION","RIVERS"
			};
	String[] asSpainTables={"DATOS_GENERALES","VICTIMAS","VIVIENDAS", "SERVICIOS_BASICOS","INDUSTRIAS", "INFRAESTRUCTURAS",
			"AGRICULTURA_GANADERIA","INDEMNIZACIONESS","INDEMNIZACIONESC", "PRECIPITACIONES",
			"BIBLIOGRAFIA", "DOCUMENTACION","RIOS_ASOCIADOS"};

	// simple datos generales:
	// "Select * from Datos_generales d,  AUX_EPISODIO x where d.Episodio= x.Episodio",

	String[] asSpainQueries={
			"Select d.Episodio, Ficha, d.Cuenca, Referencia, Fecha_inicio, Fecha_final, Denominacion, Observaciones, Descripcion_meteorologica, Descripcion_hidrologica, Tipo_dato_auxiliar, Codigo_gran_siniestralidad ,Importe_Episodio_Consorcio, Importe_Episodio_Subvenciones, Episodio_Catalogo , Episodio_Cuenca, AuxID, Cod_Prov , Cod_INE, m.Provincia, m.Municipio, UTM_X30, UTM_Y30 from ((Datos_generales d left join  AUX_EPISODIO x on d.Episodio= x.Episodio) left join AUX_EPISODIO_MUNICIPIO m on d.Episodio= m.Episodio) left join T_municipios_provincias mp on m.Municipio= mp.Municipio and m.Provincia= mp.Provincia",
			"Select [Entidad menor] as Entidad_menor, UTM_X as UTM_X_V , UTM_Y as UTM_Y_V, Huso as Huso_V , No_fallecidos, No_heridos, No_evacuados, Observaciones as Observaciones_V from Victimas v left join T_municipios_provincias mp on v.Municipio= mp.Municipio and v.Provincia= mp.Provincia",
			"Select [Entidad menor] as Entidad_menor_H, UTM_X as UTM_X_H, UTM_Y as UTM_Y_H, Huso as Huso_H, No_viviendas, Perdidas_viviendas, Euros, Observaciones as Observaciones_H  from VIVIENDAS v left join T_municipios_provincias mp on v.Municipio= mp.Municipio and v.Provincia= mp.Provincia", 
			"Select Tipo, Perdidas, Euros, Observaciones  from Servicios_basicos v left join T_municipios_provincias mp on v.Municipio= mp.Municipio and v.Provincia= mp.Provincia",
			"Select [Entidad menor] as Entidad_menor_I, UTM_X as UTM_X_I, UTM_Y as UTM_Y_I, Huso as Huso_I, No_industrias,  Perdidas_industrias, Euros as Euros_I, Observaciones as Observaciones_I from industrias v left join T_municipios_provincias mp on v.Municipio= mp.Municipio and v.Provincia= mp.Provincia", 
			"Select Tipo, Opcion, Denominacion, Ubicacion, Tramo_afectado, Nivel_danyos, Cauce, Perdidas, Euros, Observaciones, cauce from INFRAESTRUCTURAS v left join T_municipios_provincias mp on v.Municipio= mp.Municipio and v.Provincia= mp.Provincia",
			"Select tipo as Tipo_agr, Afectacion,  perdidas as perdidas_a, euros as Euros_A, Observaciones as Observaciones_A from   AGRICULTURA_GANADERIA v left join T_municipios_provincias mp on v.Municipio= mp.Municipio and v.Provincia= mp.Provincia",
			"Select Presencia_Fallecidos_Subvenciones, Importe_Perdidas_Viviendas_Subvenciones from IndemnizacionesS v left join T_municipios_provincias mp on v.Municipio= mp.Municipio",
			"Select Presencia_Fallecidos_Consorcio , Perdidas_Viviendas_Consorcio, Perdidas_Sector_Industrial_Consorcio, Perdidas_Sector_servicios_Consorcio, Perdidas_Vehiculos_Consorcio, Perdidas_Infraestructuras_Transporte_Consorcio, Perdidas_Infraestructuras_Hidraulicas_Consorcio, Perdidas_Equipamiento_Municipal_Consorcio, Perdidas_Sin_Clasificar_Consorcio from IndemnizacionesC v left join T_municipios_provincias mp on v.Municipio= mp.Municipio", 
			"PRECIPITACIONES",
			"BIBLIOGRAFIA", 
			"DOCUMENTACION",
			"RIOS_ASOCIADOS"
	};

	PreparedStatement[] pstmts=new PreparedStatement[asSpainQueries.length];

	HashMap<String,String> hmEvents=new HashMap<String,String>();
	HashMap<String,Integer> hmTabs=new HashMap<String,Integer>();

	
	Gdc_Coord_3d gdc[] = new Gdc_Coord_3d[1]; // these need to be the same length.
    Utm_Coord_3d utm[] = new Utm_Coord_3d[1];


    public void importLatitudeLongitude(fichas datacard, String sUTM_X, String sUTM_Y, String sZone)
    {
    	// only if there is no lat lon already calculated
    	if (datacard.latitude==0 && datacard.longitude==0)
    	{
    		byte zone=(byte)webObject.extendedParseInt(sZone);
    		double x=webObject.extendedParseDouble(sUTM_X);
    		double y=webObject.extendedParseDouble(sUTM_Y);
    		utm[0] = new Utm_Coord_3d(x,y,0,zone,true);
    		gdc[0] = new Gdc_Coord_3d();
    		Utm_To_Gdc_Converter.Convert(utm,gdc);
        	datacard.latitude=gdc[0].latitude;
        	datacard.longitude=gdc[0].longitude;    		
    	}
    	
    	
    }
	
	public void setConnection(Connection cn, Connection in, int type)
	{
		con=cn;
		spain=in;
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
			ustmt.executeUpdate("delete from eventos");				
			if (buildAll)
			{
				ustmt.executeUpdate("delete from regiones");
				ustmt.executeUpdate("delete from lev2");
				ustmt.executeUpdate("delete from lev1");
				ustmt.executeUpdate("delete from lev0");
			}
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

	public void importEvents()
	{
		// -----------------------------------------------------------------------------
		// create table of events
		eventos ev=new eventos();
		ev.dbType=dbType;
		try{
			// note this goes against DANA!
			ev.nombre="INUNDACIÓN";
			ev.nombre_en="FLOOD";
			ev.descripcion="FLOODS (URBAN & RURAL)";
			ev.serial=1;
			nRows=ev.addWebObject(con);
			hmEvents.put(ev.descripcion, ev.nombre);

			ev.nombre="AVENIDA";
			ev.nombre_en="FLASH FLOOD";
			ev.descripcion="FLASH FLOODS (URBAN & RURAL)";
			ev.serial=1;
			nRows=ev.addWebObject(con);
			hmEvents.put(ev.descripcion, ev.nombre);

			ev.nombre="LLUVIA";
			ev.nombre_en="HEAVY RAIN";
			ev.descripcion="HEAVY RAIN";
			ev.serial=1;
			nRows=ev.addWebObject(con);
			hmEvents.put(ev.descripcion, ev.nombre);

			ev.nombre="TORMENTA";
			ev.nombre_en="STORM";
			ev.descripcion="STORM";
			ev.serial=1;
			nRows=ev.addWebObject(con);
			hmEvents.put(ev.descripcion, ev.nombre);

		}
		catch (Exception e)
		{
			sError="Importing EVENTS"+e.toString();
			System.out.println(sError);
		}

	}

	public void importGroups()
	{
		// -----------------------------------------------------------------------------
		// create table of events
		extensiontabs ev=new extensiontabs();
		ev.dbType=dbType;

		try{
			for (int j=0; j<this.asSpainTabs.length; j++)
			{
				ev.svalue=asSpainTabs[j];
				ev.svalue_en=asSpainTabs_en[j];
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
		// level 1
		try{
			lev0 l0=new lev0();
			l0.dbType=dbType;
			rset=stmt.executeQuery("Select distinct Cod_CCAA, Comunidad_Autonoma from T_provincias_comunidades Order By Cod_CCAA");
			while (rset.next())
			{
				l0.lev0_cod=rset.getString("Cod_CCAA");
				l0.lev0_name=rset.getString("Comunidad_Autonoma");
				l0.lev0_name_en=l0.lev0_name;
				nRows=l0.addWebObject(con);
			}

			rset=stmt.executeQuery("Select Cod_Prov , Provincia, Cod_CCAA from T_provincias_comunidades Order By Cod_CCAA, Cod_Prov");
			lev1 l1=new lev1();
			l1.dbType=dbType;
			while (rset.next())
			{
				l1.lev1_cod=rset.getString("Cod_Prov");
				l1.lev1_lev0=rset.getString("Cod_CCAA");
				l1.lev1_name=rset.getString("Provincia");
				l1.lev1_name_en=l1.lev1_name;
				nRows=l1.addWebObject(con);
			}

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


	public void importGeography()
	{
		// -----------------------------------------------------------------------------
		// level 1
		try{
			lev0 l0=new lev0();
			l0.dbType=dbType;
			rset=stmt.executeQuery("Select Cod_Prov , Provincia from  T_provincias_comunidades Order By Cod_CCAA, Cod_Prov");
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
			lev1 l1=new lev1();
			l1.dbType=dbType;
			while (rset.next())
			{
				l1.lev1_cod=rset.getString("Cod_INE");
				l1.lev1_lev0=rset.getString("Cod_Prov");
				l1.lev1_name=rset.getString("Municipio");
				l1.lev1_name_en=l1.lev1_name;
				nRows=l1.addWebObject(con);
			}

		}
		catch (Exception e)
		{
			sError="Importing LEVELS :"+e.toString();
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


	/**
	 * @param datacard
	 * @param nQuery
	 * @throws SQLException
	 */
	private void setQueryParameters(fichas datacard, int nQuery)
			throws SQLException 
	{
		pstmts[nQuery].setString(1, datacard.descausa.substring(0,datacard.descausa.indexOf(" / ")));		
		if (datacard.level1.length()>0)
			pstmts[nQuery].setString(2, datacard.level1);
		else
			pstmts[nQuery].setNull(2, Types.VARCHAR);
		
		if (datacard.level0.equals("99"))
			pstmts[nQuery].setNull(3, Types.VARCHAR);
		else
		    pstmts[nQuery].setString(3, datacard.level0);
	}


	public void importStraight(fichas datacard, extension e,int nQuery)
	{
		try{
			// municipality and province to query
			setQueryParameters(datacard, nQuery);

			ResultSet r=pstmts[nQuery].executeQuery();

			if (r.next())
				importExtension(e, r, "");

		}
		catch (Exception ex)
		{
			// log here the error type
			System.out.println("[DI9] WARNING: IMPORTING STRAIGHT QUERY "+nQuery+" msg= "+ ex.toString());
		}
	}

	
	public void importStraightType(fichas datacard, extension e,int nQuery)
	{
		try{
			// municipality and province to query
			setQueryParameters(datacard, nQuery);

			ResultSet r=pstmts[nQuery].executeQuery();

			if (r.next())
				importExtension(e, r, " " + r.getString("tipo"));

		}
		catch (Exception ex)
		{
			// log here the error type
			System.out.println("[DI9] WARNING: IMPORTING STRAIGHT TYPED QUERY "+nQuery+" msg= "+ ex.toString());
		}
	}


	
	
	
	public void importHuman(fichas datacard, extension e)
	{
		try{
			setQueryParameters(datacard, 1);

			ResultSet r=pstmts[1].executeQuery();

			String sObserva="";
			String sUtmX="";
			String sUtmY="";
			String sHuso="";

			while (r.next())
			{
				int kill=r.getInt("no_fallecidos");
				int injr=r.getInt("no_heridos");
				int evac=r.getInt("no_evacuados");

				if (kill>0)
					datacard.muertos+=kill;
				if (injr>0)
					datacard.heridos+=injr;
				if (evac>0)
					datacard.evacuados+=evac;

				if (kill!=0)
					datacard.hay_muertos=-1;
				if (injr!=0)
					datacard.hay_heridos=-1;
				if (evac!=0)
					datacard.hay_evacuados=-1;

				//[Entidad menor] as Entidad_menor, UTM_X as UTM_X_V , UTM_Y as UTM_Y_V, Huso as Huso_V , No_fallecidos, No_heridos, No_evacuados, Observaciones as Observaciones_V
				String sLoc=webObject.not_null(r.getString("Entidad_menor"));
				if (sLoc.length()>0)
				{
					if (datacard.lugar.length()>0)
						datacard.lugar+=" / ";
					datacard.lugar+=sLoc;					
				}
				sLoc=webObject.not_null(r.getString("UTM_X_V"));
				if (sLoc.length()>0)
				{
					sUtmX=sLoc;
					sUtmY=webObject.not_null(r.getString("UTM_Y_V"));
					sHuso=webObject.not_null(r.getString("Huso_V"));
					
					importLatitudeLongitude(datacard, sUtmX, sUtmY, sHuso);
				}
				sLoc=webObject.not_null(r.getString("Observaciones_V"));
				if (sLoc.length()>0)
				{
					if (datacard.di_comments.length()>0)
						datacard.di_comments+=" / ";
					datacard.di_comments+=sLoc;
					if (sObserva.length()>0)
						sObserva+=" / ";
					sObserva+=sLoc;				
				}
			}
			// set extension fields
			e.asFieldNames.put("No_fallecidos".toUpperCase(), String.valueOf(datacard.muertos));	
			e.asFieldNames.put("No_heridos".toUpperCase(), String.valueOf(datacard.heridos));	
			e.asFieldNames.put("No_evacuados".toUpperCase(), String.valueOf(datacard.evacuados));	
			e.asFieldNames.put("Entidad_menor".toUpperCase(),datacard.lugar);
			e.asFieldNames.put("UTM_X_V",sUtmX);
			e.asFieldNames.put("UTM_Y_V",sUtmY);
			e.asFieldNames.put("HUSO_V",sHuso);
			e.asFieldNames.put("Observaciones_V".toUpperCase(),sObserva);

		}
		catch (Exception ex)
		{
			// log here the error type
			System.out.println("[DI9] WARNING: IMPORTING VICTIMAS msg= "+ ex.toString());
		}
	}

	
	
	public void importIndustries(fichas datacard, extension e)
	{
		try{
			setQueryParameters(datacard, 4);

			ResultSet r=pstmts[4].executeQuery();

			String sObserva="";
			String sUtmX="";
			String sUtmY="";
			String sHuso="";
			
			int nIndustries=0;
			double dIndustrialLosses=0;
			double dIndustrialEuros=0;
			String sEntidad="";

			while (r.next())
			{
				int industrias=r.getInt("no_industrias");
				double  perdidas_industrias=r.getInt("perdidas_industrias");
				double euros=r.getDouble("euros_i");
				
				if (industrias>0)
					nIndustries+=industrias;
				if (perdidas_industrias>0)
					dIndustrialLosses+=perdidas_industrias;
				if (euros>0)
					dIndustrialEuros+=euros;

				if (industrias!=0)
					datacard.industrias=-1;

				//[Entidad menor] as Entidad_menor, UTM_X as UTM_X_V , UTM_Y as UTM_Y_V, Huso as Huso_V , No_fallecidos, No_heridos, No_evacuados, Observaciones as Observaciones_V
				String sLoc=webObject.not_null(r.getString("Entidad_menor_i"));
				if (sLoc.length()>0)
				{
					if (datacard.lugar.indexOf(sLoc)<0)
					{
						if (datacard.lugar.length()>0)
							datacard.lugar+=" / ";
						datacard.lugar+=sLoc;											
					}
					if (sEntidad.length()>0)
						sEntidad+=" / ";
					sEntidad+=sLoc;					
				}
				sLoc=webObject.not_null(r.getString("UTM_X_I"));
				if (sLoc.length()>0)
				{
					sUtmX=sLoc;
					sUtmY=webObject.not_null(r.getString("UTM_Y_I"));
					sHuso=webObject.not_null(r.getString("Huso_I"));
					importLatitudeLongitude(datacard, sUtmX, sUtmY, sHuso);
				}
				sLoc=webObject.not_null(r.getString("Observaciones_I"));
				if (sLoc.length()>0&& !(" / sin datos".equalsIgnoreCase(sLoc)))
				{
					if (datacard.di_comments.length()>0)
						datacard.di_comments+=" / ";
					datacard.di_comments+=sLoc;
					if (sObserva.length()>0)
						sObserva+=" / ";
					sObserva+=sLoc;				
				}
			}
			// set extension fields
			e.asFieldNames.put("no_industrias".toUpperCase(), String.valueOf(nIndustries));	
			e.asFieldNames.put("perdidas_industrias".toUpperCase(), String.valueOf(dIndustrialLosses));	
			e.asFieldNames.put("euros_i".toUpperCase(), String.valueOf(dIndustrialEuros));	
			e.asFieldNames.put("Entidad_menor_i".toUpperCase(),sEntidad);
			e.asFieldNames.put("UTM_X_I",sUtmX);
			e.asFieldNames.put("UTM_Y_I",sUtmY);
			e.asFieldNames.put("Huso_I",sHuso);
			e.asFieldNames.put("Observaciones_I".toUpperCase(),sObserva);

		}
		catch (Exception ex)
		{
			// log here the error type
			System.out.println("[DI9] WARNING: IMPORTING INDUSTRIES msg= "+ ex.toString());
		}
	}


	
	public void importInfrastructure(fichas datacard, extension e)
	{
		try{
			setQueryParameters(datacard, 5);
			ResultSet r=pstmts[5].executeQuery();

			String sDescripcion="";
			String sObserva="";
			int opcion=0;
			String tipo="";
			String sFieldName;

			while (r.next())
			{
				double  perdidas=r.getDouble("perdidas");
				double euros=r.getDouble("euros");
				double dLosses=0;
				double dEuros=0;
				
				if (perdidas>0)
					dLosses=perdidas;
				if (euros>0)
					dEuros=euros;

				opcion=r.getInt("opcion");
				if (opcion!=0)
					datacard.transporte=-1;
				
				tipo=r.getString("tipo").trim();

				if (tipo.startsWith("ACEQUIAS") || tipo.startsWith("RED DE RIEGO"))
					datacard.agropecuario=-1;
				
				if (tipo.indexOf("RED FERROVIARIA")>=0 || tipo.indexOf("RED VIARIA")>=0)
					datacard.transporte=-1;
				
				sDescripcion=webObject.not_null(r.getString("Denominacion"));
				String sLoc=webObject.not_null(r.getString("Ubicacion"));

				if (sDescripcion.length()>0)
					sDescripcion+=", "+sLoc;
				else
					sDescripcion=sLoc;
					
				sLoc=webObject.not_null(r.getString("tramo_afectado"));				
				if (sDescripcion.length()>0)
					sDescripcion+=", TRAMO:"+sLoc;
				else
					sDescripcion="TRAMO:"+sLoc;

				sLoc=webObject.not_null(r.getString("nivel_danyos"));				
				if (sDescripcion.length()>0)
					sDescripcion+=", DAÑO:"+sLoc;
				else
					sDescripcion="DAÑO:"+sLoc;

				sLoc=webObject.not_null(r.getString("cauce"));				
				if (sDescripcion.length()>0)
					sDescripcion+=", CAUCE: "+sLoc;
				else
					sDescripcion="CAUCE: "+sLoc;

				sFieldName=getLegalExtensionFieldName("Descripcion "+tipo);
				sObserva=webObject.not_null((String)e.asFieldNames.get(sFieldName));
				if (sObserva.length()>0)
					sObserva+=" | "+sDescripcion;
				else
					sObserva=sDescripcion;				
				e.asFieldNames.put(sFieldName,sObserva);

				sLoc=webObject.not_null(r.getString("Observaciones"));
				if (sLoc.length()>0&& !(" / sin datos".equalsIgnoreCase(sLoc)))
				{
					if (datacard.di_comments.length()>0)
						datacard.di_comments+=" / ";
					datacard.di_comments+=sLoc;

					sFieldName=getLegalExtensionFieldName("Observaciones "+tipo);
					sObserva=webObject.not_null((String)e.asFieldNames.get(sFieldName));
					if (sObserva.length()>0)
						sObserva+=" | "+sLoc;
					else
						sObserva=sLoc;				
					e.asFieldNames.put(sFieldName,sObserva);
				}

				sFieldName=getLegalExtensionFieldName("perdidas "+tipo);
				dLosses+=webObject.extendedParseDouble((String)e.asFieldNames.get(sFieldName));
				e.asFieldNames.put(sFieldName, String.valueOf(dLosses));	

				sFieldName=getLegalExtensionFieldName("euros "+tipo);
				dEuros+=webObject.extendedParseDouble((String)e.asFieldNames.get(sFieldName));
				e.asFieldNames.put(sFieldName, String.valueOf(dEuros));	

			
			}
			
			// set extension fields

		}
		catch (Exception ex)
		{
			// log here the error type
			System.out.println("[DI9] WARNING: IMPORTING INFRASTRUCTURE msg= "+ ex.toString());
		}
	}


	
	public void importAgriculture(fichas datacard, extension e)
	{
		try{
			setQueryParameters(datacard, 6);
			ResultSet r=pstmts[6].executeQuery();

			String sDescripcion="";
			String sObserva="";
			int opcion=0;
			String tipo="";
			String sFieldName;

			while (r.next())
			{
				double  perdidas=r.getDouble("perdidas_a");
				double euros=r.getDouble("euros_a");
				double afectacion=r.getDouble("Afectacion");

				double dLosses=0;
				double dEuros=0;
				double dAfectacion=0;
				
				if (perdidas>0)
					dLosses=perdidas;
				if (euros>0)
					dEuros=euros;
				if (afectacion>0)
					dAfectacion=afectacion;

				tipo=r.getString("tipo_agr").trim();

				if (tipo.indexOf("OVINO")>=0 || tipo.indexOf("BOVINO")>=0 || tipo.indexOf("EQUINO")>=0 || tipo.indexOf("CAPRINO")>=0 || tipo.indexOf("PORCINO")>=0)
					datacard.cabezas+=dAfectacion;
				else
					datacard.nhectareas+=dAfectacion;
					
				
				datacard.agropecuario=-1;
				

				

				sFieldName=getLegalExtensionFieldName("TIPO_agr");
				sDescripcion=webObject.not_null((String)e.asFieldNames.get(sFieldName));
				if (sDescripcion.length()>0)
					sDescripcion+=", "+tipo;
				else
					sDescripcion=tipo;
				e.asFieldNames.put(sFieldName,sDescripcion);


				sFieldName=getLegalExtensionFieldName("Observaciones_A");
				sObserva=webObject.not_null((String)e.asFieldNames.get(sFieldName));
				if (sObserva.length()>0)
					sObserva+=" | "+sDescripcion;
				else
					sObserva=sDescripcion;				
				e.asFieldNames.put(sFieldName,sObserva);

                //Select tipo as Tipo_agr, Afectacion,  perdidas as perdidas_a, euros as euros_a, Observaciones as Observaciones_A from   AGRICULTURA_GANADERIA v left join T_municipios_provincias mp on v.Municipio= mp.Municipio and v.Provincia= mp.Provincia",
				sFieldName=getLegalExtensionFieldName("afectacion");
				dAfectacion+=webObject.extendedParseDouble((String)e.asFieldNames.get(sFieldName));
				e.asFieldNames.put(sFieldName, String.valueOf(dAfectacion));	

				sFieldName=getLegalExtensionFieldName("perdidas_a");
				dLosses+=webObject.extendedParseDouble((String)e.asFieldNames.get(sFieldName));
				e.asFieldNames.put(sFieldName, String.valueOf(dLosses));	

				sFieldName=getLegalExtensionFieldName("euros_a");
				dEuros+=webObject.extendedParseDouble((String)e.asFieldNames.get(sFieldName));
				e.asFieldNames.put(sFieldName, String.valueOf(dEuros));				
			}
			
			// set extension fields

		}
		catch (Exception ex)
		{
			// log here the error type
			System.out.println("[DI9] WARNING: IMPORTING AGRICULTURE msg= "+ ex.toString());
		}
	}


	
	
	public void importHousing(fichas datacard, extension e)
	{
		try{
			setQueryParameters(datacard, 2);

			ResultSet r=pstmts[2].executeQuery();

			String sObserva="";
			String sUtmX="";
			String sUtmY="";
			String sHuso="";
			double tot_losses=0;
			String sEntidad="";
			double nEuros=0;
			
			while (r.next())
			{
				int vivafec=r.getInt("no_viviendas");
				int perdidas=r.getInt("perdidas_viviendas");
				nEuros=webObject.extendedParseDouble(r.getString("Euros"));   /// this field not very well defined. taking the last instance

				if (vivafec>0)
					datacard.vivafec+=vivafec;
				if (perdidas>0)
					tot_losses+=perdidas;

				if (vivafec<0 || perdidas>0  || nEuros>0)
					datacard.hay_vivafec=-1;

				//[Entidad menor] as Entidad_menor, UTM_X as UTM_X_V , UTM_Y as UTM_Y_V, Huso as Huso_V , No_fallecidos, No_heridos, No_evacuados, Observaciones as Observaciones_V
				String sLoc=webObject.not_null(r.getString("Entidad_menor_H"));
				if (sLoc.length()>0)
				{
					if (datacard.lugar.indexOf(sLoc)<0)
					{
						if (datacard.lugar.length()>0)
							datacard.lugar+=" / ";
						datacard.lugar+=sLoc;											
					}
					if (sEntidad.length()>0)
						sEntidad+=" / ";
						
					sEntidad+=sLoc;					
				}
				sLoc=webObject.not_null(r.getString("UTM_X_H"));
				if (sLoc.length()>0)
				{
					sUtmX=sLoc;
					sUtmY=webObject.not_null(r.getString("UTM_Y_H"));
					sHuso=webObject.not_null(r.getString("Huso_H"));
					importLatitudeLongitude(datacard, sUtmX, sUtmY, sHuso);
				}
				sLoc=webObject.not_null(r.getString("Observaciones_H"));
				if (sLoc.length()>0)
				{
					if (datacard.di_comments.length()>0)
						datacard.di_comments+=" / ";
					datacard.di_comments+=sLoc;
					if (sObserva.length()>0)
						sObserva+=" / ";
					sObserva+=sLoc;				
				}
			}
			// set extension fields
			e.asFieldNames.put("no_viviendas".toUpperCase(), String.valueOf(datacard.vivafec));	
			e.asFieldNames.put("perdidas_viviendas".toUpperCase(), String.valueOf(tot_losses));	
			e.asFieldNames.put("Entidad_menor_H".toUpperCase(),sEntidad);
			e.asFieldNames.put("Euros".toUpperCase(), String.valueOf(nEuros));	
			e.asFieldNames.put("UTM_X_H",sUtmX);
			e.asFieldNames.put("UTM_Y_H",sUtmY);
			e.asFieldNames.put("Huso_H",sHuso);
			e.asFieldNames.put("Observaciones_H".toUpperCase(),sObserva);

		}
		catch (Exception ex)
		{
			// log here the error type
			System.out.println("[DI9] WARNING: IMPORTING HOUSING msg= "+ ex.toString());
		}
	}


	
	
	public void importDisasters()
	{
		// -----------------------------------------------------------------------------
		// create the fichas/extension tables
		int nRecs=0;
		try{

			stmt=spain.createStatement ();
			// first.. complement missing entries in  AUX_EPISODIO_MUNICIPIO

			stmt.executeUpdate("insert into AUX_EPISODIO_MUNICIPIO (Episodio, Municipio, provincia) Select distinct a.Episodio, a.Municipio, t.provincia    from (IndemnizacionesC a left join AUX_EPISODIO_MUNICIPIO x on a.Episodio= x.Episodio  and a.Municipio= x.Municipio) left join T_municipios_provincias t  on  a.municipio=t.municipio where x.Municipio is null");
			stmt.executeUpdate("insert into AUX_EPISODIO_MUNICIPIO (Episodio, Municipio, provincia) Select distinct a.Episodio, a.Municipio, t.provincia    from (IndemnizacionesS a left join AUX_EPISODIO_MUNICIPIO x on a.Episodio= x.Episodio  and a.Municipio= x.Municipio) left join T_municipios_provincias t  on  a.municipio=t.municipio where x.Municipio is null");
			
			
			
			



			rset=stmt.executeQuery( asSpainQueries[0]);
			//  FIELDS of main query:
			//  Episodio Ficha Cuenca Referencia Fecha_inicio Fecha_final Denominacion Observaciones 
			//  Descripcion_meteorologica Descripcion_hidrologica Tipo_dato_auxiliar Codigo_gran_siniestralidad 
			// Importe_Episodio_Consorcio Importe_Episodio_Subvenciones
			// Episodio Cuenca Episodio_Catalogo Episodio_Cuenca
			// Provincia Municipio AuxID

			pstmts[1]=spain.prepareStatement(asSpainQueries[1]+" where episodio=? and cod_INE=? and cod_prov=?");
			pstmts[2]=spain.prepareStatement(asSpainQueries[2]+" where episodio=? and cod_INE=? and cod_prov=?");
			pstmts[3]=spain.prepareStatement(asSpainQueries[3]+" where episodio=? and cod_INE=? and cod_prov=?");
			pstmts[4]=spain.prepareStatement(asSpainQueries[4]+" where episodio=? and cod_INE=? and cod_prov=?");
			pstmts[5]=spain.prepareStatement(asSpainQueries[5]+" where episodio=? and cod_INE=? and cod_prov=?");

			pstmts[6]=spain.prepareStatement(asSpainQueries[6]+" where episodio=? and cod_INE=? and cod_prov=?");

			
			pstmts[7]=spain.prepareStatement(asSpainQueries[7]+" where episodio=? and cod_INE=? and cod_prov=?");
			pstmts[8]=spain.prepareStatement(asSpainQueries[8]+" where episodio=? and cod_INE=? and cod_prov=?");

			fichas datacard=new fichas(); 
			extension e=new extension();
			datacard.dbType=dbType;
			e.dbType=dbType;
			e.loadExtension(con, new DICountry());
			int nSerial=0;
			while (rset.next())
			{
				e.init();
				datacard.init();
				nSerial++;
				datacard.serial=webObject.not_null(rset.getString("Episodio_Catalogo"));
				if (datacard.serial.length()==0)
					datacard.serial=String.valueOf(nSerial);
				
				// TODO: refine causes

				String sdate=rset.getString("Fecha_inicio");
				datacard.fechano=Integer.parseInt(sdate.substring(0,4));
				datacard.fechames=Integer.parseInt(sdate.substring(4,6));
				datacard.fechadia=Integer.parseInt(sdate.substring(6));
				String stodate=rset.getString("Fecha_final");

				if (!stodate.equals(sdate))
				{
					try{
						sdate=sdate.substring(0,4)+"-"+sdate.substring(4,6)+"-"+sdate.substring(6);
						stodate=stodate.substring(0,4)+"-"+stodate.substring(4,6)+"-"+stodate.substring(6);
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

				String sEventType=datacard.not_null(rset.getString("Denominacion"));
				datacard.evento="INUNDACIÓN";
				
				if (sEventType.toUpperCase().indexOf("AVENIDA")>=0)
					datacard.evento="AVENIDA";
				if (sEventType.toUpperCase().indexOf("LLUVIA")>=0)
					datacard.evento="LLUVIA";
				if (sEventType.toUpperCase().indexOf("TORMENTA")>=0)
					datacard.evento="TORMENTA";
				
				datacard.glide=datacard.not_null(rset.getString("Episodio")).trim();
				datacard.descausa=datacard.glide+" / "+sEventType;

				datacard.level0=datacard.not_null(rset.getString("Cod_Prov"));
				datacard.name0=datacard.not_null(rset.getString("Provincia"));
				datacard.level1=datacard.not_null(rset.getString("Cod_INE"));
				datacard.name1=datacard.not_null(rset.getString("Municipio"));
				if (datacard.level0.length()==0 && datacard.level0.length()>1)
				{
					datacard.level0=datacard.level1.substring(0,2);					
				}
				if (datacard.level0.length()==0)
				{
					datacard.level0="99";
					datacard.name0="Provincia no definida";
				}

				datacard.di_comments=datacard.not_null(rset.getString("Observaciones"));
				sdate=datacard.not_null(rset.getString("Descripcion_meteorologica"));
				if (sdate.length()>0)
					datacard.di_comments+=" / "+sdate;
				sdate=datacard.not_null(rset.getString("Descripcion_hidrologica"));
				if (sdate.length()>0)
					datacard.di_comments+=" / "+sdate;
				datacard.fuentes="CNIH "+datacard.not_null(rset.getString("Referencia"));;
				//datacard.lugar=rset.getString("");
				datacard.approved=0;
				importExtension(e, rset, "");

				importHuman(datacard, e);
				importHousing(datacard, e);
				importIndustries(datacard, e);

				if (!datacard.level0.equals("99"))
				  importAgriculture(datacard, e);
				
				importStraightType(datacard, e,3);

				
				importStraight(datacard, e,7);
				importStraight(datacard, e,8);

				importInfrastructure(datacard, e);

				
				datacard.addWebObject(con);
				e.updateMembersFromHashTable();
				e.clave_ext=datacard.clave;
				e.addWebObject(con);

				nRecs++;

				if (datacard.level0.equals("99"))
					System.out.println("[DI9] WARNING: IMPORTED with no georeference ["+datacard.serial+"] "+datacard.descausa);

			}    		
		}
		catch (Exception e)
		{
			sError="[DI9] Spain / Importing FICHAS:  "+e.toString();
			System.out.println(sError);
		}
		System.out.println("[DI9] Spain - Imported FICHAS:  "+nRecs);

	}

	
	// TODO  MOVE THIS TO EXTENSION CLASS!!!
	public static String getLegalExtensionFieldName(String sFieldName)
	{
		String sRet=sFieldName.toUpperCase();
		int pos=sFieldName.lastIndexOf('.');
		if (pos>=0)
			sRet=sRet.substring(pos+1);
		String sNotAcceptable=" -=+/\\!*.#$%^&(){}[]'\"?<>,:;~`";   /// this may be longer if 
		for (int j=0; j<sNotAcceptable.length(); j++)
			if (sRet.indexOf(sNotAcceptable.charAt(j))>=0)
				sRet=sRet.replace(sNotAcceptable.charAt(j), '_');
		
		if (sRet.length()>30)
			sRet=sRet.substring(0,30);
		return sRet;
	}
	
	public void importExtension(extension e, ResultSet rset, String sSuffix)
	{
		// ----1-------------------------------------------------------------------------
		// create the extension tables
		try{
			ResultSetMetaData meta = rset.getMetaData();
			String sFieldName=null;
			// these are required not to disturb the globally declared ones used by the calling method. close them at the end
			for  (int j=1; j<=meta.getColumnCount(); j++)
			{
				try
				{
					sFieldName=getLegalExtensionFieldName(meta.getColumnName(j)+sSuffix);
					e.asFieldNames.put(sFieldName, rset.getString(j));
				}
				catch (Exception ex)
				{
					// log here the error type
					System.out.println("[DI9] WARNING: IMPORTING EXTENSION ["+j+"-"+sFieldName+" msg: "+ ex.toString());
				}
			}

		}
		catch (Exception ex)
		{
			sError="Importing EXTENSION"+ex.toString();
			System.out.println(sError);
		}    	
	}




	private String importExtensionDefinition(Connection con, Connection exCon, DICountry countrybean, String sName, int tabnumber, String sSuffix)
	{
		try{
			extension woExtension=new extension();
			woExtension.loadExtension(con, countrybean);
			Statement stmt=con.createStatement ();
			Statement estmt=exCon.createStatement ();
			ResultSet erset=estmt.executeQuery(sName);
			/// gets the metadata of the resultset
			ResultSetMetaData meta = erset.getMetaData();
			int nCurrentFieldType=0;
			int nCurrentFieldSize=30;
			PreparedStatement pstmt = con.prepareStatement("insert into diccionario(orden,nombre_campo,descripcion_campo,label_campo,pos_x,pos_y,lon_x,lon_y,color,label_campo_en,tabnumber,fieldtype) values (?,?,?,?,?,?,?,?,?,?,?,?)");
			String sFieldName="";
			String sColumnName="";
			int nField=0;
			for  (int j=1; j<=meta.getColumnCount(); j++)
			{
				try
				{
					sColumnName=meta.getColumnName(j)+ sSuffix;
					sFieldName=getLegalExtensionFieldName(sColumnName);
					if (!woExtension.vMeta.containsKey(sFieldName.toUpperCase()))
					{
						nCurrentFieldType=0;
						nCurrentFieldSize=30;			
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
						String sSql="alter table extension add "+sFieldName.toUpperCase()+" "+DbImplementation.typeNames[countrybean.country.ndbtype][nCurrentFieldType];
						if (nCurrentFieldType==0)
							sSql+="("+nCurrentFieldSize+")";
						try
						{
							stmt.executeUpdate(sSql);
							woExtension.vMeta.put(sFieldName, new Integer(j));
							// if it reached here, the field has just been added to the table OK
							pstmt.setInt(1, nSerialExtension++);   // this will require a bunch of datasets to have unique serials, respecting the overall order of creation...
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
							pstmt.setInt(11, tabnumber);
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
					System.out.println("<br>EXTENSION DEFINITION  ["+nField+"-"+sFieldName+"("+DbImplementation.typeNames[countrybean.country.ndbtype][nCurrentFieldType]+")] <!--"+ e.toString()+"-->");
				}			
			}
			erset.close();
			estmt.close();

		}
		catch (Exception e)
		{
			// log here the error type
			System.out.println("[DI9] ERROR: EXTENSION DEFINITION ON TABLE "+sName+" -> "+ e.toString());
		}

		// everything ready, now get the extension codes
		return sName;
	}



	public void doImport()
	{

        // UTM converter
		Utm_To_Gdc_Converter.Init(new IN_Ellipsoid());
        gdc[0] = new Gdc_Coord_3d();
	    utm[0] = new Utm_Coord_3d(500111.206,4427964.598,0,(byte)30,true);

		
		
		// GAR 2013 settings in country bean...
		DICountry countrybean=new DICountry();
		countrybean.country.scountryid="sp";
		countrybean.countrycode=countrybean.country.scountryid;
		countrybean.countryname="Spain";
		countrybean.dbType=countrybean.country.ndbtype=Sys.iAccessDb;

		try{
			stmt=spain.createStatement();
		}
		catch (Exception e ){}


		if (buildAll)
		{
			importGeography();
		}

		importEvents();
		importGroups();			

		// creation of extension fields for:  datos_generales, in first tab of extension
		importExtensionDefinition(con, spain, countrybean, asSpainQueries[0], 1, "");	 
		importExtensionDefinition(con, spain, countrybean, asSpainQueries[1], 2, "");
		importExtensionDefinition(con, spain, countrybean, asSpainQueries[2], 3, "");
		try
		{
			stmt=spain.createStatement();
			rset=stmt.executeQuery("Select tipo from T_servicios Order By Tipo");
			while (rset.next())
			{
				// this should be asSpainQueries[3], but that query includes Tipo, which we are denormalizing here, no need to add
				importExtensionDefinition(con, spain, countrybean, "Select Perdidas, Euros, Observaciones from Servicios_basicos ", 4," "+rset.getString(1));				
			}
		}
		catch (Exception e ){
			System.out.println("[DI9] ERROR: EXTENSION DEFINITION ON TABLE SERVICIOS -> "+ e.toString());
		}

		importExtensionDefinition(con, spain, countrybean, asSpainQueries[4], 5, "");


		try
		{
			rset=stmt.executeQuery("Select tipo from T_infraestructuras Order By opcion, tipo");
			while (rset.next())
			{
				// this query will ignore tipo, and will create the memo field descripcion which will summarize denominacion, ubicacion, nivel de dañom tramo_afectado. There may as as many as 378 rows summarized!
				importExtensionDefinition(con, spain, countrybean, "Select Perdidas, Euros, Observaciones as Descripcion, Observaciones  from Infraestructuras ", 6," "+rset.getString(1));				
			}	
		}
		catch (Exception e ){
			System.out.println("[DI9] ERROR: EXTENSION DEFINITION ON TABLE INFRAESTRUCTURA -> "+ e.toString());
		}


		importExtensionDefinition(con, spain, countrybean, asSpainQueries[6], 7, "");

		importExtensionDefinition(con, spain, countrybean, asSpainQueries[7], 8, "");	 
		importExtensionDefinition(con, spain, countrybean, asSpainQueries[8], 9, "");	 

		importDisasters();


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
		pooledConnection pc=new pooledConnection(sDbDriverName, "jdbc:sqlserver://localhost:1433;DatabaseName=spain","sa","c98");				
		/*/
		String sDbDriverName = Sys.sAccess64Driver;
		pooledConnection pc=new pooledConnection(sDbDriverName, Sys.sAccess64DefaultString+"c:\\databases\\Spain\\inventesp.mdb;", null, null);				
		//*/
		pc.getConnection();
		Connection con=pc.connection;

		/*
		sDbDriverName = "sun.jdbc.odbc.JdbcOdbcDriver"; // "com.inzoom.jdbcado.Driver";
		pooledConnection pcin=new pooledConnection(sDbDriverName, "jdbc:izmado:Provider=Microsoft.Jet.OleDB.4.0;data source=c:\\databases\\Spain\\CNIH6.mdb;Pwd=DGPC101CNIH;", null, null);				
		/*/
		pooledConnection pcin=new pooledConnection(sDbDriverName, Sys.sAccess64DefaultString+"c:\\databases\\Spain\\spain.mdb;", null, null);				
		//*/


		pcin.getConnection();
		Connection dana=pcin.connection;

		SpainImport sin=new SpainImport();
		sin.setConnection(con, dana, Sys.iAccessDb); // Sys.iMsSqlDb);

		sin.doImport();

		try{ 
			con.close();
			dana.close();
		}
		catch(Exception e)
		{
		}

	}

}
