<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<title>DesInventar on-line - Add DataCard</title>
</head>
<%@ page info="Import from DI-6 page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>

<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
 <link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/> 
<table width="580" border="0">
<tr><td align="center">
<font color="Blue"><%=countrybean.getTranslation("Region")%></font>
<b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font>
 - [<jsp:getProperty name ="countrybean" property="countrycode"/>]
</td></tr>
</table>
<table width="700" border="0">
<tr><td align="center">
<div class="warning"><%=countrybean.getTranslation("ImportNotice1")%><br>
<%=countrybean.getTranslation("ImportNotice2")%>.<br><br>
<%=countrybean.getTranslation("ProcessNotice")%>
</div><br>
<br>
<br>
<div class="title" name="status" id="status"><%=countrybean.getTranslation("STATUS")%>: <%=countrybean.getTranslation("IMPORTING")%></div>
</td></tr>
</table>
<%
String database,events,causes,levels,geography,data,definition,extension,maps,othercountrycode, shiftlevel, newlev0,newlev0_name,newlev0_name_en,cleandatabase;
String metadata;
othercountrycode=countrybean.not_null(request.getParameter("othercountrycode"));
database=countrybean.not_null(request.getParameter("filename"));
events=countrybean.not_null(request.getParameter("events"));
causes=countrybean.not_null(request.getParameter("causes"));
levels=countrybean.not_null(request.getParameter("levels"));
geography=countrybean.not_null(request.getParameter("geography"));
maps=countrybean.not_null(request.getParameter("maps"));
data=countrybean.not_null(request.getParameter("data"));
definition=countrybean.not_null(request.getParameter("definition"));
extension=countrybean.not_null(request.getParameter("extension"));
cleandatabase=countrybean.not_null(request.getParameter("cleandatabase"));
metadata=countrybean.not_null(request.getParameter("metadata"));
%>

<iframe height="300" width="700" name="reindexframe" src="importXMLInFrame.jsp?metadata=<%=metadata%>&events=<%=events%>&causes=<%=causes%>&levels=<%=levels%>&geography=<%=geography%>&maps=<%=maps%>&data=<%=data%>&definition=<%=definition%>&extension=<%=extension%>&othercountrycode=<%=othercountrycode%>&cleandatabase=<%=cleandatabase%>&database=<%=database%>"></iframe>
</body>
</html>

