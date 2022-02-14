<?xml version="1.0" encoding="UTF-8"?>
<%@ page info="DesConsultar simple results page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@page import="java.net.*" %>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.map.*" %>
<%@ page import="org.lared.desinventar.webobject.fichas" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%@ include file="/util/opendatabase.jspf" %>
<%@ include file="/paramprocessor.jspf" %>
<%! 
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
String getGoogleColor(String sParam)
{
String sRet=sParam.replace("#","");
if (sRet.length()<6)
   sRet=(sRet+"000000").substring(0,6);
else
	{
	sRet=sRet.substring(4,6)+sRet.substring(2,4)+sRet.substring(0,2);
	}
return sRet;   
}
%>
<%
response.setHeader("Pragma", "no-cache");
response.setHeader("Cache-Control", "no-cache");
response.setDateHeader("Expires", 0);
//*
response.setContentType("Application/googleearth");
response.setHeader("Content-disposition", "attachment;filename=DI_thematic.kml");
response.setHeader("Content-Type", "application/kml; charset=utf-8");
/*/
DBG: response.setContentType("text/xml"); 
//*/
String pname="";
String[] pval;
/// variables for future enhancements:	
double xm=-180,ym=-90,xx=180,yy=90;
String code=htmlServer.not_null_safe(request.getParameter("code"));
String code0=htmlServer.not_null_safe(request.getParameter("level0_code"));
String code1=htmlServer.not_null_safe(request.getParameter("level1_code"));
String showcodes=htmlServer.not_null_safe(request.getParameter("showcodes"));
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


// http://localhost/DesInventar/export_kml.jsp
	   
//String sHost=request.getRemoteHost();
// gets this URL
String sRequest=new String(request.getRequestURL());
// gets the hostname
URL thisURL=new URL(sRequest);
String sHost=thisURL.getHost();
String sProtocol=thisURL.getProtocol();
int nPort=request.getLocalPort();

MapObject   mao=WebMapService.getlayerMapObject(countrybean.lmMaps[countrybean.level_map].filename);
 int nRecs=(mao.lArcs.size());
 
%>
<kml xmlns="https://www.opengis.net/kml/2.2">
<Document>  
<name>DesInventar Map</name>  
<open>1</open>
	<description><![CDATA[<body style="background-color: #FFFFFF">
<p><font face="Arial, Helvetica, sans-serif">
<font color="#008080" face="Arial, Helvetica, sans-serif">DesInventar Thematic Map</font>
<p><font face="Arial, Helvetica, sans-serif">
    <p align="justify">
Until the mid-1990.s, systematic information about the occurrence of daily
disasters of small and medium impact was not available in most countries in the world. 
From 1994, the creation of a common conceptual and
methodological framework was begun in latin America by groups of researchers, academicians,
and institutional actors linked to the Network of Social Studies in the
Prevention of Disasters in Latin America (Red de Estudios Sociales en
Prevenci&oacute;n de Desastres en Am&eacute;rica Latina - LA RED). These groups conceptualised
a system of acquisition, collection, retrieval, query and analyis of information about
disasters of small, medium and greater impact, based on pre-existing official data, academic records,
newspaper sources and institutional reports in nine countries in Latin
America. This effort was then picked up bu UNDP who sponsored the implementation of sililar systems in the Caribbean, Asia and Africa.

The developed conceptualisation, methodology and software tool is
called Disaster Inventory System - DesInventar (Sistema de Inventario de
Desastres).
<br>
<br>
The development of DesInventar, with its conception that makes visible
disasters from a local scale (town or equivalent), facilitates dialogue for
risk management between actors, institutions, sectors, provincial and
national governments.
<br>
<br>
DesInventar is a conceptual and methodological tool for the construction of
databases of loss, damage, or effects caused by emergencies or disasters. It
includes:
</p>
<p align="left">
<ul>
<li>Methodology (definitions and help in the management of data)</li>
<li>Database with flexible structure</li>
<li>Software to manage the database, including multi-user, remote data entry</li>
<li>Software for querying data (not limited to a predefined number of consultations) 
    with selection options for search criteria.</li>
</ul>
</p>
<p align="left"><a href="www.desinventar.net/DesInventar">
       <h4>Go to DesInventar Server 9.2.11 Online</h4></a>
	   <br/>
	   <br/>
</p>
</body>]]></description>
<%for (int j=0; j<8; j++)
			{%> 
<Style id="PStyle<%=j%>">    
   <PolyStyle>      
      <color>5f<%=getGoogleColor(countrybean.asMapColors[j])%></color>      
	  <colorMode>normal</colorMode>    
  </PolyStyle>  
</Style>
<%}%>


