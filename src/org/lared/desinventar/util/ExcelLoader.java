package org.lared.desinventar.util;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Types;
import java.util.HashMap;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.StringTokenizer;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

import java.io.*;
import java.sql.*;
import org.lared.desinventar.webobject.*;
import org.lared.desinventar.system.Sys;

public class ExcelLoader 
{

	// exposed variables:
	public int nFirstRow=2;
	public int nStartRow=2;
	public int nLastCol=300;
	public int nSpreadsheet=0;
	public HashMap<String,Integer> sLoadMap=new HashMap();
	public boolean bDebug=true;

	public JspWriter out=null;
	
	HSSFRow row=null;
	fichas datacard=new fichas();
	extension extended=new extension();
	// this is a large number of columns for an excel spreadsheet.
	final int nMaxCols=300;
	String[] sCols= new String[nMaxCols+1]; // enough for ALL 
	int[] wCols= new int[nMaxCols+1]; // enough for ALL 
	int nSerial=1;
	
	
	
	public void setOut(JspWriter outstream)
	{
		out=outstream;
	}
	
	public void setDebug(boolean stat)
	{
		bDebug=stat;
	}

	public void debug(String sMessage)
	{
		  System.out.println("DI9: "+sMessage);
		  try
		  {
			  if (out!=null)
					out.println(sMessage+"<br/>");
		  }
		  catch (Exception e)
		  {}
	}
	
	
	public void setFirstRow(int start)
	{
		nStartRow=start;
	}
	
	public void setLastCol(int start)
	{
		nStartRow=start;
	}
	
	
	public static GregorianCalendar getExcelCalendarDate(String sDecimalDate)
	{
		GregorianCalendar cCal=new GregorianCalendar();
		cCal.setTime(new java.util.Date());
		try {
			if (sDecimalDate.indexOf("/")>0 || (sDecimalDate.indexOf("-")>0 && sDecimalDate.lastIndexOf("-")>sDecimalDate.indexOf("-")))
			{
				Date dt=webObject.extendedParseDate(sDecimalDate);
				cCal.setTime(dt);
			}
			else{
				cCal.set(1975,1,1); 
				int dDate=webObject.extendedParseInt(sDecimalDate)-27426;  // 27426 is 01/02/75
				cCal.add(Calendar.DATE,dDate);			
			}			
		}
		catch (Exception e)
		{
		}
		return cCal;		
	}

	public static String getExcelDate(String sDecimalDate)
	{
		GregorianCalendar cCal=getExcelCalendarDate(sDecimalDate);
		return webObject.strDate(cCal.getTime());
	}



	public int loadRow(HSSFRow row)
	{
		// fix this!!
		for (int j=0; j<=nMaxCols; j++)
			sCols[j]="";
		nLastCol=row.getLastCellNum();
		for (short kCol=0; kCol<nLastCol; kCol++)
		{
			try{
				HSSFCell cell = row.getCell(kCol);
		    	if (cell!=null)
		    		{
		    		if (cell.getCellType()==HSSFCell.CELL_TYPE_STRING)
		    			{
		    			sCols[kCol]=cell.getStringCellValue();
		    			//debug(cell.getStringCellValue()+" | ");
		    			}
			    	else
			   			{
		    			try {
		    				sCols[kCol]=String.valueOf(cell.getNumericCellValue());
		    			}
		    			catch (Exception e)
		    			{
		    				sCols[kCol]=cell.getStringCellValue();
		    			}
			    		if (sCols[kCol].equals("0.0"))
			    			sCols[kCol]="";
			    		if (sCols[kCol].endsWith(".0"))
			    			sCols[kCol]=sCols[kCol].substring(0,sCols[kCol].length()-2);
		    			// debug(cell.getNumericCellValue()+" | ");
			   			}
		    		}
		    	else
		    		{
		    		// debug(" | ");
		    		sCols[kCol]="";
		    		}				
			}
			catch (Exception e){
			  debug ("exception loading cell:"+e.toString());	
			}
	    }
	    //debug("| EOC:["+nLastCol+"/"+row.getLastCellNum()+" cols]\n");
		return row.getLastCellNum();
	}
	
