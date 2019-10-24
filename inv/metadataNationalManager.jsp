<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<%-- 
</head>
 --%>
<%@ page import = "org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="woFicha" class="org.lared.desinventar.webobject.fichas" scope="session" />
<jsp:useBean id="woExtension" class="org.lared.desinventar.webobject.extension" scope="session" />
<jsp:useBean id = "metadata" class="org.lared.desinventar.webobject.MetadataNational" scope="session" />
<jsp:useBean id = "metadataNationalValue" class="org.lared.desinventar.webobject.MetadataNationalValues" scope="session" />
<jsp:useBean id = "metadataNationalLang" class="org.lared.desinventar.webobject.MetadataNationalLang" scope="session" />
<%@ taglib uri="inventag.tld" prefix="inv" %>
<%
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
if (countrybean.countrycode.length()==0)
{%><jsp:forward page="/inv/index.jsp"/><%}%>
<%@ include file="checkUserIsLoggedIn.jsp" %>
<title>DesInventar on-line : <%=countrybean.countryname%> <%=countrybean.getTranslation("Metadata National Manager")%> </title>
</head>
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/iheader",countrybean.getLanguage(),out);%>
<%@ taglib uri="inventag.tld" prefix="inv" %>


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
<%if (user.iusertype<20){%> <jsp:forward page="noaccess.jsp"/> <%}%> 
 --%>
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
int nSqlResult =0;
String sErrorMessage="";
String sWhere = " metadata_country='"+countrybean.countrycode+"' ";
PreparedStatement pstmt=null;

// important for the helper to return the right function
metadata.init();
metadata.dbType=countrybean.dbType;
if (request.getParameter("add")!=null)
   {
	metadata.init();
	dbCon.close();
	%><jsp:forward page="metadataNationalUpdate.jsp?action=0"/><%
   }
else if (request.getParameter("edit")!=null)
   {
	metadata.init();
	metadata.metadata_key=webObject.extendedParseInt(request.getParameter("metadata_key"));
	metadata.metadata_country=request.getParameter("countrycode");
	metadata.getWebObject(con);
	dbCon.close();
	%><jsp:forward page="metadataNationalUpdate.jsp?action=1"/>
	<%
   }
else if (request.getParameter("delete")!=null)
   {
	metadata.init();
	metadata.metadata_key=webObject.extendedParseInt(request.getParameter("metadata_key"));
	metadata.metadata_country=countrybean.countrycode;
	int rows = metadata.getWebObject(con);
	if(rows != 0){
		try
		{
			pstmt = con.prepareStatement("delete from metadata_national_lang where metadata_key=? and metadata_country=?");  // equivalent to a ON DELETE CASCADE !
			pstmt.setInt(1, metadata.metadata_key);
			pstmt.setString(2, metadata.metadata_country); 
			pstmt.executeUpdate();
		}
		catch (Exception exfk1)
		{
			sErrorMessage = exfk1.getMessage();
		}
		if(sErrorMessage.isEmpty()){
			try
			{
				pstmt = con.prepareStatement("delete from metadata_national_values where metadata_key=? and metadata_country=?");  // equivalent to a ON DELETE CASCADE !
				pstmt.setInt(1, metadata.metadata_key);
				pstmt.setString(2, metadata.metadata_country); 
				pstmt.executeUpdate();
			}
			catch (Exception exfk2)
			{
				sErrorMessage = exfk2.getMessage();
			}
			if(sErrorMessage.isEmpty())
				metadata.deleteWebObject(con);
		}
		pstmt.close();
	} else {
		sErrorMessage=countrybean.getTranslation("Could not find ")+" "+countrybean.getTranslation(metadata.metadata_variable);
	}
   }
else if (request.getParameter("retrieve")!=null)
{
	request.setAttribute("country", countrybean.countrycode);
	%><jsp:forward page="importXMLInFrame.jsp?action=1" /><%

}
else if (request.getParameter("maintainAnnualData")!=null)
{
//	metadata.init();
	metadata.metadata_key=webObject.extendedParseInt(request.getParameter("metadata_key"));
	metadata.metadata_country=request.getParameter("countrycode");
	metadata.getWebObject(con);
	dbCon.close();
	%><jsp:forward page="maintainMetadataNationalValue.jsp"/><%
}
else if (request.getParameter("translateMetadata")!=null)
{
//	metadata.init();
	metadata.metadata_key=webObject.extendedParseInt(request.getParameter("metadata_key"));
	metadata.metadata_country=request.getParameter("countrycode");
	metadata.getWebObject(con);
	dbCon.close();
	%><jsp:forward page="maintainMetadataNationalLang.jsp"/><%
} 
/*
else {
	try{
		pstmt = con.prepareStatement(
				"insert into metadata_national (metadata_key, metadata_country, metadata_variable, metadata_description, metadata_source, metadata_default_value, metadata_default_value_us)"
				+" select metadata_key, '"+countrybean.countrycode+"' as metadata_country, metadata_variable, metadata_description, metadata_source, metadata_default_value, metadata_default_value_us from metadata_national where metadata_country='@@@'");  // equivalent to a ON DELETE CASCADE !
		pstmt.executeUpdate();
	}
	catch(Exception exfk3)
	{
	}
}
*/

