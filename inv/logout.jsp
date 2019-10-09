<%@ page info="Logout" session="true" %> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<%@ page contentType="text/html; charset=UTF-8" %><%@ page import="org.lared.desinventar.system.*" %><%
request.setCharacterEncoding("UTF-8"); 
// if this runs in an IFRAME under IE, this will allow cookies to stay...just magic!
((HttpServletResponse)response).addHeader("P3P", "CP=\"CAO PSA OUR\"");
((HttpServletResponse)response).addHeader("X-Frame-Options", "SAMEORIGIN");
%>
<%
user.init();
user.iusertype=0;
countrybean.countrycode="";
countrybean.countryname="";
countrybean.init();
request.getSession(false).invalidate();
response.setHeader("Pragma", "no-cache");
response.setHeader("Cache-Control", "no-cache, private, max-age=0, no-store, must-revalidate, pre-check=0, post-check=0");
response.setDateHeader("Expires", 0);
request.setCharacterEncoding("UTF-8");%>
<head>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="cache-control" CONTENT="no-cache, private, max-age=0, no-store, must-revalidate, pre-check=0, post-check=0">
<META HTTP-EQUIV="Expires" CONTENT="01-01-1999">
</head>
<script language="JavaScript">
if (parent.bNotInFrame)
	parent.window.location="/DesInventar/inv/index.jsp";
else
	window.location="/DesInventar/inv/index.jsp";
</script>
