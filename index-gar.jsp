<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page info="front page of DesConsultar On-Line" session="true" %> 
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %> 
<%@ page import="org.lared.desinventar.webobject.*" %> 
<%@ page import="org.lared.desinventar.system.Sys" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<html>
<head>
<title>DesConsultar on-line Main Menu</title>
<link href="html/desinventar.css" rel="stylesheet" type="text/css">
</head>
<%
org.lared.desinventar.system.Sys.getProperties();
String sSetDescriptors="";
String sDescription="";
country cCountry=new country();
String sRealPath=getServletConfig().getServletContext().getRealPath("/");
htmlServer.outputLanguageHtml(sRealPath+"html","/header",countrybean.getLanguage(),out);
countrybean.init();
%>
<%@ include file="/util/opendefaultdatabase.jspf" %>
<div class="welcomeheadder">
  <div class="navbase">
          <h4 style="margin-bottom:0; padding-top:5px;">&nbsp;Welcome to the GAR 2011 Disaster Data Platform. </h4>
  </div>
</div>
<table width="1000" cellspacing="2" cellpadding="2" border="1"  bordercolor="white" class="IE_TABLE bs" rules="none">
<tr>
	<td valign="middle"><a href="http://www.undrr.org"><img border="0" alt="ISDR site" src="/DesInventar/images/logo-isdr.gif" height="30"/></a></td>
	<td valign="middle"><a href="http://www.preventionweb.net/gar"><img border="0" alt="GAR2011" src="/DesInventar/images/gar_brand.png" height="30"/></a></td>
	<td valign="middle"><a href="http://www.undp.org"><img src="/DesInventar/images/undp.gif" border="0" height="40" alt="UNDP" /></a></td>
</tr>
<tr><td colspan=3>
<table width="100%" cellspacing="2" cellpadding="2" border="0" class="bs">
<tr class="bodydarklight"><td colspan=6 align="center" height="30"><strong>GAR UNIVERSE  (Integrated database, 22 datasets)</strong></td></tr>
<tr>
    <th>&nbsp;&nbsp;</th>
    <th align="left" colspan="2"><strong><%=countrybean.getTranslation("CountryOrRegion")%><!-- Country or Region --></strong></th>
    <th align="left"><strong><%=countrybean.getTranslation("Period")%><!-- Period --></strong></th>
    <th align="left"><strong><%=countrybean.getTranslation("Institution")%><!-- Institution --></strong></th>
    <th>&nbsp;</th>
</tr>
<tr class="bodymedlight">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="g11";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	GAR Universe (Asia, Africa, LAC)</a>&nbsp;</td>
	<td><!--<a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a> --></td>
	<td nowrap>1970 - 2009&nbsp;</td>
	<td>National Governments, UNDRR, UNDP, La Red and other partners. </td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>
<tr><td colspan="6">&nbsp;<br/>&nbsp;</td></tr>
<tr class="bodydarklight"><td colspan=6 align="center" height="30"><strong>ASIAN AND AFRICAN DATABASES</strong></td></tr>
<tr>
    <th>&nbsp;&nbsp;</th>
    <th colspan="2" align="left"><strong><%=countrybean.getTranslation("CountryOrRegion")%><!-- Country or Region --></strong></th>
    <th align="left"><strong><%=countrybean.getTranslation("Period")%><!-- Period --></strong></th>
    <th align="left"><strong><%=countrybean.getTranslation("Institution")%><!-- Institution --></strong></th>
    <th>&nbsp;</th>
</tr>
<tr class="bodymedlight">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="id11";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>&continue=y">
	Indonesia</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap>1970 - 2009&nbsp;</td>
	<td>Indonesian National Board for Disaster Management (BNPB), UNDP Indonesia</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>
<tr>
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="ir11";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>&continue=y">
	Iran, Islamic Republic of </a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap>1970 - 2009&nbsp;</td>
	<td>Ministry of Interior Iran - UNDP Iran</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr class="bodymedlight">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="jo11";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>&continue=y">
	Jordan, Hashemite Kingdom of</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap>1970 - 2009&nbsp;</td>
	<td>Jordan Civil Defense, UNDRR</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr>
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="mo11";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>&continue=y">
	Mo&ccedil;ambique</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap>1970 - 2009&nbsp;</td>
	<td>National Disaster Management Institute (INGC) - UNDP Mo&ccedil;ambique</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>


<tr class="bodymedlight">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="np11";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>&continue=y">
	Nepal</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap>1970 - 2009&nbsp;</td>
	<td>National Society for Earthquake Technology NSET, UNDP Nepal</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>


<tr>
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="or11";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>&continue=y">
	Orissa (India)</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap>1970-2009&nbsp;</td>
	<td>Orissa State Disaster Management Authority  OSDMA, UNDP India, UNDRR</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>
