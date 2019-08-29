/*
 * Miscelaneous utility methods required by the Mapping component
 */
package org.lared.desinventar.map;
import javax.servlet.*;
import javax.servlet.http.*;
import java.text.SimpleDateFormat;
import java.util.*;
import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.*;
import java.sql.*;

import org.lared.desinventar.util.*;
import org.lared.desinventar.dbase.DBase;
import org.lared.desinventar.system.*;
import org.lared.desinventar.webobject.*;

/**
 * @author Julio
 * 
 * Utility class for mapping component
 *
 */
public class MapUtil 
{
	
	public static int clearRanges(DICountry countrybean)
	{
			int j=0;
			// clears all ranges
			for (j=0; j<10; j++)
				countrybean.asMapRanges[j]=0;
			// determines how may ranges to define (those with colors...)	
			j=0;
			while (countrybean.asMapColors[j]!=null && countrybean.asMapColors[j].length()>1 && j<10)
				j++;
			return j++;
	} 
	
	public static int calculateBestLevel(Connection con, DICountry countrybean)
	{
		int level_map=0;
		// get best level to map.
	    String sSql="select count(*) as nregions from regiones where ap_lista>0 group by nivel";
		int[] nRegionsPerLevel=new int[10];
		try{
			Statement stmt=con.createStatement();
			ResultSet rset=stmt.executeQuery(sSql);
			int i=0;
			while (rset.next())
			    nRegionsPerLevel[i++]=rset.getInt("nregions");

		    int[] nRecsPerLevel=new int[5];
			sSql="select count(*) as nrecs from fichas" ;
			rset=stmt.executeQuery(sSql);
			if (rset.next())
			    nRecsPerLevel[0]=rset.getInt("nrecs");
			sSql="select count(*) as nrecs from fichas where level1 is not null";  // and "+ countrybean.sqlNvl("level1","''")+"<>''" ;
			if (countrybean.dbType==Sys.iAccessDb)
				sSql="select count(*) as nrecs from fichas where "+ countrybean.sqlNvl("level1","''")+"<>''" ;
			rset=stmt.executeQuery(sSql);
			if (rset.next())
			    nRecsPerLevel[1]=rset.getInt("nrecs");
			// starting pointn is level_map=0;
			
			// this should be the usual case, but look is at least 80% of the data is disagregated at level1
			if (nRegionsPerLevel[1]>0 && nRecsPerLevel[0]>0 && nRecsPerLevel[1]/(float)nRecsPerLevel[0]>0.8)
				{
				level_map=1;
				// If there is a level2 map, look is at least 80% of the data is disagregated
				sSql="select count(*) as nrecs from fichas where level2 is not null"; // and "+ countrybean.sqlNvl("level2","''")+"<>''" ;
				if (countrybean.dbType==Sys.iAccessDb)
					sSql="select count(*) as nrecs from fichas where "+ countrybean.sqlNvl("level2","''")+"<>''" ;
				rset=stmt.executeQuery(sSql);
				if (rset.next())
					{
					nRecsPerLevel[2]=rset.getInt("nrecs");
					if (nRegionsPerLevel[2]>nRegionsPerLevel[1] && nRecsPerLevel[2]/(float)nRecsPerLevel[1]>0.8)
						level_map=2;
					}
				}
			rset.close();
			stmt.close();
			}
		catch (Exception e)
			{
			System.out.println("[DI9] Error calculating best mapping level"+e.toString());
			}
		return level_map;
	}
	
