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
<jsp:useBean id="woFicha" class="org.lared.desinventar.webobject.fichas" scope="session" />
<jsp:useBean id="woExtension" class="org.lared.desinventar.webobject.extension" scope="session" />
<jsp:useBean id="woMedia" class="org.lared.desinventar.webobject.MediaFile" scope="session" />
<%@ taglib uri="inventag.tld" prefix="inv" %>
<%!
String sBlankZero(int num)
{
return num==0?"":String.valueOf(num);
}

String sBlankZero(double num)
{
return num==0?"":webObject.formatDouble(num);
}

String[] sExtensions={"doc","docx","xsl","xslx","ppt","pptx","pdf","jpg","png","gif","flv","avi","mov","qt","mp","mpg","mp2",",mp4","txt","prn","zip","rar","7z","tar","gz","dat", ""};
int[] sTypes=          {1   ,1      ,2    ,2      ,3    ,3     ,4   ,5     ,5   ,5     ,6    ,6    ,6   ,6   ,6   ,6    ,6     ,6    ,8     ,8    ,9    ,9    ,9   ,9    ,9  ,9    ,7  } ;
%>
<%
//if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
 	{%>
<!--jsp:forward page="noaccess.jsp"/-->
<%}		
// checks for a session alive variable, or we have a new valid countrycode
if (countrybean.countrycode.length()==0)
	{%><jsp:forward page="/inv/index.jsp"/>
	<%}%>
<%@ include file="checkUserIsLoggedIn.jsp" %>
<%if (user.iusertype<1) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}%>
<%@ include file="/util/opendatabase.jspf" %>
<head>
<title>Media Upload</title>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
</head>
<%
int nClave=woFicha.clave;	
int j=0;
int start=htmlServer.extendedParseInt(request.getParameter("start"));
String sReturnPage=htmlServer.not_null(request.getParameter("editmode"));
boolean bLoadedOK=false;
// this directory must exist within the application path.. 
String sFilePrefix="";
String sFilename="";
String sFile_extension="";
String sOriginalFilename="";
SmartUpload fileUpload=new SmartUpload();
fileUpload.initialize(pageContext);
// fileUpload.setTotalMaxFileSize(2000000);  // TWO MEGABYTES LIMIT!!!
// perfoms the upload
fileUpload.upload();
if (user.iusertype>=10)
	{
	// First, it uploads image/video/doc...
	// Initialization
	int count=0;        
	// Retrieve the current file
	com.jspsmart.upload.File queryFile = fileUpload.getFiles().getFile(0);
	sOriginalFilename=queryFile.getFileName();

	sFilePrefix="/media";
	sFilePrefix=application.getRealPath(sFilePrefix);
	java.io.File f=new java.io.File(sFilePrefix);
	f.mkdirs();
    // obtains sequence, make sure the right SQL dialect is used
	woMedia.dbType=countrybean.dbType;
	woMedia.imedia=woMedia.getSequence("media_seq", con);
	 
	sFile_extension=sOriginalFilename.substring(sOriginalFilename.lastIndexOf(".")+1).toLowerCase();
	sFilename=sFilePrefix+"/"+countrybean.countrycode+"_"+woMedia.imedia+"."+sFile_extension;
	// Save it only if this file exists
	if (!queryFile.isMissing()) 
			    {
				// Save the files with its original names in a virtual path of the web server       
				queryFile.saveAs(sFilename);
				count ++;
			    }

		// 	woMedia.getForm((HttpServletRequest)fileUpload.getRequest(), response, con);

		woMedia.setMedia_type(fileUpload.getRequest().getParameter("media_type"));

		for (j=0; j<sExtensions.length; j++)
		   if (sExtensions[j].equalsIgnoreCase(sFile_extension))
		       woMedia.setMedia_type(sTypes[j]);

		woMedia.setMedia_title(woMedia.not_null(fileUpload.getRequest().getParameter("media_title")));
		woMedia.setMedia_title_en(woMedia.not_null(fileUpload.getRequest().getParameter("media_title_en")));
		woMedia.setMedia_description(woMedia.not_null(fileUpload.getRequest().getParameter("media_description")));
		woMedia.setMedia_description_en(woMedia.not_null(fileUpload.getRequest().getParameter("media_description_en")));
		woMedia.setMedia_link(woMedia.not_null(fileUpload.getRequest().getParameter("media_link")));

		woMedia.media_file=sOriginalFilename.toLowerCase();
		woMedia.iclave=woFicha.clave;
		woMedia.addWebObject(con);
		
		start=htmlServer.extendedParseInt(fileUpload.getRequest().getParameter("start"));
		sReturnPage=htmlServer.not_null(fileUpload.getRequest().getParameter("editmode"));
		if (sReturnPage.length()==0) sReturnPage="modifydatacard";
	
		 bLoadedOK=true;
	 }
%><!-- fname=<%=sFilename%> -->
<script language="JavaScript">
function closeAll()
{
window.location="/DesInventar/inv/<%=sReturnPage%>.jsp?usrtkn=<%=countrybean.userHash%>&start=<%=start%>";
}
</script>
<body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/iheader",countrybean.getLanguage(),out);%> 
<%
{
int nTabActive=6; // 
String[] sTabNames={countrybean.getTranslation("Region"),countrybean.getTranslation("Geography"),countrybean.getTranslation("Events"),
           countrybean.getTranslation("Causes"),countrybean.getTranslation("Extension"),countrybean.getTranslation("Query"),
           countrybean.getTranslation("EditData"),countrybean.getTranslation("DataEntry"),countrybean.getTranslation("Admin"),
		   countrybean.getTranslation("Sendai"),countrybean.getTranslation("Security")};
String[] sTabIcons={"","","","","","","","","","","",""};
String[] sTabLinks={"index.jsp","geographytab.jsp","eventab.jsp",
				"causetab.jsp","extendedtab.jsp","querytab.jsp",
				"resultstab.jsp","datacardtab.jsp","admintab.jsp",
				"sendaitab.jsp","securitytab.jsp"};
%>
<%@ include file="/util/tabs.jspf" %>
<%}%>



