<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>DesConsultar on-line Help</title>
</head>
<%@ page info="DesConsultar On-Line help page: index" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css" />
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/header",countrybean.getLanguage(),out);%>
<script language="javascript">
<!--// put here javascript needed 


// -->
</script>

<!-- TABS TOP -->

<table width="690" border="0">
<tr><td align="center"><font color="Blue">Region: </font><font class='regionlink'>
<b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font>
 - [<jsp:getProperty name ="countrybean" property="countrycode"/>]
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
 <span class="subTitle">Query Definition</span>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
 <a href='/DesInventar/index.jsp' class='linkText'>Switch to Other Region</a>
</td></tr>
</table>
<table width="690" cellspacing="0" cellpadding="3" border="0">
<tr><td>
<!-- START:    Help content Area -->

Henriette:   put here the content of the help you are pasting from the documentation.



	
<!-- END:    Help content Area -->
</td></tr>
</table>
<form name="desinventar" method="post">
<INPUT type='hidden'  name="action"  value="">
<INPUT type='hidden'  name="frompage" value="<%=request.getServletPath()%>">
</form>
<%@ include file="/html/footer.html" %>
</body>
</html>

