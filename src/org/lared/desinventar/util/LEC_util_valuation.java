package org.lared.desinventar.util;

import java.text.SimpleDateFormat;

import org.lared.desinventar.util.*;
import org.lared.desinventar.system.*;
import org.lared.desinventar.webobject.*;
import org.lared.desinventar.webobject.Dictionary;

import java.util.*;
import java.util.Date;
import java.io.*;
import java.sql.*;


public class LEC_util_valuation 
{
	// variables for economic valuation:
	public fichas woFichas=null; 						// with unit values
	public extension woExtension=null; 				// with unit values
	public String target_variable="valorus"; 	    // where the calculated value will go
	public int nValorUSOption=0;				    // 0-> dont use, 1->add always, 2-> add if >=
	public int nValorLocalOption=0;					// 0-> dont use, 1->add always, 2-> add if >=
	int[] nYears=null;
	double[] dInflation=null;
	double[] dExchange_rate=null;
	DICountry countrybean=null;

	public void save_inflation_parameters(Connection con, int[] years, double[] inflation, double[] exchange_rate)
	{

	    nYears=years;
		dInflation=inflation;
		dExchange_rate=exchange_rate;

		String sSql="";
		Statement stmt=null;
		try{
			stmt=con.createStatement();
			stmt.executeUpdate("delete from LEC_cpi");
			stmt.executeUpdate("delete from LEC_exchange");
			for (int j=0; j<nYears.length; j++)
			{
				sSql="insert into LEC_cpi (lec_year, lec_cpi) values("+years[j]+","+inflation[j]+")";
				if (nYears[j]>0 && inflation[j]!=0)
					stmt.executeUpdate(sSql);
				sSql="insert into LEC_exchange (lec_year, lec_rate) values("+nYears[j]+","+exchange_rate[j]+")";
				if (nYears[j]>0 && exchange_rate[j]!=0)
					stmt.executeUpdate(sSql);
			}
		}
		catch (Exception e)
		{
			System.out.println("[DI9] Error saving exchange/inflation... "+e.toString());
		}
		finally{
			try{stmt.close();}catch(Exception e){}
		}		
	}


	public void evaluate_inflation_exchange(DICountry countrybean,Connection con, String sTarget, int nOption)
	{

		//    <option value="0" selected><%=countrybean.getTranslation("Use maximum of Local and USD losses")%> </option>
		//    <option value="1"><%=countrybean.getTranslation("Priority to Local currency losses")%> </option>
		//    <option value="2"><%=countrybean.getTranslation("Priority to USD losses")%></option>
		//    <option value="3"><%=countrybean.getTranslation("Use only Local currency losses")%></option>
		//    <option value="4"><%=countrybean.getTranslation("Use only USD losses")%></option>
		//    <option value="5"><%=countrybean.getTranslation("Use SUM of Local and  USD losses")%></option>

		String sSql="";
		Statement stmt=null;
		try{
			target_variable=sTarget;
			stmt=con.createStatement();
			for (int j=0; j<nYears.length; j++)
				if (nYears[j]>0 && dInflation[j]+dExchange_rate[j]!=0)
				{
					sSql=" set "+sTarget+"=";
					if (dExchange_rate[j]==0)
						dExchange_rate[j]=1;
					if (dInflation[j]==0)
						dInflation[j]=100;
					String sLocal="valorloc*"+dExchange_rate[j]+"*"+(dInflation[j]/100);
					String sUSD="valorus*"+(dInflation[j]/100.0);		
					switch (nOption)
					{
					case 0:  sSql+="case when "+sLocal+">"+sUSD+" then "+sLocal+" else "+sUSD+" end";
					break;
					case 1:  sSql+="case when "+sLocal+">0 then "+sLocal+" else "+sUSD+" end";
					break;
					case 2:  sSql+="case when "+sUSD+">0 then "+sUSD+" else "+sLocal+" end";
					break;
					case 3:  sSql+=sLocal;
					break;
					case 4:  sSql+=sUSD;
					break;
					case 5:  sSql+=sLocal+" + "+sUSD;
					break;
					}
					if (sTarget.equals("valorus"))
						sSql="update fichas "+sSql+" where approved=0 and fechano="+nYears[j];
					else
						sSql=countrybean.updateExtensionJoin(sSql," approved=0 and fechano="+nYears[j]);
					stmt.executeUpdate(sSql);
					
					// uncomment to debug
					//System.out.println("[DI9] OK calculating  exchange/inflation... "+sSql);
				}
			
		}
		catch (Exception e)
		{
			System.out.println("[DI9] Error calculating  exchange/inflation... "+e.toString());
		}
		finally{
			try{stmt.close();}catch(Exception e){}
		}		

	}

