<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<%@ page info="DesInventar update" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.system.Sys" %>
<%@ page import = "com.jspsmart.upload.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<%
boolean bLoadedOK=false;
// this directory must exist within the application path.. 
String sFilePrefix="";
String sFilename="";
SmartUpload fileUpload=new SmartUpload();
fileUpload.initialize(pageContext);
// fileUpload.setTotalMaxFileSize(2000000);  // TWO MEGABYTES LIMIT!!!
// perfoms the upload
fileUpload.upload();
if (user.iusertype>=20)
	{
	// First, it uploads all images...
	// Initialization
	int count=0;        
	// Retrieve the current file
	com.jspsmart.upload.File queryFile = fileUpload.getFiles().getFile(0);
	sFilePrefix=countrybean.country.sjetfilename;

	String sUnzip=fileUpload.getRequest().getParameter("unzip");

	if (!(sFilePrefix.endsWith("/")||(sFilePrefix.endsWith("\\"))))
		sFilePrefix+="/";	

	sFilename=sFilePrefix+queryFile.getFileName();
	// Save it only if this file exists (was uploaded OK)
	if (!queryFile.isMissing()) 
			    {
				// Save the files with its original names in the database files directory       
				queryFile.saveAs(sFilename);
				// if it is a zip file, and unzip is checked, extract all files
				if (sFilename.endsWith(".zip") && "Y".equals(sUnzip))
					{
					ZipUtil.unzip(sFilename, sFilePrefix);
					}
				count ++;
			    }
	 bLoadedOK=true;
	 }
%><!-- fname=<%=sFilename%> -->
<body marginheight="0" topmargin="0" class='body'>
<title>Query Upload</title>
<body>
<%if (bLoadedOK){%>
<h2>Successfully uploaded...</h2>
<%}
else {%>
<h2>Error while uploading..</h2>
<%}%>
</body>
</html>




