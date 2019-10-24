<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<title>DesInventar on-line - Group Management</title>
</head>
<%@ page import = "org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.webobject.users" %>
<%@ page import="org.lared.desinventar.util.login" %>
<%@ page import="org.lared.desinventar.util.htmlServer" %>
<%@ page import="org.lared.desinventar.webobject.extensiontabs" %>
<%@ page import = "java.sql.*" %>
<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id = "Group" class="org.lared.desinventar.webobject.extensiontabs" scope="session" />
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
int nSqlResult =0;
String sErrorMessage="";
extensiontabs swap=new extensiontabs();
if (request.getParameter("addGroup")!=null)
   {
    Group.init();
	Group.ntab=Group.getMaximum("ntab", "extensiontabs", con)+1;
	Group.nsort=Group.getMaximum("nsort", "extensiontabs", con)+1;
	dbCon.close();
	%><jsp:forward page="groupUpdate.jsp?action=0"/><%
   }
else if (request.getParameter("editGroup")!=null)
   {
    Group.init();
	Group.ntab=Group.extendedParseInt(request.getParameter("ntab"));
	Group.getWebObject(con);
	dbCon.close();
	%><jsp:forward page="groupUpdate.jsp?action=1"/><%
   }
else if (request.getParameter("assignGroup")!=null)
   {
    Group.init();
	Group.ntab=Group.extendedParseInt(request.getParameter("ntab"));
	Group.getWebObject(con);
	dbCon.close();
	%><jsp:forward page="groupAssign.jsp"/><%
   }
else if (request.getParameter("delGroup")!=null)
   {
	Group.ntab=Group.extendedParseInt(request.getParameter("ntab"));
	Group.getWebObject(con);
	// confirm delete!!!!
	dbCon.close();
	%><jsp:forward page="groupUpdate.jsp?action=2"/><%
   }
else if (request.getParameter("upGroup")!=null)
   {
	Group.ntab=Group.extendedParseInt(request.getParameter("ntab"));
	Group.getWebObject(con);
	stmt=con.createStatement();
	rset=stmt.executeQuery("select *  from extensiontabs where nsort<"+Group.nsort+ " order by nsort desc");
	if (rset.next())
		{
		swap.loadWebObject(rset);
		int tempOrder=swap.nsort;
		swap.nsort=-1;
		swap.updateWebObject(con);
		swap.nsort=Group.nsort;
		Group.nsort=tempOrder;
		Group.updateWebObject(con);
		swap.updateWebObject(con);
		}
	rset.close();	
	stmt.close();
   }
else if (request.getParameter("downGroup")!=null)
   {
	Group.ntab=Group.extendedParseInt(request.getParameter("ntab"));
	Group.getWebObject(con);
	stmt=con.createStatement();
	rset=stmt.executeQuery("select * from extensiontabs where nsort>"+Group.nsort+ " order by nsort");
	if (rset.next())
		{
		swap.loadWebObject(rset);
		int tempOrder=swap.nsort;
		swap.nsort=-1;
		swap.updateWebObject(con);
		swap.nsort=Group.nsort;
		Group.nsort=tempOrder;
		Group.updateWebObject(con);
		swap.updateWebObject(con);
		}
	rset.close();	
	stmt.close();
   }
%>
   
<script language="JavaScript">
<!--
function bSomethingSelected()
{
if (document.desinventar.ntab.selectedIndex==-1)
	{
	alert ("<%=countrybean.getTranslation("Pleaseselectatabfromthelist")%>...");
	return false;
	} 
return true;
}
function confirmDelete()
{
if (bSomethingSelected())
	{
	return confirm ("<%=countrybean.getTranslation("AreyousureyouwanttodeletethisTab")%>");
	} 
else 
  return false;
}
//   -->
</script>

<FORM name="desinventar" method="post" action="groupManager.jsp">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<table cellspacing="0" cellpadding="0" border="0" width="850">
<tr>
  <td width=50>&nbsp;</td>
  <td align="center">
	<table cellspacing="0" cellpadding="5" border="0" width="650" rules="none">
	<tr>
	    <td height="25" td colspan="2" class='bgDark' align="center"><span class="title"><%=countrybean.getTranslation("TabManager")%></span></td>
		</td>
	</tr>
	<tr><td colspan="2" height="5"></td></tr>
	<TR>
	<TD colspan=2 align="center"><span class="warning"><%=sErrorMessage%></span></TD>
	</TR>
	<tr><td colspan="2" height="5"></td></tr>
	<tr><td colspan="2" align="center">
	<SELECT name="ntab" style="WIDTH: 450px; HEIGHT: 166px" size=10>
	<inv:select tablename='extensiontabs' selected='<%=Group.ntab%>' connection='<%= con %>'
    fieldname="svalue" codename='ntab' ordername='nsort'/>
    </SELECT>
	</td></tr>
	<tr><td colspan="2" align="center">
	<input type="submit" name="upGroup" value="<%=countrybean.getTranslation("tabUP")%>" onClick="return bSomethingSelected()">
	<input type="submit" name="downGroup" value="<%=countrybean.getTranslation("tabDOWN")%>" onClick="return bSomethingSelected()">
	</td></tr>
	<tr><td colspan="2" height="25"></td></tr>
	<tr><td colspan="2" align="center">
	<input type="submit" name="addGroup" value="<%=countrybean.getTranslation("AddTab")%>">
	<input type="submit" name="editGroup" value="<%=countrybean.getTranslation("EditTab")%>" onClick="return bSomethingSelected()">
	<input type="submit" name="delGroup" value="<%=countrybean.getTranslation("DeleteTab")%>" onClick="return confirmDelete()">
	&nbsp;&nbsp;&nbsp;<input type="submit" name="assignGroup" value="<%=countrybean.getTranslation("assignVariables")%>" onClick="return bSomethingSelected()">

	<br><br>
	<input name="doneButton" type=button value='<%=countrybean.getTranslation("Done")%>' onClick="postTo('extendedManager.jsp')">

	</td></tr>
	</table>
  </td>
 </tr>
</table>
</form>
</body>
</html>
<% dbCon.close(); %>

