<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<title>DesInventar on-line - Forgot your Password?</title>
</head>
<%@ page info="DesInventar On-Line" session="true" %> 
<%@ page import="java.io.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<%@ page contentType="text/html; charset=UTF-8" %><%@ page import="org.lared.desinventar.system.*" %><%
request.setCharacterEncoding("UTF-8"); 
// if this runs in an IFRAME under IE, this will allow cookies to stay...just magic!
((HttpServletResponse)response).addHeader("P3P", "CP=\"CAO PSA OUR\"");
((HttpServletResponse)response).addHeader("X-Frame-Options", "SAMEORIGIN");
%>
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/header",countrybean.getLanguage(),out);%>
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />


<SCRIPT>
<!-- 
var notValidChars = "'&?*^%#|\/ "

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
ok= emptyvalidation(document.userid.email,'Must type an e-mail address!..')
if (ok)
    ok=validate_alpha(document.userid.email,"Error: Invalid characters in your e-mail address....(don't use '&?*^%#|\/)");
if (ok)
   if ((document.userid.email.value.indexOf("@")<1) || (document.userid.email.value.indexOf(".")<1))
		{
        alert("<%=countrybean.getTranslation("InvalidEmail")%>");
		return false;
		}
return ok;
}
 
// -->
</script>

<div class="welcomeheadder">
  <div class="navbase">
          <h4 style="margin-bottom:0; padding-top:5px;">&nbsp;e-Mail Address lookup</h4>
  </div>
</div>
<%@ include file="/inv/ForgotUserPass_logic.jsp" %>


<FORM NAME="userid" METHOD="POST" action="ForgotUserPass.jsp" onSubmit="return validateFields()">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<TABLE BORDER="0" CELLSPACING="10" CELLPADDING="1" width=600>
<TR><TD><br></td></tr>
<TR><TD>To find your User Name and password we need you to tell us your e-Mail address, 
exactly as you typed it when you were registered with the system. 
Your identification information will be e-mailed to that address.</td></tr>
<TR><TD></td></tr>
<TR><TD></td></TR>
<TR>
<TD><b>e-Mail Address: </b><INPUT NAME="email" SIZE=50 VALUE=""></TD>
</TR><TR>
<TR><TD></td></TR>
<TD ALIGN="CENTER"><INPUT TYPE="SUBMIT" NAME="sendEmail" VALUE="Find"></TD>
<TR><TD></td></tr>
<TR><TD>click <a class=linkText HREF="/DesInventar/index.jsp">HERE</a> to return to our home page</td></tr>

</TR>

</TABLE>
</form>
<hr>

<%@ include file="/html/footer.html" %>
