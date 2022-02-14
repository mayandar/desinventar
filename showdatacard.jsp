<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<%@ page info="DesConsultar DataCard page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%!
String sBlankZero(int num)
{
return num==0?"":String.valueOf(num);
}

String sBlankZero(double num)
{
return num==0?"":webObject.formatDouble(num);
}

%><head>
<title><%=countrybean.getTranslation("DatacardTitle")%></title>
<link href="html/desinventar.css" rel="stylesheet" type="text/css">
</head>
<%// opens the country database %>
<%@ include file="/util/opendatabase.jspf" %>
<%@ include file="/paramprocessor.jspf" %>

<%	
int nPort=request.getLocalPort();
htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/header",countrybean.getLanguage(),out);
int nStart=htmlServer.extendedParseInt(request.getParameter("nStart"));
int nClave=0; 
int j=0; 
int start=0; 
int current=0;
String toSearch=""; 
current=0;
// get serial number from parameters
nClave=countrybean.extendedParseInt(request.getParameter("clave"));
// this parameter>0 means is valid
start=countrybean.extendedParseInt(request.getParameter("start"));
toSearch=countrybean.not_null_safe(request.getParameter("tosearch"));	

// loads the datacard extension
fichas woFicha=new fichas();
extension woExtension=new extension();
woExtension.dbType=dbType;
woFicha.dbType=dbType;
woExtension.loadExtension(con,countrybean);
// open the database 

