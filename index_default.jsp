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
// load language code (if available)
if (request.getParameter("lang")!=null)
	countrybean.setLanguage(request.getParameter("lang"));
// load DATA language code (if available)
if (request.getParameter("datalng")!=null)
	countrybean.setDataLanguage(request.getParameter("datalng"));
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
          <h4 style="margin-bottom:0; padding-top:5px;">&nbsp;Welcome to DesInventar Open Source Initiative site</h4>
  </div>
</div>

&nbsp;&nbsp;
<table width="1000" cellspacing="2" cellpadding="2" border="1"  bordercolor="white" class="IE_TABLE bs" rules="none">
<tr><td>
<table width="100%" cellspacing="2" cellpadding="2" border="0" class="bs">
<tr class="bodydarklight"><td colspan=6 align="center" height="30" valign="middle"><strong>ASIAN  DATABASES</strong></td></tr>
<tr>
    <th>&nbsp;&nbsp;</th>
    <th colspan="2" align="left"><strong><%=countrybean.getTranslation("CountryOrRegion")%><!-- Country or Region --></strong></th>
    <th align="left" ><strong><%=countrybean.getTranslation("Period")%><!-- Period --></strong></th>
    <th align="left"><strong><%=countrybean.getTranslation("Institution")%><!-- Institution --></strong></th>
    <th>&nbsp;</th>
</tr>
<tr class="bodymedlight bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="etm";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	East Timor</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>Minister of Social and Solidarity, East Timor, supported by UNDRR, UNDP CO</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr class="bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="019";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	India - Orissa</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>Orissa State Disaster Management Authority  OSDMA, supported by UNDRR, UNDP India</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr class="bodymedlight bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="033";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	India - Tamil Nadu</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>State Commissioner of Tamil-Nadu, supported by  UNDRR, UNDP India</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>


<tr class="bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="idn";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Indonesia</a>&nbsp;&nbsp;&nbsp;[<a target="_blank" href="http://dibi.bnpb.go.id/">open in original server</a>]</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>Indonesian National Board for Disaster Management (BNPB), supported by UNDP Indonesia</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr class="bodymedlight bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="irn";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">I.R. Iran   جمهوری اسلامی ایران</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>Ministry of Interior Iran - supported by  UNDRR, UNDP Iran</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr class="bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="jor";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Jordan, Hashemite Kingdom of</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>Jordan Civil Defense, UNDRR</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr class="bodymedlight bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="lao";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Laos</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>NDMO Laos- ADPC</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr class="bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="lbn";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Lebanon</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>Office of the Prime Minister - UNDP/UNDRR</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>


<tr class="bodymedlight bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="npl";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Nepal</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>National Society for Earthquake Technology NSET, supported by  UNDRR, UNDP Nepal</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>



<tr class="bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="lka";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Sri Lanka</a>&nbsp;&nbsp;&nbsp;[<a target="_blank" href="http://www.desinventar.lk/">open in original server</a>]</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td> Ministry of Disaster Management, DMC Sri Lanka - supported by UNDP Sri Lanka</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr class="bodymedlight bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="sy11";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Syrian Arab Republic</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td> Ministry of Local Administration, supported by  UNDRR, UNDP Syria</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>


<tr class="bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="vnm";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Viet Nam</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>MARD - FSCC, supported by UNDP,  UNDRR</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>



<tr class="bodymedlight bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="yem";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Yemen, Republic of</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>Ministry of Environment, Yemen, supported by  UNDRR, UNDP Yemen</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>


<tr class="bss">
    <td class=bss><img src='/DesInventar/images/underconstruction2.png' width=16 border=0 alt="<%=countrybean.getTranslation("Under construction...")%>"></td>
	<% 	cCountry.scountryid="mal";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Maldives</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>Ministry of Defense, supported by UNDP</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr class="bodymedlight bss">
  <td class=bss><img src='/DesInventar/images/underconstruction2.png' width=16 border=0 alt="<%=countrybean.getTranslation("Under construction...")%>"></td>
	<% 	cCountry.scountryid="miz";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	India - Mizoran</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>State Disaster Management Authority, supported by UNDP India, UNDRR</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>
