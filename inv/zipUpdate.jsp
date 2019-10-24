<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<%@ page info="DesInventar On-Line" session="true" %> 
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %> 
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<%@ page import="org.lared.desinventar.system.Sys" %>
<!--%@ include file="checkUserIsLoggedIn.jsp" %-->
<% 
String sLinkToZip="No file available";
ServletContext sc = getServletConfig().getServletContext();
String sSourcePath= sc.getRealPath("/generator");
if (request.getParameter("saveRegion")!=null)
  { 
  String srcFolder = countrybean.not_null(request.getParameter("sjetfilename"));
  srcFolder=srcFolder.replace("\\","/");
  if (srcFolder.endsWith("/"))
  	srcFolder=srcFolder.substring(0,srcFolder.length()-1);
  String sDestFolder=srcFolder;
  int pos =srcFolder.lastIndexOf("/");
  if (pos>0)
  	sDestFolder=srcFolder.substring(pos+1);
  String destZipFile = sSourcePath+"/"+sDestFolder + ".zip";
  File file = new File(srcFolder);
  if (file.exists() && srcFolder.length()>2)
	  {
	  ZipUtil zipper=new ZipUtil();
	  zipper.zipFolder(srcFolder, destZipFile);
	  sLinkToZip="<br/><a href='/DesInventar/generator/"+sDestFolder + ".zip'>Get Backup</a><br/>";
	  }
  }
response.setContentType("text/html; charset=UTF-8");
request.setCharacterEncoding("UTF-8"); 
%>
<html>
<head>
<title>DesInventar on-line : Zip Download</title>
</head>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
 
<%@ taglib uri="inventag.tld" prefix="inv" %>

<script language="JavaScript">
<!-- 

function setReturnFolder(newFolder)
{
 if (newFolder)
  document.desinventar.sjetfilename.value=newFolder;
 setODBC();
 }

function browse()
{
sPath=document.desinventar.sjetfilename.value;
var newFolder=showDialog("/DesInventar/inv/browsedirfrm.jsp?currentPath="+sPath, 'setReturnFolder');
}

function setCancel()
{
cancelling=true;
}
// -->
</script>

<%@ include file="/util/showDialog.jspf" %> 

<table width="100%" cellspacing="2" cellpadding="2" border=0 align=>
<form method="post" action="zipUpdate.jsp" name="desinventar" onSubmit="return (document.desinventar.sjetfilename.value.length>0)</form>;">
<tr>
 <td align="left">
	<span class="title">Folder Backup Utility:</span><br><br>	
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr><td class=bgLight>Folder to zip/backup:</td><td>  <INPUT type='TEXT' size='100' maxlength='250' name='sjetfilename' onChange="setODBC()" VALUE=""> 
	<INPUT type='button' name='browsebtn'  VALUE="<%=countrybean.getTranslation("Browse")%>" onClick="browse()"></td></tr>
	<TR>
	<TD></TD>
	<TD>
	<input name="saveRegion" type=submit value='Start Backup'> &nbsp; &nbsp; &nbsp; &nbsp;
	<input name="cancelRegion" type=submit value='<%=countrybean.getTranslation("Cancel")%>' onClick="setCancel()"><br>
	<%=sLinkToZip%>
	</TD>
	</Tr>
	</table>
 </td>
</tr>
</form>
</table>
<br>
</body>
</html>