<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<%@ page info="DesConsultar simple results page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%@ include file="/util/opendatabase.jspf" %>
<%@ include file="/paramprocessor.jspf" %>
<%@ taglib uri="inventag.tld" prefix="inv" %>
<%!
String outSortHeader(String sVariable, String sTitle)
{
String sRet="<a href='javascript:sortby(\""+sVariable+"\")' class='blacklinks'>"+sTitle+"</a>&nbsp;";
sRet+="<a href='javascript:sortby(\""+sVariable+" desc\")' class='blacklinks'><img src='/DesInventar/images/arr_down.gif' border=0></a>";
return sRet;
}


%>

<head>
<title><%=countrybean.getTranslation("Results")%></title>
</head>
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/header",countrybean.getLanguage(),out);%>
<script language="JavaScript">
<!--
function submitForm(istart)
{
document.desinventar.nStart.value=istart;
document.desinventar.submit();
}
function sortby(locsort)
{
document.desinventar.localsort.value=locsort;
document.desinventar.submit();
}

// -->
</script>
<%
int nTabActive=2; // results
String[] sTabNames={countrybean.getTranslation("Profile"),countrybean.getTranslation("Query"),countrybean.getTranslation("ViewData"),countrybean.getTranslation("ViewMap"),
           countrybean.getTranslation("Charts"),countrybean.getTranslation("Statistics"),countrybean.getTranslation("Reports"),
		   countrybean.getTranslation("Thematic"), countrybean.getTranslation("Crosstab")};
String[] sTabIcons={"check.gif","icon_query.gif","icon_viewdata.gif","icon_viewmap.gif","icon_charts.gif","icon_statistics.gif",
                    "icon_reports.gif","icon_thematic.gif","xtab.gif"};
String[] sTabLinks={"javascript:routeTo('profiletab.jsp')","javascript:routeTo('main.jsp')","javascript:routeTo('results.jsp')","javascript:routeTo('maps.jsp')",
				"javascript:routeTo('graphics.jsp')","javascript:routeTo('definestats.jsp')","javascript:routeTo('generator.jsp')",
				"javascript:routeTo('thematic_def.jsp')","javascript:routeTo('definextab.jsp')"};
countrybean.nAction=countrybean.VIEWDATA;
String sCountryCodeParameter="";
if (request.getParameter("countrycode")!=null)
	{
	sCountryCodeParameter="&countrycode="+countrybean.countrycode;
	}
String sLangSuffix="";
if ("EN".equals(countrybean.getDataLanguage()))
	sLangSuffix="_en";
String sAllComments="";

%>
<%@ include file="/util/tabs.jspf" %>
<table width="1000" border="0"  class="pageBackground" >
 <tr>
  <td align="left">
  <font color="Blue"><%=countrybean.getTranslation("Region")%> </font><a href="javascript:routeTo('main.jsp')"><font class='regionlink'>
  <b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font></a> - [<jsp:getProperty name ="countrybean" property="countrycode"/>]
</td><td nowrap  align="center">
<span class="subTitle"><%=countrybean.getTranslation("DataQueryResults")%></span>
</td><td nowrap=true align="right" valign="bottom">
<form name='desinventar' action='results.jsp' method='post' style="margin-bottom:0;margin-top:0;">
<input type='hidden' name='nStart' value=''>
<INPUT type='hidden'  name="actiontab" id="actiontab">
<INPUT type='hidden'  name="frompage" value="<%=request.getServletPath()%>">
<input type='checkbox' name='viewStandard' value='Y' onClick="document.desinventar.submit();" <%=countrybean.strChecked(countrybean.bViewStandard)%>><%=countrybean.getTranslation("Standard")%>&nbsp;
<input type='checkbox' name='viewExtended' value='Y' onClick="document.desinventar.submit();" <%=countrybean.strChecked(countrybean.bViewExtended)%>><%=countrybean.getTranslation("Extension")%>&nbsp;&nbsp;
<INPUT type='hidden'  name="localsort" value="">
</form>
</td><td nowrap align="right" class="bss"><%  
// a scrollable cursor is required to move quickly to start of records
ArrayList sqlparams=new ArrayList();
PreparedStatement pstmt=null;
String sSql="select count(*) as nhits "+countrybean.getWhereSql(sqlparams);
try
	{
	pstmt=con.prepareStatement(sSql);
	for (int k=0; k<sqlparams.size(); k++)
				pstmt.setString(k+1, (String)sqlparams.get(k));
	rset=pstmt.executeQuery();
	}
