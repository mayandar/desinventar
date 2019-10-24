<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<title>DesInventar on-line - Extension Management</title>
</head>
<%@ page import = "org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.webobject.users" %>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import = "java.sql.*" %>
<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id = "Dictionary" class="org.lared.desinventar.webobject.diccionario" scope="session" />
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
if (request.getParameter("addExtension")!=null)
   {
    Dictionary.init();
	Dictionary.orden=Dictionary.getMaximum("orden", "diccionario", con)+1;
	dbCon.close();
	%><jsp:forward page="extensionUpdate.jsp?action=0"/><%
   }
else if (request.getParameter("editExtension")!=null)
   {
    Dictionary.init();
	Dictionary.nombre_campo=request.getParameter("nombre_campo");
	Dictionary.getWebObject(con);
	dbCon.close();
	%><jsp:forward page="extensionUpdate.jsp?action=1"/><%
   }
else if (request.getParameter("editCodes")!=null)
   {
    Dictionary.init();
	Dictionary.nombre_campo=request.getParameter("nombre_campo");
	Dictionary.getWebObject(con);
	dbCon.close();
	%><jsp:forward page="extensionCodes.jsp?action=1"/><%
   }
else if (request.getParameter("delExtension")!=null)
   {
	Dictionary.nombre_campo=request.getParameter("nombre_campo");
	Dictionary.getWebObject(con);
	// confirm delete!!!!
	dbCon.close();
	%><jsp:forward page="extensionUpdate.jsp?action=2"/><%
   }
else if (request.getParameter("upExtension")!=null)
   {
	Dictionary.nombre_campo=request.getParameter("nombre_campo");
	Dictionary.getWebObject(con);
	stmt=con.createStatement();
	rset=stmt.executeQuery("select *  from diccionario where orden<"+Dictionary.orden+ " order by orden desc");
	if (rset.next())
		{
		diccionario dct=new diccionario();
		dct.loadWebObject(rset);
		int tempOrder=dct.orden;
		dct.orden=-1;
		dct.updateWebObject(con);
		dct.orden=Dictionary.orden;
		Dictionary.orden=tempOrder;
		Dictionary.updateWebObject(con);
		dct.updateWebObject(con);
		}
	rset.close();	
	stmt.close();
   }
else if (request.getParameter("downExtension")!=null)
   {
	Dictionary.nombre_campo=request.getParameter("nombre_campo");
	Dictionary.getWebObject(con);
	stmt=con.createStatement();
	rset=stmt.executeQuery("select * from diccionario where orden>"+Dictionary.orden+ " order by orden");
	if (rset.next())
		{
		diccionario dct=new diccionario();
		dct.loadWebObject(rset);
		int tempOrder=dct.orden;
		dct.orden=-1;
		dct.updateWebObject(con);
		dct.orden=Dictionary.orden;
		Dictionary.orden=tempOrder;
		Dictionary.updateWebObject(con);
		dct.updateWebObject(con);
		}
	rset.close();	
	stmt.close();
   }
String sField=countrybean.dbHelper[countrybean.dbType].sqlNvl("label_campo","label_campo_en");
if (countrybean.getDataLanguage().equals("EN"))
{
sField=countrybean.dbHelper[countrybean.dbType].sqlNvl("label_campo_en","label_campo");
}

%>
   
<script language="JavaScript">
<!--
function bSomethingSelected()
{
if (document.desinventar.nombre_campo.selectedIndex==-1)
	{
	alert ("<%=countrybean.getTranslation("Pleaseselecta")%> <%=countrybean.getTranslation("field")%> <%=countrybean.getTranslation("fromthelist")%>...");
	return false;
	} 
return true;
}
function confirmDelete()
{
if (bSomethingSelected())
	{
	return confirm ("<%=countrybean.getTranslation("Areyousureyouwanttodeletethis")%> <%=countrybean.getTranslation("field")%>?");
	} 
else 
  return false;
}

function editField(which)
{
document.desinventar.nombre_campo.selectedIndex=which;
document.desinventar.editExtension.click();
}

