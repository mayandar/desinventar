<html>
<%@ page info="DesConsultar Connection Diagnostics page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.util.htmlServer" %>
<%@ page import="org.lared.desinventar.util.DICountry" %>
<%@ page import="org.lared.desinventar.system.Sys" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />

 <%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/header",countrybean.getLanguage(),out);%>
<table width="580" border="0">
<tr><td align="center">
<% 
dbConnection dbCon=null; 
dbCon.resetPool();
%>
</td></tr>
</table>
DATABASE CONNECTION POOL WAS RESET at <%=java.util.Calendar.getInstance().getTime().toGMTString()%>:<br>
<%=dbConnection.dumpStatus()%>
<br>
<br>
<br>Total Memory=<%=Runtime.getRuntime().totalMemory()%>
<br>Free Memory=<%=Runtime.getRuntime().freeMemory() %><br><br>
<br>Servlet Path=<%=request.getServletPath()%><br>
<br>Path info=<%=request.getPathInfo()%><br>
<br>


<%@ include file="/html/footer.html" %>
</body>
</html>
