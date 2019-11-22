<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>DesConsultar on-line Connection Error</title>
</head>
<%@ page info="DesConsultar Connection Error page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.util.htmlServer" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/header",countrybean.getLanguage(),out);%>

<table width="580" border="0">
<tr><td align="center">
<IMG height=6 src="/DesInventar/images/r.jpg" width=580><br>
</td></tr>
</table>
<table width="680" border="0">
<tr><td align="center">
<% 
/* Reset all possibly erronoeus connections:*/ 
dbConnection.resetPool();

dbConnection dbCon=new dbConnection(countrybean.country.sdriver,countrybean.country.sdatabasename,
                      countrybean.country.susername,countrybean.country.spassword);
boolean bConnectionOK = dbCon.dbGetConnectionStatus();

%>
<span class=subTitle>DesInventar Server 9.2.11: ERROR CONNECTING TO DATABASE!!!<br>
</span><br>
<br>
</td></tr>
<tr><td align="left">
<strong>You have the Following options:</strong><br>
<br>
<br><br>a) You want to <a href="/DesInventar/inv/admintab.jsp?sub=regionManager.jsp&scountryid=<%=countrybean.countrycode>&editRegion=yes">provide/correct Database required parameters. You must later retry the Connection</a>
<br><br>b) You have fixed the problems with your Database (created an ODBC datasource?) and just want to <a href="/DesInventar/index.jsp">retry the Connection</a>
<br><br><br><br><br></td></tr>
</table>
<br>
<br>
Pool status:<br>
<%=dbConnection.dumpStatus()%>
<br>
<br>
<br>Total Memory=<%=Runtime.getRuntime().totalMemory()%>
<br>Free Memory=<%=Runtime.getRuntime().freeMemory() %><br><br>
<%@ include file="/html/footer.html" %>
</body>
</html>
