<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<%@ page info="DesConsultar charts def page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.map.*" %>
<%@ page import="org.lared.desinventar.chart.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%!
public int clearRanges(org.lared.desinventar.util.DICountry countrybean)
{
		int j=0;
		// clears all ranges
		for (j=0; j<10; j++)
			countrybean.asMapRanges[j]=0;
		// determines how may ranges to define (those with colors...)	
		j=0;
		while (countrybean.asMapColors[j]!=null && countrybean.asMapColors[j].length()>1 && j<10)
			j++;
		return j++;
} 

%>
<head>
<title><%=countrybean.getTranslation("ThematicTitle")%></title>
<style>
<!--
.dragme {
	position:relative;
}
-->
</style>
<script language="JavaScript1.2">
<!--

var ie=document.all;
var nn6=document.getElementById&&!document.all;
var isdrag=false;
var x,y;
var dobj;

function movemouse(e)
{
  if (isdrag)
  {
    dobj.style.left = nn6 ? tx + e.clientX - x : tx + event.clientX - x;
    dobj.style.top  = nn6 ? ty + e.clientY - y : ty + event.clientY - y;
    return false;
  }
}

function selectmouse(e) 
{
  var fobj       = nn6 ? e.target : event.srcElement;
  var topelement = nn6 ? "HTML" : "BODY";

  while (fobj.tagName != topelement && fobj.className != "dragme")
  {
    fobj = nn6 ? fobj.parentNode : fobj.parentElement;
  }

  if (fobj.className=="dragme")
  {
    isdrag = true;
    dobj = fobj;
    tx = parseInt(dobj.style.left+0);
    ty = parseInt(dobj.style.top+0);
    x = nn6 ? e.clientX : event.clientX;
    y = nn6 ? e.clientY : event.clientY;
    document.onmousemove=movemouse;
    return false;
  }
}

document.onmousedown=selectmouse;
document.onmouseup=new Function("isdrag=false");

//-->
</script>
</head>
<%@ include file="/util/opendatabase.jspf" %>
<%@ include file="/paramprocessor.jspf" %>
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/header",countrybean.getLanguage(),out);%>
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
<%
// loads variables from private area
countrybean.loadVariables(countrybean.asChartMapVariables);

if (request.getParameter("equlegend")!=null)
	MapUtil.calculateRanges("equlegend",con,countrybean);
else
 if (request.getParameter("isolegend")!=null)
	MapUtil.calculateRanges("isolegend",con,countrybean);
else
 if (request.getParameter("loglegend")!=null)
	MapUtil.calculateRanges("loglegend",con,countrybean);
else
 if (request.getParameter("nicelegend")!=null)
	{
	for (int j=0; j<8; j++)
	countrybean.asMapRanges[j]=ChartServer.getNiceMaximum(countrybean.asMapRanges[j]);
	}
dbCon.close();
String pname="";
String[] pval;
String imgparams="?mappingfunction="+countrybean.DoTHEMATIC+"&transparencyf=1";
String sImageMap="<map name='mapselection'>";
sImageMap+="</map>";
%>
<%@ include file="/layerControl.jspf" %>
<%@ include file="/util/showDialog.jspf" %>
<script src="/DesInventar/xmlHttp.js"></script>

<script language="JavaScript">
// defaults for maps

