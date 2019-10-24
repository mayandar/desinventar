<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<%@ page import = "org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.webobject.users" %>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.math.BigDecimal" %>
<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id = "metadata" class="org.lared.desinventar.webobject.MetadataNational" scope="session" />
<jsp:useBean id = "metadataNationalValue" class="org.lared.desinventar.webobject.MetadataNationalValues" scope="session" />
<jsp:useBean id = "Dictionary" class="org.lared.desinventar.webobject.diccionario" scope="session" />
<%
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
if (countrybean.countrycode.length()==0)
{%><jsp:forward page="/inv/index.jsp"/><%}%>
<%@ include file="checkUserIsLoggedIn.jsp" %>
<title>DesInventar on-line : <%=countrybean.countryname%> <%=countrybean.getTranslation("Metadata National Language Manager")%> </title>
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
if (request.getParameter("addMetadataNationalValue")!=null)
   {
	metadataNationalValue.init();
	metadataNationalValue.dbType = metadata.dbType;
	metadataNationalValue.metadata_country = metadata.metadata_country;
	metadataNationalValue.metadata_key = metadata.metadata_key;
	dbCon.close();
	%><jsp:forward page="metadataNationalValueUpdate.jsp?action=0"/><%
   }
else if (request.getParameter("downloadMetadataNationalValue")!=null)
{
	dbCon.close();
	request.setAttribute("country", countrybean.countrycode);
	request.setAttribute("variable", metadata.metadata_key);
	%><jsp:forward page="importXMLInFrame.jsp?action=2" /><%
}
else if (request.getParameter("editMetadataNationalValue")!=null)
   {
	metadataNationalValue.init();
	metadataNationalValue.dbType = metadata.dbType;
	metadataNationalValue.metadata_country = metadata.metadata_country;
	metadataNationalValue.metadata_key = metadata.metadata_key;
	metadataNationalValue.metadata_year = webObject.extendedParseInt(request.getParameter("new_year"));
	metadataNationalValue.metadata_value = (new BigDecimal(webObject.extendedParseDouble(request.getParameter("new_value")))).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue();
	metadataNationalValue.metadata_value_us = (new BigDecimal(webObject.extendedParseDouble(request.getParameter("new_value_us")))).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue();
	dbCon.close();
	%><jsp:forward page="metadataNationalValueUpdate.jsp?action=1"/><%
   }
else if (request.getParameter("deleteMetadataNationalValue")!=null)
   {
	metadataNationalValue.init();
	metadataNationalValue.dbType = metadata.dbType;
	metadataNationalValue.metadata_country = metadata.metadata_country;
	metadataNationalValue.metadata_key = metadata.metadata_key;
	metadataNationalValue.metadata_year = MetadataNationalValues.extendedParseInt(request.getParameter("new_year"));
	nSqlResult = metadataNationalValue.getWebObject(con);
	if(nSqlResult < 1){
		sErrorMessage = metadataNationalValue.lastError;
	} else {
		nSqlResult = metadataNationalValue.deleteWebObject(con);
		if(nSqlResult < 1)
			sErrorMessage = metadataNationalValue.lastError;
	}
	dbCon.close();
	%><%-- <jsp:forward page="metadataNationalValueUpdate.jsp?action=2"/> --%><%
   }

String sField=DICountry.dbHelper[countrybean.dbType].sqlNvl("label_campo","label_campo_en");
if (countrybean.getDataLanguage().equals("EN"))
{
sField=countrybean.dbHelper[countrybean.dbType].sqlNvl("label_campo_en","label_campo");
}

%>
   
<script language="JavaScript">
<!--
function confirmDelete()
{
	return confirm ("<%=countrybean.getTranslation("Areyousureyouwanttodeletethis")%> <%=countrybean.getTranslation("field")%>?");
}

function editField(eventId, year, value, value_us)
{
// alert("event_id="+eventId+", year="+year+", value="+value+", value_us="+value_us);
	if(eventId === 'deleteMetadataNationalValue')
	{
		if (!confirmDelete())
			return false;
	}
	var theForm = document.forms['desinventar'];
	var event = document.createElement('input');
	event.type = 'hidden';
	event.name = eventId ; // 'the key/name of the attribute/field that is sent to the server
	event.value = 'active';
	theForm.appendChild(event);
	var new_year = document.createElement('input');
	new_year.type = 'hidden';
	new_year.name = 'new_year' ; // 'the key/name of the attribute/field that is sent to the server
	new_year.value = year;
	theForm.appendChild(new_year);
	var new_value = document.createElement('input');
	new_value.type = 'hidden';
	new_value.name = 'new_value' ; // 'the key/name of the attribute/field that is sent to the server
	new_value.value = value;
	theForm.appendChild(new_value);
	var new_value_us = document.createElement('input');
	new_value_us.type = 'hidden';
	new_value_us.name = 'new_value_us' ; // 'the key/name of the attribute/field that is sent to the server
	new_value_us.value = value_us;
	theForm.appendChild(new_value_us);
	document.desinventar.submit();
}
//-->
</script>


