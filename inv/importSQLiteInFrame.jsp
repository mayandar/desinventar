<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<%@ page info="Reindex page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Enumeration"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.map.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>

<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />

<html>
<head>
	<title>Tabbed Importer</title>
</head>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body>
<script language="JavaScript">
// http://localhost:8081/DesInventar/inv/importInFrame.jsp?events=Y&causes=Y&levels=Y&geography=Y&data=Y&definition=Y&extension=Y&database=C:/bases_6/Colombia/copmap.mdb
// document.body.scroll='no';
document.body.scroll='auto';
</script>
<% // Java declarations  
int nClave;
int j=0; %>
<% // opens the database %>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%@ include file="/util/opendatabase.jspf" %>
<%
// get all parameters:
String database,events,causes,levels,geography,data,definition,extension,firstrow,startrow,sheetnumber,cleandatabase;

boolean ok=false;


    Enumeration e;
    String sRequestParams ="";
	String sSep="?";
	for (e = request.getParameterNames(); e.hasMoreElements(); )
    {
      String param = (String) e.nextElement();
      sRequestParams+=sSep+param+"="+(request.getParameter(param)==null?"":request.getParameter(param));
	  sSep="&nbsp;|&nbsp;";
    }

database=countrybean.not_null(request.getParameter("database"));
cleandatabase=countrybean.not_null(request.getParameter("cleandatabase"));

%>
Import process from: <%=database %>,<br/> started with parameters: <%=sRequestParams%><br>
<%
	if (cleandatabase.equals("Y"))
	   dbutils.cleanDatabase( con,   countrybean);
			
	Di8Import diLoader=new Di8Import();
	diLoader.doImport(database, countrybean);

// now, back to the manager
dbCon.close();
%>
<script language="JavaScript">
alert("<%=countrybean.getTranslation("ImportFinished")%>");
//parent.window.location="/DesInventar/inv/adminManager.jsp"
</script>
</body>
</html>

