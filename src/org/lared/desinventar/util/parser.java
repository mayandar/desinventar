/*
 * Created on 12-Jan-2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.lared.desinventar.util;

import java.util.HashMap;
import java.util.Hashtable;
import java.util.StringTokenizer;

/**
 * @author Julio Serje
 *
 * simple parser and translator for SQL expressions 
 */
public class parser 
{
	
	  public HashMap hmVarTrans=null;
	  public HashMap hmVarUntrans=null;
	  
	 public void buildTranslations(DICountry countrybean, boolean bAlpha)
	  {

	  	hmVarTrans=new HashMap();  	
	  	hmVarUntrans=new HashMap();  	

	 
	   	if (bAlpha)
	   		{
	   		hmVarTrans.put("fichas.serial",countrybean.getTranslation("VSerial"));
	   	  	hmVarTrans.put("fichas.evento",countrybean.getTranslation("VEvent"));
	   	  	hmVarTrans.put("fichas.lugar",countrybean.getTranslation("VLocation"));
	   	  	hmVarTrans.put("fichas.di_comments",countrybean.getTranslation("VComments"));
	   	  	hmVarTrans.put("fichas.causa",countrybean.getTranslation("VCause"));
	   	  	hmVarTrans.put("fichas.fuentes",countrybean.getTranslation("VSource"));
	   	  	hmVarTrans.put("fichas.magnitud2",countrybean.getTranslation("VMagnitude"));
	   		}
	  	
	  	// hmVarTrans.put("1",countrybean.getTranslation("VDataCards"));
	  	hmVarTrans.put("fichas.muertos",countrybean.getTranslation("VDeaths"));
	  	hmVarTrans.put("fichas.heridos",countrybean.getTranslation("VInjured"));
	  	hmVarTrans.put("fichas.desaparece",countrybean.getTranslation("VMissing"));
	  	hmVarTrans.put("fichas.vivdest",countrybean.getTranslation("VDestroyedHouses"));
	  	hmVarTrans.put("fichas.vivafec",countrybean.getTranslation("VAffectedHouses"));
	  	hmVarTrans.put("fichas.damnificados",countrybean.getTranslation("VVictims"));
	  	hmVarTrans.put("fichas.afectados",countrybean.getTranslation("VAffected"));
	  	hmVarTrans.put("fichas.reubicados",countrybean.getTranslation("VRelocated"));
	  	hmVarTrans.put("fichas.evacuados",countrybean.getTranslation("VEvacuated"));
	  	hmVarTrans.put("fichas.valorus",countrybean.getTranslation("VLossesUSD"));
	  	hmVarTrans.put("fichas.valorloc",countrybean.getTranslation("VLossesLocal"));
	  	hmVarTrans.put("fichas.nescuelas",countrybean.getTranslation("VEducationcenters"));
	  	hmVarTrans.put("fichas.nhospitales",countrybean.getTranslation("VHospitals"));
	  	hmVarTrans.put("fichas.nhectareas",countrybean.getTranslation("VDamagesincrops"));
	  	hmVarTrans.put("fichas.cabezas",countrybean.getTranslation("VCatle"));
	  	hmVarTrans.put("fichas.kmvias",countrybean.getTranslation("VDamagesinroads"));
	  	hmVarTrans.put("fichas.hay_muertos",countrybean.getTranslation("VWithDeaths"));
	  	hmVarTrans.put("fichas.hay_heridos",countrybean.getTranslation("VWithInjured"));
	  	hmVarTrans.put("fichas.hay_deasparece",countrybean.getTranslation("VWithMissing"));
	  	hmVarTrans.put("fichas.hay_vivdest",countrybean.getTranslation("VWithHousesDestroyed"));
	  	hmVarTrans.put("fichas.hay_vivafec",countrybean.getTranslation("VWithHousesAffected"));
	  	hmVarTrans.put("fichas.hay_damnificados",countrybean.getTranslation("VWithVictims"));
	  	hmVarTrans.put("fichas.hay_afectados",countrybean.getTranslation("VWithAffected"));
	  	hmVarTrans.put("fichas.hay_reubicados",countrybean.getTranslation("VWithRelocated"));
	  	hmVarTrans.put("fichas.hay_evacuados",countrybean.getTranslation("VWithEvacuated"));
	  	hmVarTrans.put("fichas.educacion",countrybean.getTranslation("VEducation"));
	  	hmVarTrans.put("fichas.salud",countrybean.getTranslation("VHealth"));
	  	hmVarTrans.put("fichas.agropecuario",countrybean.getTranslation("VAgriculture"));
	  	hmVarTrans.put("fichas.acueducto",countrybean.getTranslation("VWater"));
	  	hmVarTrans.put("fichas.alcantarillado",countrybean.getTranslation("VSewerage"));
	  	hmVarTrans.put("fichas.industrias",countrybean.getTranslation("VIndustrial"));
	  	hmVarTrans.put("fichas.comunicaciones",countrybean.getTranslation("VCommunications"));
	  	hmVarTrans.put("fichas.transporte",countrybean.getTranslation("VTransportation"));
	  	hmVarTrans.put("fichas.energia",countrybean.getTranslation("VPower"));
	  	hmVarTrans.put("fichas.socorro",countrybean.getTranslation("VRelief"));
	  	hmVarTrans.put("fichas.hay_otros",countrybean.getTranslation("VOthersectors"));

	  	hmVarTrans.put("fichas.fechano",countrybean.getTranslation("VYear"));
	  	hmVarTrans.put("fichas.fechames",countrybean.getTranslation("VMonth"));
	  	hmVarTrans.put("fichas.fechadia",countrybean.getTranslation("VDay"));
	  	hmVarTrans.put("fichas.duracion",countrybean.getTranslation("VDuration"));

	   	if (bAlpha)
			{
		  	hmVarUntrans.put(countrybean.getTranslation("VSerial"),"fichas.serial"	);
		  	hmVarUntrans.put(countrybean.getTranslation("VEvent"),"fichas.evento"	);
		  	hmVarUntrans.put(countrybean.getTranslation("VLocation"),"fichas.lugar"	);
		  	hmVarUntrans.put(countrybean.getTranslation("VComments"),"fichas.di_comments"	);
		  	hmVarUntrans.put(countrybean.getTranslation("VCause"),"fichas.causa"	);
		  	hmVarUntrans.put(countrybean.getTranslation("VSource"),"fichas.fuentes"	);
		  	hmVarUntrans.put(countrybean.getTranslation("VMagnitude"),"fichas.magnitude2"	);
			}

	  	
		//hmVarUntrans.put(countrybean.getTranslation("VDataCards"),"1"	);
		hmVarUntrans.put(countrybean.getTranslation("VDeaths"),"fichas.muertos"	);
		hmVarUntrans.put(countrybean.getTranslation("VInjured"),"fichas.heridos"	);
		hmVarUntrans.put(countrybean.getTranslation("VMissing"),"fichas.desaparece"	);
		hmVarUntrans.put(countrybean.getTranslation("VDestroyedHouses"),"fichas.vivdest"	);
		hmVarUntrans.put(countrybean.getTranslation("VAffectedHouses"),"fichas.vivafec"	);
		hmVarUntrans.put(countrybean.getTranslation("VVictims"),"fichas.damnificados"	);
		hmVarUntrans.put(countrybean.getTranslation("VAffected"),"fichas.afectados"	);
		hmVarUntrans.put(countrybean.getTranslation("VRelocated"),"fichas.reubicados"	);
		hmVarUntrans.put(countrybean.getTranslation("VEvacuated"),"fichas.evacuados"	);
		hmVarUntrans.put(countrybean.getTranslation("VLossesUSD"),"fichas.valorus"	);
		hmVarUntrans.put(countrybean.getTranslation("VLossesLocal"),"fichas.valorloc"	);
		hmVarUntrans.put(countrybean.getTranslation("VEducationcenters"),"fichas.nescuelas"	);
		hmVarUntrans.put(countrybean.getTranslation("VHospitals"),"fichas.nhospitales"	);
		hmVarUntrans.put(countrybean.getTranslation("VDamagesincrops"),"fichas.nhectareas"	);
		hmVarUntrans.put(countrybean.getTranslation("VCatle"),"fichas.cabezas");
		hmVarUntrans.put(countrybean.getTranslation("VDamagesinroads"),	"fichas.kmvias"	);
		hmVarUntrans.put(countrybean.getTranslation("VWithDeaths"),"fichas.hay_muertos");
		hmVarUntrans.put(countrybean.getTranslation("VWithInjured"),"fichas.hay_heridos");
		hmVarUntrans.put(countrybean.getTranslation("VWithMissing"),"fichas.hay_deasparece");
		hmVarUntrans.put(countrybean.getTranslation("VWithHousesDestroyed"),"fichas.hay_vivdest");
		hmVarUntrans.put(countrybean.getTranslation("VWithHousesAffected"),"fichas.hay_vivafec");
		hmVarUntrans.put(countrybean.getTranslation("VWithVictims"),"fichas.hay_damnificados");
		hmVarUntrans.put(countrybean.getTranslation("VWithAffected"),"fichas.hay_afectados");
		hmVarUntrans.put(countrybean.getTranslation("VWithRelocated"),"fichas.hay_reubicados");
		hmVarUntrans.put(countrybean.getTranslation("VWithEvacuated"),"fichas.hay_evacuados");
		hmVarUntrans.put(countrybean.getTranslation("VEducation"),"fichas.educacion");
		hmVarUntrans.put(countrybean.getTranslation("VHealth"),"fichas.salud");
		hmVarUntrans.put(countrybean.getTranslation("VAgriculture"),"fichas.agropecuario");
		hmVarUntrans.put(countrybean.getTranslation("VWater"),"fichas.acueducto");
		hmVarUntrans.put(countrybean.getTranslation("VSewerage"),"fichas.alcantarillado");
		hmVarUntrans.put(countrybean.getTranslation("VIndustrial"),"fichas.industrias");
		hmVarUntrans.put(countrybean.getTranslation("VCommunications"),"fichas.comunicaciones");
		hmVarUntrans.put(countrybean.getTranslation("VTransportation"),"fichas.transporte");
		hmVarUntrans.put(countrybean.getTranslation("VPower"),"fichas.energia");
		hmVarUntrans.put(countrybean.getTranslation("VRelief"),"fichas.socorro");
		hmVarUntrans.put(countrybean.getTranslation("VOthersectors"),"fichas.hay_otros");
		hmVarUntrans.put(countrybean.getTranslation("VYear"),"fichas.fechano");
		hmVarUntrans.put(countrybean.getTranslation("VMonth"),"fichas.fechames");
		hmVarUntrans.put(countrybean.getTranslation("VDay"),"fichas.fechadia");
		hmVarUntrans.put(countrybean.getTranslation("VDuration"),"fichas.duracion");
	  	
	  }
	  

