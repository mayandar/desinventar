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
<jsp:useBean id = "Level1" class="org.lared.desinventar.webobject.lev1" scope="session" />
<%@ taglib uri="/inventag.tld" prefix="inv" %>
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
Level1.init();
if (request.getParameter("doneLevel1")!=null)
   {
	dbCon.close();
	%><jsp:forward page="lev0Manager.jsp"/><%
   }

if (request.getParameter("addLevel1")!=null)
   {
    Level1.init();
	Level1.lev1_lev0=Level0.lev0_cod;;
	dbCon.close();
	%><jsp:forward page="lev1Update.jsp?action=0"/><%
   }
else if (request.getParameter("editLevel1")!=null)
   {
    Level1.init();
	Level1.lev1_cod=request.getParameter("lev1_cod");
	Level1.getWebObject(con);
	dbCon.close();
	%><jsp:forward page="lev1Update.jsp?action=1"/><%
   }
else if (request.getParameter("editChildren1")!=null)
   {
    Level1.init();
	Level1.lev1_cod=request.getParameter("lev1_cod");
	Level1.getWebObject(con);
	dbCon.close();
	%><jsp:forward page="lev2Manager.jsp"/><%
   }
else if (request.getParameter("delLevel1")!=null)
   {
	Level1.lev1_cod=request.getParameter("lev1_cod");
	Level1.getWebObject(con);
	// verify level1 AND datacards for references!!
	if (Level1.getReferenceCount("level1", Level1.lev1_cod, "fichas", con)==0)
		{
		if (Level1.getReferenceCount("lev2_lev1", Level1.lev1_cod, "lev2", con)==0)
			Level1.deleteWebObject(con);
		else
			sErrorMessage=countrybean.getTranslation("RecordcannotbeDeleted.Referencedby")+" "+htmlServer.htmlEncode(countrybean.asLevels[2])+" "+countrybean.getTranslation("records_that_must_be_deleted");
		}
	else
		sErrorMessage=countrybean.getTranslation("RecordcannotbeDeleted.Referencedby")+" "+countrybean.getTranslation("DataCards")+" "+countrybean.getTranslation("records_that_must_be_deleted");
   }
%>
   
<script language="JavaScript">
<!--
function bSomethingSelected()
{
if (document.desinventar.lev1_cod.selectedIndex==-1)
	{
	alert ("<%=countrybean.getTranslation("Pleaseselecta")%> <%=htmlServer.htmlEncode(countrybean.asLevels[1])%> <%=countrybean.getTranslation("fromthelist")%>...");
	return false;
	} 
return true;
}

function confirmDelete()
{
if (bSomethingSelected())
	{
	return confirm ("<%=countrybean.getTranslation("Areyousureyouwanttodeletethis")%>  <%=countrybean.asLevels[1]%> ?");
	} 
else 
  return false;
}

// -->
</script>

<FORM name="desinventar" method="post" action="lev1Manager.jsp">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<table cellspacing="0" cellpadding="0" border="0" width="650">
<tr>
  <td width=50>&nbsp;</td>
  <td>
	<table cellspacing="0" cellpadding="5" border="0" width="650" rules="none">
	<tr>
	    <td height="25" td colspan="2" class='bgDark' align="center"><span class="title"><%=countrybean.getTranslation("ManagementOf")%> <%=htmlServer.htmlEncode(countrybean.asLevels[1])%> (<%=htmlServer.htmlEncode(Level0.lev0_name)%>)</span></td>
		</td>
	</tr>
	<tr><td colspan="2" height="5"></td></tr>
	<TR>
	<TD colspan=2 align="center"><span class="warning"><%=sErrorMessage%></span></TD>
	</TR>
	<tr><td colspan="2" height="5"></td></tr>
	<tr><td colspan="2" align="center">
	<% 
	String sWhere="lev1_lev0='"+Level0.lev0_cod+"'";
	String sField="lev1_name";
	if (countrybean.getDataLanguage().equals("EN"))
		sField+="_en";
	sField=countrybean.sqlConcat(countrybean.sqlConcat("lev1_cod ","' - '"),sField);
	%>
	<SELECT name="lev1_cod" style="WIDTH: 450px; HEIGHT: 166px" size=10>
	<inv:select tablename='lev1' selected='<%=Level1.lev1_cod%>' connection='<%= con %>'
    fieldname="<%=sField%>" codename='lev1_cod' ordername='lev1_name' whereclause='<%=sWhere%>'/>
    </SELECT>
	</td></tr>
	<tr><td colspan="2" height="25"></td></tr>
	<tr><td colspan="2" align="center">
	<input type="submit" name="addLevel1" value="<%=countrybean.getTranslation("Add")%> <%=htmlServer.htmlEncode(countrybean.asLevels[1])%>">
	<input type="submit" name="editLevel1" value="<%=countrybean.getTranslation("Edit")%> <%=htmlServer.htmlEncode(countrybean.asLevels[1])%>" onClick="return bSomethingSelected()">
	<input type="submit" name="delLevel1" value="<%=countrybean.getTranslation("Delete")%> <%=htmlServer.htmlEncode(countrybean.asLevels[1])%>" onClick="return confirmDelete()">	<br><br>
	<input type="submit" name="editChildren1" value="<%=countrybean.getTranslation("Manage")%> <%=htmlServer.htmlEncode(countrybean.asLevels[2])%> <%=countrybean.getTranslation("ofThis")%>  <%=htmlServer.htmlEncode(countrybean.asLevels[1])%>" onClick="return bSomethingSelected()">
    <br><br>
	<input name="doneLevel1" type=submit value='<%=countrybean.getTranslation("Done")%>'>
	</td></tr>
	</table>
  </td>
 </tr>
</table>
</form>
</body>
</html>
<% dbCon.close(); %>

