<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<%@ page info="DesConsultar simple results page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ include file="/util/opendatabase.jspf" %> 
<%@ page import = "com.jspsmart.upload.*" %>
<%
SmartUpload fileUpload=new SmartUpload();
// this directory must exist within the application path.. 
String sFilePrefix= application.getRealPath("/download/");
if (!(sFilePrefix.endsWith("/")||(sFilePrefix.endsWith("\\"))))
		sFilePrefix+="/";

// First, it uploads the query
// Initialization
int count=0;        
fileUpload.initialize(pageContext);
// fileUpload.setTotalMaxFileSize(2000000);  // TWO MEGABYTES LIMIT!!!
// perfoms the upload	
fileUpload.upload();
// Retrieve the current file
com.jspsmart.upload.File queryFile = fileUpload.getFiles().getFile(0);
String sFilename=sFilePrefix+queryFile.getFileName();
// Save it only if this file exists
if (!queryFile.isMissing()) 
		    {
			// Save the files with its original names in a virtual path of the web server       
			queryFile.saveAs("/download/" + queryFile.getFileName());
			count ++;
		    }
boolean bLoadedOK=true;
if (!sFilename.endsWith(".qry"))
	bLoadedOK=false;
else
	{
	//		vImageVector=TagCollector.retrieveImageSources(new StreamTokenizer(new FileReader(sFileName)));
		FileInputStream qry = new FileInputStream(sFilename);
		ObjectInput deserialQry = new ObjectInputStream(qry);
		DICountry query = (DICountry) deserialQry.readObject();
		deserialQry.close();
		countrybean.asLevels=query.asLevels;
		
		// Stat levels vector
		countrybean.asStatLevels=query.asStatLevels;
		countrybean.nStatLevels=query.nStatLevels;
		
		countrybean.asMapRanges = new double[11];
		countrybean.asMapColors=new String[11];
		countrybean.asMapLegends=new String[11];
		
		countrybean.nStatLevels=query.nStatLevels;
		countrybean.nMaxhits=query.nMaxhits;
		countrybean.sKeyWord=query.sKeyWord;
		countrybean.logic=query.logic;
		countrybean.sortby=query.sortby;
		
		countrybean.fromyear=query.fromyear;
		countrybean.frommonth=query.frommonth;
		countrybean.fromday=query.fromday;
		countrybean.toyear=query.toyear;
		countrybean.tomonth=query.tomonth;
		countrybean.today=query.today;
		
		countrybean.killed=query.killed;
		countrybean.injured=query.injured;
		countrybean.destroyedHouses=query.destroyedHouses;
		countrybean.affectedHouses=query.affectedHouses;
		countrybean.victims=query.victims;
		countrybean.evacuated=query.evacuated;
		countrybean.affected=query.affected;
		countrybean.relocated=query.relocated;
		countrybean.roads=query.roads;
		countrybean.hectares=query.hectares;
		countrybean.livestock=query.livestock;
		countrybean.schools=query.schools;
		countrybean.hospitals=query.hospitals;
		
		
		countrybean.water=query.water;
		countrybean.sewerage=query.sewerage;
		countrybean.education=query.education;
		countrybean.power=query.power;
		countrybean.industries=query.industries;
		countrybean.health=query.health;
		countrybean.agriculture=query.agriculture;
		countrybean.transportation=query.transportation;
		countrybean.communications=query.communications;
		countrybean.relief=query.relief;
		countrybean.other=query.other;
		
		// TODO: this section may blow up when changing country!!!
		countrybean.asEventos=query.asEventos;
		countrybean.asNivel0=query.asNivel0;
		countrybean.asNivel1=query.asNivel1;
		countrybean.asNivel2=query.asNivel2;
		countrybean.asVariables=query.asVariables;
		countrybean.asCausas=query.asCausas;
		
		
		countrybean.bHayEventos=query.bHayEventos;
		countrybean.bHayNivel0=query.bHayNivel0;
		countrybean.bHayNivel1=query.bHayNivel1;
		countrybean.bHayNivel2=query.bHayNivel2;
		countrybean.bHayVariables=query.bHayVariables;
		countrybean.bWereCauses=query.bWereCauses;
		
		// Expert variables
		countrybean.sExpertVariable=query.sExpertVariable;
		countrybean.sExpertWhere=query.sExpertWhere;
		
		// statistical functions
		countrybean.bSum=query.bSum;
		countrybean.bMax=query.bMax;
		countrybean.bAvg=query.bAvg;
		countrybean.bStd=query.bStd;
		countrybean.bVar=query.bVar;
		
		// chart variables
		countrybean.nChartType=query.nChartType;
		countrybean.nChartMode=query.nChartMode;
		countrybean.nChartSubmode=query.nChartSubmode;
		countrybean.nPeriodType=query.nPeriodType;
		countrybean.nSeasonType=query.nSeasonType;
		countrybean.b3D=query.b3D;
		countrybean.bColorBW=query.bColorBW;
		countrybean.xresolution=query.xresolution;
		countrybean.yresolution=query.yresolution;
		// NOT VISIBLE: countrybean.hVariableList=query.hVariableList;
		countrybean.sTitle=query.sTitle;
		countrybean.sSubTitle=query.sSubTitle;
		
		countrybean.asMapRanges=query.asMapRanges;
		countrybean.asMapColors=query.asMapColors;
		countrybean.asChartColors=query.asChartColors;
		countrybean.asMapLegends=query.asMapLegends;

	  	countrybean.asStatLevels=query.asStatLevels;
		countrybean.asChartMapVariables=query.asChartMapVariables;
		countrybean.asReportVariables=query.asReportVariables;
		countrybean.asStatisticsVariables=query.asStatisticsVariables;
		countrybean.asCrosstabVariables=query.asCrosstabVariables;

	}
%>
<body marginheight="0" topmargin="0" class='body'>
<title>Query Upload</title>
<body>
<script language="JavaScript">
<%if (bLoadedOK){%>
parent.doDiagOK();
<%}
else {%>
parent.cancelAction();
<%}%>
</script>

</body>
</html>




