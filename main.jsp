<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page info="DesConsultar On-Line main page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.map.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%@ page contentType="text/html; charset=UTF-8" %><%@ page import="org.lared.desinventar.system.*" %><%
request.setCharacterEncoding("UTF-8"); 
// if this runs in an IFRAME under IE, this will allow cookies to stay...just magic!
((HttpServletResponse)response).addHeader("P3P", "CP=\"CAO PSA OUR\"");
((HttpServletResponse)response).addHeader("X-Frame-Options", "SAMEORIGIN");
%>
<%@ include file="/util/opendatabase.jspf" %>
<%@ include file="/paramprocessor.jspf" %>
<html>
<head>
<title><%=countrybean.getTranslation("DesConsultar - Charts / Query Module")%></title>
</head>
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/header",countrybean.getLanguage(),out);%>
<%@ taglib uri="inventag.tld" prefix="inv" %>
<% 
// these should be done at region opening only
if (request.getParameter("countrycode")!=null) 
	{
	// transfer of the MAP DATABASE regiones table!!!	
	ServletContext sc = getServletConfig().getServletContext();
	// Verify and update the data model
    dbutils.updateDataModelRevision(dbCon, dbType, sc.getRealPath("scripts"));
	con=dbCon.dbGetConnection();
	// and now can work on other mapping things...
	MapUtil map = new MapUtil();
	map.checkRegions(con, sc.getRealPath("/"), countrybean.country);
	countrybean.level_map=map.calculateBestLevel(con, countrybean);
	BufferedImageFactory.getFactoryInstance().initiate();
	}

int nTabActive=1; // query
String[] sTabNames={countrybean.getTranslation("Profile"),countrybean.getTranslation("Query"),countrybean.getTranslation("ViewData"),countrybean.getTranslation("ViewMap"),
           countrybean.getTranslation("Charts"),countrybean.getTranslation("Statistics"),countrybean.getTranslation("Reports"),
		   countrybean.getTranslation("Thematic"), countrybean.getTranslation("Crosstab")};
String[] sTabIcons={"check.gif","icon_query.gif","icon_viewdata.gif","icon_viewmap.gif","icon_charts.gif","icon_statistics.gif",
                    "icon_reports.gif","icon_thematic.gif","xtab.gif"};
String[] sTabLinks={"javascript:routeTo('profiletab.jsp')","javascript:routeTo('main.jsp')","javascript:routeTo('results.jsp')","javascript:routeTo('maps.jsp')",
				"javascript:routeTo('graphics.jsp')","javascript:routeTo('definestats.jsp')","javascript:routeTo('generator.jsp')",
				"javascript:routeTo('thematic_def.jsp')","javascript:routeTo('definextab.jsp')"};
%> 
<%@ include file="/util/tabs.jspf" %>
<%@ include file="/queryPage.jspf" %> 
<%@ include file="/html/footer.html" %>
<%@ include file="/util/showDialog.jspf" %> 
</body>
</html>

