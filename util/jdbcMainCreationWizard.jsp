<html>
<%@ page info="DesConsultar Connection Diagnostics page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.system.Sys" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/header",countrybean.getLanguage(),out);%>
 
<table width="100%" border="0">
<tr><td align="left">
<% /* create main connection:*/ %>
<span class=subTitle>Creating DesInventar Server 9.2.11 MAIN Database [JDBC]:</span><br>
<br>
</td></tr>
<tr><td align="left">
Creation of a new Main DesInventar JDBC database: 
<%
// first, clean previous attempts with stalled connections
dbConnection.resetPool();
dbConnection dbCon=null; 
Connection con=null; 
boolean bConnectionOK=false; 
// default database
dbCon=new dbConnection();
bConnectionOK = dbCon.dbGetConnectionStatus();
if (bConnectionOK)
	con=dbCon.dbGetConnection();
ServletContext sc = getServletConfig().getServletContext();
// DI7.0 ships with this empty DesInventar access database
String sSourcePath= sc.getRealPath("/scripts");
String strFileName=sSourcePath+"/create_main_"+DbImplementation.FolderNames[Sys.iDatabaseType]+".sql";
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
		<br><br><br><br><br><br>
		<a href="/DesInventar/index.jsp?rnd=<%=(int)(Math.random()*9999)%>">Click here to retry testing your database Connection</a>
		</td></tr>
		</table>
		<br>
<%	}
catch (Exception excreate)
	{
%>
<br><br>Error while attempting to create Database: <%=strFileName%><br>
Error: <%=excreate.toString()%>
<br><br><br><br><br><br>
<a href="/DesInventar/index.jsp?rnd=<%=(int)(Math.random()*9999)%>">Click here to retry your database Connection</a>
</td></tr>
</table>
<br>
<%	}
%>
</body>
</html>
