<%@ page import="java.sql.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@page import="java.net.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.map.*" %>
<%@ page import="org.lared.desinventar.chart.*" %>
<%@ page import="org.lared.desinventar.system.Sys" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%@ taglib uri="inventag.tld" prefix="inv" %>
<%@ include file="/util/opendatabase.jspf" %>
<%
// these should be done at region opening only
if (request.getParameter("countrycode")!=null) 
	{
	// transfer of the MAP DATABASE regiones table!!!	
	ServletContext sc = getServletConfig().getServletContext();
	con=dbCon.dbGetConnection();
	// and now can work on other mapping things...
	MapUtil map = new MapUtil();
	countrybean.level_map=map.calculateBestLevel(con, countrybean);
	}
%>
<%@ include file="/paramprocessor.jspf" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>DesInventar - <%=countrybean.getTranslation("Profile")%></title>
 </head>
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/header",countrybean.getLanguage(),out);

int nTabActive=0; // profile
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

<form name="desinventar" id="desinventar" method=post action="profiletab.jsp" style="margin-top:1px">
<table width="1000" border="0" class="pageBackground" rules="none">
<tr><td>
	<table width="1000">
	<tr><td>
	<font  class='ltbluelg'>
	<%=countrybean.getTranslation("Region")%>:</font><a href="javascript:routeTo('main.jsp')"><font class='regionlink'>
	<b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font></a>
	 - [<jsp:getProperty name ="countrybean" property="countrycode"/>]
	</td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<font  class='subTitle'><%=countrybean.getTranslation("Profile")%>:</font></td>
	</tr>
	</table>
</td></tr>
<tr><td>
    <table width="1000" border="1" rules="none">
	<tr><td colspan=5 align="center"><P><font class='subtitle'><%=countrybean.getTranslation("Select what profile you want")%>:</FONT></P>
	</td></tr>
	<tr>
	<td>
	
		<table width="50%" border="1" align="center" >
		<tr>
			<td>
				<font class='boxheader'><%=countrybean.getTranslation("Disastertype")%></FONT>
		  		<br><SELECT name="eventos" class=bs onChange="submit();">
				    <option value=""><%=countrybean.getTranslation("Multi-hazard profile")%></option>
	     			<inv:selectEvent connection="<%=con%>" language="<%=countrybean.getDataLanguage()%>" selected="<%=countrybean.asEventos%>"/>
				 </SELECT>    
			</td>
			<td>
				<font class='boxheader'><%=countrybean.asLevels[0] %> <!-- Provincia/Estado/Depto --></FONT>
				 <br>
				 <SELECT name="level0" class="bs" onChange="submit();">
				   <option value=""><%=countrybean.getTranslation("ALL")%></option>
			       <inv:selectLevel0 connection="<%=con%>"  selected="<%=countrybean.asNivel0%>"/>
				 </SELECT><input type="hidden" name="name0" value="">    
			</td>
		</tr>
		</table>		 

	</td>
	</tr>
	<tr>
		<td colspan=3 align="center">
		<% // save current thematic ranges 
			double[] asMapRanges = new double[15];
			String[] asMapColors = new String[15];
			String[] asMapLegends = new String[15];
			for (int j=0; j<10; j++)
			{
			  asMapRanges[j]=countrybean.asMapRanges[j];
			  asMapColors[j]=countrybean.asMapColors[j];
			  asMapLegends[j]=countrybean.asMapLegends[j];
			}
		%>
		<%@ include file="/generate_profile.jspf" %>
		<% // restore current thematic ranges
			for (int j=0; j<10; j++)
			{
			  countrybean.asMapRanges[j]=asMapRanges[j];
			  countrybean.asMapColors[j]=asMapColors[j];
			  countrybean.asMapLegends[j]=asMapLegends[j];
			}		
		%>
		</td>
	</tr>
	<tr>
		<td align="center" colspan=3>
		<INPUT type='hidden'  name="actiontab" id="actiontab" value="profiletab.jsp">
		<INPUT type='hidden'  name="frompage" value="<%=request.getServletPath()%>">
		</td>
	</tr>
	</table>
  </form>
<%@ include file="/html/footer.html" %>
<%
dbCon.close();
%>

</body>
</html>