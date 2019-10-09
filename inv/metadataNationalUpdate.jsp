<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<%@ page import = "org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.math.BigDecimal" %>
<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id = "metadata" class="org.lared.desinventar.webobject.MetadataNational" scope="session" />
<%@ taglib uri="/inventag.tld" prefix="inv" %>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
if (countrybean.countrycode.length()==0)
{%><jsp:forward page="/inv/index.jsp"/><%}%>
<%@ include file="checkUserIsLoggedIn.jsp" %>
<title>DesInventar on-line : <%=countrybean.countryname%> <%=countrybean.getTranslation("Metadata National Manager")%> </title>
</head>
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/iheader",countrybean.getLanguage(),out);%>
<%@ taglib uri="/inventag.tld" prefix="inv" %>


<%
int nTabActive=9; // 
String[] sTabNames={countrybean.getTranslation("Region"),countrybean.getTranslation("Geography"),countrybean.getTranslation("Events"),
           countrybean.getTranslation("Causes"),countrybean.getTranslation("Extension"),countrybean.getTranslation("Query"),
           countrybean.getTranslation("EditData"),countrybean.getTranslation("DataEntry"),countrybean.getTranslation("Admin"),
		   countrybean.getTranslation("Sendai"),countrybean.getTranslation("Security")};
String[] sTabIcons={"","","","","","","","","","","",""};
String[] sTabLinks={"index.jsp","geographytab.jsp","eventab.jsp",
				"causetab.jsp","extendedtab.jsp","querytab.jsp",
				"resultstab.jsp","datacardtab.jsp","admintab.jsp",
				"sendaitab.jsp","securitytab.jsp"};
%>
<%@ include file="/util/tabs.jspf" %>
<%-- 
<table width="1024" border="1" class="pageBackground" rules="none" height="500"><tr><td align="center" valign="top">
 --%>
<!-- Content goes after this comment -->
<br/><br/>
<table width="850" border="0">
<tr><td align="center">
<font color="Blue"><%=countrybean.getTranslation("Region")%></font>
<b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b>
 - [<jsp:getProperty name ="countrybean" property="countrycode"/>]
</td></tr>
</table>
 <% if (user.iusertype < 20){ %>
 <jsp:forward page="noaccess.jsp"/>
 <%} %>  
<%@ include file="/util/opendatabase.jspf" %>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
 <body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
 <script type="text/javascript" src="/DesInventar/html/iheader.js"></script>  
<% 
/******************************************************************
*  Process the Register request.
******************************************************************/
if (request.getParameter("cancel")!=null)
{
  dbCon.close();
  %><jsp:forward page='/inv/metadataNationalManager.jsp'/><%
}
String sSql="";
String sErrorMessage="";
int action=webObject.extendedParseInt(request.getParameter("action"));
String sVariable=request.getParameter("new_variable");
String sDescription=request.getParameter("new_description");
String sSource=request.getParameter("new_source");
String sDefaultValue=request.getParameter("new_default_value");
String sDefaultValueUS=request.getParameter("new_default_value_us");
double dDefaultValue = 0.0;
double dDefaultValueUS = 0.0;
MetadataNationalLang metadataLang=new MetadataNationalLang();

