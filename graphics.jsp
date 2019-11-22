<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<%@ page info="DesConsultar charts def page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" /><head>
<title><%=countrybean.getTranslation("ChartTitle")%></title>
</head>
<%@ include file="/util/opendatabase.jspf" %>
<%@ include file="/paramprocessor.jspf" %>
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/header",countrybean.getLanguage(),out);%>
<%@ include file="/util/showDialog.jspf" %>
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

<script src="/DesInventar/xmlHttp.js"></script>
<script language="JavaScript">
<!--
var defer=false;
var fromSeasonal=false;
function callback(request)
{
//alert ("callback got response");
// refresh image source
var newSrc="/DesInventar/GraphServer?ver="+Math.random();
document.getElementById("DI_chart").src=newSrc;
// and refreshes the getBookmark function main chunk of paraneters
sCurrentParameters=request.responseText;
}

function getRadioOption(rObject)
{
var ret="0";
for (ijk=0; ijk<rObject.length; ijk++)
  if (rObject[ijk].checked)
   ret=rObject[ijk].value;

return ret;
}

function regenerate()
{
if (!defer)
	{
	with (document.desinventar)
	  {
		  GraphServerUrl="/DesInventar/ajax_paramprocessor.jsp?frompage=/graphics.jsp&chartType="+getRadioOption(chartType);
	      GraphServerUrl+="&chartMode="+getRadioOption(chartMode);
	      GraphServerUrl+="&periodType="+getRadioOption(periodType);
	      GraphServerUrl+="&seasonType="+getRadioOption(seasonType);
	      GraphServerUrl+="&chartSubMode="+getRadioOption(chartSubMode);
	      GraphServerUrl+="&chart3D="+getRadioOption(chart3D);
	      GraphServerUrl+="&chartColor="+getRadioOption(chartColor);
	      GraphServerUrl+="&chartX="+chartX.value;
	  	  GraphServerUrl+="&chartY="+chartY.value;
	  	  // disabled GraphServerUrl+="&chartMaxX"=chartMaxX.value;
	      GraphServerUrl+="&chartMaxY="+chartMaxY.value;
	      if (logarithmicX.checked)
		     GraphServerUrl+="&logarithmicX=Y";
	      if (logarithmicY.checked)
		     GraphServerUrl+="&logarithmicY=Y";
	      if (bRegression.checked)
	      	GraphServerUrl+="&bRegression=Y";
		  for (ijk=0; ijk<variables.length; ijk++)
			if (variables.options[ijk].selected)
				GraphServerUrl+="&variables="+variables.options[ijk].value;

		  for (ijk=0; ijk<8; ijk++)
				GraphServerUrl+="&color_"+ijk+"="+escape(document.getElementById("color_"+ijk).value);

	  	  ///GraphServerUrl+="&sExpertVariable="+sExpertVariable; 
	      GraphServerUrl+="&chartTitle="+escape(chartTitle.value);
	  	  GraphServerUrl+="&chartSubTitle="+escape(chartSubTitle.value);
		  
		  //alert ("AJAX sending url:"+GraphServerUrl);

		  sendHttpRequest("GET", GraphServerUrl, callback)   
	  }

	}
}

function full_regenerate()
{
defer=false;
regenerate();
}

// defaults for histograms
function  setTimeDefaults(newSeason)
{
defer=true;
if (document.desinventar.chartMode[2].checked) // if pie, turn into series
	document.desinventar.chartMode[0].checked=true; // bar chart
if (fromSeasonal)
	document.desinventar.periodType[0].checked=true; // anual
fromSeasonal=false;
if(document.desinventar.logarithmicX.checked){
	document.desinventar.logarithmicX.checked=false; // not log x 
	document.desinventar.logarithmicY.checked=false; // not log y 
	}
full_regenerate();	
}
 
 
function  setPeriodDefaults(newSeason)
{
regenerate();
}
 
function  setSeasonal(newSeason)
{
defer=true;
fromSeasonal=true;
document.desinventar.chartMode[0].checked=true; // bar chart
document.desinventar.periodType[1].checked=true; // month
document.desinventar.seasonType[3].checked=true; // year season
document.desinventar.logarithmicX.checked=false; // not log x 
full_regenerate();
}