<FORM name="desinventar" id="maintainMetadataNationalValue" method="post" action="maintainMetadataNationalValue.jsp">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<input type="hidden" name="metadata_key" value="<%=metadataNationalValue.metadata_key %>">
<input type="hidden" name="metadata_countrycode" id="countrycode" value="<%=countrybean.countrycode %>"> 
<table cellspacing="0" cellpadding="0" border="0" width="850">
<tr>
  <td width=50>&nbsp;</td>
  <td>
	<table cellspacing="0" cellpadding="5" border="0" width="850" rules="none">
	<tr>
	    <td height="25" colspan="2" class='bgDark' align="center"><span class="title"><%=countrybean.getTranslation("Annual Metadata Value Manager")%></span></td>
	</tr>
	<tr><td colspan="2" height="5"></td></tr>
	<TR>
	<TD colspan=2 align="center"><span class="warning"><%=sErrorMessage%></span></TD>
	</TR>
	<tr><td colspan="2" align="center">
	<input type="submit" name="addMetadataNationalValue" value="<%=countrybean.getTranslation("Add")%> <%=countrybean.getTranslation(metadata.metadata_variable)%> <%=countrybean.getTranslation("annual value")%>">
<input type="submit" name="downloadMetadataNationalValue" value="<%=countrybean.getTranslation("Retrieve")%> <%=countrybean.getTranslation(metadata.metadata_variable)%> <%=countrybean.getTranslation("values from desinventar.net")%>" >
   <input name="doneButton" type=button value='<%=countrybean.getTranslation("Done")%>' onClick="postTo('metadataNationalManager.jsp')">
	</td></tr>

	<tr><td colspan="2" align="center">
	<br/><br/>
	<table cellpadding=2  width="90%" cellspacing="0" border="1">
    <tr class="DI_TableHeader bodyclass">
    <th><%=countrybean.getTranslation("Edit")%></th>
    <th><%=countrybean.getTranslation("Delete")%></th>
    <th><%=countrybean.getTranslation("Metadata Year")%></th>
    <th><%=countrybean.getTranslation("Metadata Value")%></th>
    <th><%=countrybean.getTranslation("Metadata Value US")%></th>
    </tr>
<%
	stmt=con.createStatement();
	rset=stmt.executeQuery("select * from metadata_national_values where metadata_key="+metadata.metadata_key+" and metadata_country='"+metadata.metadata_country+"' order by metadata_year desc");
	int j=0;
	while (rset.next())
		{
		MetadataNationalValues annualValue=new MetadataNationalValues();
		annualValue.loadWebObject(rset);
		out.println("<tr class='bs'>");
		/*
		out.println("<td><a href= 'javascript:editField("+j+")'><img src='/DesInventar/images/edit_row.gif' alt='Edit field' border=0></a></td>");
		out.println("<td><a href= 'javascript:deleteField("+j+")'><img src='/DesInventar/images/delete_row.gif' alt='Delete field' border=0></a></td>");
		*/
		out.println("<td align='center'><input name='editAnnualMetaValue' id='editAnnualMetaValue"+j+"' type='image'");
		out.println(" src='/DesInventar/images/edit_row.gif' alt='Submit' border='0'");
		out.println(" onClick=\"editField("+"'editMetadataNationalValue', "+annualValue.metadata_year+", "+annualValue.metadata_value+", "+annualValue.metadata_value_us+")\"></td>");
		out.println("<td align='center'><input name='deleteMetadataNationalValue' id='deleteAnnualMetaValue"+j+"' type='image'");
		out.println(" src='/DesInventar/images/delete_row.gif' alt='Submit' border='0'");
		out.println(" onClick=\"editField("+"'deleteMetadataNationalValue', "+annualValue.metadata_year+", "+annualValue.metadata_value+", "+annualValue.metadata_value_us+")\"></td>");
		out.println("<td align='center'>"+annualValue.metadata_year+"</td><td align='right'>"+annualValue.metadata_value+"</td><td align='right'>"+annualValue.metadata_value_us+"</td></tr>");
		j++;
		}
	rset.close();	
	stmt.close();
%>
	
     </table>
	</td></tr>
	</table>
  </td>
 </tr>
</table>
</form>
</body>
</html>
<% dbCon.close(); %>

