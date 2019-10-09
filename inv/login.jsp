<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<title>DesInventar on-line - Login</title>
</head>
<%@ page info="DesInventar On-Line" session="true" %> 
<%@ page import="java.io.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<%@ page contentType="text/html; charset=UTF-8" %><%@ page import="org.lared.desinventar.system.*" %><%
request.setCharacterEncoding("UTF-8"); 
// if this runs in an IFRAME under IE, this will allow cookies to stay...just magic!
((HttpServletResponse)response).addHeader("P3P", "CP=\"CAO PSA OUR\"");
((HttpServletResponse)response).addHeader("X-Frame-Options", "SAMEORIGIN");
%>
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/iheader",countrybean.getLanguage(),out);%>
<%
int nFunction = htmlServer.getActionNumber(request, "loginButton", "createButton", "forgotButton", "allforgotButton");
if (nFunction==0)
	{
    request.getSession(false).invalidate();
	user.init();
	user.iusertype=0;
	countrybean.countrycode="";
	countrybean.countryname="";
	countrybean.init();
	response.setHeader("Pragma", "no-cache");
	response.setHeader("Cache-Control", "no-cache, private, max-age=0, no-store, must-revalidate, pre-check=0, post-check=0");
	response.setDateHeader("Expires", 0);
	request.setCharacterEncoding("UTF-8");
%>
<head>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="cache-control" CONTENT="no-cache, private, max-age=0, no-store, must-revalidate, pre-check=0, post-check=0">
<META HTTP-EQUIV="Expires" CONTENT="01-01-1999">
</head>
<%}%>


<SCRIPT>
<!--  
var notValidChars = "<>'\""

function validate_alpha(entered,alertbox)
{
validateFlag=true;
for (j=0; j<entered.value.length; j++)
	{
    toCheck=entered.value.charAt(j);
	if (notValidChars.indexOf(toCheck)>=0)
		validateFlag=false;
	} 
if (!validateFlag)
	alert(alertbox);
return validateFlag;
}


function validate_pass(entered,alertbox)
{
haveAlpha=false;
haveNum=false;
for (j=0; j<entered.value.length; j++)
	{
    toCheck=entered.value.charAt(j);
	if ("0123456789".indexOf(toCheck)>=0)
		haveNum=true;
	else	
		haveAlpha=true;
	} 
validateFlag=haveNum && haveAlpha;
if (!validateFlag)
	alert(alertbox);
return validateFlag;
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
			{
			alert(alertbox);
			} 
		return false;
		}
	else 
		{
		return true;
		}
	}
}


function validateFields()
{
var ok=true;
ok= emptyvalidation(document.userid.suserid,'you must type a User name!..');
if (ok)
  ok= emptyvalidation(document.userid.spassword,'you must type a Password !...');
return ok;
}
 
// -->
</script>
<div class="welcomeheadder">
  <div class="navbase">
          <h4 style="margin-bottom:0; padding-top:5px;">&nbsp;Login to DesInventar on-line</h4>
  </div>
</div>


<%@ include file="/inv/login_logic.jsp" %>

	<!-- BEGIN TABLE WITH LOGIN -->
    <FORM name="userid" method="post" action="login.jsp" onSubmit="return validateFields()">

	<% String sAutocomplete="on";%>
<!-- this is for IndisData to comply with astringent security. Uncomment if needed 
    <input name="foolautofill" style="display: none;" type="password" />
	<--% String sAutocomplete="off";%>
-->

	<TABLE WIDTH="500" CELLSPACING="2" CELLPADDING="2">
	   <TR>
		  <TD align="center">
          </TD>
       </TR>
       <TR>
        <TD>
		<TABLE WIDTH="500" BORDER="0">
          <TR>
            <TD COLSPAN="2" class=bgDark><div class="title">DesInventar User Identification</div></TD>
          </TR>
          <TR>
           <TD WIDTH="200" ALIGN="right">Username : </TD>
           <TD><INPUT NAME="suserid" SIZE="15" autocomplete="<%=sAutocomplete%>"></TD>
          </TR>
          <TR>
           <TD WIDTH="200" ALIGN="right">Password: </TD>
           <TD><INPUT type="password" NAME="spassword" SIZE="15" autocomplete="<%=sAutocomplete%>" ></TD>
          </TR>
        </TABLE>
        
		</TD>
		</TR>
		<tr>
		<td align='center'>   
	   <INPUT TYPE="submit" NAME="loginButton" VALUE="Connect">&nbsp;&nbsp;
	   <INPUT TYPE="submit" NAME="forgotButton" VALUE="Forgot your password?" onClick='document.userid.spassword.value="12345678";'>&nbsp;&nbsp;
	   <INPUT TYPE="submit" NAME="allforgotButton" VALUE="Forgot your credentials?"  onClick='document.userid.suserid.value="anonymous";document.userid.spassword.value="12345678";'>
		</td>
      </tr>
	  </TABLE>
	 </FORM> 

<%@ include file="/html/ifooter.html" %>
