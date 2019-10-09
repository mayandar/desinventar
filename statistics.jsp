<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>DesConsultar on-line - Statistics</title>
<link href="html/desinventar.css" rel="stylesheet" type="text/css">
</head>
<%@ page info="DesConsultar simple results page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%@ include file="/util/opendatabase.jspf" %>
<%@ include file="/paramprocessor.jspf" %>
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/header",countrybean.getLanguage(),out);%> 
<%
int nTabActive=5; // stats
String[]  sTabNames={countrybean.getTranslation("Profile"),countrybean.getTranslation("Query"),countrybean.getTranslation("ViewData"),countrybean.getTranslation("ViewMap"),
           countrybean.getTranslation("Charts"),countrybean.getTranslation("Statistics"),countrybean.getTranslation("Reports"),
		   countrybean.getTranslation("Thematic"), countrybean.getTranslation("Crosstab")};
String[] sTabIcons={"check.gif","icon_query.gif","icon_viewdata.gif","icon_viewmap.gif","icon_charts.gif","icon_statistics.gif",
                    "icon_reports.gif","icon_thematic.gif","xtab.gif"};
String[] sTabLinks={"javascript:routeTo('profiletab.jsp')","javascript:routeTo('main.jsp')","javascript:routeTo('results.jsp')","javascript:routeTo('maps.jsp')",
				"javascript:routeTo('graphics.jsp')","javascript:routeTo('definestats.jsp')","javascript:routeTo('generator.jsp')",
				"javascript:routeTo('thematic_def.jsp')","javascript:routeTo('definextab.jsp')"};
%>
<%
ArrayList sqlparams=new ArrayList();
PreparedStatement pstmt=null;
boolean bReportFormat=(request.getParameter("reportFormat")!=null);
String sLocalSort=countrybean.not_null(request.getParameter("localsort"));
String sSql=""; 
int j=0;  
sSql=countrybean.getStatSql(sqlparams);
int pos=sSql.indexOf("order by");
if (pos>0) sSql=sSql.substring(0,pos);

sSql="select count(*) as nhits from ("+sSql+") q";
try
	{
	pstmt=con.prepareStatement(sSql);
	for (int k=0; k<sqlparams.size(); k++)
				pstmt.setString(k+1, (String)sqlparams.get(k));
	rset=pstmt.executeQuery();
	}
