<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>DesInventar on-line - DBaseField selection</title>
</head>
<%@ page info="DesConsultar geocode server" session="true" %>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%@ include file="/util/opendatabase.jspf" %>
<%
boolean bIEBrowser = (request.getHeader("User-Agent").indexOf("MSIE")>0);
boolean bIEdge = (request.getHeader("User-Agent").indexOf("Edge")>0);
final int Types_Oracle_Date = 93; // this is what oracle returns instead of
                                      // Types.Date
final int Types_Oracle_CLOB = 1111; // this is what oracle returns instead
                                        // of Types.CLOB?

int retCode = 0; // return code from account object methods
String sDbaseTable=countrybean.not_null(request.getParameter("filename"));
String sSelectedField=countrybean.not_null(request.getParameter("selected"));
int k=countrybean.extendedParseInt(request.getParameter("level"));
String sReturn="";

ResultSetMetaData rsMeta=null; // SQL metadata of the resultset

stmt=con.createStatement();		   
try{
	rset=stmt.executeQuery("select * from  " + sDbaseTable);
	rsMeta = rset.getMetaData();
	String [] column = new String[rsMeta.getColumnCount()]; 
	int [] coltypes = new int[rsMeta.getColumnCount()];
	for (int j=0; j<column.length; j++)
	   {
	   column[j]=rsMeta.getColumnName(j+1).toLowerCase();
	   coltypes[j]=rsMeta.getColumnType(j+1);
	   sReturn+="<option value='"+column[j]+"'"+countrybean.strSelected(sSelectedField.equalsIgnoreCase(column[j]))+">"+column[j]+"</option>";
	   }
%><!-- <%= sReturn%> -->
<script language="JavaScript">
function selectPath()
	{
	
<% if (!bIEBrowser) { %>
		     document.opener.processFieldRequest(window.desinventar.DBfields.options[window.desinventar.DBfields.selectedIndex].value);
			window.close();
	<%}%>	

		window.returnValue = window.desinventar.DBfields.options[window.desinventar.DBfields.selectedIndex].value;
		window.close();
	}
	
function cancelPath()
	{
	this.close();
	
	//	window.close();
    }

</script>
 <body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
<form method="get" action="none" name="desinventar">
<table width="100%" height="100%" cellpadding="0" cellspacing="0" >
<tr><td class="bgDark" width="100%" align="left">
 <select name="DBfields" style="WIDTH: 250px;" size="15">
 <%=sReturn%>
 </select>

</tr> 
<tr><td height="3"></td></tr>
<tr><td class="bgDark" height="1"></td></tr>
<tr><td class="body" width="100%">
<input type="button" name="okbtn" value="<%=countrybean.getTranslation("Save")%>" onclick="selectPath()">&nbsp;&nbsp;
<input type="button" name="okbtn" value="<%=countrybean.getTranslation("Cancel")%>" onclick="cancelPath()">
 </td></tr>
<tr><td class="bgDark" height="1"></td></tr>
<tr><td class="bgDark" width="100%">
<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="1">
<tr><th>#</th>
<%
	for (int j=0; j<column.length; j++)
	   out.print("<th>"+column[j]+"</th>");
%>
</tr>
<%
        int nRecs=0;
		while (rset.next() && nRecs++<100)
		{
			out.println("<tr><td>"+nRecs+"</td>");
			nRecs++;
			for (int i = 0; i < column.length; i++)
              switch (coltypes[i])
	            {
	              case Types.DATE:
	              case Types_Oracle_Date:
						out.print("<td align='right'>"+ countrybean.strDate(countrybean.not_null(rset.getString(column[i]))) + "</td>");
	                break;
	              case Types.DOUBLE:
	              case Types.FLOAT:
	              case Types.REAL:
						out.print("<td align='right'>"+ countrybean.formatDouble(rset.getDouble(column[i]),-2) + "</td>");
	                break;
	              case Types.BIGINT:
						out.print("<td align='right'>"+ rset.getLong(column[i]) + "</td>");
						break;
	              case Types.SMALLINT:
	              case Types.INTEGER:
	              case Types.TINYINT:
						out.print("<td align='right'>"+ rset.getInt(column[i]) + "</td>");
	                break;
	              default:
						out.print("<td align='left'>"+ countrybean.not_null(rset.getString(column[i])) + "</td>");
	                break;
	            }
		out.println("</tr>");
		}
%>
</table>
</td></tr>
</table>
<br>
<br>
 </form>
<%
	}
catch (Exception e)
	{
	out.println("</td></tr></table></td></tr></table><!-- Error reading DBASE:"+e.toString()+" -->");
	}
finally
{
  	rset.close();	
  	stmt.close();	
}
%>
</body>
</html>

