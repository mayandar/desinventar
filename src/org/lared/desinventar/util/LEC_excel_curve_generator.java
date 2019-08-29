package org.lared.desinventar.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.StringTokenizer;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

import java.io.*;
import java.sql.*;
import java.text.NumberFormat;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.usermodel.HSSFName;

import org.apache.poi.poifs.filesystem.POIFSFileSystem;


import org.lared.desinventar.webobject.*;
import org.lared.desinventar.system.Sys;

public class LEC_excel_curve_generator 

   {
	
	
	public void generateCurves(HSSFWorkbook workBook, DICountry countrybean, Connection con, int nGrouping_option, String sTarget)
	{
		// Name that will be used
		String strSheetName = "DI_EmpiricalCurve";

		ArrayList<String> sqlparams=new ArrayList<String>();
		PreparedStatement pstmt=null;
		ResultSet rset=null;
		
		//create a worksheet object
		HSSFSheet sheet = workBook.getSheetAt(0);
		//declare a row object reference
		HSSFRow row = null;
		//declare a cell object reference
		HSSFCell cell = null;
		HSSFCell dcell = null;
		//create stype and create Bold font style
		HSSFCellStyle cellHeaderStyle = workBook.createCellStyle();
		HSSFFont fBold = workBook.createFont();
		fBold.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		cellHeaderStyle.setFont(fBold);
		cellHeaderStyle.setBorderBottom(cellHeaderStyle.BORDER_THIN);
		workBook.setSheetName(0, strSheetName);
		// date format
		short dateFormat = workBook.createDataFormat().getFormat("dd/MM/yyyy");
		HSSFCellStyle dateStyle = workBook.createCellStyle(); 
		dateStyle.setDataFormat(dateFormat); 
		 


		int nStartingRow=50;
		short colWidth = (short) ((25*8) /((double) 1/20));
		String sLangSuffix="";
		if ("EN".equals(countrybean.getDataLanguage()))
			sLangSuffix="_en";
		boolean bReportFormat=false;   // (request.getParameter("reportFormat")!=null);
		String sSql=""; 
		short j=0;  


		int rowNum = nStartingRow;
		try	{
			// Categoria	Evento	Fecha	DivPol	Municipio	Afectados	Damnificados	Evacuados	Reubicados	Desaparecidos	Heridos	Muertos	Hospitales	Escuelas	VivDestruidas	VivAfectadas	Vias	Hectareas	Cabezas	ValorLocal	ValorUS	Costo	Acumulado
			// in stats: sSql=countrybean.getStatSql();
			sSql="SELECT max(fichas.serial) as c0, max(nombre"+sLangSuffix+") as name_ev, min(fechano*10000+fechames*100+fechadia) as fDate, max(lev0_name"+sLangSuffix+") as cl4, max(lev1_name"+sLangSuffix+") as cl5, max(lev2_name"+sLangSuffix+") as cl6, ";
			sSql+="sum(muertos) as col_1,sum(heridos) as col_2,sum(desaparece) as col_3,sum(afectados) as col_4, sum(evacuados) as col_5,sum(reubicados) as col_6, sum(nhospitales) as col_7,sum(nescuelas) as col_8,sum(vivdest) as col_9,sum(vivafec) as col_10,sum(kmvias) as col_11,sum(nhectareas) as col_12,sum(cabezas) as col_13,sum(valorloc) as col_14,sum(valorus) as col_15,sum("+sTarget+") as col_16";
			sSql+=countrybean.getWhereSql(sqlparams);
			sSql+=" and (evento in (select nombre from event_grouping where category<>'Other'))";
			switch (nGrouping_option)
				{
				case 0: sSql+=" and ("+countrybean.sqlNvl(sTarget,0)+ ">0) group by eventos.nombre"+sLangSuffix+", level0,(fechano*10000+fechames*100+fechadia)";
						break;
				case 1: sSql+=" and ("+countrybean.sqlNvl(sTarget,0)+ ">0) group by "+countrybean.sqlNvl("GLIDE","clave");
						break;
				case 2: sSql+=" and ("+countrybean.sqlNvl(sTarget,0)+ ">0) group by clave";
						break;
				}

			sSql="select * from ("+sSql+") qx order by fDate";

			//CREATE row 0 FOR HEADER
		    short col=0; 
			int nColsPerVar=0;

			pstmt=con.prepareStatement(sSql);
			for (int k=0; k<sqlparams.size(); k++)
						pstmt.setString(k+1, (String)sqlparams.get(k));
			rset=pstmt.executeQuery();

			/// gets the metadata of the resultset
			ResultSetMetaData meta = rset.getMetaData();
			int nCols=meta.getColumnCount();
			NumberFormat f = NumberFormat.getInstance();
			f.setMaximumFractionDigits(2);
			f.setGroupingUsed(bReportFormat);
			double dAcumm=0;
			double dMaximumValue=0;
			double dSecondMaximumValue=0;
			double[] dTotals=new double[nCols+1];
			double nVal=0;
		    Calendar cal2=Calendar.getInstance();
		    cal2.set(1900,1,1);
			while (rset.next())
				{
				//CREATE row FOR RESULT SET
				row = sheet.createRow(rowNum);
				rowNum++; //prepare for next row
				for (col=0; col<= 5; col++)  // 6 first columns are TEXT
		  			{
					String sCell=htmlServer.not_null(rset.getString(col+1)).trim();
					//Add cell for result row
					if (col==2)
				           {
						   sCell+="00000000";
						   int nMonth=Integer.parseInt(sCell.substring(4,6));
						   if (nMonth==0)
						      nMonth=1;
						   int nDay=Integer.parseInt(sCell.substring(6,8));
						   if (nDay==0)
						      nDay=1;
						   int nYear=Integer.parseInt(sCell.substring(0,4));
				   		   Calendar cal=Calendar.getInstance();
				   		   cal.set(nYear, nMonth, nDay);
						   dcell = row.createCell(col);
						   dcell.setCellValue(cal);
						   dcell.setCellStyle(dateStyle); 
						   }
					else   {
							cell = row.createCell(col);
							cell.setCellValue(sCell);
							}
					}
			    for (col=6; col<nCols; col++)
					{
		            nVal=rset.getDouble(col+1);
					//Add cell for result row
					cell = row.createCell(col); 
					cell.setCellValue(nVal);
					dTotals[col]+=nVal;
					}
				dAcumm+=nVal;
				if (nVal>dMaximumValue)
					{
					dSecondMaximumValue=dMaximumValue;
					dMaximumValue=nVal;
					}				
				cell = row.createCell(col); 
				cell.setCellValue(dAcumm);
				}
			// row with totals...	
			row = sheet.createRow(rowNum);
			//rowNum++; //prepare for next row
			for (col=6; col<nCols; col++)
				{
				//Add cell for result row
				cell = row.createCell(col); 
				cell.setCellValue(dTotals[col]);
				}
			cell = row.createCell(col); 
			cell.setCellValue(dAcumm);

			// Now, puts the number of rows in B3
			row = sheet.getRow(2);
			cell = row.createCell(col=1); 
			cell.setCellValue(rowNum-nStartingRow+1);

            // sets the right sizes for the named ranges
			HSSFName range0=workBook.getNameAt(workBook.getNameIndex("all_dates"));
			range0.setReference("DI_EmpiricalCurve!$C$51:$C$"+rowNum);  // this will change to  .setRefersToFormula(...
			HSSFName range1=workBook.getNameAt(workBook.getNameIndex("all_values"));
			range1.setReference("DI_EmpiricalCurve!$V$51:$V$"+rowNum);  // this will change to  .setRefersToFormula(...
			HSSFName range2=workBook.getNameAt(workBook.getNameIndex("all_accumulated"));
			range2.setReference("DI_EmpiricalCurve!$W$51:$W$"+rowNum);  // this will change to  .setRefersToFormula(...

			// now puts the maximums, START AT K5
			int nr=4;
			row = sheet.getRow(nr);  
			cell = row.getCell(col=10);  // col K
			nVal = cell.getNumericCellValue();
			while(nr<17 && nVal<dSecondMaximumValue)
			{
				nr++;
				row = sheet.getRow(nr);  
				cell = row.getCell(col=10);  // col K
				nVal = cell.getNumericCellValue();				
			}
			cell.setCellValue(dSecondMaximumValue);
			nr++;
			row = sheet.getRow(nr);  
			cell = row.getCell(col=10);  
			cell.setCellValue(dMaximumValue);

		rset.close();
		pstmt.close();
		}
		catch (Exception exst) {
			System.out.println("[DI9] Error generating LEC Excel: "+exst.toString());
		}

		
	}
	
	
	

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

}
