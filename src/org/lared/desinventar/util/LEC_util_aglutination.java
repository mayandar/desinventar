package org.lared.desinventar.util;

import java.text.SimpleDateFormat;
import java.util.*;
import java.io.*;
import java.net.URLDecoder;
import java.sql.*;
import java.awt.Color;

import org.lared.desinventar.util.*;
import org.lared.desinventar.system.*;
import org.lared.desinventar.webobject.*;
import org.lared.desinventar.webobject.Dictionary;

public class LEC_util_aglutination 
{
	// variables for aglutination:
	int nGroupingMode=0;  		//0-> by category,  1-> by event
	int nGroupingByDuration=1;  // 1-> take into account the duration
	
	String[] asCategories={"Earthquake","EQ_Landslide","Hydromet","HM_Landslide","Landslide","Volcanic","Other"};
	int [] aiIntervals={2,2,5,3,3,5,5,1};

	int Earthquake=0; 
	int EQ_Landslide=1;  
	int Hydromet=2;  
	int HM_Landslide=3;  
	int Landslide=4;  
	int Volcanic=5;  
	int Other=6;
	
	
	public void loadParameters(DICountry countrybean)
	{
		String sGroupingFileName=countrybean.country.sjetfilename+"/event_grouping_"+countrybean.countrycode+".txt";
		BufferedReader in=null; 
		String sLine="";
		try {
			File f=new File(sGroupingFileName);
			if (f.exists() && f.isFile() && f.canRead())
				{
				// open input file
				in = new BufferedReader(new FileReader(sGroupingFileName));
				//System.out.println("Loading LEC parameter file "+sInputFileName);
				sLine = in.readLine(); // This should be the Version (V.1.0), ignored for now
				sLine = in.readLine(); // Grouping mode
				nGroupingMode=webObject.extendedParseInt(sLine.substring(sLine.indexOf("=")+1));		
				sLine = in.readLine(); // Grouping by duration too
				nGroupingByDuration=webObject.extendedParseInt(sLine.substring(sLine.indexOf("=")+1));		
				sLine = in.readLine(); // optional parameter (future use)
				int npar1=webObject.extendedParseInt(sLine.substring(sLine.indexOf("=")+1));		
				sLine = in.readLine(); // optional parameter (future use)
				int npar2=webObject.extendedParseInt(sLine.substring(sLine.indexOf("=")+1));		

				sLine = in.readLine(); // Category Variable
				aiIntervals[Earthquake]=webObject.extendedParseInt(sLine.substring(sLine.indexOf("=")+1));		
				sLine = in.readLine(); // Category Variable
				aiIntervals[EQ_Landslide]=webObject.extendedParseInt(sLine.substring(sLine.indexOf("=")+1));		
				sLine = in.readLine(); // Category Variable
				aiIntervals[Hydromet]=webObject.extendedParseInt(sLine.substring(sLine.indexOf("=")+1));		
				sLine = in.readLine(); // Category Variable
				aiIntervals[HM_Landslide]=webObject.extendedParseInt(sLine.substring(sLine.indexOf("=")+1));		
				sLine = in.readLine(); // Category Variable
				aiIntervals[Landslide]=webObject.extendedParseInt(sLine.substring(sLine.indexOf("=")+1));		
				sLine = in.readLine(); // Category Variable
				aiIntervals[Volcanic]=webObject.extendedParseInt(sLine.substring(sLine.indexOf("=")+1));		
				sLine = in.readLine(); // Category Variable
				aiIntervals[Other]=webObject.extendedParseInt(sLine.substring(sLine.indexOf("=")+1));
				}
			}
			catch (Exception ioe)
			{
				System.out.println("[DI9]: Error loading LEC unit loss parameter file " + sGroupingFileName);
				
			}
			finally{
				try {in.close();} catch (Exception ioe2){};
			}

	}

	public void setParameters(int nGroupingMode, int nGroupingByDuration)
	{
		this.nGroupingMode=nGroupingMode;
		this.nGroupingByDuration=nGroupingByDuration;
	}
	
	
	public void clean_aglutination (DICountry countrybean, Connection con)
	{
		Statement stmt=null;
		try{
			stmt=con.createStatement();
			stmt.executeUpdate("update fichas set glide=null where glide like '@@%'");
		}
		catch (Exception exAgl)
		{
			System.out.println("[DI9] Exception cleaning LEC grouping"+exAgl.toString());
		}
		finally{
			try {stmt.close();}catch(Exception x){}	
		}
	}
	