function deleteField(which)
{
document.desinventar.nombre_campo.selectedIndex=which;
document.desinventar.delExtension.click();
}

// -->
</script>

<FORM name="desinventar" method="post" action="extensionManager.jsp">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<table cellspacing="0" cellpadding="0" border="0" width="850">
<tr>
  <td width=50>&nbsp;</td>
  <td>
	<table cellspacing="0" cellpadding="5" border="0" width="850" rules="none">
	<tr>
	    <td height="25" td colspan="2" class='bgDark' align="center"><span class="title"><%=countrybean.getTranslation("ExtensionManager")%></span></td>
		</td>
	</tr>
	<tr><td colspan="2" height="5"></td></tr>
	<TR>
	<TD colspan=2 align="center"><span class="warning"><%=sErrorMessage%></span></TD>
	</TR>
	<tr><td colspan="2" height="5"></td></tr>
	<tr><td colspan="2" align="center">
	<SELECT name="nombre_campo" style="WIDTH: 500px; HEIGHT: 166px" size=10>
	<inv:select tablename='diccionario' selected='<%=Dictionary.nombre_campo%>' connection='<%= con %>'
    fieldname="<%=sField%>" codename='nombre_campo' ordername='orden'/>
    </SELECT>
	</td></tr>
	<tr><td colspan="2" height="25"></td></tr>
	<tr><td colspan="2" align="center">
	<input type="submit" name="addExtension" value="<%=countrybean.getTranslation("Add")%> <%=countrybean.getTranslation("Field")%>">
	<input type="submit" name="editExtension" value="<%=countrybean.getTranslation("Edit")%> <%=countrybean.getTranslation("Field")%>" onClick="return bSomethingSelected()">
	<input type="submit" name="delExtension" value="<%=countrybean.getTranslation("Delete")%> <%=countrybean.getTranslation("Field")%>" onClick="return confirmDelete()">
	<input type="submit" name="editCodes" value="<%=countrybean.getTranslation("Codes")%>" onClick="return bSomethingSelected()">
	<input type="submit" name="upExtension" value="<%=countrybean.getTranslation("FieldUP")%>" onClick="return bSomethingSelected()">
	<input type="submit" name="downExtension" value="<%=countrybean.getTranslation("FieldDOWN")%>" onClick="return bSomethingSelected()"><br>

   
    <input name="doneButton" type=button value='<%=countrybean.getTranslation("Done")%>' onClick="postTo('extendedManager.jsp')">
	</td></tr>

	<tr><td colspan="2" align="center">
	<br/><br/>
	<table cellpadding=2  width="90%" celspacing=0 border=1>
    <tr class="DI_TableHeader bodyclass"><th><%=countrybean.getTranslation("Edit")%></th><th><%=countrybean.getTranslation("Delete")%></th><th><%=countrybean.getTranslation("FieldNameforDB")%></th><th><%=countrybean.getTranslation("Labelforfield")%></th><th><%=countrybean.getTranslation("FieldType")%></th>
    </tr>
<%
	stmt=con.createStatement();
	rset=stmt.executeQuery("select * from diccionario order by orden");
	int j=0;
	while (rset.next())
		{
		diccionario dct=new diccionario();
		dct.loadWebObject(rset);
		out.println("<tr class='bs'>");
		out.println("<td><a href= 'javascript:editField("+j+")'><img src='/DesInventar/images/edit_row.gif' alt='Edit field' border=0></a></td>");
		out.println("<td><a href= 'javascript:deleteField("+j+")'><img src='/DesInventar/images/delete_row.gif' alt='Delete field' border=0></a></td>");
		out.println("<td><strong>"+htmlServer.htmlEncode(dct.nombre_campo)+"</strong></td><td>"+htmlServer.htmlEncode(countrybean.getLocalOrEnglish(dct.label_campo,dct.label_campo_en))+"</td><td>"+extension.UserTypeNames[dct.fieldtype]+"</td></tr>");
		j++;
		}
	rset.close();	
	stmt.close();
%>
	
     </table>
	</td></tr>
	</table>
  </td>
 </tr>
</table>
</form>
</body>
</html>
<% dbCon.close(); %>