function  setExceedance(newSeason)
{
defer=true;
document.desinventar.chartMode[1].checked=true; // bar chart
document.desinventar.periodType[0].checked=true; // anual
document.desinventar.logarithmicX.checked=true; // log x 
document.desinventar.logarithmicY.checked=true; // log y 
if (document.desinventar.variables.selectedIndex<=1)
	document.desinventar.variables.selectedIndex=1;
full_regenerate();
}


function  setSeasonDefaults(newSeason)
{
defer=true;
switch (newSeason)
 {
 case 1: // century
    document.desinventar.periodType[0].checked=true;
 	break;
 case 2: // decade
    if (!document.desinventar.periodType[1].checked)  // only yr & mnth
	 document.desinventar.periodType[0].checked=true;
 	break;
 case 3: // 5yrs
    if (!document.desinventar.periodType[1].checked)  // only yr & mnth
	 document.desinventar.periodType[0].checked=true;
 	break;
 case 4:   //year
     if (document.desinventar.periodType[0].checked)  // season year, at least period=month
	 document.desinventar.periodType[1].checked=true;
 	break;
 case 5: // month
     // if (document.desinventar.periodType.selectedIndex<=1)  // month season, at least period=week
	 // document.desinventar.periodType.selectedIndex=2;
 	break;
 }
full_regenerate();
}

function  setPieChart()
{
defer=true;
// chartMode = piechart
document.desinventar.chartMode[2].checked=true;
full_regenerate();
}

// color defaults for 
function cellColor(j,colvalue)
{
htmlContent='<table  bgcolor="'+colvalue+'" cellpadding="1" cellspacing="0"  class="IE_Table" border="1"><tr><td width=80 bgcolor="'+colvalue+'" style="cursor:pointer">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></tr></table>';  //'+colvalue+'
document.getElementById("cell_"+j).innerHTML=htmlContent;
}

var currentCell=0;

function colorDone(dReturn)
{
if (dReturn)
	{
	document.getElementById(sname).value=dReturn;
	cellColor(currentCell,dReturn);
	full_regenerate();
	}
}


function setColor(j)
{
currentCell=j;
sname="color_"+j;
scolor=document.getElementById(sname).value.substring(1,7);
var sPickerUrl = 'colorpick.jsp?color='+scolor+'&title=<%=countrybean.getTranslation("Select+color+for+range")%>';
dReturn = showDialogSz(sPickerUrl, 'colorDone', '', 500, 500, "no");
}

function Hex2(col)
{
hexcol=col.toString(16);
if (hexcol.length<2)
   hexcol='0'+hexcol;
return hexcol;
}

function RGB(red,green,blue)
{
red=Math.min(255,Math.round(red));
green=Math.min(255,Math.round(green));
blue=Math.min(255,Math.round(blue));
return '#'+Hex2(red)+Hex2(green)+Hex2(blue);
}

