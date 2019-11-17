<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<%@ page info="DesConsultar simple results page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.map.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<head>
<title><%=countrybean.getTranslation("MapTitle")%></title>
</head>
 <%@ include file="/util/opendatabase.jspf" %>
<%@ include file="/paramprocessor.jspf" %>
<%@ taglib uri="inventag.tld" prefix="inv" %>
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/header",countrybean.getLanguage(),out);%>
<%
int nTabActive=3; // maps
String[] sTabNames={countrybean.getTranslation("Profile"),countrybean.getTranslation("Query"),countrybean.getTranslation("ViewData"),countrybean.getTranslation("ViewMap"),
           countrybean.getTranslation("Charts"),countrybean.getTranslation("Statistics"),countrybean.getTranslation("Reports"),
		   countrybean.getTranslation("Thematic"), countrybean.getTranslation("Crosstab")};
String[] sTabIcons={"check.gif","icon_query.gif","icon_viewdata.gif","icon_viewmap.gif","icon_charts.gif","icon_statistics.gif",
                    "icon_reports.gif","icon_thematic.gif","xtab.gif"};
String[] sTabLinks={"javascript:routeTo('profiletab.jsp')","javascript:routeTo('main.jsp')","javascript:routeTo('results.jsp')","javascript:routeTo('maps.jsp')",
				"javascript:routeTo('graphics.jsp')","javascript:routeTo('definestats.jsp')","javascript:routeTo('generator.jsp')",
				"javascript:routeTo('thematic_def.jsp')","javascript:routeTo('definextab.jsp')"};

String sShowCodes=countrybean.not_null_safe(request.getParameter("showcodes"));
// level of the displayed map
int new_level=countrybean.extendedParseInt(request.getParameter("new_level"));
int level_act=new_level; //countrybean.extendedParseInt(request.getParameter("level_act"));
// if displaying level 1 or 2, what codes is being displayed
String level0_code=countrybean.not_null_safe(request.getParameter("level0_code"));
// if displaying level 2, what level1 is being displayed
String level1_code=countrybean.not_null_safe(request.getParameter("level1_code"));
%>
<%@ include file="/util/tabs.jspf" %>

<form name="desinventar" method=post action="maps.jsp">
<input type='hidden' name="level_act" value="<%=level_act%>">
<input type='hidden' name="new_level" value="<%=new_level%>">
<input type='hidden' name="level0_code" value="<%=level0_code%>">
<input type='hidden' name="level1_code" value="<%=level1_code%>">
<INPUT type='hidden'  name="actiontab" id="actiontab">
<INPUT type='hidden'  name="frompage" value="<%=request.getServletPath()%>">
<table width="<%=Math.max(750,countrybean.xresolution+200)%>" border="0"  class="pageBackground">
 <tr>
  <td align="left" width="300" nowrap>
  <font color="Blue"><%=countrybean.getTranslation("Region")%> </font><a href="javascript:routeTo('main.jsp')"><font class='regionlink'>
  <b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font></a> - [<jsp:getProperty name ="countrybean" property="countrycode"/>]
</td><td nowrap width="300" align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<span class="subTitle"><%=countrybean.getTranslation("AdministrativeBoundariesMap")%></span>
</td><td align="left">&nbsp;&nbsp;&nbsp;<font class=bss><%=countrybean.getTranslation("InstructionsMap1")%></font> </td></table>
<%
MapUtil.validateSelected(con,countrybean);
String pname="";
String[] pval;
double xminif = 0;
double yminif = 0;
double xmaxif = 10000;
double ymaxif = 10000;
String imgparams="chartX="+countrybean.xresolution+"&chartY="+countrybean.yresolution;
String extraimgparams="";
String sImageMap="<map name='mapselection'>";
String sPolygons="";
String sPolygonImages="new Array(";
String sPolygonCodes="new Array(";
String sPolygonStates="new Array(";
String sPolygonChild="new Array(";
String asSelected[]=null;
int nPolygons=0;

if (level_act==1)
	asSelected=countrybean.asNivel1;
else if (level_act==2)
	asSelected=countrybean.asNivel2;
else
	asSelected=countrybean.asNivel0;