<tr class="bss">
  <td class=bss><img src='/DesInventar/images/underconstruction2.png' width=16 border=0 alt="<%=countrybean.getTranslation("Under construction...")%>"></td>
	<% 	cCountry.scountryid="up";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	India - Uttar Pradesh</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>State Commissioner, supported by UNDP India, UNDRR</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>



<tr class="bodymedlight bss">
    <td class=bss><img src='/DesInventar/images/underconstruction2.png' width=16 border=0 alt="<%=countrybean.getTranslation("Under construction...")%>"></td>
	<% 	cCountry.scountryid="slb";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Solomon Islands</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>SOPAC</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>


<tr class="bss">
    <td class=bss><img src='/DesInventar/images/underconstruction2.png' width=16 border=0 alt="<%=countrybean.getTranslation("Under construction...")%>"></td>
	<% 	cCountry.scountryid="vut";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Vanuatu</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>SOPAC</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>



<tr><td colspan="6">&nbsp;<br/>&nbsp;</td></tr>
<tr class="bodydarklight"><td colspan=6 align="center" height="30" valign="middle"><strong>AFRICAN DATABASES</strong></td></tr>
<tr>
    <th>&nbsp;&nbsp;</th>
    <th colspan="2" align="left"><strong><%=countrybean.getTranslation("CountryOrRegion")%><!-- Country or Region --></strong></th>
    <th align="left"><strong><%=countrybean.getTranslation("Period")%><!-- Period --></strong></th>
    <th align="left"><strong><%=countrybean.getTranslation("Institution")%><!-- Institution --></strong></th>
    <th>&nbsp;</th>
</tr>

<tr class="bodymedlight bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="dji";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Djibouti</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>Centre d'Études et de Recherches de Djibouti (CERD)</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr class="bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="eth";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Ethiopia</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>Disaster Risk Management and Food Security Sector, Ministry of Agriculture, supported by UNDRR</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
 </tr>

<tr class="bodymedlight bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="ken";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Kenya</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>National Disaster Operations Centre  - supported by UNDRR</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr class="bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="mli";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Mali</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>Protection Civile - Mali, supported by UNDRR</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
 </tr>

<tr class="bodymedlight bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="moz";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>&continue=y">
	Mo&ccedil;ambique</a>&nbsp;&nbsp;&nbsp;[<a target="_blank" href="http://moz.gripweb.org/">open in original server</a>]</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>National Disaster Management Institute (INGC) - supported by UNDP Mo&ccedil;ambique,  UNDRR</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr class="bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="uga";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Uganda</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>Office of Prime Minister - Uganda, supported by UNDRR</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
 </tr>


<tr class="bodymedlight bss">
    <td class=bss><img src='/DesInventar/images/underconstruction2.png' width=16 border=0 alt="<%=countrybean.getTranslation("Under construction...")%>"></td>
	<% 	cCountry.scountryid="ma";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Morocco</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>Ministry of Environment</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr class="bss">
    <td class=bss><img src='/DesInventar/images/underconstruction2.png' width=16 border=0 alt="<%=countrybean.getTranslation("Under construction...")%>"></td>
	<% 	cCountry.scountryid="egy";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Egypt</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>Crisis & Disaster management, Dept., IDSC, The Cabinet Of Egypt, supported by  UNDRR, UNDP Egypt</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>



