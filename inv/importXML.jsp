<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<%@ page info="Reindex page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>

<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<head>
<title>DesInventar on-line - <%=countrybean.getTranslation("Import from DesInventar XML export file")%></title>
 </head>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%if (user.iusertype<20) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}%>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>">
<script language="JavaScript">
<!-- 
function setReturnFolder(newFolder)
{
 if (newFolder)
  document.desinventar.filename.value=newFolder;
}

function browse()
{
sPath=document.desinventar.filename.value;
showDialog("/DesInventar/inv/browsefilefrm.jsp?extension=.xml&currentPath="+sPath, 'setReturnFolder');
}

function validateDB()
{
if (document.desinventar.filename.value.length>0)
	{
	if (document.desinventar.filename.value.toLowerCase().indexOf(".xml")>0)
	   return true;
	}
alert("<%=countrybean.getTranslation("NoDbSelected")%>");
return false;	
}
// -->
</script>

<%@ include file="/util/showDialog.jspf" %> 
<form method="post" action="importXML_2.jsp" name="desinventar" onSubmit="return validateDB();">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<table width="720" border="0">
<tr><td align="center">
<font color="Blue"><%=countrybean.getTranslation("Region")%></font>
<b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font>
 - [<jsp:getProperty name ="countrybean" property="countrycode"/>]
</td></tr>
</table>
<table width="850" border="0">
<tr><td height="20"></td><td></td></tr>
<tr>
<td valign="top" nowrap><div class="subtitle"><%=countrybean.getTranslation("SelectDatabase")%></div></td>
<td>  <INPUT type='TEXT' size='50' maxlength='550' name='filename'  VALUE=""> 
      <INPUT type='button' name='browsebtn'  VALUE="<%=countrybean.getTranslation("Browse")%>" onClick="browse()"><span class="warning"><strong>****</strong></span>
</td>		 
</tr>
<tr>
  <td colspan=2><br><br><div class="subtitle"><%=countrybean.getTranslation("ImportOptions")%>:</div></td>
</tr>
<tr>
  <td align="right"><INPUT type='checkbox' name='events'  VALUE='Y' checked></td>		 
  <td><%=countrybean.getTranslation("ImportEvents")%></td>
</tr>
<tr>
  <td align="right"><INPUT type='checkbox' name='causes'  VALUE='Y' checked></td>		 
  <td><%=countrybean.getTranslation("ImportCauses")%></td>
</tr>
<tr>
  <td align="right" valign="top"><INPUT type='checkbox' name='levels'  VALUE='Y' checked></td>		 
  <td><%=countrybean.getTranslation("ImportLevels")%>   &nbsp;&nbsp;</td>
</tr>

<tr>
  <td align="right"><INPUT type='checkbox' name='geography'  VALUE='Y' checked></td>		 
  <td><%=countrybean.getTranslation("ImportGeography")%></td>
</tr>
<tr>
  <td align="right"><INPUT type='checkbox' name='maps'  VALUE='Y' checked></td>		 
  <td><%=countrybean.getTranslation("ImportMaps")%></td>
</tr>
<tr>
  <td align="right"><INPUT type='checkbox' name='data'  VALUE='Y' checked></td>		 
  <td><%=countrybean.getTranslation("ImportDatacards")%></td>
</tr>
<tr>
  <td align="right"><INPUT type='checkbox' name='definition'  VALUE='Y' checked></td>		 
  <td><%=countrybean.getTranslation("ImportExtensionDefinition")%></td>
</tr>
<tr>
  <td align="right"><INPUT type='checkbox' name='extension'  VALUE='Y' checked></td>		 
  <td><%=countrybean.getTranslation("ImportExtensionData")%></td>
</tr>
<tr>
  <td align="right"><INPUT type='checkbox' name='metadata'  VALUE='Y' checked></td>		 
  <td><%=countrybean.getTranslation("Import Metadata")%></td>
</tr>

<tr>
  <td align="right"><br><INPUT type='checkbox' name='cleandatabase'  VALUE='Y' checked></td>		 
  <td><br><%=countrybean.getTranslation("OVERWRITE CURRENT DATABASE WITH THIS ONE")%></td>
</tr>

<tr>
  <td></td>
  <td><br><br><INPUT type='submit' size='50' maxlength='50' name='continue'  VALUE='<%=countrybean.getTranslation("Continue")%>'> </td>		 
</tr>
<tr>
  <td></td>
  <td><br><br><br></td>		 
</tr>
<tr>
  <td></td>
  <td><br><br><font class=warning><%=countrybean.getTranslation("ImportNotice")%></font></td>		 
</tr>
</table>
</form>
<iframe height="0" width="0" name="importFrame"></iframe>
</body>
</html>