	  public String translateExpertExpression(String sExpression, HashMap hmTranslator)
	  {
	  	String sRet="";
	  	String sTranslated="";
	  	String sToken;
	  	StringTokenizer parser=new StringTokenizer(sExpression," +-*/=()%\"'><|",true) ;
	  	while (parser.hasMoreTokens())
	  	{
	  		sToken=parser.nextToken();
	  		if (sToken.startsWith("\""))
	  		   {
	  			sRet=sToken;
	  			boolean bClosed=false;
	  			// especial cases of literals
	  			while (parser.hasMoreTokens() && ! bClosed)
	  			{
	  		  		sToken=parser.nextToken();
	  		  		sRet+=sToken;
	  				if (sToken.equals("\""))
	  					bClosed=true;
	  			}
	  		   }
	  		else
	  	  		if (sToken.startsWith("'"))
	   		   {
	  	  			sRet=sToken;
	  	  			boolean bClosed=false;
	  	  			while (parser.hasMoreTokens() && ! bClosed)
	  	  			{
	  	  		  		sToken=parser.nextToken();
	  	  		  		sRet+=sToken;
	  	  				if (sToken.equals("'"))
	  	  					bClosed=true;
	  	  			}
	   		   }
	   		else
	  			sRet=sToken;	
	  		sToken=(String) hmTranslator.get(sToken);
	        if (sToken==null)
	        	sTranslated+=sRet;
	        else
	        	sTranslated+=sToken;
	  	}
	  	return sTranslated;
	  }



}
