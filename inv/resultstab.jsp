<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<%@ page info="DesInventartar query results page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="woExtension" class="org.lared.desinventar.webobject.extension" scope="session" />
<%@ taglib uri="inventag.tld" prefix="inv" %>
<%
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
// checks for a session alive variable, or we have a new valid countrycode
if (countrybean.countrycode.length()==0)
	{%><jsp:forward page="/inv/index.jsp"/><%}%>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
 <title>DesInventar on-line : <%=countrybean.countryname%> <%=countrybean.getTranslation("EditData")%> Hi Sec</title>
<%!
String outSortHeader(String sVariable, String sTitle)
{
String sRet="<a href='javascript:sortby(\""+sVariable+"\")' class='blacklinks'>"+sTitle+"</a>&nbsp;";
sRet+="<a href='javascript:sortby(\""+sVariable+" desc\")' class='blacklinks'><img src='/DesInventar/images/arr_down.gif' border=0></a>";
return sRet;
}
%>

<link href="../html/desinventar.css" rel="stylesheet" type="text/css">
</head>
<%if (user.iusertype<1) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}%>
<%@ include file="/util/opendatabase.jspf" %>
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/iheader",countrybean.getLanguage(),out);%>
<%
ArrayList sqlparams=new ArrayList();
PreparedStatement pstmt=null;
// loads the datacard extension
woExtension.dbType=dbType;
woExtension.loadExtension(con,countrybean);
countrybean.getLevelsFromDB(con); 
countrybean.bHayVariables=false;
// loads viewing params
countrybean.processParams(request, new parser());
//stmt=con.createStatement();
String sSql="select count(*) as nhits "+countrybean.getWhereSql(countrybean.nApproved, sqlparams);
try
	{
	pstmt=con.prepareStatement(sSql);
	for (int k=0; k<sqlparams.size(); k++)
				pstmt.setString(k+1, (String)sqlparams.get(k));
	rset=pstmt.executeQuery();
	}
catch (Exception e){out.println("<!-- "+e.toString()+" -->");}
int nHits=0;
if (rset!=null && rset.next())
  nHits=rset.getInt("nhits");
int nStart=htmlServer.extendedParseInt(request.getParameter("nStart"));
int nPages=nHits/countrybean.nMaxhits;
if (nPages*countrybean.nMaxhits<nHits) nPages++;
String sLinks=htmlServer.putLinksToAllPages(nHits,  nStart, countrybean.nMaxhits,
"&nbsp;"+countrybean.getTranslation("Results")+": "+nHits +" "+countrybean.getTranslation("hits")+". "+nPages+" "+countrybean.getTranslation("Pages"), "linkText");
String sAllComments="";
String sLangSuffix="";
if ("EN".equals(countrybean.getDataLanguage()))
	sLangSuffix="_en";
%>
<%
int nTabActive=6; // 
String[] sTabNames={countrybean.getTranslation("Region"),countrybean.getTranslation("Geography"),countrybean.getTranslation("Events"),
           countrybean.getTranslation("Causes"),countrybean.getTranslation("Extension"),countrybean.getTranslation("Query"),
           countrybean.getTranslation("EditData"),countrybean.getTranslation("DataEntry"),countrybean.getTranslation("Admin"),
		   countrybean.getTranslation("Sendai"),countrybean.getTranslation("Security")};
String[] sTabIcons={"","","","","","","","","","",""};
String[] sTabLinks={"index.jsp","geographytab.jsp","eventab.jsp",
				"causetab.jsp","extendedtab.jsp","querytab.jsp",
				"resultstab.jsp","datacardtab.jsp","admintab.jsp",
				"sendaitab.jsp","securitytab.jsp"};
%>
<%@ include file="/util/tabs.jspf" %>
<!-- DI TOP OPEN -->
<table width="100%" border="1" class="pageBackground" rules="none" height="500"><tr><td align="left" valign="top">
<script language="JavaScript">
<!--
function submitForm(istart)
{
document.pagelinks.nStart.value=istart;
document.pagelinks.submit();
}

function sortby(locsort)
{
document.pagelinks.localsort.value=locsort;
document.pagelinks.submit();
}
// -->
</script>
<!-- Content goes after this comment -->

<table width="1000" border="0"> 
<tr><td align="center">
<font color="Blue"><%=countrybean.getTranslation("Region")%></font>
<b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font>
 - [<jsp:getProperty name ="countrybean" property="countrycode"/>]
