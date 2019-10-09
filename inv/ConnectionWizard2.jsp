<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<%@ page info="DesConsultar Connection Diagnostics page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.system.Sys" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%@ include file="/util/opendefaultdatabase.jspf" %>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
 <body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
 
<table width="100%" border="0">
<tr><td align="left">
<% /* create main connection:*/ %>
<span class=subTitle>Creating DesInventar Server Database:</span><br>
<br>
</td></tr>
<tr><td align="left">
Creation of a new BLANK DesInventar MS Access database: 
<%
// first, clean previous attempts with stalled connections
dbConnection.resetPool();
ServletContext sc = getServletConfig().getServletContext();

String dblang=countrybean.not_null(request.getParameter("dblang"));
// DI9.0 ships with some multilingual empty DesInventar access database AND a blank database
String sSourcePath= sc.getRealPath("model.mdb");
String sBasePath= countrybean.country.sjetfilename;
if (!sBasePath.endsWith("/"))
   sBasePath+="/";
sBasePath+="invent"+countrybean.countrycode+".mdb";
try
	{
	FileCopy.copy(sSourcePath,sBasePath);
	%>
    <br><br>Using internal command: FileCopy.copy(<%=sSourcePath%>,<%=sBasePath%>);
    <% 
	}
catch (Exception excreate)
	{
	%>
	<br><br>Error while attempting to create Database: <%=sBasePath%><br>
	Error: <%=excreate.toString()%>
	<br><br>
	<%	}
// close the database object 
dbCon.close();
pooledConnection pCon=new pooledConnection(countrybean.country.sdriver,countrybean.country.sdatabasename, countrybean.country.susername,countrybean.country.spassword);
bConnectionOK = pCon.getConnection();
boolean bContainsDesInventar=false;
if (bConnectionOK)
	con=pCon.connection;

String strFileName=sc.getRealPath("/scripts/")+"/seed_data_"+countrybean.getLanguage().toLowerCase()+".sql";
if (request.getParameter("dblang")!=null)
	{
	try
		{
			File f=new File(strFileName);
			if (!f.exists())
				{
				strFileName=sc.getRealPath("/scripts/")+"/seed_data_en.sql";
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
<a href="/DesInventar/inv/ConnectionWizard.jsp?rnd=<%=(int)(Math.random()*9999)%>&usrtkn=<%=countrybean.userHash%>">Click here to finish setting and testing your database Connection</a>
</td></tr>
</table>
<br><br>
</body>
</html>
