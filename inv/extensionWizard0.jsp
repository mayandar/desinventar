<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<title>DesInventar on-line - Create/Update Fields Wizard</title>
</head>
<%@ page import = "org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import = "java.sql.*" %>
<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
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
<%}

/******************************************************************
*  Process the request.
******************************************************************/
String sErrorMessage="";
String sQuestions=countrybean.not_null(request.getParameter("questions"));
String sQuestions_en=countrybean.not_null(request.getParameter("questions_en"));
if (request.getParameter("saveField")!=null)
	{
	if (sQuestions.length()==0)
	  sErrorMessage="Please enter questions";
	  else
	  	{
		%><jsp:forward page='/inv/extensionWizard1.jsp'/><%
		}
	}	
%>

<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
<script type="text/javascript" src="/DesInventar/html/iheader.js"></script> 
<script language="JavaScript">
<!--
function giveFocus() 
{
  	document.desinventar.questions.focus()
  	
}

function submitForm() 
{
  document.desinventar.submit()
}

function resetForm() 
{
  document.desinventar.reset()
  document.desinventar.questions.focus()
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
document.desinventar.questions.value=trim(document.desinventar.questions.value);
document.desinventar.questions_en.value=trim(document.desinventar.questions_en.value);
ok = emptyvalidation(document.desinventar.questions,"Enter questions, please...")
return ok;
}
// -->
</script>

<form name="desinventar" action="extensionWizard0.jsp" method="post" onSubmit="return validateFields()">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<table cellspacing="0" cellpadding="2" border="0" width="100%">
<tr>
<td>
<table cellspacing="0" cellpadding="5" border="1" width="100%" rules="none">
<tr>
    <td class='bgDark' height="25" td colspan="3"><span class="titleText"><%=countrybean.getTranslation("Extension Wizard")%></span></td>
	<td/>
</tr>
<% if (sErrorMessage.length()>0){%>
<TR>
<TD colspan=2 align="center"><span class="warning"><%=sErrorMessage%></span></TD>
</TR>
<%}%>
<tr>
  <td> <%=countrybean.getTranslation("Questions(one per line)")%></td>
  <td> <%=countrybean.getTranslation("English")%></td>
</tr>
<tr>
  <td> <TEXTAREA name='questions' cols="60" rows="27"><%=htmlServer.htmlEncode(sQuestions)%></TEXTAREA></td>
  <td> <TEXTAREA name='questions_en' cols="60" rows="27"><%=htmlServer.htmlEncode(sQuestions_en)%></TEXTAREA></td>
</tr>
<TR>
    <td colspan=3 align="center">
	<input name="saveField" type=submit value='<%=countrybean.getTranslation("Continue")%>'> 
	&nbsp; &nbsp; &nbsp; &nbsp;
	<input name="cancelField" type=button value='<%=countrybean.getTranslation("Cancel")%>' onClick="postTo('extendedManager.jsp')">
	</TD>
</Tr>
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












