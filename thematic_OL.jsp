<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
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
<%@ taglib uri="inventag.tld" prefix="inv" %>
<title>DesConsultar on-line Thematic Map</title>
<link rel="stylesheet" href="OL_style.css" type="text/css" />
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

		
//String sHost=request.getRemoteHost();
// gets this URL
String sRequest=new String(request.getRequestURL());
// gets the hostname
URL thisURL=new URL(sRequest);
String sHost=thisURL.getHost();
%><!-- <%=sHost%> -->

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
.dragme{position:relative;}
</style>

<script src="/DesInventar/OpenLayers.js"></script>

<script language="javascript">

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
<script type="text/javascript">

        // OL Map object 
		var map;
		
		function addLayer(sLayerName, sUrl, sLayer)
		{
			var lay = new OpenLayers.Layer.WMS(sLayerName, sURL, 
					{'layers':sLayer, 'transparent':false, 'format':'png' },
					{'isBaseLayer':true });
			lay.setVisibility(true);
			map.addLayer(lay);
		
		}
<% 
   boolean bIsDIbase=true;
   if (request.getParameter("usebaselayer")!=null)
   	if (!"N".equals(request.getParameter("usebaselayer")))
   		bIsDIbase=false;
  int nPort=request.getLocalPort();
  double dTransp=countrybean.dTransparencyFactor;
  if (bIsDIbase)
    dTransp=1.0; 
%>				
<%@ include file="/layerControl.jspf" %> 
            function init(){
				// create the basic OpenLayers Map object:	
                map = new OpenLayers.Map('map'
				, {
                    controls: [
                        new OpenLayers.Control.Navigation()
                        ,new OpenLayers.Control.PanZoomBar()
                        ,new OpenLayers.Control.LayerSwitcher({'ascending':false})
                        ,new OpenLayers.Control.ScaleLine()
                        ,new OpenLayers.Control.MousePosition()
                        //,new OpenLayers.Control.OverviewMap()
						,new OpenLayers.Control.KeyboardDefaults()
                    ]});
	
		   // DesInventar Thematic map.	If no background, it becomes the base layer
		   
           var level0 = new OpenLayers.Layer.WMS( "DesInventar","http://"+window.location.hostname+":<%=nPort%>/DesInventar/jsmapserv?transparencyf=<%=dTransp%>&rnd=<%=(int)(Math.random()*9999)%>",
				                                        {layers: 'effects<%=sLevelLayers%>', 'transparent':true, 'format':'png' },
														{'isBaseLayer':<%=bIsDIbase%>} );
			level0.setVisibility(true);
			map.addLayer(level0);
				
			// if background is requested, several alternatives are given from metacarta 
			<%if (!bIsDIbase){%>		  
			
			var metc = new OpenLayers.Layer.WMS("Metacarta basic",
					"http://labs.metacarta.com/wms/vmap0", 
					{'layers':'basic', 'transparent':false, 'format':'png' },
					{'isBaseLayer':true });
			metc.setVisibility(true);
			map.addLayer(metc);

			var mets = new OpenLayers.Layer.WMS("Metacarta satellite",
					"http://labs.metacarta.com/wms/vmap0", 
					{'layers':'satellite', 'transparent':false, 'format':'png' },
					{'isBaseLayer':true });
			mets.setVisibility(true);
			map.addLayer(mets);
// http://preview.grid.unep.ch:8080/geoserver/wms?bbox=60.50417    ,29.40611   ,74.91574    ,38.47198   &styles=&Format=image/png&request=GetMap&version=1.1.1&layers=preview:fl_events&width=640&height=309&srs=EPSG:4326
// http://preview.grid.unep.ch:8080/geoserver/wms s=&=GetMap&version=1.1.1&layers=preview:fl_events&width=640&height=309&srs=EPSG:4326			
//					{'layers':'preview:eq_events', 'transparent':false, 'format':'image/png' },

 <%         
		try{
				ServletContext sc = getServletConfig().getServletContext();

				String sCapabilitiesXML=sc.getRealPath("ows.xml");				
				File f=new File (sCapabilitiesXML);
				if (f.exists() && f.isFile() && f.canRead())
				{
					WMSGetCapabilitiesReader WmsCaps = new WMSGetCapabilitiesReader(sCapabilitiesXML);

					try {
						WmsCaps.start();					
					}
					catch (Exception exml)
					{
						System.out.println("[DI9] Error reported by WMS_XML importer:"+exml.toString());
					}
				for (int j=0; j<WmsCaps.vLayers.size(); j++)
					{
					String sLayer=(String)(WmsCaps.vLayers.get(j));
					String sLName=(String)(WmsCaps.vLayerNames.get(j));
					sLayer=sLayer.replace("\n","").trim();
					if (sLayer.length()>20)
					  sLayer=sLayer.substring(0,20)+"...";
					%>
				    var prev<%=j%> = new OpenLayers.Layer.WMS('<%=sLayer%>',"http://preview.grid.unep.ch/geoserver/wms", 
						{'layers':'<%=sLName%>', 'transparent':false, 'format':'image/png' },	{'isBaseLayer':true });
				    prev<%=j%>.setVisibility(true);
				    map.addLayer(prev<%=j%>);
<%					}
				}				
			}
			catch (Exception ex)
			{
			System.out.println("[DI9] Exception thrown:"+ex.toString());
			}
           }%>
                map.addControl(new OpenLayers.Control.LayerSwitcher());				
				bounds = new OpenLayers.Bounds(<%=xm%>,<%=ym%>,<%=xx%>,<%=yy%>);				
                map.zoomToExtent(bounds);
				
<%			if (request.getHeader("User-Agent").indexOf("Safari")>=0){ %>
				this.touchhandler = new TouchHandler( map, 4 );
<%}%>

            }
        </script>
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
 <td align="right">&nbsp;&nbsp;<a href="javascript:routeTo('thematic_def.jsp')" class='linkText'><%=countrybean.getTranslation("Back2thematic")%>.</a>&nbsp;
