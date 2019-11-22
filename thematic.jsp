<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>DesConsultar on-line Thematic Map</title>
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
 </head>
<%@ page info="DesConsultar simple results page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.fichas" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%@ include file="/util/opendatabase.jspf" %>
<%@ include file="/paramprocessor.jspf" %>
<%@ taglib uri="inventag.tld" prefix="inv" %>
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
 <td align="center" width="350"><span class="subTitle"><%=countrybean.getTranslation("ThematicMapGenerator")%></span>
 </td>
 <td align="right">&nbsp;&nbsp;<a href="javascript:routeTo('thematic_def.jsp')" class='linkText'><%=countrybean.getTranslation("Back2thematic")%>.</a>&nbsp;
&nbsp;|&nbsp;<a href="javascript:routeTo('thematic_OL.jsp')" class='linkText'><%=countrybean.getTranslation("Dynamic Map")%></a>
&nbsp;|&nbsp;<a href="javascript:routeTo('thematic_google.jsp')" class='linkText'><%=countrybean.getTranslation("Google Map")%></a>
&nbsp;|&nbsp;<a href="javascript:routeTo('thematic_VE.jsp')" class='linkText'><%=countrybean.getTranslation("Virtual Earth")%></a>
&nbsp;|&nbsp;<a href="/DesInventar/thematic_kml.jsp" class='linkText'><%=countrybean.getTranslation("KML")%></a>
&nbsp;|&nbsp;<a href="/DesInventar/thematic_svg.jsp" class='linkText'><%=countrybean.getTranslation("SVG")%></a>
 </td>
</tr>
</table>
<%
String pname="";
String[] pval;
String imgparams="?mappingfunction="+countrybean.DoTHEMATIC+"&transparencyf=1&rnd="+Math.round(Math.random()*99999);
String sImageMap="<map name='mapselection'>";
sImageMap+="</map>";
%>
<%@ include file="/layerControl.jspf" %> 
<table border="0" cellpadding="0" cellspacing="0">
<tr><td align="center" colspan="2" >
<span class="title"><%=countrybean.sTitle%></span>
</td></tr>
 <tr>
	<td align="left" bgcolor="#ffffff"><!-- MAP --><img src='/DesInventar/MapServer<%=imgparams %>&LAYERS=effects<%=sLevelLayers%>' border=0><%=sImageMap%></td>
	<td align="left" valign="top">
	<!-- LEGEND --><img class='dragme'src='/DesInventar/MapLegendServer<%=imgparams %>' border=0>
	<br><br>
	<!-- DI Layers --><%=sLayersControl%>
	</td>
 </tr>
<tr><td colspan="2">
<span class="subtitle"><%=countrybean.sSubTitle%></span>
</td></tr>
<form name="desinventar" method='post' action="thematic.jsp">
<input type='hidden' name='nStart' value=''>
<INPUT type='hidden'  name="actiontab" id="actiontab">
<INPUT type='hidden'  name="frompage" value="<%=request.getServletPath()%>">
</form>
</table>
<script language="JavaScript">
<!--

function submitForm(istart)
{
document.desinventar.nStart.value=istart;
document.desinventar.submit();
}
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
