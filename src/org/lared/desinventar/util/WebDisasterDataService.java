package org.lared.desinventar.util;

import java.util.*;

public class WebDisasterDataService {

	public HashMap<String,String> hmStandardEvents=new HashMap<String,String>();	

	public String getStandardEventCode(String sDICode)
	{
	return	hmStandardEvents.get(sDICode);
	}
	
	public WebDisasterDataService ()
	 {
		hmStandardEvents.put("FLOOD","FL");
		hmStandardEvents.put("LANDSLIDE","LS");
		hmStandardEvents.put("FLASH FLOOD","FF");
		hmStandardEvents.put("RAINS","RN");
		hmStandardEvents.put("WINDSTORM","VW");
		hmStandardEvents.put("STORM","ST");
		hmStandardEvents.put("SURGE","SS");
		hmStandardEvents.put("EARTHQUAKE","EQ");
		hmStandardEvents.put("CYCLONE","TC");
		hmStandardEvents.put("FROST","FT");
		hmStandardEvents.put("HAILSTORM","HS");
		hmStandardEvents.put("DROUGHT","DR");
		hmStandardEvents.put("MUDSLIDE","MS");
		hmStandardEvents.put("AVALANCHE","AV");
		hmStandardEvents.put("TSUNAMI","TS");
		hmStandardEvents.put("FIRE","FR");
		hmStandardEvents.put("FOREST FIRE","WF");
		hmStandardEvents.put("WILD FIRE","WF");
		hmStandardEvents.put("EPIDEMIC","EP");
		hmStandardEvents.put("PLAGUE","IN");
		hmStandardEvents.put("BIOLOGICAL","BI");
		hmStandardEvents.put("ERUPTION","VO");
		hmStandardEvents.put("THUNDER STORM","TS");
		hmStandardEvents.put("THUNDERSTORM","TS");
		hmStandardEvents.put("LIGHTNING","TS");
		hmStandardEvents.put("SNOWSTORM","SN");
		hmStandardEvents.put("SNOW STORM","SN");
		hmStandardEvents.put("HEAT WAVE","HT");
		hmStandardEvents.put("HEATWAVE","HT");
		hmStandardEvents.put("TORNADO","TO");
		hmStandardEvents.put("COLD WAVE","CW");
		hmStandardEvents.put("COLDWAVE","CW");
	
		/*
		hmStandardEvents.put("ACCIDENT","");
		hmStandardEvents.put("EXPLOSION","");
		hmStandardEvents.put("LEAK","");
		hmStandardEvents.put("STRUCTURE","");
		hmStandardEvents.put("PANIC","");
		hmStandardEvents.put("INTOXICATION","");
		hmStandardEvents.put("SEDIMENTATION","");
		hmStandardEvents.put("COASTLINE","");
		hmStandardEvents.put("LIQUEFACTION","");
		hmStandardEvents.put("OTHER","");
		hmStandardEvents.put("CONTAMINATION","");
		hmStandardEvents.put("FOG","");
		*/
	 }

}
