<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<title>DesInventar on-line - Create/Update Cause</title>
</head>
<%@ page import = "org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import = "java.sql.*" %>
<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id = "Cause" class="org.lared.desinventar.webobject.causas" scope="session" />

<%@ taglib uri="inventag.tld" prefix="inv" %>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
if (user.iusertype<20) 
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
if (request.getParameter("cancelCause")!=null)
{
  dbCon.close();
  %><jsp:forward page='/inv/causeManager.jsp'/><%
}
String sSql="";
String sErrorMessage="";
int action=Cause.extendedParseInt(request.getParameter("action"));
String sCauseid=request.getParameter("newname");
if (sCauseid==null)
   sCauseid=Cause.causa;
if (request.getParameter("saveCause")!=null)
 if (request.getParameter("causa").equals(Cause.causa))
  { 
	// checks for a NEW or DIFFERENT name
	int nr=0;
	if (!Cause.causa.equals(sCauseid))
		{
		causas cCheck=new causas();
		cCheck.causa=sCauseid;
		nr=cCheck.getWebObject(con);
		}
	// the new or different name exists...
	if (nr>0)
		{
		sErrorMessage=countrybean.getTranslation("SORRY")+": "+countrybean.getTranslation("Cause")+" "+sCauseid+" "+countrybean.getTranslation("alreadyexists.Pleasechooseanothername");
		}
	else
		{
		Cause.getForm(request,response,con);
		if (action==0)
			{
			Cause.causa=sCauseid;
			Cause.addWebObject(con);
			%><!-- ADDED RECORD: --><%=Cause.lastError%><%
			}
		else
			{
			if (!Cause.causa.equals(sCauseid))
				{
				PreparedStatement pstmt=null;
				try
					{
					// this statements implement DB-independent UPDATE ON CASCADE
					// Some databases (access, oracle, mysql) have problems/limitations on referntial integrity constraints
					// Specifically, the implementation of ON UPDATE CASCADE ON DELETE ...  varies dramatically from 
					// platform to platform. In the future, these tables should have sequential surrogate keys.
					// a) creates new record
					causas NewCause= new causas();
					NewCause.getForm(request,response,con);
					NewCause.causa=sCauseid;
					String sTempEN=NewCause.causa_en;
					NewCause.causa_en="@"+Math.random()*1000000000;
					nr=NewCause.addWebObject(con);
					if (nr>0)// b) moves child to new parent
						{
						pstmt = con.prepareStatement("update fichas set causa=? where causa=?");
						pstmt.setString(1, sCauseid);
						pstmt.setString(2, Cause.causa);
						pstmt.executeUpdate();
						// c) removes old parent
						Cause.deleteWebObject(con);
						Cause.causa=sCauseid;
						// Access database are created with a unique index on nombre_en...
						NewCause.causa_en=sTempEN;
						NewCause.updateWebObject(con);
						}
					else
					   sErrorMessage="SORRY: Cause cannot be renamed."+NewCause.lastError;						
					}
				catch (Exception e)
					{
					sErrorMessage="SORRY: Cause cannot be renamed.<!--"+e.toString()+" -->";
					}	
				try {pstmt.close();} catch (Exception cex){}
				%><!-- SECOND UPDATE: --><%=Cause.lastError%><%
				}
			else
				{
				// this statement is needed for the english version. same note as above			
				nr=Cause.updateWebObject(con);
				if (nr<=0)
					   sErrorMessage="SORRY: English Cause cannot be renamed; may be a duplicate. <br>"+Cause.lastError;
				}		
			}	
		}
	if (sErrorMessage.length()==0)
		{	
		dbCon.close();
		%><jsp:forward page='/inv/causeManager.jsp'/><%
		}
  }
%>

<script language="JavaScript">
<!--
function giveFocus() 
{
  document.desinventar.newname.focus()
}

function submitForm() 
{
  document.desinventar.submit()
}

function resetForm() 
{
  document.desinventar.reset()
  document.desinventar.causa.focus()
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
ok= emptyvalidation(document.desinventar.newname,'<%=countrybean.getTranslation("Name")%> <%=countrybean.getTranslation("ismandatory")%>!..')
return ok;
}
// -->
</script>

<table cellspacing="0" cellpadding="2" border="0" width="750">
<form name="desinventar" action="causesUpdate.jsp" method="post" onSubmit="return validateFields()">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<tr>
    <td class='bgDark' height="25" td colspan="2"><span class="titleText"><%=countrybean.getTranslation("CauseDefinition")%></span></td>
	</td>
</tr>
<tr><td colspan="2" height="5"></td></tr>
<TR>
<TD colspan=2 align="center"><span class="warning"><%=sErrorMessage%></span></TD>
</TR>
<input type="hidden" name="action" value="<%=action %>">
<input type="hidden" name="causa" maxlength="25" size="15" value="<%=htmlServer.htmlEncode(Cause.causa)%>">
<TR><td width=180 class=bgLight align='right'><%=countrybean.getTranslation("Name")%>:</td><td>  <INPUT type='TEXT' size='16' maxlength='25' name='newname' VALUE="<%=htmlServer.htmlEncode(sCauseid)%>"></td></tr>
<TR><td width=180 class=bgLight align='right'><%=countrybean.getTranslation("Name")%>(English):</td><td>  <INPUT type='TEXT' size='16' maxlength='25' name='causa_en' VALUE="<%=htmlServer.htmlEncode(Cause.causa_en)%>"></td></tr>

	<TR>
	<TD colspan=3 height="20"></TD>
	</TR>
	<TR>
	<TD  valign="bottom"  align=right>
	</TD>
	<TD valign="bottom">
	<input name="saveCause" type=submit value='<%=countrybean.getTranslation("Save")%> <%=countrybean.getTranslation("Cause")%>'> &nbsp; &nbsp; &nbsp; &nbsp;
	<input name="cancelCause" type='button' value='<%=countrybean.getTranslation("Cancel")%>' onClick="postTo('causeManager.jsp')">
	</TD>
	</Tr>

	<TR>
	<TD colspan=3 height="10"></TD>
	</TR>
	<TR>
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












