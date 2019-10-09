<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.system.Sys" %>
<html>
<head>
<title><%=countrybean.getTranslation("LoadQuery")%></title>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
</head>

<script language="JavaScript">
function closeAll()
{
window.location="/DesInventar/inv/index.jsp";
}
</script>
<body class='bodyclass'>
<form name="doc_files" action="fileUpload.jsp" METHOD="POST" ENCTYPE="multipart/form-data">
<div class="titleTextWhite"><%=countrybean.getTranslation("DataAdministrationFunctions")%> <strong> [<%=countrybean.countryname%>]</strong>:</div>
<table>
<tr><td colspan="2"><strong>DesInventar upload facility (for maps, excel and other data files)</strong></td></tr>
<tr><td>File:</td><td><INPUT TYPE='FILE' NAME='uploadfile' SIZE='50' accept=".xls,.xlsx,.shp,.shx,.dbf,.zip,.xml,.mdb"></td></tr>
<tr><td>&nbsp;</td><td><input type="checkbox" name='unzip' value="Y" checked>Decompress after upload (for zip files)</td></tr>
<tr><td><input type='submit' value='Upload' name='submitDocument' > &nbsp;&nbsp;&nbsp;&nbsp;</td>
<td><input type='button' onClick="closeAll()" value='Cancel' name='cancelDocument' ></td></tr>
</table>
</form>

</body>
</html>
