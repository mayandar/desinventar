<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page info="front page of DesConsultar On-Line" session="true" %> 
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %> 
<%@ page import="org.lared.desinventar.webobject.*" %> 
<%@ page import="org.lared.desinventar.system.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<html>
<head>
<title>DesConsultar on-line Main Menu</title>
</head>
<%
org.lared.desinventar.system.Sys.getProperties();
// load language code (if available)
if (request.getParameter("lang")!=null)
	countrybean.setLanguage(request.getParameter("lang"));
// load DATA language code (if available)
if (request.getParameter("datalng")!=null)
	countrybean.setDataLanguage(request.getParameter("datalng"));
String sRealPath=getServletConfig().getServletContext().getRealPath("/");
htmlServer.outputLanguageHtml(sRealPath+"html","/header",countrybean.getLanguage(),out);
countrybean.init();
//  when shipping to LA: countrybean.setLanguage("ES");
//countrybean.reloadBundles();
%>
<%@ include file="/util/opendefaultdatabase.jspf" %>
<div class="welcomeheadder">
  <div class="navbase">
    <div class="welcome"><strong>Welcome</strong> to DesInventar, a free, open source Disaster Information Management System</div>
  </div>
</div>

<table width="800" cellspacing="2" cellpadding="0" border="1" class="pageBackground" rules="none">
<tr>
    <td align="center">
     <font class='subtitle'><%=countrybean.getTranslation("selectRegionDatabase")%></FONT><br><br>
</tr>
<tr><td>
<table width="99%" cellspacing="0" cellpadding="2" border="1" rules="none">
<tr class="bodydarklight">
    <th width=30>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
    <th align="left"><%=countrybean.getTranslation("CountryOrRegion")%><!-- Country or Region --></th>
    <th align="left"><%=countrybean.getTranslation("Period")%><!-- Period --></th>
    <th align="left"><%=countrybean.getTranslation("Institution")%><!-- Institution --></th>
    <th>&nbsp;</th>
    <th>&nbsp;</th>
</tr>
<%
Statement stmt=con.createStatement();
ResultSet rset=stmt.executeQuery("SELECT * FROM Country order by scountryname");
String sSetDescriptors="";
String sCountryId="";
String sCountryName="";
country cCountry=new country();
boolean bLight=false;
String sBgClass="";
while (rset.next())
 {
 // same order as in query...
 cCountry.loadWebObject(rset);
 boolean bPublic=cCountry.bpublic!=0;
 sCountryId=cCountry.scountryid;
 sCountryName=cCountry.scountryname;
 countrybean.country=cCountry;
 countrybean.dbType=countrybean.country.ndbtype;
 // debug: System.out.println("country:" + sCountryId+"-"+sCountryName);
 if (bPublic)
   {
    if (bLight)
	  sBgClass=" class='bss bodymedlight'";
    else
	  sBgClass=" class='bss bodylight'";
    bLight=!bLight;
	sSetDescriptors+=CountryTip.getInstance().getCountryTip(cCountry, countrybean); 
   %><tr<%=sBgClass%>>
    <td width=30>&nbsp;</td>
	<td nowrap><a class="blackLinks" href="/DesInventar/profiletab.jsp?countrycode=<%=sCountryId%>&continue=y">
	<%=sCountryName%></a>&nbsp;&nbsp;&nbsp;
		    <a  class="greyText" href="/DesInventar/main.jsp?countrycode=<%=sCountryId%>&lang=<%=countrybean.getLanguage()%>"><%=countrybean.getTranslation("Query")%></a>&nbsp;&nbsp;&nbsp;
		    <a  class="greyText" href="/DesInventar/thematic_google.jsp?countrycode=<%=sCountryId%>&lang=<%=countrybean.getLanguage()%>&bookmark=1&maxhits=100&lang=EN&logic=AND&sortby=0&frompage=/thematic_def.jsp&_range=,1.0,3.0,10.0,30.0,100.0,1000.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0&_color=%23ffff88,%23ffcc00,%23ff8800,%23ff0000,%23bb0000,%23770000,%23330000,,,,,,,,&_legend=,,,,,,,,,,,,,&chartColor=1&chartX=1000&chartY=600&chartTitle=&chartSubTitle=&showValues=0&legendType=0&level_rep=0&level_map=1&_variables=1"><%=countrybean.getTranslation("Map")%></a>&nbsp;&nbsp;&nbsp;
	</td>
	<td><%=cCountry.speriod%></td>
	<td><%=cCountry.sinstitution%></td>
	<td><a  class="greyText" href="/DesInventar/country_profile.jsp?countrycode=<%=sCountryId%>&lang=<%=countrybean.getLanguage()%>"><%=countrybean.getTranslation("Profile")%></a>	    </td>
	<td><%
	String sPage=countrybean.getLocalOrEnglish(cCountry.spagees,cCountry.spageen);
	if (sPage!=null && sPage.length()>0)
		  {		  
		  %><a  class="greyText" onMouseOver="Tip(sTip<%=sCountryId%>)" onMouseOut="UnTip()" href="<%=sPage%>"><%=countrybean.getTranslation("moreinfo")%><!-- more info--></a>
		<%}
	else	
		  {
		  %><a  class="greyText"  onmouseover="Tip(sTip<%=sCountryId%>)" onMouseOut="UnTip()" href="#"><%=countrybean.getTranslation("moreinfo")%><!-- more info--></a>	
		<%}%></td>
	</tr><%
   }
 }
%>
</table>
</td>
</tr>
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