catch (Exception e)
	{
	out.println("<!-- "+e.toString()+"-->");
	}	
	
int nHits=0;
if (rset!=null && rset.next())
  nHits=rset.getInt("nhits");
int nStart=htmlServer.extendedParseInt(request.getParameter("nStart"));
int nPages=nHits/countrybean.nMaxhits;
if (nPages*countrybean.nMaxhits<nHits) nPages++;
String sLinks=htmlServer.putLinksToAllPages(nHits,  nStart, countrybean.nMaxhits,
   countrybean.getTranslation("Results")+": "+ nHits +" "+countrybean.getTranslation("hits")+". "+nPages
   +" "+countrybean.getTranslation("Pages")+" ", "linkText");
out.println(sLinks);
%>
  </td>
 </tr>
</table>
<table cellspacing="0" cellpadding="0" border="1" class="IE_Table_borders bs">
<tr class="bodydarklight">
<th nowrap rowspan=2><%
out.print("<a href='javascript:sortby(\"fichas.serial\")' class='blacklinks'>"+countrybean.getTranslation("Serial")+"</a>&nbsp;");
out.print("<a href='javascript:sortby(\"fichas.serial desc\")' class='blacklinks'><img src='/DesInventar/images/arr_down.gif' border=0></a>");
%></th>

