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
<%@ page import="org.lared.desinventar.webobject.diccionario" %>
<%@ page import = "java.sql.*" %>
<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id = "Group" class="org.lared.desinventar.webobject.extensiontabs" scope="session" />
<jsp:useBean id = "Dictionary" class="org.lared.desinventar.webobject.diccionario" scope="session" />
<%
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
%>

<%@ taglib uri="/inventag.tld" prefix="inv" %>
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
Dictionary.nombre_campo="";
if (request.getParameter("addToGroup")!=null)
   {
   String[] sAvail=request.getParameterValues("available");
   for (int c=0; c<sAvail.length; c++)
   		{
		Dictionary.nombre_campo=sAvail[c];
		Dictionary.getWebObject(con);
	    Dictionary.tabnumber=Group.ntab;
		Dictionary.updateWebObject(con);
		}
   }
else if (request.getParameter("delFromGroup")!=null)
   {
	Dictionary.nombre_campo=request.getParameter("thistab");
	Dictionary.getWebObject(con);
    Dictionary.tabnumber=0;
	Dictionary.updateWebObject(con);
   }
else if (request.getParameter("upExtension")!=null)
   {
	Dictionary.nombre_campo=request.getParameter("thistab");
	Dictionary.getWebObject(con);
	stmt=con.createStatement();
	rset=stmt.executeQuery("select *  from diccionario where tabnumber="+Group.ntab+" and orden<"+Dictionary.orden+ " order by orden desc");
	if (rset.next())
		{
		diccionario swap=new diccionario();
		swap.loadWebObject(rset);
		int tempOrder=swap.orden;
		swap.orden=-1;
		swap.updateWebObject(con);
		swap.orden=Dictionary.orden;
		Dictionary.orden=tempOrder;
		Dictionary.updateWebObject(con);
		swap.updateWebObject(con);
		}
	rset.close();	
	stmt.close();
   }
else if (request.getParameter("downExtension")!=null)
   {
	Dictionary.nombre_campo=request.getParameter("thistab");
	Dictionary.getWebObject(con);
	stmt=con.createStatement();
	rset=stmt.executeQuery("select * from diccionario where tabnumber="+Group.ntab+" and orden>"+Dictionary.orden+ " order by orden");
	if (rset.next())
		{
		diccionario swap=new diccionario();
		swap.loadWebObject(rset);
		int tempOrder=swap.orden;
		swap.orden=-1;
		swap.updateWebObject(con);
		swap.orden=Dictionary.orden;
		Dictionary.orden=tempOrder;
		Dictionary.updateWebObject(con);
		swap.updateWebObject(con);
		}
	rset.close();	
	stmt.close();
   }

String sWhere1=" (tabnumber is null or tabnumber<>"+Group.ntab+")";
String sWhere2=" (tabnumber="+Group.ntab+")";
String sFieldExpr=countrybean.sqlConcat(countrybean.sqlConcat(countrybean.sqlConcat("label_campo_en "," ' - ('"), countrybean.sqlNvl("svalue","'"+countrybean.getTranslation("Extension")+"'"))," ')'");
%>
   
<script language="JavaScript">
<!--
function bSomethingSelectedA()
{
if (document.desinventar.available.selectedIndex==-1)
	{
	alert ("<%=countrybean.getTranslation("Pleaseselectatabfromthelist")%>...");
	return false;
	} 
return true;
}
function bSomethingSelectedT()
{
if (document.desinventar.thistab.selectedIndex==-1)
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
// -->
</script>

<FORM name="desinventar" method="post" action="groupAssign.jsp">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<table cellspacing="0" cellpadding="0" border="0" width="650">
<tr>
  <td width=50>&nbsp;</td>
  <td>
	<table cellspacing="0" cellpadding="5" border="0" width="650" rules="none">
	<tr>
	    <td height="25" td colspan="2" class='bgDark' align="center"><span class="title"><%=countrybean.getTranslation("TabManager")%> 
		&nbsp;&nbsp;&nbsp;&nbsp;<%=countrybean.getLocalOrEnglish(Group.svalue,Group.svalue_en)%> </span></td>
		</td>
	</tr>
	<tr><td colspan="2" height="5"></td></tr>
	<TR>
	<TD colspan=2 align="center"><span class="warning"><%=sErrorMessage%></span></TD>
	</TR>
	<tr><td colspan="2" height="5"></td></tr>
	<tr><td><strong><%=countrybean.getTranslation("Variablesinothertabs")%></strong></td><td></td><td><strong><%=countrybean.getTranslation("Variablesinthistab")%></strong></td></tr>
	<tr><td align="center">
		<SELECT name="available" style="WIDTH: 300px; HEIGHT: 300px" size=30 multiple>
		<inv:select tablename='(diccionario left join extensiontabs on diccionario.tabnumber=extensiontabs.ntab)' selected='<%=Dictionary.nombre_campo%>' connection='<%= con %>'
	    fieldname="<%=sFieldExpr%>" codename='nombre_campo' ordername='orden' whereclause='<%=sWhere1%>'/>
	    </SELECT>
	</td>
	<td align="center">
		<input type="submit" name="addToGroup" value="<%=countrybean.getTranslation("AddToTab")%> >>" onClick="return bSomethingSelectedA()">
		<input type="submit" name="delFromGroup" value="<< <%=countrybean.getTranslation("DeleteFromTab")%>" onClick="return bSomethingSelectedT()"></td>
	<td align="center">
		<SELECT name="thistab" style="WIDTH: 300px; HEIGHT: 300px" size=30 multiple>
		<inv:select tablename='diccionario' selected='<%=Dictionary.nombre_campo%>' connection='<%= con %>'
	    fieldname="label_campo_en" codename='nombre_campo' ordername='orden' whereclause='<%=sWhere2%>'/>
	    </SELECT>
	</td>
	</tr>
	<tr><td></td><td></td><td align="center">
		<input type="submit" name="upExtension" value="<%=countrybean.getTranslation("tabUP")%>" onClick="return bSomethingSelectedT()">
		<input type="submit" name="downExtension" value="<%=countrybean.getTranslation("tabDOWN")%>" onClick="return bSomethingSelectedT()">
	</td></tr>
	<tr><td colspan="3" height="25"></td></tr>
	<tr><td colspan="3" align="center">
		<input name="doneButton" type=button value='<%=countrybean.getTranslation("Done")%>' onClick="postTo('groupManager.jsp')">
	</td></tr>
	</table>
  </td>
 </tr>
</table>
</form>
</body>
</html>
<% dbCon.close(); %>