	public static void calculateRanges(String sRangeType, Connection con, DICountry countrybean)
	{
		ResultSet rset;
		ArrayList<String> sqlparams=new ArrayList<String>();
		PreparedStatement pstmt=null;

		double m=1;
		String grouper="level1";
		String sSql="";
		double dMax=0;
		double dMin=0;
		if (countrybean.level_map==2)
		 grouper = "level2";
		else if (countrybean.level_map==1)
		 grouper = "level1";
		else
		 grouper = "level0";
	    String sVar = "sum(0.0+"+countrybean.sReplaceFormula(countrybean.sExtractVariable(countrybean.asVariables[0]));
	    for (int k = 1; k < countrybean.asVariables.length; k++)
	      sVar += ")+sum(0.0+" + countrybean.sReplaceFormula(countrybean.sExtractVariable(countrybean.asVariables[k]));
	    sVar+=")";
		sSql = "Select " + sVar + " as n_sum," + grouper + " as grouper ";
//		 review this!!!:
//		 sSql += countrybean.getWhereSql(sqlparams) + " and "+countrybean.sqlNvl(grouper,"''")+ "<>'' group by " + grouper;
//		 sSql += countrybean.getWhereSql(sqlparams) + " and "+grouper+" is not null and "+grouper+"<>'' group by " + grouper;
// 		 sSql += countrybean.getWhereSql(sqlparams) + " and coalesce("+grouper+",'')<>'' group by " + grouper;
		 sSql += countrybean.getWhereSql(sqlparams) + " and "+grouper+" is not null group by " + grouper;
		//System.out.println("<!-- "+sSql+" -->");
		try{
			if (sRangeType.equalsIgnoreCase("equlegend"))
			{
		    sSql="select min(n_sum) as mini_mum, max(n_sum) as maxi_mum from ("+sSql+") t";
			// debug:
			try
		      {
				pstmt=con.prepareStatement(sSql);
				for (int k=0; k<sqlparams.size(); k++)
							pstmt.setString(k+1, (String)sqlparams.get(k));
				rset=pstmt.executeQuery();
		        if (rset.next())
		        {
				dMin=rset.getDouble("mini_mum");
				dMax=rset.getDouble("maxi_mum");
				int j=MapUtil.clearRanges(countrybean);		
				if (j<3) j=3;
				for (int k=1; k<j; k++)
					countrybean.asMapRanges[k-1]=Math.round(dMin+(dMax-dMin)/j*k);		
		        }
			   rset.close();
			   pstmt.close();	
		      }
		    catch (Exception e2)
		    	{
		      	System.out.println("[DI9] Exception calculating EQU-freqs data: " + e2.toString()+" ==> "+sSql);
		    	}
			}
		else
		 if (sRangeType.equalsIgnoreCase("isolegend"))
			{
		    // debug:
			try
		      {
				pstmt=con.prepareStatement("select count(*) as cnt from ("+sSql+") t");
				for (int k=0; k<sqlparams.size(); k++)
							pstmt.setString(k+1, (String)sqlparams.get(k));
				rset=pstmt.executeQuery();

		        if (rset.next())
		        {
				int count=rset.getInt("cnt");
				int j=clearRanges(countrybean);
				if (j<2) j=2;
				// number of elements per bucket
				int bucket=(int) ((double)count/j+0.5);
				pstmt=con.prepareStatement("select * from ("+sSql+") t order by t.n_sum");
				for (int k=0; k<sqlparams.size(); k++)
							pstmt.setString(k+1, (String)sqlparams.get(k));
				rset=pstmt.executeQuery();
				
				int k=0;// bucket counter;
				int r=0; // current range
				double lastRange=-999999999.0;
				int nOverflow=0;
				double thisSum=0;
				while (rset.next())
					{
					thisSum=rset.getDouble("n_sum");
					if (++k>=bucket)
					   if (thisSum!=lastRange && thisSum!=0 )
					  	{
						if (r<j-1)
							countrybean.asMapRanges[r]=thisSum;
						r++;
						k=nOverflow;
						nOverflow=0;
						lastRange=thisSum;
						}
					 else
					    {
						nOverflow++;
						}	
					}
				if (lastRange<thisSum/15) // we have a very large event at the end of the category
					countrybean.asMapRanges[r]=thisSum;
		        }
			   rset.close();
			   pstmt.close();	
		      }
		    catch (Exception e2)
		    	{
		      	System.out.println("[DI9] Exception calculating eqi-freqs data: " + e2.toString()+" ==> "+sSql);
		    	}
			}
		else
		 if (sRangeType.equalsIgnoreCase("loglegend"))
			{
		    sSql="select min(n_sum) as mini_mum, max(n_sum) as maxi_mum from ("+sSql+") t";
			// debug:
			try
		      {
				pstmt=con.prepareStatement(sSql);
				for (int k=0; k<sqlparams.size(); k++)
							pstmt.setString(k+1, (String)sqlparams.get(k));
				rset=pstmt.executeQuery();
		        if (rset.next())
		        {
				dMin=rset.getDouble("mini_mum");
				dMax=rset.getDouble("maxi_mum");
				int j=clearRanges(countrybean);
				if (j<3) j=3;
				double dBaseLog=Math.log(dMax-dMin);
				for (int k=1; k<j; k++)
					countrybean.asMapRanges[k-1]=Math.round(dMin+Math.exp(dBaseLog*k/j));								
		        }
			   rset.close();
			   pstmt.close();	
		      }
		    catch (Exception e2)
		    	{
		      	System.out.println("[DI9] Exception calculating iso-freqs data: " + e2.toString()+" ==> "+sSql);
		    	}
			}
			
		}
		catch (Exception e)
		{
			System.out.println("[DI9] Error calculating ranges: "+e.toString());
		}

	}
	