ArrayList sqlparams=new ArrayList();
PreparedStatement pstmt=null;
if (bConnectionOK)
	{
   try
		{
   	    // creates a very light rset with clave and serial
	    pstmt=con.prepareStatement("select fichas.serial,fichas.clave "+countrybean.getWhereSql(sqlparams)+" order by "+countrybean.getSortbySql(),
		                           ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		for (int k=0; k<sqlparams.size(); k++)
					pstmt.setString(k+1, (String)sqlparams.get(k));
		rset=pstmt.executeQuery();
		
		if (request.getParameter("nextcard")!=null)
	   		{
			++start;
			if (rset.absolute(start))
				{
				nClave=rset.getInt("clave");
				}
			else if (rset.last())
				{
				start=rset.getRow(); 
			    nClave=rset.getInt("clave");
				}
			}
	    else if (request.getParameter("previouscard")!=null)
	   		{
			if (start>1)
		   		{
		   		start--;
		   		rset.absolute(start);
  			    nClave=rset.getInt("clave");
		   		}
			}
	    else if (request.getParameter("firstcard")!=null)
	   	 	{
			start=1;
			rset.first(); 			
    		nClave=rset.getInt("clave");
			}
	    else if (request.getParameter("lastcard")!=null)
	   		{
			rset.last(); 			
			start=rset.getRow(); 
			nClave=rset.getInt("clave");
			}
	    else if (request.getParameter("searchcard")!=null)
	   		{
			rset.absolute(start);
			boolean bMore=true;
			while (bMore)
			   {
			   nClave=rset.getInt("clave");
			   if (rset.getString("serial").equalsIgnoreCase(toSearch))
			     bMore=false;
			   else
			     {
				 bMore=rset.next();
				 start++;
				 }
			   }
			if (rset.isAfterLast())
				{
				rset.last();
				start=rset.getRow(); 
			    nClave=rset.getInt("clave");
				}
			}
	   else
	     if (start>0)
	   		{ // first call to the editdata stuff. comes from the outside with start=? 
			
			System.out.println("moving to "+start);
			
	   		if (rset.absolute(start))
				nClave=rset.getInt("clave");
			else 
				{
				dbCon.close();
	   			%><jsp:forward page="noDataCard.jsp" /><%
				}
			}
		else
			{
			boolean bMore=rset.next();
			start=1;
			while (bMore)
			   {
			   int nClave2=rset.getInt("clave");
			   if (nClave2==nClave)
			     bMore=false;
			   else
			     {
				 bMore=rset.next();
				 start++;
				 }
			   }
			if (rset.isAfterLast())
				{
				rset.last();
				start=rset.getRow(); 
			    nClave=rset.getInt("clave");
				}
			}					
		}
	catch (Exception e)
		{
		System.out.println("AN ERROR OCCURRED...<!-"+e.toString()+"-->");
		}				

	// gets the object from the database
	woFicha.clave=nClave;
	woFicha.getWebObject(con);
	// its localized event name
	eventos woEvent=new eventos();
	woEvent.nombre=woFicha.evento;
	woEvent.getWebObject(con);
	woFicha.evento=countrybean.getLocalOrEnglish(woEvent.nombre,woEvent.nombre_en);
	// its localized level0 name
	lev0 woLevel0=new lev0();
	woLevel0.lev0_cod=woFicha.level0;
	woLevel0.getWebObject(con);
	woFicha.name0=countrybean.getLocalOrEnglish(woLevel0.lev0_name,woLevel0.lev0_name_en);	
	// its localized level1 name	
	lev1 woLevel1=new lev1();
	woLevel1.lev1_cod=woFicha.level1;
	woLevel1.getWebObject(con); 
	woFicha.name1=countrybean.getLocalOrEnglish(woLevel1.lev1_name,woLevel1.lev1_name_en);	
	// its localized level2 name
	lev2 woLevel2=new lev2();
	woLevel2.lev2_cod=woFicha.level2;
	woLevel2.getWebObject(con); 
	woFicha.name2=countrybean.getLocalOrEnglish(woLevel2.lev2_name,woLevel2.lev2_name_en);	
	// and its extension data
	woExtension.clave_ext=nClave;
	woExtension.getWebObject(con); 

	// if no position is know, approximates via the regions object
	regiones rPlace=new regiones();
	int nGoogleZoom=5;
	String sLocationTitle=countrybean.getTranslation("APROXIMATE LOCATION");
	if (woFicha.latitude==0.0 && woFicha.longitude==0.0)
		{
		rPlace.codregion=woFicha.level2;
		int nrec=rPlace.getWebObject(con);
		if (nrec<1)
			{
			rPlace.codregion=woFicha.level1;
			nrec=rPlace.getWebObject(con);
			}
		else nGoogleZoom=8;
		if (nrec<1)
			{
			rPlace.codregion=woFicha.level0;
			nrec=rPlace.getWebObject(con);
			if (nrec>=0)
				nGoogleZoom=6;		
			}
		else nGoogleZoom=7;		
		}
	else
		{
		nGoogleZoom=10;
		sLocationTitle=countrybean.getTranslation("EVENT LOCATION");
		rPlace.ytext=woFicha.latitude;
		rPlace.xtext=woFicha.longitude;
		}
	// non GCS-WGS84	
	if (rPlace.ytext>90 || rPlace.ytext<-90 || rPlace.xtext>180 || rPlace.xtext<-180)
			{
			rPlace.ytext=0;
			rPlace.xtext=0;
			}
	

 String sLevelLayers="";
   for (int k=0; k<countrybean.level_map; k++)
   	sLevelLayers+=",level"+k;
   if (countrybean.imLayerMaps!=null)
     for (int k=0; k<countrybean.imLayerMaps.length; k++)
   		sLevelLayers+=",layer"+k;
    %>
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

<script type="text/javascript">
// best to declare your map variable outside of the function so that you can access it from other functions
var map;
var geocoder;

function initialize() 
{
/*
    var latlng = new google.maps.LatLng(<%=rPlace.ytext%>,<%=rPlace.xtext%>);    
	var myOptions ={zoom: <%=nGoogleZoom%>,      
					center: latlng,      
					panControl: false,    zoomControl: true,    scaleControl: true,
					mapTypeId: google.maps.MapTypeId.ROADMAP
					};    
	map = new google.maps.Map(document.getElementById("map_canvas"),        myOptions);
	geocoder = new google.maps.Geocoder(); 
*/
}


</script>

<%
int nTabActive=countrybean.nAction; // viewdata, stats or reports
// brackets to isolate the tab generation context
{
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
<%} // tab generation context
%>
<form name='desinventar' action='showdatacard.jsp' method='post' style="margin-top=0">
<%
    // puts the hidden info
	out.println("<input type='hidden' name='clave' value='"+nClave+"'>");
	out.println("<input type='hidden' name='start' value='"+start+"'>");
%>
<table border="0" class="pageBackground" >
<tr><td class="bs" align="left" nowrap>
<table width="750" border="0" class="pageBackground" >
<tr><td class="bs" align="left" nowrap>
<font color="Blue"><%=countrybean.getTranslation("Region")%>: </font><a href="javascript:routeTo('main.jsp')"><font class='regionlink'>
<b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font></a>
 - [<jsp:getProperty name ="countrybean" property="countrycode"/>]
<td class="bs" align="center" nowrap>
<span class="subTitle"><%=countrybean.getTranslation("DataCard")%>:<input type="submit" value=" &lt;&lt; " name="firstcard">
<input type="submit" value=" &lt; " name="previouscard">
<input type="submit" value=" &gt; " name="nextcard">
<input type="submit" value=" &gt;&gt; " name="lastcard">
<input type="submit" value="<%=countrybean.getTranslation("Findserial")%>:" name="searchcard">
<input type="text" value='<%=toSearch%>' name="tosearch" size="15" maxlength="15">
</span>
</td><td class="bs" nowrap align="right"><a href="javascript:routeTo('results.jsp?nStart=<%=nStart%>')" class='linkText'><%=countrybean.getTranslation("Back2Search")%></a>
<input type='hidden' name='nStart' value='<%=nStart%>'>
<INPUT type='hidden'  name="actiontab" id="actiontab">
<INPUT type='hidden'  name="frompage" value="<%=request.getServletPath()%>">
</td></tr>
</table>

<table border="1" bordercolor="black"><tr><td class="bs" width="850">
<table class='bs' cellpadding="0" cellspacing="0" width="850">
<tr class='bodymedlight'><td class="bs"><!-- Header lines in light blue  -->
 <table class='bs' cellpadding="0" cellspacing="0" width="100%"><tr>
  <td class="bs"><%=countrybean.getTranslation("Serial")%>: <INPUT name="serial" value="<%=woFicha.serial%>" size="6" maxlength="6"></td>
  <td class="bs"><%=countrybean.getTranslation("DateYMD")%>: <INPUT NAME="fechano"  style="WIDTH: 45px;" value="<%=sBlankZero(woFicha.fechano)%>" size="4" maxlength="4"><INPUT NAME="fechames" value="<%=sBlankZero(woFicha.fechames)%>" size="2" style="WIDTH: 22px;" maxlength="3"><INPUT NAME="fechadia" value="<%=sBlankZero(woFicha.fechadia)%>" size="2" style="WIDTH: 22px;" maxlength="3"></td>
  <td class="bs"><%=countrybean.getTranslation("Duration")%>: <INPUT NAME="duracion"  style="WIDTH: 40px;" value="<%=sBlankZero(woFicha.duracion)%>" size="4" maxlength="4"></td>
  <td class="bs"><%=countrybean.getTranslation("Source")%>: <INPUT type='TEXT' size='40' maxlength='250'name='fuentes' VALUE="<%=woFicha.fuentes%>"></td>
 </tr></table>
</td>


<td width="100%" valign="top" rowspan="10">
<table border="1" cellpadding="0" cellspacing="0" width="350" height="450" id="map_canvasTable">
 <tr>
	<td id="map_cell" align="left" bgcolor="#ffffff" width="100%" height="100%" valign="top" >
<!--
	<div id="map_canvas" style="width: 100%; height: 100%"></div>

<div>
     <iframe width="350" height="450" frameborder="0" src="https://www.bing.com/maps/embed?h=450&w=350&cp=~<%=rPlace.xtext%>&lvl=<%=nGoogleZoom%>&typ=d&sty=r&src=SHELL&FORM=MBEDV8" scrolling="yes">
</div>

-->
<script type='text/javascript'>
    function GetMap() {
        var map = new Microsoft.Maps.Map('#myMap', 
		 {  //  UNISDR user account for DEV.
            credentials: 'AnSoKDSYWEvKDNdHIaNf7Kgyz1ilnZPqO7BbPQ7DHOF16cZT8-BHGuc74P4Dif5o',
            //  UNISDR user account for WEBSITE, exclusive of desinventar.let
            //credentials: 'As6UtKSPLk-8_JiCPPrOIHZ0WvTzVMP6gJ7I1CSMMfk0AY8NKOvLki3rDE5Brl52',
            center: new Microsoft.Maps.Location(<%=rPlace.ytext%>, <%=rPlace.xtext%>),
			zoom: <%=nGoogleZoom%>
        });

        var center = map.getCenter();

        //Create custom Pushpin
        var pin = new Microsoft.Maps.Pushpin(center, {
            title: 'Aprox',
			subTitle: '',
			color: 'red'
        });

        //Add the pushpin to the map
        map.entities.push(pin);
    }
    </script>
    <script type='text/javascript' src='https://www.bing.com/api/maps/mapcontrol?callback=GetMap' async defer></script>
    <div id="myMap" style="position:relative; top:0;left:0;width:350px;height:450px;"></div>
	</td>
 </tr>
 <tr>
	<td colspan="2" class="bss"><%=countrybean.getTranslation("google_explanation")%></td>
 </tr>
</table> 
</td>


</tr>
<tr class='bodymedlight'><td class="bs">
 <table class='bs' cellpadding="0" cellspacing="0" width="100%"><tr>
  <td class="bs"><%=countrybean.asLevels[0]%>: <input name="name0" size=20 value="<%=woFicha.name0%>"></td>
  <td class="bs"><%=countrybean.asLevels[1]%>: <input type='text' name='name1' size=20 value="<%=woFicha.name1%>"></td>
  <td class="bs"><%=countrybean.asLevels[2]%>: <input type='text' name='name2' size=20 value="<%=woFicha.name2%>"></td>
 </tr></table>
</td></tr>
<tr class='bodymedlight'><td class="bs">
 <table class='bs' cellpadding="0" cellspacing="0" width="100%"><tr>
  <td class="bs"><%=countrybean.getTranslation("Event")%>: <input name="Event" size=20 value="<%=woFicha.evento%>"></td>
  <td class="bs"><%=countrybean.getTranslation("Place")%>: <INPUT type="TEXT" size="45" maxlength="60"name="lugar" VALUE="<%=woFicha.lugar%>"></td>
  <td class="bs"><%=countrybean.getTranslation("GLIDEnumber")%>: <INPUT type="TEXT" size="15" maxlength="30"name="lugar" VALUE="<%=woFicha.glide%>"></td>
 </tr></table>
</td></tr>

<tr class='bodymedlight'><td class="bs" height='28'><!-- causes lines in light red  -->
 <table class='bs' cellpadding="0" cellspacing="0" width="100%"><tr>
	<td class="bs"><%=countrybean.getTranslation("Cause")%>: <input name="Cause" size=20 value="<%=woFicha.causa%>"></td>
	<td class="bs"><%=countrybean.getTranslation("DescriptionCause")%>: <INPUT type="TEXT" size="65" maxlength="60"name="descausa" VALUE="<%=woFicha.descausa%>"></td>
 </tr></table>
</td>
</tr>

<tr class='bodydarklight'><td class="bs"><!-- Effects lines in light blue  -->
<b><i><font class='subTitle'><%=countrybean.getTranslation("EFFECTS")%></font></i></b>
</td></tr>
<tr class='bodymedlight'>
<td class="bs">

<%
String sHtmlFolder=getServletConfig().getServletContext().getRealPath("html")+"/";
String[] sTemplate={"datacard_","datacard_","datacard_UN","datacard_UN"};   // tries in order: datacard_ccc_ll, datacard_ccc, datacard_def_ll, datacard_def    
ArrayList alProcessedFields=null;
Dictionary dct = new Dictionary();
dct.nombre_campo="LIVING_DMGD_DWELLINGS"; // very unlikely defined outside sendai
dct.dbType=countrybean.dbType;
int nSendai=dct.getWebObject(con);
sTemplate[0]+=countrybean.countrycode;
sTemplate[1]+=countrybean.countrycode;
if (!countrybean.getLanguage().toLowerCase().equals("en"))
	{
	sTemplate[0]+="_"+countrybean.getLanguage().toLowerCase();
	sTemplate[2]+="_"+countrybean.getLanguage().toLowerCase();
	}
int iTemplate=0;
File tmpl=new File(sHtmlFolder+sTemplate[0]+".html");
while (iTemplate<3 && !tmpl.exists())
	tmpl=new File(sHtmlFolder+sTemplate[++iTemplate]+".html");

if (tmpl.exists() && nSendai>0)
{
woFicha.addExtensionHashMap(woExtension);
alProcessedFields=woFicha.processTemplate(sHtmlFolder+sTemplate[iTemplate]+".html",out, countrybean, con);	
}
else
{
alProcessedFields=new ArrayList();
%>

<table cellspacing="0" cellpadding="0" border="0" width="100%">
<tr><!-- Effects -->
 <td class="bs"><!-- vars with checks -->
 <table cellspacing="0" cellpadding="0" border="0" width="100%">
  <tr>
	<td class="bs" align="right" nowrap><%=countrybean.getTranslation("Deaths")%>:</td>
	<td class="bs"><INPUT type="TEXT" size="6" maxlength="8"name="muertos" VALUE="<%=sBlankZero(woFicha.muertos)%>" onChange=" chkMuertos()"></td>
	<td class="bs" align="left"><INPUT type="CHECKBOX" name="hay_muertos" VALUE="-1" <%=woFicha.strChecked(woFicha.hay_muertos)%>></td>
	<td class="bs" align="right" nowrap>&nbsp;<%=countrybean.getTranslation("Missing")%>: </td>
	<td class="bs"><INPUT type="TEXT" size="6" maxlength="8" name="desaparece" VALUE="<%=sBlankZero(woFicha.desaparece)%>"  onChange=" chkDesaparece()"></td>
	<td class="bs" align="left"><INPUT type="CHECKBOX" name="hay_deasparece" VALUE="-1" <%=woFicha.strChecked(woFicha.hay_deasparece)%>></td>
	<td class="bs" align="right" nowrap>&nbsp;<%=countrybean.getTranslation("Injured")%>: </td>
	<td class="bs"><INPUT type="TEXT" size="6" maxlength="8" name="heridos" VALUE="<%=sBlankZero(woFicha.heridos)%>"  onChange=" chkHeridos()"></td>
	<td class="bs" align="left"><INPUT type="CHECKBOX" name="hay_heridos" VALUE="-1" <%=woFicha.strChecked(woFicha.hay_heridos)%>></td>
  </tr>
  <tr>
	<td class="bs" align="right"><%=countrybean.getTranslation("Affected")%>:</td>
	<td class="bs"><INPUT type="TEXT" size="6" maxlength="8" name="afectados" VALUE="<%=sBlankZero(woFicha.afectados)%>"  onChange=" chkAfectados()"></td>
	<td class="bs" align="left"><INPUT type="CHECKBOX" name="hay_afectados" VALUE="-1" <%=woFicha.strChecked(woFicha.hay_afectados)%>></td>
	<td class="bs" align="right">&nbsp;<%=countrybean.getTranslation("Relocated")%>:</td>
	<td class="bs"><INPUT type="TEXT" size="6" maxlength="8" name="reubicados" VALUE="<%=sBlankZero(woFicha.reubicados)%>"  onChange=" chkReubicados()"></td>
	<td class="bs" align="left"><INPUT type="checkbox" name="hay_reubicados" VALUE="-1" <%=woFicha.strChecked(woFicha.hay_reubicados)%>></td>
	<td class="bs" align="right" nowrap>&nbsp;<%=countrybean.getTranslation("AffectedHouses")%>.:</td>
	<td class="bs"><INPUT type="TEXT" size="6" maxlength="8" name="vivafec" VALUE="<%=sBlankZero(woFicha.vivafec)%>"  onChange=" chkVivafec()"></td>
	<td class="bs" align="left"><INPUT type="CHECKBOX" name="hay_vivafec" VALUE="-1" <%=woFicha.strChecked(woFicha.hay_vivafec)%>></td>
  </tr>
  <tr>
	<td class="bs" align="right"><%=countrybean.getTranslation("Evacuated")%>:</td>
	<td class="bs"><INPUT type="TEXT" size="9" maxlength="8" name="evacuados" VALUE="<%=sBlankZero(woFicha.evacuados)%>"  onChange=" chkEvacuados()"></td>
	<td class="bs" align="left"><INPUT type="CHECKBOX" name="hay_evacuados" VALUE="-1" <%=woFicha.strChecked(woFicha.hay_evacuados)%>></td>
	<td class="bs" align="right">&nbsp;<%=countrybean.getTranslation("Victims")%>:</td>
	<td class="bs"><INPUT type="TEXT" size="6" maxlength="8" name="damnificados" VALUE="<%=sBlankZero(woFicha.damnificados)%>"  onChange=" chkDamnificados()"></td>
	<td class="bs" align="left"><INPUT type="CHECKBOX" name="hay_damnificados" VALUE="-1" <%=woFicha.strChecked(woFicha.hay_damnificados)%>></td>
	<td class="bs" align="right" nowrap>&nbsp;<%=countrybean.getTranslation("DestroyedHouses")%>:</td>
	<td class="bs"><INPUT type="TEXT" size="6" maxlength="8" name="vivdest" VALUE="<%=sBlankZero(woFicha.vivdest)%>"  onChange=" chkVivdest()"></td>
	<td class="bs" align="left"><INPUT type="CHECKBOX" name="hay_vivdest" VALUE="-1" <%=woFicha.strChecked(woFicha.hay_vivdest)%>></td>
  </tr>
  <tr>
	<td class="bs" colspan=9><span class="subtitle"><%=countrybean.getTranslation("AffectedSectors").toUpperCase()%></span></td>
  </tr>
 </table>
 </td>
 <td class="bs" rowspan="2"><!-- with no checks -->
	<table cellspacing="0" cellpadding="0" border="0" width="100%">
	<tr>
		<td class="bs" align="right" nowrap>&nbsp;<%=countrybean.getTranslation("Magnitude")%>:</td>
		<td class="bs"><INPUT type="TEXT" size="26" maxlength="22" name="magnitud2" VALUE="<%=woFicha.magnitud2%>"></td>
	</tr>
	<tr>
		<td class="bs" align="right" nowrap>&nbsp;<%=countrybean.getTranslation("LossesLocal")%>:</td>
		<td class="bs"><INPUT type="TEXT" size="11" maxlength="40" name="valorloc" VALUE="<%=sBlankZero(woFicha.valorloc)%>"></td>
	</tr>
	<tr>
		<td class="bs" align="right" nowrap>&nbsp;<%=countrybean.getTranslation("LossesUSD")%>:</td>
		<td class="bs"><INPUT type="TEXT" size="11" maxlength="40" name="valorus" VALUE="<%=sBlankZero(woFicha.valorus)%>"></td>
	</tr>
	<tr>
		<td class="bs" align="right"><%=countrybean.getTranslation("Damagesinroads")%>: </td>
		<td class="bs"><INPUT type="TEXT" size="8" maxlength="40" name="kmvias" VALUE="<%=sBlankZero(woFicha.kmvias)%>"  onChange=" chkKmVias()"></td>
	</tr>
	<tr>
		<td class="bs" align="right" nowrap>&nbsp;<%=countrybean.getTranslation("Damagesincrops")%>:</td>
		<td class="bs"><INPUT type="TEXT" size="8" maxlength="40" name="nhectareas" VALUE="<%=sBlankZero(woFicha.nhectareas)%>"  onChange=" chkNhectareas()"></td>
	</tr>
	<tr>
		<td class="bs" align="right">&nbsp;<%=countrybean.getTranslation("Catle")%>:</td>
		<td class="bs"><INPUT type="TEXT" size="6" maxlength="8" name="cabezas" VALUE="<%=sBlankZero(woFicha.cabezas)%>"  onChange=" chkCabezas()"></td>
	</tr>
	<tr>
		<td class="bs" align="right">&nbsp;<%=countrybean.getTranslation("Educationcenters")%>:</td>
		<td class="bs"><INPUT type="TEXT" size="6" maxlength="8" name="nescuelas" VALUE="<%=sBlankZero(woFicha.nescuelas)%>"  onChange=" chkNescuelas()"></td>
	</tr>
	<tr>
		<td class="bs" align="right">&nbsp;<%=countrybean.getTranslation("Hospitals")%>:</td>
		<td class="bs"><INPUT type="TEXT" size="6" maxlength="8" name="nhospitales" VALUE="<%=sBlankZero(woFicha.nhospitales)%>"  onChange=" chknHospitales()"></td>
	</tr>
	</table>
 </td>
</tr>
<tr><!-- Sectors -->
 <td class="bs"><!-- vars with checks -->
	<table witdh=100% cellspacing="0" cellpadding="0" border="0">
	<tr>
		<td class="bs" align="right"><INPUT  type="CHECKBOX" name="transporte" VALUE="1" <%=woFicha.strChecked(woFicha.transporte)%>></td>
		<td class="bs"><%=countrybean.getTranslation("Transportation")%>&nbsp;</td>
		<td class="bs" align="right"><INPUT type="CHECKBOX" name="comunicaciones" VALUE="1" <%=woFicha.strChecked(woFicha.comunicaciones)%>></td>
		<td class="bs"><%=countrybean.getTranslation("Communications")%>&nbsp;</td>
		<td class="bs" align="right"><INPUT  type="CHECKBOX" name="socorro" VALUE="1" <%=woFicha.strChecked(woFicha.socorro)%>></td>
		<td class="bs"><%=countrybean.getTranslation("Relief")%>&nbsp;</td>
	</tr>
	<tr>
		<td class="bs" align="right"><INPUT  type="CHECKBOX" name="agropecuario" VALUE="1" <%=woFicha.strChecked(woFicha.agropecuario)%>></td>
		<td class="bs"><%=countrybean.getTranslation("Agriculture")%>&nbsp;</td>
		<td class="bs" align="right"><INPUT  type="CHECKBOX" name="acueducto" VALUE="1" <%=woFicha.strChecked(woFicha.acueducto)%>></td>
		<td class="bs"><%=countrybean.getTranslation("Water")%>&nbsp;&nbsp;</td>
		<td class="bs" align="right"><INPUT  type="CHECKBOX" name="alcantarillado" VALUE="1" <%=woFicha.strChecked(woFicha.alcantarillado)%>></td>
		<td class="bs"><%=countrybean.getTranslation("Sewerage")%>&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<td class="bs" align="right"><INPUT  type="CHECKBOX" name="energia" VALUE="1" <%=woFicha.strChecked(woFicha.energia)%>></td>
		<td class="bs"><%=countrybean.getTranslation("Power")%>&nbsp;&nbsp;</td>
		<td class="bs" align="right"><INPUT  type="CHECKBOX" name="industrias" VALUE="1" <%=woFicha.strChecked(woFicha.industrias)%>></td>
		<td class="bs"><%=countrybean.getTranslation("Industrial")%>&nbsp;</td>
		<td class="bs" align="right"><INPUT  type="CHECKBOX" name="educacion" VALUE="1" <%=woFicha.strChecked(woFicha.educacion)%>></td>
		<td class="bs"><%=countrybean.getTranslation("Education")%>&nbsp;</td>
	</tr>
	<tr>
		<td class="bs" align="right"><INPUT  type="CHECKBOX" name="hay_otros" VALUE="1" <%=woFicha.strChecked(woFicha.hay_otros)%>></td>
		<td class="bs"><%=countrybean.getTranslation("Othersectors")%>&nbsp;&nbsp;</td>
		<td class="bs" align="right"></td>
		<td class="bs"></td>
		<td class="bs" align="right"><INPUT  type="CHECKBOX" name="salud" VALUE="1" <%=woFicha.strChecked(woFicha.salud)%>></td>
		<td class="bs"><%=countrybean.getTranslation("Health")%></td>
	</tr>
	</table>
 </td>
</tr>
</table>
</td></tr>

<tr class='bodymedlight'><td class="bs">
<%=countrybean.getTranslation("OtherLosses")%>: <INPUT type="TEXT" size="60" maxlength="60" name="otros" VALUE="<%=woFicha.otros%>">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<%=countrybean.getTranslation("Latitude")%>: <INPUT type="TEXT" size="10" maxlength="14" name="otros" VALUE="<%=woFicha.latitude==0.0?"":woFicha.formatDouble(woFicha.latitude,-8)%>">
<%=countrybean.getTranslation("Longitude")%>: <INPUT type="TEXT" size="10" maxlength="14" name="otros" VALUE="<%=woFicha.longitude==0.0?"":woFicha.formatDouble(woFicha.longitude,-8)%>">
<br>
<hr>
</td></tr>


<tr class='bodymedlight'><td class="bs"><!-- Comments lines in light blue  -->
<strong><%=countrybean.getTranslation("Comments").toUpperCase()%></strong>:<br>
<TEXTAREA rows="4" name="di_comments" cols="100"><%=woFicha.di_comments%></textarea> 
</td></tr>
<tr class='bodymedlight'><td class="bs" align="center">
 <table class='bs' cellpadding="0" cellspacing="0" width="40%"><tr>
  <td class="bs"><%=countrybean.getTranslation("By")%>: <INPUT type="TEXT" size="13" maxlength="12" name="fechapor" VALUE="<%=woFicha.fechapor%>"></td>
  <td class="bs"><%=countrybean.getTranslation("Date")%>: <INPUT type="TEXT" size="10" maxlength="10" name="fechafec" VALUE="<%=woFicha.fechafec%>"></td>
 </tr></table>
</td></tr>
</table>

<%}%>

</td>


</tr>


<tr><td class="bs" class="bs" colspan=2>


<%
nTabActive=0;
String[] sTabNames=new String[woExtension.vTabs.size()];
String[] sTabIcons=new String[woExtension.vTabs.size()];
String[] sTabLinks=new String[woExtension.vTabs.size()];
for (int k = 0; k < woExtension.vTabs.size(); k++)
    {
    extensiontabs tab = (extensiontabs) woExtension.vTabs.get(k);
	sTabNames[k]=countrybean.getLocalOrEnglish(tab.svalue,tab.svalue_en);
	sTabIcons[k]="";
	sTabLinks[k]="javascript:openTab("+k+")";
	}
 
%>
<%@ include file="/util/tabs_ext.jspf" %>
<% 
for (int ktab = 0; ktab < woExtension.vTabs.size(); ktab++)
{%>
<div id="tab_<%=ktab%>" style="display:none;">
<table cellpadding="1" cellspacing="0" border="1" rules="none" width="100%" class="<%=sTabActiveColor%>">
<%  // allocates a dictionary object to read each record
  dct = new Dictionary();
  for (int k = 0; k < woExtension.vFields.size(); k++)
     {
	 dct = (Dictionary) woExtension.vFields.get(k);
	 boolean bFound=false;
	 boolean bSelected=false;
	 if (!alProcessedFields.contains(dct.nombre_campo.toUpperCase()))
	  if ((dct.tabnumber==ktab+1) || (dct.tabnumber==0 && ktab==woExtension.vTabs.size()-1))   
	    {%>
		  <tr>
		   <td class="bs" align="right"  class=bgLight width='300'><%=countrybean.getLocalOrEnglish(dct.label_campo,dct.label_campo_en)%>:&nbsp;</td>
		   <td class="bs" align="left" class=bgLightLight>
		<%switch (dct.fieldtype)
				  	{
					case extension.YESNO:
						%>&nbsp;<input name='<%=dct.nombre_campo%>' type='checkbox' value="1" <%=dct.strChecked(dct.sValue)%> size='4' maxlength='5'><%
						break;
					case extension.LIST:
						%>&nbsp;<input name='<%=dct.nombre_campo%>' type='text' value="<%=dct.getCodeValue(dct.sValue,countrybean)%>" size='25'><%
						break;
					case extension.CHOICE:
						for (int ilist=0; ilist<dct.codes.size(); ilist++)
						{
							bSelected=false;
							extensioncodes ecList=(extensioncodes)(dct.codes.get(ilist));			
							if (ecList.code_value.equals(dct.sValue))
								{
								bFound=true;
								bSelected=true;
								}
						%>&nbsp;<input name='<%=dct.nombre_campo%>' type='radio' value="<%=ecList.code_value%>"<%=dct.strChecked(bSelected)%>><%=countrybean.getLocalOrEnglish(ecList.svalue,ecList.svalue_en)%><%
						}
						if (!bFound && dct.sValue.length()>0 && !dct.sValue.equals("0")){
						%>&nbsp;<input name='<%=dct.nombre_campo%>' type='radio' value="<%=dct.sValue%>" checked><%=dct.sValue%><%
						}
						break;
					case extension.INTEGER:
				  		%>&nbsp;<input name='<%=dct.nombre_campo%>' type='text' value="<%=sBlankZero((int)dct.dNumericValue)%>" size='10' maxlength='10'><%
						break;
					case extension.FLOATINGPOINT:
  			           %>&nbsp;<input name='<%=dct.nombre_campo%>' type='text' value="<%=dct.dNumericValue==0.0?"":woExtension.formatDouble(dct.dNumericValue,-4)%>" size='<%=Math.min(dct.lon_x + 1, 15)%>' maxlength='20'><%
		               break;
					case extension.CURRENCY:
  			           %>&nbsp;<input name='<%=dct.nombre_campo%>' type='text' value="<%=sBlankZero(dct.dNumericValue)%>" size='<%=Math.min(dct.lon_x + 1, 15)%>' maxlength='20'><%
		               break;
					case extension.DATETIME:
				       %>&nbsp;<input name='<%=dct.nombre_campo%>' type='text' value="<%=woExtension.strDate(dct.sValue)%>" size='12' maxlength='12'><%
					   break;
					case extension.MEMO:
			           %>&nbsp;<textarea name='<%=dct.nombre_campo%>' cols=60 rows=3><%=dct.sValue%></textarea><%
					   break;
				    default:  
				        %>&nbsp;<input name='<%=dct.nombre_campo%>' type='text' value="<%=dct.sValue%>" size='<%=Math.min(dct.lon_x + 1, 50)%>' maxlength='<%=dct.lon_x%>'><%
		            }%>
		   </td>
		  </tr>   	
	  <%} /* if in this tab*/ 
	} /* for each field */%>
<tr><td class="bs"></td><td class="bs"></td></tr>
</table>
</div>
<%} // for each tab
%> 
</td></tr>

<%
						  stmt = con.createStatement ();
						  String sSql="Select * from media_file where iclave="+woFicha.clave+" order by imedia";
						  rset=stmt.executeQuery(sSql);
  						  MediaFile  woMedia=new MediaFile();
						  String sLengthControl="";
						  while (rset.next())
						  {
							woMedia.loadWebObject(rset);
						    String sFile_extension=woMedia.media_file.substring(woMedia.media_file.lastIndexOf(".")+1).toLowerCase();
							String sFilename=countrybean.countrycode+"_"+woMedia.imedia+"."+sFile_extension;

							%>	  
    <tr id='<%="Row_"+woMedia.imedia%>'>
      <td class="bs" colspan=2><br/>
<%							String[] sIconShown={"link.jpg","msword.png","msexcel.png","mspowerpoint.png","pdf.jpg","blank.jpg"
							                               ,"video_logo__normal.jpg","link.jpg","text.png","zip.png","link.jpg","link.jpg","link.jpg"};
							switch (woMedia.media_type)
								{
									case 1:
									case 2:
									case 3:
									case 4:
									case 6:
									case 7:
									case 8:
									case 9:
										out.println("<br/><a href='/DesInventar/MediaServer?media="+sFilename+"' target='_blank'><img src='/DesInventar/images/"+sIconShown[woMedia.media_type]+"' border=0 width='30'>&nbsp;&nbsp;"
										            +countrybean.getLocalOrEnglish(woMedia.media_title,woMedia.media_title_en)+"</a>");
									break;
									case 5:
										out.println("<br/><a href='/DesInventar/media/"+sFilename+"' target='_blank'><img id='img"+woMedia.imedia+"' src='/DesInventar/media/"+sFilename+"'/ border='0' ></a><br/>"+countrybean.getLocalOrEnglish(woMedia.media_title,woMedia.media_title_en));
										sLengthControl+="if (document.getElementById('img"+woMedia.imedia+"').height>500) document.getElementById('img"+woMedia.imedia+"').height=500;\n";										
										break;
								}
							if ((woMedia.media_description+woMedia.media_description_en).length()>0)
								out.println("<br/>"+countrybean.getLocalOrEnglish(woMedia.media_description,woMedia.media_description_en));
							if (woMedia.media_link.length()>0)
								out.println("<br/>"+"<a href='"+woMedia.media_link+"' target='_blank'>"+woMedia.media_link+"</a>");										
%>								
      </td>
    </tr>
<%						  }
%>



</table>
</form>
</td></tr>
</table>




<script language="JavaScript">
var bConnected2Internet=true;
var marker;
var nCurrentTab=0;
<%= sLengthControl %>

function openTab(ntab)
{
document.getElementById("tab_"+nCurrentTab).style.display='none';
document.getElementById("td_"+nCurrentTab).className='<%=sTabInactiveColor%>';
document.getElementById("link_"+nCurrentTab).className='<%=sTabTextInactiveColor%>';
nCurrentTab=ntab;
document.getElementById("tab_"+nCurrentTab).style.display='block';
document.getElementById("td_"+nCurrentTab).className='<%=sTabActiveColor%>';
document.getElementById("link_"+nCurrentTab).className='<%=sTabTextActiveColor%>';
}
openTab(0);
 
 
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
 


// checks if there is Internet, and if so, it tries google geo-location
function doConnectFunction() 
{
// Internet is available, display map
bConnected2Internet=true;
initialize();
}
function doNoConnectFunction() 
{
// no connection to Internet 
bConnected2Internet=false;
}

var elements = document.forms['desinventar'].elements;
for (var i = 0; i < elements.length; i++) 
    elements[i].readOnly = true;


var i = new Image();
i.onload = doConnectFunction;
i.onerror = doNoConnectFunction;
// CHANGE IMAGE URL TO IMAGE WE KNOW IS LIVE. Append random() to override possibility of image coming from cache
i.src = 'https://www.desinventar.net/images/at.png?d=' + Math.random();

</script>

<%
try	{rset.close(); }catch (Exception e){out.println("<!-- closing r:"+e.toString()+" -->");}	
try	{pstmt.close();}catch (Exception e){out.println("<!-- closing ps:"+e.toString()+" -->");}	
dbCon.close();
}
%>
<%@ include file="/html/footer.html" %>
</body>
</html>
