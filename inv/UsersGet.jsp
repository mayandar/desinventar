<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<%@ page import = "org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.system.Sys" %>
<%@ page import = "java.sql.*" %>
<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id = "User" class="org.lared.desinventar.webobject.users" scope="session" />
<% 
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
%>
<%@ taglib uri="inventag.tld" prefix="inv" %>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%@ include file="/util/opendefaultdatabase.jspf" %>
<html>
<head>
<title>DesInventar on-line - Register a User</title>
</head>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
<script type="text/javascript" src="/DesInventar/html/iheader.js"></script> 
 
 

<% 
/******************************************************************
*  Process the Register request.
******************************************************************/
String sErrorMessage="";
String sSql="";
User.dbType=Sys.iDatabaseType;
String sUserid=request.getParameter("suserid");
if (request.getParameter("cancelUser")!=null)
{
  dbCon.close();
  %><jsp:forward page='/inv/userManager.jsp'/><%
}
if (request.getParameter("saveUser")!=null)
{
	// Query the account name & password
	try
	{
		// checks if there is a user with that username
		Statement stmt = con.createStatement ();
		sSql = "select sUSERID from users where sUSERID='" + sUserid + "'";
		ResultSet rset = stmt.executeQuery(sSql);
		if (rset.next())
		{
		sErrorMessage=countrybean.getTranslation("SORRY")+": "+sUserid+" "+countrybean.getTranslation("alreadyexists.Pleasechooseanothername");
		}
		else
		{
		  User.getForm(request,response,con);
		  User.dlastlogindate = User.strDate(new java.util.Date());
		  User.dusersince = User.strDate(new java.util.Date());
		  User.brecordstatus = (int) (Math.random()*9998.0)+1;
		  User.bactive=1;
		  User.bnewuser=99;                                 
		  User.addWebObject(con);
		  out.println("<!-- PROCESS: -->"+User.lastError);
		  dbCon.close();
  		%><jsp:forward page='/inv/userManager.jsp'/><%
		}
		
	// releases the resultset
	rset.close();
	// releases the statement
	stmt.close();
	}
	catch (Exception ex)
	{ //Trap SQL errors
	  out.println( "<!--Error processing Registration: " + ex.toString() + "-->");
	}
}
else User.init();
%>

<script language="JavaScript">
<!--
function giveFocus() 
{
  document.desinventar.suserid.focus()
}

function submitForm() 
{
  document.desinventar.submit()
}

function resetForm() 
{
  document.desinventar.reset()
  document.desinventar.suserid.focus()
}

var notValidChars = " '\/<>";

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
haveAlphaLow=false;
haveAlphaCap=false;
haveNum=false;
for (j=0; j<entered.value.length; j++)
	{
    toCheck=entered.value.charAt(j);
	if ("0123456789".indexOf(toCheck)>=0)
		haveNum=true;
	else	
	if ("ABCDEFGHIJKLMNOPQRSTUVWXYZ".indexOf(toCheck)>=0)
		haveAlphaCap=true;
	else	
		haveAlphaLow=true;
	} 
validateFlag=haveNum && haveAlphaCap && haveAlphaLow;
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
ok= emptyvalidation(document.desinventar.suserid,'<%=countrybean.getTranslation("UsernameMandatory")%>!..')
if (ok)	ok=validate_alpha(document.desinventar.suserid,"Error:  <%=countrybean.getTranslation("InvalidCharsUsername")%>");
if (ok)
	{
	ok= emptyvalidation(document.desinventar.spassword,'<%=countrybean.getTranslation("PasswordMandatory")%>!...')
	if (ok)
		if (document.desinventar.spassword.value.length<8)
		{
		alert ("<%=countrybean.getTranslation("Password must have minimum 8 chars")%>...");
		ok=false;
		}
	if (ok)
		ok=validate_pass(document.desinventar.spassword,"Error: <%=countrybean.getTranslation("Password is weak, must have CAP/low letters and numbers")%>");
	if (ok)
		{
		if (document.desinventar.spassword.value!=document.desinventar.spassword2.value)
			{
			ok=false;
			alert ("<%=countrybean.getTranslation("Passwordsdonotmatch")%>...");
			}		
		}
	}