String sDisplayField="metadata_variable";
if (countrybean.getDataLanguage().equals("EN"))
	sDisplayField="metadata_variable";
%>
   
<script language="JavaScript">
<!--

function bSomethingSelected()
{
	if (document.desinventar.metadata_key.selectedIndex==-1)
	{
		alert ("<%=countrybean.getTranslation("Pleaseselecta")%> <%=countrybean.getTranslation("national metadata")%> <%=countrybean.getTranslation("fromthelist")%>...");
		var x = document.getElementById("annualdata");  
		x.disabled = true;
		var y = document.getElementById("translatedata");  
		y.disabled = true;
		return false;
	} 
	var x = document.getElementById("annualdata");  
	x.disabled = false;
	var y = document.getElementById("translatedata");  
	y.disabled = false;
	return true;
}

function confirmDelete()
{
if (bSomethingSelected())
	{
	return confirm ("<%=countrybean.getTranslation("Areyousureyouwanttodeletethis")%> <%=countrybean.getTranslation("Event")%>  ?");
	} 
else 
  return false;
}

function bAreYourSure()
{
return confirm ("<%=countrybean.getTranslation("Are you sure you want to TRANSLATE ALL to English (this cannot be undone!) ?")%>");
}

// -->
</script>
<FORM name="desinventar" method="post" action="metadataNationalManager.jsp">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<input type="hidden" name="countrycode" id="countrycode" value="<%=countrybean.countrycode%>"> 
<table cellspacing="0" cellpadding="0" border="0" width="850">
<tr>
  <td width=50>&nbsp;</td>
  <td>
	<table cellspacing="0" cellpadding="0" border="0" width="850" rules="none">
	<tr>
	    <td height="25" colspan="8" class='bgDark' align="center">
	    <span class="title"><%=countrybean.getTranslation("National Metadata Manager")%></span>
		</td>
	</tr>
	<tr><td colspan="8" height="5"></td></tr>
	<TR>
	<TD colspan="8" align="center"><span class="warning"><%=sErrorMessage%></span></TD>
	</TR>
	<tr><td colspan="8" height="5"></td></tr>
	<tr><td colspan="8" align="center">
	<SELECT name="metadata_key" style="WIDTH: 350px; HEIGHT: 166px" size='10'  onChange="return bSomethingSelected()">
	<inv:select tablename='metadata_national' selected='<%=metadata.metadata_key%>' connection='<%= con %>'
    	fieldname="<%=sDisplayField%>" codename='metadata_key' ordername='metadata_variable'
    	whereclause="<%=sWhere%>"
        />
    </SELECT><br>
	</td></tr>
	<tr><td colspan="8" height="25"></td></tr>
	<tr>
		<td colspan="8" align="center">
		<input type="submit" name="add" value="<%=countrybean.getTranslation("Add national metadata")%>">
		<input type="submit" name="edit" value="<%=countrybean.getTranslation("Edit national metadata")%>" onClick="return bSomethingSelected()">
		<input type="submit" name="delete" value="<%=countrybean.getTranslation("Delete national metadata")%>" onClick="return confirmDelete()">
<input type="submit" name="retrieve" value='<%=countrybean.getTranslation("Retrieve metadata from desinventar.net")%>' />
		</td>
	</tr>
	<tr><td colspan="8" height="25"></td></tr>
	<tr>
		<td colspan="1" width="25%" height="25"></td>
		<td colspan="3" width="25%" align="center">
		<input type="submit" id="annualdata" name="maintainAnnualData" value="<%=countrybean.getTranslation("Maintain metadata value")%>" disabled>
		</td>
		<td colspan="3" width="25%" align="center">
		<input type="submit" id="translatedata" name="translateMetadata" value="<%=countrybean.getTranslation("Translate metadata variable")%>" disabled>
		<td colspan="1" width="25%" height="25"></td>
	</tr>
	<tr><td colspan="8" height="25"></td></tr>
	<tr>
		<td colspan="8" align="center">
		<%-- 
		<input type="button" name="endMeta" value='<%=countrybean.getTranslation("Done")%>' onClick="document.location='sendaitab.jsp'">		</td>
		 --%>
		<input name="doneButton" type="button" value='<%=countrybean.getTranslation("Done")%>'  onclick="postTo('sendaitab.jsp')">
	</tr>
	</table>
  </td>
 </tr>
</table>
</form>
</body>
</html>
<% dbCon.close(); %>

