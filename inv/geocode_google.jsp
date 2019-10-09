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
<%
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
%>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%
if (user.iusertype<20) 
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
// for geocoder:
countrybean.level_map=0;
countrybean.level_rep=0;

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

int MAXIMUM_TO_GEOCODE=500;
if (request.getParameter("max_elements")!=null)
    MAXIMUM_TO_GEOCODE=countrybean.extendedParseInt(request.getParameter("max_elements")); 
int start_clave=0;
if (request.getParameter("start_clave")!=null)
    start_clave=countrybean.extendedParseInt(request.getParameter("start_clave")); 		
%>
<%@ include file="/googlekeys.jspf" %>
 
<title>DesInventar on-line Google Geocoder Map</title>

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
        
<script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?key=AIzaSyByVWfVCeED7LjjNRgxgTluLPGSenzMgAw&sensor=false"></script>
<script type="text/javascript">
// best to declare your map variable outside of the function so that you can access it from other functions
var map;
var geocoder;

function initialize() 
{

	geocoder = new google.maps.Geocoder();    	
	
    var latlng = new google.maps.LatLng(<%=(yy+ym)/2%>,<%=(xx+xm)/2%>);    
	var myOptions ={zoom: 3,      
					center: latlng,      
					panControl: false,    zoomControl: true,    scaleControl: true,
					mapTypeId: google.maps.MapTypeId.ROADMAP
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
<body marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class="bodyclass"  bgcolor="#C9C8A9" onLoad="initialize()">
<table width="100%" height="100%" border="1" class="pageBackground" rules="none">
<tr><td valign="top">

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
	<td id="map_cell" align="left" bgcolor="#ffffff" width="90%" height="100%" >
	<div id="map_canvas" style="width: 100%; height: 100%"></div>
	</td>
	<td nowrap="nowrap"><a href='javascript:nextsLocation()'>Start Geoding!</a><br>
	<form name="desinventar" method='post' action="geocode_google.jsp">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
		Max. points:<br>
		<input type="text" maxlength="4" size="5" name="max_elements" value="<%=MAXIMUM_TO_GEOCODE%>"><br>
		<input type="hidden" name="start_clave" value="<%=start_clave%>"><br>
		<input type="submit" name="cgh" value="Get Next set">
		</form>
	</td>
 </tr>
 <tr>
	<td colspan="2">Double-click to zoom in, and drag to pan. Use controls to zoom out and select background. </td>
 </tr>
<tr><td colspan="2">
<span class="bss"><%=countrybean.sSubTitle%></span>
</td></tr>
</table>
<script language="JavaScript">


// GEOCODING STUFF:
<% 
// produces the list with elements to geocode:
// a scrollable cursor is required to move quickly to start of records
stmt=con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
//stmt=con.createStatement();
String sLatLonNotSet=" and ("+countrybean.sqlNvl("latitude",0)+"=0 or "+countrybean.sqlNvl("longitude",0)+"=0)";

// for spain:
if (countrybean.countrycode.equals("esp"))
   sLatLonNotSet+=" and (level0<>'99')";


ArrayList sqlparams=new ArrayList();
PreparedStatement pstmt=null;

String sSql="select count(*) as nhits "+countrybean.getWhereSql(-1,sqlparams)+sLatLonNotSet;
out.println("<!-- "+sSql+ " [dbtype="+countrybean.dbType+","+countrybean.country.ndbtype+"; k="+countrybean.sqlStringConstant()+"] -->");
try
	{
	pstmt=con.prepareStatement(sSql);
	for (int k=0; k<sqlparams.size(); k++)
				pstmt.setString(k+1, (String)sqlparams.get(k));
	rset=pstmt.executeQuery();
	}
catch (Exception e)
	{
	out.println("<!-- "+e.toString()+"-->");
	}	
	
	
int nHits=0;
if (rset!=null && rset.next())
  nHits=rset.getInt("nhits");
  
sSql="select fichas.clave, fichas.serial, clave_ext as ex_clave_ext, eventos.nombre as event,  eventos.nombre_en as event_en, lev0.lev0_name as name0,  lev0.lev0_name_en as name0_en ,"+
	 "lev1.lev1_name as name1, lev1.lev1_name_en as name1_en, lev2.lev2_name as name2, lev2.lev2_name_en as name2_en, lugar "
     +countrybean.getWhereSql(-1, sqlparams)+sLatLonNotSet+" and (clave>"+start_clave+")  order by clave ";

try
	{
	pstmt=con.prepareStatement(sSql);
	for (int k=0; k<sqlparams.size(); k++)
				pstmt.setString(k+1, (String)sqlparams.get(k));
	rset=pstmt.executeQuery();
	}
catch (Exception e)
	{
	out.println("<!-- "+e.toString()+"-->");
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
		start_clave=rset.getInt("clave");
		out.println(sComma+"["+start_clave+",'"+
					EncodeUtil.jsEncode(rset.getString("name0"))+"','"+    //[1]
					EncodeUtil.jsEncode(rset.getString("name0_en"))+"','"+ //[2]
					EncodeUtil.jsEncode(rset.getString("name1"))+"','"+	   //[3]
					EncodeUtil.jsEncode(rset.getString("name1_en"))+"','"+ //[4]
					EncodeUtil.jsEncode(rset.getString("name2"))+"','"+    //[5]
					EncodeUtil.jsEncode(rset.getString("name2_en"))+"','"+ //[6]
					EncodeUtil.jsEncode(countrybean.not_null(rset.getString("lugar")))+"']");    //[7]
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


var iLoc=-1;
var iLev=-1;  // ready for next
var sLocation="";
var apAddresses=new Array(30);
var sCountry="<%=countrybean.countryname%>";



function addLocations()
{
var l3=(aLocations[iLoc][3].length>0);
var l4=(aLocations[iLoc][4].length>0);
var l5=(aLocations[iLoc][5].length>0);
var l6=(aLocations[iLoc][6].length>0);
var l7=(aLocations[iLoc][7].length>0);

apAddresses[iLev++]=aLocations[iLoc][2];
apAddresses[iLev++]=aLocations[iLoc][1];

if (l4) apAddresses[iLev++]=aLocations[iLoc][4]+", "+aLocations[iLoc][2];
if (l3) apAddresses[iLev++]=aLocations[iLoc][3]+", "+aLocations[iLoc][1];

if (l6) apAddresses[iLev++]=aLocations[iLoc][6]+", "+aLocations[iLoc][4]+", "+aLocations[iLoc][2];
if (l5) apAddresses[iLev++]=aLocations[iLoc][5]+", "+aLocations[iLoc][3]+", "+aLocations[iLoc][1];

if (l7) apAddresses[iLev++]=aLocations[iLoc][7]+", "+aLocations[iLoc][6]+", "+aLocations[iLoc][4]+", "+aLocations[iLoc][2];
if (l7) apAddresses[iLev++]=aLocations[iLoc][7]+", "+aLocations[iLoc][5]+", "+aLocations[iLoc][3]+", "+aLocations[iLoc][1];

iLev--;
}



function addLocations_v0()
	{
	// use level 0 ONLY if there's no Level 1
	if (aLocations[iLoc][3].length==0 && aLocations[iLoc][4].length==0)
		{
		apAddresses[iLev++]=aLocations[iLoc][1];      // lev0 local name; last to be checked
		if (aLocations[iLoc][2]!=aLocations[iLoc][1])
		   apAddresses[iLev++]=aLocations[iLoc][2];   // lev0 english;
		} 

	// use level 1 ONLY if there's no Level 2
	else if (aLocations[iLoc][5].length==0 && aLocations[iLoc][6].length==0)
		{		   
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
	   apAddresses[iLev++]=aLocations[iLoc][6]+","+aLocations[iLoc][2];   // lev1 eng, lev0 eng;
	   }
	   
	if (aLocations[iLoc][7].length>0)  // place
	   {
	   if (aLocations[iLoc][1]!=aLocations[iLoc][2])
			{
			apAddresses[iLev++]=aLocations[iLoc][7]+","+aLocations[iLoc][1];   // place, lev0 local;
			if (aLocations[iLoc][3].length>0)
				{
				apAddresses[iLev++]=aLocations[iLoc][7]+","+aLocations[iLoc][3];   // lev1 eng, lev0 local;
				apAddresses[iLev++]=aLocations[iLoc][7]+","+aLocations[iLoc][3]+","+aLocations[iLoc][1];   // lev1 eng, lev0 local;
				}
			}
	   else
			{
			apAddresses[iLev++]=aLocations[iLoc][7]+","+aLocations[iLoc][2];   // place, lev0 eng;
			if (aLocations[iLoc][4].length>0)
				 {
				 apAddresses[iLev++]=aLocations[iLoc][7]+","+aLocations[iLoc][4];   // place, lev1 eng
				 apAddresses[iLev++]=aLocations[iLoc][7]+","+aLocations[iLoc][4]+","+aLocations[iLoc][2];   // place, lev1 eng, lev0 end;
				 }
			}
	   }
	iLev--;
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
  // continues geocoding.. alert ("continues geocoding..");
  nextsLocation();
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
 

function saveFinalLocation(FinalLoc)
{
if (FinalLoc)
	{

    var marker = new google.maps.Marker({map:map, position: FinalLoc , title:sLocation, size:12});
	var sURL="/DesInventar/inv/saveCoordinates.jsp?latitude="+FinalLoc.lat()+"&longitude="+FinalLoc.lng()+"&key="+aLocations[iLoc][0];  
	sendHttpRequest(sURL)      
	}
	
}


var not_found="";

function nextsLocation()
{
 // move to next (either next location or higher level in same location)
 sLocation="";
 if (iLev>=0 || iLoc<<%=nHits%>-1)
 	{
	 iLev--;
	 if (iLev<0) // level was completed, next point!
		{
		iLev=0;
		iLoc++;
	 	if (iLoc<<%=nHits%>) 
		   addLocations()
		}
	 if (iLoc<<%=nHits%>)		
		sLocation=apAddresses[iLev];
	}
	
 if (sLocation.length>0)
 	{	
	if (sCountry.substring(0,5)!="World")
		sLocation+=","+sCountry;

	    // alert ("starts new geocoding.."+sLocation);
		setTimeout(function(){ geocoder.geocode({ 'address': sLocation}, geocodePlace );}, 500); 
		//geocoder.geocode({ 'address': sLocation}, geocodePlace );
	}
else
  {
  alert ("Done!!");	
  document.getElementById("notfounddiv").innerHTML=not_found;
  }

}

function geocodePlace(results, status) 
{  

 //alert ("receives geocoding..");

 if (status == google.maps.GeocoderStatus.OK) // process did start, check the result.
     {
 	 // alert ("found:["+iLoc+"]["+iLev+"] "+sLocation);
   	 // not_found+= "<br>OK: ["+iLoc+"]["+iLev+"] "+sLocation+" ->loc="+aLocations[iLoc][7]+"/"+aLocations[iLoc][5]+"/"+aLocations[iLoc][3]+"/"+aLocations[iLoc][1];

	 saveFinalLocation(results[0].geometry.location);
	 // move to next location
	 iLev=0;
	 }	  
 else if (status == 'OVER_QUERY_LIMIT') // wait one and a half second, retry...
     {
	 setTimeout(function(){ geocoder.geocode({ 'address': sLocation}, geocodePlace );}, 1500); 
	 }	  
 else 
   {
   // alert ("not found: "+sLocation+"  stat="+status);
   if (iLev==0)
   		{
     	not_found+= "<br>NF: ["+iLoc+"]["+iLev+"] "+sLocation+" ->loc="+aLocations[iLoc][7]+"/"+aLocations[iLoc][5]+"/"+aLocations[iLoc][3]+"/"+aLocations[iLoc][1];
		document.getElementById("notfounddiv").innerHTML=not_found;
   	    //alert (not_found);
		}
	nextsLocation();
	}
		   
}

if (<%=nHits%>==0)
  alert("No items found to be google-geocoded. try New Query");

  
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
var overhead=0; //140;
var xoverhead=70;
idH=Math.max(idH-overhead,512);
idW=Math.max(idW-xoverhead,512);
document.getElementById("map_cell").height=idH;
document.getElementById("map_canvas").height=idH;
document.getElementById("map_canvasTable").height=idH;
document.getElementById("map_canvasTable").width=idW;
}

resizeDlg();

window.onresize = resizeDlg;
document.getElementById("start_clave").value=<%=start_clave%>;
  
</script>
<%
try	{rset.close(); }catch (Exception e){out.println("<!-- closing r:"+e.toString()+" -->");}	
try	{pstmt.close();}catch (Exception e){out.println("<!-- closing ps:"+e.toString()+" -->");}	
dbCon.close();
%>

</td>
</tr>
<tr><td>
<br/><strong>NOT FOUND:</strong><br/>
<span id="notfounddiv"></span>
</td></tr>
</table>
<%@ include file="/html/footer.html" %>
</body>
</html>
