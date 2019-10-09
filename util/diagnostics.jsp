<html>
<%@ page info="DesConsultar Connection Diagnostics page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.util.htmlServer" %>
<%@ page import="org.lared.desinventar.util.DICountry" %>
<%@ page import="org.lared.desinventar.system.Sys" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />

 <%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/header",countrybean.getLanguage(),out);%>
<table width="580" border="0">
<tr><td align="center">
<% // diagnose main connection:
String strPropertiesFile = "/etc/desinventar/desinventar.properties";
Sys.getProperties();
%>System get properties operation : <%=Sys.sLastError%><br>
<%FileInputStream fisPropFile = null;
    try
    {
      fisPropFile = new FileInputStream(strPropertiesFile);
    }
    catch (Exception eEtc)
    {
	 %>System file opening ERROR: <%=eEtc.toString()%><br><%
    }
    if (fisPropFile != null)
    {
	fisPropFile.close();
	}

	
dbConnection dbCon=null; 
Connection con=null; 
boolean bConnectionOK=false; 
// opens the default database 
dbCon=new dbConnection();
bConnectionOK = dbCon.dbGetConnectionStatus();
if (!bConnectionOK) // error,report
	{
	%>ERROR Connecting:<br>
	<%=dbCon.dbGetConnectionError()%><%
	}
else
	{ // diagnose other region connections...
	%>Connection to DesInventar main DB is OK...<br><%
	con=dbCon.dbGetConnection();
	dbConnection dbDB=null; 
	Statement stmt=con.createStatement(); 
	ResultSet rset=stmt.executeQuery("select * from country");
	DICountry countrybean=new DICountry();
	while (rset.next())
		{
		// opens each database
		countrybean.country.loadWebObject(rset); 
		dbDB=new dbConnection(countrybean.country.sdriver,countrybean.country.sdatabasename,
	                          countrybean.country.susername,countrybean.country.spassword);
		}
	dbCon.close();
	}	

%>
</td></tr>
</table>
DATABASE CONNECTION POOL at <%=java.util.Calendar.getInstance().getTime().toGMTString()%>:<br>
<%=dbConnection.dumpStatus()%>
<br>
<a href='resetPool.jsp'>Click here to reset the connection pool</a>
<br>
<br>Total Memory=<%=Runtime.getRuntime().totalMemory()%>
<br>Free Memory=<%=Runtime.getRuntime().freeMemory() %><br><br>
<br>Servlet Path=<%=request.getServletPath()%><br>
<br>Path info=<%=request.getPathInfo()%><br>
<br>


<%@ include file="/html/footer.html" %>
</body>
</html>
