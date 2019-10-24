<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<title>DesInventar on-line - Cause Management</title>
</head>
<%@ page import = "org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.webobject.users" %>
<%@ page import="org.lared.desinventar.util.login" %>
<%@ page import="org.lared.desinventar.util.htmlServer" %>
<%@ page import = "java.sql.*" %>
<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id = "Cause" class="org.lared.desinventar.webobject.causas" scope="session" />

<%@ taglib uri="inventag.tld" prefix="inv" %>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
if (user.iusertype<20) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}%> 

<%@ include file="/util/opendatabase.jspf" %>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
 <body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
 
 
<% 
int nSqlResult =0;
String sErrorMessage="";
if (request.getParameter("addCause")!=null)
   {
    Cause.init();
	dbCon.close();
	%><jsp:forward page="causesUpdate.jsp?action=0"/><%
   }
else if (request.getParameter("editCause")!=null)
   {
    Cause.init();
	Cause.causa=request.getParameter("causa");
	Cause.getWebObject(con);
	dbCon.close();
	%><jsp:forward page="causesUpdate.jsp?action=1"/><%
   }
else if (request.getParameter("delCause")!=null)
   {
	Cause.causa=request.getParameter("causa");
	// verify datacards for references!!
	if (Cause.getReferenceCount("causa", Cause.causa, "fichas", con)==0)
		Cause.deleteWebObject(con);
	else
		sErrorMessage=countrybean.getTranslation("RecordcannotbeDeleted.Referencedby")+" "+countrybean.getTranslation("DataCards")+" "+countrybean.getTranslation("records_that_must_be_deleted");
   }
String sDisplayField="causa";
if (countrybean.getDataLanguage().equals("EN"))
	sDisplayField="causa_en";
%>
   
<script language="JavaScript">
<!--
function bSomethingSelected()
{
if (document.desinventar.causa.selectedIndex==-1)
	{
	alert ("<%=countrybean.getTranslation("Pleaseselecta")%> <%=countrybean.getTranslation("Cause")%> <%=countrybean.getTranslation("fromthelist")%>...");
	return false;
	} 
return true;
}
function confirmDelete()
{
if (bSomethingSelected())
	{
	return confirm ("<%=countrybean.getTranslation("Areyousureyouwanttodeletethis")%> <%=countrybean.getTranslation("Cause")%> ?");
	} 
else 
  return false;
}
// -->
</script>

<FORM name="desinventar" method="post" action="causeManager.jsp">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<table cellspacing="0" cellpadding="0" border="0" width="650">
<tr>
  <td width=50>&nbsp;</td>
  <td>
	<table cellspacing="0" cellpadding="5" border="0" width="650" rules="none">
	<tr>
	    <td height="25" td colspan="2" class='bgDark' align="center"><span class="title"><%=countrybean.getTranslation("CausesManager")%></span></td>
		</td>
	</tr>
	<tr><td colspan="2" height="5"></td></tr>
	<TR>
	<TD colspan=2 align="center"><span class="warning"><%=sErrorMessage%></span></TD>
	</TR>
	<tr><td colspan="2" height="5"></td></tr>
	<tr><td colspan="2" align="center">
	<SELECT name="causa" style="WIDTH: 350px; HEIGHT: 166px" size=10>
	<inv:select tablename='causas' selected='<%=Cause.causa%>' connection='<%= con %>'    fieldname="<%=sDisplayField%>" codename='causa' ordername='causa'/>
    </SELECT>
	</td></tr>
	<tr><td colspan="2" height="25"></td></tr>
	<tr><td colspan="2" align="center">
	<input type="submit" name="addCause" value="<%=countrybean.getTranslation("Add")%> <%=countrybean.getTranslation("Cause")%>">
	<input type="submit" name="editCause" value="<%=countrybean.getTranslation("Edit")%> <%=countrybean.getTranslation("Cause")%>" onClick="return bSomethingSelected()">
	<input type="submit" name="delCause" value="<%=countrybean.getTranslation("Delete")%> <%=countrybean.getTranslation("Cause")%>" onClick="return confirmDelete()">
	</td></tr>
	</table>
  </td>
 </tr>
</table>
</form>
</body>
</html>
<% dbCon.close(); %>