	public void save_lec_parameters(DICountry countrybean, fichas woF, extension woE, String tv)
	{
		woFichas=woF;
		woExtension=woE;
		target_variable=tv;

		String sSql = "V.1.0";
		sSql += "\n@@target_variable="+tv;
		sSql += "\n@@Datacards";
		sSql += "\nmuertos="+woFichas.muertos;
		sSql += "\nheridos="+woFichas.heridos;
		sSql += "\ndesaparece="+woFichas.desaparece;
		sSql += "\nafectados="+woFichas.afectados;
		sSql += "\ndamnificados="+woFichas.damnificados;
		sSql += "\nevacuados="+woFichas.evacuados;
		sSql += "\nvivdest="+woFichas.vivdest;
		sSql += "\nvivafec="+woFichas.vivafec;
		sSql += "\nvalorloc="+woFichas.valorloc;
		sSql += "\nvalorus="+woFichas.valorus;
		sSql += "\nhay_muertos="+woFichas.hay_muertos;
		sSql += "\nhay_heridos="+woFichas.hay_heridos;
		sSql += "\nhay_deasparece="+woFichas.hay_deasparece;
		sSql += "\nhay_afectados="+woFichas.hay_afectados;
		sSql += "\nhay_vivdest="+woFichas.hay_vivdest;
		sSql += "\nhay_vivafec="+woFichas.hay_vivafec;
		sSql += "\nhay_otros="+woFichas.hay_otros;
		sSql += "\nsocorro="+woFichas.socorro;
		sSql += "\nsalud="+woFichas.salud;
		sSql += "\neducacion="+woFichas.educacion;
		sSql += "\nagropecuario="+woFichas.agropecuario;
		sSql += "\nindustrias="+woFichas.industrias;
		sSql += "\nacueducto="+woFichas.acueducto;
		sSql += "\nalcantarillado="+woFichas.alcantarillado;
		sSql += "\nenergia="+woFichas.energia;
		sSql += "\ncomunicaciones="+woFichas.comunicaciones;
		sSql += "\ntransporte="+woFichas.transporte;
		sSql += "\nnhospitales="+woFichas.nhospitales;
		sSql += "\nnescuelas="+woFichas.nescuelas;
		sSql += "\nnhectareas="+woFichas.nhectareas;
		sSql += "\ncabezas="+woFichas.cabezas;
		sSql += "\nkmvias="+woFichas.kmvias;
		sSql += "\nhay_damnificados="+woFichas.hay_damnificados;
		sSql += "\nhay_evacuados="+woFichas.hay_evacuados;
		sSql += "\nhay_reubicados="+woFichas.hay_reubicados;
		sSql += "\nreubicados="+woFichas.reubicados;
		sSql += "\n@@Extension";
		Dictionary dct=new Dictionary();
		for (int k = 0; k < woExtension.vFields.size(); k++)
		{
			dct = (Dictionary) woExtension.vFields.get(k);
			if (dct.fieldtype==extension.YESNO  ||
					dct.fieldtype==extension.INTEGER  ||
					dct.fieldtype==extension.FLOATINGPOINT  ||
					dct.fieldtype==extension.CURRENCY)		 
			{
				sSql+="\n"+dct.nombre_campo+"="+dct.dNumericValue;
			}
		}

		sSql += "\n@@ExchangeRates";


		sSql += "\n@@InflationCPI";

		String outputFilename=countrybean.country.sjetfilename+"/unit_valuation_"+countrybean.countrycode+".txt";

		// System.out.println("Generating parameter file " + outputFilename);
		PrintWriter out_file = null;
		try{
			out_file = new PrintWriter(new FileOutputStream(outputFilename));
			out_file.write(sSql);
		}
		catch (Exception ioe)
		{
			System.out.println("[DI9]: Error generating LEC unit loss parameter file " + outputFilename);

		}
		finally{
			try {out_file.close();} catch (Exception ioe2){};
		}

	}

