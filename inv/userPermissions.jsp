<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<%@ page info="front page of DesConsultar On-Line" session="true" %> 
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %> 
<%@ page import="org.lared.desinventar.webobject.*" %> 
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="User" class="org.lared.desinventar.webobject.users" scope="session" />
<% 
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
%>
<%@ include file="checkUserIsLoggedIn.jsp" %>
<%if (user.iusertype<40) 
 {
%><jsp:forward page="noaccess.jsp"/><%
 }
if (request.getParameter("donePerm")!=null)
   {
	%><jsp:forward page="userManager.jsp"/><%
   }
else if (request.getParameter("addSubRegion")!=null)
   {
	%><jsp:forward page="userSubPermissions.jsp"/><%
   }
%>  
<%@ include file="/util/opendefaultdatabase.jspf" %>
<%
int nSqlResult =0;
String sErrorMessage="";
if (request.getParameter("addRegion")!=null) 
 if (request.getParameter("available")!=null)
   {
   String[] asAvail= request.getParameterValues("available");
   for (int j=0; j<asAvail.length; j++)
   	{
   	user_permissions permission=new user_permissions();
   	permission.userid=User.suserid;
   	permission.country=asAvail[j];
   	permission.addWebObject(con);
	}
   }
if (request.getParameter("removeRegion")!=null)
 if (request.getParameter("authorized")!=null)
   {
   String[] asAuth= request.getParameterValues("authorized");
   for (int j=0; j<asAuth.length; j++)
	{
	user_permissions permission=new user_permissions();
	permission.userid=User.suserid;
	permission.country=asAuth[j];
	PreparedStatement pstmt=null;
	try{
		pstmt=con.prepareStatement("delete from user_subpermissions where userid=? and country=?");
		pstmt.setString(1,permission.userid);
		pstmt.setString(2,permission.country);
		pstmt.executeUpdate();		
	}
	catch (Exception e)
	{
	}
	permission.deleteWebObject(con);
	}
   }
%>
<html>
<head>
<title>DesInventar on-line - <%=countrybean.getTranslation("UserManager")%> [2]</title>
</head>

	<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
<script type="text/javascript" src="/DesInventar/html/iheader.js"></script>  
<%@ taglib uri="inventag.tld" prefix="inv" %>

<script language="javascript">
<!-- 
function bSomethingSelected()
{
if (document.desinventar.authorized.selectedIndex==-1)
	{
	alert ("<%=countrybean.getTranslation("PleaseSelectUser")%>...");
	return false;
	} 
return true;
}

function bAvailableSelected()
{
if (document.desinventar.available.selectedIndex==-1)
	{
	alert ("<%=countrybean.getTranslation("PleaseSelectAvailableRegion")%>...");
	return false;
	} 
return true;
}


function bHasCountries()
{
if (document.desinventar.authorized.options.length==0)
	{
	alert ("<%=countrybean.getTranslation("Need to have authorized countries")%>...");
	return false;
	} 
return true;
}
// -->
</script>

<body>
<table border="0" bordercolor="gray" cellpadding="0" cellspacing="0" width=600 rules="none">
<form method="post" action="userPermissions.jsp" name="desinventar">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
	  <tr><td align="center" class=bgDark colspan=3>
          <div class="title"><%=countrybean.getTranslation("SetPermissions")%>:</div><br><br>
		  </td>
	  </tr>
	  <tr>
	     <td align="center">
		 <strong><%=countrybean.getTranslation("AvailableRegions")%>:</strong><br>
		 <SELECT name="available" style="WIDTH: 200px; HEIGHT: 166px" multiple size=10>
			<% 
			String sWhere="sCountryId not in (select country from user_permissions where userid='"+User.suserid+"')";
			%>
			<inv:select tablename='country' connection='<%= con %>'
			   fieldname="sCountryName" codename='sCountryId' ordername='sCountryName' whereclause='<%=sWhere %>'/>
		 </SELECT>
		 </td>
		 <td align="center">
		 <INPUT type="submit" name="addRegion" value="<%=countrybean.getTranslation("Add")%> -&gt;" onClick="return  bAvailableSelected()"><br>
		 <INPUT type="submit" name="removeRegion" value="&lt;- <%=countrybean.getTranslation("Remove")%>"  onclick="return  bSomethingSelected()">
	     </td>
	     <td align="center">
		 <strong><%=countrybean.getTranslation("AuthorizedRegions")%>:</strong><br>
		 <SELECT name="authorized" style="WIDTH: 200px; HEIGHT: 166px; margin-left:25x" size=10 multiple>
	     <inv:selectBase connection="<%= con %>" user="<%=User%>"/>
		 </SELECT>
		 </td>
	     <td align="center">
		 <strong><%=countrybean.getTranslation("Authorized Level 0")%>:</strong><br>
		 <SELECT name="authorized_l1" style="WIDTH: 200px; HEIGHT: 166px; margin-left:25px" size=10 disabled> 
	     <inv:selectLevelX connection="<%= con %>" user="<%=User.suserid%>" level="0" only_selected="y"/>
		 </SELECT>
		 </td>
	     <td align="center">
		 <strong><%=countrybean.getTranslation("Authorized Level 1")%>:</strong><br>
		 <SELECT name="authorized_l2" style="WIDTH: 200px; HEIGHT: 166px;  margin-left:25px" size=10 disabled>
	     <inv:selectLevelX connection="<%= con %>" user="<%=User.suserid%>" level="1" only_selected="y"/>
		 </SELECT>
		 </td>
	  </tr>
      <tr>
      <td colspan="3" align="center"></td>
      <td align="center" colspan='2'><INPUT type="submit" name="addSubRegion" value="<%=countrybean.getTranslation("Add or Remove")%>" onClick="return  bHasCountries()"></td    
      ></tr>
      <tr><td colspan="5"><br/><hr></td></tr>
	  <tr>
	     <td align="center" colspan=5>
         <br/>
         <INPUT type=submit value="<%=countrybean.getTranslation("Done")%>" name=donePerm>
	     </td>
     </tr>
  </form>
</table>

<% 	// close the database object 
dbCon.close();
%>
<br>
</body>
</html>
