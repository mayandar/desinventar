<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>DesConsultar on-line Main Menu</title>
</head>
<%@ page info="front page of DesConsultar On-Line" session="true" %> 
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %> 
<%@ page import="org.lared.desinventar.system.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %> 
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%@ include file="/getCountryTip.jspf" %>
<%
org.lared.desinventar.system.Sys.getProperties();
// load language code (if available)
if (request.getParameter("lang")!=null)
	countrybean.setLanguage(request.getParameter("lang"));
// load DATA language code (if available)
if (request.getParameter("datalng")!=null)
	countrybean.setDataLanguage(request.getParameter("datalng"));
%>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/> 
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/header",countrybean.getLanguage(),out);%>
<%@ include file="/util/opendefaultdatabase.jspf" %>
&nbsp;&nbsp;<table width="700" cellspacing="2" cellpadding="2" border="1"  bordercolor="white" class="pageBackground" rules="none">
<tr>
<td colspan=4 class="title">Automated description generator
</td>
</tr>
<tr><td>
<table width="700" cellspacing="2" cellpadding="2" border="0">
<tr>
    <th width=30>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
    <th align="left"><strong><%=countrybean.getTranslation("CountryOrRegion")%><!-- Country or Region --></strong></th>
    <th align="left"><strong><%=countrybean.getTranslation("Period")%><!-- Period --></strong></th>
    <th align="left"><strong><%=countrybean.getTranslation("Institution")%><!-- Institution --></strong></th>
    <th>&nbsp;</th>
    <th>&nbsp;</th>
</tr>
<%
Statement stmt=con.createStatement();
ResultSet rset=stmt.executeQuery("SELECT * FROM Country");
String sSetDescriptors="";
String sCountryId="";
String sCountryName="";
country cCountry=new country();
String sDescription="";

while (rset.next())
 {
 // same order as in query... 
 cCountry.loadWebObject(rset);
 boolean bPublic=cCountry.bpublic!=0;
 sCountryId=cCountry.scountryid;
 sCountryName=cCountry.scountryname;
 String sPage=countrybean.getLocalOrEnglish(cCountry.spagees,cCountry.spageen);
 sSetDescriptors+=getCountryTip(cCountry, countrybean);
%><tr>
    <td width=30>&nbsp;</td>
	<td nowrap><a class="regionlink" href="/DesInventar/main.jsp?countrycode=<%=sCountryId%>&continue=y">
	<%=sCountryName%></a></td>
	<td><%=cCountry.speriod%></td>
	<td><%=cCountry.sinstitution%></td>
	<td><a  class="linkText" href="/DesInventar/country_profile.jsp?countrycode=<%=sCountryId%>"><%=sCountryName%> <%=countrybean.getTranslation("Profile")%></a></td>
	<td><%
	//sDescription=countrybean.getLocalOrEnglish(cCountry.sdescriptiones,cCountry.sdescriptionen);
	if (sPage!=null && sPage.length()>0)
		  {		  
		  %><a  class="linkText" onmouseover="Tip(sTip<%=sCountryId%>)" onmouseout="UnTip()" href="<%=sPage%>"><%=countrybean.getTranslation("moreinfo")%><!-- more info--></a>
		<%}
	else	
		  {
		  %><a  class="linkText" onmouseover="Tip(sTip<%=sCountryId%>)" onmouseout="UnTip()" href="#"><%=countrybean.getTranslation("moreinfo")%><!-- more info--></a>	
		<%}%></td>
	</tr><%
   }
%>
</table>
<script language="JavaScript">
<%=sSetDescriptors%>
</script>
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

<% 	// close the database object 
	dbCon.close(); %>

<%@ include file="/html/footer.html" %>
<br>
<table width="600" cellspacing="2" cellpadding="2" border="0">
<tr><td align="center">
<br>
<img src="/DesInventar/images/apache.gif" width=130 height=16 border=0 alt="Powered by Apache Web Server">
<img src="/DesInventar/images/tomcat_y.gif" width=50 height=36 border=0 alt="powered by Apache Tomcat JSP server">
</td></tr></table>
<inv:example/>
</body>
</html>
