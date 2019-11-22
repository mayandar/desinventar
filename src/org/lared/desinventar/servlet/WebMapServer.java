package org.lared.desinventar.servlet;

/**
 * <p>Title: DesInventar WEB Version 6.1.2 Graph Server</p>
 * <p>Description: Thematic Map generation servlet, for the
 * On-Line Version of DesInventar/DesConsultar 6,7,8,9,19,11,12.</p>
 * <p>Copyright: Copyright (c) 2002  La  Red.</p>
 * <p>Company: La Red -  La Red de Estudios Sociales en Prevención de Desastres en América Latina</p>
 * @author Julio Serje
 * @version 1.0
 */

import java.io.*;
import java.sql.*;
import java.util.*;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

import java.awt.*;
import java.awt.image.*;

import org.lared.desinventar.chart.*;
import org.lared.desinventar.map.*;
import org.lared.desinventar.util.*;
import org.lared.desinventar.webobject.webObject;

import sun.misc.Regexp;

import net.jmge.gif.Gif89Encoder;

import java.util.regex.Pattern;
import java.util.regex.Matcher;




public class WebMapServer
extends GenericServlet
implements chartConstants
{

	final public String sWMSVersion="1.1.1";
	final public String sWMScrs="CRS:84";
	final public String sWMSepsg="EPSG:4326";

	public WebMapServer()
	{
	}

	// methods to work with MS VirtualEarth

	public static final double EARTH_RADIUS = 6378137;
	public static final double EARTH_CIRCUM = EARTH_RADIUS * 2.0 * Math.PI;
	public static final double EARTH_HALF_CIRC = EARTH_CIRCUM / 2;
	public static final int TILE_SIZE = 256;

	public boolean IsReusable()
	{
		return true; 
	}

	/// <summary>
	/// Retrieves a quad key from a Virtual Earth tile specifier URL
	/// </summary>
	/// <param name="url"></param>
	/// <returns></returns>
	public String GetQuadKey(String url)
	{
		Pattern regex =       Pattern.compile(".*tiles/(.+)[.].*");
		Matcher match = regex.matcher(url);
		return match.group();

	}


	public Box QuadKeyToBox(String quadString)
	{
		return QuadKeyToBox(quadString, 0, 262144, 1);
	}

	/// <summary>
	/// Returns the bounding box for a grid square represented by
	/// the given quad key
	/// </summary>
	/// <param name="quadString"></param>
	/// <param name="x"></param>
	/// <param name="y"></param>
	/// <param name="zoomLevel"></param>
	/// <returns></returns>
	public Box QuadKeyToBox(String quadString, int x, int y, int zoomLevel)
	{
		char c = quadString.charAt(0);

		int tileSize = 2 << (18 - zoomLevel - 1);

		if (c == '0')
		{
			y = y - tileSize;
		}

		else if (c == '1')
		{
			y = y - tileSize;
			x = x + tileSize;
		}

		else if (c == '3')
		{
			x = x + tileSize;
		}

		if (quadString.length() > 1)
		{
			return QuadKeyToBox(quadString.substring(1), x, y, zoomLevel + 1);
		}
		else
		{
			return new Box(x, y, tileSize, tileSize);
		}
	}

	/// <summary>
	/// Converts radians to degrees
	/// </summary>
	/// <param name="d"></param>
	/// <returns></returns>
	public double RadToDeg(double d)
	{
		return d / Math.PI * 180.0;
	}

	/// <summary>
	/// Converts a grid row to Latitude
	/// </summary>
	/// <param name="y"></param>
	/// <param name="zoom"></param>
	/// <returns></returns>
	public double YToLatitudeAtZoom(int y, int zoom)
	{
		double arc = EARTH_CIRCUM / ((1 << zoom) * TILE_SIZE);
		double metersY = EARTH_HALF_CIRC - (y * arc);
		double a = Math.exp(metersY * 2 / EARTH_RADIUS);
		double result = RadToDeg(Math.asin((a - 1) / (a + 1)));
		return result;
	}

	/// <summary>
	/// Converts a grid column to Longitude
	/// </summary>
	/// <param name="x"></param>
	/// <param name="zoom"></param>
	/// <returns></returns>
	public double XToLongitudeAtZoom(int x, int zoom)
	{
		double arc = EARTH_CIRCUM / ((1 << zoom) * TILE_SIZE);
		double metersX = (x * arc) - EARTH_HALF_CIRC;
		double result = RadToDeg(metersX / EARTH_RADIUS);
		return result;
	}

	/// <summary>
	/// Processes any *.png inbound web request as sepecified in web.config
	/// </summary>
	/// <param name="context"></param>
	public String getLiveEarthBBox(ServletRequest request)
	{
		// Extract the QuadKey from the URL
		String urlString = ((HttpServletRequest)request).getQueryString();
		String quadKey = request.getParameter("id"); // GetQuadKey(urlString);

		int zoomLevel = quadKey.length();

		// Use the quadkey to determine a bounding box for the requested tile
		Box boundingBox = QuadKeyToBox(quadKey);

		// Get the lat longs of the corners of the box
		double lon = XToLongitudeAtZoom(boundingBox.x * TILE_SIZE, 18);
		double lat = YToLatitudeAtZoom(boundingBox.y * TILE_SIZE, 18);

		double lon2 = XToLongitudeAtZoom((boundingBox.x + boundingBox.width) * 256, 18) ;
		double lat2 = YToLatitudeAtZoom((boundingBox.y - boundingBox.height) * 256, 18);

		String sWMSBBoxRequest=lon+","+lat+","+lon2+","+lat2;

		return sWMSBBoxRequest;
	}


	public void service(ServletRequest request, ServletResponse response) throws IOException
	{

		// Graphics context object
		Graphics2D g2;

		DICountry countrybean = null;

		// JSP/Servlet environment variables (required to get the beans...)
		JspFactory jspxFactory = null;
		PageContext pageContext = null;
		HttpSession session = null;
		ServletContext application = null;
		ServletConfig config = null;
		JspWriter out = null;
		Object page = this;
		String sError = null;

		jspxFactory = JspFactory.getDefaultFactory();
		pageContext = jspxFactory.getPageContext(this, request, response, "", true, 8192, true);
		application = pageContext.getServletContext();
		config = pageContext.getServletConfig();
		session = pageContext.getSession();
		synchronized (session)
		{
			countrybean = (DICountry) pageContext.getAttribute("countrybean", PageContext.SESSION_SCOPE);
			if (countrybean == null)
			{
				try
				{
					countrybean = new DICountry(); // (DICountry) java.beans.Beans.instantiate(this.getClass().getClassLoader(), "desinventar.DICountry");
				}
				catch (Exception exc)
				{
					sError = "throw new ServletException ( Cannot create bean of class desinventar.DICountry)";
				}
				pageContext.setAttribute("countrybean", countrybean, PageContext.SESSION_SCOPE);
			}
		}

		// get parameters for this Map


		//      http://labs.metacarta.com/wms-c/Basic.py?LAYERS=basic&TRANSPARENT=true&FORMAT=png&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&STYLES=&EXCEPTIONS=application%2Fvnd.ogc.se_inimage&SRS=EPSG%3A4326&BBOX=-73.125%2C5.625%2C-71.71875%2C7.03125&WIDTH=256&HEIGHT=256
		//    	http://online.desinventar.org/cgi-bin/mapserv?MAP=%2Ftmp%2Fdi8ms_COLOMBIA-af7475be-305a-4776-b6d3-3f07d3f72a2e_.map&LAYERS=effects&TRANSPARENT=true&FORMAT=png&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&STYLES=&EXCEPTIONS=application%2Fvnd.ogc.se_inimage&SRS=EPSG%3A4326&BBOX=-77.345093%2C7.032715%2C-75.938843%2C8.438965&WIDTH=256&HEIGHT=256
		//    	http://per.geosemantica.net/services/mapserv.exe?MAP=2c1bc078-13e6-4734-863a-5636442a2e30_wms.map&LAYERS=geoutm_shp&TRANSPARENT=true&FORMAT=png&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&STYLES=&EXCEPTIONS=application%2Fvnd.ogc.se_inimage&SRS=EPSG%3A4326&BBOX=-76.639282%2C7.030884%2C-75.936157%2C7.734009&WIDTH=256&HEIGHT=256
		//      http://online.desinventar.org/cgi-bin/mapserv?&FORMAT=&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetCapabilities&EXCEPTIONS=&MAP=%2Ftmp%2Fdi8ms_COLOMBIA-af7475be-305a-4776-b6d3-3f07d3f72a2e_.map
		// GOAL:
		// http://desinventar/DesInventar/jsmapserv?MAP=ID2&LAYERS=level0&TRANSPARENT=true&FORMAT=gif&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&STYLES=&EXCEPTIONS=&SRS=EPSG%3A4326&BBOX=115.05965%2C-10.997407%2C161.0071875%2C5.906884&WIDTH=256&HEIGHT=256 


		String sWMSrequest=htmlServer.not_null_safe(request.getParameter("REQUEST"));
		String sWMSservice=htmlServer.not_null_safe(request.getParameter("SERVICE"));

		if (sWMSservice.equalsIgnoreCase("wms"))
		{
			if (sWMSrequest.equalsIgnoreCase("GetCapabilities"))
			{
				serveCapabilities(request, response, countrybean);
			}
			else if (sWMSrequest.equalsIgnoreCase("GetMap"))
			{
				serveMap(request, response, countrybean);    		    		
			}
			else if (sWMSrequest.equalsIgnoreCase("GetFeatureInfo"))
			{

			}
		}
		else
			if (sWMSservice.equalsIgnoreCase("VETILE"))
			{
				// http://localhost/DesInventar/jsmapserv?transparencyf=0.4&LAYERS=effects%2Clevel0&TRANSPARENT=true&FORMAT=png&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&STYLES=&EXCEPTIONS=application%2Fvnd.ogc.se_inimage&SRS=EPSG%3A4326&BBOX=-78.75,5.625,-73.125,11.25&WIDTH=256&HEIGHT=256
				serveMap(request, response, countrybean);    		    		
			} 


	}

	private void serveCapabilities(ServletRequest request, ServletResponse response, DICountry countrybean)
	{
		String sWMSMapRequest=htmlServer.not_null_safe(request.getParameter("MAP"));
		String sWMSVersionRequest=htmlServer.not_null_safe(request.getParameter("VERSION"));
		String sWMSFormatRequest=htmlServer.not_null_safe(request.getParameter("FORMAT"));
		String sWMSExceptionsRequest=htmlServer.not_null_safe(request.getParameter("EXCEPTIONS"));
		String sWMSSequenceRequest=htmlServer.not_null_safe(request.getParameter("UPDATESEQUENCE"));	    

	}
	private void serveMap(ServletRequest request, ServletResponse response, DICountry countrybean) throws IOException 
	{
		int nMapFunction=0;

		// MAP=xxx&LAYERS=effects&TRANSPARENT=true&FORMAT=png&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap
		// &STYLES=&EXCEPTIONS=application%2Fvnd.ogc.se_inimage&SRS=EPSG%3A4326
		// &BBOX=-77.345093%2C7.032715%2C-75.938843%2C8.438965&WIDTH=256&HEIGHT=256

		String sWMSMapRequest=htmlServer.not_null_safe(request.getParameter("MAP"));
		String sWMSVersionRequest=htmlServer.not_null_safe(request.getParameter("VERSION"));
		String sWMSFormatRequest=htmlServer.not_null_safe(request.getParameter("FORMAT"));
		String sWMSExceptionsRequest=htmlServer.not_null_safe(request.getParameter("EXCEPTIONS"));
		String sWMSSequenceRequest=htmlServer.not_null_safe(request.getParameter("UPDATESEQUENCE"));	    
		String sWMSLayersRequest=htmlServer.not_null_safe(request.getParameter("LAYERS"));
		String sWMSTransparentRequest=htmlServer.not_null_safe(request.getParameter("TRANSPARENT"));
		String sWMSStylesRequest=htmlServer.not_null_safe(request.getParameter("STYLES"));
		String sWMSSRSRequest=htmlServer.not_null_safe(request.getParameter("SRS"));
		String sWMSWidthRequest=htmlServer.not_null_safe(request.getParameter("WIDTH"));
		String sWMSHeightRequest=htmlServer.not_null_safe(request.getParameter("HEIGHT"));
		String sWMSBBoxRequest=htmlServer.not_null_safe(request.getParameter("BBOX"));

		String sWMSservice=htmlServer.not_null_safe(request.getParameter("SERVICE"));

		// Wrapper to WMS from Virtual Earth.  Service is disguised as WMS but bounding box and image size come
		// as Quad id and different parameter names.
		String tileIdParam = request.getParameter("id");
		if (sWMSservice.equalsIgnoreCase("VETILE"))
		{
			// Fetch URL-parameters
			sWMSWidthRequest="256";
			sWMSHeightRequest="256";
			sWMSBBoxRequest=getLiveEarthBBox(request);
			//System.out.println("BBOX="+sWMSBBoxRequest+" ID="+tileIdParam);
		}
		try{


			// Create the in-memory image
			int MapSizeX = webObject.extendedParseInt(sWMSWidthRequest);   
			int MapSizeY = webObject.extendedParseInt(sWMSHeightRequest);


			BufferedImage buffImage=BufferedImageFactory.getFactoryInstance().getBufferedImage(MapSizeX, MapSizeY);

			// obtain the graphics object from the image
			Graphics2D graphics = (Graphics2D) buffImage.getGraphics();
			BufferedImageFactory.setBasicGraphicProperties(graphics,countrybean.getLanguage());

			String sTransparencyFactor=request.getParameter("transparencyf");
			float dTransp=(float)webObject.extendedParseDouble(sTransparencyFactor);
			if (dTransp<0.05f)
				dTransp=countrybean.dTransparencyFactor;
			graphics.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC, dTransp));



			if (request.getParameter("countrycode")!=null)
			{
				countrybean=new DICountry();
				countrybean.countrycode=request.getParameter("countrycode");

				// Load the country object from the DesInventar (default) database
				dbConnection dbDefaultCon; 
				Connection dcon; 
				boolean bdConnectionOK=false; 
				// opens the Default database 
				dbDefaultCon=new dbConnection();
				bdConnectionOK = dbDefaultCon.dbGetConnectionStatus();
				if (bdConnectionOK)
				{
					dcon=dbDefaultCon.dbGetConnection();
				}  // opening dB!!
				else
					return;

				// It is done in the bean, so it can be reused as properties...
				countrybean.country.scountryid=countrybean.countrycode;
				countrybean.country.getWebObject(dcon);
				countrybean.countryname=countrybean.country.scountryname;
				countrybean.dbType=countrybean.country.ndbtype;
				// MUST return this connection!
				dbDefaultCon.close();
			}

			if (countrybean.countrycode.length()==0)
			{

				graphics.setColor(Color.red);
				graphics.drawString("Session timed out..",100,120);	
			}
			else
			{
				boolean bConnectionOK = false;
				dbConnection dbCon = null;
				Connection con = null;
				dbCon = new dbConnection(countrybean.country.sdriver, countrybean.country.sdatabasename,
						countrybean.country.susername, countrybean.country.spassword);


				if (request.getParameter("bookmark")!=null)
					countrybean.processParams((HttpServletRequest) request,new parser(), null);

				if (countrybean.asVariables == null)
				{
					countrybean.asVariables = new String[1];
					countrybean.asVariables[0] = "1";
				}
				if (countrybean.asVariables[0].length() == 0)
					countrybean.asVariables[0] = "1";

				// MapServer ms = new MapServer();
				MapServer ms=new MapServer();
				try
				{
					//    			 Declaration of default Dabatase variables available to the page
					// now, get a connection to the database
					bConnectionOK = dbCon.dbGetConnectionStatus();


					// continue if the database is available and ready
					if (bConnectionOK)
					{
						// Connection OK!!, go and get the data..
						con = dbCon.dbGetConnection();

						// now it should read the names of the levels, if they are missing...
						if (countrybean.asLevels[0].length()==0)
							countrybean.getLevelsFromDB(con);


						// see if there is a need to calculate ranges:
						boolean bRangesOK=false;
						for (int j=0; j<10; j++)
							if (countrybean.asMapRanges[j]!=0)
								bRangesOK=true;	
						if (!bRangesOK)
							MapUtil.calculateRanges("isolegend",con,countrybean);

						//&BBOX=-77.345093%2C7.032715%2C-75.938843%2C8.438965
						String sCoord=sWMSBBoxRequest;
						int nLim=sCoord.indexOf(",");
						double xm=Double.parseDouble(sCoord.substring(0,nLim));
						sCoord=sCoord.substring(nLim+1);
						nLim=sCoord.indexOf(",");
						double ym=Double.parseDouble(sCoord.substring(0,nLim));
						sCoord=sCoord.substring(nLim+1);
						nLim=sCoord.indexOf(",");
						double xx=Double.parseDouble(sCoord.substring(0,nLim));
						sCoord=sCoord.substring(nLim+1);
						if (sCoord.endsWith(";"))
							sCoord=sCoord.substring(0,sCoord.length()-1);
						double yy=Double.parseDouble(sCoord);

						int level_act=htmlServer.extendedParseInt(request.getParameter("level"));

						String code=htmlServer.not_null_safe(request.getParameter("code"));
						String showcodes=htmlServer.not_null_safe(request.getParameter("showcodes"));

						if (showcodes.length()>0)
							ms.bShowNames=false;
						if (ms.openMap(countrybean, graphics, con, MapSizeX, MapSizeY))
						{
							// assumes Level maps are on shapefiles (transform=1)
							MapTransformation mt=new MapTransformation();

							int nTransf=0;
							if (countrybean.lmMaps[countrybean.level_map]!=null) // default DI map with scaling by 10000 transformation... TODO: check transf type
								nTransf=DICountry.extendedParseInt(countrybean.lmMaps[level_act].filetype);	  
							// nTransf=0;
							if (nTransf==0)  // is a default old DI map
							{
								mt=(MapTransformation) (new MapTransformationDI());
								// google transformations
								if (sWMSSRSRequest.equalsIgnoreCase("EPSG:3785") || sWMSSRSRequest.equalsIgnoreCase("EPSG:900913") || sWMSSRSRequest.equalsIgnoreCase("EPSG:54004"))
									mt= (MapTransformation)(new MapTransformationMercatorSphericalDI());
							}
							else
								// google transformations
								if (sWMSSRSRequest.equalsIgnoreCase("EPSG:3785") || sWMSSRSRequest.equalsIgnoreCase("EPSG:900913") || sWMSSRSRequest.equalsIgnoreCase("EPSG:54004"))
									mt= (MapTransformation)(new MapTransformationMercatorSpherical());
								else
									if (sWMSSRSRequest.equalsIgnoreCase("EPSG:319009"))
										mt= (MapTransformation)(new MapTransformationSphericalGoogle());


							mt.setView(MapSizeX, MapSizeY);
							mt.setTransformation(xm,ym,xx,yy);
							ms.setTransformation(mt);

							StringTokenizer st =new StringTokenizer(sWMSLayersRequest," ,;");
							while (st.hasMoreTokens())
							{
								graphics.setColor(Color.black);
								String sLayer=st.nextToken();
								int nlayer=0;
								if (sLayer.equals("effects"))
									nMapFunction = DICountry.DoTHEMATIC; //htmlServer.extendedParseInt(request.getParameter("mappingfunction"));
								else if (sLayer.indexOf("select")>=0)
									nMapFunction = DICountry.SELECTED; 
								else if (sLayer.indexOf("level")>=0)
								{
									nMapFunction = DICountry.MAPS;
									level_act=webObject.extendedParseInt(sLayer.substring(5));
								}
								else if (sLayer.indexOf("layer")>=0)
								{
									nMapFunction = DICountry.MAPLAYERS; 
									nlayer=webObject.extendedParseInt(sLayer.substring(5));
								}			    	    			      		  
								else if (sLayer.indexOf("events")>=0)
								{
									nMapFunction = DICountry.VIEWDATA; 
									nlayer=0;
								}			    	    			      		  
								switch (nMapFunction)
								{
								case 99: // test function
									ms.plotAll();
									break;
								case DICountry.MAPS: // selection map
									if (nTransf==0)
									{
										try {
											float dStroke=1.0f;
											Color cColor=Color.darkGray;
											new Color(countrybean.lmMaps[level_act].color_red,countrybean.lmMaps[level_act].color_green,countrybean.lmMaps[level_act].color_blue);
											if (countrybean.lmMaps[level_act]!=null)
											{
												dStroke=countrybean.lmMaps[level_act].line_thickness/100.0f;
												cColor=new Color(countrybean.lmMaps[level_act].color_red,countrybean.lmMaps[level_act].color_green,countrybean.lmMaps[level_act].color_blue);        						        	
											}
											graphics.setStroke(new BasicStroke(dStroke));
											graphics.setColor(cColor);
											ms.plotWMSLevel(level_act,"",true);
										}
										catch (Exception emap){
											System.out.println("[DI9] Exception in WebMapServer [outline layers/0]: "+emap.toString());
										}										
									}
									else
									{
										try {
											WebMapService.addLayer(countrybean.lmMaps[level_act].filename);
											WebMapService.setlayerCode(countrybean.lmMaps[level_act].filename,   countrybean.lmMaps[level_act].lev_code, countrybean.lmMaps[level_act].lev_name, countrybean.lmMaps[level_act].lev_name );
											WebMapService.setlayerLevel(countrybean.lmMaps[level_act].filename,   level_act );
											WebMapService.setConnection(countrybean.lmMaps[level_act].filename,   con );
											Color cColor=new Color(countrybean.lmMaps[level_act].color_red,countrybean.lmMaps[level_act].color_green,countrybean.lmMaps[level_act].color_blue);
											graphics.setStroke(new BasicStroke(Math.max(0.5f,countrybean.lmMaps[level_act].line_thickness/100.0f)));
											int nRecs=(WebMapService.getlayerMapObject(countrybean.lmMaps[level_act].filename).lArcs.size());
											int nShowId=0;
											if ( (level_act==0 || level_act<countrybean.level_map) && nRecs<15)  // avoid clutter	
												nShowId=2;
											WebMapService.renderLayer(countrybean.lmMaps[level_act].filename, mt, graphics, MapSizeX, MapSizeY, cColor, null,countrybean,  nShowId);
										}
										catch (Exception emap){
											System.out.println("[DI9]Exception in WebMapServer [outline layers/1]: "+emap.toString()+
													             " cntry:" +countrybean.countrycode+"-"+countrybean.countryname+" lev"+level_act);
										}										
									}



									break;
								case DICountry.VIEWDATA: // tematic map
									try {
										if (countrybean.htEvents==null)
											countrybean.htEvents = ms.CreateEvents(countrybean,con);
										if (nTransf==0)
										{
											// DEVELOP THIS: ?
											// ms.plotEvents(countrybean.level_rep,countrybean.level_map,countrybean.htData);
										}
										else
										{   // Synthetic layer with points per event location. This is a transient layer, so is removed after rendering
											String sSyntheticLayer="MAP@"+countrybean.countrycode;
											WebMapService.addLayer(sSyntheticLayer);
											WebMapService.setlayerMapObject(sSyntheticLayer, countrybean.htEvents);
											// Color cColor=new Color(countrybean.lmMaps[countrybean.level_map].color_red,countrybean.lmMaps[countrybean.level_map].color_green,countrybean.lmMaps[countrybean.level_map].color_blue);
											Color cColor=Color.blue; // not good over google: .green; // was  .black;
											graphics.setStroke(new BasicStroke(0.5f));
											WebMapService.renderLayer(sSyntheticLayer, mt, graphics, MapSizeX, MapSizeY, cColor, countrybean, null);
											WebMapService.removeLayer(sSyntheticLayer);
										}			        		
									}
									catch (Exception emap){
										System.out.println("Exception in WebMapServer [Thematic layer]: "+emap.toString());
										emap.printStackTrace();
									}
									break;
								case DICountry.DoTHEMATIC: // tematic map
									try {
										if (countrybean.htData==null)
											countrybean.htData = ms.CreateData(countrybean);
										if (nTransf==0)
										{
											ms.plotThematic(countrybean.level_rep,countrybean.level_map,countrybean.htData);
										}
										else
										{
											WebMapService.addLayer(countrybean.lmMaps[countrybean.level_map].filename);
											WebMapService.setlayerCode(countrybean.lmMaps[countrybean.level_map].filename,   countrybean.lmMaps[countrybean.level_map].lev_code, countrybean.lmMaps[countrybean.level_map].lev_name, countrybean.lmMaps[countrybean.level_map].lev_name );
											WebMapService.setlayerLevel(countrybean.lmMaps[countrybean.level_map].filename,   countrybean.level_map );
											WebMapService.setConnection(countrybean.lmMaps[countrybean.level_map].filename,   con );
											Color cColor=new Color(countrybean.lmMaps[countrybean.level_map].color_red,countrybean.lmMaps[countrybean.level_map].color_green,countrybean.lmMaps[countrybean.level_map].color_blue);
											graphics.setStroke(new BasicStroke(Math.max(0.8f,countrybean.lmMaps[countrybean.level_map].line_thickness/100.0f)));
											WebMapService.renderLayer(countrybean.lmMaps[countrybean.level_map].filename, mt, graphics, MapSizeX, MapSizeY, cColor, countrybean, countrybean.htData);
										}			        		
									}
									catch (Exception emap){
										System.out.println("Exception in WebMapServer [Thematic layer]: "+emap.toString());
										emap.printStackTrace();
									}
									break;

								case DICountry.MAPLAYERS: // ArcView -external map
									try {
										if (countrybean.imLayerMaps!=null && 
												nlayer<countrybean.imLayerMaps.length && 
												countrybean.imLayerMaps[nlayer]!=null &&
												countrybean.imLayerMaps[nlayer].visible>0
										){
											WebMapService wms=WebMapService.getInstance();
											WebMapService.addLayer(countrybean.imLayerMaps[nlayer].filename);
											Color cColor=new Color(countrybean.imLayerMaps[nlayer].color_red,countrybean.imLayerMaps[nlayer].color_green,countrybean.imLayerMaps[nlayer].color_blue);
											graphics.setColor(cColor);
											graphics.setStroke(new BasicStroke(Math.max(0.5f,countrybean.imLayerMaps[nlayer].line_thickness/100.0f)));
											WebMapService.renderLayer(countrybean.imLayerMaps[nlayer].filename, mt, graphics, MapSizeX, MapSizeY, cColor, null,countrybean, 0);
										}					        		
									}
									catch (Exception emap){
										System.out.println("Exception in WebMapServer [other layers]: "+emap.toString());
										emap.printStackTrace();
									}
									break;
								case DICountry.SELECTED: // subImage of Selected Region
									// TODO: add htmlServer.extendedParseDouble!!
									buffImage=ms.plotSelected(code,level_act,xm,ym,xx,yy,buffImage);
									break;
								}
							}
						}
					}
					else
					{
					}


				}
				catch (Exception eMain){
					System.out.println("Exception in WebMapServer: "+eMain.toString());
					eMain.printStackTrace();
				}
				finally{
					// and finally, close the database (return to pool) and make sure the map resources are closed too
					dbCon.close();
					ms.close();

				}

			}
			//  For JAVA2D, a PNG encoder:
			response.setContentType("image/png");
			byte[] pngbytes=new byte[10];
			PngEncoderB png =  new PngEncoderB( buffImage, PngEncoder.ENCODE_ALPHA,	0,1);
			ServletOutputStream output = response.getOutputStream();
			try
			{
				pngbytes = png.pngEncode();
				if (pngbytes == null) {
					System.out.println("MAP: Null image");
				}
				output.write(pngbytes);

			}
			catch (Exception e)
			{
				// e.printStackTrace();
				if (!e.toString().startsWith("ClientAbortException"))  // this cases can be ignored...
					System.out.println("Exception  encoding image: "+e.toString());
			}		    
			output.close();


			BufferedImageFactory.getFactoryInstance().returnImageToFactory(buffImage);
		}
		catch (Exception e)
		{
			if (!e.toString().startsWith("ClientAbortException"))  // this cases can be ignored...
			{
				System.out.println("ERROR:   ->>> "+e.toString());
				e.printStackTrace();
			}
		}
	}   
}

class Box
{
	public int x;
	public int y;
	public int width;
	public int height;

	public Box(int x, int y, int width, int height)
	{
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}
}

