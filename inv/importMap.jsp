<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
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
<%if (user.iusertype<20) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}%>
<%@ include file="/util/opendatabase.jspf" %>

<%
	// check for GLIDE field. It's on-line version specific, would fail only on MS Access..
	Glide.checkGlideField(con);

	// transfer of the MAP DATABASE regiones table!!!	
	ServletContext sc = getServletConfig().getServletContext();
	MapUtil map = new MapUtil();
	map.regenerateRegions(con, sc.getRealPath("/"), countrybean);

	// and check the full-text indexes!!!
    indexer Indexer = new indexer();
    Indexer.checkIndexes(con);
    dbCon.close();
	// now, back to the Map manager
	%>
<jsp:forward page='/inv/levelMapManager.jsp'/>
</body>
</html>
