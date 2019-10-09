<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
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
<form name="doc_files" action="WDDS_updateUpload.jsp" METHOD="POST" ENCTYPE="multipart/form-data">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<table>
<tr><td colspan="2"><strong>DesInventar file upload facility</strong></td></tr>
<%
if (!Sys.bRequireLogin)
	{
	if (user.suserid.length()==0)
	    user.suserid="Anonimous";
	user.iusertype=99;
	}
if (user.suserid.length()==0 || user.iusertype<99)
	{ // expired session OR susper user!%>
<tr><td>Authorization:</td><td><input type="Password" maxlength="20" name='passwd'></td></tr>
<%  }%>
<tr><td>Location</td><td><input type="text" maxlength="250" name='folder'></td></tr>
<tr><td>File:</td><td><INPUT TYPE='FILE' NAME='queryfile' SIZE='50' value="*.qry" accept="*.qry"></td></tr>
<tr><td><input type='submit' value='Upload' name='submitDocument' > &nbsp;&nbsp;&nbsp;&nbsp;</td>
<td><input type='button' onclick="closeAll()" value='Cancel' name='cancelDocument' ></td></tr>
</table>
</form>

</body>
</html>
