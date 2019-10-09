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
<jsp:useBean id = "Dictionary" class="org.lared.desinventar.webobject.diccionario" scope="session" />
<%
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
%>
<%@ taglib uri="/inventag.tld" prefix="inv" %>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%
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
if (request.getParameter("cancelField")!=null)
{
  dbCon.close();
  %><jsp:forward page='/inv/extensionManager.jsp'/><%
}
String sSql="";
String sErrorMessage="";

int MAXCODES=12;

if (request.getParameter("saveField")!=null)
	{
	PreparedStatement pstmt=null;
  		try{
			// remove all codes firste!!!
        	sSql="delete from extensioncodes where field_name='"+Dictionary.nombre_campo+"'";
			pstmt=con.prepareStatement(sSql);
			pstmt.executeUpdate();
			// and all new ones
			sSql="insert into extensioncodes (field_name, nsort, code_value,svalue,svalue_en) values ('"+Dictionary.nombre_campo+"',?,?,?,?)";
			pstmt=con.prepareStatement (sSql);
			String[] aCodes=request.getParameterValues("code_value");
			String[] aValues=request.getParameterValues("svalue");
			String[] aValues_en=request.getParameterValues("svalue_en");
			for (int k=0; k<MAXCODES; k++)
			   {
			   boolean ok=(aCodes[k]!=null && aValues[k]!=null && aCodes[k].length()!=0 && aValues[k].length()!=0);
			   if (ok)
			   		{
					pstmt.setInt(1,k);
					pstmt.setString(2, aCodes[k]);			  
					pstmt.setString(3, aValues[k]);			  
					pstmt.setString(4, aValues_en[k]);			  
					pstmt.executeUpdate();			
					}
				}			
			}
		catch (Exception e3){
			sErrorMessage="SORRY: Field code cannot be added...("+e3.toString()+" <!--"+sSql+"--> )";
		}	
		finally{
			pstmt.close();
		}	
		if (sErrorMessage.length()==0){
			dbCon.close();
			%><jsp:forward page='/inv/extensionManager.jsp'/><%
		}
	}	

stmt=con.createStatement ();
rset=stmt.executeQuery("select code_value, svalue, svalue_en from extensioncodes where field_name='"+Dictionary.nombre_campo+"'  order by nsort");		   	

%>

<script language="JavaScript">
<!--
function giveFocus() 
{
  	document.desinventar.code_value[0].focus()
  	
}

function submitForm() 
{
  document.desinventar.submit()
}

function resetForm() 
{
  document.desinventar.reset()
  document.desinventar.code_value[0].focus()
}

var notValidChars = " '\/<>";
var ValidChars = "01234567890_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

function validate_alpha(entered,alertbox)
{
validateFlag=true;
entered.value=trim(entered.value);
for (j=0; j<entered.value.length; j++)
	{
    toCheck=entered.value.charAt(j);
	if (ValidChars.indexOf(toCheck)<0)
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
return ok;
}
// -->
</script>



<form name="desinventar" action="extensionCodes.jsp" method="post"><!--  onSubmit="return validateFields()"> check for consistency? TODO -->
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<table cellspacing="0" cellpadding="2" border="0" width="100%">
<tr>
<td>
<table cellspacing="0" cellpadding="5" border="1" width="100%" rules="none">
<tr>
    <td class='bgDark' height="25" td colspan="3"><span class="titleText"><%=countrybean.getTranslation("FieldDefinition")%>  - <%=countrybean.getTranslation("Codes")%></span></td>
	<td/>
	<td/>
</tr>
<tr><td colspan="3" height="5"></td></tr>
<TR>
<TD colspan=2 align="center"><span class="warning"><%=sErrorMessage%></span></TD>
</TR>
<tr>
  <td> <%=countrybean.getTranslation("Code")%></td>
  <td> <%=countrybean.getTranslation("Value")%></td>
  <td> <%=countrybean.getTranslation("English")%></td>
</tr>
<input type="hidden" name="field_name" maxlength="10" size="10" value="<%=htmlServer.htmlEncode(Dictionary.nombre_campo) %>">
<% // 20 is an arbitrary number, for now 
String sValue="";
String sValue_en="";
String sCode="";
for (int k=0; k<MAXCODES; k++){
if (rset.next()){
sCode=countrybean.not_null(rset.getString("code_value"));
sValue=countrybean.not_null(rset.getString("sValue"));
sValue_en=countrybean.not_null(rset.getString("sValue_en"));
} else {
sValue="";
sValue_en="";
sCode="";
}
%>
<tr>
  <td> <INPUT type='TEXT' size='5' maxlength='5' name='code_value' VALUE="<%=htmlServer.htmlEncode(sCode)%>"></td>
  <td> <INPUT type='TEXT' size='40' maxlength='40' name='svalue' VALUE="<%=htmlServer.htmlEncode(sValue)%>"></td>
  <td> <INPUT type='TEXT' size='40' maxlength='40' name='svalue_en' VALUE="<%=htmlServer.htmlEncode(sValue_en)%>"></td>
</tr>
<%}%>
	<TR>
	<TD colspan=3 height="20"></TD>
	</TR>
	<tr><td colspan=3 align="center">
	<input name="saveField" type=submit value='<%=countrybean.getTranslation("Save")%>'> 
	&nbsp; &nbsp; &nbsp; &nbsp;
	<input name="cancelField" type=button value='<%=countrybean.getTranslation("Cancel")%>' onClick="postTo('extensionManager.jsp')">
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
<%dbCon.close();%>