int xOffset=280;
int yOffset=260;
try // this may fail, regiones may not exist in the database...
	{
	 PreparedStatement pstmt=null;

     String sSql = " from regiones r,";
	 String sNameSql="nombre";
	 switch (level_act)
	 	{
		case 0:
				sSql+=" lev0 geo where codregion=geo.lev0_cod";
				sNameSql="geo.lev0_name as DiName";
				break;
		case 1:
				sSql+=" lev1 geo where codregion=geo.lev1_cod";
				sNameSql="geo.lev1_name as DiName";
				break;
		case 2:
				sSql+=" lev2 geo where codregion=geo.lev2_cod";
				sNameSql="geo.lev2_name as DiName";
				break;				
		}
	 sSql+=" and nivel=" + level_act;
     if ((level_act==1 && level0_code.length() > 0) ||     (level_act==2 && level1_code.length() > 0))
			sSql += " and r.lev0_cod=?";
	 String sFullSql="select max("+countrybean.sqlXmax()+") as x_max, max(ymax) as y_max, min("+countrybean.sqlXmin()+") as x_min, min(ymin) as y_min  " + sSql;
	 //out.println("<!-- [1] "+sFullSql+" -->");
     pstmt=con.prepareStatement(sFullSql);
     if (level_act==1 && level0_code.length() > 0)
        	pstmt.setString(1,level0_code);
     else if (level_act==2 && level1_code.length() > 0)
        	pstmt.setString(1,level1_code);
	 rset=pstmt.executeQuery();
	 
	 if (rset.next())
      {
        xminif = rset.getDouble("x_min");
        yminif = rset.getDouble("y_min");
        xmaxif = rset.getDouble("x_max");
        ymaxif = rset.getDouble("y_max");
      }
 
/* to be enabled soon?
	 if (request.getParameter("xminif")!=null)
        xminif = countrybean.extendedParseDouble(request.getParameter("xminif"));
	 if (request.getParameter("yminif")!=null)
        yminif = countrybean.extendedParseDouble(request.getParameter("yminif"));
	 if (request.getParameter("xmaxif")!=null)
        xmaxif = countrybean.extendedParseDouble(request.getParameter("xmaxif"));
	 if (request.getParameter("ymaxif")!=null)
        ymaxif = countrybean.extendedParseDouble(request.getParameter("ymaxif"));
*/ 
     imgparams+="&xminif="+xminif+"&yminif="+yminif+"&xmaxif="+xmaxif+"&ymaxif="+ymaxif;
     MapServer ms = new MapServer();
	 ms.mt.setView(countrybean.xresolution, countrybean.yresolution);
	 ms.mt.setTransformation(xminif,yminif,xmaxif,ymaxif);
 	 
	 sFullSql="select "+sNameSql+", r.*, (select count(*) from regiones rchild where nivel=" 
	 						+ (level_act+1)+ " and rchild.lev0_cod=r.codregion) as nchild "   +sSql;
	 //out.println("<!-- [2]  "+sFullSql+" -->");
     pstmt=con.prepareStatement(sFullSql);
     if (level_act==1 && level0_code.length() > 0)
        	pstmt.setString(1,level0_code);
     else if (level_act==2 && level1_code.length() > 0)
        	pstmt.setString(1,level1_code);
	 rset=pstmt.executeQuery();
	 while (rset.next())
	  	{
		nPolygons++;
		// produces the image map coords
		String sCode=rset.getString("codregion");
		double xmin=rset.getDouble(countrybean.sqlXmin());
		double ymin=rset.getDouble("ymin");
		double xmax=rset.getDouble(countrybean.sqlXmax());
		double ymax=rset.getDouble("ymax");
		double x=ms.mt.xdev((xmin+xmax)/2);
		double y=ms.mt.ydev((ymin+ymax)/2);
		String sName=countrybean.not_null(rset.getString("DiName"));
		double xNm=(x-sName.length()*4);
		if (xNm<0) xNm=0;
		int nChild=rset.getInt("nchild"); 
		sImageMap+="<area coords='"+
		           xNm+","+y+","+(xNm+sName.length()*8)+","+(y-10)+
				   "'  href=\"javascript:doSelect('"+sCode+"')\" ondblclick=\"doZoom('"+sCode+"')\" alt=\""+sName+"\"  title=\""+sName+"\"  >";
		// produces the filled polygon image 
		sPolygons+="<div id='mapdiv_"+sCode+"' STYLE='position:absolute;top:"+(yOffset+ms.mt.ydev(ymax))+"px;left:"+(xOffset+ms.mt.xdev(xmin))+"px;vertical-align:top;z-index:2;'>";
		if (countrybean.bInArray(sCode,asSelected))
			{
			sPolygons+="<img src='/DesInventar/MapServer?mappingfunction="+countrybean.SELECTED+"&"+imgparams+extraimgparams+"&level="+level_act+"&code="+sCode+"&showcodes="+sShowCodes+"' border='0'>";
			sPolygonStates+="true,";
			}
		else	
			sPolygonStates+="false,";
		sPolygonImages+="\"<img src='/DesInventar/MapServer?mappingfunction="+countrybean.SELECTED+"&"+imgparams+extraimgparams+"&level="+level_act+"&code="+sCode+"&showcodes="+sShowCodes+"' border='0'>\",";
		sPolygons+="</div>";
		sPolygonCodes+="'"+sCode+"',";
		sPolygonChild+= nChild==0?"false,":"true,";
		}
	rset.close();
	stmt.close();
	}
