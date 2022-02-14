<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" 
  "https://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<%@ page info="DesConsultar simple results page" session="true" %><%@ page import="java.io.*"%><%@ page import="java.sql.*"%><%@ page import="java.util.*"%><%@page import="java.net.*" %><%@ page import="org.lared.desinventar.util.*" %><%@ page import="org.lared.desinventar.map.*" %><%@ page import="org.lared.desinventar.webobject.fichas" %><jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" /><%@ include file="/util/opendatabase.jspf" %><%@ include file="/paramprocessor.jspf" %><%! 
String getList(String[] asList)
{
String sSql="";
String sOr="'";
for (int j = 0; j < asList.length; j++)
	{
	  sSql += sOr + htmlServer.check_quotes(asList[j])+"'";
	  sOr = ",'";
	}
return sSql;
}

String iCoo(double xy)
{
// return (int)(xy*10000);
return DICountry.formatDouble(xy,-4);
}
String iCooY(double xy)
{
// return (int)(xy*10000);
return DICountry.formatDouble(90-xy,-4);
}
%><%
response.setHeader("Pragma", "no-cache");
response.setHeader("Cache-Control", "no-cache");
response.setDateHeader("Expires", 0);
//*
String sTime=String.valueOf(Calendar.getInstance().get(Calendar.MINUTE)+Calendar.getInstance().get(Calendar.HOUR)*100);
response.setHeader("Content-disposition", "attachment;filename=DI_SVGmap"+sTime+".svg");
response.setHeader("Content-Type", "image/svg+xml; charset=utf-8");
/*/
DBG: response.setContentType("text/xml"); 
//*/
String pname="";
String[] pval;
/// variables for future enhancements:	
double xm=-180,ym=-90,xx=180,yy=90;
String code=htmlServer.not_null(request.getParameter("code"));
String code0=htmlServer.not_null(request.getParameter("level0_code"));
String code1=htmlServer.not_null(request.getParameter("level1_code"));
String showcodes=htmlServer.not_null(request.getParameter("showcodes"));
int level_act=countrybean.extendedParseInt(request.getParameter("level_act"));


MapTransformation mt=new MapTransformation();
if (countrybean.level_rep==0)
        MapUtil.getExtents(countrybean.level_rep, countrybean.asNivel0, mt, con, countrybean);
	else
        MapUtil.getExtents(countrybean.level_rep, countrybean.asNivel1, mt, con, countrybean);
xm=mt.xminif;
ym=mt.yminif;
xx=mt.xmaxif;
yy=mt.ymaxif;

int nTransf=0;
if (countrybean.lmMaps[level_act]!=null) // default DI map with scaling by 10000 transformation... TODO: check transf type
				  nTransf=countrybean.extendedParseInt(countrybean.lmMaps[level_act].filetype);	  
if (nTransf==0)
	{
     xm/=10000.0;
     ym/=10000.0;
     xx/=10000.0;
	 yy/=10000.0;
    }

String sShape="";
if (countrybean.lmMaps[countrybean.level_map]!=null)
	  sShape=countrybean.lmMaps[countrybean.level_map].filename;
	  // default DI map with scaling by 10000 transformation... TODO: check transf type
 if (xm==0 && xx==0)
    {
    xm = WebMapService.getlayerXmin(sShape);
    ym = WebMapService.getlayerYmin(sShape);
    xx = WebMapService.getlayerXmax(sShape);
    yy = WebMapService.getlayerYmax(sShape);
	}

		
 if (xm==0 && xx==0)
	   xm=-(xx=180);
 if (ym==0 && yy==0)
	   ym=-(yy=85);

mt.xminif=xm;
mt.yminif=ym;
mt.xmaxif=xx;
mt.ymaxif=yy;
mt.setView(120.0,120.0);

// gets this URL
String sRequest=new String(request.getRequestURL());
// gets the hostname
URL thisURL=new URL(sRequest);
String sHost=thisURL.getHost();
int nPort=request.getLocalPort();

if (countrybean.htData==null)
		{
		countrybean.htData=new HashMap(); // no data?
		//	countrybean.htData = new MapServer().CreateData(countrybean);
		}
MapObject   mao=WebMapService.getlayerMapObject(countrybean.lmMaps[countrybean.level_map].filename);
 int nRecs=(mao.lArcs.size());
/*
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "https://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
*/  
%><svg width="12cm" height="12cm" viewBox="<%=iCoo(Math.max(-179,xm))%> <%=iCooY(Math.min(80,yy))%> <%=iCoo(Math.min(179,xx))%> <%=iCooY(Math.max(-80,ym))%>"
     xmlns="https://www.w3.org/2000/svg" version="1.1">
	 <desc>DesInventar Thematic Map - <jsp:getProperty name ="countrybean" property="countryname"/> [<jsp:getProperty name ="countrybean" property="countrycode"/>] </desc>
