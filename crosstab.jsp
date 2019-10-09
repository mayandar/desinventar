<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>DesConsultar on-line - Statistics</title>
 </head>
<%@ page info="DesConsultar simple results page" session="true" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%@ include file="/util/opendatabase.jspf" %>
<%@ include file="/paramprocessor.jspf" %>
<%!

String sFechanoFechames="(fechano*100+fechames) as year_month";
String sFecha="(fechano*10000+fechames*100+fechadia) as DateYMD";

int  outputHeader(JspWriter out, int j, DICountry countrybean, boolean bWithAdditionalCodeColumn)
{
int col=3;
if  (bWithAdditionalCodeColumn)
	col=4;
try
  {
        String sSpan="<th nowrap>";
		if (bWithAdditionalCodeColumn && j==1)
		   sSpan="<th nowrap colspan='2'>";
  		if ( (countrybean.asStatLevels[j].startsWith("lev0_name"))
		    ||(countrybean.asStatLevels[j].startsWith("lev1_name"))
		    ||(countrybean.asStatLevels[j].startsWith("lev2_name")) )
		   		{
				out.print(sSpan+htmlServer.htmlEncode(countrybean.asLevels[Integer.parseInt(countrybean.asStatLevels[j].substring(3,4))])+"&nbsp;</th>");
				if (j==0)
					out.print("<th>"+countrybean.getTranslation("Code")+"</th>");
				}
			else if (countrybean.asStatLevels[j].equals(sFechanoFechames))
	   			{
				out.print(sSpan+countrybean.getTranslation("Year")+" - "+countrybean.getTranslation("Month")+"&nbsp;</th>");
				}
		    else
	   			{
				out.print(sSpan+htmlServer.htmlEncode(countrybean.getColumnTitle(countrybean.asStatLevels[j]))+"&nbsp;</th>");
				}
	}
catch (Exception eout)
	{
	}

return col;
}
%>
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/header",countrybean.getLanguage(),out);%> 
<%
int nTabActive=8; // crosstab stats
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

<table width="100%" class="pageBackground">
<tr><td align="center">
<font  class='ltbluelg'><%=countrybean.getTranslation("StatisticsGeneratedFor")%></font><a href="javascript:routeTo('main.jsp')"><font class='regionlink'>
<b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font></a>
 - [<jsp:getProperty name ="countrybean" property="countrycode"/>]
</td><td nowrap>
 <a href="crosstab_excel.jsp" class='linkText'><%=countrybean.getTranslation("getitasExcel")%></a>
<!--  <a href="stats_spreadsheet.jsp" class='linkText'><%=countrybean.getTranslation("CSV")%></a>
 --> </td></tr>
</table>

<table cellpadding="2" border="1" class="IE_Table bss">
<%
boolean bReportFormat=(request.getParameter("reportFormat")!=null);
String sSql=""; 
int j=0;  
extension woExtension=new extension();
woExtension.dbType=countrybean.dbType;
woExtension.loadExtension(con,countrybean);

ArrayList vHorizontal=new ArrayList();
String sTemp=countrybean.asStatLevels[0];
String sTemp2=countrybean.asStatLevels[1];
countrybean.asStatLevels[0]=countrybean.asStatLevels[1];
countrybean.asStatLevels[1]="";
countrybean.nStatLevels=1;
ArrayList sqlparams=new ArrayList();
PreparedStatement pstmt=null;
sSql=countrybean.getCrosstabSql(sqlparams);
	%><!--ncols= <%=sSql%> -->
	<%
try	{
	pstmt=con.prepareStatement(sSql);
	for (int k=0; k<sqlparams.size(); k++)
				pstmt.setString(k+1, (String)sqlparams.get(k));
	rset=pstmt.executeQuery();
	while (rset.next())
		vHorizontal.add(htmlServer.htmlEncode(rset.getString(1)).trim());			
	}
catch (Exception exst)
	{
	%><!-- <%=exst.toString()%> -->
	<%
	}
