<%@ page info="DesInventar On-Line main page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.system.Sys" %>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.map.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<%
if (request.getParameter("reload")!=null)
	{
	String sLang=countrybean.getLanguage();
	countrybean.reloadBundles();
	countrybean.setLanguage(sLang);
	}
	WebMapService.clearLayers();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>DesInventar on-line : <%=countrybean.countryname%> Admin Manager </title>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="/DesInventar/html/iheader.js"></script> 
</head>
<body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
 
<script language="JavaScript">
function confirmOption(takeMe, message)
{
if (confirm("<%=countrybean.getTranslation("Areyousureyouwantto")%> "+message+" <%=countrybean.getTranslation("ThisMayDisable")%> ?... "))
	postTo(takeMe);
}
function queryRegion()
{
parent.window.location="/DesInventar/main.jsp"
}

function someAccess(sPage)
{
if (parent.bNotInFrame)
	parent.window.location=sPage;
else
	window.location=sPage;
}

</script>
<br/>
<div align="left">
<FORM NAME="desinventar" method="post">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<table width="800" cellspacing="2" cellpadding="2" border=0 align="left" class="bs">
<% if (user.iusertype>=20) 
{%>
<tr> 
 <td align="center" width='50%'>
	<table border="1" cellpadding="2" cellspacing="0" width="80%" class='IE_Table'>
	  <tr><td align="center" class="DI_TableHeader bs whitetext">
          <div class="titleTextWhite"><%=countrybean.getTranslation("GeneralAdministrativeFunctions")%>:</div>
		  </td>
	  </tr>
	  <tr><td align="center">
      <br>
<% if (user.iusertype>=40) 
 {%>
	  <A class=linkText href='javascript:postTo("regionManager.jsp")'><%=countrybean.getTranslation("RegionAdministration")%></a><br><br>
<%}
else
{
out.print(countrybean.getTranslation("RegionAdministration"));
}

if (user.iusertype>=99)
  { // only superuser: %>
  	  <A class='linkText' href='javascript:postTo("sqlexecMain.jsp")'><%=countrybean.getTranslation("RunScript")%> [Main DB]</a><br><br>
	  <A  class='linkText' href='javascript:postTo("parameterManager.jsp")'><%=countrybean.getTranslation("ParameterAdministration")%></a><br><br>
<%}%>
	  </td></tr>
	</table>
   </td>
   </tr>
   <%if (countrybean.countrycode.length()>0)
    {%>
   <tr>
	   <td align="center"  width='50%'>
		<table border="1" cellpadding="1" cellspacing="0" width='80%' class='IE_Table'>
		  <tr><td align="center" class="DI_TableHeader bs whitetext">
	          <div class="titleTextWhite"><%=countrybean.getTranslation("DataAdministrationFunctions")%> <strong> [<%=countrybean.countryname%>]</strong>:</div>
			  </td>
		  </tr>
		  <tr><td align="center">
	      <br>
			<A class='linkText' href="javascript:confirmOption('/DesInventar/inv/reIndex.jsp','<%=countrybean.getTranslation("FullreindexofthisRegion")%>')"><%=countrybean.getTranslation("FullreindexofthisRegion")%></a>	  <br><br>
			<A class='linkText' href='javascript:postTo("importDI6.jsp")'><%=countrybean.getTranslation("ImportAccess")%></a><br><br>
			<A class='linkText' href='javascript:postTo("importDI7.jsp")'><%=countrybean.getTranslation("ImportOther")%></a><br><br>
			<A class='linkText' href='javascript:postTo("ImportExcel.jsp")'><%=countrybean.getTranslation("ImportEXCEL")%></a><br><br>
			<A class='linkText' href='javascript:postTo("importDI8SQLite.jsp")'><%=countrybean.getTranslation("Import from DI-8 SQLITE FORMAT")%></a><br><br>
			<A class='linkText' href='javascript:postTo("ImportJdbc.jsp")'><%=countrybean.getTranslation("ImportTABLE")%></a><br><br>
			<A class='linkText' href="javascript:parent.window.location='/DesInventar/download_base.jsp?countrycode=<%=countrybean.country.scountryid%>'"><%=countrybean.getTranslation("ExportXML")%></a><br><br>			
			<A class='linkText' href='javascript:postTo("importXML.jsp")'><%=countrybean.getTranslation("importXML")%></a><br><br>
			<font class='linkText'><%=countrybean.getTranslation("Export SQL")%>: </font>
			<A class='linkText' href='javascript:postTo("exportSQL.jsp?dbType=0")'>Oracle</a>&nbsp;|
			<A class='linkText' href='javascript:postTo("exportSQL.jsp?dbType=2")'>SQL Server</a>&nbsp;|
			<A class='linkText' href='javascript:postTo("exportSQL.jsp?dbType=5")'>PostgreSQL</a>&nbsp;|
			<A class='linkText' href='javascript:postTo("exportSQL.jsp?dbType=3")'>MySQL</a>&nbsp;|
			<A class='linkText' href='javascript:postTo("exportSQL.jsp?dbType=1")'>MS Access</a>
			<br><br>
			<A class='linkText' href='javascript:postTo("sqlexec.jsp")'><%=countrybean.getTranslation("RunScript")%></a><br><br>
			<A class='linkText' href='javascript:postTo("fileLoader.jsp")'><%=countrybean.getTranslation("Upload files to directory")%></a><br><br>
		  </td></tr>
		</table>
      </td>	  
    </tr>
    <tr>
     <td align="center">
        <table border="1" cellpadding="2" cellspacing="0" width='80%' class='IE_Table'>
          <tr><td align="center" class="DI_TableHeader bs whitetext">
              <div class="titleTextWhite"><%=countrybean.getTranslation("Loss Exceedance Curves")%>   <strong> [<%=countrybean.countryname%>]</strong>:</div>
              </td>
          </tr>
          <tr><td align="center">
 <br>
          <A  class=linkText href='javascript:postTo("LEC/LEC_C.jsp")'><%=countrybean.getTranslation("New Loss Exceedance Curve Module")%></a><br><br>
          
          <br>
          <A  class=linkText href='javascript:postTo("LEC_grouping.jsp")'><%=countrybean.getTranslation("Automated Grouping of Physical Events")%></a><br><br>
          <A  class=linkText href='javascript:postTo("LEC_inflation_exchange.jsp")'><%=countrybean.getTranslation("Calculate Inflation and convert currency to USD")%></a><br><br>
          <A  class=linkText href='javascript:postTo("LEC_economic_valuation.jsp")'><%=countrybean.getTranslation("Calculate Economic Valuation")%></a><br><br>
          <A  class=linkText href='javascript:postTo("LEC_excel.jsp")'><%=countrybean.getTranslation("Generate Excel file with Curves")%></a><br><br>

          </td></tr>
        </table>
       </td>	  
    </tr>
	<%}%>
<%}%>

<tr>
 <td align="center">
	<table border="1" cellpadding="2" cellspacing="0" width='80%' class='IE_Table'>
	  <tr><td align="center" class="DI_TableHeader bs whitetext">
          <div class="titleTextWhite"><%=countrybean.getTranslation("UsefulLinks")%>:</div>
		  </td>
	  </tr>
	  <tr><td align="center">
	  <br>
      <A  class=linkText href="javascript:queryRegion()"><%=countrybean.getTranslation("QueryThisRegion")%></a><br><br>
	  <A  class=linkText href='javascript:postTo("logout.jsp")'><%=countrybean.getTranslation("Logout")%></a><br><br>
	  <A  class=linkText href='javascript:postTo("adminManager.jsp?&usrtkn=<%=countrybean.userHash%>&reload=true")'><%=countrybean.getTranslation("ReloadTranslations")%></a><br><br>
	  </td></tr>
	</table>
   </td>	  
</tr>


</table>
</FORM>
</div>
</body>
</html>

