<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<%@ page info="Reindex page" session="true" %>
<%@ page import="java.io.*"%>
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
<head>
<title>DesInventar on-line - <%=countrybean.getTranslation("ImportEXCEL")%></title>
 </head>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>">
<table width="100%" border="1" bgcolor="white">
<%
String database,firstrow,startrow,sheetnumber;
database=countrybean.not_null(request.getParameter("filename"));
firstrow=countrybean.not_null(request.getParameter("firstrow"));
startrow=countrybean.not_null(request.getParameter("startrow"));
sheetnumber=countrybean.not_null(request.getParameter("sheetnumber"));
// opens the excel spreadsheet
InputStream inp = new FileInputStream(database);
if (inp!=null)
	{
	HSSFWorkbook wb;
	HSSFSheet sheet;
	try
		{
		wb = new HSSFWorkbook(new POIFSFileSystem(inp));
		sheet=wb.getSheetAt(countrybean.extendedParseInt(sheetnumber));
		if (wb!=null && sheet!=null)
			{
			HSSFCell cell = null;
			HSSFRow row=null;
			String sCellContent="";
			
			for (int j=0; j<10; j++)
				{
				row=sheet.getRow(j);
				if (row!=null)
					{
					int nLastCol=row.getLastCellNum();
					out.print("<tr><td bgcolor=\"silver\">"+j+"</td>");
					for (short kCol=0; kCol<nLastCol; kCol++)
							{
							try{
								cell = row.getCell(kCol);
								if (cell!=null)
						    		if (cell.getCellType()==HSSFCell.CELL_TYPE_STRING)
						    			{
						    			sCellContent=cell.getStringCellValue();
						    			}
							    	else
							   			{
						    			sCellContent=String.valueOf(cell.getNumericCellValue());
							    		if (sCellContent.endsWith(".0"))
							    			sCellContent=sCellContent.substring(0,sCellContent.length()-2);
							   			}
									else
									sCellContent="&nbsp;";	
								}
							catch (Exception ex)
								{
								sCellContent="&nbsp;";
								}
							out.print("<td>"+sCellContent+"</td>");
					    	}
						}
				out.println("</tr>");
				}
			}
		}
	catch (Exception eex)
	{
	}	
	inp.close();
	}
%>
</table>
</body>
</html>
