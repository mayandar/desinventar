<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<%@ page info="DesConsultar Connection Diagnostics page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.system.Sys" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%if (user.iusertype<20) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}%>
<%@ include file="/util/opendatabase.jspf" %>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/iheader",countrybean.getLanguage(),out);%>
<%@ taglib uri="/inventag.tld" prefix="inv" %>
<%
int nTabActive=9; // 
String[] sTabNames={countrybean.getTranslation("Region"),countrybean.getTranslation("Geography"),countrybean.getTranslation("Events"),
           countrybean.getTranslation("Causes"),countrybean.getTranslation("Extension"),countrybean.getTranslation("Query"),
           countrybean.getTranslation("EditData"),countrybean.getTranslation("DataEntry"),countrybean.getTranslation("Admin"),
		   countrybean.getTranslation("Sendai"),countrybean.getTranslation("Security")};
String[] sTabIcons={"","","","","","","","","","","",""};
String[] sTabLinks={"index.jsp","geographytab.jsp","eventab.jsp",
				"causetab.jsp","extendedtab.jsp","querytab.jsp",
				"resultstab.jsp","datacardtab.jsp","admintab.jsp",
				"sendaitab.jsp","securitytab.jsp"};
%>
<%@ include file="/util/tabs.jspf" %>
<br/><br/> 
<table width="1024" border="0" rules="none">
<tr>
	<td align="center" valign="top">
	<!-- Content goes after this comment -->
    <table width="90%" border="0">
        <tr><td align="center">
         <font color="Blue"><%=countrybean.getTranslation("Region")%></font>
         <b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font>
          - [<jsp:getProperty name ="countrybean" property="countrycode"/>]
         </td>
        </tr>
    </table>
	<!-- Content goes before this comment -->
	</td>
</tr>
<tr><td align="left">
<% /* create main connection:*/ %>
<br/><br/><br/>
<span class=subTitle>Rolling back the migration from Sendai format to classic DesInventar:</span><br>
<br>
</td></tr>
<tr><td align="left">
Verification of a DesInventar database type:  <%
out.flush();
String dblang=countrybean.not_null(request.getParameter("dblang"));
ServletContext sc = getServletConfig().getServletContext();

boolean isDI=true;
try
{
	stmt=con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	rset=stmt.executeQuery("select DEATHS_FEMALE, DEATHS_MALE from extension where clave_ext=-1");
	isDI=false;
	rset.close();
}
catch (Exception e)	
{// todo: log here the error.
	System.out.println("[DI9] Error testing DI database:" +e.toString());
}	

if (!isDI)
	{
		dbutils.rollBackFromSendai(dbCon, con, out, countrybean, sc, dblang);
		%><br><br>Migration completed !<br>
		<%
	}
else
	{
		%><br><br>Your database has not been migrated and is in classic format. No action required!<br>
		<%
	}
dbCon.close();
%>
		<a href="/DesInventar/inv/sendaitab.jsp?usrtkn=<%=countrybean.userHash%>">Click here to continue using your classic DesInventar database</a>
</td></tr>
</table>
<br><br>
</body>
</html>