<form name="doc_files" action="mediaUpload.jsp" METHOD="POST" ENCTYPE="multipart/form-data">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<h2><strong>DesInventar Media Upload facility</strong></h2>
<table class='bs' cellpadding="0" cellspacing="0" width="850">
<tr class='bodymedlight'><td class="bs"><!-- Header lines in light blue  -->
 <table class='bs' cellpadding="0" cellspacing="0" width="100%"><tr>
  <td class="bs"><%=countrybean.getTranslation("Serial")%>: <INPUT name="serial" value="<%=woFicha.serial%>" size="6" maxlength="6"></td>
  <td class="bs"><%=countrybean.getTranslation("DateYMD")%>: <INPUT NAME="fechano"  style="WIDTH: 45px;" value="<%=sBlankZero(woFicha.fechano)%>" size="4" maxlength="4"><INPUT NAME="fechames" value="<%=sBlankZero(woFicha.fechames)%>" size="2" style="WIDTH: 22px;" maxlength="3"><INPUT NAME="fechadia" value="<%=sBlankZero(woFicha.fechadia)%>" size="2" style="WIDTH: 22px;" maxlength="3"></td>
  <td class="bs"><%=countrybean.getTranslation("Duration")%>: <INPUT NAME="duracion"  style="WIDTH: 40px;" value="<%=sBlankZero(woFicha.duracion)%>" size="4" maxlength="4"></td>
  <td class="bs"><%=countrybean.getTranslation("Source")%>: <INPUT type='TEXT' size='40' maxlength='250'name='fuentes' VALUE="<%=woFicha.fuentes%>"></td>
 </tr></table>
</td></tr>
<tr class='bodymedlight'><td class="bs">
 <table class='bs' cellpadding="0" cellspacing="0" width="100%"><tr>
  <td class="bs"><%=countrybean.asLevels[0]%>: <input name="name0" size=20 value="<%=woFicha.name0%>"></td>
  <td class="bs"><%=countrybean.asLevels[1]%>: <input type='text' name='name1' size=20 value="<%=woFicha.name1%>"></td>
  <td class="bs"><%=countrybean.asLevels[2]%>: <input type='text' name='name2' size=20 value="<%=woFicha.name2%>"></td>
 </tr></table>
</td></tr>
<tr class='bodymedlight'><td class="bs">
 <table class='bs' cellpadding="0" cellspacing="0" width="100%"><tr>
  <td class="bs"><%=countrybean.getTranslation("Event")%>: <input name="Event" size=20 value="<%=woFicha.evento%>"></td>
  <td class="bs"><%=countrybean.getTranslation("Place")%>: <INPUT type="TEXT" size="45" maxlength="60"name="lugar" VALUE="<%=woFicha.lugar%>"></td>
  <td class="bs"><%=countrybean.getTranslation("GLIDEnumber")%>: <INPUT type="TEXT" size="15" maxlength="30"name="lugar" VALUE="<%=woFicha.glide%>"></td>
 </tr></table>
</td></tr>
</table>
<%if (bLoadedOK)
{ 
 %>
<h2>File has been Successfully uploaded...</h2>


<table  class='bodymedlight bs' cellpadding="0" cellspacing="0" width="850">
<tr><td colspan="2"><br/><strong>Description of media uploaded  [id=<%=woMedia.imedia%>]:</strong></td></tr>
<tr><td>Type of media:</td><td>
	<SELECT name="media_type" disabled>
	<inv:select tablename='media_type' selected='<%=woMedia.media_type%>' connection='<%= con %>'
    fieldname="media_type_name_en" codename='media_type' ordername='media_type'/>
    </SELECT>
</td></tr>
<tr><td>Uploaded file:</td><td><INPUT TYPE='text' NAME='media_file' SIZE='50' value="<%=woMedia.media_file%>">
(saved as <%=countrybean.countrycode+"_"+woMedia.imedia+"."+sFile_extension%>)</td></tr>
<tr><td>Title :</td><td><INPUT TYPE='text' NAME='media_title' SIZE='50' value="<%=woMedia.media_title%>" disabled></td></tr>
<tr><td>Title (English):</td><td><INPUT TYPE='text' NAME='media_title_en' SIZE='50'  maxlength="50" value="<%=woMedia.media_title_en%>" disabled></td></tr>
<tr><td>Description :</td><td><INPUT TYPE='text' NAME='media_description' SIZE='80'  maxlength="255" value="<%=woMedia.media_description%>" disabled></td></tr>
<tr><td>Description (English):</td><td><INPUT TYPE='text' NAME='media_description_en'  SIZE='80'  maxlength="255" value="<%=woMedia.media_description_en%>" disabled></td></tr>
<tr><td>Link URL :</td><td><INPUT TYPE='text' NAME='media_link' maxlength="255" SIZE='80' value="<%=woMedia.media_link%>" disabled></td></tr>
<td><input type='button' onClick="closeAll()" value='Continue...' name='contDocument' ></td></tr>
<input type='hidden' name='start' value='<%=start%>'>
</table>
</form>

<%}
else {%>
<h2>Error while uploading..</h2>
<%}


dbCon.close();
%>
</body>
</html>




