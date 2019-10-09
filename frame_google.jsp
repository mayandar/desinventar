<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
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
<% 
boolean bIEBrowser = (request.getHeader("User-Agent").indexOf("MSIE")>0);
boolean bIEdge = (request.getHeader("User-Agent").indexOf("Edge")>0);
String pname="";
String[] pval;
/// variables for future enhancements:	
double xm=-180,ym=-90,xx=180,yy=90;
String code=htmlServer.not_null(request.getParameter("code"));
String code0=htmlServer.not_null(request.getParameter("level0_code"));
String code1=htmlServer.not_null(request.getParameter("level1_code"));
String showcodes=htmlServer.not_null(request.getParameter("showcodes"));
int level_act=countrybean.extendedParseInt(request.getParameter("level_act"));

// ensures the data is retrieved...
countrybean.htData=null;


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

 int nPort=request.getLocalPort();

/// variables for future enhancements:	
String imgparams="&transparencyf=0.6";
//if (bIEBrowser)
//   imgparams+="&countrycode="+countrybean.countrycode;
%>
<%@ include file="/layerControl.jspf" %> 
<%@ include file="/googlekeys.jspf" %> 
 
<title>DesConsultar on-line Thematic Map</title>

        <style type="text/css">
            #map {
                width: 100%;
                height: 100%;
                border: 1px solid black;
            }

            #text {
                position: absolute;
                bottom: 0px;
                left:0px;
                width: 512px;
            }
        </style>
        <script src="https://maps.google.com/maps?file=api&amp;v=2.x&key=<%=sGoogleKey%>" type="text/javascript"></script>
		<script src="/DesInventar/wms236.js" type="text/javascript"></script>		
		<script type="text/javascript">
// best to declare your map variable outside of the function so that you can access it from other functions
var map;

function initialize() 
{
  if (GBrowserIsCompatible()) {
	//	set up the map	
	map = new GMap2(document.getElementById("map_canvas")); 
	
	//	set up your wms layer
	var desinventar_layer;
	desinventar_layer= new GTileLayer(new GCopyrightCollection(""),1,17);
	
   //	these are the layers from your mapserver map file	
	desinventar_layer.myLayers =  'effects<%=sLevelLayers%>';
	desinventar_layer.myMercZoomLevel=5;
	desinventar_layer.myFormat='image/gif';
	
    //	this is the address of your mapserver map	
	desinventar_layer.myBaseURL= 'http://'+window.location.hostname+':<%=nPort%>/DesInventar/jsmapserv?rnd='+Math.round(Math.random()*99999)+"<%=imgparams%>";
	
	//	this is the function performed by John Deck's script	
	desinventar_layer.getTileUrl=CustomGetTileUrl;		
	
	//	this specifies the opacity of your layer	
	desinventar_layer.getOpacity = function() {return 1.0;}

	map.addControl(new GLargeMapControl());
	//map.addControl(new GMapTypeControl());
	//map.addMapType(G_PHYSICAL_MAP);
	//map.setMapType(G_PHYSICAL_MAP);
		
	var bounds = new GLatLngBounds();
	bounds.extend(new GLatLng(-85,-179));
	bounds.extend(new GLatLng( 85,179));
	//	set the location of the map	 
	//map.setCenter(new GLatLng(20,20),map.getBoundsZoomLevel(bounds));	
    map.setCenter(new GLatLng(20,20),1);	
    // for debug: alert("zoom level="+map.getBoundsZoomLevel(bounds))	;

    //	add wms layer with GTileLayerOverlay
	var MapserverLayer = new GTileLayerOverlay(desinventar_layer);
	map.addOverlay(MapserverLayer);
	map.enableScrollWheelZoom();

	}
}
</script>

</head>
<body marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" onload="initialize()">
<form name="flayers" method='post' action="thematic_OL.jsp">
 <input type='hidden' name='code'  value='<%=code%>'>
 <input type='hidden' name='level0_code' value='<%=code0%>'>
 <input type='hidden' name='level1_code' value='<%=code1%>'>
 <input type='hidden' name='showcodes'  value='<%=showcodes%>'>
 <input type='hidden' name='usebaselayer'>
</form>
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="400" id="map_canvasTable">
 <tr>
	<td id="map_cell" align="left" bgcolor="#ffffff" width="100%" height="400" >
	<div id="map_canvas" style="width: 100%; height: 400"></div>
	</td>
 </tr>
<form name="desinventar" method='post' action="thematic_OL.jsp">
<input type='hidden' name='nStart' value=''>
<INPUT type='hidden'  name="actiontab" id="actiontab">
<INPUT type='hidden'  name="frompage" value="<%=request.getServletPath()%>">

</form>
</td>
</tr>
</table>
<script language="JavaScript">

function sendIEHttpRequest() 
{
	var request;
	var async = true;
	
  	if (window.ActiveXObject) {
 		request = new ActiveXObject("Microsoft.XMLHTTP");
		request.open("GET", "https://www.desinventar.net/DesInventar/getTip.jsp?countrycode=wo3", async);	
	}
}

sendIEHttpRequest();


</script>


<%
dbCon.close();
%>

</td>
</tr>
</table>
</body>
</html>
