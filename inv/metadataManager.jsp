<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<%@ page info="DesConsultar Connection Diagnostics page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.system.Sys" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="indicator" class="org.lared.desinventar.webobject.MetadataIndicator" scope="session" />
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%if (user.iusertype<20) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}%>
<%@ include file="/util/opendatabase.jspf" %>
<%@ taglib uri="inventag.tld" prefix="inv" %>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/iheader",countrybean.getLanguage(),out);%>
<%@ taglib uri="inventag.tld" prefix="inv" %>
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
<% 
if(request.getParameter("retrieveMeta") != null){
	request.setAttribute("country", countrybean.countrycode);
	%><jsp:forward page="importXMLInFrame.jsp?action=3"/><%
}
if(request.getParameter("editMeta") != null){
%><jsp:forward page="metadataGroup.jsp" /><%
}
%> 
 
<script language="JavaScript">
<!--
function bSomethingSelected() 
{
if (document.desinventar.indicator_key.selectedIndex==-1)
	{
	alert ("<%=countrybean.getTranslation("Please select a group")%> <%=countrybean.getTranslation("fromthelist")%>...");
	return false;
	} 
return true;
}
// -->
</script>
 
<FORM name="desinventar" method="post" action="metadataManager.jsp">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<br/><br/> 
<table width="1024" border="0" rules="none">
<tr>
	<td align="center" valign="top">
	<!-- Content goes after this comment -->
    <table width="90%" border="0">
        <tr><td align="center">
         <font color="Blue"><%=countrybean.getTranslation("Region")%></font>
         <b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font>
          - [<jsp:getProperty name ="countrybean" property="countrycode"/>]
         </td>
        </tr>
    </table>
	<!-- Content goes before this comment -->
	</td>
</tr>
<tr><td align="left">
<span class=subTitle><%=countrybean.getTranslation("DesInventar Sendai Metadata Manager")%></span><br>
<br>
</td></tr>
<tr><td align="left">
<%=countrybean.getTranslation("Select the Metadata Group you want to create/edit:")%>
<br/><br/>
</td></tr>
 <tr><td>
 
	<SELECT name="indicator_key" style="WIDTH: 500px; HEIGHT: 230px; margin-left:130px;" size=10>
 	<inv:select tablename='metadata_indicator_lang' selected='<%=indicator.indicator_key%>' connection='<%= con %>'
    fieldname="indicator_description" codename='indicator_key' ordername='indicator_key' 
    language='<%=countrybean.getLanguage().toLowerCase()%>' languagefield="metadata_lang"/>
    </SELECT>
    <br/><br>
</td></tr>
 <tr><td align="left">
 <div style="WIDTH: 500px; margin-left:180px;">
    <input type="submit" name="editMeta" value='<%=countrybean.getTranslation("Edit")%>' onClick="return bSomethingSelected()">
    <input type="button" name="endMeta" value='<%=countrybean.getTranslation("Done")%>' onClick="document.location='sendaitab.jsp'">
 </div>
</td></tr>
<tr><td><br/><br/><br/></td></tr>
 <tr><td align="left">
 <div style="WIDTH: 500px; margin-left:180px;">
<input type="submit" name="retrieveMeta" value="<%=countrybean.getTranslation("Retrieve Price/Cost data from desinventar.net")%>" />
 </div>
 </td></tr>

</table>
<br><br>
</body>
</html>