<tr class="bodymedlight">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="sl11";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>&continue=y">
	Sri Lanka</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap>1974 - 2009&nbsp;</td>
	<td> Ministry of Disaster Management, DMC Sri Lanka - UNDP Sri Lanka</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr>
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="sy11";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>&continue=y">
	Syrian Arab Republic</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap>1980 - 2009&nbsp;</td>
	<td> Ministry of Local Administration, UNDP Syria, UNDRR</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>


<tr class="bodymedlight">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="tn3";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>&continue=y">
	Tamil Nadu (India)</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap>1976 - 2009&nbsp;</td>
	<td>State Commissioner of Tamil-Nadu, UNDP India, UNDRR</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr>
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="ym11";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>&continue=y">
	Yemen, Republic of</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap>1976 - 2009&nbsp;</td>
	<td>Ministry of Environment, Yemen, UNDP Yemen, UNDRR</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr><td colspan="6">&nbsp;<br/>&nbsp;</td></tr>
<tr class="bodydarklight"><td colspan=6 align="center" height="30" valign="bottom"><strong>LATIN AMERICAN DATABASES</strong></td></tr>
<tr>
    <th>&nbsp;&nbsp;</th>
    <th colspan="2" align="left"><strong><%=countrybean.getTranslation("CountryOrRegion")%><!-- Country or Region --></strong></th>
    <th align="left"><strong><%=countrybean.getTranslation("Period")%><!-- Period --></strong></th>
    <th align="left"><strong><%=countrybean.getTranslation("Institution")%><!-- Institution --></strong></th>
    <th>&nbsp;</th>
</tr>
<tr class="bodymedlight">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="ar11";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>&continue=y">
	Argentina</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap>1970-2009&nbsp;</td>
	<td>Centro de Estudios Sociales y Ambientales (CENTRO) - LA RED</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>
<tr>
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="bo11";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>&continue=y">
	Bolivia</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap>1970 - 2009&nbsp;</td>
	<td>Viceministerio de Defensa Civil y Cooperaci&oacute;n al Desarrollo Integral - LA RED</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>
<tr>

<tr class="bodymedlight">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="ch11";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>&continue=y">
	Chile</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap>1970 - 2009&nbsp;</td>
	<td>Universidad de Chile - LA RED</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr>
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="co11";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>&continue=y">
	Colombia</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap>1970-2009&nbsp;</td>
	<td>Direcci&oacute;n de Gesti&oacute;n de Riesgos (DGR) - Corporaci&oacute;n OSSO</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>
<tr class="bodymedlight">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="cr11";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>&continue=y">
	Costa Rica</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap>1970 - 2009&nbsp;</td>
	<td>Comisi&oacute;n Nacional de Prevenci&oacute;n de Riesgo y Atenci&oacute;n de Emergencias (CNE)</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>
<tr>
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="ec11";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>&continue=y">
	Ecuador</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap>1970 - 2009&nbsp;</td>
	<td>Secretar&iacute;a Nacional de Gestion de Riesgo (SNGR)</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>
<tr class="bodymedlight">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="sa11";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>&continue=y">
	El Salvador</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap>1970 - 2009&nbsp;</td>
	<td>Servicio Nacional de Estudios Territoriales (SNET)</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr>
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="gu11";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>&continue=y">
	Guatemala</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap>1970 - 2009&nbsp;</td>
	<td>LA RED, FLACSO (G. Gellert)</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr class="bodymedlight">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="mx11";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>&continue=y">
	Mexico</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap>1970 - 2009&nbsp;</td>
	<td>LA RED - CIESAS </td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr>
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="pa11";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>&continue=y">
	Panama</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap>1988 - 2009&nbsp;</td>
	<td>Sistema Nacional de Protecci&oacute;n Civil (SINAPROC)</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>


<tr class="bodymedlight">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="pe11";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>&continue=y">
	Peru</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap>1970 - 2009&nbsp;</td>
	<td>Centro de Estudios y Prevenci&oacute;n de Desastres (PREDES)</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>


<tr>
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="ve11";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>&continue=y">
	Venezuela</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap>1970 - 2009&nbsp;</td>
	<td>Centro Nacional de Prevenci&oacute;n y Atenci&oacute;n de Desastres (CENAPRAD)</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>
</table>
</td></tr>
<tr>
    <td align="center" colspan=4>
  <A  class="linkText" href="http://gar-isdr.desinventar.net" target='_blank' class='linkText'>open Platform  in  separate window</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <A  class="linkText" href="https://www.desinventar.net" target='_blank' class='linkText'>open DesInventar.net in  separate window</a>&nbsp;&nbsp;
    </td>
</tr>
 
 </table>
<script language="JavaScript">
<%=sSetDescriptors%>
</script>

<% 	// close the database object 
	dbCon.close(); %>

<%@ include file="/html/footer.html" %>
<br>
</body>
</html>
