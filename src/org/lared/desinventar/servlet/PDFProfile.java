package org.lared.desinventar.servlet;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.sql.*;
import java.text.*;
import java.util.*;
import java.net.*;

import org.lared.desinventar.webobject.*;
import org.lared.desinventar.util.*;
import org.lared.desinventar.map.*;
import org.lared.desinventar.system.Sys;

import java.awt.Color;
import java.io.FileOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.Image;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfLine;
import com.itextpdf.text.Chunk;
import com.itextpdf.text.Font;
import com.itextpdf.text.Element;




public final class PDFProfile 
   extends GenericServlet
{

  public String getServletInfo() 
  {
    return "PDF profile generator of DesConsultar On-Line";
  }

  
  public Paragraph varFontParagraph(String sTxt, int nSize, boolean bold)
  {
      Paragraph p = new Paragraph();
     
      Font f = new Font();
      f.setFamily("Helvetica");
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
  
  public Paragraph smallFontParagraph(String sTxt, boolean bold)
  {
	  return varFontParagraph(sTxt, 6, bold);
  }
  
  public Paragraph littleFontParagraph(String sTxt)
  {
	  return varFontParagraph(sTxt, 8,false);
  }

  public Paragraph littleFontParagraph(String sTxt, boolean bold)
  {
	  return varFontParagraph(sTxt, 8,bold);
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
	  return varFontParagraph(sTxt, 14,true);
  }
  
  public void service(ServletRequest request, ServletResponse response) throws IOException
  {

    JspFactory _jspxFactory = null;
    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;


    try {
      _jspxFactory = JspFactory.getDefaultFactory();
      pageContext = _jspxFactory.getPageContext(this, request, response, null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();

DICountry countrybean=new DICountry(); 
Sys.getProperties();
countrybean.init();
// load language code (if available)
if (request.getParameter("lang")!=null)
	countrybean.setLanguage(request.getParameter("lang"));
// load DATA language code (if available)
if (request.getParameter("datalng")!=null)
	countrybean.setDataLanguage(request.getParameter("datalng"));
String sSuffix=countrybean.getLocalOrEnglish("","_en");
String sDetails="";
String sSqlDetails="";
// load geographic unit spec (if available)
boolean bGeo=false;
String sLevel0="";
if (request.getParameter("_level0")!=null)
	{
	bGeo=true;
	sLevel0=request.getParameter("_level0");
	sDetails="&_level0="+sLevel0;
    sSqlDetails=" AND fichas.level0='"+sLevel0+"'";
	}
// load event type spec (if available)
boolean bHazard=false;
String sHazard="";
if (request.getParameter("_eventos")!=null)
	{
	bHazard=true;
	sHazard=request.getParameter("_eventos"); // already in DI-URL encode form
	sDetails+="&_eventos="+sHazard;
	countrybean.asEventos = countrybean.loadArrayParameter((HttpServletRequest)request, "eventos");
	countrybean.bHayEventos = (countrybean.asEventos!=null);	
	sHazard=countrybean.asEventos[0];
	sSqlDetails+=" AND fichas.evento='"+sHazard+"'";
	}
// gets this URL
String sRequest=new String(((HttpServletRequest)request).getRequestURL());
// gets the hostname
URL thisURL=new URL(sRequest);
   String sHost="http://"+thisURL.getHost();
int nPort=request.getLocalPort();
if (nPort!=80)
   sHost+=":"+nPort;
String  sSql="";
String sRealPath=getServletConfig().getServletContext().getRealPath("/");
request.setCharacterEncoding("UTF-8"); 
// load country code (if available)
if (request.getParameter("countrycode")!=null)
	{
	countrybean.init();
	countrybean.countrycode=request.getParameter("countrycode");
	// Load the country object from the DesInventar (default) database
	dbConnection dbDefaultCon; 
	Connection dcon; 
	boolean bdConnectionOK=false; 
	// opens the Default database 
	dbDefaultCon=new dbConnection();
	bdConnectionOK = dbDefaultCon.dbGetConnectionStatus();
	if (bdConnectionOK)
		{
		dcon=dbDefaultCon.dbGetConnection();
		}  // opening dB!!
	else
		{
        // do something else: _jspx_page_context.forward("/connectionError.jsp");
        return;
		}
	// now it should read the names of the levels. 
	// It is done in the bean, so it can be reused as properties...
	countrybean.country.scountryid=countrybean.countrycode;
	countrybean.country.getWebObject(dcon);
	countrybean.countryname=countrybean.country.scountryname;
	countrybean.dbType=countrybean.country.ndbtype;
	// MUST return this connection!
	dbDefaultCon.close();
	}
// checks for a session alive variable
else if (countrybean.countrycode.length()==0)
	{
        return;
	}	

// Declaration of default Dabatase variables available to the page 
dbConnection dbCon=null;
// this is just a shortcut, easier to remember
int dbType=countrybean.country.ndbtype; 
Connection con=null; 
Statement stmt=null; 
ResultSet rset=null; 
boolean bConnectionOK=false; 
// opens the database 
dbCon=new dbConnection(countrybean.country.sdriver,countrybean.country.sdatabasename,
                      countrybean.country.susername,countrybean.country.spassword);
bConnectionOK = dbCon.dbGetConnectionStatus();
if (bConnectionOK)
	{	
	con=dbCon.dbGetConnection();
	// now it should read the names of the levels. 
	countrybean.getLevelsFromDB(con);
	}
else
	{
        //_jspx_page_context.forward("/connectionError.jsp");
        return;
	}	

response.setContentType("application/pdf");
request.setCharacterEncoding("UTF-8"); 
//  depending where it is comming from, loads different parameters...
String strFromPage=countrybean.not_null(request.getParameter("frompage"));
parser Parser=new parser();
countrybean.processParams((HttpServletRequest)request, Parser, con);
if (bHazard)
	{
	eventos evUnit=new eventos();
	evUnit.nombre=sHazard;
	evUnit.getWebObject(con);
	countrybean.asEventos=new String[1];
	countrybean.asEventos[0]=sHazard;
	countrybean.bHayEventos=true;
	countrybean.countryname+="  - "+countrybean.getLocalOrEnglish(evUnit.nombre,evUnit.nombre_en);
	}
if (bGeo)
	{
	lev0 geoUnit=new lev0();
	geoUnit.lev0_cod=sLevel0;
	geoUnit.getWebObject(con);
	countrybean.asNivel0=new String[1];
	countrybean.asNivel0[0]=sLevel0;
	countrybean.bHayNivel0=true;
	countrybean.countryname+="  -  "+countrybean.getLocalOrEnglish(geoUnit.lev0_name,geoUnit.lev0_name_en);
	}
countrybean.country.scountryname=countrybean.countryname;

Document document = new Document();
ByteArrayOutputStream baos = new ByteArrayOutputStream();
PdfWriter.getInstance(document, baos);
document.open();

document.addTitle(countrybean.getTranslation("Profile"));
document.addAuthor("JS, LA RED, UNISDR, UNDP, GAR and others");
document.addSubject(countrybean.getTranslation("ExplainProfile"));
document.addKeywords("DesInventar, Country, Profile, Hazard, Risk, damage, loss, vulnerability");
document.addCreator("See Database owner in main page. Software by Julio Serje");

document.add(titleFontParagraph(countrybean.countryname));

document.add(smallFontParagraph("\n"+countrybean.getTranslation("ExplainProfile")+"\r\n\n"));
// Obtain basic statistics
boolean bKilled=true;
boolean bHousing=true;
boolean bAffected=true;
sSql="SELECT sum(1) as nrecs, sum(0.0+fichas.muertos) as killed, sum(0.0+fichas.vivdest)+sum(0.0+fichas.vivafec) as housing, sum(0.0+fichas.damnificados)+sum(0.0+fichas.afectados) as affected from fichas where  (fichas.approved is null or fichas.approved=0)";
try{
	  stmt=con.createStatement();
	  rset=stmt.executeQuery(sSql);
	  if (rset.next())
	  	{
		bHousing=(rset.getInt("housing")>0);
		bAffected=(rset.getInt("affected")>0);
		}
	 rset.close();
 	 stmt.close();
	 }
catch (Exception eSql)
	{
	System.out.println("ERR: "+eSql.toString()+" -->");
	}	 



// Composition only makes sense for multi-hazard profiles...
if (!bHazard)
{
	document.add(largeFontParagraph("\r\n"+countrybean.getTranslation("Composition of Disasters")+"\r\n\r\n"));
		
    float[] relativeWidths={1.0f,1.0f};
    PdfPTable table = new PdfPTable(relativeWidths);
    table.setWidthPercentage(100f);


    PdfPCell cell =  new PdfPCell(littleFontParagraph(countrybean.getTranslation("Deaths")));
    cell.setBorderColor(new BaseColor(255, 255, 255));			
    table.addCell(cell);
    cell =  new PdfPCell(littleFontParagraph(countrybean.getTranslation("DataCards")));
    cell.setBorderColor(new BaseColor(255, 255, 255));			
    table.addCell(cell);

    
    URL imgURL=new URL(sHost+"/DesInventar/GraphServer?bookmark=1&countrycode="+countrybean.countrycode+"&lang="+countrybean.getLanguage()+"&datalng="+countrybean.getDataLanguage()
    		+"&logic=AND&sortby=0&frompage=/graphics.jsp&chartType=5&chartMode=3&chartSubMode=1&periodType=1&seasonType=4&chart3D=1&chartColor=1&chartX=500&chartY=400&chartTitle=&chartSubTitle=&chartMaxY=0.0&chartMaxY=0.0&chartRanges=50&_color=%2300BFFF,%23FF8C00,%23006400,%23800000,%23FF1493,%2300FFFF,%23CD5C5C,%23FFA07A,%2300FF7A,%23A07AFF,,,,,&_variables=fichas.muertos"
    		+sDetails);            
    Image jpg = Image.getInstance(imgURL);
    jpg.scalePercent(50f);
    cell =new PdfPCell(jpg,false);
    cell.setBorderColor(new BaseColor(255, 255, 255));
    table.addCell(cell);

    imgURL=new URL(sHost+"/DesInventar/GraphServer?bookmark=1&countrycode="+countrybean.countrycode+"&lang="+countrybean.getLanguage()+"&datalng="+countrybean.getDataLanguage()
    		+"&logic=AND&sortby=0&frompage=/graphics.jsp&chartType=5&chartMode=3&chartSubMode=1&periodType=1&seasonType=4&chart3D=1&chartColor=1&chartX=500&chartY=400&chartTitle=&chartSubTitle=&chartMaxY=0.0&chartMaxY=0.0&chartRanges=50&_color=%2300BFFF,%23FF8C00,%23006400,%23800000,%23FF1493,%2300FFFF,%23CD5C5C,%23FFA07A,%2300FF7A,%23A07AFF,,,,,&_variables=1"
    	    +sDetails);            
    jpg = Image.getInstance(imgURL);
    jpg.scalePercent(50f);
    cell =new PdfPCell(jpg,false);
    cell.setBorderColor(new BaseColor(255, 255, 255));
    table.addCell(cell);

	

	if (bAffected){
	      cell =  new PdfPCell(littleFontParagraph(countrybean.getTranslation("Affected")));
	      cell.setBorderColor(new BaseColor(255, 255, 255));			
	      table.addCell(cell);
	 }
	
	if (bHousing){
	      cell =  new PdfPCell(littleFontParagraph(countrybean.getTranslation("DestroyedHouses")+" + "+countrybean.getTranslation("AffectedHouses")));
	      cell.setBorderColor(new BaseColor(255, 255, 255));			
	      table.addCell(cell);
	 }
	
	int nCellsHere=0;
	if (bAffected){
	    imgURL=new URL(sHost+"/DesInventar/GraphServer?bookmark=1&countrycode="+countrybean.countrycode+"&lang="+countrybean.getLanguage()+"&datalng="+countrybean.getDataLanguage()
	    		+"&logic=AND&sortby=0&frompage=/graphics.jsp&chartType=5&chartMode=3&chartSubMode=1&periodType=1&seasonType=4&chart3D=1&chartColor=1&chartX=500&chartY=400&chartTitle=&chartSubTitle=&chartMaxY=0.0&chartMaxY=0.0&chartRanges=50&_color=%2300BFFF,%23FF8C00,%23006400,%23800000,%23FF1493,%2300FFFF,%23CD5C5C,%23FFA07A,%2300FF7A,%23A07AFF,,,,,&_variables=fichas.afectados,fichas.damnificados"
	    	    +sDetails);            
	    jpg = Image.getInstance(imgURL);
	    jpg.scalePercent(50f);
	    cell =new PdfPCell(jpg);
	    cell.setBorderColor(new BaseColor(255, 255, 255));
	    table.addCell(cell);
	    nCellsHere++;
	 }
	if (bHousing){
	    imgURL=new URL(sHost+"/DesInventar/GraphServer?bookmark=1&countrycode="+countrybean.countrycode+"&lang="+countrybean.getLanguage()+"&datalng="+countrybean.getDataLanguage()
	    		+"&logic=AND&sortby=0&frompage=/graphics.jsp&chartType=5&chartMode=3&chartSubMode=1&periodType=1&seasonType=4&chart3D=1&chartColor=1&chartX=500&chartY=400&chartTitle=&chartSubTitle=&chartMaxY=0.0&chartMaxY=0.0&chartRanges=50&_color=%2300BFFF,%23FF8C00,%23006400,%23800000,%23FF1493,%2300FFFF,%23CD5C5C,%23FFA07A,%2300FF7A,%23A07AFF,,,,,&_variables=fichas.vivdest,fichas.vivafec"
	    	    +sDetails);            
	    jpg = Image.getInstance(imgURL);
	    jpg.scalePercent(50f);
	    cell =new PdfPCell(jpg);
	    cell.setBorderColor(new BaseColor(255, 255, 255));
	    table.addCell(cell);
	    nCellsHere++;
	} // end of COmposition analysis. Temporal analysis ALWAYS applies
	if (nCellsHere==1)
	{
	    cell =new PdfPCell(new Paragraph(""));
	    cell.setBorderColor(new BaseColor(255, 255, 255));
	    table.addCell(cell);	
	}

	document.add(table);

	//------------------------------------

	document.newPage();
}


document.add(largeFontParagraph("\r\n"+countrybean.getTranslation("Temporal Behaviour")+"\r\n"));

document.add(littleFontParagraph(countrybean.getTranslation("Deaths")));
URL imgURL=new URL(sHost+"/DesInventar/GraphServer?bookmark=1&countrycode="+countrybean.countrycode+"&lang="+countrybean.getLanguage()+"&datalng="+countrybean.getDataLanguage()
		+"&logic=AND&sortby=0&frompage=/graphics.jsp&chartType=1&chartMode=2&chartSubMode=1&periodType=1&seasonType=4&chart3D=1&chartColor=1&chartX=700&chartY=250&chartTitle=&chartSubTitle=&chartMaxY=0.0&chartMaxY=0.0&chartRanges=50&_color=%2300BFFF,%23FF8C00,%23006400,%23800000,%23FF1493,%2300FFFF,%23CD5C5C,%23FFA07A,%2300FF7A,%23A07AFF,,,,,&_variables=fichas.muertos&bRegression=Y"
		+sDetails);            
Image jpg = Image.getInstance(imgURL);
jpg.scalePercent(60f);
document.add(jpg);


document.add(littleFontParagraph(countrybean.getTranslation("DataCards")));
imgURL=new URL(sHost+"/DesInventar/GraphServer?bookmark=1&countrycode="+countrybean.countrycode+"&lang="+countrybean.getLanguage()+"&datalng="+countrybean.getDataLanguage()
		+"&logic=AND&sortby=0&frompage=/graphics.jsp&chartType=1&chartMode=2&chartSubMode=1&periodType=1&seasonType=4&chart3D=1&chartColor=1&chartX=700&chartY=250&chartTitle=&chartSubTitle=&chartMaxY=0.0&chartMaxY=0.0&chartRanges=50&_color=%2322aa00,%23FF8C00,%23006400,%23800000,%23FF1493,%2300FFFF,%23CD5C5C,%23FFA07A,%2300FF7A,%23A07AFF,,,,,&_variables=1&bRegression=Y"
		+sDetails);            
jpg = Image.getInstance(imgURL);
jpg.scalePercent(60f);
document.add(jpg);

 if (bHousing){
	 document.add(littleFontParagraph(countrybean.getTranslation("DestroyedHouses")+" - "+countrybean.getTranslation("AffectedHouses")));
	 imgURL=new URL(sHost+"/DesInventar/GraphServer?bookmark=1&countrycode="+countrybean.countrycode+"&lang="+countrybean.getLanguage()
	 		+"&logic=AND&sortby=0&frompage=/graphics.jsp&chartType=9&chartMode=2&chartSubMode=2&periodType=1&seasonType=4&chart3D=1&chartColor=1&chartX=700&chartY=250&chartTitle=&chartSubTitle=&chartMaxY=0.0&chartMaxY=0.0&chartRanges=50&_color=%2300BFFF,%23FF8C00,%23006400,%23800000,%23FF1493,%2300FFFF,%23CD5C5C,%23FFA07A,%2300FF7A,%23A07AFF,,,,,&_variables=fichas.vivdest,fichas.vivafec&bRegression=Y"
	 		+sDetails);            
	 jpg = Image.getInstance(imgURL);
	 jpg.scalePercent(60f);
	 document.add(jpg);
	 }

 if (bAffected){
	
	 document.add(littleFontParagraph(countrybean.getTranslation("Affected")));
	 imgURL=new URL(sHost+"/DesInventar/GraphServer?bookmark=1&countrycode="+countrybean.countrycode+"&lang="+countrybean.getLanguage()
	 		+"&logic=AND&sortby=0&frompage=/graphics.jsp&chartType=9&chartMode=2&chartSubMode=2&periodType=1&seasonType=4&chart3D=1&chartColor=1&chartX=700&chartY=250&chartTitle=&chartSubTitle=&chartMaxY=0.0&chartMaxY=0.0&chartRanges=50&_color=%2322aa00,%23FF8C00,%23006400,%23800000,%23FF1493,%2300FFFF,%23CD5C5C,%23FFA07A,%2300FF7A,%23A07AFF,,,,,&_variables=fichas.afectados,fichas.damnificados&bRegression=Y"
	 		+sDetails);            
	 jpg = Image.getInstance(imgURL);
	 jpg.scalePercent(60f);
	 document.add(jpg);
     }

 
//------------------------------------
document.newPage();

int level_map=1;
int level_rep=0;

double xm=-180;
double ym=-90;
double xx=180;
double yy=90;
MapTransformation mt=new MapTransformation();

countrybean.getLevelsFromDB(con);
MapUtil.getExtents(countrybean.level_rep, sLevel0, mt, con, countrybean);
xm=mt.xminif;
ym=mt.yminif;
xx=mt.xmaxif;
yy=mt.ymaxif;
String sMapSize="&WIDTH=512&HEIGHT=512";

if (yy-ym>0 && xx-xm>0)
  if (yy-ym<xx-xm)
	sMapSize="&WIDTH=512&HEIGHT="+( (int) (512 * ((yy-ym)/(xx-xm))));
  else
	sMapSize="&HEIGHT=512&WIDTH="+( (int) (512 * ((xx-xm)/(yy-ym))));

int nTransf=0;
if (countrybean.lmMaps[0]!=null) // default DI map with scaling by 10000 transformation... TODO: check transf type
	nTransf=countrybean.extendedParseInt(countrybean.lmMaps[0].filetype);
if (nTransf==0)
	    {
        xm/=10000.0;
        ym/=10000.0;
	    xx/=10000.0;
	    yy/=10000.0;
    	}

	// calculate the bounding box:
	String bBox="BBOX="+xm+"%2C"+ym+"%2C"+xx+"%2C"+yy;
	countrybean.asVariables=new String[1];
	
	countrybean.asVariables[0]="fichas.Muertos as \""+countrybean.getTranslation("Deaths")+"\"";
	countrybean.bHayVariables = true;
    // this heuristically tries to suggest a good mapping level
	level_map=MapUtil.calculateBestLevel(con, countrybean);
	countrybean.level_map=level_map;
    MapUtil.calculateRanges("isolegend",con,countrybean);
	String sRanges="";
	for (int j=0; j<countrybean.asMapRanges.length; j++)
		sRanges+=","+countrybean.asMapRanges[j];	
// maps only make sense if there is detail available
if (!bGeo || (level_map>0))
{
	document.add(largeFontParagraph(countrybean.getTranslation("Spatial Distribution")+"\r\n"));

	String sLargeURL="?bookmark=1&countrycode="+countrybean.countrycode+"&"+bBox+"&level="+level_rep+"&level_map="+level_map+"&transparencyf=1&lang="+countrybean.getLanguage()
    +"&logic=AND&sortby=0&sExpertVariable=&frompage=/thematic_def.jsp&_range="+sRanges
    +"&_color=%23ffff88,%23ffcc00,%23ff8800,%23ff0000,%23bb0000,%23770000,,,,,,,,,&_legend=,,,,,,,,,,,,,,&chartColor=1&chartX=512&chartY=512&chartTitle=&chartSubTitle=&showValues=0&legendType=0&level_rep=0&level_map=1&_variables=fichas.muertos&LAYERS=effects%2Clevel0&TRANSPARENT=true&FORMAT=png&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&SRS=EPSG:4326"
    +sMapSize+sDetails;
    
    imgURL=new URL(sHost+"/DesInventar/MapLegendServer"+sLargeURL);
    Image jpg2 = Image.getInstance(imgURL);
    imgURL=new URL(sHost+"/DesInventar/jsmapserv"+sLargeURL);
    jpg = Image.getInstance(imgURL);

    float[] relativeWidths={1.0f,4.0f};
    PdfPTable table = new PdfPTable(relativeWidths);
    table.setWidthPercentage(100f);
    PdfPCell cell = new PdfPCell(littleFontParagraph(countrybean.getTranslation("Deaths")));
    cell.setColspan(2);
    cell.setBorderColor(new BaseColor(255, 255, 255));			
    table.addCell(cell);
    jpg2.scalePercent(50f);
    cell =new PdfPCell(jpg2,false);
    cell.setBorderColor(new BaseColor(255, 255, 255));
    table.addCell(cell);
    jpg.scalePercent(60f);
    cell =new PdfPCell(jpg,false);
    cell.setBorderColor(new BaseColor(255, 255, 255));
    cell.setColspan(7);
    table.addCell(cell);
    document.add(table);

    
    
	countrybean.asVariables[0]="1 as \""+countrybean.getTranslation("DataCards")+"\"";
    MapUtil.calculateRanges("isolegend",con,countrybean);
	sRanges="";
	for (int j=0; j<countrybean.asMapRanges.length; j++)
		sRanges+=","+countrybean.asMapRanges[j];	
	sLargeURL="?bookmark=1&countrycode="+countrybean.countrycode+"&"+bBox+"&level="+level_rep+"&level_map="+level_map+"&transparencyf=1&lang="+countrybean.getLanguage()
    +"&logic=AND&sortby=0&sExpertVariable=&frompage=/thematic_def.jsp&_range="+sRanges
    +"&_color=%23e4dacc,%23c9b499,%23ad8f66,%23926933,%23774400,%233c2200,,,,,,,,,&_legend=,,,,,,,,,,,,,,&chartColor=1&chartX=512&chartY=512&chartTitle=&chartSubTitle=&showValues=0&legendType=0&level_rep=0&level_map=1&_variables=1&LAYERS=effects%2Clevel0&TRANSPARENT=true&FORMAT=png&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&SRS=EPSG:4326&"
    +sMapSize+sDetails;
    
    imgURL=new URL(sHost+"/DesInventar/MapLegendServer"+sLargeURL);
    jpg2 = Image.getInstance(imgURL);
    imgURL=new URL(sHost+"/DesInventar/jsmapserv"+sLargeURL);
    jpg = Image.getInstance(imgURL);

    table = new PdfPTable(relativeWidths);
    table.setWidthPercentage(100f);
    cell = new PdfPCell(littleFontParagraph(countrybean.getTranslation("DataCards")));
    cell.setColspan(2);
    cell.setBorderColor(new BaseColor(255, 255, 255));			
    table.addCell(cell);
    jpg2.scalePercent(50f);
    cell =new PdfPCell(jpg2,false);
    cell.setBorderColor(new BaseColor(255, 255, 255));
    table.addCell(cell);
    jpg.scalePercent(60f);
    cell =new PdfPCell(jpg,false);
    cell.setBorderColor(new BaseColor(255, 255, 255));
    cell.setColspan(7);
    table.addCell(cell);
    document.add(table);

  //------------------------------------
    document.newPage();
 
    if (bHousing)
    {
    countrybean.asVariables=new String[2];
	countrybean.asVariables[0]="fichas.vivdest";
	countrybean.asVariables[1]="fichas.vivafec";
    MapUtil.calculateRanges("isolegend",con,countrybean);
	sRanges="";
	for (int j=0; j<countrybean.asMapRanges.length; j++)
		sRanges+=","+countrybean.asMapRanges[j];	

	sLargeURL="?bookmark=1&countrycode="+countrybean.countrycode+"&"+bBox+"&level="+level_rep+"&level_map="+level_map+"&transparencyf=1&lang="+countrybean.getLanguage()
    +"&logic=AND&sortby=0&sExpertVariable=&frompage=/thematic_def.jsp&_range="+sRanges
    +"&_color=%23cce7cc,%2399cf99,%2366b866,%2333a033,%23008800,%23004400,,,,,,,,,&_legend=,,,,,,,,,,,,,,&chartColor=1&chartX=512&chartY=512&chartTitle=&chartSubTitle=&showValues=0&legendType=0&level_rep=0&level_map=1&_variables=fichas.vivdest&LAYERS=effects%2Clevel0&TRANSPARENT=true&FORMAT=png&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&SRS=EPSG:4326"
    +sMapSize+sDetails;
    
    imgURL=new URL(sHost+"/DesInventar/MapLegendServer"+sLargeURL);
    jpg2 = Image.getInstance(imgURL);
    imgURL=new URL(sHost+"/DesInventar/jsmapserv"+sLargeURL);
    jpg = Image.getInstance(imgURL);

    table = new PdfPTable(relativeWidths);
    table.setWidthPercentage(100f);
    cell = new PdfPCell(littleFontParagraph(countrybean.getTranslation("DestroyedHouses")+" + "+countrybean.getTranslation("AffectedHouses")));
    cell.setColspan(2);
    cell.setBorderColor(new BaseColor(255, 255, 255));			
    table.addCell(cell);
    jpg2.scalePercent(50f);
    cell =new PdfPCell(jpg2,false);
    cell.setBorderColor(new BaseColor(255, 255, 255));
    table.addCell(cell);
    jpg.scalePercent(60f);
    cell =new PdfPCell(jpg,false);
    cell.setBorderColor(new BaseColor(255, 255, 255));
    cell.setColspan(7);
    table.addCell(cell);
    document.add(table);
}

    if (bAffected)
    {
    countrybean.asVariables=new String[2];
	countrybean.asVariables[0]="fichas.afectados";
	countrybean.asVariables[1]="fichas.damnificados";
    MapUtil.calculateRanges("isolegend",con,countrybean);
	sRanges="";
	for (int j=0; j<countrybean.asMapRanges.length; j++)
		sRanges+=","+countrybean.asMapRanges[j];	

	sLargeURL="?bookmark=1&countrycode="+countrybean.countrycode+"&"+bBox+"&level="+level_rep+"&level_map="+level_map+"&transparencyf=1&lang="+countrybean.getLanguage()
    +"&logic=AND&sortby=0&sExpertVariable=&frompage=/thematic_def.jsp&_range="+sRanges
    +"&_color=%23c4dddd,%2388bbbb,%234d9999,%23117777,%230b4f4f,%23062828,,,,,,,,,&_legend=,,,,,,,,,,,,,,&chartColor=1&chartX=512&chartY=512&chartTitle=&chartSubTitle=&showValues=0&legendType=0&level_rep=0&level_map=1&_variables=fichas.afectados&LAYERS=effects%2Clevel0&TRANSPARENT=true&FORMAT=png&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&SRS=EPSG:4326"
    +sMapSize+sDetails;
    
    imgURL=new URL(sHost+"/DesInventar/MapLegendServer"+sLargeURL);
    jpg2 = Image.getInstance(imgURL);
    imgURL=new URL(sHost+"/DesInventar/jsmapserv"+sLargeURL);
    jpg = Image.getInstance(imgURL);

    table = new PdfPTable(relativeWidths);
    table.setWidthPercentage(100f);
    cell = new PdfPCell(littleFontParagraph(countrybean.getTranslation("Affected")));
	cell.setColspan(2);
    cell.setBorderColor(new BaseColor(255, 255, 255));			
    table.addCell(cell);
    jpg2.scalePercent(50f);
    cell =new PdfPCell(jpg2,false);
    cell.setBorderColor(new BaseColor(255, 255, 255));
    table.addCell(cell);
    jpg.scalePercent(60f);
    cell =new PdfPCell(jpg,false);
    cell.setBorderColor(new BaseColor(255, 255, 255));
    cell.setColspan(7);
    table.addCell(cell);
    document.add(table);
	}
    document.add(new Paragraph("\r\n"));
} // end geo section

//------------------------------------
document.newPage();

document.add(largeFontParagraph("\r\n"+countrybean.getTranslation("Statistics")+"\r\n"));
// Composition only makes sense for multi-hazard profiles...
String slabelHD=countrybean.getTranslation("DestroyedHouses").trim();
int isp=slabelHD.indexOf(" ");
if (isp>0)
 slabelHD= slabelHD.substring(0,isp)+"\r\n"+slabelHD.substring(isp);
String slabelHA=countrybean.getTranslation("AffectedHouses").trim();
isp=slabelHA.indexOf(" ");
if (isp>0)
 slabelHA= slabelHA.substring(0,isp)+"\r\n"+slabelHA.substring(isp);


if (!bHazard)
{
	
	document.add(mediumFontParagraph(countrybean.getTranslation("Composition of Disasters")+"\r\n"));
	document.add(new Paragraph("\r\n"));

	float[] relativeWidths={2.5f,1.0f,1.0f,1.0f,1.0f,1.0f,1.0f,1.0f,1.0f,1.0f,1.0f};
	PdfPTable table = new PdfPTable(relativeWidths);
	table.setWidthPercentage(100f);

    PdfPCell cell = new PdfPCell(smallFontParagraph(countrybean.getTranslation("Event"),true));
    table.addCell(cell);
    cell = new PdfPCell(smallFontParagraph(countrybean.getTranslation("DataCards"),true));
    table.addCell(cell);
    cell = new PdfPCell(smallFontParagraph(countrybean.getTranslation("Deaths"),true));
    table.addCell(cell);
    cell = new PdfPCell(smallFontParagraph(countrybean.getTranslation("Injured"),true));
    table.addCell(cell);
    cell = new PdfPCell(smallFontParagraph(countrybean.getTranslation("Missing"),true));
    table.addCell(cell);
    cell = new PdfPCell(smallFontParagraph(slabelHD,true));
    table.addCell(cell);
    cell = new PdfPCell(smallFontParagraph(slabelHA,true));
    table.addCell(cell);
    cell = new PdfPCell(smallFontParagraph(countrybean.getTranslation("Victims"),true));
    table.addCell(cell);
    cell = new PdfPCell(smallFontParagraph(countrybean.getTranslation("Affected"),true));
    table.addCell(cell);
    cell = new PdfPCell(smallFontParagraph(countrybean.getTranslation("Relocated"),true));
    table.addCell(cell);
    cell = new PdfPCell(smallFontParagraph(countrybean.getTranslation("Evacuated"),true));
    table.addCell(cell);

  sSql="SELECT eventos.nombre"+sSuffix+",sum(1) as C0L__0, sum(0.0+fichas.muertos) as C0L__1, sum(0.0+fichas.heridos) as C0L__2, sum(0.0+fichas.desaparece) as C0L__3, sum(0.0+fichas.vivdest) as C0L__4, sum(0.0+fichas.vivafec) as C0L__5, sum(0.0+fichas.damnificados) as C0L__6, sum(0.0+fichas.afectados) as C0L__7, sum(0.0+fichas.reubicados) as C0L__8, sum(0.0+fichas.evacuados) as C0L__9 from  (((((fichas left join eventos on eventos.nombre=fichas.evento) left join lev0 on lev0.lev0_cod=fichas.level0) left join lev1 on lev1.lev1_cod=fichas.level1) left join lev2 on lev2.lev2_cod=fichas.level2) left join causas on causas.causa=fichas.causa)  left join extension on fichas.clave = extension.clave_ext  where  (fichas.approved is null or fichas.approved=0) "+sSqlDetails+" group by eventos.nombre"+sSuffix+" order by eventos.nombre"+sSuffix;
  try{
	  stmt=con.createStatement();
	  rset=stmt.executeQuery(sSql);
	  while (rset.next())
	  	{
		    cell = new PdfPCell(smallFontParagraph(countrybean.not_null(rset.getString(1))));
		    table.addCell(cell);
		    for (int j=2; j<12; j++)
		    {
		    	Paragraph p=smallFontParagraph(String.valueOf(rset.getInt(j)));
		    	p.setAlignment(Element.ALIGN_RIGHT);
		    	cell = new PdfPCell(p);
		    	cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
			    table.addCell(cell);
		    }
		}
	 rset.close();
 	 stmt.close();
	 }
catch (Exception eSql)
	{
	System.out.println("<!-- "+eSql.toString()+" -->");
	}	 
  document.add(table);
}



//maps only make sense if there is detail available
if (!bGeo || (level_map>0))
{

	document.add(mediumFontParagraph(countrybean.getTranslation("Spatial Distribution")+"\r\n"));
	document.add(new Paragraph("\r\n"));

	float[] relativeWidths={2.5f,1.0f,1.0f,1.0f,1.0f,1.0f,1.0f,1.0f,1.0f,1.0f,1.0f,1.0f};   // just one more
	PdfPTable table = new PdfPTable(relativeWidths);
	table.setWidthPercentage(100f);

    PdfPCell cell = new PdfPCell(smallFontParagraph(countrybean.getTranslation("Geography"),true));
    table.addCell(cell);
    cell = new PdfPCell(smallFontParagraph(countrybean.getTranslation("Code"),true));
    table.addCell(cell);
    cell = new PdfPCell(smallFontParagraph(countrybean.getTranslation("DataCards"),true));
    table.addCell(cell);
    cell = new PdfPCell(smallFontParagraph(countrybean.getTranslation("Deaths"),true));
    table.addCell(cell);
    cell = new PdfPCell(smallFontParagraph(countrybean.getTranslation("Injured"),true));
    table.addCell(cell);
    cell = new PdfPCell(smallFontParagraph(countrybean.getTranslation("Missing"),true));
    table.addCell(cell);
    cell = new PdfPCell(smallFontParagraph(slabelHD,true));
    table.addCell(cell);
    cell = new PdfPCell(smallFontParagraph(slabelHA,true));
    table.addCell(cell);
    cell = new PdfPCell(smallFontParagraph(countrybean.getTranslation("Victims"),true));
    table.addCell(cell);
    cell = new PdfPCell(smallFontParagraph(countrybean.getTranslation("Affected"),true));
    table.addCell(cell);
    cell = new PdfPCell(smallFontParagraph(countrybean.getTranslation("Relocated"),true));
    table.addCell(cell);
    cell = new PdfPCell(smallFontParagraph(countrybean.getTranslation("Evacuated"),true));
    table.addCell(cell);



if (bGeo)
  sSql="SELECT lev1_name"+sSuffix+", max(lev1_cod) as code0,sum(1) as C0L__0, sum(0.0+fichas.muertos) as C0L__1, sum(0.0+fichas.heridos) as C0L__2, sum(0.0+fichas.desaparece) as C0L__3, sum(0.0+fichas.vivdest) as C0L__4, sum(0.0+fichas.vivafec) as C0L__5, sum(0.0+fichas.damnificados) as C0L__6, sum(0.0+fichas.afectados) as C0L__7, sum(0.0+fichas.reubicados) as C0L__8, sum(0.0+fichas.evacuados) as C0L__9 from  (((((fichas left join eventos on eventos.nombre=fichas.evento) left join lev0 on lev0.lev0_cod=fichas.level0) left join lev1 on lev1.lev1_cod=fichas.level1) left join lev2 on lev2.lev2_cod=fichas.level2) left join causas on causas.causa=fichas.causa)  left join extension on fichas.clave = extension.clave_ext  where   (fichas.approved is null or fichas.approved=0) "+sSqlDetails+" group by lev1_name"+sSuffix+" order by lev1_name"+sSuffix;
else
  sSql="SELECT lev0_name"+sSuffix+", max(lev0_cod) as code0,sum(1) as C0L__0, sum(0.0+fichas.muertos) as C0L__1, sum(0.0+fichas.heridos) as C0L__2, sum(0.0+fichas.desaparece) as C0L__3, sum(0.0+fichas.vivdest) as C0L__4, sum(0.0+fichas.vivafec) as C0L__5, sum(0.0+fichas.damnificados) as C0L__6, sum(0.0+fichas.afectados) as C0L__7, sum(0.0+fichas.reubicados) as C0L__8, sum(0.0+fichas.evacuados) as C0L__9 from  (((((fichas left join eventos on eventos.nombre=fichas.evento) left join lev0 on lev0.lev0_cod=fichas.level0) left join lev1 on lev1.lev1_cod=fichas.level1) left join lev2 on lev2.lev2_cod=fichas.level2) left join causas on causas.causa=fichas.causa)  left join extension on fichas.clave = extension.clave_ext  where   (fichas.approved is null or fichas.approved=0) "+sSqlDetails+" group by lev0_name"+sSuffix+" order by lev0_name"+sSuffix;

try{
	  stmt=con.createStatement();
	  rset=stmt.executeQuery(sSql);
	  while (rset.next())
	  	{
		    cell = new PdfPCell(smallFontParagraph(countrybean.not_null(rset.getString(1))));
		    table.addCell(cell);
		    cell = new PdfPCell(smallFontParagraph(countrybean.not_null(rset.getString(2))));
		    table.addCell(cell);
		    for (int j=3; j<13; j++)
		    {
		    	Paragraph p=smallFontParagraph(String.valueOf(rset.getInt(j)));
		    	p.setAlignment(Element.ALIGN_RIGHT);
		    	cell = new PdfPCell(p);
		    	cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
			    table.addCell(cell);
		    }
		}
	 rset.close();
	 stmt.close();
	 }
catch (Exception eSql)
	{
	System.out.println("<!-- "+eSql.toString()+" -->");
	}	 
document.add(table);
}


{
	
	document.add(mediumFontParagraph(countrybean.getTranslation("Temporal Behaviour")+"\r\n"));
	document.add(new Paragraph("\r\n"));

	float[] relativeWidths={2.5f,1.0f,1.0f,1.0f,1.0f,1.0f,1.0f,1.0f,1.0f,1.0f,1.0f};
	PdfPTable table = new PdfPTable(relativeWidths);
	table.setWidthPercentage(100f);

    PdfPCell cell = new PdfPCell(smallFontParagraph(countrybean.getTranslation("Year"),true));
    table.addCell(cell);
    cell = new PdfPCell(smallFontParagraph(countrybean.getTranslation("DataCards"),true));
    table.addCell(cell);
    cell = new PdfPCell(smallFontParagraph(countrybean.getTranslation("Deaths"),true));
    table.addCell(cell);
    cell = new PdfPCell(smallFontParagraph(countrybean.getTranslation("Injured"),true));
    table.addCell(cell);
    cell = new PdfPCell(smallFontParagraph(countrybean.getTranslation("Missing"),true));
    table.addCell(cell);
    cell = new PdfPCell(smallFontParagraph(slabelHD,true));
    table.addCell(cell);
    cell = new PdfPCell(smallFontParagraph(slabelHA,true));
    table.addCell(cell);
    cell = new PdfPCell(smallFontParagraph(countrybean.getTranslation("Victims"),true));
    table.addCell(cell);
    cell = new PdfPCell(smallFontParagraph(countrybean.getTranslation("Affected"),true));
    table.addCell(cell);
    cell = new PdfPCell(smallFontParagraph(countrybean.getTranslation("Relocated"),true));
    table.addCell(cell);
    cell = new PdfPCell(smallFontParagraph(countrybean.getTranslation("Evacuated"),true));
    table.addCell(cell);

  sSql="SELECT fichas.fechano,sum(1) as C0L__0, sum(0.0+fichas.muertos) as C0L__1, sum(0.0+fichas.heridos) as C0L__2, sum(0.0+fichas.desaparece) as C0L__3, sum(0.0+fichas.vivdest) as C0L__4, sum(0.0+fichas.vivafec) as C0L__5, sum(0.0+fichas.damnificados) as C0L__6, sum(0.0+fichas.afectados) as C0L__7, sum(0.0+fichas.reubicados) as C0L__8, sum(0.0+fichas.evacuados) as C0L__9 from  (((((fichas left join eventos on eventos.nombre=fichas.evento) left join lev0 on lev0.lev0_cod=fichas.level0) left join lev1 on lev1.lev1_cod=fichas.level1) left join lev2 on lev2.lev2_cod=fichas.level2) left join causas on causas.causa=fichas.causa)  left join extension on fichas.clave = extension.clave_ext  where   (fichas.approved is null or fichas.approved=0) "+sSqlDetails+" group by fichas.fechano order by fichas.fechano" ;
  try{
	  stmt=con.createStatement();
	  rset=stmt.executeQuery(sSql);
	  while (rset.next())
	  	{
		    cell = new PdfPCell(smallFontParagraph(countrybean.not_null(rset.getString(1))));
		    table.addCell(cell);
		    for (int j=2; j<12; j++)
		    {
		    	Paragraph p=smallFontParagraph(String.valueOf(rset.getInt(j)));
		    	p.setAlignment(Element.ALIGN_RIGHT);
		    	cell = new PdfPCell(p);
		    	cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
			    table.addCell(cell);
		    }
		}
	 rset.close();
 	 stmt.close();
	 }
catch (Exception eSql)
	{
	System.out.println("<!-- "+eSql.toString()+" -->");
	}	 
  document.add(table);
}






// -----------

 	// close the database object 
	dbCon.close(); 

	
	document.close();
	response.setContentType("application/pdf");
	((HttpServletResponse) response).setHeader("Pragma", "no-cache");
	((HttpServletResponse) response).setHeader("Cache-Control", "no-cache");
	((HttpServletResponse) response).setDateHeader("Expires", 0);
	response.setContentLength(baos.size());
	ServletOutputStream out = response.getOutputStream();
	baos.writeTo(out);
	out.close();
    } 
    catch (Throwable t) 
     {
    	// report exception here
     } 
    finally 
     {
    	// what else?
     }
  }
}
