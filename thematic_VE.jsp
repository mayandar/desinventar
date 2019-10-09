<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page info="DesConsultar Dinamyc map" session="true" %>
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
<html>
<style>
<!--
.dragme{position:relative;}
-->
</style>
<script language="JavaScript1.2">
<!--

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

//-->
</script>


<head>
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
%>
<%
boolean bIEBrowser = (request.getHeader("User-Agent").indexOf("MSIE")>0);
boolean bIEdge = (request.getHeader("User-Agent").indexOf("Edge")>0);
String pname="";
String[] pval;
/// variables for future enhancements:	
double xm=-180,ym=-90,xx=180,yy=90;
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
if (countrybean.lmMaps[countrybean.level_map]!=null) // default DI map with scaling by 10000 transformation... TODO: check transf type
				  nTransf=countrybean.extendedParseInt(countrybean.lmMaps[countrybean.level_map].filetype);	  
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
<title>DesConsultar on-line Thematic Map</title>
        <link rel="stylesheet" href="OL_style.css" type="text/css" />
		<link rel="stylesheet" href="google.css" type="text/css">

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
		

<script src="/DesInventar/OpenLayers.js"></script>
<script type="text/javascript">
        // OL Map object 
		var map;
		
		
        function init()
		{
			var prjMS = new OpenLayers.Projection("EPSG:900913");
			var options = {
				projection        : prjMS,
				controls		  : [
		                        new OpenLayers.Control.Navigation()
		                        ,new OpenLayers.Control.PanZoomBar()
		                        ,new OpenLayers.Control.LayerSwitcher({'ascending':false})
		                        ,new OpenLayers.Control.ScaleLine()
		                        ,new OpenLayers.Control.MousePosition()
		                        //,new OpenLayers.Control.OverviewMap()
								,new OpenLayers.Control.KeyboardDefaults()
		                    ],
				numZoomLevels     : 22
			};

			map = new OpenLayers.Map('map', options);
		
			
			var apiKey='Au0PO4Uuq1UQ4VBHSfheRkZR5ev07nJ_Gvpdxfy_nhwHEf7KIc60VCYxJqn21Wuh';
			var apiKeyLoc='AhICMBa8Pg7rvWmhr7Sb2xf_CuBbySi-FpLCDUO33ZrLmGxUS59rEA7Tb-_zI6hL';


			
		   // DesInventar Thematic map.	If no background, it becomes the base layer
           var level0 = new OpenLayers.Layer.WMS( "DesInventar","http://"+window.location.hostname+":<%=nPort%>/DesInventar/jsmapserv?&SRS=EPSG:319009&transparencyf=<%=countrybean.dTransparencyFactor%>&rnd=<%=(int)(Math.random()*9999)%>",
				                                        {layers: 'effects<%=sLevelLayers%>', 'transparent':true, 'format':'png' },
														{'isBaseLayer':false} );
			level0.setVisibility(true);
			map.addLayer(level0);

			
			
			var ve = new OpenLayers.Layer.Bing({  name: "Bing map",  key: apiKey,  type: "Road"  });
			map.addLayer(ve);
			
			var sosm = new OpenLayers.Layer.OSM("OpenStreet");
        	map.addLayer(sosm);
		
			map.addControl(new OpenLayers.Control.LayerSwitcher());				
			bounds = new OpenLayers.Bounds(<%=MapTransformationSphericalGoogle.longToX(Math.max(-179,xm))%>,
			                               <%=MapTransformationSphericalGoogle.latToY(Math.max(-80,ym))%>,
										   <%=MapTransformationSphericalGoogle.longToX(Math.min(179,xx))%>,
										   <%=MapTransformationSphericalGoogle.latToY(Math.min(80,yy))%>);				
			map.zoomToExtent(bounds);		

        }
		
		// this assumes that the Map object is a JavaScript variable named "map"