&nbsp;|&nbsp;<a href="javascript:routeTo('thematic_google.jsp')" class='linkText'><%=countrybean.getTranslation("Google Map")%></a>
&nbsp;|&nbsp;<a href="javascript:routeTo('thematic_VE.jsp')" class='linkText'><%=countrybean.getTranslation("Virtual Earth")%></a>
&nbsp;|&nbsp;<a href="/DesInventar/thematic_kml.jsp" class='linkText'><%=countrybean.getTranslation("KML")%></a>
&nbsp;|&nbsp;<a href="/DesInventar/thematic_svg.jsp" class='linkText'><%=countrybean.getTranslation("SVG")%></a>
&nbsp;&nbsp;|&nbsp;<font size="1"><%=countrybean.getTranslation("Background")%>:</font><a href="javascript:sendBaseLayerOn()" class='linkText'><%=countrybean.getTranslation("ON")%></a>
<a href="javascript:sendBaseLayerOff()" class='linkText'><%=countrybean.getTranslation("OFF")%></a>
<form name="flayers" method='post' action="thematic_OL.jsp">
 <input type='hidden' name='showcodes'  value='<%=showcodes%>'>
 <input type='hidden' name='usebaselayer'>
</form>
<script language="JavaScript">
function sendBaseLayerOn()
{
document.flayers.usebaselayer.value="Y";
document.flayers.submit();
}

function sendBaseLayerOff()
{
document.flayers.usebaselayer.value="N";
document.flayers.submit();
}
</script>
</td>
</tr>
</table>
<%
/// variables for future enhancements:	
String imgparams="?mappingfunction="+countrybean.DoTHEMATIC+"&transparencyf="+dTransp+"&rnd="+Math.round(Math.random()*99999);
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

function resizeDlg(){
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
<br/><%=request.getHeader("User-Agent")%>
</body>
</html>