if (ok) ok= emptyvalidation(document.desinventar.sfirstname,'<%=countrybean.getTranslation("FirstnameMandatory")%>!..')
if (ok) ok= emptyvalidation(document.desinventar.slastname,'<%=countrybean.getTranslation("LastnameMandatory")%>!..')
if (ok) ok= emptyvalidation(document.desinventar.semailaddress,'<%=countrybean.getTranslation("EmailMandatory")%>!..')
if (ok) ok= emptyvalidation(document.desinventar.sorganization,'<%=countrybean.getTranslation("Organization_is_Mandatory")%>!..');
return ok;
}
// -->
</script>



<table cellspacing="0" cellpadding="0" border="0" width="750">
<form name="desinventar" action="UsersGet.jsp" method="post" onSubmit="return validateFields()">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<tr>
    <td class='bgDark' height="25" td colspan="2"><span class="titleText">DesInventar - <%=countrybean.getTranslation("UserRegistration")%></span></td>
	</td>
</tr>
<tr><td colspan="2" height="5"></td></tr>
<TR>
<TD colspan=2 align="center"><span class="warning"><%=sErrorMessage%></span></TD>
</TR>
	
<TR><td width=180 class=bgLight align='right'><%=countrybean.getTranslation("Username")%>: </td><TD><input type="text" name="suserid" maxlength="10" size="10" value="<%=htmlServer.htmlEncode(User.suserid) %>"><span class="warning">*</span></td></tr>                
<TR><td width=180 class=bgLight align='right'><%=countrybean.getTranslation("Password")%>: </td><TD><input  type="Password" name="spassword" maxlength="20" size="13" value="<%=htmlServer.htmlEncode(User.spassword) %>"><span class="warning">*</span></td></tr>                
<TR><td width=180 class=bgLight align='right'><%=countrybean.getTranslation("retypePassword")%>: </td><TD><input  type="Password" name="spassword2" maxlength="20" size="12" value="<%=htmlServer.htmlEncode(User.spassword) %>"><span class="warning">*</span></td></tr>                
<%if (user.iusertype>=40)  // only owner/superuser can assign privilege!!!
 {%>
 <TR><TD class=bgLight align='right'><%=countrybean.getTranslation("UserType")%>: </td><TD>
 <SELECT NAME="iusertype">
 <option value='0'<%=User.strSelected(User.iusertype,0)%>><%=countrybean.getTranslation("Guest")%>
 <option value='1'<%=User.strSelected(User.iusertype,1)%>><%=countrybean.getTranslation("Operator")%>
 <option value='20'<%=User.strSelected(User.iusertype,20)%>><%=countrybean.getTranslation("Administrator")%>
 <option value='40'<%=User.strSelected(User.iusertype,40)%>><%=countrybean.getTranslation("Owner")%>
<%if (user.iusertype>=99)  // only superuser can assign superuser privilege!!!
 {%>
  <option value='99'<%=User.strSelected(User.iusertype,99)%>><%=countrybean.getTranslation("Superuser")%>
<%}%>
 </SELECT>
 </td></tr>                
<%}%>


