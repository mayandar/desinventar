package org.lared.desinventar.util;

import java.util.*;
import java.sql.*;
import org.lared.desinventar.util.*;
import org.lared.desinventar.webobject.*;

public class VariableManager {

	public HashMap<String,String> hmVarTitle=new HashMap<String,String>();

	public VariableManager()
	{
		initVariableManager();
	}
	
	public void initVariableManager()
		{
		hmVarTitle.put("eventos.nombre","Event");
		hmVarTitle.put("eventos.nombre_en","Event");
		hmVarTitle.put("fichas.fechano,fichas.fechames,fichas.fechadia","Date_");
		hmVarTitle.put("causas.causa", "Cause");
		hmVarTitle.put("causas.causa_en", "Cause");
		hmVarTitle.put("fichas.descausa","DescriptionCause");
		hmVarTitle.put("fichas.fuentes","Source");
		hmVarTitle.put("fichas.magnitud2","Magnitude");
		hmVarTitle.put("fichas.glide","GLIDEnumber");
		hmVarTitle.put("fichas.lugar","Location");
		hmVarTitle.put("fichas.otros","Othersectors");	
		hmVarTitle.put("fichas.di_comments","Comments");	

		hmVarTitle.put("fichas.fechano","Year");	
		hmVarTitle.put("fichas.fechames","Month");	
		hmVarTitle.put("fichas.fechadia","Day");	

		hmVarTitle.put("1","DataCards");
		hmVarTitle.put("fichas.muertos","Deaths");
		hmVarTitle.put("fichas.heridos","Injured");
		hmVarTitle.put("fichas.desaparece","Missing");
		hmVarTitle.put("fichas.vivdest","DestroyedHouses");
		hmVarTitle.put("fichas.vivafec","AffectedHouses");
		hmVarTitle.put("fichas.damnificados","Victims");
		hmVarTitle.put("fichas.afectados","Affected");
		hmVarTitle.put("fichas.reubicados","Relocated");
		hmVarTitle.put("fichas.evacuados","Evacuated");
		hmVarTitle.put("fichas.valorus","LossesUSD");
		hmVarTitle.put("fichas.valorloc","LossesLocal");
		hmVarTitle.put("fichas.nescuelas","Educationcenters");
		hmVarTitle.put("fichas.nhospitales","Hospitals");
		hmVarTitle.put("fichas.nhectareas","Damagesincrops");
		hmVarTitle.put("fichas.cabezas","Catle");
		hmVarTitle.put("fichas.kmvias","Damagesinroads");
		hmVarTitle.put("fichas.duracion","Duration");
		hmVarTitle.put("abs(hay_muertos)","WithDeaths");
		hmVarTitle.put("abs(hay_heridos)","WithInjured");
		hmVarTitle.put("abs(hay_deasparece)","WithMissing");
		hmVarTitle.put("abs(hay_vivdest)","WithHousesDestroyed");
		hmVarTitle.put("abs(hay_vivafec)","WithHousesAffected");
		hmVarTitle.put("abs(hay_damnificados)","WithVictims");
		hmVarTitle.put("abs(hay_afectados)","WithAffected");
		hmVarTitle.put("abs(hay_reubicados)","WithRelocated");
		hmVarTitle.put("abs(hay_evacuados)","WithEvacuated");
		hmVarTitle.put("abs(educacion)","Education");
		hmVarTitle.put("abs(salud)","Health");
		hmVarTitle.put("abs(agropecuario)","Agriculture");
		hmVarTitle.put("abs(acueducto)","Water");
		hmVarTitle.put("abs(alcantarillado)","Sewerage");
		hmVarTitle.put("abs(industrias)","Industrial");
		hmVarTitle.put("abs(comunicaciones)","Communications");
		hmVarTitle.put("abs(transporte)","Transportation");
		hmVarTitle.put("abs(energia)","Power");
		hmVarTitle.put("abs(socorro)","Relief");
		hmVarTitle.put("abs(hay_otros)","WithOthersectors");
		hmVarTitle.put("@formula@","Formula");
		
	}

    public void addCountryVariables(DICountry countrybean)
    {
	hmVarTitle.put("fichas.level0","Code "+countrybean.asLevels[0]);
	hmVarTitle.put("lev0_name",countrybean.asLevels[0]);
	hmVarTitle.put("lev0_name_en",countrybean.asLevels[0]);
	hmVarTitle.put("fichas.level1","Code" +countrybean.asLevels[1]);
	hmVarTitle.put("lev1_name",countrybean.asLevels[1]);
	hmVarTitle.put("lev1_name_en",countrybean.asLevels[1]);
	hmVarTitle.put("fichas.level2","Code"+countrybean.asLevels[2]);
	hmVarTitle.put("lev2_name",countrybean.asLevels[2]);
	hmVarTitle.put("lev2_name_en",countrybean.asLevels[2]);
	}
    
    public void addExtensionVariables(extension woExtension, DICountry countrybean)
    {
    	addCountryVariables(countrybean);
    	
    	// allocates a dictionary object to read each record
    	org.lared.desinventar.webobject.Dictionary dct = new org.lared.desinventar.webobject.Dictionary();
    	for (int k = 0; k < woExtension.vFields.size(); k++)
    	    {
    	    dct = (org.lared.desinventar.webobject.Dictionary) woExtension.vFields.get(k);
    	    boolean bIsNumeric=false;
    	    if (dct.nDataType==Types.DECIMAL
    	       || dct.nDataType==Types.DOUBLE
    	       || dct.nDataType==Types.FLOAT
    	       || dct.nDataType==Types.NUMERIC
    	       || dct.nDataType==Types.REAL
    	       || dct.nDataType==Types.SMALLINT
    	       || dct.nDataType==Types.INTEGER
    		   )
    			bIsNumeric=true;
    		 String sDescription=countrybean.getLocalOrEnglish(dct.label_campo,dct.label_campo_en).trim();
    		 String sField=dct.nombre_campo;
    		 if (sDescription==null || sDescription.length()==0)
    				sDescription=sField;
    		 hmVarTitle.put("extension."+dct.nombre_campo.toUpperCase(),sDescription);
    	    }

    }

    public String getVarTitle(String sSqlVar)
    {
      if (hmVarTitle.size()==0)
    	  initVariableManager();
      if (sSqlVar.startsWith("extension."))
    		  sSqlVar="extension."+sSqlVar.substring(10).toUpperCase();
      return  hmVarTitle.get(sSqlVar);
    }
    
}