<th nowrap rowspan=2><%
out.print("<a href='javascript:sortby(\"eventos.nombre"+sLangSuffix+"\")' class='blacklinks'>"+countrybean.getTranslation("Event")+"</a>&nbsp;");
out.print("<a href='javascript:sortby(\"eventos.nombre"+sLangSuffix+" desc\")' class='blacklinks'><img src='/DesInventar/images/arr_down.gif' border=0></a>");
%></th>
<% for (int j=0; j<3; j++){%>
<th nowrap rowspan=2><%
out.print("<a href='javascript:sortby(\"lev"+j+"_name"+sLangSuffix+"\")' class='blacklinks'>"+countrybean.asLevels[j] +"</a>&nbsp;");
out.print("<a href='javascript:sortby(\"lev"+j+"_name"+sLangSuffix+" desc\")' class='blacklinks'><img src='/DesInventar/images/arr_down.gif' border=0></a>");
%></th>
<%}%>
<th nowrap rowspan=2>
<%
out.print("<a href='javascript:sortby(\"fechano,fechames,fechadia\")' class='blacklinks'>"+countrybean.getTranslation("Date") +"</a>&nbsp;");
out.print("<a href='javascript:sortby(\"fechano desc,fechames desc,fechadia desc\")' class='blacklinks'><img src='/DesInventar/images/arr_down.gif' border=0></a>");
%>
</th>
<% if (countrybean.bViewStandard)
{%>
<th rowspan=2 nowrap><%=outSortHeader("fichas.lugar",countrybean.getTranslation("Location"))%></th>
<th rowspan=2 nowrap><%=outSortHeader("fichas.muertos",countrybean.getTranslation("Deaths"))%></th>
<th rowspan=2 nowrap><%=outSortHeader("fichas.heridos",countrybean.getTranslation("Injured"))%></th>
<th rowspan=2 nowrap><%=outSortHeader("fichas.desaparece",countrybean.getTranslation("Missing"))%></th>
<th rowspan=2 nowrap><%=outSortHeader("fichas.vivdest",countrybean.getTranslation("DestroyedHouses"))%></th>
<th rowspan=2 nowrap><%=outSortHeader("fichas.vivafec",countrybean.getTranslation("AffectedHouses"))%></th>
<th rowspan=2 nowrap><%=outSortHeader("fichas.damnificados",countrybean.getTranslation("Victims"))%></th>
<th rowspan=2 nowrap><%=outSortHeader("fichas.afectados",countrybean.getTranslation("Affected"))%></th>
<th rowspan=2 nowrap><%=outSortHeader("fichas.reubicados",countrybean.getTranslation("Relocated"))%></th>
<th rowspan=2 nowrap><%=outSortHeader("fichas.evacuados",countrybean.getTranslation("Evacuated"))%></th>
<th rowspan=2 nowrap><%=outSortHeader("fichas.valorus",countrybean.getTranslation("LossesUSD"))%></th>
<th rowspan=2 nowrap><%=outSortHeader("fichas.valorloc",countrybean.getTranslation("LossesLocal"))%></th>
<th rowspan=2 nowrap><%=outSortHeader("fichas.nescuelas",countrybean.getTranslation("Educationcenters"))%></th> 
<th rowspan=2 nowrap><%=outSortHeader("fichas.nhospitales",countrybean.getTranslation("Hospitals"))%></th>
<th rowspan=2 nowrap><%=outSortHeader("fichas.nhectareas",countrybean.getTranslation("Damagesincrops"))%></th>
<th rowspan=2 nowrap><%=outSortHeader("fichas.cabezas",countrybean.getTranslation("Catle"))%></th>
<th rowspan=2 nowrap><%=outSortHeader("fichas.kmvias",countrybean.getTranslation("Damagesinroads"))%></th>
<th rowspan=2 nowrap><%=outSortHeader("fichas.glide",countrybean.getTranslation("GLIDEnumber"))%></th>
<th  rowspan=2 align="center" nowrap width=350><%=countrybean.getTranslation("Comments")%></th>
<%
}
extension woExtension=new extension();
woExtension.dbType=countrybean.dbType;
woExtension.loadExtension(con,countrybean);
Dictionary dct = new Dictionary();
if (countrybean.bViewExtended)
{
   for (int ktab = 0; ktab < woExtension.vTabs.size(); ktab++)
    {
    extensiontabs tab = (extensiontabs) woExtension.vTabs.get(ktab);
	String sTabName=countrybean.getLocalOrEnglish(tab.svalue,tab.svalue_en);
    int nFields=0;
	for (int k = 0; k < woExtension.vFields.size(); k++)
	     {
		 dct = (Dictionary) woExtension.vFields.get(k);
	     if ((dct.tabnumber==ktab+1) || (dct.tabnumber==0 && ktab==woExtension.vTabs.size()-1))
		     nFields++;
		 }
	if (nFields>0)
	   out.print("<th colspan="+nFields+">"+sTabName+"</th>");
    }
  out.print("</tr><tr class=\"bodydarklight\">");
   for (int ktab = 0; ktab < woExtension.vTabs.size(); ktab++)
    {
	  for (int k = 0; k < woExtension.vFields.size(); k++)
	     {
		 dct = (Dictionary) woExtension.vFields.get(k);
	     if ((dct.tabnumber==ktab+1) || (dct.tabnumber==0 && ktab==woExtension.vTabs.size()-1))
			out.print("<th nowrap>"+outSortHeader(dct.nombre_campo,countrybean.getLocalOrEnglish(dct.label_campo,dct.label_campo_en))+"</th>");
		 }
	}
}
else  {
%></tr><tr style="height:1"><%
	}
%>
</tr>
<%
String sSerial; 
sSql="select fichas.clave " +
     countrybean.getWhereSql(countrybean.nApproved,sqlparams)+" order by " +countrybean.getSortbySql();
	 
