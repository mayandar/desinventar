<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head> 
<title>DesConsultar on-line Report</title>
</head>
<%@ page info="DesConsultar generator results page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%@ include file="/util/opendatabase.jspf" %> 
<%@ include file="/paramprocessor.jspf" %>
<%!


NumberFormat f = NumberFormat.getInstance();

String sReportString(double nVal)
{ 
    f.setMaximumFractionDigits(2);
    f.setGroupingUsed(true);
	String sNumber=f.format(nVal);
	if (sNumber.endsWith(".0"))
  	    sNumber=sNumber.substring(0,sNumber.length()-2);
	return sNumber;
}
%>
<%	
ArrayList sqlparams=new ArrayList();
PreparedStatement pstmt=null;
String sSql, sSqlCopy;  
int j=0;
sSql=countrybean.getSql(true, sqlparams);
sSqlCopy=new String(sSql);
//System.out.println("SQL="+sSql);
int pos=sSql.indexOf("from");
sSql="select sum(1) as nhits "+sSqlCopy.substring(pos);
pos=sSql.indexOf("order by");
if (pos>0) sSql=sSql.substring(0,pos);

try
	{
	pstmt=con.prepareStatement(sSql);
	for (int k=0; k<sqlparams.size(); k++)
				pstmt.setString(k+1, (String)sqlparams.get(k));
	rset=pstmt.executeQuery();
	}