	public void createExtension(HttpServletRequest request,Connection con, DICountry countrybean)
	{
		int nCurrentFieldType=0;
		int nCurrentFieldSize=30;
		String sFieldName="";
		int nField=0;
		int maxcols=webObject.extendedParseInt(request.getParameter("maxcols"));
		extended.dbType=countrybean.dbType;
		extended.loadExtension(con, countrybean);
		try{
			Statement stmt=con.createStatement();
			for (int j=0; j<maxcols; j++)
				{
				String sName=webObject.not_null(request.getParameter("namecol"+j)).trim();
				String sName_en=webObject.not_null(request.getParameter("namecol_en"+j)).trim();
				if (sName_en.length()==0)
					sName_en=sName;
				boolean bCreateThis="Y".equals(request.getParameter("chkcol"+j)) && sName.length()>0;
				if (bCreateThis)
					{
					try	{					
						wCols[j]=webObject.extendedParseInt(request.getParameter("col_width"+j));
						sFieldName=webObject.not_null(request.getParameter("fieldname"+j)).trim();
						
						if (sFieldName.length()<2)
							sFieldName= getFieldNameFromLabel(j, sName_en);
						// MAX FIELD NAME IN DICTIONARIO
						if (sFieldName.length()>30)
							sFieldName= sFieldName.substring(0,30);
						
						nCurrentFieldType=0;
						nCurrentFieldSize=30;			
						nField=0;
						int nType=webObject.extendedParseInt(request.getParameter("field_type"+j));
					/*	 <option value=0>Text
						 <option value=1>Integer
						 <option value=2>Floating point   // <option value=3 currency not used here
						 <option value=3>Date
						 <option value=4>Memo 
				   		 <option value=6>Yes/No
				 		 <option value=7>Drop-down List
				 		 <option value=8>Choice   */						
						switch (nType)
							 {
							   case 4: // Types.CLOB:  case 1111: // type reported by Oracle for BLOB types...  case -1: // type reported by ACCESS for MEMO types...						   case Types.BLOB:
								 nCurrentFieldType=5;
								 nCurrentFieldSize=16;			  
							     break;
							   case 3:  //Types.DATE:
								 nCurrentFieldType=4;
								 nCurrentFieldSize=16;			  
								 break;
							   case 2: // Types.DECIMAL:  case Types.DOUBLE:   case Types.FLOAT:   case Types.REAL:   case Types.NUMERIC:
								 nCurrentFieldType=2;
								 nCurrentFieldSize=8;
								 break;
							   case 1: // Types.SMALLINT: case Types.INTEGER:  case Types.BIGINT:   case Types.TINYINT:
							   case 6: // Yes/no
							   case 7: // Drop-down:
							   case 8: // Choice
								 nCurrentFieldType=1;
								 nCurrentFieldSize=4;			  
							     break;
							   case 0:   //Types.VARCHAR:
								 nCurrentFieldType=0;
								 nCurrentFieldSize=wCols[j];  //TODO: fix this... meta.getColumnDisplaySize(nField);			  
							     break;
						    }
		        		String sSql="alter table extension add "+sFieldName.toLowerCase()+" "+DbImplementation.typeNames[countrybean.country.ndbtype][nCurrentFieldType];
						if (nCurrentFieldType==0)
				   			sSql+="("+nCurrentFieldSize+")";
						try
							{
							stmt.executeUpdate(sSql);
							// if it reached here, the field has just been added to the table OK

							diccionario dct=new diccionario();
							dct.orden=extended.vFields.size()+j+1;
							dct.nombre_campo=sFieldName;
							dct.label_campo=sName;
							dct.label_campo_en=sName_en;
							dct.descripcion_campo=sName;
							dct.lon_x=nCurrentFieldSize;
							dct.fieldtype=nType;
							dct.addWebObject(con);
							// and adds the variable to the loader's map
							sLoadMap.put(sFieldName,j);
							extended.asFieldNames.put(sFieldName,"");
							}
						catch (Exception e)
							{
							// log here the error type
							debug("EXTENSION DEFINITION_0 ["+nField+"-"+sFieldName+"("+DbImplementation.typeNames[countrybean.country.ndbtype][nCurrentFieldType]+")] "+ e.toString());
							}
						}
					catch(Exception e)
						{
						// log here the error type
						debug("EXTENSION DEFINITION_1  ["+nField+"-"+sFieldName+"("+DbImplementation.typeNames[countrybean.country.ndbtype][nCurrentFieldType]+")] "+ e.toString());
						}			
						
					}
				}
			
		}
		catch (Exception eload)
		{
			debug("EXTENSION DEFINITION_2  ["+nField+"-"+sFieldName+"("+DbImplementation.typeNames[countrybean.country.ndbtype][nCurrentFieldType]+")] "+ eload.toString());			
		}
	}