catch (Exception e)
	{
	System.out.println(e.toString());
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
sSql=countrybean.getStatSql(sqlparams);
if (sLocalSort.length()>0)
   {
   pos=sSql.indexOf("order by ");
   sSql="select * from ("+sSql.substring(0,pos)+") q order by "+sLocalSort;
   }
extension woExtension=new extension();
woExtension.dbType=countrybean.dbType;
woExtension.loadExtension(con,countrybean);
try
	{%>
<!-- SQL=<%=sSql%> -->
<script language="JavaScript">
function sortby(locsort)
{
document.desinventar.localsort.value=locsort;
document.desinventar.submit();
}
</script>
<%@ include file="/util/tabs.jspf" %>
<table width="1000"  class="pageBackground">
<tr><td align="center">
<font  class='ltbluelg'><%=countrybean.getTranslation("StatisticsGeneratedFor")%></font><a href="javascript:routeTo('main.jsp')"><font class='regionlink'>
<b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font></a>
 - [<jsp:getProperty name ="countrybean" property="countrycode"/>]
</td><td nowrap align="right">
<%=sLinks%></td><td>&nbsp;&nbsp;<a href="stats_excel.jsp" class='linkText'><%=countrybean.getTranslation("getitasExcel")%></a>&nbsp;&nbsp;|&nbsp; <a href="stats_spreadsheet.jsp" class='linkText'><%=countrybean.getTranslation("CSV")%></a></td></tr>
</table>

<table cellspacing="1" cellpadding="1" border="0" width="100%" class="pageBackground"><tr><td>
<table cellspacing="0" cellpadding="2" border="1"  class="IE_Table bs">
    <tr class="bodydarklight">
<%	
	String ants[]= new String[countrybean.nStatLevels+1];
	String sFechanoFechames="(fechano*100+fechames) as year_month";
	String sFecha="(fechano*10000+fechames*100+fechadia) as DateYMD";
	int col=countrybean.nStatLevels; 
	for (j=0; j< countrybean.nStatLevels; j++)
  		{
		ants[j]="";
		if (  (countrybean.asStatLevels[j].startsWith("lev0_name"))
		    ||(countrybean.asStatLevels[j].startsWith("lev1_name"))
		    ||(countrybean.asStatLevels[j].startsWith("lev2_name")) )
		   		{
				out.print("<th nowrap><a href='javascript:sortby(\""+htmlServer.htmlEncode(countrybean.asStatLevels[j])+" desc\")' class='blacklinks'>"+htmlServer.htmlEncode(countrybean.asLevels[Integer.parseInt(countrybean.asStatLevels[j].substring(3,4))])+"</a>&nbsp;");
				out.print("<a href='javascript:sortby(\""+countrybean.asStatLevels[j]+"\")' class='blacklinks'><img src='/DesInventar/images/arr_up.gif' border=0></a></th>");
				out.print("<th>"+countrybean.getTranslation("Code")+"</th>");
				col++;
				}
			else if (countrybean.asStatLevels[j].equals(sFechanoFechames))
	   			{
				out.print("<th nowrap><a href='javascript:sortby(\"year_month desc\")' class='blacklinks'>"+countrybean.getTranslation("Year")+" - "+countrybean.getTranslation("Month")+"</a>&nbsp;");
				out.print("<a href='javascript:sortby(\"year_month\")' class='blacklinks'><img src='/DesInventar/images/arr_up.gif' border=0></a></th>");
				}
			else if (countrybean.asStatLevels[j].equals(sFecha))
	   			{
				out.print("<th nowrap><a href='javascript:sortby(\"DateYMD desc\")' class='blacklinks'>"+countrybean.getTranslation("Date")+"</a>&nbsp;");
				out.print("<a href='javascript:sortby(\"DateYMD\")' class='blacklinks'><img src='/DesInventar/images/arr_up.gif' border=0></a></th>");
				}
		    else
	   			{
				String sSortVar=countrybean.asStatLevels[j];
				if (sSortVar.indexOf(".")>0)
				  sSortVar=sSortVar.substring(sSortVar.indexOf(".")+1);
				out.print("<th nowrap><a href='javascript:sortby(\""+sSortVar+" desc\")' class='blacklinks'>"+htmlServer.htmlEncode(countrybean.getColumnTitle(countrybean.asStatLevels[j]))+"</a>&nbsp;");
				out.print("<a href='javascript:sortby(\""+sSortVar+"\")' class='blacklinks'><img src='/DesInventar/images/arr_up.gif' border=0></a></th>");
				}
		}
	int nColsPerVar=0;
	if (countrybean.bSum)
		nColsPerVar++;
	if (countrybean.bAvg)
		nColsPerVar++;
	if (countrybean.bMax)
		nColsPerVar++;
	if (countrybean.bVar)
		nColsPerVar++;
	if (countrybean.bStd)
		nColsPerVar++;
	
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
	/// gets the metadata of the resultset
	ResultSetMetaData meta = rset.getMetaData();
	int nCols=meta.getColumnCount();
	for (j=col+1; j<=nCols; j++)
  		{
		sSql=meta.getColumnName(j);
		out.print("<th nowrap><a href='javascript:sortby(\""+sSql+" desc\")' class='blacklinks'>"+htmlServer.htmlEncode(countrybean.getColumnTitle(sSql))+"</a>&nbsp;");
		out.print("<a href='javascript:sortby(\""+sSql+"\")' class='blacklinks'><img src='/DesInventar/images/arr_up.gif' border=0></a></th>");
		}
    %></tr><%
	NumberFormat f = NumberFormat.getInstance();
	f.setMaximumFractionDigits(2);
	f.setGroupingUsed(true);
    
	// This is faster but can only be used with problematic settings in ACCESS and with issues with Unicode charsets: rset.absolute(nStart);
	// slow but safe.
	for (int jk=0; jk<nStart; jk++)
	      rset.next(); 
	nHits=0;  // start page count 
	boolean bLight=false;
	String sBgClass="bss bodylight";

	while (rset.next() && nHits++<countrybean.nMaxhits)
		{
		if (bLight)
		  sBgClass="'bs bodymedlight'";
		else
		  sBgClass="'bs bodylight'";
		bLight=!bLight;

		out.print("<tr class="+sBgClass+">");
		col=1;
		for (j=0; j<countrybean.nStatLevels; j++)
  			{
			String sCell=htmlServer.htmlEncode(rset.getString(col));
			sSql=countrybean.sExtractVariable(countrybean.asStatLevels[j]);
			if (countrybean.asStatLevels[j].equals(sFechanoFechames))
		           {
				   sCell+="000000";
				   sCell= sCell.substring(0,4)+"/"+sCell.substring(4,6);
				   }
			else if (countrybean.asStatLevels[j].equals(sFecha))
		           {
				   sCell+="00000000";
				   sCell= sCell.substring(0,4)+"/"+sCell.substring(4,6)+"/"+sCell.substring(6,8);
				   }
			if (sSql.startsWith("extension."))
					out.print("<td nowrap align='right'>"+(sCell.length()==0?"-":woExtension.getValue(sSql.substring(10),htmlServer.not_null(sCell)))+"&nbsp;</td>");
				else		
					out.print("<td nowrap align='left'>"+sCell+"&nbsp;</td>");
			if (!sCell.equals(ants[j]))
				{
				ants[j]=sCell;
				}
			else
				if (bReportFormat)
					sCell="";
			if (sSql.startsWith("lev0_name") || 
				sSql.startsWith("lev1_name") ||
				sSql.startsWith("lev2_name"))
				{
				col++;
				sCell=htmlServer.not_null(rset.getString(col));
				out.print("<td>&nbsp;"+sCell+"&nbsp;</td>");
				}
			col++;
			}
	    for (j=col; j<=nCols; j++)
			{
            double nVal=rset.getDouble(j);
			String sNumber=nVal==0.0?"":countrybean.formatDouble(nVal,-4); //f.format(nVal);
			if (sNumber.endsWith(".0"))
	  		    sNumber=sNumber.substring(0,sNumber.length()-2);
			out.print("<td align='right'>"+sNumber+"</td>");
			}
      	out.println("</tr>");
		}


sSql="SELECT " + countrybean.getVariableList(true)+ countrybean.getWhereSql(sqlparams);
out.print("<!-- SQL tot="+sSql+" -->");
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
//col=countrybean.nStatLevels; 
meta = rset.getMetaData();
nCols=meta.getColumnCount();
if (rset.next())
	{
	out.print("<tr class=\"bodydarklight\"><td colspan="+(col-1)+"><strong>"+countrybean.getTranslation("TOTAL")+"</strong></td>");
    for (j=1; j<=nCols; j++)
		{
        double nVal=rset.getDouble(j);
		String sNumber=f.format(nVal);
		if (sNumber.endsWith(".0"))
  		    sNumber=sNumber.substring(0,sNumber.length()-2);
		out.print("<td align='right'>"+sNumber+"</td>");
		}
	}
try	{rset.close(); }catch (Exception e){out.println("<!-- closing r:"+e.toString()+" -->");}	
try	{pstmt.close();}catch (Exception e){out.println("<!-- closing ps:"+e.toString()+" -->");}	
}
catch (Exception exst)
{
%><!-- <%=exst.toString()%> --><%
}
 out.println("</tr>");
 dbCon.close();
%>

</table>
<form name="desinventar" method=post action="statistics.jsp" onSubmit="return allSelected(1)">
<INPUT type='hidden'  name="actiontab" id="actiontab">
<INPUT type='hidden'  name="frompage" value="<%=request.getServletPath()%>">
<INPUT type='hidden'  name="localsort" value="<%=sLocalSort%>">
<input type='hidden' name='nStart' value=''>
</form>

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

</td></tr></table>

<%@ include file="/html/footer.html" %>
</body>
</html>
