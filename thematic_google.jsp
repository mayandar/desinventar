<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<style>
.dragme {
	position:relative;
}
</style>
<script language="JavaScript">

var ie=document.all;
var nn6=document.getElementById&&!document.all;

var isdrag=false;
var x,y;
var dobj;

function movemouse(e)
{
  if (isdrag)
  {
    dobj.style.left = nn6 ? tx + e.clientX - x : tx + event.clientX - x;
    dobj.style.top  = nn6 ? ty + e.clientY - y : ty + event.clientY - y;
    return false;
  }
}

function selectmouse(e) 
{
  var fobj       = nn6 ? e.target : event.srcElement;
  var topelement = nn6 ? "HTML" : "BODY";

  while (fobj.tagName != topelement && fobj.className != "dragme")
  {
    fobj = nn6 ? fobj.parentNode : fobj.parentElement;
  }

  if (fobj.className=="dragme")
  {
    isdrag = true;
    dobj = fobj;
    tx = parseInt(dobj.style.left+0);
    ty = parseInt(dobj.style.top+0);
    x = nn6 ? e.clientX : event.clientX;
    y = nn6 ? e.clientY : event.clientY;
    document.onmousemove=movemouse;
    return false;
  }
}

document.onmousedown=selectmouse;
document.onmouseup=new Function("isdrag=false");
</script>
<%@ page info="DesConsultar simple results page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@page import="java.net.*" %>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.map.*" %>
<%@ page import="org.lared.desinventar.webobject.fichas" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" /><%@ include file="/util/opendatabase.jspf" %>
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
  /** java.awt.Color from an HTML color  string #RRGGBB */
String BWfromColorString(String strColor)
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

%>
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
countrybean.htEvents=null;

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
<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyByVWfVCeED7LjjNRgxgTluLPGSenzMgAw&sensor=false"></script>
<script type="text/javascript">
// best to declare your map variable outside of the function so that you can access it from other functions
var map;


function initialize() 
{

    var latlng = new google.maps.LatLng(<%=(yy+ym)/2%>,<%=(xx+xm)/2%>);    
	var myOptions ={zoom: 3,      
					center: latlng,      
					panControl: false,    zoomControl: true,    scaleControl: true,
					mapTypeId: google.maps.MapTypeId.TERRAIN    
					};    
	map = new google.maps.Map(document.getElementById("map_canvas"),        myOptions);
	
	map.fitBounds(new google.maps.LatLngBounds(
								new google.maps.LatLng(<%=Math.max(-80,ym)%>,<%=Math.max(-179,xm)%>),
							    new google.maps.LatLng(<%=Math.min(80,yy)%>,<%=Math.min(179,xx)%>) 
	                           	));


    var desinventar_layer = new google.maps.ImageMapType({
                    getTileUrl: function (coord, zoom) {
                        var proj = map.getProjection();
                        var zfactor = Math.pow(2, zoom);
                        // get Long Lat coordinates
                        var top = proj.fromPointToLatLng(new google.maps.Point(coord.x * 256 / zfactor, coord.y * 256 / zfactor));
                        var bot = proj.fromPointToLatLng(new google.maps.Point((coord.x + 1) * 256 / zfactor, (coord.y + 1) * 256 / zfactor));
                        var bbox =     top.lng() + "," + bot.lat() + "," + bot.lng() + "," + top.lat() ;

                        //base WMS URL
                        var url = 'http://'+window.location.hostname+':<%=nPort%>/DesInventar/jsmapserv?rnd='+Math.random();
                        url += "&REQUEST=GetMap"; //WMS operation
                        url += "&SERVICE=WMS";    //WMS service
                        url += "&VERSION=1.1.1";  //WMS version  
                        url += "&LAYERS=" + 'effects<%=sLevelLayers%>'; //WMS layers
                        url += "&FORMAT=image/png" ; //WMS format
                        url += "&BGCOLOR=0xFFFFFF";  
                        url += "&TRANSPARENT=TRUE";
                        url += "&SRS=EPSG:900913";     //set WGS84 
                        url += "&BBOX=" + bbox;      // set bounding box
                        url += "&WIDTH=256";         //tile size in google
                        url += "&HEIGHT=256";
                        return url;                 // return URL for the tile

                    },
                    tileSize: new google.maps.Size(256, 256),
                    isPng: true
                });
  
         //add WMS layer
        map.overlayMapTypes.push(desinventar_layer);
}


</script>
</head>
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/header",countrybean.getLanguage(),out);%>
<%
int nTabActive=7; // thematic
String[] sTabNames={countrybean.getTranslation("Profile"),countrybean.getTranslation("Query"),countrybean.getTranslation("ViewData"),countrybean.getTranslation("ViewMap"),
           countrybean.getTranslation("Charts"),countrybean.getTranslation("Statistics"),countrybean.getTranslation("Reports"),
		   countrybean.getTranslation("Thematic"), countrybean.getTranslation("Crosstab")};
