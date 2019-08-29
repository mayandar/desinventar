package org.lared.desinventar.map;
import java.io.*;
import java.sql.*;
import java.util.*;

import javax.servlet.*;

import java.awt.*;
import java.awt.image.*;

import org.lared.desinventar.util.*;
import org.lared.desinventar.webobject.*;


/**
 * WebMapService is a singleton that serves map tiles from ArcInfo ShapeFiles (initially)
 * @author julio.serje
 *
 */
public class WebMapService
{
    private WebMapService()
    {
    // private singleton constructor
    }
	private static HashMap<String,MapObject> htLayers=new HashMap<String,MapObject>();
    private static WebMapService theInstance=new WebMapService();
	
	
	public static WebMapService getInstance()
	{
	return theInstance;	
	}
	

 	public static boolean existLayer(String sShapeFile)
	{
		boolean bSuccess=false;
		if (htLayers.get(sShapeFile)!=null)
			bSuccess=true;		
		return bSuccess;
	}
 	
 	public static boolean addLayer(String sShapeFile)
	{
		boolean bSuccess=false;
		// only if it does not exist in the server
		if (htLayers.get(sShapeFile)!=null){
			bSuccess=true;
		}
		else{
			try{
				
				File f=new File(sShapeFile);
				if (sShapeFile.startsWith("MAP@") || (f.exists()&& f.isFile() && f.canRead()))
				{
					MapObject moShape=new MapObject(sShapeFile);
					htLayers.put(sShapeFile,moShape);
				}
			}
			catch (Exception e)
			{
				System.out.println("DI-WebMapService Error processing layer:"+e.toString());
			}
		}
		if (bSuccess)
			htLayers.get(sShapeFile).nCount++;
		
		return bSuccess;
	}
	
 	
	public static void removeLayer(String sShapeFile)
	{
		htLayers.remove(sShapeFile);
	}

 	
	public static void clearLayers()
	{
		htLayers=new HashMap<String,MapObject>();
	}

	
	
	
/* 
 * renders a cosmetic layer in a shapefile
 */	
	public static void renderLayer(String sShapeFile, MapTransformation m, Graphics2D g2, int xResolution, int yResolution, Color cBorderColor, Color cFillColor, DICountry countrybean, int nShowNames)
	{
		MapObject moShape=htLayers.get(sShapeFile);
		if (moShape!=null)
			moShape.renderMap(g2, xResolution, yResolution,  cBorderColor, cFillColor, countrybean, null,m, nShowNames);
	}
	
	/*
	 * renders a thematic layer
	 */
	public static void renderLayer(String sShapeFile, MapTransformation m, Graphics2D g2, int xResolution, int yResolution, Color cBorderColor, DICountry countrybean,  HashMap htData)
	{
	 //  long lBefore= (new java.util.Date()).getTime();
		MapObject moShape=htLayers.get(sShapeFile);
		if (moShape!=null)
			moShape.renderMap(g2, xResolution, yResolution,  cBorderColor, null, countrybean, htData, m, countrybean.nShowIdType);
	//   long lAfter= (new java.util.Date()).getTime();
	//	if ((lAfter-lBefore)>500)
	//	System.out.println("Time rendering[theme]:"+(lAfter-lBefore));
		
	}
    
	public static void setlayerCode(String sShapeFile, String sCodeField, String sNameField, String sNameEnField)
	{
		MapObject moShape=htLayers.get(sShapeFile);
		if (moShape!=null)
		{
			moShape.SetCodeField(DICountry.not_null(sCodeField));
			moShape.SetNameField(DICountry.not_null(sNameField));
			moShape.SetNameField(DICountry.not_null(sNameEnField));
		}
		
	}

	public static void setlayerLevel(String sShapeFile,int level)
	{
		MapObject moShape=htLayers.get(sShapeFile);
		if (moShape!=null)
		{
			moShape.SetLevel(level);
		}
		
	}

