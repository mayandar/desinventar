<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>

<html>
<head>
<title>DesInventar on-line - Expired/Invalid/No access </title>
</head>
<%@ page info="Add Datacard page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 

<table width="1000" border="0">
<tr id='header'><td>
<%if (request.getParameter("inframe")==null)
	{
	htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/iheader",countrybean.getLanguage(),out);
    }%> 
</td></tr>
<tr><td align="center"><br/><br/><br/>
<h3>SESSION EXPIRED/INVALID/NO ACCESS:<br/>You may not see this page because your session data is invalid or expired, or you don't have enough privileges to access this page.</h3>
</td></tr>
<tr><td align="center"><a href="javascript:someAccess('/DesInventar/main.jsp')">Click here to return to <strong>public</strong> pages</a></td></tr>
<tr><td align="center"><a href="javascript:someAccess('/DesInventar/inv/index.jsp')">Click here to attempt returning to administration module</a></td></tr>
</table>
<script language="JavaScript">
function someAccess(sPage)
{
if (parent.bNotInFrame)
	parent.window.location=sPage;
else
	window.location=sPage;
}

if (parent.bNotInFrame)
{}
else    
document.getElementById("header").style.display='none';

</script>
</body>
</html>