	//	 validates all Level1 and Level2 elements correspond to a selected Level0 element
	public static void validateSelected(Connection con, DICountry countrybean)
    {
	    if (countrybean.asNivel0==null || countrybean.asNivel0.length<1)
	    {
	    	countrybean.asNivel1=null;
	    	countrybean.bHayNivel1=false;
	    	countrybean.asNivel2=null;
	    	countrybean.bHayNivel2=false;
	        return;
	    }
	    if (countrybean.asNivel1==null || countrybean.asNivel1.length<1)
	    {
	    	countrybean.asNivel2=null;
	    	countrybean.bHayNivel2=false;
	        return;
	    }
		
		try
			{
			//Database Connection Object
			Statement stmt=null; // SQL statement object
		  	stmt=con.createStatement();
		  	// validate Level1 elements
		  	String sSelected="";
		  	String sLevel0="";
			String sComma="";
            for (int j = 0; j < countrybean.asNivel0.length; j++)
	          {
            	sLevel0 += sComma+ htmlServer.check_quotes(countrybean.asNivel0[j]);
            	sComma = "','";
	          }
			sComma="";
			int j = 0;
			for (; j < countrybean.asNivel1.length; j++)
	          {
				sSelected += sComma+ htmlServer.check_quotes(countrybean.asNivel1[j]);
				sComma = "','";
	          }
			ResultSet rset=stmt.executeQuery("select count(*) as ncodes from lev1 where lev1_cod in ('"+ sSelected+"') and lev1_lev0 in ('"+sLevel0+"')");
			rset.next(); // aggregate always return set
			int nCodes=rset.getInt(1);
			if (nCodes==0)
				{
		    	countrybean.asNivel1=null;
		    	countrybean.bHayNivel1=false;
		    	countrybean.asNivel2=null;
		    	countrybean.bHayNivel2=false;
		        return;				
				}
			else
			{
				countrybean.asNivel1=new String[nCodes];
				rset=stmt.executeQuery("select lev1_cod from lev1 where lev1_cod in ('"+ sSelected+"') and lev1_lev0 in ('"+sLevel0+"')");
				j = 0;
			  	sSelected="";
			  	sLevel0="";
				sComma="";
				// reloads the vector of selected
				while (rset.next())
			  		{
					countrybean.asNivel1[j]=rset.getString(1);
	            	sLevel0 += sComma+ htmlServer.check_quotes(countrybean.asNivel1[j]);
	            	sComma = "','";
	            	j++;
			  		}
			  	// validate Level2 elements
				if (countrybean.asNivel2!=null && countrybean.asNivel2.length>0)
				{
		            sComma="";
					j = 0;
					for (; j < countrybean.asNivel2.length; j++)
			          {
						sSelected += sComma+ htmlServer.check_quotes(countrybean.asNivel2[j]);
						sComma = "','";
			          }
					rset=stmt.executeQuery("select count(*) as ncodes from lev2 where lev2_cod in ('"+ sSelected+"') and lev2_lev1 in ('"+sLevel0+"')");
					rset.next(); // aggregate always return set
					nCodes=rset.getInt(1);
					if (nCodes==0)
						{
				    	countrybean.asNivel2=null;
				    	countrybean.bHayNivel2=false;
				        return;				
						}
					else
					{
						countrybean.asNivel2=new String[nCodes];
						rset=stmt.executeQuery("select lev2_cod from lev2 where lev2_cod in ('"+ sSelected+"') and lev2_lev1 in ('"+sLevel0+"')");
						j = 0;
						while (rset.next())
					  		{
							countrybean.asNivel2[j++]=rset.getString(1);
					  		}						
					}
					
				}
				
			}
			
			
			}
	  	catch (Exception e)
	  		{
	  		}
    	
    }

	
	
	public void regenerateRegions(Connection con, String sRealPath, DICountry countrybean)
	{
		//Database Connection Objects
		Statement stmt=null; // SQL statement object
		try
			{
		  	stmt=con.createStatement();
			stmt.executeUpdate("update  regiones set ap_lista=0");
			}
	  	catch (Exception e)
	  		{
	  		}
	  	finally
	  	{
	  		try
	  		{
	  			stmt.close();
	  		}
	  		catch (Exception clo)
	  		{
	  			// do nothing
	  		}
	  	}
	  	// now regenerate the regions with a DI map file if available 
	  	checkRegions(con, sRealPath, countrybean.country);
	   	int nTransf=0;
	    if (countrybean.lmMaps[0]!=null) // default DI map with scaling by 10000 transformation... TODO: check transf type
  			  nTransf=countrybean.extendedParseInt(countrybean.lmMaps[0].filetype);
	  	if (nTransf==1)
	  		generateRegionsFromShapeFile(con, countrybean);
	  	else
	  		generateRegionsFromDI(con, sRealPath, countrybean.country);
	}