<TR><td width=180 class=bgLight align='right'><%=countrybean.getTranslation("FirstName")%>: </td><TD><input type="text" name="sfirstname" maxlength="50" size="50" value="<%=htmlServer.htmlEncode(User.getSfirstname()) %>"><span class="warning">*</span></td></tr>                
<TR><td width=180 class=bgLight align='right'><%=countrybean.getTranslation("LastName")%>: </td><TD><input type="text" name="slastname" maxlength="50" size="50" value="<%=htmlServer.htmlEncode(User.getSlastname()) %>"><span class="warning">*</span></td></tr>                
<TR><td width=180 class=bgLight align='right'><%=countrybean.getTranslation("Address")%>: </td><TD><input type="text" name="saddress1" maxlength="50" size="50" value="<%=htmlServer.htmlEncode(User.getSaddress1()) %>"></td></tr>                
<TR><td width=180 class=bgLight align='right'><%=countrybean.getTranslation("Address")%> (<%=countrybean.getTranslation("cont")%>.): </td><TD><input type="text" name="saddress2" maxlength="50" size="50" value="<%=htmlServer.htmlEncode(User.getSaddress2()) %>"></td></tr>                
<TR><td width=180 class=bgLight align='right'><%=countrybean.getTranslation("City")%>: </td><TD><input type="text" name="scity" value="<%=htmlServer.htmlEncode(User.getScity()) %>"></td></tr>                
<TR><td width=180 class=bgLight align='right'><%=countrybean.getTranslation("StateProvince")%>: </td><TD>
<input type="text" name="sstateprovince" maxlength="50" size="50" value="<%=User.getSstateprovince() %>">
</td></tr>                
 <TR><TD class=bgLight align='right'><%=countrybean.getTranslation("Country")%>: </td><TD><input type="Text" maxlength="30" size="30" NAME="scountry" value="<%= htmlServer.htmlEncode(User.getScountry()) %>">
 </td></tr>                
<TR><td width=180 class=bgLight align='right'><%=countrybean.getTranslation("Postal Code")%>: </td><TD><input type="text" name="spostalcode" maxlength="10" size="10"  value="<%=htmlServer.htmlEncode(User.getSpostalcode()) %>"></td></tr>                
<TR><td width=180 class=bgLight align='right'><%=countrybean.getTranslation("eMail")%>: </td><TD><input type="text" name="semailaddress" maxlength="150" size="50" value="<%=htmlServer.htmlEncode(User.getSemailaddress()) %>"><span class="warning">*</span></td></tr>                
<TR><td width=180 class=bgLight align='right'><%=countrybean.getTranslation("Phone")%>: </td><TD><input type="text" name="sphonenumber" maxlength="14" size="14"  value="<%=htmlServer.htmlEncode(User.getSphonenumber()) %>"></td></tr>                
<tr><td width=180 class=bgLight align='right'><%=countrybean.getTranslation("Alternatephone")%>:</td><td>  <INPUT type='TEXT' size='14' maxlength='14' name='salternatephonenumber' VALUE="<%=htmlServer.htmlEncode(User.salternatephonenumber)%>"></td></tr>
<TR><td width=180 class=bgLight align='right'><%=countrybean.getTranslation("Fax")%>: </td><TD><input type="text" name="sfaxnumber" maxlength="14" size="14" value="<%=htmlServer.htmlEncode(User.getSfaxnumber()) %>">
<input type="hidden" name="bactive"  maxlength="2" size="2" value="<%=User.getBactive() %>">
</td></tr>                
<tr><td width=180 class=bgLight align='right'><%=countrybean.getTranslation("Organization")%>:</td><td>  <INPUT type='TEXT' size='50' maxlength='50' name='sorganization' VALUE="<%=htmlServer.htmlEncode(User.sorganization)%>"><span class="warning">*</span></td></tr>
	<TR>
	<TD colspan=3 height="20"></TD>
	</TR>
	<TR>
	<TD  valign="bottom"  align=right>
	</TD>
	<TD valign="bottom">
	<input name="saveUser" type=submit value='<%=countrybean.getTranslation("Save")%> <%=countrybean.getTranslation("User")%>'> &nbsp; &nbsp; &nbsp; &nbsp;
	<input name="cancelUser" type=button value='<%=countrybean.getTranslation("Cancel")%>' onclick='postTo("userManager.jsp")'>
	</TD>
	</Tr>

</form>
</table>
<script language="JavaScript">
<!-- 
giveFocus();
// -->
</script>
</BODY>
</html>
<%dbCon.close();%>












