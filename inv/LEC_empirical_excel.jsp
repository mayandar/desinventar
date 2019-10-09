<%@ page info="DesConsultar generator results page" session="true" %><%@ page import="java.io.*"%><%@ page import="java.sql.*"%><%@ page import="java.text.*"%><%@ page import="java.util.*"%><%@ page import="org.lared.desinventar.util.*" %><%@ page import="org.lared.desinventar.webobject.*" %><%@ page import="org.apache.poi.hssf.dev.*"%><%@ page import="org.apache.poi.hssf.model.*"%><%@ page import="org.apache.poi.hssf.record.*"%><%@ page import="org.apache.poi.hssf.usermodel.*"%><%@ page import="org.apache.poi.hssf.util.*"%><%@ page import="org.apache.poi.util.StringUtil"%><jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" /><%@ include file="/util/opendatabase.jspf" %><%@ include file="/paramprocessor.jspf" %><%  
	/*
	************************************************************************************************
	At first, when the UTF-8 Excel required

	@page language="java" pageEncoding="utf8" contentType="application/vnd.ms-excel; charset=UTF-8"

	at the top of page, then this leads to alter code in /paramprocessor.jspf and /util/opendatabase.jspf by
	ommiting the "pageEncoding" becuase of the duplication. 
	The weird thing is; after finiish coding then I try to go back for checking out one more time. 
	There is no longer required for a above statement anymore. Then everthing suppose to be back to normal.

	:) Tom.
    ************************************************************************************************
	*/
	

// and makes final the page parameters
int nGrouping_option=webObject.extendedParseInt(request.getParameter("group_option"));
String sTarget=request.getParameter("target_var");

ServletContext sc = getServletConfig().getServletContext();
String sDesInventarFolder=sc.getRealPath("/");

InputStream inp = new FileInputStream(sDesInventarFolder+"EmpiricalCurves.xls");
// create a workbook object
HSSFWorkbook workBook = new HSSFWorkbook(inp);

// Gnerates the excel file from Java class
LEC_excel_curve_generator lexcel=new LEC_excel_curve_generator();
lexcel.generateCurves(workBook, countrybean, con, nGrouping_option,  sTarget);


//out.println("");
dbCon.close();

//prepare excel and then write binary to response.
try {
	ByteArrayOutputStream outStream =new ByteArrayOutputStream();
	workBook.write(outStream);
	inp.close();
	//response.reset();
	response.setHeader("Content-disposition", "attachment;filename=DI_LossExceedanceCurve.xls");
	response.setHeader("Content-Type", "application/vnd.ms-excel; charset=utf-8");
	OutputStream excel = response.getOutputStream();
	excel.write(outStream.toByteArray());
	excel.close();
	} 
catch (FileNotFoundException fne) {
	System.out.println("File not found...");
	} 
catch (IOException ioe) {
	System.out.println("IOException..." + ioe.toString());
	}
%>