<%@ page trimDirectiveWhitespaces="true" %>
<%@ page info="DesConsultar generator results page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.apache.poi.hssf.dev.*"%>
<%@ page import="org.apache.poi.hssf.model.*"%>
<%@ page import="org.apache.poi.hssf.record.*"%>
<%@ page import="org.apache.poi.hssf.usermodel.*"%>
<%@ page import="org.apache.poi.hssf.util.*"%>
<%@ page import="org.apache.poi.util.StringUtil"%>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%@ include file="/util/opendatabase.jspf" %>
<%@ include file="/paramprocessor.jspf" %>
<%
try{ 
response.reset();
}
catch (Exception exx){}

String sTime=String.valueOf(Calendar.getInstance().get(Calendar.MINUTE)*100+Calendar.getInstance().get(Calendar.SECOND)+Calendar.getInstance().get(Calendar.HOUR)*10000);
response.setHeader("Content-disposition", "attachment;filename=DI_Report"+sTime+".xls");
response.setHeader("Content-Type", "application/vnd.ms-excel; charset=utf-8");
//Static/Init that will be used
String strSheetName = "DI Report";
String strDummy = "";
int rowNum = 0;
short colWidth = (short) ((25*8) /((double) 1/20));
extension woExtension=new extension();
woExtension.dbType=countrybean.dbType;
woExtension.loadExtension(con,countrybean);

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

ArrayList sqlparams=new ArrayList();
PreparedStatement pstmt=null;
String sSql, sSqlCopy;
int j=0;
sSql=countrybean.getSql(true,sqlparams);
//CREATE row 0 FOR HEADER
row = sheet.createRow(rowNum);
rowNum++; //prepare for next row
//Add cell for "Serial" to header row
cell = row.createCell((short) 0);
cell.setCellValue(countrybean.getTranslation("Serial"));
cell.setCellStyle(cellHeaderStyle);	
sheet.setColumnWidth((short) 0, colWidth);

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


ResultSetMetaData meta;
// gets the metadata of the resultset
meta = rset.getMetaData();
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
	sSql=countrybean.sExtractVariable(countrybean.asVariables[j]);
	 // format name of date column 
     if (sSql.equals("fichas.fechano,fichas.fechames,fichas.fechadia")) 
		    {
		    //Add cell for "Date" to header row
			cell = row.createCell( (short) (j+1));
			cell.setCellValue(countrybean.getTranslation("Date"));
			cell.setCellStyle(cellHeaderStyle);	
			sheet.setColumnWidth((short) j, colWidth);
		    }
        else{ 
			//Add cell for "Date" to header row
			cell = row.createCell( (short) (j+1));
			cell.setCellValue(countrybean.getVartitle(countrybean.asVariables[j]));
			cell.setCellStyle(cellHeaderStyle);	
			sheet.setColumnWidth((short) j, colWidth);
		    } 
	}
//HEADER row finish. FOR DEBUGGING PURPOSES:
//out.println("<!-- "+sSql+" -->");
//cell = row.createCell( (short) (j+1));
//cell.setCellValue(countrybean.getSql(true));
      
//Data rows
// ALL ROWS!!!


