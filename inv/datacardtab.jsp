<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8");%>
<%@ page info="DesInventar On-Line data entry page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="woFicha" class="org.lared.desinventar.webobject.fichas" scope="session" />
<jsp:useBean id="woExtension" class="org.lared.desinventar.webobject.extension" scope="session" />
<%// checks for a session alive variable, or we have a new valid countrycode
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
if (countrybean.countrycode.length()==0)
	{%><jsp:forward page="/inv/index.jsp"/>
	<%}%>
<%@ include file="checkUserIsLoggedIn.jsp" %>
<%if (user.iusertype<1) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}%>
<%@ include file="/util/opendatabase.jspf" %>
<html>
<head>
<title><%=countrybean.countryname%><%=countrybean.getTranslation("DataEntry")%> </title>
</head> 
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/iheader",countrybean.getLanguage(),out);%>
<%@ taglib uri="/inventag.tld" prefix="inv" %>
<script language="JavaScript">
document.body.scroll='no';
</script>
<%
int nTabActive=7; // 
String[] sTabNames={countrybean.getTranslation("Region"),countrybean.getTranslation("Geography"),countrybean.getTranslation("Events"),
           countrybean.getTranslation("Causes"),countrybean.getTranslation("Extension"),countrybean.getTranslation("Query"),
           countrybean.getTranslation("EditData"),countrybean.getTranslation("DataEntry"),countrybean.getTranslation("Admin"),
		   countrybean.getTranslation("Sendai"),countrybean.getTranslation("Security")};
String[] sTabIcons={"","","","","","","","","","",""};
String[] sTabLinks={"index.jsp","geographytab.jsp","eventab.jsp",
				"causetab.jsp","extendedtab.jsp","querytab.jsp",
				"resultstab.jsp","datacardtab.jsp","admintab.jsp",
				"sendaitab.jsp","securitytab.jsp"};
%>
<%@ include file="/util/tabs.jspf" %>
<table width="100%" border="1" class="pageBackground" rules="none">
<tr><td align="left" valign="top">
<!-- Content goes after this comment -->
	<table width="1000" border="0">
	<tr><td align="center">
	<font color="Blue"><%=countrybean.getTranslation("Region")%></font>
	<b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font>
	- [<jsp:getProperty name ="countrybean" property="countrycode"/>]
	</td></tr>
	</table>
<!-- Content goes before this comment -->
</td></tr>
</table><br/>
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
<form name="desinventar"  method=post action="datacardtab.jsp">
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
