<%@ page info="DesConsultar simple results page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.system.Sys" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title><%=countrybean.getTranslation("StatsDefTitle")%></title>
 </head>
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/header",countrybean.getLanguage(),out);%>
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

function checkConsistency()
{
if (document.desinventar.stat0.options[document.desinventar.stat0.selectedIndex].value==document.desinventar.stat1.options[document.desinventar.stat1.selectedIndex].value ||
    document.desinventar.stat0.options[document.desinventar.stat0.selectedIndex].value==document.desinventar.stat2.options[document.desinventar.stat2.selectedIndex].value ||
	document.desinventar.stat2.options[document.desinventar.stat_.selectedIndex].value==document.desinventar.stat1.options[document.desinventar.stat1.selectedIndex].value)
  {
  alert ("<%=countrybean.getTranslation("Invalid repeated selection")%>")
  return false;
  }
return true  
}

</script>

<%
int nTabActive=5; // stats
String[] sTabNames={countrybean.getTranslation("Profile"),countrybean.getTranslation("Query"),countrybean.getTranslation("ViewData"),countrybean.getTranslation("ViewMap"),
           countrybean.getTranslation("Charts"),countrybean.getTranslation("Statistics"),countrybean.getTranslation("Reports"),
		   countrybean.getTranslation("Thematic"), countrybean.getTranslation("Crosstab")};
String[] sTabIcons={"check.gif","icon_query.gif","icon_viewdata.gif","icon_viewmap.gif","icon_charts.gif","icon_statistics.gif",
                    "icon_reports.gif","icon_thematic.gif","xtab.gif"};
String[] sTabLinks={"javascript:routeTo('profiletab.jsp','allSelected(0)')","javascript:routeTo('main.jsp','allSelected(0)')","javascript:routeTo('results.jsp','allSelected(0)')","javascript:routeTo('maps.jsp','allSelected(0)')",
				"javascript:routeTo('graphics.jsp','allSelected(0)')","javascript:routeTo('definestats.jsp','allSelected(0)')","javascript:routeTo('generator.jsp','allSelected(0)')",
				"javascript:routeTo('thematic_def.jsp','allSelected(0)')", "javascript:routeTo('definextab.jsp','allSelected(0)')"};
// do not remove or change this: needed in selectVariables.jspf to define the set of variables
countrybean.nAction=countrybean.STATISTICS;
%>
<%@ include file="/util/tabs.jspf" %>
<table width="1000" border="0" class="pageBackground" rules="none"><tr><td>
<table width="100%">
<tr><td>
<font  class='ltbluelg'>
<%=countrybean.getTranslation("Region")%>:</font><a href="javascript:routeTo('main.jsp','allSelected(0)')"><font class='regionlink'>
<b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font></a>
 - [<jsp:getProperty name ="countrybean" property="countrycode"/>]
</td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<font  class='subTitle'><%=countrybean.getTranslation("StatisticsGenerator")%>:</font></td>
</tr>
</table>
<form name="desinventar" method=post action="statistics.jsp"  onSubmit="return allSelected(1)" style="margin-top:1px">
<% // loads variables from private area. If no variables there, tries other section as starting point...
	countrybean.loadVariables(countrybean.asStatisticsVariables);
