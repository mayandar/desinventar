<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<title>DesInventar on-line - User Management</title>
</head>
<%@ page import = "org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.webobject.users" %>
<%@ page import="org.lared.desinventar.util.login" %>
<%@ page import="org.lared.desinventar.util.htmlServer" %>
<%@ page import = "java.sql.*" %>
<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id = "User" class="org.lared.desinventar.webobject.users" scope="session" />
<%
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
%>

<%@ taglib uri="/inventag.tld" prefix="inv" %>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%@ include file="/util/opendefaultdatabase.jspf" %>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
 
<%
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
if (user.iusertype<40) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}
 
int nSqlResult =0;
String sErrorMessage="";
if (request.getParameter("addUser")!=null)
   {
    User.init();
	User.dbType=Sys.iDatabaseType;
	dbCon.close();
	%><jsp:forward page="UsersGet.jsp"/><%
   }
else if (request.getParameter("editUser")!=null)
   {
	User.suserid=request.getParameter("suserid");
	User.getWebObject(con);
	dbCon.close();
	%><jsp:forward page="UsersUpdate.jsp"/><%
   }
else if (request.getParameter("permUser")!=null)
   {
	User.suserid=request.getParameter("suserid");
	User.getWebObject(con);
	dbCon.close();
	%><jsp:forward page="userPermissions.jsp"/><%
   }
else if (request.getParameter("delUser")!=null)
   {
	User.suserid=request.getParameter("suserid");
	User.getWebObject(con);
	User.bactive=0;
	if (User.getReferenceCount("userid", User.suserid, "user_permissions", con)==0)
		User.deleteWebObject(con);
	else
		sErrorMessage=countrybean.getTranslation("CannotBeDeletedNote");
   }
%>
   
<script language="JavaScript">
<!--
function bSomethingSelected()
{
if (document.desinventar.suserid.selectedIndex==-1)
	{
	alert ("<%=countrybean.getTranslation("PleaseSelectUser")%>...");
	return false;
	} 
return true;
}

function confirmDelete()
{
if (bSomethingSelected())
	{
	return confirm ("<%=countrybean.getTranslation("Areyousureyouwanttodeletethis")%> <%=countrybean.getTranslation("User")%> ?");
	} 
else 
  return false;
}
// -->
</script>

<table cellspacing="0" cellpadding="0" border="0" width="650" align="center">
<tr>
  <td width=50>&nbsp;</td>
  <td>
	<table cellspacing="0" cellpadding="5" border="0" width="650" rules="none">
	<FORM name="desinventar" method="post" action="userManager.jsp">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
	<tr>
	    <td height="25" td colspan="2" class='bgDark' align="center"><span class="title">DesInventar - <%=countrybean.getTranslation("UserManager")%></span></td>
		</td>
	</tr>
	<tr><td colspan="2" height="5"></td></tr>
	<TR>
	<TD colspan=2 align="center"><span class="warning"><%=sErrorMessage%></span></TD>
	</TR>
	<tr><td colspan="2" height="5"></td></tr>
	<tr><td colspan="2" align="center">
	<% 
	String sWhere="";
	User.dbType=Sys.iDatabaseType; //dbType
	//String sField=User.sqlConcat(User.sqlConcat(User.sqlConcat(User.sqlConcat("sUserid ","' '")," sFirstName "), "' '")," sLastName ");
	//String sField=User.sqlConcat(User.sqlConcat(User.sqlConcat(User.sqlConcat("sUserid ","N' '")," sFirstName "), "N' '")," sLastName ");
	String sField="sUserid ";
	%>
	<SELECT name="suserid" style="WIDTH: 250px; HEIGHT: 166px" size=10>
	<inv:select tablename='users' selected='<%=User.suserid%>' connection='<%= con %>'
    fieldname="<%=sField%>" codename='suserid' ordername='<%=sField%>' whereclause='<%=sWhere %>'/>
    </SELECT>
	</td></tr>
	<tr><td colspan="2" height="25"></td></tr>
	<tr><td colspan="2" align="center">
	<input type="submit" name="addUser" value="<%=countrybean.getTranslation("Add")%> <%=countrybean.getTranslation("User")%>">
	<input type="submit" name="editUser" value="<%=countrybean.getTranslation("Edit")%> <%=countrybean.getTranslation("User")%>" onClick="return bSomethingSelected()">
	<input type="submit" name="delUser" value="<%=countrybean.getTranslation("Delete")%> <%=countrybean.getTranslation("User")%>" onClick="return confirmDelete()">
	<input type="submit" name="permUser" value="<%=countrybean.getTranslation("Permissions")%>" onClick="return bSomethingSelected()"><br>
	</td></tr>
	</form>
	</table>
  </td>
 </tr>
</table>
</body>
</html>
<% dbCon.close(); %>