catch (Exception exx){
	 					out.println("<!-- "+exx.toString()+" -->");
						/*no issues, ignore*/
						}
sImageMap+="</map>";
sPolygonImages+="\"\");";
sPolygonCodes+="'');";
sPolygonStates+="false);";
sPolygonChild+="false);";
%>
<script  language="JavaScript">
var nPolygons=<%=nPolygons%>;
var arrCodes=<%=sPolygonCodes%>
var arrImages=<%=sPolygonImages%>
var arrStates=<%=sPolygonStates%>
var arrLoaded=<%=sPolygonStates%>
var arrChild=<%=sPolygonChild%>


function doCheckList()
{
var j=0;
for ( ; j<document.desinventar.codes.options.length; j++)
	{
	sCode=document.desinventar.codes.options[j].value;		
	polygonSet(sCode,document.desinventar.codes.options[j].selected);
	}
}

function polygonSet(sCode, bSelected)
{
var j=0;
for ( ; j<nPolygons; j++)
  if (arrCodes[j]==sCode)
   {
    if (bSelected)
		{
		if (!arrStates[j]) // select only if not selected
			{
			arrStates[j]=true;
			if (!arrLoaded[j])
				document.getElementById("mapdiv_"+sCode).innerHTML=arrImages[j];
			arrLoaded[j]=true;
			document.getElementById("mapdiv_"+sCode).style.visibility="visible";
			}
		}
	else
		if (arrStates[j])  // if selected, unselecte
		    {
			arrStates[j]=false;
			document.getElementById("mapdiv_"+sCode).style.visibility="hidden";
			}
   }
}

function polygonToggle(sCode)
{
var j=0;
for ( ; j<nPolygons; j++)
  if (arrCodes[j]==sCode)
   {
    if (arrStates[j])
	    {
		arrStates[j]=false;
		document.getElementById("mapdiv_"+sCode).style.visibility="hidden";
		}
	else
		{
		arrStates[j]=true;
		document.getElementById("mapdiv_"+sCode).innerHTML=arrImages[j];
		document.getElementById("mapdiv_"+sCode).style.visibility="visible";
		}	 
   }
}

function  doSelect(sCode)
{
// select it in the list
var j=0;
for ( ; j<document.desinventar.codes.options.length; j++)
	{
	if (document.desinventar.codes.options[j].value==sCode)
		document.desinventar.codes.options[j].selected=!document.desinventar.codes.options[j].selected;
	}
polygonToggle(sCode);
}

function  doSet(sCode, bSelected)
{
// select it in the list
var j=0;
for ( ; j<document.desinventar.codes.options.length; j++)
	{
	if (document.desinventar.codes.options[j].value==sCode)
		document.desinventar.codes.options[j].selected=bSelected;
	}
polygonSet(sCode,bSelected);
}

function  doZoom(sCode)
{
doSet(sCode, true);
var j=0;
var nPoly=0;
for ( ; j<nPolygons; j++)
  if (arrCodes[j]==sCode) nPoly=j;

if (document.desinventar.level_act.value==2)
	alert ("<%=countrybean.getTranslation("NoMapInLevel")%>");
else if (!arrChild[nPoly])
	alert ("<%=countrybean.getTranslation("NoDetailedMap")%>");
else
   {
   document.desinventar.new_level.value=Math.abs(document.desinventar.level_act.value)+1;
   if (document.desinventar.new_level.value==1)
      document.desinventar.level0_code.value=sCode;
   if (document.desinventar.new_level.value==2)
      document.desinventar.level1_code.value=sCode;
    polygonSet(sCode, true);
   document.desinventar.submit();	   
   }
}

function  go_Up()
{
if (document.desinventar.level_act.value==0)
	alert ("<%=countrybean.getTranslation("isTopLevel")%>");
else
   {
   document.desinventar.new_level.value=document.desinventar.level_act.value-1;
   document.desinventar.submit();	   
   }
}

function zoom_in()
{
document.desinventar.xminif.value=<%=Math.round(xminif+(xmaxif-xminif)/5)%>;
document.desinventar.yminif.value=<%=Math.round(yminif+(ymaxif-yminif)/5)%>;
document.desinventar.xmaxif.value=<%=Math.round(xmaxif-(xmaxif-xminif)/5)%>;
document.desinventar.ymaxif.value=<%=Math.round(ymaxif-(ymaxif-yminif)/5)%>;
document.desinventar.submit();	   
}

function zoom_out()
{
document.desinventar.xresolution.value=Math.round(document.desinventar.xresolution.value/1.25);
document.desinventar.yresolution.value=Math.round(document.desinventar.yresolution.value/1.25);
document.desinventar.submit();	   
}

