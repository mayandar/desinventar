<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<%@ page info="DesConsultar simple results page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ include file="/util/opendatabase.jspf" %> 
<head>
<title><%=countrybean.getTranslation("Expert")%></title>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
</head>
<script language="JavaScript">
function doDiagOK()
	{
<%
boolean bIEBrowser = (request.getHeader("User-Agent").indexOf("MSIE")>0);
boolean bIEdge = (request.getHeader("User-Agent").indexOf("Edge")>0);
if (!bIEBrowser) { %>
		    opener.loadDone("loadOK");
	<%}%>	
		window.returnValue = "loadOK";
		window.close();
	}
	
function cancelAction()
	{
	window.returnValue = "";
	window.close();
    }
</script>

 <table width="100%" border="1" class="pageBackground" rules="none" height="100%">
<tr>
	<td valign="top">
	<table width="100%" border="0">
	<tr><td align="left">
	<font class='ltbluelg'><%=countrybean.getTranslation("Region")%></font><a href="javascript:routeTo('main.jsp','allSelected(0)')"><font class='regionlink'>
	<b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font></a>
	 - [<jsp:getProperty name ="countrybean" property="countrycode"/>]
	</td><td nowrap  align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<span class="subTitle"><%=countrybean.getTranslation("LoadQuery")%></span>
	</td>
	</tr>
	</table>
</tr>
<tr>
	<td>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr><td colspan="3" align="left">
	<iframe id="querysaver" name="querysaver" height="150" width="450" frameborder="0" src="/DesInventar/queryloader.jsp"></iframe>
	</td></tr>
	</table>


</td></tr>
</table>
</body>
<%
dbCon.close();
%>

</html>
