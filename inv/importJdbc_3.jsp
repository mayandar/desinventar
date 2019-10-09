<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<%@ page info="Import from DI-6 page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<html>
<head>
<title>DesInventar on-line - <%=countrybean.getTranslation("ImportTABLE")%></title>
</head>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
  
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
<form name='frameform' action="importJdbcInFrame.jsp" target="reindexframe" method='post'>
<%
    Enumeration e;
    String sRequestParams ="";
	String sSep="?";
	for (e = request.getParameterNames(); e.hasMoreElements(); )
    {
      String param = (String) e.nextElement();
	  int nval=countrybean.extendedParseInt(request.getParameter(param));
      if (nval!=300)
	  	sRequestParams+=sSep+param+"="+(request.getParameter(param)==null?"":request.getParameter(param));
	  sSep="&";
    }
	for (e = request.getParameterNames(); e.hasMoreElements(); )
    {
      String param = (String) e.nextElement();
      int nval=countrybean.extendedParseInt(request.getParameter(param));
      if (nval!=300)
	  	out.println("<input type='hidden' name='"+param+"' value='"+(request.getParameter(param)==null?"":request.getParameter(param))+"'>");
	  sSep="&";
    }

%>
</form>  

<!-- <iframe height="300" width="700" name="reindexframe" src="importExcelInFrame.jsp<%=sRequestParams%>"></iframe> -->
<iframe height="300" width="700" name="reindexframe"></iframe>
<script language="JavaScript">
document.frameform.submit();
</script>
</body>
</html>