	public void generateRegionsFromShapeFile(Connection con, DICountry countrybean)
	{

	    // now it should read the names of the levels. 
	   	countrybean.getLevelsFromDB(con);
  	    for (int level_act=0; level_act<3; level_act++)
  	    {
  		   	int nTransf=0;
  		    if (countrybean.lmMaps[level_act]!=null) // default DI map with scaling by 10000 transformation... TODO: check transf type
  			  nTransf=countrybean.extendedParseInt(countrybean.lmMaps[level_act].filetype);
  			if (nTransf==1)
  		    {
  		    	// this is a shapefile, get all regions and import!
 		    	String sShapefileName=countrybean.not_null(countrybean.lmMaps[level_act].filename);
  		    	String sCodeField=countrybean.not_null(countrybean.lmMaps[level_act].lev_code);
  		    	String sNameField=countrybean.not_null(countrybean.lmMaps[level_act].lev_name);
  		    	String sNameEnField=sNameField;

  		    	File f=new File(sShapefileName);
  		    	if (f.exists() && f.isFile())
  		    	{
   	  			   try{
	  	  	   		 	// forces a reload of all layers and then builds the region table from it.
	  		    		WebMapService wms=WebMapService.getInstance();
	  	  	   		 	wms.removeLayer(sShapefileName);
	  	  	   		 	wms.addLayer(sShapefileName);
	  	  	   		 	wms.setlayerCode(countrybean.lmMaps[level_act].filename,   sCodeField, sNameField,  sNameEnField);
	  	  	   		    wms.setConnection(countrybean.lmMaps[level_act].filename,   con );
	  	  	   		 	wms.setlayerLevel(countrybean.lmMaps[level_act].filename,   level_act );
	  	  	   		 	Color cColor= Color.black; // something easy..
	  	  	   		 	
	  	  	   		 	BufferedImage buffImage= new BufferedImage(10, 10, BufferedImage.TYPE_INT_ARGB); //TYPE_INT_BGR); // TYPE_3BYTE_BGR); //TYPE_INT_RGB);
	  	  	   		 	// Create a graphics object from the image
	  	  	   		 	Graphics2D graphics = (Graphics2D) buffImage.getGraphics();
	
	  	  	   		 	graphics.setStroke(new BasicStroke(1.0f));
	  	  	   		 	wms.renderLayer(sShapefileName, new MapTransformation(), graphics, 10, 10, cColor, countrybean, null);

  						String sSql="update regiones set codregion=?,nombre=?, nombre_en=?, x=?,y=?,angulo=?,"+countrybean.sqlXmin()+"=?,ymin=?,"+countrybean.sqlXmax()+"=?,ymax=?,xtext=?,ytext=?,nivel=?,ap_lista=?,lev0_cod=? where codregion=?";
  						PreparedStatement update_stmt= con.prepareStatement(sSql);

  						sSql="insert into regiones (codregion,nombre, nombre_en, x,y,angulo,"+countrybean.sqlXmin()+",ymin,"+countrybean.sqlXmax()+",ymax,xtext,ytext,nivel,ap_lista,lev0_cod) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
  						PreparedStatement insert_stmt= con.prepareStatement(sSql);
  						
  						sSql="select codregion from regiones where codregion=?";
  						PreparedStatement read_stmt= con.prepareStatement(sSql);

  						MapObject moShape=wms.getlayerMapObject(sShapefileName);
  					    // the map has previously been used, first call triggered a full scan of the file, loading the index and polygons into memory
  					    for (int j=0; j<moShape.lArcs.size(); j++)
  					    {
  						   ArcObject arco=(ArcObject)(moShape.lArcs.get(j));
  						   //if (!(arco.xmax<xm || arco.ymax<ym || arco.xmin>xx || arco.ymin>yy))

  						    regiones Region=new regiones();
  				    		Region.nivel=level_act;
  				    		Region.codregion=arco.sCode;
  				    		Region.nombre=arco.sName;
  				    		if (Region.nombre.length()>30)
  				    			Region.nombre=Region.nombre.substring(0,30);
  				    		Region.nombre_en=arco.sName_en;
  				    		Region.xmin=arco.xmin;
  				    		Region.xmax=arco.xmax;
  				    		Region.ymin=arco.ymin;
  				    		Region.ymax=arco.ymax;
  				    		Region.x=(Region.xmin+Region.xmax)/2;
  				    		Region.xtext=Region.x;
  				    		Region.y=(Region.ymin+Region.ymax)/2;
  				    		Region.ytext=Region.y;
  				    		Region.ap_lista=j+1;  				    		
  				    		if (Region.codregion.length()>0)
  				    		{
  	  				    		if (level_act>0) // this is good for new databases with consistent codes 001112222.
  	  				    			Region.lev0_cod=arco.sCode.substring(0,Math.min(arco.sCode.length(),countrybean.anLevelsLen[level_act-1]));
  	  				    		verifyRegion(con, Region);
  	 							
  	  				    		read_stmt.setString(1,Region.codregion);
  	  				    		ResultSet rset=read_stmt.executeQuery();
  	  				    		if (rset.next())
  	  				    			executeRegionStatement(update_stmt, Region, true);
  	  				    		else
  	  				    			executeRegionStatement(insert_stmt, Region, false);
  	  	  			  			try {rset.close();} catch (Exception e){}  				    			
  				    		}
  				    			    
  				    	}
  						update_stmt = syncronizeRegionsLevels(con, countrybean.country, update_stmt);
  			  			try {read_stmt.close();} catch (Exception e){}
  			  			try {update_stmt.close();} catch (Exception e){}
  			  			try {insert_stmt.close();} catch (Exception e){}
  					    
  	  			   	  }
  		  		   catch (Exception e)
  		  			  {
  		  				  System.out.println("[DI9] Error Loading Reg/reg DBASE:"+e.toString());
  		  			  }
  		    	}
	    	}
  	    }
	  }