%>
<%@ include file="/util/selectVariables.jspf" %>
<table width="100%" border="0" rules="none" align="center" class="IE_Table bs">
<tr><td colspan=5 align="center"><P><font class='subtitle'><%=countrybean.getTranslation("DefineAggregationFunctions")%>:</FONT></P>
</td></tr>
<tr>
<td><input type='checkbox' name='bSum' value="Y" <%=countrybean.strChecked(countrybean.bSum)%>>&nbsp;<%=countrybean.getTranslation("Sum")%></td>
<td><input type='checkbox' name='bAvg' value="Y" <%=countrybean.strChecked(countrybean.bAvg)%>>&nbsp;<%=countrybean.getTranslation("Average")%></td>
<td><input type='checkbox' name='bMax' value="Y" <%=countrybean.strChecked(countrybean.bMax)%>>&nbsp;<%=countrybean.getTranslation("Max")%></td>
<td><input type='checkbox' name='bVar' value="Y" <%=countrybean.strChecked(countrybean.bVar)%>>&nbsp;<%=countrybean.getTranslation("Variance")%></td>
<td><input type='checkbox' name='bStd' value="Y" <%=countrybean.strChecked(countrybean.bStd)%>>&nbsp;<%=countrybean.getTranslation("StdDev")%></td>
</tr>
</table>
<table width="1000" border="1" rules="none" class='IE_Table'>
<tr><td colspan=3 align="center"><P><font class='subtitle'><%=countrybean.getTranslation("DefineAggregationLevels")%>:</FONT></P>
</td></tr>
<tr>
<%
String sFechanoFechames="(fechano*100+fechames) as year_month";
String sFecha="(fechano*10000+fechames*100+fechadia) as DateYMD";
int level=0;
String[] sLevelTitles={countrybean.getTranslation("FirstLevel"),countrybean.getTranslation("SecondLevel"),countrybean.getTranslation("ThirdLevel")};
for (level=0; level<3; level++)
{%>

<td align="middle" width="33%">
  <table border=1 cellpadding="0" cellspacing="0" width="100%" class='IE_Table'>
    <tr>
      <td class="DI_TableHeader bs" align="center" colspan=3><font color="White"><%=sLevelTitles[level]%>:</font></td>
    </tr>
	<tr>
		<td>
		<select name="stat<%=level%>" size=5 style="WIDTH: 100%;">
		<option value="eventos.nombre<%=sLangSuffix%>"<%=countrybean.strSelected("eventos.nombre"+sLangSuffix,countrybean.asStatLevels[level])%>><%=countrybean.getTranslation("Event")%></option>
		<option value="lev0_name<%=sLangSuffix%>,level0"<%=countrybean.strSelected("lev0_name"+sLangSuffix+",level0",countrybean.asStatLevels[level])%>><%=htmlServer.htmlEncode(countrybean.asLevels[0])%></option>
		<% if (countrybean.asLevels[1].length()>0){%>
		<option value="lev1_name<%=sLangSuffix%>,level1"<%=countrybean.strSelected("lev1_name"+sLangSuffix+",level1",countrybean.asStatLevels[level])%>><%=htmlServer.htmlEncode(countrybean.asLevels[1])%></option>
		<%} if (countrybean.asLevels[2].length()>0){%>
		<option value="lev2_name<%=sLangSuffix%>,level2"<%=countrybean.strSelected("lev2_name"+sLangSuffix+",level2",countrybean.asStatLevels[level])%>><%=htmlServer.htmlEncode(countrybean.asLevels[2])%></option>
		<%}%>
		<option value="<%=sFecha%>"<%=countrybean.strSelected(sFecha,countrybean.asStatLevels[level])%>><%=countrybean.getTranslation("Date")%></option>
		<option value="fichas.fechano"<%=countrybean.strSelected("fichas.fechano",countrybean.asStatLevels[level])%>><%=countrybean.getTranslation("Year")%></option>
		<option value="<%=sFechanoFechames%>"<%=countrybean.strSelected(sFechanoFechames,countrybean.asStatLevels[level])%>><%=countrybean.getTranslation("Year")%>/<%=countrybean.getTranslation("month")%></option>
		<option value="fichas.fechames"<%=countrybean.strSelected("fichas.fechames",countrybean.asStatLevels[level])%>><%=countrybean.getTranslation("Month")%></option>
		<option value="causas.causa<%=sLangSuffix%>"<%=countrybean.strSelected("causas.causa",countrybean.asStatLevels[level])%>><%=countrybean.getTranslation("Cause")%></option>
		<option value="fichas.descausa"<%=countrybean.strSelected("fichas.descausa",countrybean.asStatLevels[level])%>><%=countrybean.getTranslation("DescriptionCause")%></option>
		<option value="fichas.glide"<%=countrybean.strSelected("fichas.glide",countrybean.asStatLevels[level])%>><%=countrybean.getTranslation("GLIDEnumber")%></option>
		<option value='fichas.fuentes'<%=countrybean.strSelected("fichas.fuentes",countrybean.asStatLevels[level])%>><%=countrybean.getTranslation("Source")%></option>
		<option value='fichas.muertos'<%=countrybean.strSelected(countrybean.asStatLevels[level],"fichas.muertos")%>><%=countrybean.getTranslation("Deaths")%></option>
		<option value='fichas.heridos'<%=countrybean.strSelected(countrybean.asStatLevels[level],"fichas.heridos")%>><%=countrybean.getTranslation("Injured")%></option>
		<option value='fichas.desaparece<%=countrybean.strSelected(countrybean.asStatLevels[level],"fichas.hesaparece")%>><%=countrybean.getTranslation("Missing")%></option>
		<option value='fichas.vivdest'<%=countrybean.strSelected(countrybean.asStatLevels[level],"fichas.vivdest")%>><%=countrybean.getTranslation("DestroyedHouses")%></option>
		<option value='fichas.vivafec'<%=countrybean.strSelected(countrybean.asStatLevels[level],"fichas.vivafec")%>><%=countrybean.getTranslation("AffectedHouses")%></option>
		<option value='fichas.damnificados'<%=countrybean.strSelected(countrybean.asStatLevels[level],"fichas.damnificados")%>><%=countrybean.getTranslation("Victims")%></option>
		<option value='fichas.afectados'<%=countrybean.strSelected(countrybean.asStatLevels[level],"fichas.afectados")%>><%=countrybean.getTranslation("Affected")%></option>
		<option value='fichas.reubicados'<%=countrybean.strSelected(countrybean.asStatLevels[level],"fichas.reubicados")%>><%=countrybean.getTranslation("Relocated")%></option>
		<option value='fichas.evacuados'<%=countrybean.strSelected(countrybean.asStatLevels[level],"fichas.evacuados")%>><%=countrybean.getTranslation("Evacuated")%></option>
		<option value='fichas.valorus'<%=countrybean.strSelected(countrybean.asStatLevels[level],"fichas.valorus")%>><%=countrybean.getTranslation("LossesUSD")%></option>
		<option value='fichas.valorloc'<%=countrybean.strSelected(countrybean.asStatLevels[level],"fichas.valorloc")%>><%=countrybean.getTranslation("LossesLocal")%></option>
		<option value='fichas.nescuelas'<%=countrybean.strSelected(countrybean.asStatLevels[level],"fichas.nescuelas")%>><%=countrybean.getTranslation("Educationcenters")%></option>
		<option value='fichas.nhospitales'<%=countrybean.strSelected(countrybean.asStatLevels[level],"fichas.nhospitales")%>><%=countrybean.getTranslation("Hospitals")%></option>
		<option value='fichas.nhectareas'<%=countrybean.strSelected(countrybean.asStatLevels[level],"fichas.nhectareas")%>><%=countrybean.getTranslation("Damagesincrops")%></option>
		<option value='fichas.cabezas'<%=countrybean.strSelected(countrybean.asStatLevels[level],"fichas.cabezas")%>><%=countrybean.getTranslation("Catle")%></option>
		<option value='fichas.kmvias'<%=countrybean.strSelected(countrybean.asStatLevels[level],"fichas.kmvias")%>><%=countrybean.getTranslation("Damagesinroads")%></option>
		<option value='@formula@'<%=countrybean.strSelected(countrybean.asStatLevels[level],"@formula@")%>><%=countrybean.getTranslation("Formula")%></option>

<% 	for (int k = 0; k < woExtension.vFields.size(); k++)
    {
    dct = (org.lared.desinventar.webobject.Dictionary) woExtension.vFields.get(k);
    String sDescription=countrybean.getLocalOrEnglish(dct.label_campo,dct.label_campo_en).trim();
    String sField=dct.nombre_campo;
 	if (sDescription==null || sDescription.length()==0)
			sDescription=sField;
	   if (sField!=null)
			{  // TODO:  the following should 
		  %><option value='extension.<%=sField.toLowerCase()%>'<%=countrybean.strSelected("extension."+sField.toLowerCase(),countrybean.asStatLevels[level])%>><%=EncodeUtil.htmlEncode(sDescription)%></option>
		  <%}      
	}

    for (int aj=0; aj<3; aj++)
    	if (countrybean.laAttrs[aj]!=null && countrybean.laAttrs[aj].table_level==aj && countrybean.laAttrs[aj].table_name.length()>0 && countrybean.laAttrs[aj].table_code.length()>0)
		{
		attributes aAttribs = new attributes();
		aAttribs.loadAttributes(con,countrybean,aj);
		java.util.ArrayList varFields=aAttribs.vFields;
		// allocates a dictionary object to read each record
		for (int k = 0; k < varFields.size(); k++)
		    {
			String sField=(String) (varFields.get(k));
		  %><option value='DA_<%=aj%>.<%=sField.toLowerCase()%>'<%=countrybean.strSelected(countrybean.asStatLevels[level],"DA_"+aj+"."+sField.toLowerCase())%>><%=sField%></option>
		  <%}	
		}
%>
 		</select>
	</td>
  </tr>
</table>  	
</td>
<%}%>

