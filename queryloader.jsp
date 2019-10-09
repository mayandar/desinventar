<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.*" %>
<html>
<head>
<title><%=countrybean.getTranslation("LoadQuery")%></title>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
</head>

<script language="JavaScript">
function closeAll()
{
parent.cancelAction();
}
</script>
<body class='bodyclass'>
<form name="doc_files" action="document_files_upload.jsp" METHOD="POST" ENCTYPE="multipart/form-data">
Query file: <INPUT TYPE='FILE' NAME='queryfile' SIZE='50' value="*.qry" accept="*.qry"><br>
<input type='submit' value='<%=countrybean.getTranslation("LoadQuery")%>' name='submitDocument' > &nbsp;&nbsp;&nbsp;&nbsp;
<input type='button' onclick="closeAll()" value='<%=countrybean.getTranslation("Cancel")%>' name='cancelDocument' >
</form>

</body>
</html>
