<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>DesInventar on-line - DBaseField selection</title>
</head>
<%@ page info="DesConsultar geocode server" session="true" %>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.dbase.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%@ include file="/util/opendatabase.jspf" %>
<%
boolean bIEBrowser = (request.getHeader("User-Agent").indexOf("MSIE")>0);
boolean bIEdge = (request.getHeader("User-Agent").indexOf("Edge")>0);
int retCode = 0; // return code from account object methods
String sShapefileName=countrybean.not_null(request.getParameter("filename"));
String sSelectedField=countrybean.not_null(request.getParameter("selected"));
int k=countrybean.extendedParseInt(request.getParameter("level"));
String sReturn="";
int pos=sShapefileName.lastIndexOf("/");
DBase db =null;
		   
try{
	String sDbaseDir=sShapefileName.substring(0,pos);
	int pos2=sShapefileName.lastIndexOf(".");
	String sDbaseTable=sShapefileName.substring(pos+1,pos2);
	db = new DBase(sDbaseDir);
	db.setMemoHandler(DBase.DBASEIII);
	String [] column = null;
	char [] coltypes = null;
	try
		{
		db.openTable(sDbaseTable);
		column = db.getColumnNames();
		coltypes = db.getColumnTypes();
		for (int j=0; j<column.length; j++)
		   sReturn+="<option value='"+column[j]+"'"+countrybean.strSelected(sSelectedField.equalsIgnoreCase(column[j]))+">"+column[j]+"</option>";
		}
	catch (Throwable te)
		{
		out.println("ERROR READING TABLE: <strong><font size=\"+1\">"+ sDbaseTable+"</font></strong><br><br>Please keep in mind current DBASE driver cannot process names with ACCENTS (αινσϊρ...)"+te.toString());
		}
%>
<script language="JavaScript">
function selectPath()
	{
	
<% if (!bIEBrowser) { %>

		     opener.processFieldRequest(document.getElementById("DBfields").options[document.getElementById("DBfields").selectedIndex].value);
			 this.close();
			 parent.close();
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
 <select name="DBfields" id="DBfields" style="WIDTH: 250px;" size="15">
 <%=sReturn%>
 </select>

</tr> 
<tr><td height="3"></td></tr>
<tr><td class="bgDark" height="1"></td></tr>
<tr><td class="body" width="100%">
<input type="button" name="okbtn" value="<%=countrybean.getTranslation("Save")%>" onClick="selectPath()">&nbsp;&nbsp;
<input type="button" name="okbtn" value="<%=countrybean.getTranslation("Cancel")%>" onClick="cancelPath()">
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
		while (db.next() && nRecs++<100)
		{
			out.println("<tr><td>"+nRecs+"</td>");
			nRecs++;
			for (int i = 0; i < column.length; i++)
			{
			  String sCell="";
			  try
			  {
			    sCell=db.getString(column[i]);
			  }
			catch (Exception edbf)
			  {
			  // System.out.println("DBF ERR:"+edbf.toString()+ "  COL=" +column[i]);
			  }  
			  if (coltypes[i]=='N')
					{
					if (sCell.endsWith(".0"))
					    sCell=sCell.substring(0,sCell.length()-2);
					out.print("<td align='right'>"+ sCell+ "</td>");
					}
				else
					out.print("<td>"+ sCell + "</td>");
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
  if (db!=null)
  	db.closeTable();	
}
%>
</body>
</html>