	/**
	 * @param j
	 * @param sName_en
	 * @return
	 */
	public String getFieldNameFromLabel(int j, String sName_en) 
	{
		String sFieldName;
		String sVarName=sName_en.toUpperCase();
		sFieldName="";
		String sAlpha="ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
		int l=0;
		for (int i=0; i<sVarName.length();  i++)
		{
			if ( sAlpha.indexOf(sVarName.charAt(i))>=0)
				sFieldName+=sVarName.charAt(i);
			else 
				if (!sFieldName.endsWith("_"))
					sFieldName+="_";								
		}
		if (sFieldName.length()>30)
		{
			String[] sWords=sFieldName.split("_");
			int k=sWords.length;
			String sTail="";
			sFieldName="";
			for (int i=0; (sFieldName+sTail).length()<30 && i<k; i++, k--)
			{
				sFieldName+=(sFieldName.length()>0?"_":"");
				sFieldName+=sWords[i];
				
				sTail=(sTail.length()>0?"_":"")+sTail;
				sTail=sWords[k]+sTail;			
			}
		}
		
		if (sFieldName.length()<2 // too short
		    || extended.asFieldNames.get(sFieldName)!=null  // or already defined
		    )
			sFieldName="FIELD_XLS_"+(extended.vFields.size()+j+1);
		return sFieldName;
	}
	
