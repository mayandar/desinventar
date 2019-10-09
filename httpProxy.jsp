<%@ page contentType="text/html; charset=UTF-8" %><%@ page import="org.lared.desinventar.util.*"%><%
// get the page from the other server...	
SimpleXmlHttpRequestProxy proxy=new SimpleXmlHttpRequestProxy();
out.println(proxy.getUrl(request));
%>