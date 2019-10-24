<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<title>DesInventar on-line - Geography Management</title>
</head>
<%@ page import = "org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.webobject.users" %>
<%@ page import="org.lared.desinventar.util.login" %>
<%@ page import="org.lared.desinventar.util.htmlServer" %>
<%@ page import = "java.sql.*" %>
<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id = "Level0" class="org.lared.desinventar.webobject.lev0" scope="session" />
<%
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
%>
<%@ taglib uri="inventag.tld" prefix="inv" %>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%if (user.iusertype<20) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}%>
<%@ include file="/util/opendatabase.jspf" %>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
<script type="text/javascript" src="/DesInventar/html/iheader.js"></script> 
 
<%
countrybean.getLevelsFromDB(con);
int nSqlResult =0;
String sErrorMessage="";
if (request.getParameter("addLevel0")!=null)
   {
    Level0.init();
	dbCon.close();
	%><jsp:forward page="lev0Update.jsp?action=0"/><%
   }
else if (request.getParameter("editLevel0")!=null)
   {
    Level0.init();
	Level0.lev0_cod=request.getParameter("lev0_cod");
	Level0.getWebObject(con);
	dbCon.close();
	%><jsp:forward page="lev0Update.jsp?action=1"/><%
   }
else if (request.getParameter("editChildren0")!=null)
   {
    Level0.init();
	Level0.lev0_cod=request.getParameter("lev0_cod");
	Level0.getWebObject(con);
	dbCon.close();
	%><jsp:forward page="lev1Manager.jsp"/><%
   }
else if (request.getParameter("delLevel0")!=null)
   {
	Level0.lev0_cod=request.getParameter("lev0_cod");
	Level0.getWebObject(con);
	// verify level1 AND datacards for references!!
	if (Level0.getReferenceCount("level0", Level0.lev0_cod, "fichas", con)==0)
		{
		if (Level0.getReferenceCount("lev1_lev0", Level0.lev0_cod, "lev1", con)==0)
			Level0.deleteWebObject(con);
		else
			sErrorMessage=countrybean.getTranslation("RecordcannotbeDeleted.Referencedby")+countrybean.asLevels[1]+" "+countrybean.getTranslation("records_that_must_be_deleted");
		}
	else
		sErrorMessage=countrybean.getTranslation("RecordcannotbeDeleted.Referencedby")+" "+countrybean.getTranslation("DataCards")+" "+countrybean.getTranslation("records_that_must_be_deleted");
   }
%>
   
<script language="JavaScript">
<!--
function bSomethingSelected()
{
if (document.desinventar.lev0_cod.selectedIndex==-1)
	{
	alert ("<%=countrybean.getTranslation("Pleaseselecta")%> <%=countrybean.asLevels[0]%> <%=countrybean.getTranslation("fromthelist")%>...");
	return false;
	} 
return true;
}
function confirmDelete()
{
if (bSomethingSelected())
	{
	return confirm ("<%=countrybean.getTranslation("Areyousureyouwanttodeletethis")%> <%=countrybean.asLevels[0]%> ?");
	} 
else 
  return false;
}

// -->
</script>

<FORM name="desinventar" method="post" action="lev0Manager.jsp">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<table cellspacing="0" cellpadding="0" border="0" width="100%">
<tr>
  <td width=50>&nbsp;</td>
  <td>
	<table cellspacing="0" cellpadding="5" border="0" width="800" rules="none">
	<tr>
	    <td height="25" td colspan="2" class='bgDark' align="center"><span class="title"><%=countrybean.getTranslation("ManagementOf")%>: <%=htmlServer.htmlEncode(countrybean.asLevels[0])%></span></td>
		</td>
	</tr>
	<tr><td colspan="2" height="5"></td></tr>
	<TR>
	<TD colspan=2 align="center"><span class="warning"><%=htmlServer.htmlEncode(sErrorMessage)%></span></TD>
	</TR>
	<tr><td colspan="2" height="5"></td></tr>
	<tr><td colspan="2" align="center">
	<% 
	String sWhere=""; 
	String sField="lev0_name";
	if (countrybean.getDataLanguage().equals("EN"))
		sField+="_en";
	sField=countrybean.sqlConcat(countrybean.sqlConcat("lev0_cod", "' - '"),sField);
	%>
	<SELECT name="lev0_cod" style="WIDTH: 450px; HEIGHT: 166px" size=10>
	<inv:select tablename='lev0' selected='<%=Level0.lev0_cod%>' connection='<%= con %>'
    fieldname="<%=sField%>" codename='lev0_cod' ordername='lev0_name asc'/>
    </SELECT>
	</td></tr>
	<tr><td colspan="2" height="25"></td></tr>
	<tr><td colspan="2" align="center">
	<input type="submit" name="addLevel0" value="<%=countrybean.getTranslation("Add")%> <%=htmlServer.htmlEncode(countrybean.asLevels[0])%>">&nbsp;&nbsp;&nbsp;
	<input type="submit" name="editLevel0" value="<%=countrybean.getTranslation("Edit")%> <%=htmlServer.htmlEncode(countrybean.asLevels[0])%>" onClick="return bSomethingSelected()">&nbsp;&nbsp;&nbsp;
	<input type="submit" name="delLevel0" value="<%=countrybean.getTranslation("Delete")%> <%=htmlServer.htmlEncode(countrybean.asLevels[0])%>" onClick="return confirmDelete()">
	<br><br>
	<input type="submit" name="editChildren0" value="<%=countrybean.getTranslation("Manage")%> <%=htmlServer.htmlEncode(countrybean.asLevels[1])%> <%=countrybean.getTranslation("ofThis")%>  <%=htmlServer.htmlEncode(countrybean.asLevels[0])%>" onClick="return bSomethingSelected()">
    <br><br>
	<input type="button" name="tolevels" value="<%=countrybean.getTranslation("ManageLevels")%>" onClick="postTo('levelManager.jsp')">
	<input type="button" name="toAtrlevels" value="<%=countrybean.getTranslation("ManageAttributes")%>" onClick="postTo('levelAttributeManager.jsp')">
	<input type="button" name="toMaplevels" value="<%=countrybean.getTranslation("ManageMaps")%>" onClick="postTo('levelMapManager.jsp')">
	<input type="button" name="toLayers" value="<%=countrybean.getTranslation("ManageLayers")%>" onClick="postTo('mapLayers.jsp')">
    <br><br>
	<input type="button" name="Geocoder" value="<%=countrybean.getTranslation("Google-Geocode")%>" onClick="postTo('geocode_google.jsp')">
	</td></tr>
	</table>
  </td>
 </tr>
</table>
</form>
</body>
</html>
<% dbCon.close(); %>