<tr><td colspan="6">&nbsp;<br/>&nbsp;</td></tr>
<tr class="bodydarklight"><td colspan=6 align="center" height="30" valign="middle"><strong>LATIN AMERICAN DATABASES</strong></td></tr>
<tr>
    <th>&nbsp;&nbsp;</th>
    <th colspan="2" align="left"><strong><%=countrybean.getTranslation("CountryOrRegion")%><!-- Country or Region --></strong></th>
    <th align="left"><strong><%=countrybean.getTranslation("Period")%><!-- Period --></strong></th>
    <th align="left"><strong><%=countrybean.getTranslation("Institution")%><!-- Institution --></strong></th>
    <th>&nbsp;</th>
</tr>
<tr class="bodymedlight bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="ar11";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Argentina</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>Centro de Estudios Sociales y Ambientales (CENTRO) - LA RED</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>
<tr class="bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="bol";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Bolivia</a>&nbsp;
    </td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>Viceministerio de Defensa Civil y Cooperaci&oacute;n al Desarrollo Integral - LA RED</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>
<tr>

<tr class="bodymedlight bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="chl";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Chile</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a><!--http://online.desinventar.org/desinventar/?r=CHL-1257983285-chile_inventario_historico_de_desastres&lang=eng --></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>Universidad de Chile - LA RED</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr class="bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="col";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Colombia</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a>   <!--http://online.desinventar.org/desinventar/?r=COL-1250694506-colombia_inventario_historico_de_desastres&lang=eng --></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>Direcci&oacute;n de Gesti&oacute;n de Riesgos (DGR) - Corporaci&oacute;n OSSO</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr class="bodymedlight bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="cri";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Costa Rica</a>&nbsp;  <!--http://online.desinventar.org/desinventar/?r=CRI-1250694968-costa_rica_inventario_historico_de_desastres&lang=eng --></td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>Comisi&oacute;n Nacional de Prevenci&oacute;n de Riesgo y Atenci&oacute;n de Emergencias (CNE)</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr class="bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="ecu";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Ecuador</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>Secretar&iacute;a Nacional de Gestion de Riesgo (SNGR)</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr class="bodymedlight bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="slv";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	El Salvador</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a>   <!--http://online.desinventar.org/desinventar/?r=SLV-1250695592-el_salvador_inventario_historico_de_desastres&lang=eng --></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>Servicio Nacional de Estudios Territoriales (SNET)</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr class="bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="gtm";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Guatemala</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a> <!--http://online.desinventar.org/desinventar/?r=GTM-1257291154-guatemala_inventario_historico_de_desastres&lang=eng --></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>LA RED, FLACSO (G. Gellert)</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr class="bodymedlight bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="guy";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Guyana</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>Civil Defense</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr class="bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="hnd";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Honduras</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>COPECO - LA RED</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>


<tr class="bodymedlight bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="jam";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Jamaica</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>University of West Indies - MONA</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>


<tr class="bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="mex";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Mexico</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>LA RED - CIESAS </td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr class="bodymedlight bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="nic";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Nicaragua</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>LA RED</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>



<tr class="bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="pan";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Panama</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>Sistema Nacional de Protecci&oacute;n Civil (SINAPROC)</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>


<tr class="bodymedlight bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="per";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Peru</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>Centro de Estudios y Prevenci&oacute;n de Desastres (PREDES)</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr class="bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="ury";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Uruguay</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>Sistema nacional de Emergencias, SINAE</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr class="bodymedlight bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="ven";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Venezuela</a>&nbsp; <!--http://online.desinventar.org/desinventar/?r=VEN-1250695640-venezuela_inventario_historico_de_desastres&lang=eng --></td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>Centro Nacional de Prevenci&oacute;n y Atenci&oacute;n de Desastres (CENAPRAD)</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

	
<tr class="bss">
    <td class=bss><img src='/DesInventar/images/underconstruction2.png' width=16 border=0 alt="<%=countrybean.getTranslation("Under construction...")%>"></td>
	<% 	cCountry.scountryid="rdo";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Republica Dominicana</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>LA RED - ERN</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>


