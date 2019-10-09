<%@ page info="DesConsultar generator results page" session="true" %><%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import="java.text.*"%><%@ page import="org.lared.desinventar.util.*" %><%@ page import="org.lared.desinventar.webobject.*" %><%@ page import="org.apache.poi.hssf.dev.*"%><%@ page import="org.apache.poi.hssf.model.*"%><%@ page import="org.apache.poi.hssf.record.*"%><%@ page import="org.apache.poi.hssf.usermodel.*"%><%@ page import="org.apache.poi.hssf.util.*"%><%@ page import="org.apache.poi.util.StringUtil"%><%@ page contentType="text/html; charset=UTF-8" %><%@ page import="org.lared.desinventar.system.*" %><%
request.setCharacterEncoding("UTF-8"); 
// if this runs in an IFRAME under IE, this will allow cookies to stay...just magic!
((HttpServletResponse)response).addHeader("P3P", "CP=\"CAO PSA OUR\"");
((HttpServletResponse)response).addHeader("X-Frame-Options", "SAMEORIGIN");
%><jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" /><%@ include file="/util/opendatabase.jspf" %><%@ include file="/paramprocessor.jspf" %><%@ page import="java.util.ArrayList"%><%  
	/*************************
	At first, when the UTF-8 Excel required

	@page language="java" pageEncoding="utf8" contentType="application/vnd.ms-excel; charset=UTF-8"

	at the top of page, then this leads to alter code in /paramprocessor.jspf and /util/opendatabase.jspf by
	ommiting the "pageEncoding" becuase of the duplication. The weire thing is; after finiish coding then I try to go back for checking out one more time. There is no longer required for a above statement anymore. Then everthing suppose to be back to normal.

	:) Tom.

	**************************/
//Static/Init that will be used
String strSheetName = "DI Statistics";
String strDummy = "";
int rowNum = 1;
short colWidth = (short) ((25*8) /((double) 1/20));

// create a new workbook
HSSFWorkbook workBook = new HSSFWorkbook();
//create a new worksheet
HSSFSheet sheet = workBook.createSheet(); 
//declare a row object reference
HSSFRow row = null;
//declare a cell object reference
HSSFCell cell = null;
//create stype and create Bold font style
HSSFCellStyle cellHeaderStyle = workBook.createCellStyle();
HSSFFont fBold = workBook.createFont();
fBold.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
cellHeaderStyle.setFont(fBold);
cellHeaderStyle.setBorderBottom(cellHeaderStyle.BORDER_THIN);
workBook.setSheetName(0, strSheetName);
extension woExtension=new extension();
woExtension.dbType=countrybean.dbType;
woExtension.loadExtension(con,countrybean);

boolean bReportFormat=false;   // (request.getParameter("reportFormat")!=null);
String sSql=""; 
int j=0;  
ArrayList sqlparams=new ArrayList();
PreparedStatement pstmt=null;

