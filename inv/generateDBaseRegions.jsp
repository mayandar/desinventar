<html>
<%@ page info="DesConsultar Connection Diagnostics page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.map.MapUtil" %>
<%@ page import="org.lared.desinventar.system.Sys" %>
<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<% // opens the database %>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%@ include file="/util/opendatabase.jspf" %>

<%

	// transfer of the MAP DATABASE regiones table!!!	
	ServletContext sc = getServletConfig().getServletContext();
	MapUtil map = new MapUtil();
	map.generateDBaseRegions(con, countrybean, sc.getRealPath("/"));

    dbCon.close();
	// now, back to the Map manager
	%>
<jsp:forward page='/inv/levelMapManager.jsp'/>
</body>
</html>