while (rset.next() && rowNum<35000)
  try
	{
	String sSerial="";
	try{sSerial=htmlServer.not_null(rset.getString("fichas.serial"));}
		catch (Exception nser)
		  {
			try{sSerial=htmlServer.not_null(rset.getString("serial"));}
			catch (Exception nser2){} 
		  } 
	//CREATE row 0 FOR HEADER
	row = sheet.createRow(rowNum);
	rowNum++; //prepare for next row
	//Add cell for "Serial" to header row
	cell = row.createCell((short) 0);
	cell.setCellValue(htmlServer.not_null(sSerial));
	sheet.setColumnWidth((short) 0, colWidth);

	for (j=0; j<countrybean.asVariables.length; j++)
	  try
		{
		String sRealVar="C0L__"+j;
		sSql=countrybean.sExtractVariable(countrybean.asVariables[j]);
		if (sSql.equals("fichas.fechano,fichas.fechames,fichas.fechadia"))
			{
				/******************
				Due to POI cell ref is Zero base then "j" value has to be + 1
				*******************/
				//Add cell for "COL___ + j" to data row
				cell = row.createCell( (short) (j+1));
				cell.setCellValue( countrybean.sFormatDate(rset.getString("fechano"), rset.getString("fechames"), rset.getString(sRealVar)) );
				sheet.setColumnWidth((short) (j+1), colWidth);
			}
		else					
		 if (sSql.startsWith("eventos.nombre"))
		     {
				//Add cell for "COL___ + j" to data row
				cell = row.createCell( (short) (j+1));
				String sCell=countrybean.getLocalOrEnglish(rset,"event","event_en");
				cell.setCellValue(htmlServer.not_null(rset.getString(sRealVar)));
				sheet.setColumnWidth((short) (j+1), colWidth);
		     }
             else if (sSql.startsWith("extension."))
			 	{
					cell = row.createCell( (short) (j+1));
				    switch (nDataType[j])
				      {
				        case Types.DATE:
						          cell.setCellValue(rset.getDate(sRealVar));
						          break;
				        case Types.DECIMAL:
				        case Types.DOUBLE:
				        case Types.FLOAT:
				        case Types.NUMERIC:
				        case Types.REAL:
						           double dV=rset.getDouble(sRealVar);
						           if (dV!=0.0)
								   		cell.setCellValue(dV);										
				          		   break;
				        case Types.SMALLINT:
				        case Types.INTEGER:
				        case Types.TINYINT:
					    case Types.BIGINT:
						          int nValue=rset.getInt(sRealVar);
								  String sCell=woExtension.getValue(sSql.substring(10),String.valueOf(nValue));
						          if (woExtension.extendedParseInt(sCell)==nValue)
								  		{
										if (nValue!=0)
											cell.setCellValue(nValue);
										}
								  else
								  		cell.setCellValue(sCell);
								  break;
						default:
								cell.setCellValue(rset.getString(sRealVar));  
				      }
					sheet.setColumnWidth((short) (j+1), colWidth);
				}

            else {
				//Add cell for "COL___ + j" to data row
				cell = row.createCell( (short) (j+1));
			    switch (nDataType[j])
			      {
			        case Types.DATE:
					          cell.setCellValue(rset.getDate(sRealVar));
					          break;
			        case Types.DECIMAL:
			        case Types.DOUBLE:
			        case Types.FLOAT:
			        case Types.NUMERIC:
			        case Types.REAL:
						           double dV=rset.getDouble(sRealVar);
						           if (dV!=0.0)
								   		cell.setCellValue(dV);
			          		   break;
			        case Types.SMALLINT:
			        case Types.INTEGER:
			        case Types.TINYINT:
				    case Types.BIGINT:
						           int iV=rset.getInt(sRealVar);
						           if (iV!=0)
								   		cell.setCellValue(iV);
					          break;
					default:
							cell.setCellValue(rset.getString(sRealVar));  
			      }
				sheet.setColumnWidth((short) (j+1), colWidth);
			}
		}
	 catch (Exception colnotfound)
	    {
			   out.println("!-- Not found:"+sSql+" --");
		}	

		//out.println("");
		//***********************************/
	}
 catch (Exception ex)
    {
   	out.println("!-- Exception found:"+ex.toString()+" --");
	}	
try	{rset.close(); }catch (Exception e){out.println("<!-- closing r:"+e.toString()+" -->");}	
try	{pstmt.close();}catch (Exception e){out.println("<!-- closing ps:"+e.toString()+" -->");}	
dbCon.close();


//prepare excel and then write binary to response.
try {
	ByteArrayOutputStream outStream =new ByteArrayOutputStream();
	workBook.write(outStream);
	//response.reset();
	//response.setHeader("Content-disposition", "inline;filename=DI_Stat.xls");
	OutputStream excel = response.getOutputStream();
	excel.write(outStream.toByteArray());
	//excel.flush();
	excel.close();
} 
catch (FileNotFoundException fne) {
	System.out.println("File not found...");
} 
catch (Exception ioe) {
	System.out.println("IOException..." + ioe.toString());
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
