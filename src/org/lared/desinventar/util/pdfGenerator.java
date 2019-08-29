package org.lared.desinventar.util;

import java.awt.Color;
import java.io.FileOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;

import com.itextpdf.text.Chunk;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Font;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.Image;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;


import java.net.*;

public class pdfGenerator {


	  public Paragraph varFontParagraph(String sTxt, int nSize, boolean bold)
	  {
	      Paragraph p = new Paragraph();
	     
	      Font f = new Font();
	      f.setFamily("HELVETICA");
	      f.setSize(nSize);
	      if (bold)
	    	  f.setStyle(f.BOLD);
	      Chunk ch =new Chunk(sTxt, f);
	      p.add(ch);
	      return p;
	  }

	  public Paragraph smallFontParagraph(String sTxt)
	  {
		  return varFontParagraph(sTxt, 6,false);
	  }
	  public Paragraph littleFontParagraph(String sTxt)
	  {
		  return varFontParagraph(sTxt, 8,false);
	  }
	  public Paragraph mediumFontParagraph(String sTxt)
	  {
		  return varFontParagraph(sTxt, 10,false);
	  }
	  public Paragraph largeFontParagraph(String sTxt)
	  {
		  return varFontParagraph(sTxt, 12,true);
	  }
	  public Paragraph titleFontParagraph(String sTxt)
	  {
		  return varFontParagraph(sTxt, 14,false);
	  }


	public void outWithContentLength()
	{
		Document document = new Document();
		try {
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		PdfWriter.getInstance(document, baos);
		document.open();
		document.add(new Paragraph("whatever"));
		document.close();

		/* 
		 
	    response.setContentType("application/pdf");
		response.setContentLength(baos.size());
		ServletOutputStream out = response.getOutputStream();
		baos.writeTo(out);
		out.flush();
		 */
		} catch (DocumentException de) {
			System.err.println(de.getMessage());
		} catch (Exception ioe) {
			System.err.println(ioe.getMessage());
		}

		// step 5: we close the document
		document.close();

	}
	
	/**
	 * Generates a PDF file with the text 'Hello World'
	 * 
	 * @param args no arguments needed here
	 */
	public static void main(String[] args) 
	{


		// step 1: creation of a document-object
		Document document = new Document();
		try {
			// step 2:
			// we create a writer that listens to the document
			// and directs a PDF-stream to a file
			PdfWriter.getInstance(document,
					new FileOutputStream("/temp/bugwork/HelloWorld.pdf"));

			// PdfWriter.getInstance(document, response.getOutputStream());
            // response.setContentType("application/pdf");

			// step 3: we open the document
			document.open();
			// metadata
			document.addTitle("DesInventar Country Profile");
			document.addAuthor("JS, LA RED, UNDP, GRIP, OSSO and others");
			document.addSubject("This Country Profile shows a set of typical results known as \"Preliminary Analysis\" comming from the disaster database. Charts, Maps and tables below will provide you with a basic understanding of the effects of many types of natural disasters occurred in the region. ");
			document.addKeywords("DesInventar, Country, Profile, Hazard, Risk, damage, loss, vulnerability");
			document.addCreator("Julio Serje");
			
            document.add(new Paragraph("A map of Iran:"));
			document.add(new Paragraph("This Country Profile shows a set of typical results known as \"Preliminary Analysis\" comming from the disaster database. Charts, Maps and tables below will provide you with a basic understanding of the effects of many types of natural disasters occurred in the region. "));
            
            URL imgURL=new URL("https://www.desinventar.net/DesInventar/jsmapserv?bookmark=1&countrycode=ir&BBOX=44.037009375%2C25.0652734375%2C63.3320625%2C39.776734375&level=0&level_map=1&transparencyf=1&lang=EN&logic=AND&sortby=0&sExpertVariable=&frompage=/thematic_def.jsp&_range=,1.0,5.0,13.0,29.0,90.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0&_color=%23ffff88,%23ffcc00,%23ff8800,%23ff0000,%23bb0000,%23770000,,,,,,,,,&_legend=,,,,,,,,,,,,,,&chartColor=1&chartX=512&chartY=512&chartTitle=&chartSubTitle=&showValues=0&legendType=0&level_rep=0&level_map=1&_variables=fichas.muertos&LAYERS=effects%2Clevel0&TRANSPARENT=true&FORMAT=png&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&SRS=EPSG:4326&WIDTH=512&HEIGHT=390");            
            Image jpg = Image.getInstance(imgURL);
           // document.add(jpg);
            
            imgURL=new URL("https://www.desinventar.net/DesInventar/MapLegendServer?bookmark=1&countrycode=ir&BBOX=44.037009375%2C25.0652734375%2C63.3320625%2C39.776734375&level=0&level_map=1&transparencyf=1&lang=EN&logic=AND&sortby=0&sExpertVariable=&frompage=/thematic_def.jsp&_range=,1.0,5.0,13.0,29.0,90.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0&_color=%23ffff88,%23ffcc00,%23ff8800,%23ff0000,%23bb0000,%23770000,,,,,,,,,&_legend=,,,,,,,,,,,,,,&chartColor=1&chartX=512&chartY=512&chartTitle=&chartSubTitle=&showValues=0&legendType=0&level_rep=0&level_map=1&_variables=fichas.muertos&LAYERS=effects%2Clevel0&TRANSPARENT=true&FORMAT=png&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&SRS=EPSG:4326&WIDTH=512&HEIGHT=390");
            Image jpg2 = Image.getInstance(imgURL);
            //document.add(jpg2);

            float[] relativeWidths={1.5f,8.0f};
            PdfPTable table = new PdfPTable(relativeWidths);
            PdfPCell cell =
              new PdfPCell(new Paragraph("Mortality"));
            cell.setColspan(2);
            cell.setBorderColor(new BaseColor(255, 255, 255));			
            table.addCell(cell);

            
            jpg2.scalePercent(50f);
            cell =new PdfPCell(jpg2,false);
            cell.setBorderColor(new BaseColor(255, 255, 255));
            table.addCell(cell);
            jpg.scalePercent(70f);
            cell =new PdfPCell(jpg,false);
            cell.setBorderColor(new BaseColor(255, 255, 255));
            cell.setColspan(7);
            table.addCell(cell);
            document.add(table);
            
			// step 4: we add a paragraph to the document
			document.add(new Paragraph("Hello World"));
		} catch (DocumentException de) {
			System.err.println(de.getMessage());
		} catch (IOException ioe) {
			System.err.println(ioe.getMessage());
		}

		// step 5: we close the document
		document.close();
	}
}