var defer=false;
function callback(request)
{
// alert ("callback got response");
// refresh image source
var newSrc="/DesInventar/MapServer<%=imgparams %>&LAYERS=effects<%=sLevelLayers%>&rnd="+Math.random();
document.getElementById("DI_map").src=newSrc;
newSrc="/DesInventar/MapLegendServer<%=imgparams %>&rnd="+Math.random();
document.getElementById("DI_legend").src=newSrc;
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
		GraphServerUrl="/DesInventar/ajax_paramprocessor.jsp?frompage=/thematic_def.jsp";		  
		for (ijk=0; ijk<variables.length; ijk++)
		  if (variables.options[ijk].selected)
			GraphServerUrl+="&variables="+variables.options[ijk].value;				
		for (ijk=0; ijk<8; ijk++)
		 GraphServerUrl+="&range_"+ijk+"="+document.getElementById("range_"+ijk).value;
		for (ijk=0; ijk<8; ijk++)
		 GraphServerUrl+="&color_"+ijk+"="+escape(document.getElementById("color_"+ijk).value);
		for (ijk=0; ijk<8; ijk++)
		 GraphServerUrl+="&legend_"+ijk+"="+escape(document.getElementById("legend_"+ijk).value);
		GraphServerUrl+="&idType="+getRadioOption(idType);
		GraphServerUrl+="&legendType="+getRadioOption(legendType);
		GraphServerUrl+="&chartColor=1"; //+getRadioOption(chartColor);
		GraphServerUrl+="&chartTitle="+chartTitle.value;
		GraphServerUrl+="&chartSubTitle="+chartSubTitle.value;
		if (showValues.checked)
		  GraphServerUrl+="&showValues=1"
		GraphServerUrl+="&chartX="+chartX.value;
		GraphServerUrl+="&chartY="+chartY.value;
		GraphServerUrl+="&transparencyf="+transparencyf.value;
		GraphServerUrl+="&level_rep="+getRadioOption(level_rep);
		GraphServerUrl+="&level_map="+getRadioOption(level_map);
		if (dissagregate_map.checked)
		  GraphServerUrl+="&dissagregate_map=1"
		
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

function cellColor(j,colvalue)
{
htmlContent='<table  bgcolor="'+colvalue+'" cellpadding="1" cellspacing="0" border="1"><tr><td width=80 bgcolor="'+colvalue+'" style="cursor:pointer">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></tr></table>';//'+colvalue+'
document.getElementById("cell_"+j).innerHTML=htmlContent;
document.getElementById("color_"+j).value=colvalue;
}

var currentCell=0;
var sname="color_1";

function colorDone(dReturn)
{
if (dReturn)
	{
	if (dReturn==' ')
	  {
	  dReturn='';
	  document.getElementById("range_"+currentCell).value='';
	  }
	document.getElementById(sname).value=dReturn;
	cellColor(currentCell,dReturn);
  	full_regenerate();
	}
}

function delColor(j)
{
  document.getElementById("range_"+j).value='';
  cellColor(j,'');
  full_regenerate();
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

var hexPrefix="0x";
function generateGradient(colorSel)
{
red=parseInt(hexPrefix+colorSel.substring(1,3),16);
green=parseInt(hexPrefix+colorSel.substring(3,5),16);
blue=parseInt(hexPrefix+colorSel.substring(5,7),16);
// heuristic to locate the color in the slider: darker colors to the left, lighter colors to the right
colorindex=red+green+blue;
if (colorindex>765) colorindex=765;
maxcolors=3
for (j=0; j<8; j++){
	if (document.getElementById("range_"+j).value.length>0)
	  maxcolors=j;
    }
lastcolor=maxcolors+2;
if (lastcolor>8)
  lastcolor=8;	

maxcolors+=3; // will discard last 3

colorindex=Math.floor(colorindex*maxcolors/765)+1;

sliderDiv='';

// colors BEFORE
for (j=colorindex-1;j>=0; j--)
  {
  red2=red*j/colorindex;
  green2=green*j/colorindex;
  blue2=blue*j/colorindex;
  k=maxcolors-j-1;
  if (k<lastcolor)
  	{
	sname="color_"+k;
  	currentCell=k;
  	document.getElementById(sname).value=RGB(red2,green2,blue2);
  	cellColor(currentCell,RGB(red2,green2,blue2));
	}
  }
// colors AFTER
for (j=colorindex;j<maxcolors; j++)
  {
  red2=red+(255-red)*(j-colorindex)/(maxcolors-colorindex);
  green2=green+(255-green)*(j-colorindex)/(maxcolors-colorindex);
  blue2=blue+(255-blue)*(j-colorindex)/(maxcolors-colorindex);
  k=maxcolors-j-1;
  if (k<lastcolor)
  	{
  	sname="color_"+k;
  	currentCell=k;
  	document.getElementById(sname).value=RGB(red2,green2,blue2);
  	cellColor(currentCell,RGB(red2,green2,blue2));
	}
  }
}

function gradientDone(dReturn)
{
if (dReturn)
	 {
	 generateGradient(dReturn);
	 full_regenerate();
	 }
}

function setGradient()
{
sname="color_1";
scolor=document.getElementById(sname).value.substring(1,7);
var sPickerUrl = 'colorpick.jsp?gradient=Y&callback=gradientDone&color='+scolor+'&title=<%=countrybean.getTranslation("Select+color+for+gradient")%>';
dReturn = showDialogSz(sPickerUrl, 'gradientDone', '', 400, 450, "no");
}



function generateDoubleGradient()
{
colorSel=document.getElementById("gradcolor_1").value;
red1=parseInt(hexPrefix+colorSel.substring(1,3),16);
green1=parseInt(hexPrefix+colorSel.substring(3,5),16);
blue1=parseInt(hexPrefix+colorSel.substring(5,7),16);

colorSel=document.getElementById("gradcolor_2").value;
red2=parseInt(hexPrefix+colorSel.substring(1,3),16);
green2=parseInt(hexPrefix+colorSel.substring(3,5),16);
blue2=parseInt(hexPrefix+colorSel.substring(5,7),16);

maxcolors=1;
for (j=0; j<8; j++){
	if (document.getElementById("range_"+j).value.length>0)
	  maxcolors=j;
    }
maxcolors+=2;
if (maxcolors>8)
  maxcolors=8;	

// morphing of colors
for (j=0;j<maxcolors; j++)
  {
  red=red1 +(red2-red1)*j/(maxcolors-1);
  green=green1 +(green2-green1)*j/(maxcolors-1);
  blue=blue1 +(blue2-blue1)*j/(maxcolors-1);
  sname="color_"+j;
  currentCell=j;
  document.getElementById(sname).value=RGB(red,green,blue);
  cellColor(currentCell,RGB(red,green,blue));
  }
}


function gradientColor2Done(dReturn)
{
if (dReturn)
	 {
	 document.getElementById("gradcolor_2").value=dReturn;
	 generateDoubleGradient();
	 full_regenerate();
	 }
}

function gradientColor1Done(dReturn)
{
<% if (bIEBrowser || bIEdge){%>
alert("<%=countrybean.getTranslation("Please select now the second color...")%>");
<%}%>

if (dReturn)
	{
	document.getElementById("gradcolor_1").value=dReturn;
	scolor=document.getElementById("gradcolor_2").value.substring(1,7);
	var sPickerUrl = 'colorpick.jsp?gradient=y&callback=gradientColor2Done&color='+scolor+'&title=<%=countrybean.getTranslation("Select+color+for+gradient")%>[2]';
	dReturn = showDialogSz(sPickerUrl, 'gradientColor2Done', '', 320, 380, "no");
	}
}


function setDoubleGradient()
{
sname="gradcolor_1";
scolor=document.getElementById(sname).value.substring(1,7);
var sPickerUrl = 'colorpick.jsp?gradient=y&callback=gradientColor1Done&color='+scolor+'&title=<%=countrybean.getTranslation("Select+color+for+gradient")%>[1]';
dReturn = showDialogSz(sPickerUrl, 'gradientColor1Done', '', 320, 380, "no");
}

//------

function generateTripleGradient()
{
colorSel=document.getElementById("gradcolor_1").value;
red1=parseInt(hexPrefix+colorSel.substring(1,3),16);
green1=parseInt(hexPrefix+colorSel.substring(3,5),16);
blue1=parseInt(hexPrefix+colorSel.substring(5,7),16);

colorSel=document.getElementById("gradcolor_2").value;
red2=parseInt(hexPrefix+colorSel.substring(1,3),16);
green2=parseInt(hexPrefix+colorSel.substring(3,5),16);
blue2=parseInt(hexPrefix+colorSel.substring(5,7),16);

colorSel=document.getElementById("gradcolor_3").value;
red3=parseInt(hexPrefix+colorSel.substring(1,3),16);
green3=parseInt(hexPrefix+colorSel.substring(3,5),16);
blue3=parseInt(hexPrefix+colorSel.substring(5,7),16);

maxcolors=3
for (j=0; j<8; j++){
	if (document.getElementById("range_"+j).value.length>0)
	  maxcolors=j;
    }
midcolor=Math.round(maxcolors/2);
maxcolors+=2;
if (maxcolors>8)
  maxcolors=8;	


// morphing of colors
for (j=0;j<=midcolor; j++)
  {
  red=red1 +(red2-red1)*j/midcolor;
  green=green1 +(green2-green1)*j/midcolor;
  blue=blue1 +(blue2-blue1)*j/midcolor;
  sname="color_"+j;
  currentCell=j;
  document.getElementById(sname).value=RGB(red,green,blue);
  cellColor(currentCell,RGB(red,green,blue));
  }
// morphing of colors
for (j=midcolor+1;j<maxcolors; j++)
  {
  red=red2 +(red3-red2)*(j-midcolor)/(maxcolors-midcolor-1);
  green=green2 +(green3-green2)*(j-midcolor)/(maxcolors-midcolor-1);
  blue=blue2 +(blue3-blue2)*(j-midcolor)/(maxcolors-midcolor-1);
  sname="color_"+j;
  currentCell=j;
  document.getElementById(sname).value=RGB(red,green,blue);
  cellColor(currentCell,RGB(red,green,blue));
  }
}


function gradient3Color3Done(dReturn)
{
if (dReturn)
	 {
	 document.getElementById("gradcolor_3").value=dReturn;
	 generateTripleGradient();
	 full_regenerate();
	 }
}

function gradient3Color2Done(dReturn)
{
<% if (bIEBrowser || bIEdge){%>
alert("<%=countrybean.getTranslation("Please select now the third color...")%>");
<%}%>
if (dReturn)
	{
	document.getElementById("gradcolor_2").value=dReturn;
	scolor=document.getElementById("gradcolor_3").value.substring(1,7);
	var sPickerUrl = 'colorpick.jsp?gradient=y&callback=gradient3Color3Done&color='+scolor+'&title=<%=countrybean.getTranslation("Select+color+for+gradient")%>[3]';
	dReturn = showDialogSz(sPickerUrl, 'gradient3Color3Done', '', 320, 380, "no");
	}
}


function gradient3Color1Done(dReturn)
{
<% if (bIEBrowser || bIEdge){%>
alert("<%=countrybean.getTranslation("Please select now the second color...")%>");
<%}%>

if (dReturn)
	{
	document.getElementById("gradcolor_1").value=dReturn;
	scolor=document.getElementById("gradcolor_2").value.substring(1,7);
	var sPickerUrl = 'colorpick.jsp?gradient=y&callback=gradient3Color2Done&color='+scolor+'&title=<%=countrybean.getTranslation("Select+color+for+gradient")%>[2]';
	dReturn = showDialogSz(sPickerUrl, 'gradient3Color2Done', '', 320, 380, "no");
	}
}

function setTripleGradient()
{
sname="gradcolor_1";
scolor=document.getElementById(sname).value.substring(1,7);
var sPickerUrl = 'colorpick.jsp?gradient=y&callback=gradient3Color1Done&color='+scolor+'&title=<%=countrybean.getTranslation("Select+color+for+gradient")%>[1]';
dReturn = showDialogSz(sPickerUrl, 'gradient3Color1Done', '', 320, 380, "no");
}






function setNormal()
{
cellColor(0,'#ffff88');
cellColor(1,'#ffcc00');
cellColor(2,'#ff8800');
cellColor(3,'#ff0000');
cellColor(4,'#bb0000');
cellColor(5,'#770000');
cellColor(6,'');
cellColor(7,'');

with (document.desinventar)
{
	range_0.value=1;
	range_1.value=10;
	range_2.value=100;
	range_3.value=1000;
	range_4.value=10000;
	range_5.value='';
	range_6.value='';
	range_7.value='';
}
full_regenerate();
}

</script>
<%
int nTabActive=7; // thematic
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

<form name="desinventar" method='post' action="thematic_def.jsp">
  <table width="100%" border="0" class="pageBackground bss" rules="none">
  <tr>
    <td valign="top"><table width="700" border="0">
        <tr>
          <td align="left"><font class='ltbluelg'>
            <!-- onSubmit="return document.desinventar.stat0.selectedIndex>=0">-->
            <%=countrybean.getTranslation("Region")%>: </font><a href="javascript:routeTo('main.jsp')"><font class='regionlink'> <b><i>
            <jsp:getProperty name ="countrybean" property="countryname"/>
            </i></b></font></a> - [
            <jsp:getProperty name ="countrybean" property="countrycode"/>
            ] </td>
          <td align="center" class="subTitle"><%=countrybean.getTranslation("ThematicMapGenerator")%></td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td valign="top">
       <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
          <td width="250"><!-- Options -->
            <table border=1 cellpadding="0" cellspacing="0" class="IE_Table_borders bss">
              <tr>
                <td class="DI_TableHeader bs" colspan="5" align="center"><font color="White"><%=countrybean.getTranslation("Ranges")%></font></td>
              </tr>
              <tr>
                <th width="50" nowrap=true><%=countrybean.getTranslation("UpperLimit")%></th>
                <th width="30"><%=countrybean.getTranslation("Color")%></th>
                <th width="100"><%=countrybean.getTranslation("Legend")%></th>
                <th>&nbsp;</th>
                <th>&nbsp;</th>
              </tr>
              <%
			for (int j=0; j<8; j++)
			{%>
              <tr>
                <td><input class=bss size='6' maxlength='12' name="range_<%=j%>"  id="range_<%=j%>" value="<%=countrybean.asMapRanges[j]==0?"":countrybean.formatDouble(countrybean.asMapRanges[j])%>" onClick=" regenerate();"></td>
                <td onClick="setColor(<%=j%>)"><div id="cell_<%=j%>"></div></td>
                <td><input type=hidden name="color_<%=j%>" id="color_<%=j%>" value="<%=countrybean.asMapColors[j]%>">
                  &nbsp;
                  <input class=bss size='15' maxlength='50' name="legend_<%=j%>"  id="legend_<%=j%>" value="<%=countrybean.asMapLegends[j]%>" onClick=" regenerate();"></td>
                <td><a href='javascript:setColor(<%=j%>)'><img src="/DesInventar/images/edit_row.gif" alt='<%=countrybean.getTranslation("Edit")%>' border=0></a></td>
                <td><a href='javascript:delColor(<%=j%>)'><img src="/DesInventar/images/delete_row.gif" alt='<%=countrybean.getTranslation("Delete")%>' border=0></a></td>
              </tr>
              <%}%>
                            <tr>
                <td valign="bottom"><%=countrybean.getTranslation("Color")%>:<br>
                  <input type=button class="bss" name="deflegend" value="<%=countrybean.getTranslation("Normal")%>" onclick='setNormal();'/>
                  <input type=button class="bss" name="gradbtn" value="<%=countrybean.getTranslation("Gradient")%>" onclick='setGradient()'/>

                  <input type=button class="bss" name="grad2btn" value="<%=countrybean.getTranslation("Gradient")%>-2" onclick='setDoubleGradient()'/>
                  <input type=button class="bss" name="grad3btn" value="<%=countrybean.getTranslation("Gradient")%>-3" onclick='setTripleGradient()'/>
                  
                  <input type=hidden name="gradcolor_1" id="gradcolor_1" value="">
                  <input type=hidden name="gradcolor_2" id="gradcolor_2" value="">
                  <input type=hidden name="gradcolor_3" id="gradcolor_3" value="">
                  
                </td>
                <td colspan=4><%=countrybean.getTranslation("Calculate")%>:<br>
                  <input type=submit class="bss" name="isolegend" value="<%=countrybean.getTranslation("Isoranges")%>" onclick='document.desinventar.action.value=""'/>
                  <br/>
                  <input type=submit class="bss" name="equlegend" value="<%=countrybean.getTranslation("Equranges")%>" onclick='document.desinventar.action.value=""'/>
                  <br/>
                  <input type=submit class="bss" name="loglegend" value="<%=countrybean.getTranslation("Logarithmic")%>" onclick='document.desinventar.action.value=""'/>
                  <br/>
                  <input type=submit class="bss" name="nicelegend" value="<%=countrybean.getTranslation("Nice")%>" onclick='document.desinventar.action.value=""'/>
                </td>
              </tr>
            </table>
            <br/>
            <table  width='100%' border=1 cellpadding="0" cellspacing="0"  class='IE_Table'>
              <tr>
                <td  width='100%' class="DI_TableHeader bs" align="center"><font color="White"><%=countrybean.getTranslation("Variabletobeplotted")%>:</font></td>
              </tr>
              <tr>
                <td width='100%'><% // check the variables vector
                        if (countrybean.asVariables==null)
                            {
                            countrybean.asVariables=new String[1];
                            countrybean.asVariables[0] = "";
                            }
                        if (countrybean.asVariables[0].length() == 0)
                            countrybean.asVariables[0] = "1 as \""+countrybean.getTranslation("DataCards")+"\"";
                    %>
                  <select name="variables" id="variables" size=12 style="WIDTH:100%;" multiple onChange="full_regenerate();">
                    <%@ include file="/util/numericVariables.jspf" %>
                    <%@ include file="/util/extendedVariables.jspf" %>
                  </select>
                </td>
              </tr>
            </table></td>
          <td colspan="5"><!-- MAP -->
            <table border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td align="center" colspan="2" ><span class="title"><%=countrybean.sTitle%></span> </td>
              </tr>
              <tr>
                <td align="left" bgcolor="#ffffff"><!-- MAP -->
                  <img id='DI_map' src='/DesInventar/MapServer<%=imgparams %>&LAYERS=effects<%=sLevelLayers%>&rnd=<%=Math.random()%>' border=0><%=sImageMap%>
                  <!-- LEGEND -->
                  <img id='DI_legend'class='dragme' src='/DesInventar/MapLegendServer<%=imgparams %>&rnd=<%=Math.random()%>' border=0 style="position:absolute; left:900px; top:200px"></td>
              </tr>
              <tr>
                <td align="center" colspan="2" ><span class="subtitle"><%=countrybean.sSubTitle%></span> </td>
              </tr>
            </table></td>
        </tr>
        <tr>
        <tr>
          <td  height="25"><!-- EMPTY-->
          </td>
          <td align="left" valign="top" class=bss colspan="5" height="25"><!-- Buttons -->
            <input type='button' class=bss value="<%=countrybean.getTranslation("GenerateMap")%>" name="genmap" onClick="routeTo('thematic_def.jsp')">
            <input type='button' class=bss value="<%=countrybean.getTranslation("Dynamic Map")%>" name="dynmap" onClick="routeTo('thematic_OL.jsp')">
            <input type='button' class=bss value="<%=countrybean.getTranslation("Google")%>" name="goomap" onClick="routeTo('thematic_google.jsp')">
            <input type='button' class=bss value="<%=countrybean.getTranslation("VirtualEarth")%>" name="bingmap" onClick="routeTo('thematic_VE.jsp')">
			

            <input type='button' class=bss value="<%=countrybean.getTranslation("KML")%>" name="kml" onClick="window.open('thematic_kml.jsp')">
            <input type='button' class=bss value="<%=countrybean.getTranslation("KML-Vector")%>" name="kml" onClick="window.open('export_kml.jsp')">
            <input type='button' class=bss value="<%=countrybean.getTranslation("SVG")%>" name="kml" onClick="window.open('thematic_svg.jsp')">
			
          </td>
        </tr>
        <tr>
          <td valign="top" width="25%" align="center"><table border=1 cellpadding="0" cellspacing="0"  class='IE_Table bs' width="180">
              <tr>
                <td class="DI_TableHeader bs" align="center"><font color="White"><%=countrybean.getTranslation("TypeofAreaID")%></font></td>
              </tr>
              <tr>
                <td><input type="Radio" name="idType" id="idType" value="0"<%=countrybean.strChecked(countrybean.nShowIdType==0)%> onClick=" regenerate();">
                  &nbsp;<%=countrybean.getTranslation("NoIdshown")%><br>
                  <input type="Radio" name="idType" id="idType" value="1"<%=countrybean.strChecked(countrybean.nShowIdType==1)%> onClick=" regenerate();">
                  &nbsp;<%=countrybean.getTranslation("ShowCodes")%><br>
                  <input type="Radio" name="idType" id="idType" value="2"<%=countrybean.strChecked(countrybean.nShowIdType==2)%> onClick=" regenerate();">
                  &nbsp;<%=countrybean.getTranslation("ShowNames")%><br>
                </td>
              </tr>
            </table></td>
          <td valign="top"><table border=1 cellpadding="0" cellspacing="0" width=180  class='IE_Table bs'>
              <tr>
                <td class="DI_TableHeader" align="center"><font color="White"><%=countrybean.getTranslation("Legendtype")%></font></td>
              </tr>
              <tr>
                <td><input type="Radio" name="legendType" id="legendType" value="0"<%=countrybean.strChecked(countrybean.nMapType==0)%> onClick=" regenerate();">
                  &nbsp;<%=countrybean.getTranslation("Fillareas")%><br>
                  <input type="Radio" name="legendType" id="legendType" value="1"<%=countrybean.strChecked(countrybean.nMapType==1)%> onClick=" regenerate();">
                  &nbsp;<%=countrybean.getTranslation("Discs")%><br>
                  <input type="Radio" name="legendType" id="legendType" value="2"<%=countrybean.strChecked(countrybean.nMapType==2)%> onClick=" regenerate();">
                  &nbsp;<%=countrybean.getTranslation("Bars")%><br>
                  <input type="checkbox" name="showValues" id="showValues" value="1" <%=countrybean.strChecked(countrybean.nShowValueType==1)%>  onClick="regenerate();">
                  &nbsp;<%=countrybean.getTranslation("ShowValues")%><br>
                </td>
              </tr>
            </table></td>
          <td valign="top" width="25%" align="center"><table border=1 cellpadding="0" cellspacing="0" class='IE_Table bs' width="180">
              <tr>
                <td class="DI_TableHeader"
 align="center"><font color="White"><%=countrybean.getTranslation("OutputLevel")%></font></td>
              </tr>
              <tr>
                <td><input type="Radio" name="level_map"  id="level_map" value="0"<%=countrybean.strChecked(countrybean.level_map==0)%> onClick=" regenerate();">
                  <%=countrybean.asLevels[0]%><br>
                  <% if (countrybean.asLevels[1].length()>0){%>
                  <input type="Radio" name="level_map" value="1"<%=countrybean.strChecked(countrybean.level_map==1)%> onClick=" regenerate();">
                  <%=countrybean.asLevels[1]%><br>
                  <%} if (countrybean.asLevels[2].length()>0){%>
                  <input type="Radio" name="level_map" value="2"<%=countrybean.strChecked(countrybean.level_map==2)%> onClick=" regenerate();">
                  <%=countrybean.asLevels[2]%><br>
                  <%}%>
				  <input type="checkbox" name="dissagregate_map" value="1" <%=countrybean.strChecked(countrybean.dissagregate_map)%> onClick=" regenerate();">
                  <%=countrybean.getTranslation("Artificial Disaggregation")%>                  
                </td>
              </tr>
            </table>
            <br>
            <table border=1 cellpadding="0" cellspacing="0" class='IE_Table bs' width="180">
              <tr>
                <td class="DI_TableHeader bs" align="center"><font color="White"><%=countrybean.getTranslation("SelectionLevel")%></font></td>
              </tr>
              <tr>
                <td><input type="Radio" name="level_rep" value="0"<%=countrybean.strChecked(countrybean.level_rep==0)%> onClick=" regenerate();">
                  <%=countrybean.asLevels[0]%><br>
                  <% if (countrybean.asLevels[1].length()>0){%>
                  <input type="Radio" name="level_rep" value="1"<%=countrybean.strChecked(countrybean.level_rep==1)%> onClick=" regenerate();">
                  <%=countrybean.asLevels[1]%><br>
                  <%}%>
                </td>
              </tr>
            </table></td>
          <td valign="top" align="center"><table border=1 cellpadding="0" cellspacing="0" class='IE_Table bs'>
              <tr>
                <td width='400' class="DI_TableHeader" align="center" colspan=3><font color="White"><%=countrybean.getTranslation("MapFeatures")%></font></td>
              </tr>
              <tr>
                <td class=bs><strong><%=countrybean.getTranslation("GenerateMap")%></strong><br> <%=countrybean.getTranslation("Width")%>:
                  <input TYPE=HIDDEN name="_chartX" value="1000" size="5" maxlength="4"  onChange="regenerate();">
                  <input class=bs name="chartX" value="<%=countrybean.xresolution%>" size="5" maxlength="4"  onChange="regenerate();">
                  &nbsp;&nbsp;&nbsp;<%=countrybean.getTranslation("Height")%>:
                  <input TYPE=HIDDEN  name="_chartY" value="600" size="5" maxlength="4"  onChange="regenerate();">
                  <input class=bs name="chartY" value="<%=countrybean.yresolution%>" size="5" maxlength="4"  onChange="regenerate();">
                </td>
                <td class=bs><strong><%=countrybean.getTranslation("Dynamic Map")%>&nbsp;&nbsp;</strong><br>
                  &nbsp;<%=countrybean.getTranslation("Transparency")%>:
                  <input class=bs name="transparencyf" size="5" maxlength="4" value="<%=countrybean.formatDouble(countrybean.dTransparencyFactor,2)%>">
                  <input type=hidden name="chartColor" value="1">
                </td>
              </tr>
              <tr>
                <td colspan=3><br>
                  <%=countrybean.getTranslation("Title")%>:
                  <input class=bs name="chartTitle" value="<%=countrybean.sTitle%>" size="50" maxlength="80"  onChange="regenerate();">
                  <br>
                  <br>
                  <%=countrybean.getTranslation("Subtitle")%>:
                  <input class=bs name="chartSubTitle" value="<%=countrybean.sSubTitle%>" size="50" maxlength="80"  onChange="regenerate();">
                  <br>
                  &nbsp; </td>
              </tr>
            </table></td>
          <td valign="top"><!-- DI Layers 	
            <%=sLayersControl%>
            -->
          </td>
          <td width="100"></td>
        </tr>
<!--
        <tr>
          <td></td>
          <td colspan=4 align="left"><table  cellspacing="0" cellpadding="0" border="0">
              <tr>
                <td class=bss><%=countrybean.getTranslation("Formula")%>&nbsp;&nbsp;</td>
                <td><input type="text" class="bss" name="sDisabledExpertWhere" size="80" maxlength="255" disabled onDblClick="openExpert()" value="<%=(Parser.translateExpertExpression(countrybean.sExpertVariable, Parser.hmVarTrans))%>"/>
                  &nbsp;&nbsp;
                  <input type="hidden" name="sExpertVariable" value="<%=(Parser.translateExpertExpression(countrybean.sExpertVariable, Parser.hmVarTrans))%>"/>
                  <input class="bss" type='button' name='expertbutton' value='<%=countrybean.getTranslation("Expert")%>' onClick="openExpert()"/>
                </td>
              </tr>
            </table>
            <br>
            <br>
          </td>
        </tr>
-->

      </table>
      <input type='hidden' name='nStart' value=''>
      <INPUT type='hidden'  name="actiontab" id="actiontab">
      <INPUT type='hidden'  name="frompage" value="<%=request.getServletPath()%>">
</form>
<script language="JavaScript">
<!--

document.getElementById("gradcolor_1").value='#00aa00';
document.getElementById("gradcolor_2").value='#ffff00';
document.getElementById("gradcolor_3").value='#DD0000';


function submitForm(istart)
{
document.desinventar.nStart.value=istart;
document.desinventar.submit();
}

<%for (int j=0; j<8; j++){
%>cellColor(<%=j%>,'<%=countrybean.asMapColors[j]%>');
<%}%>
if (document.desinventar.variables.selectedIndex<0)
document.desinventar.variables.selectedIndex=1;

var idW=1000;
var idH=750;	
<% if (bIEBrowser) { %>
	idW = document.body.clientWidth; 
	idH = document.body.clientHeight; 
	<% } else { %>
	idH = window.outerHeight-150;
	idW = window.outerWidth; 
	<% } %>

document.getElementById("DI_legend").style.left=idW-150;
// -->
</script>
</td>
</tr>
</table>
<%@ include file="/html/footer.html" %>
</body></html>