function expertDone(oReturn)
{
if (oReturn){
  if (oReturn==' ') 
  		oReturn='';
  document.desinventar.sExpertVariable.value=oReturn;
  document.desinventar.sDisabledExpertWhere.value=oReturn;
  full_regenerate();
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

// -->
</script>
<form name="desinventar" method=post action="graphics.jsp" style="margin-top:1px">
  <table width="100%" border="0"  class="pageBackground bs" rules="none">
    <tr>
      <td align="left"><font color="Blue"><%=countrybean.getTranslation("Region")%> </font><a href="javascript:routeTo('main.jsp')"><font class='regionlink'> <b><i>
        <jsp:getProperty name ="countrybean" property="countryname"/>
        </i></b></font></a> - [
        <jsp:getProperty name ="countrybean" property="countrycode"/>
        ] </td>
      <td nowrap  align="left" colspan=3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span class="subTitle"><%=countrybean.getTranslation("ChartGenerator")%></span><br>
      </td>
    </tr>
    <tr>
      <td valign="top" width="250" align="left"><table border=1 cellpadding="2" cellspacing="0" width="100%" class='IE_Table'>
          <tr>
            <td class="DI_TableHeader bs" align="center" nowrap><font color="White"><%=countrybean.getTranslation("TypeofChart")%></font></td>
          </tr>
          <tr>
            <td class="bs"><strong><%=countrybean.getTranslation("Composition of Disasters")%></strong><br>
              <input type="Radio" name="chartType" value="5" <%=countrybean.strChecked(countrybean.nChartType,5)%> onClick="setPieChart()">
              &nbsp;<%=countrybean.getTranslation("ComparativebyEvents")%><br>
              <input type="Radio" name="chartType" value="6" <%=countrybean.strChecked(countrybean.nChartType,6)%> onClick="setPieChart()">
              &nbsp;<%=countrybean.getTranslation("ComparativebyGeography")%><br>
              <input type="Radio" name="chartType" value="7" <%=countrybean.strChecked(countrybean.nChartType,7)%> onClick="setPieChart()">
              &nbsp;<%=countrybean.getTranslation("ComparativebyCause")%><br>
              <br>
              <strong><%=countrybean.getTranslation("Temporal Behaviour")%></strong><br>
              <input type="Radio" name="chartType" value="1" <%=countrybean.strChecked(countrybean.nChartType,1)%> onClick="setTimeDefaults(1)">
              &nbsp;<%=countrybean.getTranslation("TemporalHistogram")%><br>
              <input type="Radio" name="chartType" value="2" <%=countrybean.strChecked(countrybean.nChartType,2)%> onClick="setTimeDefaults(2)">
              &nbsp;<%=countrybean.getTranslation("EventTemporalHistogram")%><br>
              <input type="Radio" name="chartType" value="3" <%=countrybean.strChecked(countrybean.nChartType,3)%> onClick="setTimeDefaults(3)">
              &nbsp;<%=countrybean.getTranslation("GeographicTemporalHistogram")%><br>
              <input type="Radio" name="chartType" value="8" <%=countrybean.strChecked(countrybean.nChartType,8)%> onClick="setTimeDefaults(7)">
              &nbsp;<%=countrybean.getTranslation("CauseTemporalHistogram")%><br>
              <input type="Radio" name="chartType" value="9" <%=countrybean.strChecked(countrybean.nChartType,9)%> onClick="setTimeDefaults(9)">
              &nbsp;<%=countrybean.getTranslation("Variable_Histogram")%><br>
              <input type="Radio" name="chartType" value="10" <%=countrybean.strChecked(countrybean.nChartType,10)%> onClick="setTimeDefaults(9)">
              &nbsp;<%=countrybean.getTranslation("DistributionHistogram")%><br>
              <input type="Radio" name="chartType" value="4" <%=countrybean.strChecked(countrybean.nChartType,4)%> onClick="setSeasonal()">
              &nbsp;<%=countrybean.getTranslation("SeasonalHistogram")%><br>
              <br>
              <strong><%=countrybean.getTranslation("Retrospective risk assessment")%></strong><br>
              <input type="Radio" name="chartType" value="11" <%=countrybean.strChecked(countrybean.nChartType,11)%> onClick="setExceedance(11)">
              &nbsp;<%=countrybean.getTranslation("Loss Exceedance Curve")%><br>
            </td>
          </tr>
        </table>
        <br/>
        <table border=1 cellpadding="2" cellspacing="0" class='IE_Table'>
          <tr>
            <td class="DI_TableHeader bs" align="center"><font color="White"><%=countrybean.getTranslation("Variabletobeplotted")%>:</font></td>
          </tr>
          <tr>
            <td>
			<% // loads variables from private area
			countrybean.loadVariables(countrybean.asChartMapVariables);
			// check the variables vector
			if (countrybean.asVariables==null)
				{
				countrybean.asVariables=new String[1];
				countrybean.asVariables[0] = "";
				}
			if (countrybean.asVariables[0].length() == 0)
				countrybean.asVariables[0] = "1 as \""+countrybean.getTranslation("DataCards")+"\"";
		     %>
			 <select name="variables" size=15 style="WIDTH: 250px;" multiple onChange="full_regenerate()">
						<%@ include file="/util/numericVariables.jspf" %>
						<%@ include file="/util/extendedVariables.jspf" %>
              </select>
            </td>
          </tr>
        </table></td>
      <td colspan="3">
<%
String imgparams="?rnd="+Math.round(Math.random()*9999);
%>
        <div id="DI_chartdiv"><img name="DI_chart" id="DI_chart" src='/DesInventar/GraphServer<%=imgparams %>' border=0></div>
        <br/> 
        <input type=button value="<%=countrybean.getTranslation("GenerateChart")%>" name="continue" onClick="routeTo('graphics.jsp')">
        </td>
    </tr>
    <!-- First row -->
    <tr>
      <td  valign="top"><table border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td valign="top"><table border=1 cellpadding="2" cellspacing="0" width=120 class='IE_Table'>
                <tr>
                  <td class="DI_TableHeader bs"
 align="center"><font color="White"><%=countrybean.getTranslation("Period")%></font></td>
                </tr>
                <tr>
                  <td  class=bs><input type="Radio" name="periodType" value="1" <%=countrybean.strChecked(countrybean.nPeriodType,1)%> onClick="setPeriodDefaults(1)">
                    &nbsp;<%=countrybean.getTranslation("Anual")%><br>
                    <input type="Radio" name="periodType" value="2" <%=countrybean.strChecked(countrybean.nPeriodType,2)%> onClick="setPeriodDefaults(2)">
                    &nbsp;<%=countrybean.getTranslation("Month")%><br>
                    <input type="Radio" name="periodType" value="3" <%=countrybean.strChecked(countrybean.nPeriodType,3)%> onClick="setPeriodDefaults(3)">
                    &nbsp;<%=countrybean.getTranslation("Week")%><br>
                    <input type="Radio" name="periodType" value="4" <%=countrybean.strChecked(countrybean.nPeriodType,4)%> onClick="setPeriodDefaults(4)">
                    &nbsp;<%=countrybean.getTranslation("Day")%><br>
                  </td>
                </tr>
              </table></td>
            <td valign="top"  width="25%" align="left"><table border=1 cellpadding="2" cellspacing="0" width=150 class='IE_Table'>
                <tr>
                  <td class="DI_TableHeader bs"
 align="center"><font color="White"><%=countrybean.getTranslation("Season")%></font></td>
                </tr>
                <td nowrap class=bs><input type="Radio" name="seasonType" value="1" <%=countrybean.strChecked(countrybean.nSeasonType,1)%> onClick="setSeasonDefaults(1)">
                    &nbsp;<%=countrybean.getTranslation("Century")%><br>
                    <input type="Radio" name="seasonType" value="2" <%=countrybean.strChecked(countrybean.nSeasonType,2)%> onClick="setSeasonDefaults(2)">
                    &nbsp;<%=countrybean.getTranslation("Decade")%><br>
                    <input type="Radio" name="seasonType" value="3" <%=countrybean.strChecked(countrybean.nSeasonType,3)%> onClick="setSeasonDefaults(3)">
                    &nbsp;<%=countrybean.getTranslation("Quinquennium")%><br>
                    <input type="Radio" name="seasonType" value="4" <%=countrybean.strChecked(countrybean.nSeasonType,4)%> onClick="setSeasonDefaults(4)">
                    &nbsp;<%=countrybean.getTranslation("Year")%><br>
                    <input type="Radio" name="seasonType" value="5" <%=countrybean.strChecked(countrybean.nSeasonType,5)%> onClick="setSeasonDefaults(5)">
                    &nbsp;<%=countrybean.getTranslation("Month")%><br>
                  </td>
              </table></td>
          </tr>
        </table>
      </td>
      <td valign="top">
       <table style="width:780px" width="780" border=1 cellpadding="2" cellspacing="0" class='IE_Table'>
          <tr>
            <td class="DI_TableHeader bs"
 align="center" colspan=4><font color="White"><%=countrybean.getTranslation("ChartFeatures")%></font></td>
          </tr>
          <tr>
          <td class='bs' rowspan="4" width="20%" align="center">
          <table border="1" cellpadding="2" cellspacing="0" width=80 class='bs IE_Table'>
          <tr>
            <td class="DI_TableHeader bs"><font color="White"><%=countrybean.getTranslation("Serie")%>&nbsp;</font></td>
            <td class="DI_TableHeader"><font color="White"><%=countrybean.getTranslation("Color")%>&nbsp;</font></td>
          </tr>
          <%
        for (int j=0; j<8; j++)
        {%>
          <tr>
            <td  class=bs><%=j+1%></td>
            <td onClick="setColor(<%=j%>)"><div id="cell_<%=j%>"></div>
              <input type=hidden name="color_<%=j%>" id="color_<%=j%>" value="<%=countrybean.asChartColors[j]%>">
          </tr>
          <%}%>
          <tr>
            <td class="DI_TableHeader bs" colspan="2"><font color="White" size="-2"><%=countrybean.getTranslation("Applies only to bar / line charts")%>&nbsp;</font></td>
          </tr>

        </table></td>

            <td rowspan=2  width="20%"  class=bs><input type="Radio" name="chartMode" value="1"<%=countrybean.strChecked(countrybean.nChartMode,1)%> onClick="document.desinventar.bRegression.checked=false; regenerate();">
              &nbsp;<%=countrybean.getTranslation("BarChart")%><br>
              <input type="Radio" name="chartMode" value="2"<%=countrybean.strChecked(countrybean.nChartMode,2)%> onClick="document.desinventar.chartSubMode[0].checked=true; regenerate();">
              &nbsp;<%=countrybean.getTranslation("LineChart")%><br>
              <input type="Radio" name="chartMode" value="3"<%=countrybean.strChecked(countrybean.nChartMode,3)%> onClick="document.desinventar.chartSubMode[0].checked=true;document.desinventar.bRegression.checked=false; regenerate();">
              &nbsp;<%=countrybean.getTranslation("PieChart")%><br>
              <br/>
              <input type="checkbox" name="bRegression" value="Y"<%=countrybean.strChecked(countrybean.bRegression)%> onClick="document.desinventar.chartMode[1].checked=true; regenerate();">
              &nbsp;<%=countrybean.getTranslation("Regression")%><br>
            </td>
            <td class=bs>&nbsp;
              <input type="Radio" name="chart3D" value="1"<%=countrybean.strChecked(countrybean.b3D)%> onClick=" regenerate();">
              &nbsp;<%=countrybean.getTranslation("3D")%><br>
              &nbsp;
              <input type="Radio" name="chart3D" value="2"<%=countrybean.strChecked(!countrybean.b3D)%> onClick=" regenerate();">
              &nbsp;<%=countrybean.getTranslation("2D")%><br>
              <br>
            </td>
            <td class=bs>&nbsp;
              <input type="Radio" name="chartSubMode" value="1"<%=countrybean.strChecked(countrybean.nChartSubmode,1)%> onClick=" regenerate();">
              &nbsp;<%=countrybean.getTranslation("Normal")%><br>
              &nbsp;
              <input type="Radio" name="chartSubMode" value="2"<%=countrybean.strChecked(countrybean.nChartSubmode,2)%>  onclick="if (document.desinventar.chartMode[2].checked=true) document.desinventar.chartMode[0].checked=true;  regenerate();">
              &nbsp;<%=countrybean.getTranslation("Stacked")%><br>
              &nbsp;
              <input type="Radio" name="chartSubMode" value="3"<%=countrybean.strChecked(countrybean.nChartSubmode,3)%> onClick="if (document.desinventar.chartMode[2].checked=true) document.desinventar.chartMode[0].checked=true;  regenerate();">
              &nbsp;<%=countrybean.getTranslation("Cummulative")%><br>
            </td>
          </tr>
          <tr>
            <td class=bs>&nbsp;
              <input type="Radio" name="chartColor" value="1"<%=countrybean.strChecked(countrybean.bColorBW)%> onClick=" regenerate();">
              &nbsp;<%=countrybean.getTranslation("Color")%><br>
              &nbsp;
              <input type="Radio" name="chartColor" value="2"<%=countrybean.strChecked(!countrybean.bColorBW)%> onClick=" regenerate();">
              &nbsp;<%=countrybean.getTranslation("BW")%><br>
              <br>
            </td>
            <td class=bs>&nbsp;
              <input type="checkbox" name="logarithmicY" value="Y"<%=countrybean.strChecked(countrybean.bLogarithmicY)%> onClick=" regenerate();">
              &nbsp;<%=countrybean.getTranslation("LogarithmicScale")%> (Y)<br>
              &nbsp;
              <input type="checkbox" name="logarithmicX" value="Y"<%=countrybean.strChecked(countrybean.bLogarithmicX)%>  onClick=" regenerate();">
              &nbsp;<%=countrybean.getTranslation("LogarithmicScale")%> (X)<br>
              <br>
            </td>
          </tr>
          <tr>
            <td colspan=3 class=bs><%=countrybean.getTranslation("MaximumForChart")%> (Y):
              <input name="chartMaxY" size="10" maxlength="15" value='<%=countrybean.formatDouble(countrybean.dChartMaxY)%>' onChange="regenerate();">
              &nbsp;<%=countrybean.getTranslation("0->auto")%><br>
              <!--           <%=countrybean.getTranslation("MaximumForChart")%> (X):
          <input name="chartMaxX" size="10" maxlength="15" value='<%=countrybean.formatDouble(countrybean.dChartMaxX)%>'>&nbsp;<%=countrybean.getTranslation("0->auto")%> 
 -->
            </td>
          </tr>
          <tr>
            <td colspan=3 class=bs><%=countrybean.getTranslation("Title")%>:<br>
              <input name="chartTitle" size="50" maxlength="80" value='<%=countrybean.sTitle%>' onChange="regenerate();">
              <br>
              <%=countrybean.getTranslation("Subtitle")%>:<br>
              <input name="chartSubTitle" size="50" maxlength="80" value='<%=countrybean.sSubTitle%>' onChange="regenerate();">
              <br>
              <br>
            </td>
          </tr>
          <tr>
            <td class=bs colspan="2" align="right"><span style="float:left"><%=countrybean.getTranslation("SIZE")%></span>&nbsp;&nbsp;&nbsp;<%=countrybean.getTranslation("Width")%>:
              <input name="chartX" value="<%=countrybean.xresolution%>" size="5" maxlength="4" onChange="regenerate();">
              &nbsp;&nbsp;&nbsp;<%=countrybean.getTranslation("Height")%>:
              <input name="chartY" value="<%=countrybean.yresolution%>" size="5" maxlength="4" onChange="regenerate();">
            </td>
<!--
            <td colspan="3" class=bs align="right"><%=countrybean.getTranslation("Formula")%>&nbsp;&nbsp;<input type="text" class="bss" name="sDisabledExpertWhere" size="75" maxlength="255"  disabled onDblClick="openExpert()" value="<%=(Parser.translateExpertExpression(countrybean.sExpertVariable, Parser.hmVarTrans))%>"/>
              &nbsp;&nbsp;<input class="bss" type='button' name='expertbutton' value='<%=countrybean.getTranslation("Expert")%>' onClick="openExpert()"/>
              
              <input type="hidden" name="sExpertVariable" value="<%=(Parser.translateExpertExpression(countrybean.sExpertVariable, Parser.hmVarTrans))%>"/>
-->

           </td>
          </tr>
        </table>
        </td>
        <td width="100%">&nbsp;</td>
    </tr>
  </table>
  <input type='hidden' name='nStart' value=''>
  <INPUT type='hidden'  name="actiontab" id="actiontab">
  <INPUT type='hidden'  name="frompage" value="<%=request.getServletPath()%>">
  <script language="JavaScript">
<!--
function submitForm(istart)
{
document.desinventar.nStart.value=istart;
document.desinventar.submit();
}

<%for (int j=0; j<8; j++){
%>cellColor(<%=j%>,'<%=countrybean.asChartColors[j]%>');
<%}


dbCon.close();

%>

// -->
</script>
</form>
<%@ include file="/html/footer.html" %>
</body></html>
