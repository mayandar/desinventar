<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<%@ page info="DesConsultar Connection Diagnostics page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.system.Sys" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
 <body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
 
<table width="100%" border="0">
<tr><td align="left">
<% /* create main connection:*/ %>
<span class=subTitle>Creating DesInventar Server 9.2.11  Database:</span><br>
<br>
</td></tr>
<tr><td align="left">
Creation of a new DesInventar JDBC database: 
<%
// first, clean previous attempts with stalled connections
dbConnection.resetPool();
pooledConnection dbTestConnection=null; 
Connection con=null; 
Statement stmt=null; 
ResultSet rset=null; 
boolean bConnectionOK=false; 
dbTestConnection=new pooledConnection(countrybean.country.sdriver,countrybean.country.sdatabasename, countrybean.country.susername,countrybean.country.spassword);
bConnectionOK = dbTestConnection.getConnection();
boolean bContainsDesInventar=false;
if (bConnectionOK)
	con=dbTestConnection.connection;
ServletContext sc = getServletConfig().getServletContext();
// DI7.0 ships with this empty DesInventar access database
String sSourcePath= sc.getRealPath("/scripts");
String strFileName=sSourcePath+"/create_"+DbImplementation.FolderNames[countrybean.country.ndbtype]+".sql";
try
	{
		File f=new File(strFileName);
		if (f.exists())
		{
			FileReader javaIn = new FileReader(f);
	        int nSize = (int) f.length();
	        char[] cBuffer = new char[nSize];
	        int nRead = javaIn.read(cBuffer, 0, nSize);
	        String sScript=new String(cBuffer);
	        System.out.println("\nPROCESSING FILE: " + strFileName + " Size=" + nSize + "  read=" + nRead);
	        dbutils dbUtil= new dbutils();
			dbUtil.executeScript(sScript, con);
	        javaIn.close();
		}
%>
<br><br>Executed Database creation script: <%=strFileName%>
<%	}
catch (Exception excreate)
	{
%>
<br><br>Error while attempting to create Database: <%=strFileName%><br>
Error: <%=excreate.toString()%>
<br><br>
<%	}
strFileName=sSourcePath+"/seed_data_"+countrybean.getLanguage().toLowerCase()+".sql";
if (request.getParameter("seed")!=null)
	{
	try
		{
			File f=new File(strFileName);
			if (!f.exists())
				{
				strFileName=sSourcePath+"/seed_data_en.sql";
				f=new File(strFileName);
				}
			if (f.exists())
			{
				FileReader javaIn = new FileReader(f);
		        int nSize = (int) f.length();
		        char[] cBuffer = new char[nSize];
		        int nRead = javaIn.read(cBuffer, 0, nSize);
				String sScript=new String(cBuffer);
		        System.out.println("\nPROCESSING FILE: " + strFileName + " Size=" + nSize + "  read=" + nRead);
		        dbutils dbUtil= new dbutils();
				dbUtil.executeScript(sScript, con);
		        javaIn.close();
			}
			
	%>
	<br><br>Executed SEED DATA creation script: <%=strFileName%>
	<br><br>
	<%	}
	catch (Exception excreate)
		{
	%>
	<br><br>Error while attempting to create Seed Data: <%=strFileName%><br>
	Error: <%=excreate.toString()%>
	<br><br>
	<%	}
	}
%>
<br><br><br><br><br><br>
<a href="/DesInventar/inv/ConnectionWizard.jsp?usrtkn=<%=countrybean.userHash%>&rnd=<%=(int)(Math.random()*9999)%>">Click here to finish setting and testing your database Connection</a>
</td></tr>
</table>
<br><br>
</body>
</html>
