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
<title>DesInventar on-line - <%=countrybean.getTranslation("ImportTABLE")%></title>
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
  {
  document.desinventar.tablename.value=newFolder;
  refreshFrame();
  }
}

function refreshFrame()
{
 var newFolder=document.desinventar.filename.value;
 if (newFolder)
  {
  var params="?tablename="+newFolder;
  document.getElementById("excelFrame").src="/DesInventar/inv/importJdbc_show.jsp"+params;
  }
}

function validateDB()
{
if (document.desinventar.tablename.value.length>0)
	   return true;
alert("<%=countrybean.getTranslation("NoExcelSelected")%>");
return false;	
}



// -->
</script>

<%@ include file="/util/showDialog.jspf" %> 
<form method="post" action="importJdbc_2.jsp" name="desinventar" onSubmit="return validateDB();">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<table width="580" border="0">
<tr><td align="center">
<font color="Blue"><%=countrybean.getTranslation("Region")%></font>
<b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font>
 - [<jsp:getProperty name ="countrybean" property="countrycode"/>]
</td></tr>
</table>
<table width="100%" border="0">
<tr><td height="10"></td><td></td></tr>
<tr>
<td valign="top" COLSPAN=2 nowrap><div class="subtitle"><%=countrybean.getTranslation("SelectTable")%></div></td>
<tr>
  <td align="right"><%=countrybean.getTranslation("Table_Name")%></td>		  
  <td><input name='tablename' onChange="refreshFrame();"></td>
</tr>
<tr>
  <td colspan=2><br><div class="subtitle"><%=countrybean.getTranslation("ImportOptions")%>:</div></td>
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
  <td align="right"><INPUT type='checkbox' name='geography'  VALUE='Y' checked></td>		 
  <td><%=countrybean.getTranslation("ImportGeography")%></td>
</tr>
<tr>
  <td align="right"><INPUT type='checkbox' name='data'  VALUE='Y' checked></td>		 
  <td><%=countrybean.getTranslation("ImportDatacards")%></td>
</tr>
<tr>
  <td align="right"><br><INPUT type='checkbox' name='cleandatabase'  VALUE='Y'></td>		 
  <td><br><%=countrybean.getTranslation("OVERWRITE CURRENT DATABASE WITH THIS ONE")%></td>
</tr>

<tr>
  <td></td>
  <td><br><INPUT type='submit' size='50' maxlength='50' name='continue'  VALUE='<%=countrybean.getTranslation("Continue")%>'> </td>		 
</tr>
<tr>
  <td colspan=3><iframe height="160" width="100%" name="excelFrame"></iframe></td>		 
</tr>
<tr>
  <td></td>
  <td><font class=warning><%=countrybean.getTranslation("ImportExcelNotice")%></font></td>		 
</tr>
</table>
</form>
</body>
</html>