	public String  load_lec_parameters(DICountry countrybean, fichas woF, extension woE)
	{

		woFichas=woF;
		woExtension=woE;
		String sInputFileName=countrybean.country.sjetfilename+"/unit_valuation_"+countrybean.countrycode+".txt";
		BufferedReader in=null; 
		try {
			String sLine="";
			File f=new File(sInputFileName);
			if (f.exists() && f.isFile() && f.canRead())
			{
				target_variable="";
				woFichas.init();
				woExtension.init();
				// open input file
				in = new BufferedReader(new FileReader(sInputFileName));
				//System.out.println("Loading LEC parameter file "+sInputFileName);
				sLine = in.readLine(); // This should be the Version (V.1.0), ignored for now
				sLine = in.readLine(); // Target Variable
				target_variable=sLine.substring(sLine.indexOf("=")+1);
				sLine = in.readLine(); // @@Datacard section, ignored for now
				while ((sLine = in.readLine()) != null && (!sLine.startsWith("@@"))) 
				{
					int pos=sLine.indexOf("="); 
					String sVar=sLine.substring(0,pos);
					String sValue=sLine.substring(pos+1);
					woFichas.asFieldNames.put(sVar, sValue);
				}
				woFichas.updateMembersFromHashTable();
				// @@extension section, ignored for now
				while ((sLine = in.readLine()) != null && (!sLine.startsWith("@@"))) 
				{
					int pos=sLine.indexOf("="); 
					String sVar=sLine.substring(0,pos);
					String sValue=sLine.substring(pos+1);
					woExtension.asFieldNames.put(sVar, sValue);
				}
				woExtension.updateMembersFromHashTable();
				// @@ExchangeRates section, ignored for now

				// @@InflationCPI section, ignored for now

			}
		}
		catch (Exception ioe)
		{
			System.out.println("[DI9]: Error loading LEC unit loss parameter file " + sInputFileName);

		}
		finally{
			try {in.close();} catch (Exception ioe2){};
		}

		return target_variable;
	}


	public String calcVarValue(String variable, double value)
	{
		String sRet="";
		if (value>0)
		{
			sRet+="+"+countrybean.sqlNvl(variable,0)+"*"+value;
		}
		return sRet;
	}

	
	public String calcVarValue(String variable, double value, String hay_variable)
	{
		String sRet="";
		if (value>0)
		{
			sRet+="+"+countrybean.sqlNvl(variable,0)+"*"+value;
		}
		return sRet;
	}


