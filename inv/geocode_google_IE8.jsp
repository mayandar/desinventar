<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
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
<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%if (user.iusertype<20) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}%>
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

// ensures the data is NOT retrieved... we don't want colors here
countrybean.htData=new HashMap();

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

HashMap  hGoogleKeys=new HashMap();


hGoogleKeys.put("localhost", 				"ABQIAAAAhd44-6kCwRi5MmbzS9iplRT2yXp_ZAY8_ufC3CFXhHIE1NvwkxTAgprKkxYALJMxLqtTkIj7RlOcPg");
hGoogleKeys.put("desinventar", 				"ABQIAAAAhd44-6kCwRi5MmbzS9iplRTS6jzxg57uaPPzAtHhggi9bVK_axQNa0Kaa38RFPpbwlUeX1EXzKZLPQ");
hGoogleKeys.put("www.desinventar.net", 		"ABQIAAAAhd44-6kCwRi5MmbzS9iplRSrn-KtM_IX8cZWqa1Z3yaaaCwAlhQVwRTZ8QlQJO7yN87WJ3tIyCpGvQ");
hGoogleKeys.put("undp.deinventar.net", 		"ABQIAAAAhd44-6kCwRi5MmbzS9iplRQdQk_7cEOxxVjJhqn_v63jV1gf-xT-tPNYePqJLWRCXlUKML9I29EFJw");
hGoogleKeys.put("gar-isdr.desinventar.net", "ABQIAAAAhd44-6kCwRi5MmbzS9iplRSG7eSSqty5cerjt_inlYQb0-9YWBS2Q-xyQwtm3kB3H5wZT7Fn88Whmg");
hGoogleKeys.put("www.gripweb.org", 			"ABQIAAAAhd44-6kCwRi5MmbzS9iplRRYRpEcIErehx7qxUYBuU9oDmC2uBRYFT9zJHhWFBRHya3HR3lV2rQH_A");
hGoogleKeys.put("moz.gripweb.org", 			"ABQIAAAAhd44-6kCwRi5MmbzS9iplRS0tuJMY191T8Z7RHtK9TA4nAAvtxT9PePRraWoC7cS3fnd2xnZSx6R6Q");
hGoogleKeys.put("www.desinventar.lk", 		"ABQIAAAAhd44-6kCwRi5MmbzS9iplRQHattnIS4Ev7F3UBTx2GRv0azCgBRKc7olLBXphsfD6QEmy5yvkpP-ww");




//String sHost=request.getRemoteHost();
// gets this URL
String sRequest=new String(request.getRequestURL());
// gets the hostname
URL thisURL=new URL(sRequest);
   String sHost=thisURL.getHost();
String sGoogleKey= (String)hGoogleKeys.get(sHost);
if (sGoogleKey==null)
  sGoogleKey="ABQIAAAAhd44-6kCwRi5MmbzS9iplRT2yXp_ZAY8_ufC3CFXhHIE1NvwkxTAgprKkxYALJMxLqtTkIj7RlOcPg";
			
 boolean bIsDIbase=true;
   String sLevelLayers="";
   for (int k=0; k<countrybean.level_map; k++)
   	sLevelLayers+=",level"+k;
   if (countrybean.imLayerMaps!=null)
     for (int k=0; k<countrybean.imLayerMaps.length; k++)
   		sLevelLayers+=",layer"+k;
   if (request.getParameter("usebaselayer")!=null)
   	if (!"N".equals(request.getParameter("usebaselayer")))
   		bIsDIbase=false;
int nPort=request.getLocalPort();

int MAXIMUM_TO_GEOCODE=100;
if (request.getParameter("max_elements")!=null)
    MAXIMUM_TO_GEOCODE=countrybean.extendedParseInt(request.getParameter("max_elements")); 
		
%>
 
<title>DesConsultar on-line Google Geocoder Map</title>

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
	desinventar_layer.myFormat='image/png';
	
//	this is the address of your mapserver map	
	desinventar_layer.myBaseURL= 'http://'+window.location.hostname+':<%=nPort%>/DesInventar/jsmapserv?rnd='+Math.round(Math.random()*99999);
	
//	this is the function performed by John Deck's script	
	desinventar_layer.getTileUrl=CustomGetTileUrl;		
	
