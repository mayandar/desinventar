package org.lared.desinventar.servlet;

/**
 * <p>Title: DesInventar WEB Version 6.1.2 Graph Server</p>
 * <p>Description: Thematic Map generation servlet, for the
 * On-Line Version of DesInventar/DesConsultar 6.</p>
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
import org.lared.desinventar.util.*;

import net.jmge.gif.Gif89Encoder;

public class MapLegendServer     
	extends GenericServlet
	implements chartConstants
{

	  /** java.awt.Color from an HTML color  string #RRGGBB */
	  public Color gColorFromString(String strColor)
	  {
	    int r = 0, g = 0, b = 0;

	    if (strColor == null || strColor.length() == 0)
	      strColor = "#";
	    strColor += "000000";
	    try
	    {
	      r = Integer.parseInt(strColor.substring(1, 3), 16);
	    }
	    catch (Exception er)
	    {}
	    try
	    {
	      g = Integer.parseInt(strColor.substring(3, 5), 16);
	    }
	    catch (Exception eg)
	    {}
	    try
	    {
	      b = Integer.parseInt(strColor.substring(5, 7), 16);
	    }
	    catch (Exception eb)
	    {}
/*	    if (!countrybean.bColorBW)
	        {
	    	r=(r+g+b)/3;
	    	return new Color(r, r, r);
	        }
*/	   
	    return new Color(r, g, b);
	  }

	  /** java.awt.Color from an HTML color  string #RRGGBB */
	  private String BWfromColorString(String strColor)
	  {
	    int r = 0, g = 0, b = 0;
	    String sRet="#000000";
	    
	    if (strColor == null || strColor.length() == 0)
	      strColor = "#";
	    strColor += "000000";
	    try
	    {
	      r = Integer.parseInt(strColor.substring(1, 3), 16);
	    }
	    catch (Exception er)
	    {}
	    try
	    {
	      g = Integer.parseInt(strColor.substring(3, 5), 16);
	    }
	    catch (Exception eg)
	    {}
	    try
	    {
	      b = Integer.parseInt(strColor.substring(5, 7), 16);
	    }
	    catch (Exception eb)
	    {}

	    r=(r+g+b)/3;
	    if (r<16)
	    	sRet="#0"+Integer.toHexString(r)+"0"+Integer.toHexString(r)+"0"+Integer.toHexString(r);
	    else
	    {
	    	sRet="#"+Integer.toHexString(r)+Integer.toHexString(r)+Integer.toHexString(r);
	    }
	    	
	    return sRet;
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
	
	// now it should read the names of the levels. 
	// It is done in the bean, so it can be reused as properties...
	countrybean.country.scountryid=countrybean.countrycode;
	countrybean.country.getWebObject(dcon);
	countrybean.countryname=countrybean.country.scountryname;
	countrybean.dbType=countrybean.country.ndbtype;
	// MUST return this connection!
	dbDefaultCon.close();
	}

	if (request.getParameter("bookmark")!=null)
		countrybean.processParams((HttpServletRequest) request,new parser(),null);

	String[] sRanges=new String[11];
    int nMaxLegendHeight=2;

	sRanges[0]="0/"+countrybean.getTranslation("NoData");
	int nMaxLegendWidth=sRanges[0].length()*8;
    if (countrybean.asMapLegends[0].length()>0)
		sRanges[1]=countrybean.asMapLegends[0];
	else
		sRanges[1]="<= "+countrybean.formatDouble(countrybean.asMapRanges[0]);
	nMaxLegendWidth=Math.max(nMaxLegendWidth,sRanges[1].length()*8);
	int j;
	for (j=1; j<10 && countrybean.asMapRanges[j]>0  ; j++)
		{
        // here the cell with color
		if (countrybean.asMapLegends[j].length()>0)
			sRanges[j+1]=countrybean.asMapLegends[j];
		else
			sRanges[j+1]=countrybean.formatDouble(countrybean.asMapRanges[j-1])+" <= "+countrybean.formatDouble(countrybean.asMapRanges[j]);
		nMaxLegendWidth=Math.max(nMaxLegendWidth,sRanges[j+1].length()*8);
		nMaxLegendHeight++;
		}
	if (countrybean.asMapLegends[j].length()>0)
		{
		sRanges[j+1]=countrybean.asMapLegends[j];
		nMaxLegendHeight++;
		nMaxLegendWidth=Math.max(nMaxLegendWidth,sRanges[j+1].length()*7);
		}
	else
		if (countrybean.asMapColors[j].length()>0)
		 {
			sRanges[j+1]="> "+countrybean.formatDouble(countrybean.asMapRanges[j-1]);
			nMaxLegendHeight++;
			nMaxLegendWidth=Math.max(nMaxLegendWidth,sRanges[j+1].length()*7);
		}

	nMaxLegendWidth+=40; // the squares
	
	for (int k = 0; k < countrybean.asVariables.length; k++)
	{
	String sVar=countrybean.getTranslation("Variable")+" "+countrybean.getVartitle(countrybean.asVariables[k]);
	nMaxLegendWidth=Math.max(nMaxLegendWidth,sVar.length()*7);
	}
	
	// calculate the maximums
	int MapSizeX = nMaxLegendWidth;
    // add one line per variable
	int MapSizeY = (nMaxLegendHeight+1)*20+countrybean.asVariables.length*12;

	BufferedImage buffImage=BufferedImageFactory.getFactoryInstance().getBufferedImage(MapSizeX, MapSizeY);
    Graphics2D graphics = (Graphics2D) buffImage.getGraphics();
    
    BufferedImageFactory.setBasicGraphicProperties(graphics,countrybean.getLanguage());
    
    String sTransparencyFactor=request.getParameter("transparencyf");
    float dTransp=(float)countrybean.extendedParseDouble(sTransparencyFactor);
    if (dTransp<0.05f)
    	dTransp=countrybean.dTransparencyFactor;

    graphics.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC, dTransp));

    try
		{
	    graphics.setColor(Color.white);
	    graphics.fillRect(0, 0, MapSizeX-1, MapSizeY-1);
		graphics.setColor(Color.gray);
	    graphics.drawRect(0, 0, MapSizeX-1, MapSizeY-1);
	    graphics.setColor(Color.black);
	     int cY=15;
		for (int k = 0; k < countrybean.asVariables.length; k++)
			{
			String sVar=countrybean.getTranslation("Variable")+": ";
			if (k>0)
				sVar= "            + ";
			sVar+= countrybean.getVartitle(countrybean.asVariables[k]);
			graphics.drawString(sVar,2,cY);
			cY+=12;
			}
		for (j=0; j< nMaxLegendHeight; j++)
			{
			try {
		        // here the cell with color
	            if (j==0)
	            	graphics.setColor(Color.white);
	            else
	            	graphics.setColor(gColorFromString(countrybean.asMapColors[j-1]));
	            if (countrybean.nMapType == 1)
				{
	            	graphics.fillOval(10, cY+20*j,j*4,j*4);
				}
				else if (countrybean.nMapType == 2)
				{
					graphics.fillRect(10, cY+20*j,6,j*4);
					graphics.setColor(Color.black);
					graphics.drawRect(10, cY+20*j,6,j*4);
				}	 
				else
				{
					graphics.fillRect(10, cY+20*j, 25, 18 );
		    		graphics.setColor(Color.darkGray);
		            graphics.drawRect(10, cY+20*j, 25, 18 );
				}
	    	    graphics.setColor(Color.black);
				graphics.drawString(sRanges[j],40,cY+15+20*j);				
				graphics.drawString(sRanges[j],40,cY+15+20*j);				
			}
			catch (Exception e)
			{
				// ignore
			}
			}

	}
	catch (Exception eMain){
		
	}
	finally
	{
	// and finally, close the database (return to pool)
		
	}
	//  For JAVA2D, a PNG encoder:
    response.setContentType("image/png");
	byte[] pngbytes;
	PngEncoderB png =  new PngEncoderB( buffImage, PngEncoder.ENCODE_ALPHA,	0,1);
	ServletOutputStream out_stream = response.getOutputStream();
	try
	{
		pngbytes = png.pngEncode();
		if (pngbytes == null) {
			System.out.println("MAP: Null image");
		}
		out_stream.write(pngbytes);		
	}
	catch (Exception e)
	{
  		System.out.println("Exception generating Legend: "+e.toString());
		e.printStackTrace();
	}
	out_stream.close();
  }   
}
