<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="woFicha" class="org.lared.desinventar.webobject.fichas" scope="session" />
<jsp:useBean id="woExtension" class="org.lared.desinventar.webobject.extension" scope="session" />
<jsp:useBean id="woMedia" class="org.lared.desinventar.webobject.MediaFile" scope="session" />
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.system.Sys" %>
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

%>
<%
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
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
<html>
<head>
<title><%=countrybean.getTranslation("Media Loader")%></title>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
</head>
<%
int nClave;
int j=0;
nClave=woFicha.clave;	
int start=htmlServer.extendedParseInt(request.getParameter("start"));
String sReturnPage=htmlServer.not_null(request.getParameter("editmode"));
woFicha.getWebObject(con); 
%>
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
<input type="hidden" name="editmode" id="editmode" value="<%=sReturnPage%>"> 
<h2><strong>DesInventar Media Upload facility</strong></h2>
<table class='bs' cellpadding="0" cellspacing="0" width="850">
<tr class='bodymedlight'><td class="bs"><!-- Header lines in light blue  -->
 <table class='bs' cellpadding="0" cellspacing="0" width="100%"><tr>
  <td class="bs"><%=countrybean.getTranslation("Serial")%>: <INPUT name="serial" value="<%=htmlServer.htmlEncode(woFicha.serial)%>" size="6" maxlength="6"></td>
  <td class="bs"><%=countrybean.getTranslation("DateYMD")%>: <INPUT NAME="fechano"  style="WIDTH: 45px;" value="<%=sBlankZero(woFicha.fechano)%>" size="4" maxlength="4"><INPUT NAME="fechames" value="<%=sBlankZero(woFicha.fechames)%>" size="2" style="WIDTH: 22px;" maxlength="3"><INPUT NAME="fechadia" value="<%=sBlankZero(woFicha.fechadia)%>" size="2" style="WIDTH: 22px;" maxlength="3"></td>
  <td class="bs"><%=countrybean.getTranslation("Duration")%>: <INPUT NAME="duracion"  style="WIDTH: 40px;" value="<%=sBlankZero(woFicha.duracion)%>" size="4" maxlength="4"></td>
  <td class="bs"><%=countrybean.getTranslation("Source")%>: <INPUT type='TEXT' size='40' maxlength='250'name='fuentes' VALUE="<%=htmlServer.htmlEncode(woFicha.fuentes)%>"></td>
 </tr></table>
</td></tr>
<tr class='bodymedlight'><td class="bs">
 <table class='bs' cellpadding="0" cellspacing="0" width="100%"><tr>
  <td class="bs"><%=countrybean.asLevels[0]%>: <input name="name0" size=20 value="<%=htmlServer.htmlEncode(woFicha.name0)%>"></td>
  <td class="bs"><%=countrybean.asLevels[1]%>: <input type='text' name='name1' size=20 value="<%=htmlServer.htmlEncode(woFicha.name1)%>"></td>
  <td class="bs"><%=countrybean.asLevels[2]%>: <input type='text' name='name2' size=20 value="<%=htmlServer.htmlEncode(woFicha.name2)%>"></td>
 </tr></table>
</td></tr>
<tr class='bodymedlight'><td class="bs">
 <table class='bs' cellpadding="0" cellspacing="0" width="100%"><tr>
  <td class="bs"><%=countrybean.getTranslation("Event")%>: <input name="Event" size=20 value="<%=htmlServer.htmlEncode(woFicha.evento)%>"></td>
  <td class="bs"><%=countrybean.getTranslation("Place")%>: <INPUT type="TEXT" size="45" maxlength="60"name="lugar" VALUE="<%=htmlServer.htmlEncode(woFicha.lugar)%>"></td>
  <td class="bs"><%=countrybean.getTranslation("GLIDEnumber")%>: <INPUT type="TEXT" size="15" maxlength="30"name="lugar" VALUE="<%=htmlServer.htmlEncode(woFicha.glide)%>"> [<%=woFicha.clave%>]</td>
 </tr></table>
</td></tr>
</table>
<table  class='bodymedlight bs' cellpadding="0" cellspacing="0" width="850">
<tr><td colspan="2"><br/><strong>Description of media to upload:</strong></td></tr>
<tr><td>Type of media:</td><td>
	<SELECT name="media_type">
	<inv:select tablename='media_type' selected='<%=woMedia.media_type%>' connection='<%= con %>'
    fieldname="media_type_name_en" codename='media_type' ordername='media_type'/>
    </SELECT>

</td></tr>
<tr><td>File to upload:</td><td><INPUT TYPE='FILE' NAME='queryfile' SIZE='50' value="*.jpg,*.png.*.mp4,*.mov,*.doc,*.docx,*.xls,*.xlsx,*.pdf,*.zip,*.txt" accept="*.jpg,*.png.*.mp4,*.mov,*.doc,*.docx,*.xls,*.xlsx,*.pdf,*.zip,*.txt"></td></tr>
<tr><td>Title :</td><td><INPUT TYPE='text' NAME='media_title' SIZE='50'></td></tr>
<tr><td>Title (English):</td><td><INPUT TYPE='text' NAME='media_title_en' SIZE='50'  maxlength="50"></td></tr>
<tr><td>Description :</td><td><INPUT TYPE='text' NAME='media_description' SIZE='80'  maxlength="255"></td></tr>
<tr><td>Description (English):</td><td><INPUT TYPE='text' NAME='media_description_en'  SIZE='80'  maxlength="255"></td></tr>
<tr><td>Link URL :</td><td><INPUT TYPE='text' NAME='media_link' maxlength="255" SIZE='80'></td></tr>
<tr><td><input type='submit' value='Upload' name='submitDocument' > &nbsp;&nbsp;&nbsp;&nbsp;</td>
<td><input type='button' onClick="closeAll()" value='Cancel' name='cancelDocument' ></td></tr>
<input type='hidden' name='start' value='<%=start%>'>
</table>
</form>
<%
dbCon.close();
%>
</body>
</html>