//	this specifies the opacity of your layer	
	desinventar_layer.getOpacity = function() {return 1.0;}

	map.addControl(new GLargeMapControl());
	map.addControl(new GMapTypeControl());
	map.addMapType(G_PHYSICAL_MAP);
	//map.setMapType(G_PHYSICAL_MAP);
		
	var bounds = new GLatLngBounds();
	bounds.extend(new GLatLng(<%=ym%>,<%=xm%>));
	bounds.extend(new GLatLng(<%=yy%>,<%=xx%>));
	//	set the location of the map	 
	map.setCenter(new GLatLng(<%=(yy+ym)/2%>,<%=(xx+xm)/2%>),map.getBoundsZoomLevel(bounds));	
	

    //	add wms layer with GTileLayerOverlay
	var MapserverLayer = new GTileLayerOverlay(desinventar_layer);
	map.addOverlay(MapserverLayer);
	map.enableScrollWheelZoom();

	}
}

var request;
function checkResults()
{
if (request.readyState==4)
  {// 4 = "loaded"
  if (request.status==200)
    {// 200 = OK
	// do nothing
    }
  else
    {
    alert("Problem updating coords.. data");
    }
  }
 
}
 
 
function sendHttpRequest(url) 
{
//alert("URL="+url);
 
     if (window.XMLHttpRequest) 
		request = new XMLHttpRequest();
	 else if (window.ActiveXObject) 
		request = new ActiveXObject("Microsoft.XMLHTTP");
	 else 
		return null;
			
	   request.open("GET", url, true);
	
       request.onreadystatechange = checkResults;	
       request.send(null);
       return request;
}


var g_request;
function sendHttpGeocodeRequest(url, callback) 
{
//alert("URL="+url);
 
     if (window.XMLHttpRequest) 
		g_request = new XMLHttpRequest();
	 else if (window.ActiveXObject) 
		g_request = new ActiveXObject("Microsoft.XMLHTTP");
	 else 
		return null;
			
	   g_request.open("GET", url, true);
	
       g_request.onreadystatechange = callback;	
       g_request.send(null);
       return g_request;
}
 

</script>

</head>
<body marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class="bodyclass"  bgcolor="#C9C8A9" onLoad="initialize()">
<table width="100%" border="1" class="pageBackground" rules="none"><tr><td valign="top">
<table border="0">
 <tr>
  <td align="left" nowrap><font color="Blue"><%=countrybean.getTranslation("Region")%>: </font><font class='regionlink'>
 <b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font>
  - [<jsp:getProperty name ="countrybean" property="countrycode"/>]&nbsp;&nbsp;
 </td>
 <td align="center" width="350"><span class="subTitle"><%=countrybean.getTranslation("Google-Geocoder")%></span>
 </td>
 <td align="right">&nbsp;&nbsp;<a href="lev0Manager.jsp" class='linkText'><%=countrybean.getTranslation("Done")%></a>
</td>
</tr>
</table>
<%
/// variables for future enhancements:	
String imgparams="?mappingfunction="+countrybean.DoTHEMATIC+"&transparencyf="+countrybean.dTransparencyFactor+"&rnd="+Math.round(Math.random()*99999);
%>
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" id="map_canvasTable">
<tr><td align="center" colspan="2">
<span class="title"><%=countrybean.sTitle%></span>
</td></tr>
 <tr>
	<td id="map_cell" align="left" bgcolor="#ffffff" width="100%" height="100%" >
	<div id="map_canvas" style="width: 100%; height: 100%"></div>
	</td>
	<td nowrap="nowrap"><a href='javascript:geocodePlace(null)'>Start Geoding!</a><br>
	<a href='geocode_google_IE8.jsp?max_elements=<%=MAXIMUM_TO_GEOCODE%>'>Get Next set</a><br>
		<form name="desinventar" method='post' action="geocode_google_IE8.jsp">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
		Max. points:<br>
		<input type="text" maxlength="4" size="5" name="max_elements" value="<%=MAXIMUM_TO_GEOCODE%>"><br>
		<input type="submit" name="cgh" value="change">
		</form>
	</td>
 </tr>
 <tr>
	<td colspan="2">Double-click to zoom in, and drag to pan. Use controls to zoom out and select background. </td>
 </tr>
<tr><td colspan="2">
<span class="bss"><%=countrybean.sSubTitle%></span>
</td></tr>
</td>
</tr>
</table>
<script language="JavaScript">

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
var overhead=140;
var xoverhead=50;
//idH=Math.max(idH-overhead,512);
//idW=Math.max(idW-xoverhead,512);
document.getElementById("map_cell").height=idH;
document.getElementById("map_canvas").height=idH;
document.getElementById("map_canvasTable").height=idH;
document.getElementById("map_canvasTable").width=idW;
}
window.onresize = resizeDlg;
resizeDlg();

