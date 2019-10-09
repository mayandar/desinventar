<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<title>DesInventar on-line - Add DataCard</title>
</head>
<%@ page info="Import from DI-6 page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>

<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%if (user.iusertype<20) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}%>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>  
<body marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>">
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
</table>0
<iframe height="500" width="700" name="reindexframe"></iframe>
<form name='frameform' id='frameform' action="importExcelInFrame.jsp" target="reindexframe" method='post'>
<%
    Enumeration e;
	for (e = request.getParameterNames(); e.hasMoreElements(); )
    {
      String param = (String) e.nextElement();
	  if (request.getParameter(param)!=null)
	  	out.println("<input type='hidden' name='"+param+"' value='"+request.getParameter(param)+"'>");
    }
%>
</form>

<script language="JavaScript">
document.frameform.submit();
</script>
</body>
</html>