<% 
   // the map has previously been used, first call triggered a full scan of the file, loading the index and polygons into memory
   for (int j=0; j<mao.lArcs.size(); j++)
   {
	ArcObject arco=(ArcObject)(mao.lArcs.get(j));
	// renderMapObject(g2, cBorderColor, cFillColor, countrybean, htData, m, arco, nShowIdType);
	int nSize;
	int i=0;
	Double odVal=(Double) (countrybean.htData.get(arco.sCode));
	double dVal=0;
	if (odVal!=null) 
	 dVal=odVal.doubleValue();	
	int k=0;
	int kCol=0;
	if (dVal!=0)
		{
		try{
		while ( (kCol < 10) && (countrybean.asMapRanges[kCol] < dVal) && (countrybean.asMapRanges[kCol] > 0))
			kCol++;
			}
		catch (Exception e) 
		   {
			System.out.println("[DI9]: rendering SVG[1] "+e.toString());
		   }
		}
	if (arco.xmax>xm && arco.ymax>ym && arco.xmin<xx && arco.ymin<yy && arco.numparts>0) // && odVal!=null) // too much filtering
		{	   
	    try{
	 	   // first polygon
		   // polygons - have to search them in order?
		   for (k = 0; k<arco.numparts; k++)
	   		{
	 	  	nSize = arco.parts[k+1]-arco.parts[k];
			if (nSize>0)
			  {
			  if (odVal!=null){%>   
	<polygon style="stroke:#808080; fill:<%=countrybean.asMapColors[kCol]%>;stroke-width:0.1;" points="<%
		}
	else{%>   
	<polygon style="stroke:#808080; fill:#ffffff;stroke-width:0.1;" points="<%
		}
	    for (int jj = 0; jj < nSize; jj++)
					     	{
					    	out.print(iCoo(arco.xcoo[i])+","+iCooY(arco.ycoo[i])+" ");
					    	i++;
					     	}%>"/>  
	<%			}
	          }
			}
		 catch (Exception esvg)
			{
			System.out.println("DI9: rendering SVG[2] "+esvg.toString());
			}
	   }
   }
   
   // build the legend
   	String[] sRanges=new String[11];
    int nMaxLegendHeight=2;
	
	sRanges[0]="0 / "+countrybean.getTranslation("NoData");
    if (countrybean.asMapLegends[0].length()>0)
		sRanges[1]=countrybean.asMapLegends[0];
	else
		sRanges[1]="&lt;= "+countrybean.formatDouble(countrybean.asMapRanges[0]);

	int j;
	for (j=1; j<10 && countrybean.asMapRanges[j]>0  ; j++)
		{
        // here the cell with color
		if (countrybean.asMapLegends[j].length()>0)
			sRanges[j+1]=countrybean.asMapLegends[j];
		else
			sRanges[j+1]=countrybean.formatDouble(countrybean.asMapRanges[j-1])+" &lt;= "+countrybean.formatDouble(countrybean.asMapRanges[j]);
		nMaxLegendHeight++;
		}
	if (countrybean.asMapLegends[j].length()>0)
		{
		sRanges[j+1]=countrybean.asMapLegends[j];
		nMaxLegendHeight++;
		}
	else
		if (countrybean.asMapColors[j].length()>0)
		 {
			sRanges[j+1]="&gt; "+countrybean.formatDouble(countrybean.asMapRanges[j-1]);
			nMaxLegendHeight++;
		}

    double dFullSize=xx-xm;
	double dScaleSize=dFullSize/10;
	double dScaleMargin=dFullSize/100;
	double dPosx=xx+dScaleMargin;
	double dPosy=yy;
	double dStepY=dFullSize/nMaxLegendHeight;
	double dRectSize=dStepY*0.8;
	double dFontSize=dStepY*0.5;
	
    try
		{
		String sVar=countrybean.getTranslation("Variable")+": ";
		for (int k = 0; k < countrybean.asVariables.length; k++)
			{
			if (k>0)
				sVar+= " + ";
			sVar+= countrybean.getVartitle(countrybean.asVariables[k]);
			}
%><text x="<%=dPosx%>" y="<%=dPosy%>" style="fill:#000000; font-size:<%=dFontSize%>;"><%=sVar%></text>
<%
		dPosy+=dStepY;
		for (j=0; j< nMaxLegendHeight; j++)
			{
			String sCol="#FFFFFF";
			try {
		        // here the cell with color
	            if (j>0)
	            	sCol=countrybean.asMapColors[j-1];
%>			<rect x="<%=dPosx%>" y="<%=dPosy%>" width="<%=dRectSize%>" height="<%=dRectSize%>"  style="stroke:#000000; fill:<%=sCol%>;stroke-width:0.1;" /> 
			<text x="<%=dPosx+dStepY%>" y="<%=dPosy+dStepY/2%>" style="fill:#000000; font-size:<%=dFontSize%>;"><%=sRanges[j]%></text>
<%	        dPosy+=dStepY;
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
   
   
   
   
   
   
   
   
   
   
   
   
   
   %>
</svg>


