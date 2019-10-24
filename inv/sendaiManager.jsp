<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<title>DesInventar on-line - Sendai Management</title>
</head>
<%@ page import = "org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.login" %>
<%@ page import="org.lared.desinventar.util.htmlServer" %>
<%@ page import="org.lared.desinventar.webobject.diccionario" %>
<%@ page import = "java.io.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.text.*" %>
<%@ page import = "java.util.*" %>
<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%@ taglib uri="inventag.tld" prefix="inv" %>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
if (user.iusertype<20) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}%> 

<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
<script type="text/javascript" src="/DesInventar/html/iheader.js"></script> 
 
<FORM name='desinventar' method="post" action="extendedManager.jsp">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<table cellspacing="0" cellpadding="0" border="0" width="100%">
<tr>
  <td width=50>&nbsp;</td>
  <td>
	<table cellspacing="0" cellpadding="5" border="0" width="100%" rules="none">
	<tr>
	    <td height="25" td colspan="2" class='bgDark' align="center"><span class="title"><%=countrybean.getTranslation("Sendai Framework Manager")%></span></td>
		</td>
	</tr>
	<tr><td colspan="2" height="5"></td></tr>
	<tr><td colspan="2" align="center">
	<br>
	<table border="1" cellpadding="0" cellspacing="0" width=450>
	  <tr><td align="center">
      <br>
		<A class='linkText' href='javascript:postTo("SendaiMigration.jsp")'><%=countrybean.getTranslation("Migrate database to support Sendai Targets and Indicators")%></a><br><br>
		<A class='linkText' href='javascript:postTo("metadataManager.jsp")'><%=countrybean.getTranslation("Select Metadata to disaggregate Targets C and D ")%></a><br><br>
		<A class='linkText' href='javascript:postTo("generateMetadataFields.jsp")'><%=countrybean.getTranslation("Generate Metadata Extension fields")%></a><br><br> 
		<A class='linkText' href='javascript:postTo("sendaiMappingExtension.jsp")'><%=countrybean.getTranslation("Map Extension fields to indicators")%></a><br><br> 
 	  </td></tr>
	</table>
	</td></tr>
	</table>
  </td>
 </tr>
</table>
</form>
</body>
</html>