	public void loadFile (String sFileToLoad, Connection con, DICountry countrybean, HttpServletRequest request)
	{
		

		eventos tstEvent=new eventos();
		causas tstCausa=new causas();
		lev0 tstLev0=new lev0();
		lev1 tstlev1=new lev1();
		lev2 tstlev2=new lev2();
	    debug("Now starting import using spreadsheet "+sFileToLoad);
		
	    
	    for (int j=0; j<=nMaxCols; j++)
				sCols[j]="";
	 
		datacard.dbType=countrybean.dbType;
		extended.dbType=countrybean.dbType;
		extended.loadExtension(con, countrybean);

		InputStream inp = null;
		HSSFWorkbook wb = null;
		
    	try{
    		inp = new FileInputStream(sFileToLoad);

    		wb = new HSSFWorkbook(new POIFSFileSystem(inp));
    		HSSFSheet sheet=wb.getSheetAt(nSpreadsheet);
    		int nLastRow=sheet.getLastRowNum();
    		row=sheet.getRow(nStartRow);
    		nLastCol=row.getLastCellNum();
    		
    		HSSFCell cell = null;
    		
    		/* Debug code
    		String s1=sLoadMap.get("serial").toString();
    		String s2=sLoadMap.get("level0").toString();
	    	String s3=sLoadMap.get("evento").toString();
	    	String s4=sLoadMap.get("fechano").toString()+sLoadMap.get("date").toString()+webObject.not_null(request.getParameter("serial_auto"));
    		*/
	    	
	    	boolean bser=request.getParameter("serial_auto")!=null;
	    	boolean beve=request.getParameter("evento_fixed")!=null;
	    	boolean bdat=request.getParameter("date_fixed")!=null;
	    
	    	boolean bImportEvents=request.getParameter("events")!=null;
	    	boolean bImportGeo=request.getParameter("geography")!=null;
	    	boolean bImportCauses=request.getParameter("causes")!=null;
    		
    		if (sLoadMap.get("level0")<nMaxCols && 
    		   (sLoadMap.get("serial")<nMaxCols || request.getParameter("serial_auto")!=null) &&
    		   (sLoadMap.get("evento")<nMaxCols || request.getParameter("evento_fixed")!=null) &&
			   (sLoadMap.get("fechano")<nMaxCols || sLoadMap.get("date")<nMaxCols || request.getParameter("date_fixed")!=null))
    	      {
    		  for (int jRow=nStartRow; jRow<=nLastRow; jRow++)
    	    	{
    	    	int nCols=loadRow(sheet.getRow(jRow));
 
    	    	/* Debug code
        		s1=sCols[sLoadMap.get("serial")];
    	    	s2=sCols[sLoadMap.get("level0")];
    	    	s3=sCols[sLoadMap.get("evento")];
    	    	s4=sCols[sLoadMap.get("fechano")]+sCols[sLoadMap.get("date")];
    	        */
    	    	
    	    	// Save row info    	    	         
    	    	boolean bProceed=((sCols[sLoadMap.get("serial")].length()>0  || request.getParameter("serial_auto")!=null) &&
    	    					   sCols[sLoadMap.get("level0")].length()>0  &&
    	    					  (sCols[sLoadMap.get("evento")].length()>3  || request.getParameter("evento_fixed")!=null) &&
    	    					  (sCols[sLoadMap.get("fechano")]+sCols[sLoadMap.get("date")]+ webObject.not_null(request.getParameter("date_fixed"))).length()>1);    
    	    	if (bProceed)
    	    		{
    	    		debug("Processing Row "+jRow);
    	    		if (jRow==375)
    	    			debug("Processing BUGGY Row "+jRow);
    		    	if (bImportEvents)
    	    		{
    		    	 tstEvent.nombre=sCols[sLoadMap.get("evento")];
    		    	 if (tstEvent.nombre.length()>=30)
    		    		 tstEvent.nombre=tstEvent.nombre.substring(0,30);
    		    	 // to avoid issues with non-sensitive databases
    		    	 tstEvent.nombre=tstEvent.nombre.toUpperCase();
    		    	 int nr=tstEvent.getWebObject(con);
    		    	 if (nr==0)
    		    	 	{
    		    		 tstEvent.serial=tstEvent.getMaximum("serial", "eventos", con)+1;
    		    		 tstEvent.nombre_en=tstEvent.nombre;
    		    		 tstEvent.addWebObject(con);
    		    		 debug("Added [ev]: "+tstEvent.nombre);
    	    		    }
    	    		}
    		    	if (bImportCauses)
    	    		{
       		    	 tstCausa.causa=sCols[sLoadMap.get("causa")];
    		    	 if (tstCausa.causa.length()>25)
    		    		 tstCausa.causa=tstCausa.causa.substring(0,25);
    		    	 // to avoid issues with non-sensitive databases
    		    	 tstCausa.causa=tstCausa.causa.toUpperCase();
    		    	 if (tstCausa.causa.length()>0){
    		    		 int nr=tstCausa.getWebObject(con);
        		    	 if (nr==0)
     		    	 		{
        		    		 tstCausa.causa_en=tstCausa.causa;
        		    		 tstCausa.addWebObject(con);
        		    		 debug("Added [ca]: "+tstCausa.causa);
     		    	 		}
    		    	 }
    	    			
    	    		}
    		    	if (bImportGeo)
    	    		{
          		    	 tstLev0.lev0_cod=sCols[sLoadMap.get("level0")];
        		    	 int nr=tstLev0.getWebObject(con);
        		    	 if (nr==0)
        		    	 	{
              		    	 tstLev0.lev0_name=sCols[sLoadMap.get("name0")];
            		    	 if (tstLev0.lev0_name.length()>=30)
            		    		 tstLev0.lev0_name=tstLev0.lev0_name.substring(0,30);
        		    		 tstLev0.lev0_name_en=tstLev0.lev0_name;
        		    		 tstLev0.addWebObject(con);
        		    	 	}    	    			
  					   	 if (sCols[sLoadMap.get("level1")].length()>0)
  					   	 	{
  	          		    	 tstlev1.lev1_cod=sCols[sLoadMap.get("level1")];
  	        		    	 nr=tstlev1.getWebObject(con);
  	        		    	 if (nr==0)
  	        		    	 	{
  	              		    	 tstlev1.lev1_lev0=sCols[sLoadMap.get("level0")];
  	              		    	 tstlev1.lev1_name=sCols[sLoadMap.get("name1")];
  	              		    	 if (tstlev1.lev1_name.length()>=30)
  	              		    		 tstlev1.lev1_name=tstlev1.lev1_name.substring(0,30);
  	              		    	 tstlev1.lev1_name_en=tstlev1.lev1_name;
  	        		    		 tstlev1.addWebObject(con);
  	        		    	 	}    	    			  					   		 
  	  					   	 if (sCols[sLoadMap.get("level2")].length()>0)
	   					   	 	{
	   	          		    	 tstlev2.lev2_cod=sCols[sLoadMap.get("level2")];
	   	        		    	 nr=tstlev2.getWebObject(con);
	   	        		    	 if (nr==0)
	   	        		    	 	{
	   	              		    	 tstlev2.lev2_lev1=sCols[sLoadMap.get("level1")];
	   	              		    	 tstlev2.lev2_name=sCols[sLoadMap.get("name2")];
	   	              		    	 if (tstlev2.lev2_name.length()>=30)
	   	              		    		 tstlev2.lev2_name=tstlev2.lev2_name.substring(0,30);
	   	              		    	 tstlev2.lev2_name_en=tstlev2.lev2_name;
	   	        		    		 tstlev2.addWebObject(con);
	   	        		    	 	}    	    			  					   		 
	   					   	 	}
  					   	 	}
    	    		}
    	    		
    	    		datacard.init();
    				datacard.serial=String.valueOf(datacard.getSequence("fichas_seq", con));
    	    		LoadDatacard(request);
   		    	 	// to avoid issues with non-sensitive databases
    	    		datacard.evento=datacard.evento.toUpperCase();
    	    		datacard.causa=datacard.causa.toUpperCase();
    	    		loadExtended(countrybean);
    	    		datacard.checkLengths();
    	    		int nrows=datacard.addWebObject(con);
    	    		if (nrows==0)
    	    			debug("Not added - DC:"+datacard.lastError);
    	    		// adds corresponding extended datacard
    	    		extended.clave_ext=datacard.clave;
    	    		extended.checkLengths();
    	    		nrows=extended.addWebObject(con); 
    	    		if (nrows==0)
    	    			debug("Not added - EX:"+datacard.lastError);
    	    		}
    	    	}
    	    }  
    		else
        		debug ("NOT LOADING: essential fields missing !!! ");
   
    	}
    	catch (Exception e){
    		debug ("Exception loading record: "+e.toString());
    	}
    	finally{
        	try{
        		inp.close();
        	}
        	catch (Exception e){
        		debug ("Exception closing : "+e.toString());
        	}
    		
    	}


    	// removes the entry from tips - it will not show real data
		CountryTip.getInstance().remove(countrybean.countrycode);

	}
	