sSql=countrybean.getStatSql(sqlparams);
try	{
	String ants[]= new String[countrybean.nStatLevels];
	String sFechanoFechames="(fechano*100+fechames) as year_month";
	String sFecha="(fechano*10000+fechames*100+fechadia) as DateYMD";

	//CREATE row 0 FOR HEADER
	row = sheet.createRow(rowNum);
	rowNum++; //prepare for next row
    short col=0; 
	for (j=0; j< countrybean.nStatLevels; j++) 
	{
		ants[j]="";
		cell = row.createCell(col);
		cell.setCellStyle(cellHeaderStyle);	
		sheet.setColumnWidth(col, colWidth);
		if (countrybean.asStatLevels[j].startsWith("lev0_name") || 
			countrybean.asStatLevels[j].startsWith("lev1_name") ||
			countrybean.asStatLevels[j].startsWith("lev2_name")){
			//Add cell for header row
			cell.setCellValue(countrybean.asLevels[Integer.parseInt(countrybean.asStatLevels[j].substring(3,4))]);
			//Add cell for code
			col++;
			cell = row.createCell( (short) col);
			cell.setCellStyle(cellHeaderStyle);	
			sheet.setColumnWidth(col, colWidth);
			cell.setCellValue(countrybean.getTranslation("Code"));
		}
		else if (countrybean.asStatLevels[j].equals(sFechanoFechames)) {
				//Add cell for header row
				cell.setCellValue(countrybean.getTranslation("Year")+" - "+countrybean.getTranslation("Month"));
		}
		else {
				//Add cell for header row
				cell.setCellValue(countrybean.getColumnTitle(countrybean.asStatLevels[j]));
		}
		col++;
	} //end for

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
		System.out.println(e.toString());
		}	
	/// gets the metadata of the resultset
	ResultSetMetaData meta = rset.getMetaData();
	int nCols=meta.getColumnCount();
	for (j=col+1; j<=nCols; j++) {
		sSql=meta.getColumnName(j);
		//Add cell for header row
		strDummy = countrybean.getColumnTitle(sSql).toString();
		cell = row.createCell( (short) (j-1)); //Cell has shift, please verify
		cell.setCellValue(strDummy);
		cell.setCellStyle(cellHeaderStyle);
		sheet.setColumnWidth((short) (j-1), colWidth);
	}

	//HEADER row END
	
	NumberFormat f = NumberFormat.getInstance();
	f.setMaximumFractionDigits(2);
	f.setGroupingUsed(bReportFormat);
	while (rset.next() && rowNum<32000)
		{
		//CREATE row FOR RESULT SET
		row = sheet.createRow(rowNum);
		rowNum++; //prepare for next row
		col=1;
		for (j=0; j< countrybean.nStatLevels; j++)
  			{
			String sCell=htmlServer.not_null(rset.getString(col)).trim();
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
			//Add cell for result row
			cell = row.createCell((short)(col-1));
			if (sSql.startsWith("extension."))
				cell.setCellValue(woExtension.getValue(sSql.substring(10),htmlServer.not_null(sCell)));
			else{
				cell.setCellValue(sCell);
			}
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
				cell = row.createCell((short)(col-1));
				cell.setCellValue(sCell);
				}
			col++;
			}
	    for (j=col; j<=nCols; j++)
			{
            double nVal=rset.getDouble(j);
			//Add cell for result row
			cell = row.createCell( (short) (j-1)); //why cell shift up ??
			if (nVal!=0.0)
				cell.setCellValue(nVal);
			}
		}

//CREATE row FOR Total
row = sheet.createRow(rowNum);
rowNum++; //prepare for next row
//Add cell for TOTAL row
cell = row.createCell((short) 0);
cell.setCellValue("TOTAL");


sSql="SELECT " + countrybean.getVariableList(true)+ countrybean.getWhereSql(sqlparams);
//sSql=sSql.substring(0,sSql.indexOf("group by"));
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
//col=countrybean.nStatLevels; 
meta = rset.getMetaData();
nCols=meta.getColumnCount();
if (rset.next())
	{
    for (j=1; j<=nCols; j++)
		{
        double nVal=rset.getDouble(j);
		cell = row.createCell((short) (j+col-2));
		if (nVal>0)
			cell.setCellValue(nVal);
		}
	}

try	{rset.close(); }catch (Exception e){out.println("<!-- closing r:"+e.toString()+" -->");}	
try	{pstmt.close();}catch (Exception e){out.println("<!-- closing ps:"+e.toString()+" -->");}	
}
catch (Exception exst) {
	System.out.println(exst.toString());
}
//out.println("");
dbCon.close();

//prepare excel and then write binary to response.
try {
	ByteArrayOutputStream outStream =new ByteArrayOutputStream();
	workBook.write(outStream);
	//response.reset();
	String sTime=String.valueOf(Calendar.getInstance().get(Calendar.MINUTE)+Calendar.getInstance().get(Calendar.HOUR)*100);

    response.reset();
    OutputStream excel = response.getOutputStream();
	response.setHeader("Content-disposition", "attachment;filename=DI_Stat"+sTime+".xls");
	response.setHeader("Content-Type", "application/vnd.ms-excel; charset=utf-8");
	excel.write(outStream.toByteArray());
	excel.close();

//	out.write(outStream.toByteArray());

	} 
catch (FileNotFoundException fne) 
	{
		System.out.println("File not found...");
	} 
catch (Exception ioe) {
	System.out.println("Other Exception..." + ioe.toString());
}

try {
out.clear(); // where out is a JspWriter
out = pageContext.pushBody();
	}
catch (Exception ioe) 
	{
	}

try {
	response.getOutputStream().flush();
    response.getOutputStream().close();
	}
catch (Exception ioe) 
	{
	System.out.println("Exception flushing response caught..." + ioe.toString());
	}

%>