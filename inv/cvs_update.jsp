<html>
<title>
DesInventar development infrastructure - CVS update
</title>
<%@ page import="java.io.*"%>
<body>
 
<table width="100%" border="0">
<tr><td align="left">
<span class=subTitle>NOW  Executing CVS update:</span><br>
<br>
</td></tr>
<tr><td align="left">
<%
ServletContext sc = getServletConfig().getServletContext();
Runtime rt=Runtime.getRuntime();
String sExecutablePath= "/cvsupdate.bat";
out.println("EXECUTING:"+sExecutablePath+"<br>");
rt.exec(sExecutablePath);
%>
<br><br>Executed command: <%=sExecutablePath%>
</td></tr>
</table>

<br>
</body>
</html>