catch (Exception e)
	{
	System.out.println("[DI9]"+e.toString());
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
sSql=sSqlCopy;
extension woExtension=new extension();
woExtension.dbType=countrybean.dbType;
woExtension.loadExtension(con,countrybean);
boolean bLight=false;
//out.println("<!-- "+sSql+" -->");
%>
 <%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/header",countrybean.getLanguage(),out);%>

<%
int nTabActive=6; // reports
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
<table border="0"  width="1024" class="pageBackground">
<form name='desinventar' action='report.jsp' method='post'>
<input type='hidden' name='nStart' value=''>
<INPUT type='hidden'  name="actiontab" id="actiontab">
<INPUT type='hidden'  name="frompage" value="<%=request.getServletPath()%>">
<INPUT type='hidden'  name="localsort" value="">
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

<tr>
  <td align="left" nowrap>
  <font color="Blue"><%=countrybean.getTranslation("Region")%>: </font><a href="javascript:routeTo('main.jsp')"><font class='regionlink'>
  <b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font></a> - [<jsp:getProperty name ="countrybean" property="countrycode"/>]
</td><td nowrap  align="center">
<span class="subTitle"><%=countrybean.getTranslation("GeneratedReport")%></span>
</td><td nowrap align="right">
<%=sLinks%></td><td nowrap><% if (nHits<32000){%>
<a href="report_excel.jsp" class='linkText'><%=countrybean.getTranslation("getitasExcel")%>
</a><%}%>
 <a href="report_spreadsheet.jsp" class='linkText'><%=countrybean.getTranslation("CSV")%></a>
 <!-- <a href="report_spreadsheet.jsp?format=TXT" class='linkText'><%=countrybean.getTranslation("TXT")%></a> -->
 <!-- <a href="report_spreadsheet.jsp?format=XML" class='linkText'><%=countrybean.getTranslation("XML")%></a> -->
 </td>
</tr>
</table>
<table cellspacing="0" cellpadding="0"  class="IE_Table_borders bss">
<tr class="bodydarklight">
<%
out.print("<th nowrap><a href='javascript:sortby(\"fichas.serial\")' class='blacklinks'>"+countrybean.getTranslation("Serial")+"</a>&nbsp;");
out.print("<a href='javascript:sortby(\"fichas.serial desc\")' class='blacklinks'><img src='/DesInventar/images/arr_down.gif' border=0></a></th>");
%>
<%

	try
		{
		pstmt=con.prepareStatement(sSql,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		for (int k=0; k<sqlparams.size(); k++)
					pstmt.setString(k+1, (String)sqlparams.get(k));
		rset=pstmt.executeQuery();
		}
	catch (Exception e)
		{
		System.out.println(e.toString());
		}	
	// gets the metadata of the resultset
	ResultSetMetaData meta = rset.getMetaData();
	int[] nDataType= new int[countrybean.asVariables.length]; 
	for (int k = 1;k <= meta.getColumnCount(); k++)
		{
		// search by field name
		String sCol = meta.getColumnName(k).toUpperCase();
		if (sCol.startsWith("C0L"))
			{
			sCol=sCol.substring(5);
			nDataType[countrybean.extendedParseInt(sCol)]= meta.getColumnType(k);
			}
		}

    for (j=0; j< countrybean.asVariables.length; j++)
  		{
		String sVar=countrybean.sExtractVariable(countrybean.asVariables[j]);
		if (countrybean.getTranslation("DateYMD").equals(countrybean.getVartitle(countrybean.asVariables[j])))
		 	sVar="fechano,fechames,fechadia";
		out.print("<th nowrap "+(sVar.startsWith("di_comments")?"width='300'":"")+"><a href='javascript:sortby(\""+sVar+"\")' class='blacklinks'>"+htmlServer.htmlEncode(countrybean.getVartitle(countrybean.asVariables[j]))+"</a>&nbsp;");
		if (countrybean.getTranslation("DateYMD").equals(countrybean.getVartitle(countrybean.asVariables[j])))
		 	sVar="fechano desc,fechames desc,fechadia";
		out.print("<a href='javascript:sortby(\""+sVar+" desc\")' class='blacklinks'><img src='/DesInventar/images/arr_down.gif' border=0></a></th>");
		}
 %>
    </tr>
<tr><td colspan="<%=countrybean.asVariables.length+2%>" height="1" bgcolor="#000000"></td></tr>        
<%
String sBgClass="";
try
	{
	if (rset!=null && nStart>1)
  		rset.absolute(nStart);
	nHits=0;   
	while (rset!=null && rset.next() && nHits++<countrybean.nMaxhits)
	  try
		{
		 if (bLight)
			  sBgClass=" class='bodymedlight'";
		    else
			  sBgClass=" class='bodylight'";
		    bLight=!bLight;
		out.print("<tr"+sBgClass+">");
		try{sSql=htmlServer.htmlEncode(rset.getString("fichas.serial"));}
		catch (Exception nser)
		  {
			try{
				sSql=htmlServer.htmlEncode(rset.getString("serial"));
			   }
			catch (Exception nser2){} 
		  } 
		%>
       <td nowrap valign="top"><a href='showdatacard.jsp?clave=<%=rset.getString("clave")%>'><%=sSql%></a> </td>
		<%
		for (j=0; j<countrybean.asVariables.length; j++)
		  try
			{
			String sRealVar="C0L__"+j;
			sSql=countrybean.sExtractVariable(countrybean.asVariables[j]);
			if (sSql.startsWith("extension."))
			 	{
				    switch (nDataType[j])
				      {
				        case Types.DATE:
				   				  out.println("<td nowrap>"+htmlServer.htmlEncode(woExtension.strDate(rset.getString(sRealVar)))+"&nbsp;</td>");
						          break;
				        case Types.DECIMAL:
				        case Types.DOUBLE:
				        case Types.FLOAT:
				        case Types.NUMERIC:
				        case Types.REAL:
									double dV=rset.getDouble(sRealVar);
						            out.println("<td align=\"right\" nowrap>"+(dV!=0.0?sReportString(rset.getDouble(sRealVar)):"")+"&nbsp;</td>");
				          		    break;
				        case Types.SMALLINT:
				        case Types.INTEGER:
				        case Types.TINYINT:
					    case Types.BIGINT:
						          int nValue=rset.getInt(sRealVar);
								  String sCell=woExtension.getValue(sSql.substring(10),String.valueOf(nValue));
						          if (woExtension.extendedParseInt(sCell)==nValue)
				   				  		out.println("<td align=\"right\" nowrap>"+(nValue==0?"":sCell)+"&nbsp;</td>");
									else
				   				  		out.println("<td align=\"right\" nowrap>"+sCell+"&nbsp;</td>");
								  break;
						default:
				   				  out.println("<td>"+htmlServer.htmlEncode(rset.getString(sRealVar))+"&nbsp;</td>");
				      }
				}
			  else
			    if (sSql.startsWith("di_comments")) 
			     	out.println("<td width='300'>"+htmlServer.htmlEncode(woExtension.getClob(rset,sRealVar))+"&nbsp;</td>");
			    else
					{
				    switch (nDataType[j])
				      {
				        case Types.DATE:
				   				  out.println("<td nowrap>"+htmlServer.htmlEncode(woExtension.strDate(rset.getString(sRealVar)))+"&nbsp;</td>");
						          break;
				        case Types.DECIMAL:
				        case Types.DOUBLE:
				        case Types.FLOAT:
				        case Types.NUMERIC:
				        case Types.REAL:
				        case Types.SMALLINT:
				        case Types.INTEGER:
				        case Types.TINYINT:
					    case Types.BIGINT:
									double dV=rset.getDouble(sRealVar);
						            out.println("<td align=\"right\" nowrap>"+(dV!=0.0?sReportString(rset.getDouble(sRealVar)):"")+"&nbsp;</td>");
								  break;
						default:
				   				  out.println("<td>"+htmlServer.htmlEncode(rset.getString(sRealVar))+"&nbsp;</td>");
				      }
					}
			}
		 catch (Exception colnotfound)
		    {
				   out.println("<td><!-- Not found:"+sSql+" --> </td>");
			}	
      	out.println("</tr>");
		}
	 catch (Exception ex)
	    {
	   	out.println("<!-- Exception found:"+ex.toString()+" --> </td>");
		}	
	}
 catch (Exception ex)
    {
	out.println("<!-- Exception found:"+ex.toString()+" --> </td>");
	}	
		
	%>
</table> 
<%=sLinks%>
<%
try	{rset.close(); }catch (Exception e){out.println("<!-- closing r:"+e.toString()+" -->");}	
try	{pstmt.close();}catch (Exception e){out.println("<!-- closing ps:"+e.toString()+" -->");}	
dbCon.close();
%>
<%@ include file="/html/footer.html" %>
</body>
</html>