	public void evaluate_economic_value(DICountry countrybean, Connection con)
	{

		String sSql=null;

		this.countrybean=countrybean;
		sSql=" set "+target_variable+"=0";   //kmvias*200 + cabezas*200 + vivafec*8000 + nhectareas*800 +vivdest*22000+nescuelas*90000+nhospitales*800000";

		sSql+=calcVarValue("muertos",woFichas.muertos,"hay_muertos");
		sSql+=calcVarValue("heridos",woFichas.heridos,"hay_heridos");
		sSql+=calcVarValue("desaparece",woFichas.desaparece,"hay_heridos");

		sSql+=calcVarValue("afectados",woFichas.afectados,"hay_afectados");
		sSql+=calcVarValue("damnificados",woFichas.damnificados,"hay_damnificados");
		sSql+=calcVarValue("evacuados",woFichas.evacuados,"hay_evacuados");
		sSql+=calcVarValue("reubicados",woFichas.reubicados,"hay_reubicados");

		sSql+=calcVarValue("vivdest",woFichas.vivdest,"hay_vivdest");
		sSql+=calcVarValue("vivafec",woFichas.vivafec,"hay_vivafec");

		sSql+=calcVarValue("nescuelas",woFichas.nescuelas,"educacion");
		sSql+=calcVarValue("nhospitales",woFichas.nhospitales,"salud");
		sSql+=calcVarValue("nhectareas",woFichas.nhectareas,"agropecuario");
		sSql+=calcVarValue("kmvias",woFichas.kmvias,"transporte");				

		sSql+=calcVarValue("cabezas",woFichas.cabezas);

		// This should go with inflation and exchange rate...
		sSql+=calcVarValue("valorloc",woFichas.valorloc);
		sSql+=calcVarValue("valorus",woFichas.valorus);

		sSql+=calcVarValue("abs(socorro)",woFichas.socorro);
		sSql+=calcVarValue("abs(industrias)",woFichas.industrias);
		sSql+=calcVarValue("abs(acueducto",woFichas.acueducto);
		sSql+=calcVarValue("abs(alcantarillado)",woFichas.alcantarillado);
		sSql+=calcVarValue("abs(energia)",woFichas.energia);
		sSql+=calcVarValue("abs(comunicaciones)",woFichas.comunicaciones);
		sSql+=calcVarValue("abs(hay_otros)",woFichas.hay_otros);


		org.lared.desinventar.webobject.Dictionary dct=new org.lared.desinventar.webobject.Dictionary();
		for (int k = 0; k < woExtension.vFields.size(); k++)
		{
			dct = (Dictionary) woExtension.vFields.get(k);
			if (dct.fieldtype==extension.YESNO  ||
					dct.fieldtype==extension.INTEGER  ||
					dct.fieldtype==extension.FLOATINGPOINT  ||
					dct.fieldtype==extension.CURRENCY)		 
			{
				sSql+=calcVarValue(dct.nombre_campo,dct.dNumericValue);				 
			}
		}

		if (target_variable.equals("valorus") || target_variable.equals("valorloc"))
			sSql=countrybean.updateDatacardJoin(sSql,"approved=0");
		else
			sSql=countrybean.updateExtensionJoin(sSql,"approved=0");

		Statement stmt=null;
		try {
			stmt=con.createStatement();
			stmt.execute(sSql);
		}
		catch (Exception e)
		{
			System.out.println("[DI9] Error in LEC valuator: "+e.toString());
		}
		finally
		{
			try{stmt.close();}catch (Exception ex){}
		}
	}


	/**
	 * UNIT TEST
	 * @param args
	 */
	public static void main(String[] args) 
	{
		LEC_util_valuation  lecValuator=new LEC_util_valuation();

		lecValuator.woFichas=new fichas(); 						// with unit values
		lecValuator.woExtension=new extension(); 				// with unit values
		lecValuator.target_variable="valorus";					// where the calculated value will go

		lecValuator.woFichas.vivafec=500;
		lecValuator.woFichas.kmvias=200;
		lecValuator.woFichas.cabezas=200;
		lecValuator.woFichas.vivafec=8000;
		lecValuator.woFichas.nhectareas=800;
		lecValuator.woFichas.vivdest=22000;
		lecValuator.woFichas.nescuelas=90000;
		lecValuator.woFichas.nhospitales=800000;

		String sDbDriverName = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
		String sDbConnect="jdbc:sqlserver://localhost:1433;databaseName=colombia;";
		String sDbUser="sa";
		String sDbPass="c98";

		pooledConnection pc=new pooledConnection(sDbDriverName, sDbConnect,sDbUser,sDbPass);				
		pc.getConnection();
		Connection con=pc.connection;

		DICountry countrybean=new DICountry();
		countrybean.dbType=Sys.iMsSqlDb; // mssql server / access / oracle / postgres?
		countrybean.setCountryname("Colombia");
		countrybean.setCountrycode("co");
		countrybean.country.dbType=countrybean.dbType;
		countrybean.country.sjetfilename="c:/bases_6/Colombia2008";

		lecValuator.save_lec_parameters(countrybean, lecValuator.woFichas, lecValuator.woExtension, "valorus");

		lecValuator.evaluate_economic_value(countrybean, con);



	}

}
