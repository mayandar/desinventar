<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>

<head>
    <title>DesInventar on-line - Economic Valuation Utility</title>
</head>

<%@ page import = "org.lared.desinventar.util.dbConnection" %>
<%@ page import = "org.lared.desinventar.webobject.users" %>
<%@ page import = "org.lared.desinventar.util.*" %>
<%@ page import = "org.lared.desinventar.webobject.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.io.*" %>
<%@ page import = "java.net.*" %>

<%@ page import = "org.lared.desinventar.sendai.*" %>

<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id = "countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id = "Dictionary" class="org.lared.desinventar.webobject.diccionario" scope="session" />
<jsp:useBean id = "woFicha" class="org.lared.desinventar.webobject.fichas" scope="session" />
<jsp:useBean id = "woExtension" class="org.lared.desinventar.webobject.extension" scope="session" />

<%@ taglib uri="/inventag.tld" prefix="inv" %>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>

<%if (user.iusertype<20)
{%>
<jsp:forward page="noaccess.jsp"/>
<%}%>
<%@ include file="/util/opendatabase.jspf" %>

<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>">
<%
    out.print(String.format("Local starting time: %tT", Calendar.getInstance()));
    economic_loss el = new economic_loss();
	String sCountryCodes=request.getParameter("country");
    //el.calculate_economic_loss(con);
    el.calculate_temp_economic_loss(con,sCountryCodes);

    out.print("</br> Return to page jsp </br>");
    out.print(String.format("Local End of process time: %tT", Calendar.getInstance()));
%>
</body>
</html>
<% dbCon.close(); %>