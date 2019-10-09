<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<%@ page import = "org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import = "java.sql.*" %>
<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id = "Level0" class="org.lared.desinventar.webobject.lev0" scope="session" />
<jsp:useBean id = "Level1" class="org.lared.desinventar.webobject.lev1" scope="session" />
<jsp:useBean id = "Level2" class="org.lared.desinventar.webobject.lev2" scope="session" />
<%@ taglib uri="/inventag.tld" prefix="inv" %>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	{%><jsp:forward page="noaccess.jsp"/><%}		
if (user.iusertype<20) 
 {
 %><jsp:forward page="noaccess.jsp"/><%}
if (request.getParameter("cancelLevel2")!=null)
{
  %><jsp:forward page='/inv/lev2Manager.jsp'/><%
}
%>
<%@ include file="/util/opendatabase.jspf" %>
<head>
<title>DesInventar on-line - Create/Update <%=countrybean.asLevels[2]%></title>
</head>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
<% 
/******************************************************************
*  Process the Register request.
******************************************************************/
String sSql="";
String sErrorMessage="";
PreparedStatement pstmt=null;
int action=Level2.extendedParseInt(request.getParameter("action"));
String sLevel2id=request.getParameter("newCode");
if (sLevel2id==null)
   sLevel2id=Level2.lev2_cod;
if (request.getParameter("saveLevel2")!=null)
 if (request.getParameter("lev2_cod").equals(Level2.lev2_cod))
  { 
	// checks for a NEW or DIFFERENT name
	int nr=0;
	lev2 eCheck=new lev2();
	if (!Level2.lev2_cod.equals(sLevel2id))
		{
		eCheck.lev2_cod=sLevel2id;
		nr=eCheck.getWebObject(con);
		}
	// the new or different name exists...
	if (nr>0)
		{
		sErrorMessage=countrybean.getTranslation("SORRY")+": "+sLevel2id+" ("+eCheck.lev2_name+") "+countrybean.getTranslation("alreadyexists.Pleasechooseanothercode");
		}
	else
		{
		Level2.getForm(request,response,con);
		if (action==0)
			{
			Level2.lev2_cod=sLevel2id;
			Level2.addWebObject(con);
			%><!-- ADDED RECORD: --><%=Level2.lastError%><%
			}
		else
			if (!Level2.lev2_cod.equals(sLevel2id))
				{
				// this statements implement DB-independent UPDATE ON CASCADE
				// Some databases (access, oracle, mysql) have problems/limitations on referential integrity constraints
			    try
					{
					// a) creates new parent record
					lev2 NewLevel2= new lev2();
					NewLevel2.getForm(request,response,con);
					NewLevel2.lev2_cod=sLevel2id;
					NewLevel2.addWebObject(con);
					// b) moves children to new parent
					// there is no lev3...
					pstmt=con.prepareStatement("update fichas set level2=?, name2=?, level1=? where level2=?");
					pstmt.setString(1,sLevel2id);
					pstmt.setString(2,Level2.lev2_name);
					pstmt.setString(3,Level2.lev2_lev1);
					pstmt.setString(4,Level2.lev2_cod);
					pstmt.executeUpdate();
					pstmt=con.prepareStatement("update regiones set codregion=?, nombre=?, nombre_en=?, lev0_cod=? where codregion=?");
					pstmt.setString(1,sLevel2id);
					pstmt.setString(2,Level2.lev2_name);
					pstmt.setString(3,Level2.lev2_name_en);
					pstmt.setString(4,Level2.lev2_lev1);
					pstmt.setString(5,Level2.lev2_cod);
					pstmt.executeUpdate();
					pstmt=con.prepareStatement("update regiones set lev0_cod=? where lev0_cod=?");
					pstmt.setString(1,sLevel2id);
					pstmt.setString(2,Level2.lev2_cod);
					pstmt.executeUpdate();
					pstmt.close();
					// c) removes old parent
					Level2.deleteWebObject(con);
					Level2.lev2_cod=sLevel2id;
					}
				  catch (Exception e)
					{
					sErrorMessage="SORRY: "+countrybean.asLevels[0]+" cannot be Updated.<!--"+e.toString()+" -->";
					}
				%><!-- SECOND UPDATE: --><%=Level2.lastError%><%
				}
			else
				{
			    try
					{
					Level2.updateWebObject(con);
					pstmt=con.prepareStatement("update fichas set name2=?, level1=? where level2=?");
					pstmt.setString(1,Level2.lev2_name);
					pstmt.setString(2,Level2.lev2_lev1);
					pstmt.setString(3,Level2.lev2_cod);
					pstmt.executeUpdate();
					pstmt=con.prepareStatement("update regiones set nombre=?, nombre_en=?, lev0_cod=? where codregion=?");
					pstmt.setString(1,Level2.lev2_name);
					pstmt.setString(2,Level2.lev2_name_en);
					pstmt.setString(3,Level2.lev2_lev1);
					pstmt.setString(4,Level2.lev2_cod);
					pstmt.executeUpdate();
					}
				  catch (Exception e)
					{
					sErrorMessage="WARNING: "+countrybean.asLevels[0]+" some cascade data cannot be Updated.<!--"+e.toString()+" -->";
					}
				%><!-- FIRST UPDATE: <%=Level2.sSql%> --><%=Level2.lastError%><%
				}
		}	
	if (sErrorMessage.length()==0)
		{	
		dbCon.close();
		%><jsp:forward page='/inv/lev2Manager.jsp'/><%
		}
  }