</td>
</td><td nowrap=true align="right" valign="bottom">
<form name='pagelinks' action='resultstab.jsp' method='post'  style="margin-bottom:0;margin-top:0;">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<input type='hidden' name='nStart' value=''>
<input type='hidden' name='NoQuery' value='NoQuery'>
<INPUT type='hidden'  name="actiontab_" id="actiontab_">
<INPUT type='hidden'  name="frompage" value="<%=request.getServletPath()%>">
<input type='checkbox' name='viewStandard' value='Y' onClick="document.pagelinks.submit();" <%=countrybean.strChecked(countrybean.bViewStandard)%>><%=countrybean.getTranslation("Standard")%>&nbsp;
<input type='checkbox' name='viewExtended' value='Y' onClick="document.pagelinks.submit();" <%=countrybean.strChecked(countrybean.bViewExtended)%>><%=countrybean.getTranslation("Extension")%>&nbsp;&nbsp;
<INPUT type='hidden'  name="localsort" value="">
</form>
</td><td nowrap align="right" class="bss" align="right"><%=sLinks%></td></tr>
</table>
<table cellspacing="0" cellpadding="0" border="1" class='IE_Table_borders bss'>
<tr class="bodydarklight">
<th rowspan=2><img src="/DesInventar/images/edit_row.gif" alt="Edit datacard" border=0></th>
<th rowspan=2><img src="/DesInventar/images/delete_row.gif" alt="Delete datacard" border=0></th>
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
  out.print("</tr><tr>");
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

<% // Java declarations  
String sClave; 
String sSerial; 	 

sSql="select fichas.clave " +
     countrybean.getWhereSql(countrybean.nApproved,sqlparams)+" order by " +countrybean.getSortbySql();
	 
out.println("<!-- "+sSql+" -->");
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
	
try
{
	while (rset.next() && nHits++<countrybean.nMaxhits)
		{
		sClave=rset.getString("clave");
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

		woFicha.clave=woFicha.extendedParseInt(sClave);
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
		int approved=woFicha.approved;
		%>
        <tr class="bodylight<%=approved%>">
		<td>
		<%
		if (user.bHasAccess(countrybean.countrycode,0,woFicha.level0) && (woFicha.level1.length()==0 || user.bHasAccess(countrybean.countrycode,1,woFicha.level1)))
		{%>
            <a href= 'modifydatacard.jsp?clave=<%=sClave%>&serial=<%=sSerial%>&nStart=<%=nStart%>&start=<%=nStart+nHits%>&usrtkn=<%=countrybean.userHash%>''>
                <img src="/DesInventar/images/edit_row.gif" alt="Edit datacard" border=0></a>
            </td>
            <td>
            <a href= 'deletedatacard.jsp?clave=<%=sClave%>&serial=<%=sSerial%>&nStart=<%=nStart%>&usrtkn=<%=countrybean.userHash%>'>
                <img src="/DesInventar/images/delete_row.gif" alt="Delete datacard" border=0></a>
		<%}
        else
        {%>X</td>
		<td>
        <%}%>
		</td>
		<td  nowrap><%=sSerial%>		</td>
		<td  nowrap><%=countrybean.getLocalOrEnglish(woHazard.nombre,woHazard.nombre_en)%></td>
		<td  nowrap>&nbsp;<%=countrybean.getLocalOrEnglish(woLev0.lev0_name,woLev0.lev0_name_en)%></td>
		<td  nowrap>&nbsp;<%=countrybean.getLocalOrEnglish(woLev1.lev1_name,woLev1.lev1_name_en)%></td>
		<td  nowrap>&nbsp;<%=countrybean.getLocalOrEnglish(woLev2.lev2_name,woLev2.lev2_name_en)%></td>
		<td><%=countrybean.sFormatDate(Integer.toString(woFicha.fechano),Integer.toString(woFicha.fechames),Integer.toString(woFicha.fechadia))%></td>
<% if (countrybean.bViewStandard)
{%>
		<td  nowrap>&nbsp;<%=htmlServer.not_null(woFicha.lugar)%>&nbsp;</td>
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

sAllComments+="sTip"+sClave+"='"+EncodeUtil.jsEncode("<table><tr><td>"+sComments+"</td></tr></table>")+"';\n";
if (sComments.length()>70)
   {
   int pos=65;
   while (pos>50 && sComments.charAt(pos)!=' ') pos--;
   sComments=sComments.substring(0,pos)+"<a  onmouseover='Tip(sTip"+sClave+")' onmouseout='UnTip()' href='modifydatacard.jsp?clave="+sClave+"&serial="+sSerial+"&nStart="+nStart+"'>[...]</a>";
   }
   
%>
		<td  nowrap><%=sComments%>&nbsp;</td>
<%}
if (countrybean.bViewExtended)
{
  woExtension.clave_ext=woFicha.clave;
  woExtension.getWebObject(con);		
  for (int k = 0; k < woExtension.vFields.size(); k++)
     {
	 dct = (Dictionary) woExtension.vFields.get(k);
	 dct.countrybean=countrybean;
     %><td><%=dct.getFieldValue()%>&nbsp;</td><%
	} /* for each field */
  } // ix extension fields%>
 </tr>
<%      
 } // while rset.next()
}
catch (Exception e)
{
out.println("<!-- MAIN loop: "+e.toString()+" -->");
}

%>
</table>
<%
out.println(sLinks);
try	{rset.close(); }catch (Exception e){out.println("<!-- closing r:"+e.toString()+" -->");}	
try	{pstmt.close();}catch (Exception e){out.println("<!-- closing ps:"+e.toString()+" -->");}	
dbCon.close();
%>

<!-- Content goes before this comment -->
</td></tr></table>
<script language="JavaScript">
<%=sAllComments%>
</script>
<%@ include file="/html/ifooter.html" %>
</body>
</html>
