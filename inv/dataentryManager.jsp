<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<%@ page info="DesInventar On-Line main page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:setProperty name="countrybean" property="countrycode" />
<jsp:setProperty name="countrybean" property="countryname" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%if (user.iusertype<1) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}%>
<jsp:useBean id="woFicha" class="org.lared.desinventar.webobject.fichas" scope="session" />
<jsp:useBean id="woExtension" class="org.lared.desinventar.webobject.extension" scope="session" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>DesInventar on-line : <%=countrybean.countryname%> Home </title>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
</head>
 <body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
<!-- Simulates IE table default borders in FireFox and Chrome -->
<style>
.IE_Table {  
   <%if (request.getHeader("User-Agent").indexOf("MSIE") == -1) {%>
   border-collapse: collapse; border-style:solid; border-width: 1px;	border-color: LightGrey; <%}%>
 }
</style>
 
<%@ include file="/util/opendatabase.jspf" %>
<%
// loads the datacard extension
woFicha.dbType=dbType;
woExtension.dbType=dbType;
woExtension.loadExtension(con,countrybean);
countrybean.getLevelsFromDB(con); 
dbCon.close();
if (request.getParameter("addData")!=null)
	{
   %><jsp:forward page="addDataCard.jsp" /><%
	}
else if (request.getParameter("editData")!=null)
	{
   %><jsp:forward page="editDataCard.jsp?action=0" /><%
	}
else if (request.getParameter("delData")!=null)
	{
   %><jsp:forward page="editDataCard.jsp?action=1" /><%
	}
%>
<table width="1000" cellspacing="2" cellpadding="5" border="1" class='IE_Table'>
<form name="desinventar"  method=post action="dataentryManager.jsp">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<tr> 
<td align="center" colspan=2><span class="title"><%=countrybean.getTranslation("DesInventarDataEntryFunctions")%></span></td>
</tr>
<tr><td colspan=2  align="center"><br><br>
<font size="+1">
<input type='submit' name='addData' value='<%=countrybean.getTranslation("New")%> <%=countrybean.getTranslation("DataCard")%>'> &nbsp;&nbsp;&nbsp;
<input type='submit' name='editData' value='<%=countrybean.getTranslation("Edit")%> <%=countrybean.getTranslation("DataCards")%>'> &nbsp;&nbsp;&nbsp;
<input type='submit' name='delData' value='<%=countrybean.getTranslation("Delete")%> <%=countrybean.getTranslation("DataCards")%>'> &nbsp;&nbsp;&nbsp;

<input type='hidden' name='viewStandard' value='<%=countrybean.bViewStandard?"Y":""%>'>

</font><br><br>
</td></tr>
</table>
</body>
</html>