// GEOCODING STUFF:
<% 
// produces the list with elements to geocode:
// a scrollable cursor is required to move quickly to start of records
stmt=con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
//stmt=con.createStatement();
String sLatLonNotSet=" and ("+countrybean.sqlNvl("latitude",0)+"=0 or "+countrybean.sqlNvl("longitude",0)+"=0)";
String sSql="select count(*) as nhits "+countrybean.getWhereSql()+sLatLonNotSet;
// out.println("<!-- "+sSql+ " [dbtype="+countrybean.dbType+","+countrybean.country.ndbtype+"; k="+countrybean.sqlStringConstant()+"] -->");
try
	{
	rset=stmt.executeQuery(sSql);
	}
	catch (Exception e){out.println("<!-- "+e.toString()+" -->");}
	
int nHits=0;
if (rset!=null && rset.next())
  nHits=rset.getInt("nhits");
  
sSql="select fichas.clave, fichas.serial, clave_ext as ex_clave_ext, eventos.nombre as event,  eventos.nombre_en as event_en, lev0.lev0_name as name0,  lev0.lev0_name_en as name0_en ,"+
	 "lev1.lev1_name as name1, lev1.lev1_name_en as name1_en, lev2.lev2_name as name2, lev2.lev2_name_en as name2_en,lugar "
     +countrybean.getWhereSql()+sLatLonNotSet+" order by " +countrybean.getSortbySql();

// out.println("<!--  "+sSql+" -->"); 
try
	{
	rset=stmt.executeQuery(sSql);
	}
catch (Exception e)
{
out.println("//<br><br><strong>ERROR: there has been an error executing your query: </strong>: "+e.toString()+"<br><br><br>");
}
int nStart=htmlServer.extendedParseInt(request.getParameter("nStart"));
try
{
if (nStart>1)
  rset.absolute(nStart);
}
catch (Exception e)
{
out.println("<!-- absolute: "+e.toString()+" -->");
}
nHits=0;
try
{
   String sComma="";
   out.println("var aLocations=[");
   while (rset!=null && rset.next() && nHits<MAXIMUM_TO_GEOCODE)
		{
		int nClave=rset.getInt("clave");
		out.println(sComma+"["+nClave+",'"+
					EncodeUtil.jsEncode(rset.getString("name0"))+"','"+    //[1]
					EncodeUtil.jsEncode(rset.getString("name0_en"))+"','"+ //[2]
					EncodeUtil.jsEncode(rset.getString("name1"))+"','"+	   //[3]
					EncodeUtil.jsEncode(rset.getString("name1_en"))+"','"+ //[4]
					EncodeUtil.jsEncode(rset.getString("name2"))+"','"+    //[5]
					EncodeUtil.jsEncode(rset.getString("name2_en"))+"','"+ //[6]
					EncodeUtil.jsEncode(rset.getString("lugar"))+"']");    //[7]
		sComma=",";
		nHits++;
		}
    out.println("];  // end vector aLocations");
}
catch (Exception e)
{
out.println("<!-- MAIN  loop: "+e.toString()+" -->");
}
try
	{
	rset.close();
	stmt.close();
	}
catch (Exception e)
{out.println("<!-- closing:"+e.toString()+" -->");}	
%>

var geocoder = new GClientGeocoder();
var iLoc=-1;
var iLev=-1;  // ready for next
var sLocation="";
var apAddresses=new Array(30);

function saveFinalLocation(FinalLoc)
{
if (FinalLoc)
	{
	var marker = new GMarker(FinalLoc, {title:aLocations[iLoc][2]+","+aLocations[iLoc][4]+" "+aLocations[iLoc][6]});  //] apAddresses[iLev]       
	map.addOverlay(marker);
	var sURL="/DesInventar/inv/saveCoordinates.jsp?latitude="+FinalLoc.lat()+"&longitude="+FinalLoc.lng()+"&key="+aLocations[iLoc][0];  
	sendHttpRequest(sURL)      
	}
else
   alert ("Definitely Not found: ["+iLoc+"]["+iLev+"] loc="+aLocations[iLoc][4]+"/"+aLocations[iLoc][5]);
	
}

