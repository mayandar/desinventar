<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<%@ page info="DesInventar On-Line main page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="woFicha" class="org.lared.desinventar.webobject.fichas" scope="session" />
<jsp:useBean id="woExtension" class="org.lared.desinventar.webobject.extension" scope="session" />
<jsp:useBean id="User" class="org.lared.desinventar.webobject.users" scope="session" />
<title>DesInventar on-line : <%=countrybean.countryname%> Home </title>
</head>
<%@ include file="checkUserIsLoggedIn.jsp" %>
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/iheader",countrybean.getLanguage(),out);%>
<%@ taglib uri="/inventag.tld" prefix="inv" %>

<script language="javascript">
<!-- 

var countrycode="<%=countrybean.countrycode%>";
function goto(tabpage)
{
// checks there's a selection
if (countrycode.length>0)
	{
	window.location=tabpage;
	}
else
	window.location="/DesInventar/inv/index.jsp"	
}
// -->
</script>

<%
int nTabActive=10;
String[] sTabNames={countrybean.getTranslation("Region"),countrybean.getTranslation("Geography"),countrybean.getTranslation("Events"),
           countrybean.getTranslation("Causes"),countrybean.getTranslation("Extension"),countrybean.getTranslation("Query"),
           countrybean.getTranslation("EditData"),countrybean.getTranslation("DataEntry"),countrybean.getTranslation("Admin"),
		   countrybean.getTranslation("Sendai"),countrybean.getTranslation("Security")};
String[] sTabIcons={"","","","","","","","","","",""};
String[] sTabLinks={"index.jsp","geographytab.jsp","eventab.jsp",
				"causetab.jsp","extendedtab.jsp","querytab.jsp",
				"resultstab.jsp","datacardtab.jsp","admintab.jsp",
				"sendaitab.jsp","securitytab.jsp"};
%>
<%@ include file="/util/tabs.jspf" %>
<FORM NAME="desinventar" method="post">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
</FORM>
<table width="1000" border="1" class="pageBackground" rules="none" height="500"><tr><td align="center" valign="top">
<font color="#000000">
<!-- Content goes after this comment -->
<% if (user.iusertype>=40) 
{%>
<iframe width="1000" height="500" id="contentFrame" src="userManager.jsp?usrtkn=<%=countrybean.userHash%>"></iframe>
<%}
else
{
	User.suserid=user.suserid;
%>
<iframe width="1000" height="500" id="contentFrame" src="UsersUpdate.jsp?usrtkn=<%=countrybean.userHash%>"></iframe>
<%}%>
<!-- Content goes before this comment -->
</td></tr></table>
<script src="/DesInventar/inv/resize.js"></script>
</body>
</html>