	public void generateRegionsFromDI(Connection con, String sRealPath, country Country)
	{
		  //Database Connection Objects
		  int nSqlRet = 0; // return from update SQL
		  String sSql; // string holding SQL statement
		  Statement stmt=null; // SQL statement object
		  PreparedStatement update_stmt=null; // SQL statement object
		  ResultSet rset = null; // SQL resultset
		  regiones Region=new regiones();
		  Country.dbType=Country.ndbtype;
		  Region.dbType=Country.ndbtype;
		  try
		  {

	  		// table and PK are created, now transfer regions, ACCESS mode
	  		// a) create an ODBC connection to the map database
			String sBasePath= Country.sjetfilename;
			if (!sBasePath.endsWith("/"))
				sBasePath+="/";
			sBasePath=getMapFileName(sBasePath,Country.scountryid,"pmap.mdb");
			// only for windows. The path to ODBC manager
			// attempt to open the resulting database
			boolean bConnectionOK=false; 
			//	opens the database 
			pooledConnection dbTestConnection=new pooledConnection(Sys.sAccess64Driver, Sys.sAccess64DefaultString+sBasePath+";", null,null);

			bConnectionOK = dbTestConnection.getConnection();
			if (bConnectionOK)
				{	
				Connection regioncon=dbTestConnection.connection;
				stmt=regioncon.createStatement();
				rset=stmt.executeQuery("select * from regiones");

				sSql="update regiones set codregion=?,nombre=?, nombre_en=?, x=?,y=?,angulo=?,"+Country.sqlXmin()+"=?,ymin=?,"+Country.sqlXmax()+"=?,ymax=?,xtext=?,ytext=?,nivel=?,ap_lista=?,lev0_cod=? where codregion=?";
				update_stmt= con.prepareStatement(sSql);

				sSql="insert into regiones (codregion,nombre, nombre_en, x,y,angulo,"+Country.sqlXmin()+",ymin,"+Country.sqlXmax()+",ymax,xtext,ytext,nivel,ap_lista,lev0_cod) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
				PreparedStatement insert_stmt= con.prepareStatement(sSql);
				
				sSql="select codregion from regiones where codregion=?";
				PreparedStatement read_stmt= con.prepareStatement(sSql);

				Region.dbType=Sys.iAccessDb;// !!! always access!!   Country.ndbtype;
				while (rset.next())
					{
					// caution: this could crash the order of reading?...
					Region.loadWebObject(rset);
					int nLevel = Region.nivel;							
					verifyRegion(con, Region);

		    		read_stmt.setString(1,Region.codregion);
		    		ResultSet rrset=read_stmt.executeQuery();
		    		if (rrset.next())
			    			executeRegionStatement(update_stmt, Region, true);
			    		else
			    			executeRegionStatement(insert_stmt, Region, false);
					}
				update_stmt = syncronizeRegionsLevels(con, Country, update_stmt);
				
				}
  			try {rset.close();} catch (Exception e){}
  			try {stmt.close();} catch (Exception e){}
  			try {dbTestConnection.connection.close();} catch (Exception e){}
  			}
        catch (Exception e2)
        	{
        	System.out.println("[DI9] Error loading region table from DI format: " + e2.toString());
        	}
  	    finally
	  	{
	  		try
	  		{
	  			stmt.close();
	  			if (update_stmt!=null)
	  				update_stmt.close();		  		
	  		}
	  		catch (Exception clo)
	  		{
	  			// do nothing
	  			// System.out.println(clo.toString());
	  		}
	  	}
	}



	/**
	 * @param update_stmt
	 * @param Region
	 * @throws SQLException
	 */
	private void executeRegionStatement(PreparedStatement update_stmt, regiones Region, boolean b16) throws SQLException 
	{
		if (Region.nombre.length()>30)
			Region.nombre=Region.nombre.substring(0,30);
		if (Region.nombre_en.length()>30)
			Region.nombre_en=Region.nombre_en.substring(0,30);
		update_stmt.setString(1,Region.codregion);
		update_stmt.setString(2,Region.nombre);
		update_stmt.setString(3,Region.nombre_en);
		update_stmt.setDouble(4,Region.x);
		update_stmt.setDouble(5,Region.y);
		update_stmt.setDouble(6, Region.angulo);
		update_stmt.setDouble(7,Region.xmin);
		update_stmt.setDouble(8,Region.ymin);
		update_stmt.setDouble(9,Region.xmax);
		update_stmt.setDouble(10,Region.ymax);
		update_stmt.setDouble(11,Region.xtext);
		update_stmt.setDouble(12,Region.ytext);
		update_stmt.setInt(13,Region.nivel);
		update_stmt.setInt(14,Region.ap_lista);
		update_stmt.setString(15,Region.lev0_cod);
		if (b16)
			update_stmt.setString(16,Region.codregion);
  		try
			{
			update_stmt.executeUpdate();
			}
		catch (Exception upd)
			{
			System.out.println("[DI9] Error transferring region table [in executeRegionStatement]: " + upd.toString());								
			}
	}
	
	
	
