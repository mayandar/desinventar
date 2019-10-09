<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<%@ page info="DesConsultar Connection Diagnostics page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.util.htmlServer" %>
<%@ page import="org.lared.desinventar.util.DICountry" %>
<%@ page import="org.lared.desinventar.system.Sys" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%@ include file="/util/opendefaultdatabase.jspf" %>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
 <body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
 
<table width="100%" border="0">
<tr><td align="left">
<% /* create main connection:*/ %>
<span class=subTitle>Creating DesInventar Server 9.2.11  Database:</span><br>
<br>
</td></tr>
<tr><td align="left">
Results of searching for a DesInventar database:<br>
<%
ServletContext sc = getServletConfig().getServletContext();
// searches for a DesInventar access database of the form inventXX.mdb
String sBasePath= countrybean.country.sjetfilename;
countrybean.country.sjetfilename=(sBasePath=sBasePath.replace('\\','/'));
File fDir=new File(sBasePath);
String[] filename= fDir.list();
String sName="";
String sIdealName="invent"+countrybean.countrycode.toLowerCase()+".mdb";
for (int j=0; j<filename.length && sName.length()==0; j++)
    {
	if (filename[j].toLowerCase().equals(sIdealName))
		sName=filename[j];
	}
if (sName.length()==0)
  for (int j=0; j<filename.length && sName.length()==0; j++)
    {
	if (filename[j].toLowerCase().startsWith("invent") && filename[j].toLowerCase().endsWith(".mdb"))
		sName=filename[j];
	}
if (sName.length()==0)
{
%><br><br>DesInventar could NOT find ANY database in this location: <%=sBasePath%>
<br>
<a href="/DesInventar/inv/ConnectionWizard.jsp?rnd=<%=(int)(Math.random()*9999)%>&usrtkn=<%=countrybean.userHash%>"">Click here to other options for your connection</a>
<%
}
else
{
sBasePath= countrybean.country.sjetfilename;
if (!sBasePath.endsWith("/"))
	sBasePath+="/";
sBasePath+=sName;  //"invent"+countrybean.countrycode+".mdb";
sBasePath=sBasePath.replace("/","\\");
// only for windows machines. The different drivers, with the path path to database
if (countrybean.country.sdriver.startsWith("sun.jdbc.odbc"))
	countrybean.country.sdatabasename=Sys.sDefaultODBCtring+sBasePath+";";
else if (countrybean.country.sdriver.startsWith("net.ucanaccess"))
	countrybean.country.sdatabasename=Sys.sAccess64DefaultString+sBasePath+";";
else	
	countrybean.country.sdatabasename=Sys.sDefaultIZMADOString+sBasePath+";";

// now try to open it, to report the results and to 
%>
<br><br>DesInventar found an enabled this database: <%=sBasePath%>
<% 
countrybean.country.updateWebObject(con);
%>
<br><br><br><br><br><br>
<a href="/DesInventar/inv/ConnectionWizard.jsp?rnd=<%=(int)(Math.random()*9999)%>&usrtkn=<%=countrybean.userHash%>">Click here to finish setting and testingConnection</a>
<%
  }
// close the database object 
dbCon.close();
%>
</td></tr>
</table>
<br>
</body>
</html>
