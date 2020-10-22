<%@ page info="DesInventar On-Line main page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="woFicha" class="org.lared.desinventar.webobject.fichas" scope="session" />
<jsp:useBean id="woExtension" class="org.lared.desinventar.webobject.extension" scope="session" />
<%@ include file="checkUserIsLoggedIn.jsp" %>
<% if (user.iusertype<20)  // only superusers, owner admin, for now.
  response.sendRedirect("/DesInventar/inv/noaccess.jsp");
%>
<%
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
// checks for a session alive variable, or we have a new valid countrycode
if (countrybean.countrycode.length()==0)
	{%><jsp:forward page="/inv/index.jsp"/><%}%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<title>DesInventar on-line : <%=countrybean.countryname%> <%=countrybean.getTranslation("ExtensionManager")%> </title>
</head>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/iheader",countrybean.getLanguage(),out);%>
<%@ taglib uri="inventag.tld" prefix="inv" %>
<script language="javascript">
function confirmRollBack()
{
 if (confirm('<%=countrybean.getTranslation("Are you sure you want to Roll Back your database?")%>'))
			postTo("SendaiRollback.jsp");
 return true;		
}
</script>
<%
int nTabActive=9; // 
String[] sTabNames={countrybean.getTranslation("Region"),countrybean.getTranslation("Geography"),countrybean.getTranslation("Events"),
           countrybean.getTranslation("Causes"),countrybean.getTranslation("Extension"),countrybean.getTranslation("Query"),
           countrybean.getTranslation("EditData"),countrybean.getTranslation("DataEntry"),countrybean.getTranslation("Admin"),
		   countrybean.getTranslation("Sendai"),countrybean.getTranslation("Security")};
String[] sTabIcons={"","","","","","","","","","","",""};
String[] sTabLinks={"index.jsp","geographytab.jsp","eventab.jsp",
				"causetab.jsp","extendedtab.jsp","querytab.jsp",
				"resultstab.jsp","datacardtab.jsp","admintab.jsp",
				"sendaitab.jsp","securitytab.jsp"};
%>
<%@ include file="/util/tabs.jspf" %>
<br/><br/>
<FORM NAME="desinventar" method="post">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<table width="1024" border="0" rules="none">
<tr>
	<td align="center" valign="top">
	<!-- Content goes after this comment -->
    <table width="90%" border="0">
        <tr><td align="center">
         <font color="Blue"><%=countrybean.getTranslation("Region")%></font>
         <b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b>
          - [<jsp:getProperty name ="countrybean" property="countrycode"/>]
         </td>
        </tr>
    </table>
	<!-- Content goes before this comment -->
	</td>
</tr>
<tr>
  <td>
	<table cellspacing="0" cellpadding="5" border="0" width="100%" rules="none">
	<tr>
	    <td height="25" td colspan="2" class='bgDark' align="center"><span class="title"><%=countrybean.getTranslation("Sendai Framework Manager")%></span>
        </td>
	</tr>
	<tr><td colspan="2" height="5"></td></tr>
	<tr><td colspan="2" align="center">
	<br>
	<table border="1" cellpadding="0" cellspacing="0" width=450>
	  <tr><td align="center">
      <br>
		<A class='linkText' href='javascript:postTo("SendaiMigration.jsp")'><%=countrybean.getTranslation("Migrate database to support Sendai Targets and Indicators")%></a><br><br>
		<A class='linkText' href='javascript:confirmRollBack()'><%=countrybean.getTranslation("Roll-back the Sendai migration of database")%></a><br><br>
		<%-- 
		 <A class='linkText' href='javascript:postTo("maintainMetadataNational.jsp")'><%=countrybean.getTranslation("Maintain National Metadata")%></a><br><br>
		 --%>
		 <A class='linkText' href='javascript:postTo("metadataNationalManager.jsp")'><%=countrybean.getTranslation("Maintain National Metadata")%></a><br><br>
		<A class='linkText' href='javascript:postTo("metadataManager.jsp")'><%=countrybean.getTranslation("Select Metadata to disaggregate Targets C and D ")%></a><br><br>
		<A class='linkText' href='javascript:postTo("sendaiMappingExtension.jsp")'><%=countrybean.getTranslation("Map Extension fields to indicators")%></a><br><br> 

<%
if (user.iusertype==99) 
 {%>
		<A class='linkText' href='javascript:postTo("sdgManager.jsp")'><%=countrybean.getTranslation("Processes required to generate SDG data")%></a><br><br> 
<%}%> 

 	  </td></tr>
	</table>
    <br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
	</td></tr>
	</table>
  </td>
 </tr>
</table>

</body>
</html>