	public int loadExtended(DICountry countrybean)
	{
	
	// allocates a dictionary object to read each field
	Dictionary dct = new Dictionary();
	for (int j = 0; j < extended.vFields.size(); j++)
		{
		dct = (Dictionary) extended.vFields.get(j);
		int jl=sLoadMap.get(dct.nombre_campo);
		dct.sValue=extended.not_null(sCols[jl]);
		switch (dct.fieldtype)
			{
		
			case extension.YESNO:
				if ("YES".equalsIgnoreCase(dct.sValue)
					|| "Y".equalsIgnoreCase(dct.sValue)
					|| "1".equals(dct.sValue)
					|| "-1".equals(dct.sValue)
				   )
				dct.sValue="Y";	
  
			case extension.LIST:
			case extension.CHOICE:
				dct.sValue=dct.getValueCode(dct.sValue,countrybean);
			    dct.dNumericValue=dct.extendedParseInt(dct.sValue);
				break;
			case extension.DATETIME:
			   dct.sValue=getExcelDate(dct.sValue);
			   break;
			case extension.CURRENCY:
			case extension.FLOATINGPOINT:
			   dct.dNumericValue=dct.extendedParseDouble(dct.sValue);
			   break;
			case extension.INTEGER:
			   dct.dNumericValue=dct.extendedParseInt(dct.sValue);
			   break;
			}
		}
	return 0;
	}

	int getCheckboxValue(String sVal)
	{
		int nRet=datacard.extendedParseInt(sVal);
		if (nRet>0)
			nRet=-1;
		else
			if ("YES".equalsIgnoreCase(sVal) || "Y".equalsIgnoreCase(sVal))
				nRet=-1;			
		return nRet;
	}