if(sDefaultValue != null && !metadata.isNumber(sDefaultValue)){
	sErrorMessage=countrybean.getTranslation("SORRY")+": "+countrybean.getTranslation("Metadata default value ")+" "+sVariable+" "+countrybean.getTranslation(" is not a number");
}
else if(sDefaultValueUS != null && !metadata.isNumber(sDefaultValueUS)){
	sErrorMessage=countrybean.getTranslation("SORRY")+": "+countrybean.getTranslation("Metadata default value US ")+" "+sVariable+" "+countrybean.getTranslation(" is not a number");
}
else 
{
	if(sDefaultValue == null)
		dDefaultValue=(new BigDecimal(metadata.metadata_default_value)).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue();
	else 
		dDefaultValue=(new BigDecimal(webObject.extendedParseDouble(sDefaultValue))).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue();
	if(sDefaultValueUS == null)
		dDefaultValueUS=(new BigDecimal(metadata.metadata_default_value_us)).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue();
	else 
		dDefaultValueUS=(new BigDecimal(webObject.extendedParseDouble(sDefaultValueUS))).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue();
	if (sVariable==null)
	   sVariable=metadata.metadata_variable;
	if (request.getParameter("saveMetadata")!=null)
		if(sVariable.isEmpty()){
			sErrorMessage=countrybean.getTranslation("SORRY")+": "+countrybean.getTranslation("Metadata national Variable is a Mandatory! ")+countrybean.getTranslation("Please specify it!");
		}
		else  if(!webObject.not_null(sVariable).equals(metadata.metadata_variable) 
				 || !webObject.not_null(sDescription).equals(metadata.metadata_description)
				 || !webObject.not_null(sSource).equals(metadata.metadata_source)
				 || dDefaultValue != (new BigDecimal(metadata.metadata_default_value)).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue()
				 || dDefaultValueUS != (new BigDecimal(metadata.metadata_default_value_us)).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue()
		)
			{ 
				// checks for a NEW or DIFFERENT name
				int nr=0;
				if (!metadata.metadata_variable.equals(sVariable))
					{
					MetadataNational metadataNational=new MetadataNational();
					metadataNational.metadata_key=webObject.extendedParseInt(request.getParameter("metadata_key"));
					metadataNational.metadata_country=countrybean.countrycode;
					nr=metadataNational.getWebObject(con);
					if(nr > 0 && 
						(!metadataNational.metadata_variable.equals(sVariable) 
							|| !metadataNational.metadata_description.equals(sSource)
							|| !metadataNational.metadata_source.equals(sDescription) 
							|| (new BigDecimal(metadata.metadata_default_value)).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue() != dDefaultValue
							|| (new BigDecimal(metadata.metadata_default_value_us)).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue() != dDefaultValueUS
						)
					)
						nr=0;
					}
				// the new or different name exists...
				if (nr>0)
					{
					sErrorMessage=countrybean.getTranslation("SORRY")+": "+countrybean.getTranslation("Metadata")+" "+sVariable+" "+countrybean.getTranslation("alreadyexists.Pleasechooseanothername");
					}
				else
					{
					metadata.getForm(request,response,con);
					if (action==0)
						{
						metadata.metadata_key=metadata.getMaximum("metadata_key","metadata_national", con)+1;
						metadata.metadata_country=countrybean.countrycode;
						metadata.metadata_variable=sVariable;
						metadata.metadata_description=sDescription;
						metadata.metadata_source=sSource;
						metadata.metadata_default_value=dDefaultValue;
						metadata.metadata_default_value_us=dDefaultValueUS;
						nr = metadata.addWebObject(con);
		
						metadataLang.metadata_key=metadata.metadata_key;
						metadataLang.metadata_country=countrybean.countrycode;
						metadataLang.metadata_lang=countrybean.getLanguage().toLowerCase();
						metadataLang.metadata_description=sDescription;
						nr = metadataLang.addWebObject(con);
						if (!"en".equals(metadataLang.metadata_lang))
							{
							// forces the creation of an english metadadata lang entry. yes, cheating.
							metadataLang.metadata_lang="en";
							metadataLang.addWebObject(con);
							}
						%><!-- ADDED RECORD: --><%=metadata.lastError%><%
						}
					else
						/* TODO Update */
						{
						if (!metadata.metadata_variable.equals(sVariable))
							{
							PreparedStatement pstmt=null;
							try
								{
								// a) creates new parent record
								MetadataNational metadataNational = new MetadataNational();
								metadataNational.getForm(request, response, con);
								metadataNational.metadata_key=webObject.extendedParseInt(request.getParameter("metadata_key"));
								metadataNational.metadata_country=countrybean.countrycode;
								metadataNational.metadata_variable=sVariable;
								metadataNational.metadata_description=sDescription;
								metadataNational.metadata_source=sSource;
								metadataNational.metadata_default_value=dDefaultValue;
								metadataNational.metadata_default_value_us=dDefaultValueUS;
								nr = metadataNational.updateWebObject(con);
								
								metadataLang.metadata_key=metadata.metadata_key;
								metadataLang.metadata_country=countrybean.countrycode;
								metadataLang.metadata_lang=countrybean.getLanguage().toLowerCase();
								metadataLang.metadata_description=sDescription;
								metadataLang.updateWebObject(con);
		
								}
							catch (Exception e)
								{
								sErrorMessage="SORRY: national metadata cannot be updated.<!--"+e.toString()+" -->";
								}	
							try {pstmt.close();} catch (Exception cex){}
							%>
		                    <!-- SECOND UPDATE: --><%=metadata.lastError%><%
							}
							%>
						}	
					if (sErrorMessage.length()==0)
						{
						dbCon.close();
				    	%><jsp:forward page='metadataNationalManager.jsp'/><%
						}
					}	
			  } 
			  else {
				sErrorMessage=countrybean.getTranslation("SORRY")+": "+countrybean.getTranslation("Metadata")+" "+sVariable+" "+countrybean.getTranslation("alreadyexists.Pleasechooseanothername");
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
//  document.desinventar.nombre.focus()
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
ok= emptyvalidation(document.desinventar.newname,' <%=countrybean.getTranslation("Name")%> <%=countrybean.getTranslation("ismandatory")%>!..')
return ok;
}
// -->
</script>



<form name="desinventar" action="metadataNationalUpdate.jsp" method="post" onSubmit="return validateFields()">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<input type="hidden" name="action" value="<%=action %>">
<input type="hidden" name="metadata_key" value="<%=metadata.metadata_key %>">
<input type="hidden" name="metadata_countrycode" id="countrycode" value="<%=countrybean.countrycode %>"> 
<table cellspacing="0" cellpadding="2" border="0" width="750">
<tr>
    <td class='bgDark' height="25" colspan="2"><span class="titleText"><%=countrybean.getTranslation("Definitionof")%> <%=countrybean.getTranslation("Matadata National")%> </span></td>
</tr>
<tr><td colspan="2" height="5"></td></tr>
<TR>
<TD colspan=2 align="center"><span class="warning"><%=sErrorMessage%></span></TD>
</TR>
<TR>
	<td width=180 class=bgLight align='right'><%=countrybean.getTranslation("Variable")%>:</td>
	<td>  <INPUT type='TEXT' size='31' maxlength='30' name='new_variable' VALUE="<%=htmlServer.htmlEncode(metadata.metadata_variable)%>"></td>
</tr>
<tr>
	<td width=180 class=bgLight align='right'><%=countrybean.getTranslation("Description")%>:</td>
	<td>  <INPUT type='TEXT' size='50' maxlength='200' name='new_description' VALUE="<%=htmlServer.htmlEncode(metadata.metadata_description)%>"></td>
</tr>
<tr>
	<td width=180 class=bgLight align='right'><%=countrybean.getTranslation("Source")%>:</td>
	<td>  <INPUT type='TEXT' size='50' maxlength='200' name='new_source' VALUE="<%=htmlServer.htmlEncode(metadata.metadata_source)%>"></td>
</tr>
<tr>
	<td width=180 class=bgLight align='right'><%=countrybean.getTranslation("Default Value")%>:</td>
	<td>  <INPUT type='TEXT' size='31' maxlength='200' name='new_default_value' VALUE="<%=htmlServer.htmlEncode(metadata.metadata_default_value)%>"></td>
</tr>
<tr>
	<td width=180 class=bgLight align='right'><%=countrybean.getTranslation("Default Value US")%>:</td>
	<td>  <INPUT type='TEXT' size='31' maxlength='200' name='new_default_value_us' VALUE="<%=htmlServer.htmlEncode(metadata.metadata_default_value_us)%>"></td>
</tr>

	<TR>
	<TD colspan=3 height="20"></TD>
	</TR>
	<TR>
	<TD  valign="bottom"  align=right>
	</TD>
	<TD valign="bottom">
	<input name="saveMetadata" type='submit' value='<%=countrybean.getTranslation("Save")%> <%=countrybean.getTranslation("Metadata")%>'> &nbsp; &nbsp; &nbsp; &nbsp;
	<input name="cancelMetadata" type='button' value='<%=countrybean.getTranslation("Cancel")%>' onClick="postTo('metadataNationalManager.jsp')">
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