<tr class="bodymedlight bss">
    <td class=bss><img src='/DesInventar/images/underconstruction2.png' width=16 border=0 alt="<%=countrybean.getTranslation("Under construction...")%>"></td>
	<% 	cCountry.scountryid="tt";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Trinidad &amp; Tobago</a>&nbsp;</td>
	<td><a  class="linkText" href="/DesInventar/profiletab.jsp?countrycode=<%=cCountry.scountryid%>"><%=countrybean.getTranslation("Profile")%></a></td>
	<td nowrap><%=cCountry.speriod%>&nbsp;</td>
	<td>University of West Indies - MONA</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr><td colspan="6">&nbsp;<br/>&nbsp;</td></tr>
<tr class="bodydarklight"><td colspan=6 align="center" height="30" valign="middle"><strong>EVENT-SPECIFIC DATABASES</strong></td></tr>
<tr>
    <th>&nbsp;&nbsp;</th>
    <th colspan="2" align="left"><strong><%=countrybean.getTranslation("CountryOrRegion")%><!-- Country or Region --></strong></th>
    <th align="left"><strong><%=countrybean.getTranslation("Period")%><!-- Period --></strong></th>
    <th align="left"><strong><%=countrybean.getTranslation("Institution")%><!-- Institution --></strong></th>
    <th>&nbsp;</th>
</tr>

<tr class="bodymedlight bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="HAT";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Haiti Earthquake</a>&nbsp;</td>
	<td></td>
	<td nowrap>2010&nbsp;</td>
	<td>supported by UNDP</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>


<tr class="bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="MYH";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Myanmar NARGIS (Household Survey)</a>&nbsp;</td>
	<td></td>
	<td nowrap>2008&nbsp;</td>
	<td>supported by  UNDRR</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr class="bodymedlight bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="idt";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Indonesia TSUNAMI</a>&nbsp;</td>
	<td></td>
	<td nowrap>2004&nbsp;</td>
	<td>supported by UNDP</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr class="bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="mv";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Maldives TSUNAMI</a>&nbsp;</td>
	<td></td>
	<td nowrap>2004&nbsp;</td>
	<td>supported by UNDP</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr class="bodymedlight bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="slt";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Sri Lanka TSUNAMI</a>&nbsp;</td>
	<td></td>
	<td nowrap>2004&nbsp;</td>
	<td>supported by UNDP</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr class="bss">
    <td>&nbsp;</td>
	<% 	cCountry.scountryid="ho";
	cCountry.getWebObject(con);
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean);  %>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=cCountry.scountryid%>">
	Honduras - MITCH</a>&nbsp;</td>
	<td></td>
	<td nowrap>1998&nbsp;</td>
	<td>COPECO</td>
	<td><a  class="linkText" onMouseOver="Tip(sTip<%=cCountry.scountryid%>)"  onmouseout="UnTip()"  href="#"><%=countrybean.getTranslation("More Info")%></a></td>
	</tr>

<tr class="bss">
	<td colspan="7">&nbsp;</td>
	</tr>
    
<tr class="bss">
    <td class=bss><img src='/DesInventar/images/underconstruction2.png' width=16 border=0 alt="<%=countrybean.getTranslation("Under construction...")%>"></td>
	<td nowrap>&nbsp;=&nbsp;<strong><%=countrybean.getTranslation("Under construction...")%></strong>
    </td>
	<td></td>
	<td nowrap></td>
	<td></td>
	<td></td>
	</tr>



</table>
</td></tr>
<tr>
    <td align="center" colspan=4>
<% if (Sys.bRequireLogin)
	{%>	 	
     <A  class="linkText" href="/DesInventar/inv/login.jsp" class='linkText'><%=countrybean.getTranslation("MembersLoginHere")%><!-- Members Login here--></a>
   <%}
else
	{%>	 	
     <A  class="linkText" href="/DesInventar/inv/admintab.jsp?sub=regionManager.jsp" class='linkText'><%=countrybean.getTranslation("clickToCreateNewRegion")%><!-- click here to Create a new Region--></a>
   <%}%>
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
