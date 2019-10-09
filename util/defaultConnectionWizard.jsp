<html>
<%@ page info="DesConsultar Connection Diagnostics page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.system.Sys" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/header",countrybean.getLanguage(),out);%>
<form name="desinventar" action="parameterManager.jsp" method="post">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
</form>
<table width="680" border="0">
<tr><td align="center">
<span class=subTitle>DesInventar Server has detected NO Main Database.</span><br>
<br>
<% /* create main connection:*/ 
dbConnection dbCon=null; 
// opens the database 
dbCon=new dbConnection();
out.println("<br>Message when opening default database: " +dbCon.dbGetConnectionError());
dbCon.close();
dbConnection.resetPool();
%>
</td></tr>
<tr><td align="left">
<strong>You have the Following options:</strong><br>
<br>
<br>a) This may be the first time you are using the system so you want <strong>DesInventar</strong> to 
<a href="javascript:postTo('/DesInventar/util/defaultConnectionWizard1.jsp')">create the Main Database with MS Access</a> 
<br><br>b) You want to <a href="javascript:postTo('/DesInventar/inv/admintab.jsp?sub=parameterManager.jsp')">provide required parameters. You must later retry the Connection</a>(required in LINUX/UNIX like systems)
<br><br>c) You have created an  DesInventar MAIN datasource and just want to <a href="/DesInventar/index.jsp">retry the Connection</a>
<br><br><br><br><br>
</td></tr>
</table>
<br>
<%@ include file="/html/footer.html" %>
</body>
</html>
