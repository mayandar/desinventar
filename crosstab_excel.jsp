<%@ page info="DesConsultar generator results page" session="true" %><%@ page import="java.io.*"%><%@ page import="java.sql.*"%><%@ page import="java.text.*"%><%@ page import="java.util.*"%><%@ page import="org.lared.desinventar.webobject.*" %><%@ page import="org.lared.desinventar.util.*" %><%@ page import="org.apache.poi.hssf.dev.*"%><%@ page import="org.apache.poi.hssf.model.*"%><%@ page import="org.apache.poi.hssf.record.*"%><%@ page import="org.apache.poi.hssf.usermodel.*"%><%@ page import="org.apache.poi.hssf.util.*"%><%@ page import="org.apache.poi.util.StringUtil"%><%@ page import="java.util.ArrayList"%><jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" /><%!
String sFechanoFechames="(fechano*100+fechames) as year_month";
String sFecha="(fechano*10000+fechames*100+fechadia) as DateYMD";

void outputHeader(HSSFCell cell, int j, DICountry countrybean)
{
try
  {
	if (countrybean.asStatLevels[j].startsWith("lev0_name") || 
		countrybean.asStatLevels[j].startsWith("lev1_name") ||
		countrybean.asStatLevels[j].startsWith("lev2_name")){
			//Add cell for header row
			cell.setCellValue(countrybean.asLevels[Integer.parseInt(countrybean.asStatLevels[j].substring(3,4))]);
		}
   else if (countrybean.asStatLevels[j].equals(sFechanoFechames)) 
   		{
				cell.setCellValue(countrybean.getTranslation("Year")+"/"+countrybean.getTranslation("Month"));
		}
	else{
				cell.setCellValue(countrybean.getColumnTitle(countrybean.asStatLevels[j]));
		}
	}
catch (Exception eout)
	{
	}
}
%><%@ include file="/util/opendatabase.jspf" %><%@ include file="/paramprocessor.jspf" %><% 
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
int rowNum = 0;
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
cellHeaderStyle.setAlignment((short)2);  // XSSFCellStyle.ALIGN_CENTER);
cellHeaderStyle.setWrapText(true);
HSSFFont fBold = workBook.createFont();
fBold.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
cellHeaderStyle.setFont(fBold);

boolean bReportFormat=false;   // (request.getParameter("reportFormat")!=null);
String sSql=""; 
int j=0;  
stmt=con.createStatement ();
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
try	{
	pstmt=con.prepareStatement(sSql);
	for (int k=0; k<sqlparams.size(); k++)
				pstmt.setString(k+1, (String)sqlparams.get(k));
	rset=pstmt.executeQuery();
	while (rset.next())
		vHorizontal.add(htmlServer.not_null(rset.getString(1)).trim());			
	}
catch (Exception exst)
	{
	// exst.toString(); ??
	}