</tr>
<tr>
<td></td>
<td align="middle"><input type='button' name="no2" value="<%=countrybean.getTranslation("Dontuse")%>" onClick="document.desinventar.stat1.selectedIndex=-1"></td>
<td align="middle"><input type='button' name="no3" value="<%=countrybean.getTranslation("Dontuse")%>" onClick="document.desinventar.stat2.selectedIndex=-1"></td>
</tr>
<tr>
<tr><td align="center" colspan=3 class="bs">
<INPUT type='hidden'  name="actiontab" id="actiontab" value="statistics.jsp">
<input type=Submit value="<%=countrybean.getTranslation("Continue")%>" name="continue" onClick="return checkConsistency()">&nbsp;&nbsp;
<input type=checkbox value="Y" name="reportFormat" checked><%=countrybean.getTranslation("ReportFormat")%>
<INPUT type='hidden'  name="frompage" value="<%=request.getServletPath()%>">
</td></tr>
<td align="center" colspan=3>
<font class='instruction'><%=countrybean.getTranslation("StartisticsInstruction1")%> 
<%=countrybean.not_null(countrybean.asLevels[1])%>&nbsp;<%=countrybean.getTranslation("StartisticsInstruction2")%>  
<%=countrybean.not_null(countrybean.asLevels[0])%>   <%=countrybean.getTranslation("StartisticsInstruction3")%>
</font>
<br></td>
</tr>
</table>
</form>
<script language="JavaScript">
with (document.desinventar)
	{
	if (stat0.selectedIndex<0)
		stat0.selectedIndex=0;
	if (variables.length==0)
		  {
		  for (j=0; j<10; j++)
		    availableVars.options[j].selected=true;
		  addVar();
		  }
	}
</script>
</td></tr></table>
<%@ include file="/html/footer.html" %>
<%
dbCon.close();
%>

</body>
</html>