	 /**
	  * searches for a suitable file name. resolves the issues with upper and lower cases in 
	  * windows/unix filenames and is fault-tolerant with the code: if no file with the specific
	  * code is found, it will return a file which ends with the suffix
	  * 
	  * @param sBasePath  folder to seaarch
	  * @param sCode   country code
	  * @param suffix  suffix (file type - arco.dat, etc...)
	  * @return the file found
	  */
	  public String getMapFileName(String sBasePath, String sCode, String suffix)
	  {
	  	File fDir=new File(sBasePath);
	  	String[] filename= fDir.list();
	  	String sName="";
	  	sCode=sCode.toLowerCase();
	  	String sIdealName=sCode+suffix;
	  	for (int j=0; j<filename.length && sName.length()==0; j++)
		    {
			if (filename[j].toLowerCase().equals(sIdealName))
				sName=filename[j];
			}			
	  	for (int j=0; j<filename.length && sName.length()==0; j++)
		    {
			if (filename[j].toLowerCase().endsWith(suffix))
				sName=filename[j];
			}
	   return sBasePath+ (sName.length()==0?sIdealName:sName);
	  }
	  

	
	public void checkRegions(Connection con, String sRealPath, country Country)
	{
		  //Database Connection Objects
		  int nSqlRet = 0; // return from update SQL
		  String sSql; // string holding SQL statement
		  Statement stmt=null; // SQL statement object
		  PreparedStatement update_stmt=null; // SQL statement object
		  ResultSet rset = null; // SQL resultset
		  regiones Region=new regiones();
		  Country.dbType=Country.ndbtype;
		  Region.dbType=Country.ndbtype;
		  try
		  {
		  	stmt=con.createStatement();
		  	// determines if the regions table exist..
		  	boolean bRegionsExist=false;
		  	boolean bTablesExist=false;
			try
				{
			      rset=stmt.executeQuery("select * from regiones where nivel=0");
			      bTablesExist=true;
			      if (rset.next())
			    	  bRegionsExist=true;
			      rset.close();
				}
		  	catch (Exception e)
		  		{
		  		}
	  		// table doesn't exist. create it:  (this can ONLY happen with OLD Access Databases. SQL is ACCESS -dependant
	  		// other DB platforms ensure the database is properly created with all tables and fields
	  		if (!bTablesExist)
	  			{
	  			try{
	  				stmt.executeUpdate("create table regiones (codregion   Text(15),nombre  Text(30), nombre_en  Text(30), x   double,y   double,angulo double,xmin    double,ymin    double,xmax    double,ymax    double,xtext   double,ytext   double,nivel   integer,ap_lista    Long,lev0_cod Text(15))");
			  		stmt.executeUpdate("alter table regiones add constraint REGIONPK primary key (codregion)");
	  				}
		        catch (Exception e2)
	        		{
		        	System.out.println("[DI9] Error creating Region table in MS Access!!!: " + e2.toString());
	        		}
	  			}
            // on new databases, this may be neeeded..
		  	if (!bRegionsExist)
		  	{
		  		generateRegionsFromDI(con, sRealPath, Country);		  	
		  	}
		  }
	      catch (Exception e)
	      {
	        System.out.println("[DI9] Error creating  region table: " + e.toString());
	      }
	  	finally
		  	{
		  		try
		  		{
		  			stmt.close();
		  			if (update_stmt!=null)
		  				update_stmt.close();		  		
		  		}
		  		catch (Exception clo)
		  		{
		  			// do nothing..	System.out.println(clo.toString());
		  		}
		  	}
	}


	/**
	 * @param con
	 * @param Country
	 * @param update_stmt
	 * @return
	 */
	private PreparedStatement syncronizeRegionsLevels(Connection con, country Country, PreparedStatement update_stmt) {
		try
		{
		if (Country.ndbtype==1 && !Country.sdriver.equals(Sys.sAccess64Driver))  // access engine is picky with these updates
			{
			update_stmt= con.prepareStatement("update  regiones,lev0 set nombre=IIf(IsNull(lev0_name),nombre,lev0_name) where lev0.lev0_cod=codregion and nivel=0");
			update_stmt.executeUpdate();
			update_stmt= con.prepareStatement("update regiones,lev1 set nombre=IIf(IsNull(lev1_name),nombre,lev1_name) where lev1.lev1_cod=codregion and nivel=1");
			update_stmt.executeUpdate();
			update_stmt= con.prepareStatement("update regiones,lev2 set nombre=IIf(IsNull(lev2_name),nombre,lev2_name) where lev2.lev2_cod=codregion and nivel=2");
			update_stmt.executeUpdate();
			}
		else
			{
			update_stmt= con.prepareStatement("update regiones set nombre=coalesce((select lev0_name from lev0 l0 where l0.lev0_cod=codregion),nombre) where nivel=0");
			update_stmt.executeUpdate();
			update_stmt= con.prepareStatement("update regiones set nombre=coalesce((select lev1_name from lev1 l0 where l0.lev1_cod=codregion),nombre) where nivel=1");
			update_stmt.executeUpdate();
			update_stmt= con.prepareStatement("update regiones set nombre=coalesce((select lev2_name from lev2 l0 where l0.lev2_cod=codregion),nombre) where nivel=2");
			update_stmt.executeUpdate();
			}
		}
catch (Exception upd)
		{
		System.out.println("[DI9] Error transferring region table [syncronizeRegionsLevels]: " + upd.toString());								
		}
		return update_stmt;
	}


