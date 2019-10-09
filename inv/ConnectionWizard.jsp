<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<%@ page info="DesConsultar Connection Diagnostics page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.map.MapUtil" %>
<%@ page import="org.lared.desinventar.system.Sys" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight'  dir="<%=countrybean.getTranslation("ltr")%>"> 
<table width="680" border="0">
<tr><td align="center">
<%// Check for existing ODBC connection:
// first, clean previous attempts with stalled connections
dbConnection.resetPool();
// Declaration of default Dabatase variables available to the page 
pooledConnection dbTestConnection=null; 
Connection con=null; 
Statement stmt=null; 
ResultSet rset=null; 
boolean bConnectionOK=false; 
// opens the database 
dbConnection dbCon=new dbConnection(countrybean.country.sdriver,countrybean.country.sdatabasename,
                      countrybean.country.susername,countrybean.country.spassword);
bConnectionOK = dbCon.dbGetConnectionStatus();
if (bConnectionOK)
	{
	con=dbCon.dbGetConnection();
	// Database exists, checks for version issues:
	ServletContext sc = getServletConfig().getServletContext();
    dbutils.updateDataModelRevision(dbCon, countrybean.country.ndbtype, sc.getRealPath("scripts"));
	con=dbCon.dbGetConnection();
	// transfer of the MAP DATABASE regiones table!!!	
	MapUtil map = new MapUtil();
	map.checkRegions(con, sc.getRealPath("/"), countrybean.country);

    dbCon.close();
	// now, back to the manager
	%><jsp:forward page='/inv/regionManager.jsp?usrtkn=<%=countrybean.userHash%>'/><%
	}
String sBasePath= countrybean.country.sjetfilename+"/invent"+countrybean.countrycode+".mdb";
dbCon.close();
%>
<span class=subTitle>DesInventar Server has not been able to find your Database.</span><br>
<br>
Message was: <%=dbCon.dbGetConnectionError()%>
<br>
</td></tr>
<tr><td align="left">
<strong>You have the Following options:</strong><br>
<br>
<br>a) You have an existing database in that location and you want <strong>DesInventar</strong> to 
<a href="/DesInventar/inv/ConnectionWizard1.jsp?usrtkn=<%=countrybean.userHash%>">find it and use it</a>. The database expected location is: <%=countrybean.country.sjetfilename%>
<br><br>b) You want <strong>DesInventar</strong> to <a href="/DesInventar/inv/ConnectionWizard2.jsp?usrtkn=<%=countrybean.userHash%>">create a BLANK DesInventar database</a>(the database will be created as: <%=sBasePath%>).
<br><br>c) You want <strong>DesInventar</strong> to <a href="/DesInventar/inv/ConnectionWizard2.jsp?dblang=_<%=countrybean.getLanguage()%>&usrtkn=<%=countrybean.userHash%>">create a BLANK DesInventar database with predefined EVENTS and CAUSES 
</a>(the database will be created as: <%=sBasePath%>).
<br><br>d) You have created/fixed your <strong>DesInventar</strong> database and just want to <a href="/DesInventar/inv/ConnectionWizard.jsp?usrtkn=<%=countrybean.userHash%>">retry the Connection</a>
<br><br>3) If you typed a wrong parameter, click <a href="regionsUpdate.jsp?action=1&?usrtkn=<%=countrybean.userHash%>">HERE to re-enter or fix your Database connection parameters</a>
<br><br><br><br><br></td></tr>
</table>

<br>

</body>
</html>
