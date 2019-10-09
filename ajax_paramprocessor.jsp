<%@ page import="org.lared.desinventar.util.*" %><%@ page import="org.lared.desinventar.webobject.*" %><jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" /><%
response.setContentType("text/plain; charset=UTF-8");
request.setCharacterEncoding("UTF-8"); 
parser Parser=new parser();
countrybean.processParams(request, Parser, null);
// This page should never be cached by browsers - always should be re-obtained to force new parameters to be loaded
response.setHeader("Pragma", "no-cache");
response.setHeader("Cache-Control", "no-cache");
response.setDateHeader("Expires", 0);
out.print(countrybean.getBookmark(request));
%>