	/**
	 * @param con
	 * @param Region
	 * @return
	 */
	private int verifyRegion(Connection con, regiones Region) {
		lev0 Level0= new lev0();
		lev1 Level1= new lev1();
		lev2 Level2= new lev2();
		int nLevel=Region.nivel;
		int nRows=0;
		switch(nLevel)
		{
		case 0:
			Level0.lev0_cod=Region.codregion;
			nRows=Level0.getWebObject(con);
			if (nRows==0)
			{
				Level0.lev0_name=Region.nombre;
				Level0.lev0_name_en=Region.nombre_en;
				Level0.addWebObject(con);
			}
			else
				if (Level0.lev0_name.length()==0)
				{
					Level0.lev0_name=Region.nombre;
					Level0.lev0_name_en=Region.nombre_en;
					Level0.updateWebObject(con);
				}
			break;
		case 1:
			Level1.lev1_cod=Region.codregion;
			nRows=Level1.getWebObject(con);
			if (nRows==0)
			{
				Level1.lev1_name=Region.nombre;
				Level1.lev1_name_en=Region.nombre_en;
				Level1.lev1_lev0=Region.lev0_cod;
				Level1.addWebObject(con);
			}
			else
				if (Level1.lev1_name.length()==0)
				{
					Level1.lev1_name=Region.nombre;
					Level1.lev1_name_en=Region.nombre_en;
					Level1.updateWebObject(con);
				}
			// this guarantees consistency - and does not rely on the assumption of hierarchical key. 0011222
			Region.lev0_cod=Level1.lev1_lev0;
			break;
		case 2:
			Level2.lev2_cod=Region.codregion;
			nRows=Level2.getWebObject(con);
			if (nRows==0)
			{
				Level2.lev2_name=Region.nombre;
				Level2.lev2_name_en=Region.nombre_en;
				Level2.lev2_lev1=Region.lev0_cod;
				Level2.addWebObject(con);
			}
			else
				if (Level2.lev2_name.length()==0)
				{
					Level2.lev2_name=Region.nombre;
					Level2.lev2_name_en=Region.nombre_en;
					Level2.updateWebObject(con);
				}
			Region.lev0_cod=Level2.lev2_lev1;
			break;
		}
		return nLevel;
	}
	
	
	/**
	 * @param level
	 * @param code
	 */
	public static void getExtents(int level, String code, MapTransformation mt, Connection con, DICountry countrybean) 
	{
		String sCode="";
		if (code.length() > 0)
			 sCode="('"+code+"')";
		getActualExtents(level,sCode, mt, con, countrybean);
	}

	public static void getExtents(int level, String[] asSelected, MapTransformation mt, Connection con, DICountry countrybean) 
	{
	      String code = "";
	      if (asSelected != null)
	      {
	        String sComma = "(";
	        int j = 0;
	        for (j = 0; j < asSelected.length; j++)
	        {
	          code += sComma + "'" + asSelected[j] + "'";
	          sComma = ",";
	        }
	        if (j > 0)
	          code += ")";
	      }

		getActualExtents(level, code, mt, con, countrybean);
	}

	
	public static void getActualExtents(int level, String code, MapTransformation mt, Connection con, DICountry countrybean) 
		{
		Statement stmt = null;
	    ResultSet rset=null;
	    try
	    {
	      // System.out.println("[DI9] Plotting level " + level + " code (" + code + ")");
	      stmt=con.createStatement();
	      String sSql = "";
	      switch (level)
	      {
	      case 0:
	    	  sSql=" from regiones r,lev0 l where r.codregion=l.lev0_cod  ";
	    	  break;
	      case 1:
	    	  sSql=" from regiones r,lev1 l where r.codregion=l.lev1_cod  ";
	    	  break;
	      case 2:
	    	  sSql=" from regiones r,lev2 l where r.codregion=l.lev2_cod  ";
	    	  break;
	      }
	      sSql+=" and nivel=" + level;
	      if (code.length() > 0)
	      	sSql += " and (r.codregion in " + code+ " or r.lev0_cod in " + code+")";
	      // System.out.println("[DI9] Getting map extents with sql= select max(xmax) as x_max, max(ymax) as y_max, min(xmin) as x_min, min(ymin) as y_min  " + sSql);
	      rset = stmt.executeQuery("select max("+countrybean.sqlXmax()+") as x_max, max(ymax) as y_max, min("+countrybean.sqlXmin()+") as x_min, min(ymin) as y_min  " + sSql);

	      if (rset.next())
	      {
	        mt.xminif = rset.getDouble("x_min");
	        mt.yminif = rset.getDouble("y_min");
	        mt.xmaxif = rset.getDouble("x_max");
	        mt.ymaxif = rset.getDouble("y_max");
	      }

	   
	    }
	    catch (Exception e)
	    {
	      System.out.println("[DI9] Exception getting extents: " + e.toString());
	    }
	    finally
	    {
	    	try{
	    		if (rset!=null) rset.close();
	    		if (stmt!=null) stmt.close();
	    	}
	    	catch (Exception e)
	    	{
	   
	    	}
	    }
	}