%>

<script language="JavaScript">
<!--
function giveFocus() 
{
  document.desinventar.newCode.focus()
}

function submitForm() 
{
  document.desinventar.submit()
}

function resetForm() 
{
  document.desinventar.reset()
  document.desinventar.lev2_cod.focus()
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
ok= emptyvalidation(document.desinventar.newCode,'<%=countrybean.asLevels[2]%> <%=countrybean.getTranslation("Code")%> <%=countrybean.getTranslation("ismandatory")%>!..')
if (ok)
  ok= emptyvalidation(document.desinventar.lev2_name,'<%=countrybean.asLevels[2]%> <%=countrybean.getTranslation("Name")%> <%=countrybean.getTranslation("ismandatory")%>!..')
return ok;
}
// -->
</script>



<form name="desinventar" action="lev2Update.jsp" method="post" onSubmit="return validateFields()">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<table cellspacing="0" cellpadding="2" border="0" width="750">
<tr>
    <td class='bgDark' height="25" td colspan="2"><span class="titleText"><%=countrybean.getTranslation("Definitionof")%> <%=htmlServer.htmlEncode(countrybean.asLevels[2])%></span></td>
	</td>
</tr>
<tr><td colspan="2" height="5"></td></tr>
<TR>
<TD colspan=2 align="center"><span class="warning"><%=htmlServer.htmlEncode(sErrorMessage)%></span></TD>
</TR>
<input type="hidden" name="action" value="<%=action %>">
<input type="hidden" name="lev2_cod" maxlength="10" size="10" value="<%=htmlServer.htmlEncode(Level2.lev2_cod) %>">
<TR><td width=180 class=bgLight align='right'><%=htmlServer.htmlEncode(countrybean.asLevels[2])%> <%=countrybean.getTranslation("Code")%>:</td><td>  <INPUT type='TEXT' size='16' maxlength='15' name='newCode' VALUE="<%=htmlServer.htmlEncode(sLevel2id)%>"></td></tr>
<tr><td width=180 class=bgLight align='right'><%=countrybean.asLevels[2]%> <%=countrybean.getTranslation("Name")%>:</td><td>  <INPUT type='TEXT' size='30' maxlength='30' name='lev2_name' VALUE="<%=htmlServer.htmlEncode(Level2.lev2_name)%>"></td></tr>
<tr><td width=180 class=bgLight align='right'><%=countrybean.asLevels[2]%> <%=countrybean.getTranslation("Name")%>(English):</td><td>  <INPUT type='TEXT' size='30' maxlength='30' name='lev2_name_en' VALUE="<%=htmlServer.htmlEncode(Level2.lev2_name_en)%>"></td></tr>
<tr><td width=180 class=bgLight align='right'><%=countrybean.getTranslation("Belongsto")%>:</td><td>  
<SELECT name="lev2_lev1">
	<% 
	String sWhere="";
	String sField=countrybean.sqlConcat(countrybean.sqlConcat("lev1_cod ","' - '")," lev1_name ");
	%>
	<inv:select tablename='lev1' selected="<%=htmlServer.htmlEncode(Level2.lev2_lev1)%>" connection='<%= con %>'
    fieldname="<%=sField%>" codename='lev1_cod' ordername='lev1_name'/>
    </SELECT>
</td></tr>

	
	<TR>
	<TD colspan=3 height="20"></TD>
	</TR>
	<TR>
	<TD  valign="bottom"  align=right>
	</TD>
	<TD valign="bottom">
	<input name="saveLevel2" type=submit value='<%=countrybean.getTranslation("Save")%> <%=countrybean.asLevels[2]%> Info'> &nbsp; &nbsp; &nbsp; &nbsp;
	<input name="cancelLevel" type='button' value='<%=countrybean.getTranslation("Cancel")%>' onClick="window.location='lev2Manager.jsp'">
	</TD>
	</Tr>

	<TR>
	<TD colspan=3 height="10"></TD>
	</TR>
	<TR>
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

