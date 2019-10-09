<html>
<%@ page info="DesConsultar Connection Diagnostics page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.system.Sys" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />

 <%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/header",countrybean.getLanguage(),out);%>
<table width="100%" border="0">
<tr><td align="left">
<% /* create main connection:*/ %>
<span class=subTitle>Creating DesInventar Sendai Server 10.0.1 Main Database:</span><br>
<br>
</td></tr>
<tr><td align="left">
A default database has been found at:
<%
ServletContext sc = getServletConfig().getServletContext();
// DI7.0 ships with this empty DesInventar access database
String sSourcePath= sc.getRealPath("/desinventar.mdb_");
String sBasePath= "/etc/desinventar/desinventar.mdb";
try
	{
	File  sTestFile=new File(sBasePath);
	if (!sTestFile.exists())
		{
	        File fEtcFolder=new File("/etc");
			try{fEtcFolder.mkdir();} catch (Exception e){}
    		fEtcFolder=new File("/etc/desinventar");
			try{fEtcFolder.mkdirs();} catch (Exception e){}
	    	boolean bEtcOK=(fEtcFolder.exists()&& fEtcFolder.isDirectory());
			if (!bEtcOK)
				sBasePath=sc.getRealPath("/desinventar.mdb");
			FileCopy.copy(sSourcePath,sBasePath);
		}
	}
catch (Exception e)
	{
	}	
// only for windows machines.... with ACCESS
sSourcePath=sSourcePath.replace("/","\\");
// before doing it, saves the properties file..
Sys.sDataBaseName = Sys.sDefaultAccessMainString;
  // DesInventar main user/schema/database (depending on DB platform)
Sys.sDbUserName = "";
  // default password
Sys.sDbPassword = "";
  // maximum connections to be allocated in pool
Sys.sMaxConnections = "250";
  // type of database
Sys.iDatabaseType = Sys.iAccessDb;
  // JDBC DRIVERS FOR DATABASE
Sys.sDbDriverName = Sys.sAccess64Driver; // 64 bit direct - no authentication (MS Access)
  // prefix to all template files, dependent on the file system
Sys.strFilePrefix = sc.getRealPath("/");
  // drive prefix to all files, dependent on the file system
Sys.strAbsPrefix = sc.getRealPath("/");
  // Absolute WEB APP DIRECTORY
Sys.sDefaultDir = sc.getRealPath("/");
  // Directory for mail daemon
Sys.strMailDir = sc.getRealPath("/");
Sys.saveProps();
%>
<br><br>Created database: <%=sBasePath%>
<br><br><br><br><br><br>
<a href="/DesInventar/index.jsp">Click here to retry the Connection</a>
</td></tr>
</table>

<br>

<%@ include file="/html/footer.html" %>
</body>
</html>