out.println("<!--  "+countrybean.not_null_safe(sSql)+" -->"); 
try
	{
	pstmt=con.prepareStatement(sSql,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	for (int k=0; k<sqlparams.size(); k++)
				pstmt.setString(k+1, (String)sqlparams.get(k));
	rset=pstmt.executeQuery();
	}
catch (Exception e)
{
out.println("<br><br><strong>ERROR: there has been an error executing your query: </strong>: "+e.toString()+"<br><br><br>");
}
nStart=htmlServer.extendedParseInt(request.getParameter("nStart"));
try
{
if (nStart>1)
  rset.absolute(nStart);
}
catch (Exception e)
{
out.println("<!-- absolute: "+e.toString()+" -->");
}
nHits=0;
boolean bLight=false;
String sBgClass="bodylight";
double dNum=0;
int iNum=0;
try
{
   while (rset!=null && rset.next() && nHits++<countrybean.nMaxhits)
		{
		int nClave=rset.getInt("clave");
		woExtension.clave_ext=nClave;
		
		// allocate empty objects
		fichas woFicha=new fichas();
		woFicha.dbType=countrybean.country.dbType;  
		eventos woHazard=new eventos();
		woHazard.dbType=countrybean.country.dbType;  
		lev0 woLev0=new lev0();
		woLev0.dbType=countrybean.country.dbType;  
		lev1 woLev1=new lev1();
		woLev1.dbType=countrybean.country.dbType;  
		lev2 woLev2=new lev2();
		woLev2.dbType=countrybean.country.dbType;  
		causas woCause=new causas();
		woCause.dbType=countrybean.country.dbType; 

		woFicha.clave=nClave;
		woFicha.getWebObject(con);
		// get the relate tables info
		woLev0.lev0_cod=woFicha.level0;
		woLev0.getWebObject(con);
		woLev1.lev1_cod=woFicha.level1;
		woLev1.getWebObject(con);
		woLev2.lev2_cod=woFicha.level2;
		woLev2.getWebObject(con);
		woCause.causa=woFicha.causa;
		woLev2.getWebObject(con);
		woHazard.nombre=woFicha.evento;
		woHazard.getWebObject(con);
				
		sSerial=woFicha.serial;

		
		
		if (bLight)
		  sBgClass="'bodymedlight'";
		else
		  sBgClass="'bodylight'";
		bLight=!bLight;
		
		int nRecordExt=woExtension.getWebObject(con);
		
		%>
        <tr class=<%=sBgClass%> align="right"> 
		<td nowrap  align="left"><a class=linkText href='showdatacard.jsp?clave=<%=nClave%>&nStart=<%=nStart%><%=sCountryCodeParameter%>'>
			<%=sSerial%></a>
			<%=nRecordExt==0?"<div class='warning'><strong>*</strong></div>":""%>
		</td>
		<td  nowrap><%=countrybean.getLocalOrEnglish(woHazard.nombre,woHazard.nombre_en)%></td>
		<td  nowrap>&nbsp;<%=countrybean.getLocalOrEnglish(woLev0.lev0_name,woLev0.lev0_name_en)%></td>
		<td  nowrap>&nbsp;<%=countrybean.getLocalOrEnglish(woLev1.lev1_name,woLev1.lev1_name_en)%></td>
		<td  nowrap>&nbsp;<%=countrybean.getLocalOrEnglish(woLev2.lev2_name,woLev2.lev2_name_en)%></td>
		<td><%=countrybean.sFormatDate(Integer.toString(woFicha.fechano),Integer.toString(woFicha.fechames),Integer.toString(woFicha.fechadia))%></td>

<% if (countrybean.bViewStandard)
{%>
		<td  nowrap align="left">&nbsp;<%=htmlServer.not_null(woFicha.lugar)%>&nbsp;</td>
		<td><inv:check2 number='<%=woFicha.muertos%>'  value='<%=woFicha.hay_muertos%>'/></td>
		<td><inv:check2 number='<%=woFicha.heridos%>'  value='<%=woFicha.hay_heridos%>'/></td>
		<td><inv:check2 number='<%=woFicha.desaparece%>'  value='<%=woFicha.hay_deasparece%>'/></td>
		<td><inv:check2 number='<%=woFicha.vivdest%>'  value='<%=woFicha.hay_vivdest%>'/></td>
		<td><inv:check2 number='<%=woFicha.vivafec%>'  value='<%=woFicha.hay_vivafec%>'/></td>
		<td><inv:check2 number='<%=woFicha.damnificados%>'  value='<%=woFicha.hay_damnificados%>'/></td>
		<td><inv:check2 number='<%=woFicha.afectados%>'  value='<%=woFicha.hay_afectados%>'/></td>
		<td><inv:check2 number='<%=woFicha.reubicados%>'  value='<%=woFicha.hay_reubicados%>'/></td>
		<td><inv:check2 number='<%=woFicha.evacuados%>'  value='<%=woFicha.hay_evacuados%>'/></td>
		<td><%=webObject.formatDouble(woFicha.valorus)%></td>
		<td><%=webObject.formatDouble(woFicha.valorloc)%></td>
		<td><inv:check2 number='<%=woFicha.nescuelas%>'  value='<%=woFicha.educacion%>'/></td>
		<td><inv:check2 number='<%=woFicha.nhospitales%>'  value='<%=woFicha.salud%>'/></td>
		<td><inv:check2 number='<%=woFicha.nhectareas%>'  value='<%=woFicha.agropecuario%>'/></td>
		<td><%=woFicha.cabezas%> </td>
		<td><inv:check2 number='<%=woFicha.kmvias%>'  value='<%=woFicha.transporte%>'/></td>
     	<td><%=htmlServer.not_null(woFicha.glide)%>&nbsp;</td>

<%
String sComments=woFicha.di_comments;

if (sComments.length()>150)
   {
	sAllComments+="sTip"+nClave+"='"+EncodeUtil.jsEncode("<table><tr><td>"+sComments+"</td></tr></table>")+"';\n";
   int pos=149;
   while (pos>140 && sComments.charAt(pos)!=' ') pos--;
   sComments=sComments.substring(0,pos)+"<a  onmouseover='Tip(sTip"+nClave+")' onmouseout='UnTip()' href='showdatacard.jsp?clave="+nClave+"&nStart="+nStart+"'>&nbsp;[...]</a>";
   }
%>
		<td  align="left" width=350><%=sComments%>&nbsp;</td>
<%}
if (countrybean.bViewExtended)
{
  for (int ktab = 0; ktab < woExtension.vTabs.size(); ktab++)
    {
	  for (int k = 0; k < woExtension.vFields.size(); k++)
	     {
		 dct = (Dictionary) woExtension.vFields.get(k);
	 	 dct.countrybean=countrybean;
	     if ((dct.tabnumber==ktab+1) || (dct.tabnumber==0 && ktab==woExtension.vTabs.size()-1))
            {
			%><td><%=dct.getFieldValue()%>&nbsp;</td><%
			}
		 }
	} /* for each field */
} // if extension fields%>
</tr>
<%      } // while rset.next()
}
catch (Exception e)
{
out.println("<!-- MAIN  loop: "+e.toString()+" -->");
}

%>
</table> 
<%
out.println(sLinks);
try	{rset.close(); }catch (Exception e){out.println("<!-- closing r:"+e.toString()+" -->");}	
try	{pstmt.close();}catch (Exception e){out.println("<!-- closing ps:"+e.toString()+" -->");}	
dbCon.close();
%>
<%@ include file="/html/footer.html" %>
<script language="JavaScript">
<%=sAllComments%>
</script>

</body>
</html>
