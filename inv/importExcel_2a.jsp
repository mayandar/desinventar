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
<title>DesInventar on-line - <%=countrybean.getTranslation("ImportEXCEL")%></title>
 </head>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%if (user.iusertype<20) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}%>
<%@ include file="/util/opendatabase.jspf" %>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>">

<form method="post" action="importExcel_3.jsp" name="desinventar">
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
<td colspan=5  valign="top" nowrap><div class="subtitle"><%=countrybean.getTranslation("SelectMappingForVariables")%></div></td>
</tr>
<tr><td height="20" width='60%'><%=countrybean.getTranslation("Cell_Content")%></td>
	<td width='20%'><%=countrybean.getTranslation("Create")%> &nbsp; <input type="Button" name="createall" value="<%=countrybean.getTranslation("All")%>" onClick="createAll()"></td>
	<td width='20%'><%=countrybean.getTranslation("FieldType")%></td>
	<td width='20%'><%=countrybean.getTranslation("Length")%></td>
</tr>	
<%
String database,firstrow,startrow,sheetnumber;
database=countrybean.not_null(request.getParameter("filename"));
firstrow=countrybean.not_null(request.getParameter("firstrow"));
startrow=countrybean.not_null(request.getParameter("startrow"));
sheetnumber=countrybean.not_null(request.getParameter("sheetnumber"));
int nLastCol=40;
int nStartRow=countrybean.extendedParseInt(startrow);
    Enumeration e;
	for (e = request.getParameterNames(); e.hasMoreElements(); )
    {
      String param = (String) e.nextElement();
      if (request.getParameter(param)!=null)
	  	out.println("<input type='hidden' name='"+param+"' value='"+request.getParameter(param)+"'>");
    }

InputStream inp=null;
try{
	inp = new FileInputStream(database);
	
	HSSFWorkbook wb = new HSSFWorkbook(new POIFSFileSystem(inp));
	HSSFSheet sheet=wb.getSheetAt(countrybean.extendedParseInt(sheetnumber));
	HSSFRow row=sheet.getRow(countrybean.extendedParseInt(firstrow));
	nLastCol=row.getLastCellNum();
	
	int[] sizes=new int[nLastCol+1];
	int nLastRow=sheet.getLastRowNum();
	for (int jRow=nStartRow; jRow<=nLastRow; jRow++)
 		{
		HSSFRow anyrow=sheet.getRow(jRow);
		for (short kCol=0; kCol<nLastCol; kCol++)
			{
				try{
					HSSFCell cell = anyrow.getCell(kCol);
			    	if (cell!=null)
			    		{
			    		if (cell.getCellType()==HSSFCell.CELL_TYPE_STRING)
			    			{
			    			sizes[kCol]=Math.max(sizes[kCol],Math.min(255,cell.getStringCellValue().length()+5));
			    			//debug(cell.getStringCellValue()+" | ");
			    			}
						}
					else
						sizes[kCol]=Math.max(sizes[kCol],8);	
					}
				catch (Exception e2)
					{
					}
			}
		}	
	
	%><input type='hidden' name='maxcols' value='<%=nLastCol%>'><%
	for (short kCol=0; kCol<nLastCol; kCol++)
			{
				try{
					HSSFCell cell = row.getCell(kCol);
			    	String sCellContent="column_"+kCol;
					if (cell!=null)
			    		sCellContent=cell.getStringCellValue();
%>	<tr><td><%=sCellContent%><input type='hidden' name='namecol<%=kCol%>' value='<%=EncodeUtil.htmlEncode(sCellContent)%>'></td> 
											<td><input type='checkbox' name='chkcol<%=kCol%>' value="Y"></td>
											<td>									     
											  <select name='field_type<%=kCol%>'>
											 <option value=0>Text<%=sizes[kCol]>8?" selected":""%>
											 <option value=1>Integer
											 <option value=2<%=sizes[kCol]>8?"":" selected"%>>Floating point
											 <option value=4>Date
											 <option value=5>Memo
                                             <option value=6>Yes/No
											 </select>
											 </td>
											 <td>
											 <input name='col_width<%=kCol%>' value='<%=sizes[kCol]%>' size='5' maxlength='5'>
											 </td>
									</tr>
		    		  <%
				}
				catch (Exception ex){
				}
		    }
	}
catch (Exception ex2)
	{
	out.println("[DI9] ERROR: exception loading(2a)..="+ex2.toString());
	}

try {inp.close();} catch (Exception ei){};

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
for (kCol=0; kCol<<%=nLastCol%>; kCol++)
	{
	document.getElementById("chkcol"+kCol).checked=true
	}
}
// -->
</script>
</body>
</html>

<% dbCon.close(); %>