	public void LoadDatacard(HttpServletRequest request)
	{
		if (request.getParameter("serial_auto")==null) 
			datacard.serial=sCols[sLoadMap.get("serial")];
		datacard.level0=sCols[sLoadMap.get("level0")];
		datacard.level1=sCols[sLoadMap.get("level1")];
		datacard.level2=sCols[sLoadMap.get("level2")];
		datacard.name0=sCols[sLoadMap.get("name0")];
		datacard.name1=sCols[sLoadMap.get("name1")];
		datacard.name2=sCols[sLoadMap.get("name2")];
		datacard.evento="";
		if (sLoadMap.get("evento")>=0 && sLoadMap.get("evento")<nLastCol)
			datacard.evento=sCols[sLoadMap.get("evento")];
		else if (request.getParameter("evento_fixed")!=null) 
				datacard.evento=request.getParameter("evento_fixed");
		datacard.lugar=sCols[sLoadMap.get("lugar")];
		datacard.fechano=datacard.extendedParseInt(sCols[sLoadMap.get("fechano")]);
		datacard.fechames=datacard.extendedParseInt(sCols[sLoadMap.get("fechames")]);
		datacard.fechadia=datacard.extendedParseInt(sCols[sLoadMap.get("fechadia")]);
		if (sLoadMap.get("date")>=0 && sLoadMap.get("date")<nLastCol)
		{
			String sDecimalDate=sCols[sLoadMap.get("date")];
			GregorianCalendar cal=getExcelCalendarDate(sDecimalDate);
			datacard.fechano=cal.get(Calendar.YEAR);
			datacard.fechames=cal.get(Calendar.MONTH)+1;
			datacard.fechadia=cal.get(Calendar.DATE);
		}
		else if (webObject.not_null(request.getParameter("date_fixed")).length()>0)
		{
			String sDecimalDate=request.getParameter("date_fixed");
			java.sql.Date dt=webObject.extendedParseDate(sDecimalDate);
			GregorianCalendar cal=new GregorianCalendar();
			if (dt!=null)
				cal.setTime(dt);
			datacard.fechano=cal.get(Calendar.YEAR);
			datacard.fechames=cal.get(Calendar.MONTH)+1;
			datacard.fechadia=cal.get(Calendar.DATE);
		}
		
		
		
		datacard.muertos=datacard.extendedParseInt(sCols[sLoadMap.get("muertos")]);		
		datacard.heridos=datacard.extendedParseInt(sCols[sLoadMap.get("heridos")]);
		datacard.desaparece=datacard.extendedParseInt(sCols[sLoadMap.get("desaparece")]);
		datacard.afectados=datacard.extendedParseInt(sCols[sLoadMap.get("afectados")]);
		datacard.vivdest=datacard.extendedParseInt(sCols[sLoadMap.get("vivdest")]);
		datacard.vivafec=datacard.extendedParseInt(sCols[sLoadMap.get("vivafec")]);
		datacard.otros=sCols[sLoadMap.get("otros")];
		datacard.di_comments=sCols[sLoadMap.get("di_comments")];
		if (datacard.not_null(request.getParameter("fuentes_fixed")).length()>0) 
			datacard.fuentes=request.getParameter("fuentes_fixed");
		else
			datacard.fuentes=sCols[sLoadMap.get("fuentes")];
		if (datacard.not_null(request.getParameter("glide_fixed")).length()>0) 
			datacard.glide=request.getParameter("glide_fixed");
		else
			datacard.glide=sCols[sLoadMap.get("glide")];
		datacard.valorloc=datacard.extendedParseDouble(sCols[sLoadMap.get("valorloc")]);
		datacard.valorus=datacard.extendedParseDouble(sCols[sLoadMap.get("valorus")]);
		if (datacard.not_null(request.getParameter("fechapor_fixed")).length()>0) 
			datacard.fechapor=request.getParameter("fechapor_fixed");
		else
			datacard.fechapor=sCols[sLoadMap.get("fechapor")];
		if (datacard.not_null(request.getParameter("fechafec_fixed")).length()>0) 
			datacard.fechapor=request.getParameter("fechafec_fixed");
		else
			datacard.fechafec=sCols[sLoadMap.get("fechafec")];
		datacard.hay_muertos=getCheckboxValue(sCols[sLoadMap.get("hay_muertos")]);
		datacard.hay_heridos=getCheckboxValue(sCols[sLoadMap.get("hay_heridos")]);
		datacard.hay_deasparece=getCheckboxValue(sCols[sLoadMap.get("hay_deasparece")]);
		datacard.hay_afectados=getCheckboxValue(sCols[sLoadMap.get("hay_afectados")]);
		datacard.hay_vivdest=getCheckboxValue(sCols[sLoadMap.get("hay_vivdest")]);
		datacard.hay_vivafec=getCheckboxValue(sCols[sLoadMap.get("hay_vivafec")]);
		datacard.hay_otros=getCheckboxValue(sCols[sLoadMap.get("hay_otros")]);
		datacard.socorro=getCheckboxValue(sCols[sLoadMap.get("socorro")]);
		datacard.salud=getCheckboxValue(sCols[sLoadMap.get("salud")]);
		datacard.educacion=getCheckboxValue(sCols[sLoadMap.get("educacion")]);
		datacard.agropecuario=getCheckboxValue(sCols[sLoadMap.get("agropecuario")]);
		datacard.industrias=getCheckboxValue(sCols[sLoadMap.get("industrias")]);
		datacard.acueducto=getCheckboxValue(sCols[sLoadMap.get("acueducto")]);
		datacard.alcantarillado=getCheckboxValue(sCols[sLoadMap.get("alcantarillado")]);
		datacard.energia=getCheckboxValue(sCols[sLoadMap.get("energia")]);
		datacard.comunicaciones=getCheckboxValue(sCols[sLoadMap.get("comunicaciones")]);
		if (datacard.not_null(request.getParameter("causa_fixed")).length()>0) 
			datacard.causa=request.getParameter("causa_fixed");
		else
			datacard.causa=sCols[sLoadMap.get("causa")];
		if (datacard.not_null(request.getParameter("descausa_fixed")).length()>0) 
			datacard.descausa=request.getParameter("descausa_fixed");
		else
			datacard.descausa=sCols[sLoadMap.get("descausa")];
		datacard.transporte=datacard.extendedParseInt(sCols[sLoadMap.get("transporte")]);
		if (datacard.not_null(request.getParameter("magnitud2_fixed")).length()>0) 
			datacard.magnitud2=request.getParameter("magnitud2_fixed");
		else
			datacard.magnitud2=sCols[sLoadMap.get("magnitud2")];
		datacard.nhospitales=datacard.extendedParseInt(sCols[sLoadMap.get("nhospitales")]);
		datacard.nescuelas=datacard.extendedParseInt(sCols[sLoadMap.get("nescuelas")]);
		datacard.nhectareas=datacard.extendedParseDouble(sCols[sLoadMap.get("nhectareas")]);
		datacard.cabezas=datacard.extendedParseInt(sCols[sLoadMap.get("cabezas")]);
		datacard.kmvias=datacard.extendedParseDouble(sCols[sLoadMap.get("kmvias")]);
		if (datacard.not_null(request.getParameter("duracion_fixed")).length()>0) 
			datacard.duracion=datacard.extendedParseInt(request.getParameter("duracion_fixed"));
		else
			datacard.duracion=datacard.extendedParseInt(sCols[sLoadMap.get("duracion")]);

		datacard.damnificados=datacard.extendedParseInt(sCols[sLoadMap.get("damnificados")]);
		datacard.evacuados=datacard.extendedParseInt(sCols[sLoadMap.get("evacuados")]);
		datacard.reubicados=datacard.extendedParseInt(sCols[sLoadMap.get("reubicados")]);		
		datacard.hay_damnificados=getCheckboxValue(sCols[sLoadMap.get("hay_damnificados")]);
		datacard.hay_evacuados=getCheckboxValue(sCols[sLoadMap.get("hay_evacuados")]);
		datacard.hay_reubicados=getCheckboxValue(sCols[sLoadMap.get("hay_reubicados")]);
		
		datacard.latitude=datacard.extendedParseDouble(sCols[sLoadMap.get("latitude")]);		
		datacard.longitude=datacard.extendedParseDouble(sCols[sLoadMap.get("longitude")]);		

	}


