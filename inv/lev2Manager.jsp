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
<jsp:useBean id = "Level2" class="org.lared.desinventar.webobject.lev2" scope="session" />
<%
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
%>
<%@ taglib uri="/inventag.tld" prefix="inv" %>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%
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
Level2.init();
if (request.getParameter("doneLevel2")!=null)
   {
	dbCon.close();
	%><jsp:forward page="lev1Manager.jsp"/><%
   }

if (request.getParameter("addLevel2")!=null)
   {
    Level2.init();
	Level2.lev2_lev1=Level1.lev1_cod;;
	dbCon.close();
	%><jsp:forward page="lev2Update.jsp?action=0"/><%
   }
else if (request.getParameter("editLevel2")!=null)
   {
    Level2.init();
	Level2.lev2_cod=request.getParameter("lev2_cod");
	Level2.getWebObject(con);
	dbCon.close();
	%><jsp:forward page="lev2Update.jsp?action=1"/><%
   }
else if (request.getParameter("delLevel2")!=null)
   {
	Level2.lev2_cod=request.getParameter("lev2_cod");
	Level2.getWebObject(con);
	// verify Level2 AND datacards for references!!
	if (Level2.getReferenceCount("Level2", Level2.lev2_cod, "fichas", con)==0)
		{
		Level2.deleteWebObject(con);
		}
	else
		sErrorMessage=countrybean.getTranslation("RecordcannotbeDeleted.Referencedby")+" "+countrybean.getTranslation("DataCards")+" "+countrybean.getTranslation("records_that_must_be_deleted");
   }
%>
   
<script language="JavaScript">
<!--
function bSomethingSelected()
{
if (document.desinventar.lev2_cod.selectedIndex==-1)
	{
	alert ("<%=countrybean.getTranslation("Pleaseselecta")%> <%=htmlServer.htmlEncode(countrybean.asLevels[2])%> <%=countrybean.getTranslation("fromthelist")%>...");
	return false;
	} 
return true;
}

function confirmDelete()
{
if (bSomethingSelected())
	{
	return confirm ("<%=countrybean.getTranslation("Areyousureyouwanttodeletethis")%> <%=htmlServer.htmlEncode(countrybean.asLevels[2])%> ?");
	} 
else 
  return false;
}

// -->
</script>

<FORM name="desinventar" method="post" action="lev2Manager.jsp">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<table cellspacing="0" cellpadding="0" border="0" width="650">
<tr>
  <td width=50>&nbsp;</td>
  <td>
	<table cellspacing="0" cellpadding="5" border="0" width="650" rules="none">
	<tr>
	    <td height="25" td colspan="2" class='bgDark' align="center"><span class="title"><%=countrybean.getTranslation("ManagementOf")%> <%=htmlServer.htmlEncode(countrybean.asLevels[2])%> (<%=htmlServer.htmlEncode(Level0.lev0_name)%> - <%=htmlServer.htmlEncode(Level1.lev1_name)%>)</span></td>
		</td>
	</tr>
	<tr><td colspan="2" height="5"></td></tr>
	<TR>
	<TD colspan=2 align="center"><span class="warning"><%=htmlServer.htmlEncode(sErrorMessage)%></span></TD>
	</TR>
	<tr><td colspan="2" height="5"></td></tr>
	<tr><td colspan="2" align="center">
	<% 
	String sWhere="lev2_lev1='"+Level1.lev1_cod+"'";
	String sField="lev2_name";
	if (countrybean.getDataLanguage().equals("EN"))
		sField+="_en";
	sField=countrybean.sqlConcat(countrybean.sqlConcat("lev2_cod ","' - '"),sField);
	%>
	<SELECT name="lev2_cod" style="WIDTH: 450px; HEIGHT: 166px" size=10>
	<inv:select tablename='lev2' selected='<%=Level2.lev2_cod%>' connection='<%= con %>'
    fieldname="<%=sField%>" codename='lev2_cod' ordername='lev2_name' whereclause='<%=sWhere%>'/>
    </SELECT>
	</td></tr>
	<tr><td colspan="2" height="25"></td></tr>
	<tr><td colspan="2" align="center">
	<input type="submit" name="addLevel2" value="<%=countrybean.getTranslation("Add")%> <%=htmlServer.htmlEncode(countrybean.asLevels[2])%>">&nbsp;&nbsp;&nbsp;
	<input type="submit" name="editLevel2" value="<%=countrybean.getTranslation("Edit")%> <%=htmlServer.htmlEncode(countrybean.asLevels[2])%>" onClick="return bSomethingSelected()">&nbsp;&nbsp;
	<input type="submit" name="delLevel2" value="<%=countrybean.getTranslation("Delete")%> <%=htmlServer.htmlEncode(countrybean.asLevels[2])%>" onClick="return confirmDelete()">	
	<br>
	<input name="doneLevel2" type=submit value='<%=countrybean.getTranslation("Done")%>'>
	</td></tr>
	</table>
  </td>
 </tr>
</table>
</form>
</body>
</html>
<% dbCon.close(); %>

