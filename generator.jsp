<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<%@ page info="DesConsultar simple results page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.*" %>
<head>
<title><%=countrybean.getTranslation("ReportsTitle")%></title>
</head>
<%@ include file="/util/opendatabase.jspf" %>
<%@ include file="/paramprocessor.jspf" %>
<%@ include file="/util/showDialog.jspf" %> 
<script language="JavaScript">
function expertDone(oReturn)
{
if (oReturn){
  if (oReturn==' ') 
  		oReturn='';
  document.desinventar.sExpertVariable.value=oReturn;
  document.desinventar.sDisabledExpertWhere.value=oReturn;
  }
}

function getExpertString()
{
return document.desinventar.sExpertVariable.value;
}

function expertArgs()
{
	this.sExpertVariable = document.desinventar.sExpertVariable.value;
}

function openExpert()
{
var sPickerUrl = '/DesInventar/expert.jsp?sql=y&formula=f';
dReturn = showDialogSz(sPickerUrl, 'expertDone', new expertArgs(), 450, 700, "no");
}
</script>
 <%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/header",countrybean.getLanguage(),out);%>
<%
int nTabActive=6; // reports
String[] sTabNames={countrybean.getTranslation("Profile"),countrybean.getTranslation("Query"),countrybean.getTranslation("ViewData"),countrybean.getTranslation("ViewMap"),
           countrybean.getTranslation("Charts"),countrybean.getTranslation("Statistics"),countrybean.getTranslation("Reports"),
		   countrybean.getTranslation("Thematic"), countrybean.getTranslation("Crosstab")};
String[] sTabIcons={"check.gif","icon_query.gif","icon_viewdata.gif","icon_viewmap.gif","icon_charts.gif","icon_statistics.gif",
                    "icon_reports.gif","icon_thematic.gif","xtab.gif"};
String[] sTabLinks={"javascript:routeTo('profiletab.jsp','allSelected(0)')","javascript:routeTo('main.jsp','allSelected(0)')","javascript:routeTo('results.jsp','allSelected(0)')","javascript:routeTo('maps.jsp','allSelected(0)')",
				"javascript:routeTo('graphics.jsp','allSelected(0)')","javascript:routeTo('definestats.jsp','allSelected(0)')","javascript:routeTo('generator.jsp','allSelected(0)')",
				"javascript:routeTo('thematic_def.jsp','allSelected(0)')", "javascript:routeTo('definextab.jsp','allSelected(0)')"};
countrybean.nAction=countrybean.GENERATOR;
%>
<%@ include file="/util/tabs.jspf" %>
<table width="1000" border="0" class="pageBackground" rules="none" height="500"><tr><td valign="top">
<table width="100%" border="0">
<tr><td align="left">
<font class='ltbluelg'><%=countrybean.getTranslation("Region")%></font><a href="javascript:routeTo('main.jsp','allSelected(0)')"><font class='regionlink'>
<b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font></a>
 - [<jsp:getProperty name ="countrybean" property="countrycode"/>]
</td><td nowrap  align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<span class="subTitle"><%=countrybean.getTranslation("ReportGenerator")%></span><br>
</td>
</tr>
</table>

<form name="desinventar" method=post action="report.jsp" onSubmit="return allSelected(1)">
<% // loads variables from private area
countrybean.loadVariables(countrybean.asReportVariables);
%>
<%@ include file="/util/selectVariables.jspf" %>
<%
   countrybean.vmVmanager.addExtensionVariables(woExtension,countrybean);
%>
<table cellpadding="0" cellspacing="0" border="0" ALIGN="CENTER" width="100%">
<tr><td align="CENTER" colspan=3>
<input type=Submit value="<%=countrybean.getTranslation("Continue")%>" name="continue">
<INPUT type='hidden'  name="actiontab" id="actiontab" value="report.jsp">
<INPUT type='hidden'  name="frompage" value="<%=request.getServletPath()%>">
</td></tr>
</table>
</form>
<script language="JavaScript">
with (document.desinventar)
	{
	if (variables.length==0)
		  {
		  for (j=0; j<31; j++)
		    availableVars.options[j].selected=true;
		  addVar();
		  }
	}
</script>

</td></tr>
</table>
<%@ include file="/html/footer.html" %>
<%
dbCon.close();
%>

</body>
</html>