	void startMap()
	{
		sLoadMap.put("serial", nMaxCols);
		sLoadMap.put("level0", nMaxCols);
		sLoadMap.put("level1", nMaxCols);
		sLoadMap.put("level2", nMaxCols);
		sLoadMap.put("name0", nMaxCols);
		sLoadMap.put("name1", nMaxCols);
		sLoadMap.put("name2", nMaxCols);
		sLoadMap.put("evento", nMaxCols);
		sLoadMap.put("lugar", nMaxCols);
		sLoadMap.put("fechano", nMaxCols);
		sLoadMap.put("fechames", nMaxCols);
		sLoadMap.put("fechadia", nMaxCols);
		sLoadMap.put("date", nMaxCols);
		sLoadMap.put("muertos", nMaxCols);
		sLoadMap.put("heridos", nMaxCols);
		sLoadMap.put("desaparece", nMaxCols);
		sLoadMap.put("afectados", nMaxCols);
		sLoadMap.put("vivdest", nMaxCols);
		sLoadMap.put("vivafec", nMaxCols);
		sLoadMap.put("otros", nMaxCols);
		sLoadMap.put("fuentes", nMaxCols);
		sLoadMap.put("valorloc", nMaxCols);
		sLoadMap.put("valorus", nMaxCols);
		sLoadMap.put("fechapor", nMaxCols);
		sLoadMap.put("fechafec", nMaxCols);
		sLoadMap.put("hay_muertos", nMaxCols);
		sLoadMap.put("hay_heridos", nMaxCols);
		sLoadMap.put("hay_deasparece", nMaxCols);
		sLoadMap.put("hay_afectados", nMaxCols);
		sLoadMap.put("hay_vivdest", nMaxCols);
		sLoadMap.put("hay_vivafec", nMaxCols);
		sLoadMap.put("hay_otros", nMaxCols);
		sLoadMap.put("socorro", nMaxCols);
		sLoadMap.put("salud", nMaxCols);
		sLoadMap.put("educacion", nMaxCols);
		sLoadMap.put("agropecuario", nMaxCols);
		sLoadMap.put("industrias", nMaxCols);
		sLoadMap.put("acueducto", nMaxCols);
		sLoadMap.put("alcantarillado", nMaxCols);
		sLoadMap.put("energia", nMaxCols);
		sLoadMap.put("comunicaciones", nMaxCols);
		sLoadMap.put("causa", nMaxCols);
		sLoadMap.put("descausa", nMaxCols);
		sLoadMap.put("transporte", nMaxCols);
		sLoadMap.put("magnitud2", nMaxCols);
		sLoadMap.put("nhospitales", nMaxCols);
		sLoadMap.put("nescuelas", nMaxCols);
		sLoadMap.put("nhectareas", nMaxCols);
		sLoadMap.put("cabezas", nMaxCols);
		sLoadMap.put("kmvias", nMaxCols);
		sLoadMap.put("duracion", nMaxCols);
		sLoadMap.put("damnificados", nMaxCols);
		sLoadMap.put("evacuados", nMaxCols);
		sLoadMap.put("hay_damnificados", nMaxCols);
		sLoadMap.put("hay_evacuados", nMaxCols);
		sLoadMap.put("hay_reubicados", nMaxCols);
		sLoadMap.put("reubicados", nMaxCols);
		sLoadMap.put("glide", nMaxCols);
		sLoadMap.put("di_comments", nMaxCols);
		sLoadMap.put("uu_id", nMaxCols);
		sLoadMap.put("latitude", nMaxCols);
		sLoadMap.put("longitude", nMaxCols);

	}
	// Myanmar
	public  void protoMap()
	{
		startMap();
	}


