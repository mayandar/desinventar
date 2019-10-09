<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<%@ page info="Reindex page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>

<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />

<html>
<head>
	<title>Hidden Reindexer</title>
</head>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body>
<script language="JavaScript">
document.body.scroll='no';
</script>
<% // Java declarations  
int nClave;
int j=0; %>
<% // opens the database %>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%@ include file="/util/opendatabase.jspf" %>
<%
// and check the full-text indexes!!!
indexer Indexer = new indexer();
Indexer.checkIndexes(con);
Indexer.reIndex(con,dbType,out);
// now, back to the manager
dbCon.close();
%>
<script language="JavaScript">
// parent.document.getElementById("status").innerHTML="STATUS:  FINISHED OK...";
parent.window.location="/DesInventar/inv/adminManager.jsp"
</script>
</body>
</html>
