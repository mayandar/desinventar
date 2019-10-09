<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.util.htmlServer" %>
<%@ page import="org.lared.desinventar.util.DICountry" %>
<%@ page import="org.lared.desinventar.system.Sys" %>
<body>
 
<table width="100%" border="0">
<tr><td align="left">
<span class=subTitle>NOW  Executing NTRIghts:</span><br>
<br>
</td></tr>
<tr><td align="left">
<%
ServletContext sc = getServletConfig().getServletContext();
Runtime rt=Runtime.getRuntime();
String sExecutablePath= "";  // sc.getRealPath("c:/ntrights.exe -u Administrator +r SeInteractiveLogonRight");
sExecutablePath="c:/ntrights.exe -u Administrator +r SeInteractiveLogonRight";
out.println("EXECUTING:"+sExecutablePath+"<br>");
rt.exec(sExecutablePath);
sExecutablePath= "c:/ntrights.exe -u Administrator -r SeDenyInteractiveLogonRight";
out.println("EXECUTING:"+sExecutablePath+"<br>");
rt.exec(sExecutablePath);
%>
<br><br>Executed command: <%=sExecutablePath%>
</td></tr>
</table>

<br>
</body>
</html>
