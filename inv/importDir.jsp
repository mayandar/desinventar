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
<title>DesInventar on-line - <%=countrybean.getTranslation("ImportEXCEL")%></title>
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
  document.desinventar.filename.value=newFolder;
  refreshFrame();
  }
}

function refreshFrame()
{
 var newFolder=document.desinventar.filename.value;
 if (newFolder)
  {
  var params="?filename="+newFolder+"&sheetnumber="+document.desinventar.sheetnumber.value;
  document.getElementById("excelFrame").src="/DesInventar/inv/importExcel_show.jsp"+params;
  }
}

function browse()
{
sPath=document.desinventar.filename.value;
showDialog("/DesInventar/inv/browsefilefrm.jsp?extension=.xls&currentPath="+sPath, 'setReturnFolder');
}

function validateDB()
{
if (document.desinventar.filename.value.length>0)
	{
	if (document.desinventar.filename.value.toLowerCase().indexOf(".xls")>0)
	   return true;
	}
alert("<%=countrybean.getTranslation("NoExcelSelected")%>");
return false;	
}
// -->
</script>

<%@ include file="/util/showDialog.jspf" %> 
<form method="post" action="importExcel_2.jsp" name="desinventar" onSubmit="return validateDB();">
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
<td valign="top" nowrap><div class="subtitle"><%=countrybean.getTranslation("SelectExcelFile")%></div></td>
<td>  <INPUT type='TEXT' size='50' maxlength='550' name='filename'  VALUE=""> 
      <INPUT type='button' name='browsebtn'  VALUE="<%=countrybean.getTranslation("Browse")%>" onClick="browse()"><span class="warning"><strong>****</strong></span>
</td>		 
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
  <td align="right"></td>		 
  <td><br><%=countrybean.getTranslation("SpreadSheetNo")%>&nbsp;(0..n)&nbsp;&nbsp;<select name='sheetnumber' onChange="refreshFrame();">
  <% for (int s=0; s<20; s++){out.println("<option value="+s+">"+s+"</option>");}%>
  </select></td>
</tr>
<tr>
  <td align="right"></td>		 
  <td><%=countrybean.getTranslation("TitleRow")%>&nbsp;(0..n)&nbsp;&nbsp;<INPUT type='text' name='firstrow'  VALUE='0' size="3"></td>
</tr>
<tr>
  <td align="right"><br></td>		 
  <td><%=countrybean.getTranslation("StartImportRow")%>&nbsp;(0..n)&nbsp;&nbsp;<INPUT type='text' name='startrow'  VALUE='1' size="3"></td>
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