	public void aglutinate_categories(DICountry countrybean, Connection con)
	{
		Statement stmt=null;
		ResultSet rset=null;
		try{
			stmt=con.createStatement();
			for (int nCat=0; nCat<asCategories.length; nCat++)
				{
				// for each category, send an update with its interval
				// first, build a list of the event types of each category
				rset=stmt.executeQuery("select * from event_grouping where category='"+asCategories[nCat]+"'"); // verify table name
				String sList="('__'";
				while (rset.next())
					sList+=",'"+htmlServer.check_quotes(rset.getString("nombre"))+"'";
				sList+=")";			
				// buils query for the category.
				String sSql=countrybean.updateFromJoin("fichas", "fichas", "t1.evento in "+sList+" and t2.evento in "+sList+" and t1.level0=t2.level0 and (t1.fechano*365+t1.fechames*30+t1.fechadia between t2.fechano*365+t2.fechames*30+t2.fechadia and t2.fechano*365+t2.fechames*30+t2.fechadia+"+aiIntervals[nCat]+")"
									, "set t1.glide=t2.glide", "t1.approved=0 and t1.glide like '@@%'");
				stmt.executeUpdate(sSql);				
				}			
		}
		catch (Exception exAgl)
		{
			System.out.println("[DI9] Exception grouping [categories]"+exAgl.toString());
		}
		finally{
			try {stmt.close();}catch(Exception x){}	
		}	
	}

	public void aglutinate_events(DICountry countrybean, Connection con)
	{
		Statement stmt=null;
		Statement ustmt=null;
		ResultSet rset=null;
		try{
			stmt=con.createStatement();

			//nombre varchar (30)  NOT NULL ,
			//lec_grouping_days smallint,
		    //category varchar(30)
			
			ustmt=con.createStatement();
			rset=stmt.executeQuery("select * from eventos, event_grouping where eventos.nombre=event_grouping.nombre");
			while (rset.next())
				{
				String sSql=countrybean.updateFromJoin("fichas", "fichas","t1.evento='"+htmlServer.check_quotes(rset.getString("nombre"))
						                          +  "' and t1.evento=t2.evento and t1.level0=t2.level0 and "
						                          +  "(t1.fechano*365+t1.fechames*30+t1.fechadia between t2.fechano*365+t2.fechames*30+t2.fechadia and t2.fechano*365+t2.fechames*30+t2.fechadia + "+rset.getInt("lec_grouping_days")+")"
						                          , "set t1.glide=t2.glide", "t1.approved=0 and t1.glide like '@@%'");
				ustmt.executeUpdate(sSql);
				}	
		}
		catch (Exception exAgl)
		{
			System.out.println("[DI9] Exception grouping [events]"+exAgl.toString());
		}
		finally{
			try {stmt.close();}catch(Exception x){}	
			try {ustmt.close();}catch(Exception x){}	
			try {rset.close();}catch(Exception x){}	
		}
		
		
	}
	

	public void generate_aglutination (DICountry countrybean, Connection con)
	{
		Statement stmt=null;
		ResultSet rset=null;

		// 0 load parameters from file
		loadParameters(countrybean);
		// 1-Clean previous groupings:
		clean_aglutination (countrybean, con);
		try{
			stmt=con.createStatement();
			// 2 - initial generation of an internal glide.
			String sSql="update fichas set glide="+countrybean.sqlConcat("'@@'",countrybean.sqlCharNumber("clave"))+
				   			   "  where "+countrybean.sqlNvl("approved",0)+"=0 and "+countrybean.sqlNvl("glide","''")+"=''";
			stmt.executeUpdate(sSql);
			// event-based or category_based agutination
			if (nGroupingMode==0)
				aglutinate_categories(countrybean, con);
			else
				aglutinate_events(countrybean, con);
		}
		catch (Exception exAgl)
		{
			System.out.println("[DI9] Exception performing LEC grouping"+exAgl.toString());
			
		}
		finally{
			try {stmt.close();}catch(Exception x){}	
			try {rset.close();}catch(Exception x){}	
		}
		
	}
	
	
	/**
	 * @param args
	 */
	public static void main(String[] args) 
	{
		DICountry countrybean=new DICountry();	
	
	}


}
