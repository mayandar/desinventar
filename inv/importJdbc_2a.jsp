<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<%@ page info="Reindex page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>

<%@ page import="org.apache.poi.hssf.usermodel.HSSFCell" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFRow" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFSheet" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFWorkbook" %>
<%@ page import="org.apache.poi.poifs.filesystem.POIFSFileSystem" %>


<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<%!

String sSelectExcel(String sOptions,String svar)
{

String ret=svar.toLowerCase();

ret="<select name='"+ret+"'>"+sOptions+"</select>";
return ret;
}

%>
<head>
<title>DesInventar on-line - <%=countrybean.getTranslation("ImportTABLE")%></title>
 </head>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%@ include file="/util/opendatabase.jspf" %>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>">


<form method="post" action="importJdbc_3.jsp" name="desinventar">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<table width="580" border="0">
<tr><td align="center">
<font color="Blue"><%=countrybean.getTranslation("Region")%></font>
<b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font>
 - [<jsp:getProperty name ="countrybean" property="countrycode"/>]
</td></tr>
</table>
<table width="100%" border="1">
<tr>
<td colspan=4  valign="top" nowrap><div class="subtitle"><%=countrybean.getTranslation("SelectMappingForVariables")%></div></td>
</tr>
<tr><td height="20" width='60%'><%=countrybean.getTranslation("Cell_Content")%></td>
	<td width='20%'><%=countrybean.getTranslation("Create")%> &nbsp; <input type="Button" name="createall" value="<%=countrybean.getTranslation("All")%>" onClick="createAll()"></td>
	<td width='20%'><%=countrybean.getTranslation("FieldType")%></td>

</tr>	
<%
String database,firstrow,startrow,sheetnumber;
database=countrybean.not_null(request.getParameter("tablename"));
int nLastCol=0;

    Enumeration e;
    String sRequestParams ="";
	String sSep="?";
	for (e = request.getParameterNames(); e.hasMoreElements(); )
    {
      String param = (String) e.nextElement();
      out.println("<input type='hidden' name='"+param+"' value='"+(request.getParameter(param)==null?"":request.getParameter(param))+"'>");
	  sSep="&";
    }

try{
	stmt=con.createStatement();
	rset=stmt.executeQuery("select * from "+database);
	/// gets the metadata of the resultset
	ResultSetMetaData meta = rset.getMetaData();
	nLastCol=meta.getColumnCount();
	%><input type='hidden' name='maxcols' value='<%=nLastCol%>'><%
    for (int j=1; j<=nLastCol; j++)
			{
				try{
					String sCellContent=meta.getColumnName(j);
					// get the DesInventar closest Type.
					int nType=meta.getColumnType(j);
					int nCurrentFieldType=0;
					int nCurrentFieldSize=30;			
					switch (nType)
						 {
						   case Types.CLOB:							   	
						   case 1111: // type reported by Oracle for BLOB types...
						   case -1: // type reported by ACCESS for MEMO types...
						   case Types.BLOB:
							 nCurrentFieldType=5;
							 nCurrentFieldSize=16;			  
						     break;
						   case Types.DATE:
							 nCurrentFieldType=4;
							 nCurrentFieldSize=16;			  
							 break;
						   case Types.DECIMAL:
						   case Types.DOUBLE:
						   case Types.FLOAT:
						   case Types.REAL:
						   case Types.NUMERIC:
							 nCurrentFieldType=2;
							 nCurrentFieldSize=8;
							 if (meta.isCurrency(j) || meta.getPrecision(j)==2)
								 nCurrentFieldType=3;
							 break;
						   case Types.SMALLINT:
						   case Types.INTEGER:
						   case Types.BIGINT:
						   case Types.TINYINT:
							 nCurrentFieldType=1;
							 nCurrentFieldSize=4;			  
						     break;
						   case Types.VARCHAR:
							 nCurrentFieldType=0;
							 nCurrentFieldSize=meta.getColumnDisplaySize(j);			  
						     break;
					    }

%><tr><td><%=sCellContent%><input type='hidden' name='namecol<%=j%>' value='<%=EncodeUtil.htmlEncode(sCellContent)%>'></td> 
											<td>
											 <input type='checkbox' name='chkcol<%=j%>' value="Y"></td><td>									     
											 <select name='field_type<%=j%>'>
											 <option value=0<%=countrybean.strSelected(0,nCurrentFieldType)%>>Text
											 <option value=1<%=countrybean.strSelected(1,nCurrentFieldType)%>>Integer
											 <option value=2<%=countrybean.strSelected(2,nCurrentFieldType)%>>Floating point
											 <option value=3<%=countrybean.strSelected(3,nCurrentFieldType)%>>Currency
											 <option value=4<%=countrybean.strSelected(4,nCurrentFieldType)%>>Date
											 <option value=5<%=countrybean.strSelected(5,nCurrentFieldType)%>>Memo
											 </select>
											 <input type='hidden' name='field_size<%=j%>' value='<%=nCurrentFieldSize%>'>
											 </td><td>
	
											 </td></tr>
		    		  <%
				}
				catch (Exception ex){
				}
		    }
	}
catch (Exception ex2)
	{
	out.println("ERROR: exception loading..="+ex2.toString());
	}
finally
	{
	rset.close();
	stmt.close();
	}
%>


<tr>
  <td></td>
  <td colspan=3><br><br><INPUT type='submit' size='50' maxlength='50' name='continue'  VALUE='<%=countrybean.getTranslation("Continue")%>'> </td>		 
</tr>
<tr>
  <td colspan="4"><br><br><font class=warning><%=countrybean.getTranslation("ImportExcelNotice")%></font></td>		 
</tr>
</table>
</form>
<script language="JavaScript">
<!-- 
function setReturnFolder(newFolder)
{
 if (newFolder)
  document.desinventar.filename.value=newFolder;
}

function createAll()
{
for (kCol=1; kCol<=<%=nLastCol%>; kCol++)
	{
	document.getElementById("chkcol"+kCol).checked=true
	}
}
// -->
</script>
</body>
</html>

<% dbCon.close(); %>