function enlarge()
{
document.desinventar.xresolution.value=Math.round(document.desinventar.xresolution.value*1.25);
document.desinventar.yresolution.value=Math.round(document.desinventar.yresolution.value*1.25);
document.desinventar.submit();	   
}

function reduce()
{
document.desinventar.xresolution.value=Math.round(document.desinventar.xresolution.value/1.25);
document.desinventar.yresolution.value=Math.round(document.desinventar.yresolution.value/1.25);
document.desinventar.submit();	   
}


function showcodes()
{
document.desinventar.showcodes.value="Y";
document.desinventar.submit();	   
}
function shownames()
{
document.desinventar.showcodes.value="";
document.desinventar.submit();	   
}
</script>


<table border="1" cellpadding="0" cellspacing="0" class="pageBackground" width="100%">
 <tr>
    <td width="1"><img src='spacer.gif' width="1" height="<%=countrybean.yresolution+30%>"</td>
	<td valign="top" align="right" width="150"><br><!-- Tools & buttons -->
<%	
if (level_act==0){%>
	 <%=htmlServer.htmlEncode(countrybean.asLevels[0]) %><br>
	 <SELECT name="codes" style="WIDTH: 150px; HEIGHT: 160px" size=10 multiple  class=bs onChange="doCheckList()">
       <inv:selectLevel0 connection="<%= con %>"  selected="<%=countrybean.asNivel0%>"/>
	 </SELECT><br>
<%}
else  
if (level_act==1){%>
	 <%=htmlServer.htmlEncode(countrybean.asLevels[1]) %><br>
	 <SELECT name="codes" style="WIDTH: 150px; HEIGHT: 160px" size=10 multiple  class=bs onChange="doCheckList()">
       <inv:selectLevel1 connection="<%= con %>" level0Code="<%=countrybean.asNivel0%>" selected="<%=countrybean.asNivel1%>"/>
	 </SELECT><br>
<%}
else  
if (level_act==2){%>
	 <%=htmlServer.htmlEncode(countrybean.asLevels[2]) %><br>
	 <SELECT name="codes" style="WIDTH: 150px; HEIGHT: 160px" size=10 multiple  class=bs onChange="doCheckList()">
       <inv:selectLevel2 connection="<%= con %>" level1Code="<%=countrybean.asNivel1%>" selected="<%=countrybean.asNivel2%>"/>
	 </SELECT><br>
<%}%>
	 <!-- <input type='submit' name="query" value="Return to query"><br> -->
	 <br>
	<img src="/DesInventar/images/map_toolbar.gif" alt="" width="49" height="192" border="0" usemap="#maptoolbar">
	<map name="maptoolbar">
<area alt="Increase Size" coords="1,2,48,31" href="javascript:enlarge()">
<area alt='Reduce size' coords='0,31,47,62' href='javascript:reduce()'>
<area alt="UPlevel" coords="-1,63,47,94" href="javascript:go_Up()">
<area alt="Show Codes" coords="1,95,51,125" href="javascript:showcodes()">
<area alt="ShowNames" coords="0,127,47,158" href="javascript:shownames()">
<area alt="<%=countrybean.getTranslation("Refreshmap")%>" coords="0,160,47,190" href="javascript:document.desinventar.submit()">
</map>
	<input type='hidden' name="showcodes" value="<%=sShowCodes%>">
	<br><br> 
	 <%=countrybean.getTranslation("Mapwidth")%><br>
	 <input name="xresolution" size="5" maxlength="5" value="<%=countrybean.xresolution%>"><br>    
	 <%=countrybean.getTranslation("Mapheight")%><br>
	 <input name="yresolution" size="5" maxlength="5" value="<%=countrybean.yresolution%>"><br>    
	</td>
	<td height="" bgcolor='#ffffff' width="<%=Math.max(750,countrybean.xresolution+200)%>">
	<div id="mapdiv" STYLE='position:absolute;top:<%=yOffset%>px;left:<%=xOffset%>px;vertical-align:top;z-index:255; '>
	<img src='/DesInventar/MapServer?<%=imgparams %>&level=<%=level_act%>&level0_code=<%=level0_code%>&level1_code=<%=level1_code%>&showcodes=<%=sShowCodes%>' border=0 usemap="#mapselection" height='<%=countrybean.yresolution%>' width='<%=countrybean.xresolution%>'>
	<%=sImageMap%>
	</div>
    <!-- MAP --><%=sPolygons%>
	</td>
 </tr>
</table>
<!-- <%=request.getParameter("xminif")%> -->
 <input name="xminif" id="xminif" type='hidden'>
 <input name="yminif" id="yminif" type='hidden'>
 <input name="xmaxif" id="xmaxif" type='hidden'>
 <input name="ymaxif" id="ymaxif" type='hidden'>
    
</form>
<%
dbCon.close();
%>

<%@ include file="/html/footer.html" %>
</body>
</html>
