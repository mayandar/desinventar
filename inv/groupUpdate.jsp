<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<title>DesInventar on-line - Create/Update Field</title>
</head>
<%@ page import = "org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.*" %>
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

/******************************************************************
*  Process the Register request.
******************************************************************/
if (request.getParameter("cancelField")!=null)
{
  dbCon.close();
  %><jsp:forward page='/inv/extensionManager.jsp'/><%
}
String sSql="";
String sErrorMessage="";
int action=Group.extendedParseInt(request.getParameter("action"));
String sFieldid=request.getParameter("ntab");
if (request.getParameter("saveField")!=null)
{
 switch (action)
  { 
  case 0:  // add field, check for a NEW  name
		Group.getForm(request,response,con);
		Group.addWebObject(con);
		out.write("<!-- ADDED RECORD: -->"+Group.lastError);
	break;
  case 1:  // update field
		Group.getForm(request,response,con);
  		Group.updateWebObject(con);
		%><!-- FIRST UPDATE: <%=Group.sSql%> --><%=Group.lastError%><%
		break;
  case 2:  // delete field
		Group.getForm(request,response,con);
  		try{
			// remove all variables from this tab, send them to default tab
        	sSql="update diccionario set tabnumber=null where tabnumber="+Group.ntab;
			stmt=con.createStatement ();
			stmt.executeUpdate(sSql);		   	
			Group.deleteWebObject(con);
			}
		catch (Exception e3)
			{
			sErrorMessage="SORRY: Field cannot be deleted...("+e3.toString()+" <!--"+sSql+"--> )";
			}	
		finally
			{
			stmt.close();
			}
	}	
  if (sErrorMessage.length()==0)
	{
	dbCon.close();
	%><jsp:forward page='/inv/groupManager.jsp'/><%
	}
  }
%>

<script language="JavaScript">
<!--
function giveFocus() 
{
  	document.desinventar.svalue.focus()  	
}

function submitForm() 
{
  document.desinventar.submit()
}

function resetForm() 
{
  document.desinventar.reset()
  document.desinventar.svalue.focus()
}


function trim(strVariable)
{
if (strVariable==null)
	return "";
var len=strVariable.length;
if (len==0)
	return "";
// first part:  trims blanks to the right
var index=len-1;
while ((index>0) && (strVariable.charAt(index)==" ")) index--;
strVariable=strVariable.substring(0,index+1);
// second part:  trims leading blanks
len=strVariable.length;
index=0;
while ((index<len) && (strVariable.charAt(index)==" ")) index++;
strVariable=strVariable.substring(index,len);
return strVariable;
}

function emptyvalidation(entered, alertbox)
{
with (entered)
	{
    value=trim(value);
	if (value==null || value=="")
		{	
		if (alertbox!="") 
			alert(alertbox);
		return false;
		}
	else 
		return true;
	}
}


function validateFields()
{
var ok=true;
ok= emptyvalidation(document.desinventar.svalue,'<%=countrybean.getTranslation("name")%> <%=countrybean.getTranslation("ismandatory")%>!..')
return ok;
}
// -->
</script>



<form name="desinventar" action="groupUpdate.jsp" method="post" onSubmit="return validateFields()">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<table cellspacing="0" cellpadding="2" border="0" width="750">
<tr>
<td>
<table cellspacing="0" cellpadding="5" border="1" width="650" rules="none">
<tr>
    <td class='bgDark' height="25" td colspan="2"><span class="titleText"><%=countrybean.getTranslation("ExtensionTabDefinition")%></span></td>
	</td>
</tr>
<tr><td colspan="2" height="5"></td></tr>
<TR>
<TD colspan=2 align="center"><span class="warning"><%=sErrorMessage%></span></TD>
</TR>
<input type="hidden" name="action" value="<%=action %>">
<input type="hidden" name="ntab" maxlength="10" size="10" value="<%=Group.ntab%>">
<INPUT type='hidden' name='nsort' VALUE="<%=Group.nsort%>">
<tr><td width=180 class=bgLight align='right'><%=countrybean.getTranslation("TabName")%></td><td>  
<INPUT type='TEXT' size='41' maxlength='40' name='svalue' VALUE="<%=Group.svalue%>"> <span class="warning">*</span>
</td></tr>
<tr><td width=180 class='bgLight' align='right'><%=countrybean.getTranslation("TabNameInEnglish")%></td><td>  
<INPUT type='TEXT' size='41' maxlength='40' name='svalue_en' VALUE="<%=Group.svalue_en%>">
</td></tr>
	<TR>
	<TD colspan=3 height="20"></TD>
	</TR>
	<TR>
	<TD  valign="bottom"  align=right>
	</TD>
	<TD valign="bottom">
<% if (action==2)
   {%>
	<input name="saveField" type=submit value='<%=countrybean.getTranslation("Delete")%>'> 
<% }
   else
   {%>
	<input name="saveField" type=submit value='<%=countrybean.getTranslation("Save")%>'> 
<% }%>
	&nbsp; &nbsp; &nbsp; &nbsp;
	<input name="cancelField" type=button value='<%=countrybean.getTranslation("Cancel")%>' onClick="postTo('groupManager.jsp')">
	</TD>
	</Tr>

	<TR>
	<TD colspan=3 height="10"></TD>
	</TR>
	<TR>
</table>
</td>
</tr>
</table>
</form>


<script language="JavaScript">
<!-- 
giveFocus();
// -->
</script>
</BODY>
</html>
<%dbCon.close();%>