	public  void initProtoMap(Connection con, DICountry countrybean)
	{	
		startMap();
		
		extended.loadExtension(con, countrybean);
		// allocates a dictionary object to read each field, puts all extended fields in the load map
		Dictionary dct = new Dictionary();
		for (int j = 0; j < extended.vFields.size(); j++)
			{
			dct = (Dictionary) extended.vFields.get(j);
			sLoadMap.put(dct.nombre_campo, nMaxCols);
			}

	}

	public ExcelLoader()
	{
	}
	
	
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		//String sFileToLoad="C:/bases_6/Indonesia1996/Indonesia Disaster Data 2002_2006.xls";
		
		ExcelLoader elLoader=new ExcelLoader();
		
		 String sFileToLoad="C:/bases_6/MyanmarPONJA/Operational dataV2.xls";		
		//String sDbDriverName = "sun.jdbc.odbc.JdbcOdbcDriver";
		//pooledConnection pc=new pooledConnection(sDbDriverName, "jdbc:odbc:inventID2",null,null);
		
		String sDbDriverName = "com.microsoft.jdbc.sqlserver.SQLServerDriver";
		pooledConnection pc=new pooledConnection(sDbDriverName, "jdbc:microsoft:sqlserver://localhost:1433;DatabaseName=myanmar_ki_leader","sa","sapasswd");
		
		
		pc.getConnection();
		Connection con=pc.connection;
        
			
		DICountry countrybean= new DICountry();
		countrybean.country.scountryid="PO";
//		countrybean.countryname="Indonesia";
//		countrybean.dbType=Sys.iAccessDb;
		countrybean.countryname="Myanmar";
		countrybean.dbType=Sys.iMsSqlDb;
		countrybean.setLanguage("EN");

		
		// not needed in the unit test: 
		elLoader.initProtoMap(con, countrybean);
		// unit test: 
		elLoader.protoMap();
		HttpServletRequest request=null;
		elLoader.loadFile (sFileToLoad, con, countrybean, null);
	}

}
