<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<title>DesInventar on-line - Create/Update National Metadata</title>
</head>
<%@ page import = "org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import = "java.sql.*" %>
<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id = "Event" class="org.lared.desinventar.webobject.eventos" scope="session" />
<jsp:useBean id = "metadata" class="org.lared.desinventar.webobject.MetadataNational" scope="session" />
<%@ taglib uri="/inventag.tld" prefix="inv" %>
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
if (request.getParameter("cancel")!=null)
{
  dbCon.close();
  %><jsp:forward page='/inv/nationalMetadataManager.jsp'/><%
}
String sSql="";
String sErrorMessage="";
int action=metadata.extendedParseInt(request.getParameter("action"));
String sVariable=request.getParameter("new_variable");
String sDescription=request.getParameter("new_description");
String sSource=request.getParameter("new_source");
String sDefaultValue=request.getParameter("new_default_value");
double dDefaultValue = 0.0;
if(sDefaultValue != null && !metadata.isNumber(sDefaultValue)){
	sErrorMessage=countrybean.getTranslation("SORRY")+": "+countrybean.getTranslation("Metadata deafult value ")+" "+sVariable+" "+countrybean.getTranslation(" is not a number");
}
else 
{
	dDefaultValue=sDefaultValue == null ? metadata.metadata_default_value : metadata.extendedParseDouble(sDefaultValue);
	if (sVariable==null)
	   sVariable=metadata.metadata_variable;
	if (request.getParameter("saveMetadata")!=null)
		if(!metadata.not_null(sVariable).equals(metadata.metadata_variable) 
		 || !metadata.not_null(request.getParameter(sDescription)).equals(metadata.metadata_description)
		 || !metadata.not_null(request.getParameter(sSource)).equals(metadata.metadata_source)
		 || dDefaultValue != metadata.metadata_default_value
	)
	  { 
		// checks for a NEW or DIFFERENT name
		int nr=0;
		if (!metadata.metadata_variable.equals(sVariable))
			{
			MetadataNational metadataNational=new MetadataNational();
			metadataNational.metadata_key=metadataNational.extendedParseInt(request.getParameter("metadata_key"));
			metadataNational.metadata_country=countrybean.countrycode;
			nr=metadataNational.getWebObject(con);
			if(nr > 0 && 
				(!metadataNational.metadata_variable.equals(sVariable) 
					|| !metadataNational.metadata_description.equals(sSource)
					|| !metadataNational.metadata_source.equals(sDescription) 
					|| metadataNational.metadata_default_value != dDefaultValue
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
				metadata.addWebObject(con);
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
						// this statements implement DB-independent UPDATE ON CASCADE
						// Some databases (access, mysql) have problems/limitations on referential integrity constraints
						// Specifically, the implementation of ON UPDATE CASCADE ON DELETE ...  varies dramatically from 
						// platform to platform. In the future, these tables should have sequential surrogate keys.
						// a) creates new parent record
						MetadataNational metadataNational = new MetadataNational();
						metadataNational.getForm(request, response, con);
						metadataNational.metadata_key=metadataNational.extendedParseInt(request.getParameter("metadata_key"));
						metadataNational.metadata_country=countrybean.countrycode;
						metadataNational.metadata_variable=sVariable;
						metadataNational.metadata_description=sDescription;
						metadataNational.metadata_source=sSource;
						metadataNational.metadata_default_value=dDefaultValue;
						nr = metadataNational.updateWebObject(con);
						/* 
						eventos NewEvent= new eventos();
						NewEvent.getForm(request,response,con);
						NewEvent.nombre=sVariable;					
						String sTempEN=NewEvent.nombre_en;
						NewEvent.nombre_en="@"+Math.random()*1000000000;
						NewEvent.serial=Event.getMaximum("serial","eventos", con)+1;
						nr=NewEvent.addWebObject(con);
						if (nr>0) // b) moves child to new parent,  EQUIVALENT TO    ON UPDATE CASCADE !!!
							{
							pstmt = con.prepareStatement("update fichas set evento=? where evento=?");
							pstmt.setString(1, sVariable);
							pstmt.setString(2, Event.nombre);
							pstmt.executeUpdate();
							
							pstmt = con.prepareStatement("update eventos set parent=? where parent=?");
							pstmt.setString(1, sVariable);
							pstmt.setString(2, Event.nombre);
							pstmt.executeUpdate();
	
							pstmt = con.prepareStatement("update event_grouping set nombre=? where nombre=?");
							pstmt.setString(1, sVariable);
							pstmt.setString(2, Event.nombre);
							pstmt.executeUpdate();
	
							// c) removes old parent
							Event.deleteWebObject(con);
							Event.nombre=sVariable;
							// Access database are created with a unique index on nombre_en...
							NewEvent.nombre_en=sTempEN;
							NewEvent.updateWebObject(con);
							}
						else
							sErrorMessage="SORRY: event cannot be renamed."+NewEvent.lastError;	
						*/
						}
					catch (Exception e)
						{
						sErrorMessage="SORRY: national metadata cannot be updated.<!--"+e.toString()+" -->";
						}	
					try {pstmt.close();} catch (Exception cex){}
					%><!-- SECOND UPDATE: --><%=metadata.lastError%><%
					}
				/*
				else	
					{
					nr=metadata.updateWebObject(con);
					if (nr<=0)
							sErrorMessage="SORRY: English event cannot be renamed; may be a duplicate. <br>"+Event.lastError;
				*/
					%>
					<!-- FIRST UPDATE: <%-- <%=Event.sSql --%> --><%-- <%=Event.lastError--%><%
				/*
					}
				*/
				}	
			if (sErrorMessage.length()==0)
				{
				dbCon.close();
		    	%><jsp:forward page='/inv/nationalMetadataManager.jsp'/><%
				}
			}	
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



<form name="desinventar" action="nationalMetadataUpdate.jsp" method="post" onSubmit="return validateFields()">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<input type="hidden" name="action" value="<%=action %>">
<input type="hidden" name="metadata_key" value="<%=metadata.metadata_key %>">
<input type="hidden" name="metadata_countrycode" id="countrycode" value="<%=countrybean.countrycode %>"> 
<table cellspacing="0" cellpadding="2" border="0" width="750">
<tr>
    <td class='bgDark' height="25" td colspan="2"><span class="titleText"><%=countrybean.getTranslation("Definitionof")%> <%=countrybean.getTranslation("Event")%> </span></td>
	</td>
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
	<td>  <INPUT type='TEXT' size='50' maxlength='200' name='new_default_value' VALUE="<%=htmlServer.htmlEncode(metadata.metadata_default_value)%>"></td>
</tr>

	<TR>
	<TD colspan=3 height="20"></TD>
	</TR>
	<TR>
	<TD  valign="bottom"  align=right>
	</TD>
	<TD valign="bottom">
	<input name="saveMetadata" type='submit' value='<%=countrybean.getTranslation("Save")%> <%=countrybean.getTranslation("Metadata")%>'> &nbsp; &nbsp; &nbsp; &nbsp;
	<input name="cancelMetadata" type='button' value='<%=countrybean.getTranslation("Cancel")%>' onClick="postTo('nationalMetadataManager.jsp')">
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