function geocodePlace() 
{  
 if (iLoc>=0) // process did start, check the result.
     {
		if (g_request.readyState==4) // 4 = "loaded"
		  {
		  if (g_request.status==200)
		    {
			// do nothing
		    }
		  else
		    {
		    alert("Problem getting coords.. ");
		    }
		  }
		else
		  return;  
	 var sCoords=g_request.responseText;
	 var istart=sCoords.indexOf("<coordinates>");
	 if (istart>0)
	 	{
		 sCoords=sCoords.substring(istart+13);
	 	 istart=sCoords.indexOf(",");
		 var nLon=sCoords.substring(0,istart)*1.0;
		 sCoords=sCoords.substring(istart+1);
	 	 istart=sCoords.indexOf(",");
		 var nLat=sCoords.substring(0,istart)*1.0;
		 var point=new GLatLng(nLat,nLon);
		 saveFinalLocation(point);
		 }
	 // move to next location
	 iLev=0;
	 }	  
 // move to next (either next location or higher level in same location)
 sLocation="";
 while (sLocation.length==0 && iLoc<<%=nHits%>)
 	{
	 iLev--;
	 if (iLev<0) // level was completed, next point!
		{
		iLev=0;
		iLoc++;
	 	if (iLoc<<%=nHits%>) 
			{
	        apAddresses[iLev++]=aLocations[iLoc][1];      // lev0 local name; last to be checked
	        if (aLocations[iLoc][2]!=aLocations[iLoc][1])
			   apAddresses[iLev++]=aLocations[iLoc][2];   // lev0 english;
	        if (aLocations[iLoc][3].length>0 && aLocations[iLoc][4]!=aLocations[iLoc][3])
			   apAddresses[iLev++]=aLocations[iLoc][3];   // only lev1 local;
	        if (aLocations[iLoc][4].length>0)
			   apAddresses[iLev++]=aLocations[iLoc][4];   // only lev1 local;
			if (aLocations[iLoc][3].length>0 && aLocations[iLoc][4]!=aLocations[iLoc][3])
			   apAddresses[iLev++]=aLocations[iLoc][3]+","+aLocations[iLoc][1];   // lev1, lev0 local;
	        if (aLocations[iLoc][4].length>0)
			   {
			   if (aLocations[iLoc][1]!=aLocations[iLoc][2])
			        apAddresses[iLev++]=aLocations[iLoc][4]+","+aLocations[iLoc][1];   // lev1 eng, lev0 local;
			   apAddresses[iLev++]=aLocations[iLoc][4]+","+aLocations[iLoc][2];   // lev1 eng, lev0 end;
			   }
	           
	        if (aLocations[iLoc][5].length>0 && aLocations[iLoc][6]!=aLocations[iLoc][5])
			   apAddresses[iLev++]=aLocations[iLoc][5];   // only lev1 local;
	        if (aLocations[iLoc][6].length>0)
			   apAddresses[iLev++]=aLocations[iLoc][6];   // only lev2 eng;
	        if (aLocations[iLoc][5].length>0 && aLocations[iLoc][6]!=aLocations[iLoc][5])
			   apAddresses[iLev++]=aLocations[iLoc][5]+","+aLocations[iLoc][1];   // lev1, lev0 local;
	        if (aLocations[iLoc][6].length>0)
			   {
			   if (aLocations[iLoc][1]!=aLocations[iLoc][2])
			        apAddresses[iLev++]=aLocations[iLoc][6]+","+aLocations[iLoc][1];   // lev1 eng, lev0 local;
			   apAddresses[iLev++]=aLocations[iLoc][6]+","+aLocations[iLoc][2];   // lev1 eng, lev0 end;
			   }
	        iLev--;
			}
		}
	 if (iLoc<<%=nHits%>)		
		sLocation=apAddresses[iLev];
	}
	
 if (sLocation.length>0)
 	{
		//  with geocoder object: geocoder.getLatLng( sLocation+", <%=countrybean.countryname%>", geocodePlace );
        var sGeoURL="http://maps.google.com/maps/geo?key=<%=sGoogleKey%>&sensor=false&output=xml&q="+sLocation+", <%=countrybean.countryname%>";
		sendHttpGeocodeRequest(sGeoURL, geocodePlace)		
	}
else
  alert ("Done!!");	
}

if (<%=nHits%>==0)
  alert("No items found to be geocoded. try New Query");

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
