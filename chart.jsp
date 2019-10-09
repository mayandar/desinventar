<%@ page info="DesConsultar simple results page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.fichas" %>
<%@ page import="org.lared.desinventar.system.Sys" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%@ include file="/util/opendatabase.jspf" %>
<%@ include file="/paramprocessor.jspf" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>DesConsultar on-line Charts</title>
</head>
 <%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/header",countrybean.getLanguage(),out);%>

<% 
int nTabActive=4; // charts
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
<table width="100%" border="1" class="pageBackground" rules="none"> 
<tr><td align="center">
<font color="Blue"><%=countrybean.getTranslation("Region")%> </font><a href="javascript:routeTo('main.jsp')"><font class='regionlink'>
<b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font></a>
 - [<jsp:getProperty name ="countrybean" property="countrycode"/>]
</td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<font  class='subTitle'><%=countrybean.getTranslation("GeneratedChart")%>:</font></td>
<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:routeTo('graphics.jsp')"><%=countrybean.getTranslation("Backtochartdefinition")%></a>
</td></tr>
<tr><td colspan="3">

<%
String imgparams="?rnd="+Math.round(Math.random()*9999);
%>

<img src='/DesInventar/GraphServer<%=imgparams %>' border=0><br>
<form name="desinventar" method=post action="chart.jsp" style="margin-top:1px">
<input type='hidden' name='nStart' value=''>
<INPUT type='hidden'  name="actiontab" id="actiontab">
<INPUT type='hidden'  name="frompage" value="<%=request.getServletPath()%>">
</td></tr>
<tr><td colspan="3">
<%=countrybean.sSubTitle.length()==0?"":"<span class='subtitle'>"+countrybean.sSubTitle+"</span><br>"%>
<%
String sVar = "";
if (countrybean.asVariables.length>0)
		sVar=countrybean.getVartitle(countrybean.asVariables[0]);
for (int k = 1; k < countrybean.asVariables.length; k++)
 sVar += " + " + countrybean.getVartitle(countrybean.asVariables[k]);
%><%=countrybean.getTranslation("Variable")%>:&nbsp;&nbsp;&nbsp;<%=sVar%>
</td></tr>
</table>
<script language="JavaScript">
<!--
function submitForm(istart)
{
document.desinventar.nStart.value=istart;
document.desinventar.submit();
}
// -->
</script>
</form>
<%
 dbCon.close();
 %>

<%@ include file="/html/footer.html" %>
</body>
</html>