	public void generateDBaseRegions(Connection con, DICountry countrybean, String sRealPath)
	{
	    try
	    {
	    // copies the regiones.dbf template to the maps folder
	    String sSourcePath=sRealPath+"/regiones.dbf";
	    String sBasePath=countrybean.country.sjetfilename+"/regiones.dbf";
	    FileCopy.copy(sSourcePath,sBasePath);

	    // now transfer the records
	    String sSql = "insert into regiones (";
	    String sSqlVars= "codregion, nombre, nombre_en, x, y, angulo, xmin, ymin, xmax, ymax, xtext, ytext, nivel, ap_lista, lev0_cod";
		sSql += sSqlVars+ ") VALUES ("; // ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

		Statement stmt=con.createStatement();
		ResultSet rset=stmt.executeQuery("select "+sSqlVars+" from regiones");
	    	
		// Using a DBASE IV memo file.
		DBase db = new DBase(countrybean.country.sjetfilename);
		db.setMemoHandler(DBase.DBASEIII);
		
		//db.exec("delete from regiones");
		
		while (rset.next())
			{
			// create regiones.mdb
			String sDBaseSql=sSql+"'"+rset.getString("codregion")+"',"
					+"'"+countrybean.not_null(rset.getString("nombre"))+"',"
					+"'"+countrybean.not_null(rset.getString("nombre_en"))+"',"
					+rset.getDouble("x")+","
					+rset.getDouble("y")+","
					+rset.getDouble("angulo")+","
					+rset.getDouble("xmin")+","
					+rset.getDouble("ymin")+","
					+rset.getDouble("xmax")+","
					+rset.getDouble("ymax")+","
					+rset.getDouble("xtext")+","
					+rset.getDouble("ytext")+","
					+rset.getInt("nivel")+","
					+rset.getInt("ap_lista")+","
					+"'"+countrybean.not_null(rset.getString("lev0_cod"))+"')";
				db.exec(sDBaseSql);
			}
		db.closeTable();
		rset.close();
		stmt.close();
		}
    	catch (Exception e)
    	{
    		System.out.println("[DI9] Error converting regions to dbase: "+e.toString());
    	}

		
	}
	
	
	/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	/*::                                                                         :*/
	/*::  This routine calculates the distance between two points (given the     :*/
	/*::  latitude/longitude of those points). It is being used to calculate     :*/
	/*::  the distance between two ZIP Codes or Postal Codes using our           :*/
	/*::  ZIPCodeWorld(TM) and PostalCodeWorld(TM) products.                     :*/
	/*::                                                                         :*/
	/*::  Definitions:                                                           :*/
	/*::    South latitudes are negative, east longitudes are positive           :*/
	/*::                                                                         :*/
	/*::  Passed to function:                                                    :*/
	/*::    lat1, lon1 = Latitude and Longitude of point 1 (in decimal degrees)  :*/
	/*::    lat2, lon2 = Latitude and Longitude of point 2 (in decimal degrees)  :*/
	/*::    unit = the unit you desire for results                               :*/
	/*::           where: 'M' is statute miles                                   :*/
	/*::                  'K' is kilometers (default)                            :*/
	/*::                  'N' is nautical miles                                  :*/
	/*::  Hexa Software Development Center © All Rights Reserved 2004            :*/
	/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

	private double distance(double lat1, double lon1, double lat2, double lon2, char unit) 
	{
	  double theta = lon1 - lon2;
	  double dist = Math.sin(deg2rad(lat1)) * Math.sin(deg2rad(lat2)) + Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * Math.cos(deg2rad(theta));
	  dist = Math.acos(dist);
	  dist = rad2deg(dist);
	  dist = dist * 60 * 1.1515;
	  if (unit == 'K') {
	    dist = dist * 1.609344;
	  } else if (unit == 'N') {
	  	dist = dist * 0.8684;
	    }
	  return (dist);
	}

	/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	/*::  This function converts decimal degrees to radians             :*/
	/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	private double deg2rad(double deg) {
	  return (deg * Math.PI / 180.0);
	}

	/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	/*::  This function converts radians to decimal degrees             :*/
	/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	private double rad2deg(double rad) {
	  return (rad * 180.0 / Math.PI);
	}



}