<% 
	   // the map has previously been used, first call triggered a full scan of the file, loading the index and polygons into memory
	   for (int j=0; j<mao.lArcs.size(); j++)
	   {
	   ArcObject arco=(ArcObject)(mao.lArcs.get(j));
	   // renderMapObject(g2, cBorderColor, cFillColor, countrybean, htData, m, arco, nShowIdType);
	   int nSize;
	   int i=0;
%>  <Placemark>    
    <name><%=arco.sName%></name>
	<%
	if (countrybean.htData==null)
		countrybean.htData=new HashMap(); // no data?
	//	countrybean.htData = new MapServer().CreateData(countrybean);
	Double odVal=(Double) (countrybean.htData.get(arco.sCode));
	double dVal=0;
	if (odVal!=null) 
		dVal=odVal.doubleValue();	
	int k=0;
	if (dVal!=0)
	{
	try{
		while ( (k < 10) && (countrybean.asMapRanges[k] < dVal) && (countrybean.asMapRanges[k] > 0))
		k++;
		}
		catch (Exception e) {}
	}
	%>   
	<styleUrl>#PStyle<%=k%></styleUrl>    
	<Polygon>      
	<extrude>0</extrude>      
	<tessellate>0</tessellate>
	<altitudeMode>clampToGround</altitudeMode>      
	<outerBoundaryIs>        
<%	   
	   for (k = 0; k<arco.numparts; k++)
	   		{
	 	  	nSize = arco.parts[k+1]-arco.parts[k];
			   %>
			<LinearRing>          
			  <coordinates>
			  <% for (int jj = 1; jj < nSize; jj++)
				     	{
				    	out.println(arco.xcoo[i]+","+arco.ycoo[i]+",0");
				    	i++;
				     	}%>
		      </coordinates>
			</LinearRing>      
<%		} %>
	</outerBoundaryIs>      
	</Polygon>  
	</Placemark>

<%	}%>
 	<ScreenOverlay id="NWILEGEND">
		<name>Leyenda</name>
		<Icon>
			<href><%=sProtocol%>://<%=sHost%><%=nPort==80?"":":"+nPort%>/DesInventar/MapLegendServer<%=EncodeUtil.xmlEncode(countrybean.getBookmark(request))%>&amp;mappingfunction=10&amp;transparencyf=0.4</href>
		</Icon>
		<overlayXY x="0" y="0" xunits="fraction" yunits="fraction"/>
		<screenXY x="0.005" y="0.02" xunits="fraction" yunits="fraction"/>
		<rotationXY x="0.5" y="0.5" xunits="fraction" yunits="fraction"/>
<!-- 		<size x="350" y="90" xunits="pixels" yunits="pixels"/> -->
	</ScreenOverlay>
	<ScreenOverlay id="DILogo">
		<name>&lt;a href=&quot;http://<%=sHost%><%=nPort==80?"":":"+nPort%>/&quot;&gt;DesInventar 7 Online&lt;/a&gt;</name>
		<Icon>
			<href>http://<%=sHost%><%=nPort==80?"":":"+nPort%>/DesInventar/images/DI_logo.gif</href>
		</Icon>
		<overlayXY x="0" y="1" xunits="fraction" yunits="fraction"/>
		<screenXY x="0.005" y="0.995" xunits="fraction" yunits="fraction"/>
		<rotationXY x="0.5" y="0.5" xunits="fraction" yunits="fraction"/>
		<size x="105" y="83" xunits="pixels" yunits="pixels"/>
	</ScreenOverlay>

 </Document>

</kml>