	public static void setConnection(String sShapeFile,Connection con)
	{
		MapObject moShape=htLayers.get(sShapeFile);
		if (moShape!=null)
		{
			moShape.SetConnection(con);
		}
		
	}

	
	public static double getlayerXmin(String sShapeFile)
	{
		double xm=-180;
		MapObject moShape=htLayers.get(sShapeFile);
		if (moShape!=null)
			xm=moShape.xmin;
		return xm;	
	}

	public static double getlayerYmin(String sShapeFile)
	{
		double ym=-85;
		MapObject moShape=htLayers.get(sShapeFile);
		if (moShape!=null)
			ym=moShape.ymin;
		return ym;	
	}

	public static double getlayerXmax(String sShapeFile)
	{
		double xm=180;
		MapObject moShape=htLayers.get(sShapeFile);
		if (moShape!=null)
			xm=moShape.xmax;
		return xm;	
	}

	public static double getlayerYmax(String sShapeFile)
	{
		double ym=85;
		MapObject moShape=htLayers.get(sShapeFile);
		if (moShape!=null)
			ym=moShape.ymax;
		return ym;	
	}

	public static MapObject  getlayerMapObject(String sShapeFile)
	{
		MapObject moShape=htLayers.get(sShapeFile);
		if (moShape==null)
			{
			addLayer(sShapeFile);
			moShape=htLayers.get(sShapeFile);
			}
		return moShape;	
	}

	public static void setlayerMapObject(String sShapeFile, MapObject moShape)
	{
		htLayers.put(sShapeFile, moShape);
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		

	    WebMapService ms = new WebMapService();

	    BufferedImage buffImage = new BufferedImage(600, 600, BufferedImage.TYPE_INT_RGB);
	    // Create a graphics object from the image
	    Graphics2D graphics = (Graphics2D) buffImage.getGraphics();
	    graphics.setColor(Color.white);
	    graphics.fillRect(0, 0, 600, 600);
	    // ms.setShapefile("C:/ESRI/ESRIDATA/indonesia/IDN_ADM2");
	    String sTestShp="C:/ESRI/ESRIDATA/Col2008/col_adm1.shp";
	    
	    //sTestShp="C:/ESRI/ESRIDATA/Mozambique/MOZ_GIS_DATABSE/top250gp.shp";
	    sTestShp="C:/ESRI/ESRIDATA/WORLD/CNTRY94.SHP";
	    
	    
	    ms.addLayer(sTestShp);
	    
	    long lBefore= (new java.util.Date()).getTime();
	    graphics.setColor(Color.black);
	    // plots in black.. loads the map to memory
	    // ms.renderLayer(sTestShp, -81.738677,-4.3,-65,13.0, graphics,  600, 600);
	    // ms.renderLayer(sTestShp, -76.738677,0,-70,4.0, graphics,  600, 600);
	    // ms.renderLayer(sTestShp, -76,6.0,-74,8.0, graphics,  600, 600, Color.black, null);
	    // ms.renderLayer(sTestShp, 30.4, -26.85, 40.9, -10.5, graphics,  600, 600, Color.black, null);
		MapTransformation m=new MapTransformation();

	    ms.renderLayer(sTestShp, m, graphics,  600, 600, Color.black, null, null, 0);

	    
	    long lMidWay= (new java.util.Date()).getTime();
	    // plots in red from memory
	    graphics.setColor(Color.red);
	    ms.renderLayer(sTestShp, m, graphics,  600, 600, Color.black, null, null, 0);

	    long lAfter= (new java.util.Date()).getTime();

		System.out.println("Time loading:"+(lMidWay-lBefore));
		System.out.println("Time in mem rendering:"+(lAfter-lMidWay));
	    
	    try{
	    	//JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(new FileOutputStream("c:/temp/av_indo.jpg"));
	        //JPEGEncodeParam params= encoder.getDefaultJPEGEncodeParam(buffImage);
	        //params.setQuality((float)0.90,false);
	        // Convert the image to JPeg
	        //encoder.encode(buffImage,params);
	    }
	    catch (Exception ioe)
	    {
	    	System.out.println("error:"+ioe.toString());
	    }	
	}

}
