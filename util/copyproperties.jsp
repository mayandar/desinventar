<html>
<%@ page info="DesInventar properties restore from backup" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.system.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />

<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/header",countrybean.getLanguage(),out);%>
<table width="580" border="0">
<tr><td align="center">
<IMG height=6 src="/DesInventar/images/r.jpg" width=580><br>
</td></tr>
</table>
<%
String sSourcePath="/etc/desinventar/desinventar.properties.bak";
String sDestPath="/etc/desinventar/desinventar.properties";
try
	{
	FileCopy.copy(sSourcePath,sDestPath);
	%>
    <br><br>Using internal command: FileCopy.copy(<%=sSourcePath%>,<%=sDestPath%>);
    <% 
	}
catch (Exception excreate)
	{
	%>
	<br><br>Error while attempting to create properties: <%=sDestPath%><br>
	Error: <%=excreate.toString()%>
	<br><br>
	<%	}

%>
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
