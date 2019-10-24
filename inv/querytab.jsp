<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<%@ page info="DesInventar On-Line main page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.map.*" %>

<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="woFicha" class="org.lared.desinventar.webobject.fichas" scope="session" />
<jsp:useBean id="woExtension" class="org.lared.desinventar.webobject.extension" scope="session" />
<title>DesInventar on-line : <%=countrybean.countryname%> Query edit data </title>
</head>
<%// checks for a session alive variable, or we have a new valid countrycode
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
if (countrybean.countrycode.length()==0)
	{%><jsp:forward page="/inv/index.jsp"/><%}	
%>
<%@ include file="checkUserIsLoggedIn.jsp" %>
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/iheader",countrybean.getLanguage(),out);%>
<%@ taglib uri="inventag.tld" prefix="inv" %>

<script language="javascript">
<!-- 
function gotoPage(tabpage)
{
// checks there's a selection
with (document.desinventar)
	{
	// saves the page to forward to...
    actiontab.value=tabpage;
	submit();
	}
}
<%
parser Parser=new parser();
String sExpertTranslation="";
Parser.buildTranslations(countrybean, true);
if (request.getParameter("frompage")!=null && request.getParameter("frompage").equals(request.getServletPath()))
	{
	countrybean.loadVectors(request);
	// the expert:
	if (request.getParameter("sExpertWhere")!=null)
	   {
	   sExpertTranslation=request.getParameter("sExpertWhere");
	   countrybean.sExpertWhere=Parser.translateExpertExpression(sExpertTranslation, Parser.hmVarUntrans);
	   }
	else
	    countrybean.sExpertWhere=""; 
    if (countrybean.not_null(request.getParameter("actiontab")).length()>0)
	    {
     	%>window.location='<%=request.getParameter("actiontab")%>';<%
		}
     }
%>
// -->
</script>


<%
int nTabActive=5;
String[] sTabNames={countrybean.getTranslation("Region"),countrybean.getTranslation("Geography"),countrybean.getTranslation("Events"),
           countrybean.getTranslation("Causes"),countrybean.getTranslation("Extension"),countrybean.getTranslation("Query"),
           countrybean.getTranslation("EditData"),countrybean.getTranslation("DataEntry"),countrybean.getTranslation("Admin"),
		   countrybean.getTranslation("Sendai"),countrybean.getTranslation("Security")};
String[] sTabIcons={"","","","","","","","","","","",""};

/* This page requires an post when moving to other tabls so that the form parameters are applied */
String[] sTabLinks={"index.jsp","javascript:gotoPage('geographytab.jsp')","javascript:gotoPage('eventab.jsp')",
				"javascript:gotoPage('causetab.jsp')","javascript:gotoPage('extendedtab.jsp')","javascript:gotoPage('querytab.jsp')",
				"javascript:gotoPage('resultstab.jsp')","javascript:gotoPage('datacardtab.jsp')","javascript:gotoPage('admintab.jsp')",
				"javascript:gotoPage('sendaitab.jsp')","javascript:gotoPageinconditional('securitytab.jsp')"};


%>
<%@ include file="/util/tabs.jspf" %>
<table width="1024" border="1"  id="contentFrame"  class="pageBackground" rules="none" height="500">
<tr><td align="left" valign="top">
<!-- Content goes after this comment -->
<%@ taglib uri="inventag.tld" prefix="inv" %>
<%// opens the country database %>
<%@ include file="checkUserIsLoggedIn.jsp" %>
<%if (user.iusertype<1) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}%>
<%@ include file="/util/opendatabase.jspf" %>
<%
// now it should read the names of the levels. 
// It is done in the bean, so it can be reused as properties...
countrybean.getLevelsFromDB(con);
// and loads the datacard extension
woExtension.dbType=dbType;
woExtension.loadExtension(con,countrybean);
%>
<%@ include file="/util/showDialog.jspf" %> 
<%@ include file="/queryPage.jspf" %> 
</td>
</tr>
</table>
</td>
</tr>
</table>
<script src="/DesInventar/inv/resize.js"></script>
</body>
</html>
