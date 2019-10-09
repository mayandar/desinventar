<html>
<%@ page info="DesConsultar Connection Diagnostics page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.map.MapUtil" %>
<%@ page import="org.lared.desinventar.system.Sys" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>">  
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/header",countrybean.getLanguage(),out);%>
<table width="680" border="0">
<tr><td align="center">
<span class=subTitle>DesInventar Server has detected your JDBC Database, but it contains NO DesInventar tables.<br>
</span><span class=warning>DesInventar or Your Database administrator must run the initialization SQL script<br>
</span><br>
<br>
</td></tr>
<tr><td align="left">
<strong>You have the Following options:</strong><br>
<br>
<br><br>a) You want DesInventar to create your database tables: <a href="/DesInventar/util/jdbcMainCreationWizard.jsp?usrtkn=<%=countrybean.userHash%>">click here to run the initialization script</a>.
<br><br>b) You or your database administrator have fixed the problem (created and initialized) the Main <strong>DesInventar</strong> database and just want to <a href="/DesInventar/index.jsp">retry the Connection</a>
<br><br>c) If you typed a wrong parameter just click on 'Back' in your browser and re-enter or fix your Database connection</a>
<br><br><br><br><br></td></tr>
</table>

<br>

</body>
</html>
