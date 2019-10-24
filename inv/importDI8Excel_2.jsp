<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<%@ page info="Reindex page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>

<%@ page import="org.apache.poi.hssf.usermodel.HSSFCell" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFRow" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFSheet" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFWorkbook" %>
<%@ page import="org.apache.poi.poifs.filesystem.POIFSFileSystem" %>


<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<head>
<title>DesInventar on-line - <%=countrybean.getTranslation("ImportEXCEL")%> DI-8 PROPRIETARY FORMAT</title>
 </head>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%if (user.iusertype<20) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}%>
<%@ include file="/util/opendatabase.jspf" %>
<%@ taglib uri="inventag.tld" prefix="inv" %>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>">
<table width="580" border="0">
<tr><td align="center">
<font color="Blue"><%=countrybean.getTranslation("Region")%></font>
<b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font>
 - [<jsp:getProperty name ="countrybean" property="countrycode"/>]
</td></tr>
</table>
<table width="100%" border="0">
<tr><td>&nbsp</td></tr>
<tr><td>MESSAGES FROM IMPORT:</td></tr>
<tr><td>&nbsp</td></tr>
<tr><td>
<%
String database=countrybean.not_null(request.getParameter("filename"));

Di8ImportFakeExcel diLoader=new Di8ImportFakeExcel();
diLoader.doImport(database, countrybean);

out.println("IMPORT FINALIZED OK");
%>
</td></tr>
</table>
</body>
</html>

<% dbCon.close(); %>