String[] sTabIcons={"check.gif","icon_query.gif","icon_viewdata.gif","icon_viewmap.gif","icon_charts.gif","icon_statistics.gif",
                    "icon_reports.gif","icon_thematic.gif","xtab.gif"};
String[] sTabLinks={"javascript:routeTo('profiletab.jsp')","javascript:routeTo('main.jsp')","javascript:routeTo('results.jsp')","javascript:routeTo('maps.jsp')",
				"javascript:routeTo('graphics.jsp')","javascript:routeTo('definestats.jsp')","javascript:routeTo('generator.jsp')",
				"javascript:routeTo('thematic_def.jsp')","javascript:routeTo('definextab.jsp')"};
%>
<%@ include file="/util/tabs.jspf" %>
<table width="100%" border="1" class="pageBackground" rules="none">
  <tr>
  <td valign="top">
  
  <table border="0">
    <tr>
      <td align="left" nowrap><font color="Blue"><%=countrybean.getTranslation("Region")%>: </font><a href="javascript:routeTo('main.jsp')"><font class='regionlink'> <b><i>
        <jsp:getProperty name ="countrybean" property="countryname"/>
        </i></b></font></a> - [
        <jsp:getProperty name ="countrybean" property="countrycode"/>
        ]&nbsp;&nbsp; </td>
      <td align="center" width="350"><span class="subTitle"><%=countrybean.getTranslation("ThematicMapGenerator")%></span> </td>
      <td align="right">&nbsp;&nbsp;<a href="javascript:routeTo('thematic_def.jsp')" class='linkText'><%=countrybean.getTranslation("Back2thematic")%></a> &nbsp;|&nbsp;<a href="javascript:routeTo('thematic_OL.jsp')" class='linkText'><%=countrybean.getTranslation("Dynamic Map")%></a> &nbsp;|&nbsp;<a href="javascript:routeTo('thematic_VE.jsp')" class='linkText'><%=countrybean.getTranslation("Virtual Earth")%></a> &nbsp;|&nbsp;<a href="/DesInventar/thematic_kml.jsp" class='linkText'><%=countrybean.getTranslation("KML")%></a> &nbsp;|&nbsp;<a href="/DesInventar/export_kml.jsp" class='linkText'><%=countrybean.getTranslation("KML-Vector")%></a> &nbsp;|&nbsp;<a href="/DesInventar/thematic_svg.jsp" class='linkText'><%=countrybean.getTranslation("SVG")%></a>
        <form name="flayers" method='post' action="thematic_OL.jsp">
          <input type='hidden' name='code'  value='<%=code%>'>
          <input type='hidden' name='level0_code' value='<%=code0%>'>
          <input type='hidden' name='level1_code' value='<%=code1%>'>
          <input type='hidden' name='showcodes'  value='<%=showcodes%>'>
          <input type='hidden' name='usebaselayer'>
        </form></td>
    </tr>
  </table>
  <%
/// variables for future enhancements:	
String imgparams="?mappingfunction="+countrybean.DoTHEMATIC+"&transparencyf="+countrybean.dTransparencyFactor+"&rnd="+Math.round(Math.random()*99999);
%>
  <table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" id="map_canvasTable">
    <tr>
      <td align="center" colspan="2"><span class="title"><%=htmlServer.htmlEncode(countrybean.sTitle)%></span> </td>
    </tr>
    <tr>
      <td id="map_cell" align="left" bgcolor="#ffffff" width="100%" height="100%" ><div id="map_canvas" style="width: 100%; height: 100%"></div></td>
      <td align="left" valign="top"><!-- LEGEND -->
        <img src='/DesInventar/MapLegendServer<%=imgparams %>' class='dragme' border=0> <br>
        <br>
        <!-- DI Layers -->
        <%=sLayersControl%> </td>
    </tr>
    <tr>
      <td colspan="2" class='bss'><%=countrybean.getTranslation("google_explanation")%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=countrybean.getTranslation("paste_explanation")%></td>
    </tr>
    <tr>
      <td colspan="2"><span class="bss"><%=htmlServer.htmlEncode(countrybean.sSubTitle)%></span> </td>
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

function submitForm(istart)
{
document.desinventar.nStart.value=istart;
document.desinventar.submit();
}

function resizeDlg()
{
var idW=1000;
var idH=750;	
<% if (bIEBrowser) { %>
	idW = document.body.clientWidth; 
	idH = document.body.clientHeight; 
	<% } else { %>
	idH = window.outerHeight-150;
	idW = window.outerWidth; 
	<% } %>
var overhead=0;//140;
idH=Math.min(1400,Math.max(idH-overhead,512));
idW=Math.max(idW,512);
document.getElementById("map_cell").height=idH;
document.getElementById("map_canvas").height=idH;
document.getElementById("map_canvasTable").height=idH;
document.getElementById("map_canvasTable").width=idW;
}
window.onresize = resizeDlg;
resizeDlg();
initialize();

</script>
  <%
dbCon.close();
%>
  </td>
  
  </tr>
  
</table>
<%@ include file="/html/footer.html" %>
</body>
</html>