int nHorizontal=vHorizontal.size();
countrybean.asStatLevels[0]=sTemp;
countrybean.asStatLevels[1]=sTemp2;
countrybean.nStatLevels=2;
sSql=countrybean.getCrosstabSql(sqlparams);
try
	{
%>
    <tr class="bodydarklight">
<%	
	boolean bWithAdditionalCodeColumn=( countrybean.asStatLevels[0].startsWith("lev0_name")
				 					  ||countrybean.asStatLevels[0].startsWith("lev1_name")
				 					  ||countrybean.asStatLevels[0].startsWith("lev2_name") );
	int col=outputHeader(out, 1, countrybean, bWithAdditionalCodeColumn);
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

	pstmt=con.prepareStatement(sSql);
	for (int k=0; k<sqlparams.size(); k++)
				pstmt.setString(k+1, (String)sqlparams.get(k));
	rset=pstmt.executeQuery();

	/// gets the metadata of the resultset
	ResultSetMetaData meta = rset.getMetaData();
	int nCols=meta.getColumnCount();
	double totals[]= new double[nHorizontal*(nCols-col+1)+3];
	totals[0]=0;
	String sCell="";
	for (int k=0; k<nHorizontal; k++)
		{
		sCell=(String)vHorizontal.get(k);
		if (sCell.length()==0)
		 sCell="-";
		sSql=countrybean.sExtractVariable(countrybean.asStatLevels[1]);
		if (countrybean.asStatLevels[1].equals(sFechanoFechames))
		           {
				   sCell+="000000";
				   sCell= sCell.substring(0,4)+"/"+sCell.substring(4,6);
				   }
		if (sSql.startsWith("extension."))
					sCell=woExtension.getValue(sSql.substring(10),htmlServer.not_null(sCell));
		out.print("<th colspan=\""+(nCols-col+1)+"\">"+htmlServer.htmlEncode(sCell)+"</th>");
		}
    %></tr><tr class="bodydarklight">
	<%
	outputHeader(out, 0, countrybean, bWithAdditionalCodeColumn);
	int iColIndex=1;
	for (int k=0; k<nHorizontal; k++)
	  for (j=col; j<=nCols; j++)
  		{
		totals[k+j-col+1]=0;
		sSql=meta.getColumnName(j);
		out.print("<th>"+htmlServer.htmlEncode(countrybean.getColumnTitle(sSql))+"</th>");
		}
    %></tr><%
	NumberFormat f = NumberFormat.getInstance();
	f.setMaximumFractionDigits(2);
	f.setGroupingUsed(bReportFormat);
	String sLastRowId="@@--#";
	int iRowIndex=0;
	int iRow=0;
	boolean bLight=false;
	String sBgClass="bss bodylight";
	while (rset.next())
		{
		sCell=htmlServer.htmlEncode(rset.getString(1)).trim();
		sSql=countrybean.sExtractVariable(countrybean.asStatLevels[0]);
		if (countrybean.asStatLevels[0].equals(sFechanoFechames))
		           {
				   sCell+="000000";
				   sCell=sCell.substring(0,4)+"/"+sCell.substring(4,6);
				   }
			else if (countrybean.asStatLevels[0].equals(sFecha))
		           {
				   sCell+="00000000";
				   sCell=sCell.substring(0,4)+"/"+sCell.substring(4,6)+"/"+sCell.substring(6,8);
				   }
			else if (sSql.startsWith("extension."))
					sCell=sCell.length()==0?"-":woExtension.getValue(sSql.substring(10),sCell);
		String sRowId=sCell;
		if  (bWithAdditionalCodeColumn)
			sRowId=htmlServer.not_null(rset.getString(2)).trim();
		if (!sLastRowId.equals(sRowId))
			{
			if (iRow>0)
				{
				for (int k=iRowIndex; k<nHorizontal; k++)
				     for (j=col; j<=nCols; j++)
						out.print("<td>&nbsp;</td>");
				out.println("</tr>");
				}
			if (bLight)
			  sBgClass="'bss bodymedlight'";
			else
			  sBgClass="'bss bodylight'";
			bLight=!bLight;

		  	out.print("<tr class="+sBgClass+">");
			out.print("<td nowrap>"+sCell+"</td>");
			if  (bWithAdditionalCodeColumn)
				out.print("<td>"+sRowId+"</td>");
		  	sLastRowId=sRowId;
			iRowIndex=0;
			iColIndex=0;
			iRow++;
			}
		// fills empty columns !!
		sCell=htmlServer.not_null(rset.getString(col-1)).trim();
		while (iRowIndex<nHorizontal && !sCell.equals((String)vHorizontal.get(iRowIndex)))
		     {
	    	 for (j=col; j<=nCols; j++)
				{
				out.print("<td>&nbsp;</td>");
				iColIndex++;
				}
			 iRowIndex++;
			 }
	    for (j=col; j<=nCols; j++)
			{
            double nVal=rset.getDouble(j);
			totals[iColIndex]+=nVal;
			iColIndex++;
			String sNumber=f.format(nVal);
			if (sNumber.endsWith(".0"))
	  		    sNumber=sNumber.substring(0,sNumber.length()-2);
			out.print("<td align='right'>"+sNumber+"</td>");
			}
		iRowIndex++;
		}
	for (int k=iRowIndex; k<nHorizontal; k++)
	     for (j=col; j<=nCols; j++)
			out.print("<td>&nbsp;</td>");
	String sColspanBot="";
	if  (bWithAdditionalCodeColumn)
	    sColspanBot=" colspan=2";
	out.println("</tr><tr class=\"bodydarklight\"><td "+sColspanBot+"><strong>"+countrybean.getTranslation("TOTAL")+"</strong></td>");
	for (j=0; j<nHorizontal*(nCols-col+1); j++)
		{
		boolean bOutput=true;
/*		sSql=meta.getColumnName(j);
		for (int k=0; k<countrybean.asVariables.length; k++)
			{
			String sTitSql=countrybean.getVartitle(countrybean.asVariables[k]);
			// only sum columns are rolled up - they make sense
			if (!sSql.equals(sTitSql)) // this must be divided by #datacards, not always available: || sSql.equals(countrybean.getTranslation("AverageOf")+" "+sTitSql))
			   bOutput=false;
			}
*/
		if (bOutput)
			{
			String sNumber=f.format(totals[j]);
			if (sNumber.endsWith(".0"))
			  sNumber=sNumber.substring(0,sNumber.length()-2);
			out.print("<td align='right'><strong>"+sNumber+"</strong></td>");
			}
		else
			out.print("<td align='right'>&nbsp;</td>");
		}
	rset.close();
	pstmt.close();
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
</form>

<%@ include file="/html/footer.html" %>
</body>
</html>