var print_wait_win = null;
function PrintMap() 
  {
    //-- post a wait message
    alert("One moment please");

    // go through all layers, and collect a list of objects
    // each object is a tile's URL and the tile's pixel location relative to the viewport
    var offsetX = parseInt(map.layerContainerDiv.style.left);
    var offsetY = parseInt(map.layerContainerDiv.style.top);
    var size  = map.getSize();
    var tiles = [];
    for (layername in map.layers) 
	{
        // if the layer isn't visible at this range, or is turned off, skip it
        var layer = map.layers[layername];
        if (!layer.getVisibility()) continue;
        if (!layer.calculateInRange()) continue;
        // iterate through their grid's tiles, collecting each tile's extent and pixel location at this moment
        for (tilerow in layer.grid) 
		{
            for (tilei in layer.grid[tilerow]) 
			{
                var tile     = layer.grid[tilerow][tilei]
                var url      = layer.getURL(tile.bounds);
                var position = tile.position;
                var tilexpos = position.x + offsetX;
                var tileypos = position.y + offsetY;
                var opacity  = layer.opacity ? parseInt(100*layer.opacity) : 100;
                tiles[tiles.length] = {url:url, x:tilexpos, y:tileypos, opacity:opacity};

                alert("Tile:"+url +", x:"+tilexpos+", y:"+tileypos+", opacity:"+opacity);
				
            }
        }
    }

    // hand off the list to our server-side script, which will do the heavy lifting
	/*
    var tiles_json = JSON.stringify(tiles);
    var printparams = 'width='+size.w + '&height='+size.h + '&tiles='+escape(tiles_json) ;
    OpenLayers.Request.POST(
      { url:'lib/print.php',
        data:OpenLayers.Util.getParameterString({width:size.w,height:size.h,tiles:tiles_json}),
        headers:{'Content-Type':'application/x-www-form-urlencoded'},
        callback: function(request) {
           window.open(request.responseText);
        }
      }
    );
	*/
	
	
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
<%!
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
<table width="100%" border="1" class="pageBackground" rules="none"><tr><td valign="top">
<table border="0">
 <tr>
  <td align="left" nowrap><font color="Blue"><%=countrybean.getTranslation("Region")%>: </font><a href="javascript:routeTo('main.jsp')"><font class='regionlink'>
 <b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font></a>
  - [<jsp:getProperty name ="countrybean" property="countrycode"/>]&nbsp;&nbsp;
 </td>
 <td align="center" width="300"><span class="subTitle"><%=countrybean.getTranslation("ThematicMapGenerator")%></span>
 </td>
 <td align="right">
 &nbsp;&nbsp;<a href="javascript:routeTo('thematic_def.jsp')" class='linkText'><%=countrybean.getTranslation("Back2thematic")%>.</a>&nbsp;
 &nbsp;|&nbsp;<a href="javascript:routeTo('thematic_OL.jsp')" class='linkText'><%=countrybean.getTranslation("Dynamic Map")%></a>
 &nbsp;|&nbsp;<a href="javascript:routeTo('thematic_google.jsp')" class='linkText'><%=countrybean.getTranslation("Google Map")%></a>
 &nbsp;|&nbsp;<a href="/DesInventar/thematic_kml.jsp" class='linkText'><%=countrybean.getTranslation("KML")%></a>
 &nbsp;|&nbsp;<a href="/DesInventar/thematic_svg.jsp" class='linkText'><%=countrybean.getTranslation("SVG")%></a>

<!-- &nbsp;|&nbsp;<a href="" onClick="PrintMap();" class='linkText'><%=countrybean.getTranslation("Print")%></a> -->

 &nbsp;&nbsp;|
 
<form name="flayers" method='post' action="thematic_bgs.jsp">
 <input type='hidden' name='showcodes'  value='<%=showcodes%>'>
 <input type='hidden' name='usebaselayer'>
</form>
</td>
</tr>
</table>
<%
/// variables for future enhancements:	
String imgparams="?mappingfunction="+countrybean.DoTHEMATIC+"&transparencyf="+countrybean.dTransparencyFactor+"&rnd="+Math.round(Math.random()*99999);
%>
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" id="map_canvasTable">
<tr><td align="center" colspan="2">
<span class="title"><%=htmlServer.htmlEncode(countrybean.sTitle)%></span>
</td></tr>
 <tr>
	<td id="map_cell" align="left"   bgcolor="#ffffff" width="90%">
        <div id="map" style="font-size:8px;"></div>
	</td>
	<td align="left" valign="top">
	<!-- LEGEND --><img class='dragme' src='/DesInventar/MapLegendServer<%=imgparams %>' border=0><br><br>
	<!-- DI Layers --><%=sLayersControl%>
    </td>
 </tr>
 <tr>
	<td colspan="2" class='bss'><%=countrybean.getTranslation("dyn_explanation")%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=countrybean.getTranslation("paste_explanation")%></td>
 </tr>
<tr><td colspan="2"class="bss"><%=htmlServer.htmlEncode(countrybean.sSubTitle)%></td></tr>
<form name="desinventar" method='post' action="thematic_OL.jsp">
<INPUT type='hidden'  name="actiontab" id="actiontab">
<INPUT type='hidden'  name="frompage" value="<%=request.getServletPath()%>">
</form>
</td>
</tr>
</table>
<script language="JavaScript">
<!--

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
var overhead=0; //135;
idH=Math.max(idH-overhead,512);

idW=Math.max(idW-15,512);

document.getElementById("map_cell").height=idH;
document.getElementById("map").height=idH;
document.getElementById("map_canvasTable").height=idH;
document.getElementById("map_canvasTable").width=idW;
}
window.onresize = resizeDlg;
resizeDlg();
init();
// -->
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
