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
<body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>">  
<table width="680" border="0">
<tr><td align="center">
<%// Check for existing ODBC connection:
// first, clean previous attempts with stalled connections
// dbConnection.resetPool();
// Declaration of default Dabatase variables available to the page 
Connection con=null; 
Statement stmt=null; 
ResultSet rset=null; 
boolean bConnectionOK=false; 
// opens the database 
boolean bContainsDesInventar=false;
dbConnection dbCon=new dbConnection(countrybean.country.sdriver,countrybean.country.sdatabasename,
                      countrybean.country.susername,countrybean.country.spassword);
bConnectionOK = dbCon.dbGetConnectionStatus();
if (bConnectionOK)
	{	
	con=dbCon.dbGetConnection();
	// Database exists. 
	try
		{
		// test that fichas/extension exists!!!
		stmt=con.createStatement();
		rset=stmt.executeQuery("select clave_ext from extension where clave_ext=-1999");
		bContainsDesInventar=true;
		}
	catch (Exception eNotDI)
		{
		} 
	finally
		{
		try {
			rset.close();
			stmt.close();
			}
		catch (Exception ecls)
			{}	
		}
	// if OK, back to the manager
	if (bContainsDesInventar)	
		{
    	// checks for version issues
		ServletContext sc = getServletConfig().getServletContext();
	    dbutils.updateDataModelRevision(dbCon, countrybean.country.ndbtype, sc.getRealPath("scripts"));
		dbCon.close();
		%><jsp:forward page='/inv/regionManager.jsp'/><%  // ?usrtkn=<%=countrybean.userHash%>
		}
    dbCon.close();
	}
if (!bConnectionOK)
	{%>
	<span class=subTitle>DesInventar Server has not been able to detect your JDBC Database.</span><br>
	<span class=warning>Your Database administrator must create the database and give you the right parameters to connect. Other possible issues can be the DB Username and Password have not been correctly set, or other connections parameters are missing or wrong (Database name, host, port)<br></span>
	<br>The database returned the following message when attempting to connect: <%=dbCon.m_connection.strConnectionError%><br>
<%  }
else
	{%>
	<span class=subTitle>DesInventar Server has detected your JDBC Database, but it contains NO DesInventar tables.<br>
	</span><span class=warning>DesInventar or Your Database administrator must run the initialization SQL script<br>
	</span><br>
<%  }
}
%>		
<br>
</td></tr>
<tr><td align="left">
<strong>You have the Following options:</strong><br>
<br>
<br><br>a) You want DesInventar to create your database tables: <a href="/DesInventar/inv/jdbcCreationWizard.jsp?usrtkn=<%=countrybean.userHash%>">click here to run the initialization script</a>.
<br><br>b) You want DesInventar to create your database tables <strong>with basic event/cause data</strong>: <a href="/DesInventar/inv/jdbcCreationWizard.jsp?seed=y&usrtkn=<%=countrybean.userHash%>">click here to run the initialization script</a>.
<br><br>c) You or your database administrator have fixed the problem (created and initialized) the JDBC <strong>DesInventar</strong> database connection and just want to <a href="/DesInventar/inv/adminManager.jsp?usrtkn=<%=countrybean.userHash%>">retry the Connection</a>
<br><br>d) If you typed a wrong parameter just click on 'Back' in your browser and re-enter or fix your Database connection</a>
<br><br><br><br><br></td></tr>
</table>

<br>

</body>
</html>