int nHorizontal=vHorizontal.size();
countrybean.asStatLevels[0]=sTemp;
countrybean.asStatLevels[1]=sTemp2;
countrybean.nStatLevels=2;
sSql=countrybean.getCrosstabSql(sqlparams);
try
	{
	j=0;
	//CREATE row 0 FOR HEADER
	row = sheet.createRow(rowNum);
	rowNum++; //prepare for next row
	//Add cell for header row
	cell = row.createCell( (short) j);
	cell.setCellStyle(cellHeaderStyle);
	outputHeader(cell, 1, countrybean);
	sheet.setColumnWidth((short) j, colWidth);
	int col=3; 
	boolean bWithAdditionalCodeColumn=( countrybean.asStatLevels[0].startsWith("lev0_name")
				 					  ||countrybean.asStatLevels[0].startsWith("lev1_name")
				 					  ||countrybean.asStatLevels[0].startsWith("lev2_name") );
	if  (bWithAdditionalCodeColumn)
		col=4;
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
	int iColIndex=1;
	if (col==4)
		iColIndex=2;
	sSql=countrybean.sExtractVariable(countrybean.asStatLevels[1]);		
	for (int k=0; k<nHorizontal; k++)
		{
		int iStartIndex=iColIndex;
		sCell=(String)vHorizontal.get(k);
		if (countrybean.asStatLevels[1].equals(sFechanoFechames))
		           {
				   sCell+="000000";
				   sCell=sCell.substring(0,4)+"/"+sCell.substring(4,6);
				   }
		if (sSql.startsWith("extension."))
				sCell=woExtension.getValue(sSql.substring(10),htmlServer.not_null(sCell));
		cell = row.createCell( (short) (iColIndex)); 
		cell.setCellValue(sCell);
		cell.setCellStyle(cellHeaderStyle);
		//colWidth=(short)(countrybean.getColumnTitle(sSql).length()*1000);
		sheet.setColumnWidth((short) (iColIndex), colWidth);
		iColIndex++;
		for (j=col+1; j<=nCols; j++)
	  		{
			cell = row.createCell( (short) (iColIndex)); 
			cell.setCellStyle(cellHeaderStyle);
			iColIndex++;
			}
		sheet.addMergedRegion(new Region(
            						rowNum-1,
									(short)iStartIndex, //first column (0-based)
            						rowNum-1, // first and last row  (0-based)
            						(short)(iColIndex-1)));  //last column  (0-based)

		}

	//CREATE row 1 FOR HEADER
	cellHeaderStyle.setBorderBottom(cellHeaderStyle.BORDER_THIN);
	cellHeaderStyle.setBorderLeft(cellHeaderStyle.BORDER_THIN);
	cellHeaderStyle.setBorderRight(cellHeaderStyle.BORDER_THIN);
	row = sheet.createRow(rowNum);
	rowNum++; //prepare for next row
    j=0;
	cell = row.createCell( (short) j);
	cell.setCellStyle(cellHeaderStyle);
	outputHeader(cell, 0, countrybean);
	sheet.setColumnWidth((short) j, colWidth);
	iColIndex=1;
	if (bWithAdditionalCodeColumn)
		{
		cell = row.createCell( (short) iColIndex);
		cell.setCellStyle(cellHeaderStyle);
		cell.setCellValue(countrybean.getTranslation("Code"));
		sheet.setColumnWidth((short) j, colWidth);
		iColIndex=2;
		}
	for (int k=0; k<nHorizontal; k++)
	  for (j=col; j<=nCols; j++)
  		{
		totals[k+j-col+1]=0;
		sSql=meta.getColumnName(j);
		//Add cell for header row
		strDummy = countrybean.getColumnTitle(sSql);
		cell = row.createCell( (short) (iColIndex)); //Cell has shift, please verify
		cell.setCellValue(strDummy);
		cell.setCellStyle(cellHeaderStyle);
		//colWidth=(short)(countrybean.getColumnTitle(sSql).length()*1000);
		sheet.setColumnWidth((short) (iColIndex), colWidth);
		// sheet.setRowHeight((short) (rowNum-1), 2);
		iColIndex++;
	}

	//HEADER row END
	
	NumberFormat f = NumberFormat.getInstance();
	f.setMaximumFractionDigits(2);
	f.setGroupingUsed(bReportFormat);
	String sLastRowId="@#$---##"; // Arbitrary value
	int iRowIndex=0;
	iColIndex=0;
	while (rset.next() && rowNum<32000)
		{
		sCell=htmlServer.not_null(rset.getString(1));
		sSql=countrybean.sExtractVariable(countrybean.asStatLevels[0]);
		if (countrybean.asStatLevels[0].equals(sFechanoFechames))
		           {
				   sCell+="000000";
				   sCell= sCell.substring(0,4)+"/"+sCell.substring(4,6);
				   }
			else if (countrybean.asStatLevels[0].equals(sFecha))
		           {
				   sCell+="00000000";
				   sCell= sCell.substring(0,4)+"/"+sCell.substring(4,6)+"/"+sCell.substring(6,8);
				   }
			else if (sSql.startsWith("extension."))
					sCell=sCell.length()==0?"-":woExtension.getValue(sSql.substring(10),sCell);
		String sRowId=sCell;
		if  (bWithAdditionalCodeColumn)
			sRowId=htmlServer.not_null(rset.getString(2)).trim();

		if (!sLastRowId.equals(sRowId))
			{
		    row = sheet.createRow(rowNum);
		    rowNum++; //prepare for next row
		  	sLastRowId=sRowId;
			iRowIndex=0;
			iColIndex=0;
			//Add cell for vertical dimension
			cell = row.createCell( (short) 0);
			cell.setCellValue(sCell);
			if (col==4)
				{
				//Add cell for geo code
				cell = row.createCell( (short) 1);
				cell.setCellValue(htmlServer.not_null(sRowId));
				iColIndex=1;
				}
			}
		sCell=htmlServer.not_null(rset.getString(col-1)).trim();
		while (iRowIndex<nHorizontal && !sCell.equals((String)vHorizontal.get(iRowIndex)))
		     {
	    	 for (j=col; j<=nCols; j++)
				{
				iColIndex++;
				//Add cell for result row
				cell = row.createCell( (short) (iColIndex)); 
				cell.setCellValue(0);
				}
			 iRowIndex++;
			 }
	    for (j=col; j<=nCols; j++)
			{
            double nVal=rset.getDouble(j);
			totals[iColIndex]+=nVal;
			iColIndex++;
			//Add cell for result row
			cell = row.createCell( (short) (iColIndex)); 
			cell.setCellValue(nVal);
			}
		iRowIndex++;
		}

//CREATE row FOR Total
row = sheet.createRow(rowNum);
rowNum++; //prepare for next row
//Add cell for TOTAL row
cell = row.createCell((short) 0);
cell.setCellValue("TOTAL");
int offset=0;
if (bWithAdditionalCodeColumn)
  offset++;
for (j=0; j<nHorizontal*(nCols-col+1); j++)
	{
	boolean bOutput=true;
/*
	sSql=meta.getColumnName(j);
	for (int k=0; k<countrybean.asVariables.length; k++)
		{
		String sTitSql=countrybean.getVartitle(countrybean.asVariables[k]);
		// only sum columns are rolled up - they make sense
			if (!sSql.equals(sTitSql)) // this must be divided by #datacards, not always available: || sSql.equals(countrybean.getTranslation("AverageOf")+" "+sTitSql))
		   bOutput=true;
		}
*/
	//Add cell for TOTAL row
	cell = row.createCell( (short) (j+1+offset) );
	if (bOutput)
		{
		cell.setCellValue(totals[j+offset]);
		}
	else
		cell.setCellValue("");
	}

rset.close();
stmt.close();
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
	//response.setHeader("Content-disposition", "inline;filename=DI_Stat.xls");
    String sTime=String.valueOf(Calendar.getInstance().get(Calendar.MINUTE)*100+Calendar.getInstance().get(Calendar.SECOND)+Calendar.getInstance().get(Calendar.HOUR)*10000);
    response.setHeader("Content-disposition", "attachment;filename=DI_Crosstab"+sTime+".xls");
    response.setHeader("Content-Type", "application/vnd.ms-excel; charset=utf-8");
	OutputStream excel = response.getOutputStream();
	excel.write(outStream.toByteArray());
	//excel.flush();
	excel.close();
} 
catch (FileNotFoundException fne) {
	System.out.println("File not found...");
} 
catch (IOException ioe) {
	System.out.println("IOException..." + ioe.toString());
}
%>



