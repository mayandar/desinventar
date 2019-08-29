package org.lared.desinventar.servlet;

/**
 * <p>Title: DesInventar WEB Version 9.1.2 Graph Server</p>
 * <p>Description: Thematic Map generation servlet, for the
 * On-Line Version of DesInventar/DesConsultar 6.</p>
 * <p>Copyright: Copyright (c) 2002...2010  La  Red.</p>
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

import net.jmge.gif.Gif89Encoder;



public class ThematicMapServer
extends GenericServlet
implements chartConstants
{
	PrintWriter out = null;

	public ThematicMapServer()
	{
	}


	public void service(ServletRequest request, ServletResponse response) throws IOException
	{

		// Graphics context objects
		Graphics2D g2;
		Graphics g;

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
					countrybean = new DICountry(); //(DICountry) java.beans.Beans.instantiate(this.getClass().getClassLoader(), "desinventar.DICountry");
				}
				catch (Exception exc)
				{
					sError = "throw new ServletException ( Cannot create bean of class desinventar.DICountry)";
				}
				pageContext.setAttribute("countrybean", countrybean, PageContext.SESSION_SCOPE);
			}
		}

		// get parameters for this Map
		int nMapFunction = DICountry.MAPS; // htmlServer.extendedParseInt(request.getParameter("mapType"));
		if (request.getParameter("mappingfunction")!=null)
			nMapFunction = htmlServer.extendedParseInt(request.getParameter("mappingfunction"));
		if (countrybean.asVariables == null)
		{
			countrybean.asVariables = new String[1];
			countrybean.asVariables[0] = "1";
		}
		if (countrybean.asVariables[0].length() == 0)
			countrybean.asVariables[0] = "1";

		// Create the in-memory image
		int MapSizeX = countrybean.xresolution;
		int MapSizeY = countrybean.yresolution;

		BufferedImage buffImage=BufferedImageFactory.getFactoryInstance().getBufferedImage(MapSizeX, MapSizeY);

		if (buffImage==null)
			System.out.println("DI9: error allocating MAP bitmap");
		// else System.out.println("DI9: NO error allocating MAP bitmap");
		// Create a graphics object from the image
		Graphics2D graphics = (Graphics2D) buffImage.getGraphics();
		graphics.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, 1.0f));

		BufferedImageFactory.setBasicGraphicProperties(graphics,countrybean.getLanguage());

		// this component produces bright, non-transparent solid color thematic maps, but transparent selection Maps
		if (nMapFunction==DICountry.DoTHEMATIC)
		{
			java.awt.geom.Rectangle2D.Double rect = new java.awt.geom.Rectangle2D.Double(0,0,MapSizeX,MapSizeY); 
			graphics.setColor(Color.white);
			graphics.fill(rect);    	
		}


		// Declaration of default Dabatase variables available to the page
		boolean bConnectionOK = false;
		dbConnection dbCon = null;
		Connection con = null;
		// now, get a connection to the database
		dbCon = new dbConnection(countrybean.country.sdriver, countrybean.country.sdatabasename,
				countrybean.country.susername, countrybean.country.spassword);
		bConnectionOK = dbCon.dbGetConnectionStatus();
		// continue if the database is available and ready
		if (bConnectionOK)
		{
			// Conexion OK!!, go and get the data..
			con = dbCon.dbGetConnection();

			MapServer ms = new MapServer();
			int level_act=htmlServer.extendedParseInt(request.getParameter("level"));
			String code=htmlServer.not_null(request.getParameter("code"));
			String code0=htmlServer.not_null(request.getParameter("level0_code"));
			String code1=htmlServer.not_null(request.getParameter("level1_code"));
			String showcodes=htmlServer.not_null(request.getParameter("showcodes"));
			String layers=htmlServer.not_null(request.getParameter("LAYERS"));
			if (showcodes.length()>0)
				ms.bShowNames=false;
			if (ms.openMap(countrybean, graphics, con, MapSizeX, MapSizeY))
			{
				ms.mt.setView(countrybean.xresolution, countrybean.yresolution);
				switch (nMapFunction)
				{
				case 99:
					ms.plotAll();
					break;
				case DICountry.MAPS: // selection map
				graphics.setColor(Color.darkGray);
				int nTemp=countrybean.level_map;
				int nShowTemp=countrybean.nShowIdType;
				countrybean.nShowIdType=2;
				countrybean.level_map=99; // force names
				if (level_act==0)
					ms.plotLevel(0,"",request);  
				else if (level_act==1)
					ms.plotLevel(1,code0,request);   
				else if (level_act==2)
					ms.plotLevel(2,code1,request);  
				countrybean.level_map=nTemp;
				countrybean.nShowIdType=nShowTemp;
				break;
				case DICountry.DoTHEMATIC: // thematic mapping
					countrybean.htData = ms.CreateData(countrybean);
					// force recalculation of full window
					ms.mt.xminif = 0;
					ms.mt.yminif = 0;
					ms.mt.xmaxif = 0;
					ms.mt.ymaxif = 0;
					ms.plotThematic(countrybean.level_rep,countrybean.level_map, countrybean.htData);
					graphics.setStroke(new BasicStroke(1.1f));
					graphics.setColor(Color.darkGray);
					nShowTemp=countrybean.nShowIdType;
					// dont show names for now..
					StringTokenizer st =new StringTokenizer(layers," ,;");
					while (st.hasMoreTokens())
					{
						String sLayer=st.nextToken();
						int nlayer=0;
						if (sLayer.indexOf("layer")>=0)
						{
							nlayer=webObject.extendedParseInt(sLayer.substring(5));
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
									WebMapService.renderLayer(countrybean.imLayerMaps[nlayer].filename, ms.mt, graphics, MapSizeX, MapSizeY, cColor, null,countrybean, 0);
								}					        		
							}
							catch (Exception emap){
								System.out.println("Exception in WebMapServer [other layers]: "+emap.toString());
								emap.printStackTrace();
							}
						}
						else    if (sLayer.indexOf("level")>=0)
						{
							countrybean.nShowIdType=0;
							level_act=webObject.extendedParseInt(sLayer.substring(5));
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
							countrybean.nShowIdType=nShowTemp;			        	
						}

					}
					break;
				case DICountry.SELECTED: // subImage of Selected Region
					double xm=countrybean.extendedParseDouble(request.getParameter("xminif"));
					double ym=countrybean.extendedParseDouble(request.getParameter("yminif"));
					double xx=countrybean.extendedParseDouble(request.getParameter("xmaxif"));
					double yy=countrybean.extendedParseDouble(request.getParameter("ymaxif"));
					buffImage=ms.plotSelected(code,level_act,xm,ym,xx,yy,buffImage);
					break;
				}

				ms.close();
			}
			// and finally, close the database (return to pool)
			dbCon.close();

		}
		else
		{
		}

		ServletOutputStream output = response.getOutputStream();
		//  For JAVA2D, a PNG encoder:
		response.setContentType("image/png");
		byte[] pngbytes;
		PngEncoderB png =  new PngEncoderB( buffImage, PngEncoder.ENCODE_ALPHA,	0,1);
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
			e.printStackTrace();
		}


		output.close();

	}

}