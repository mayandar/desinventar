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
<jsp:useBean id = "metaElement" class="org.lared.desinventar.webobject.MetadataElement" scope="session" />
<jsp:useBean id = "metadataElementCost" class="org.lared.desinventar.webobject.MetadataElementCosts" scope="session" />
<jsp:useBean id = "Dictionary" class="org.lared.desinventar.webobject.diccionario" scope="session" />
<jsp:useBean id="indicator" class="org.lared.desinventar.webobject.MetadataIndicator" scope="session" />
<%
indicator.indicator_key=indicator.extendedParseInt(request.getParameter("indicator_key"));
String sIndicatorkey = request.getParameter("indicator_key");
String sElementkey = request.getParameter("element_key");
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
<!-- 
<table width="1024" border="1" class="pageBackground" rules="none" height="500"><tr><td align="center" valign="top">
 -->
<!-- Content goes after this comment -->
<table width="580" border="0">
<tr><td align="center">
<font color="Blue"><%=countrybean.getTranslation("Region")%></font>
<b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font>
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
if (request.getParameter("addMetadataElementCosts")!=null)
   {
	metadataElementCost.init();
	metadataElementCost.dbType = metaElement.dbType;
	metadataElementCost.metadata_country = metaElement.metadata_country;
	metadataElementCost.metadata_element_key = metaElement.metadata_element_key;
	dbCon.close();
	%><jsp:forward page="metadataElementCostsUpdate.jsp?action=0"/><%
   }
else if (request.getParameter("editMetadataElementCosts")!=null)
   {
	metadataElementCost.init();
	metadataElementCost.dbType = metaElement.dbType;
	metadataElementCost.metadata_country = metaElement.metadata_country;
	metadataElementCost.metadata_element_key = metaElement.metadata_element_key;
	metadataElementCost.metadata_element_year = metadataElementCost.extendedParseInt(request.getParameter("new_year"));
	metadataElementCost.metadata_element_unit_cost = (new BigDecimal(metadataElementCost.extendedParseDouble(request.getParameter("new_cost")))).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue();
	metadataElementCost.metadata_element_unit_cost_us = (new BigDecimal(metadataElementCost.extendedParseDouble(request.getParameter("new_cost_us")))).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue();
	dbCon.close();
	%><jsp:forward page="metadataElementCostsUpdate.jsp?action=1"/><%
   }
else if (request.getParameter("deleteMetadataElementCosts")!=null)
   {
	metadataElementCost.init();
	metadataElementCost.dbType = metaElement.dbType;
	metadataElementCost.metadata_country = metaElement.metadata_country;
	metadataElementCost.metadata_element_key = metaElement.metadata_element_key;
	metadataElementCost.metadata_element_year = MetadataElementCosts.extendedParseInt(request.getParameter("new_year"));
	nSqlResult = metadataElementCost.getWebObject(con);
	if(nSqlResult < 1){
		sErrorMessage = metadataElementCost.lastError;
	} else {
		nSqlResult = metadataElementCost.deleteWebObject(con);
		if(nSqlResult < 1)
			sErrorMessage = metadataElementCost.lastError;
	}
	dbCon.close();
	%><%-- <jsp:forward page="metadataElementCostUpdate.jsp?action=2"/> --%><%
   }
else if (request.getParameter("retrieveMetadatqaElementCosts")!=null)
{
	request.setAttribute("country", countrybean.countrycode);
	request.setAttribute("indicator_key", indicator.indicator_key);
	request.setAttribute("element_key", metaElement.metadata_element_key);
	%><jsp:forward page="importXMLInFrame.jsp?action=5" /><%
}
else if (request.getParameter("doneButton")!=null)
{
	dbCon.close();
	%><jsp:forward page='metadataGroup.jsp?indicator_key=<%=request.getParameter("indicator_key") %>'/><%
}

String sField=countrybean.dbHelper[countrybean.dbType].sqlNvl("label_campo","label_campo_en");
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

function editField(eventId, year, cost, cost_us)
{
	// alert("event_id="+eventId+", year="+year+", value="+value);
	if(eventId === 'deleteMetadataElementCosts')
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
	var new_cost = document.createElement('input');
	new_cost.type = 'hidden';
	new_cost.name = 'new_cost' ; // 'the key/name of the attribute/field that is sent to the server
	new_cost.value = cost;
	theForm.appendChild(new_cost);
	var new_cost_us = document.createElement('input');
	new_cost_us.type = 'hidden';
	new_cost_us.name = 'new_cost_us' ; // 'the key/name of the attribute/field that is sent to the server
	new_cost_us.value = cost_us;
	theForm.appendChild(new_cost_us);
	document.desinventar.submit();
}
//-->
</script>


<FORM name="desinventar" id="maintainMetadataElementValue" method="post" action="maintainMetadataElementCosts.jsp">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<input type="hidden" name="metadata_element_key" value="<%=metaElement.metadata_element_key %>">
<input type="hidden" name="metadata_countrycode" id="countrycode" value="<%=countrybean.countrycode %>"> 
<input type="hidden" name="indicator_key" value="<%=indicator.indicator_key%>">
<table cellspacing="0" cellpadding="0" border="0" width="850">
<tr>
  <td width=50>&nbsp;</td>
  <td>
	<table cellspacing="0" cellpadding="5" border="0" width="850" rules="none">
	<tr>
	    <td height="25" td colspan="2" class='bgDark' align="center"><span class="title"><%=countrybean.getTranslation("Annual Metadata Element Unit Costs Manager")%></span></td>
		</td>
	</tr>
	<tr><td colspan="2" height="5"></td></tr>
	<TR>
	<TD colspan=2 align="center"><span class="warning"><%=sErrorMessage%></span></TD>
	</TR>
	<tr><td colspan="2" align="center">
	<input type="submit" name="addMetadataElementCosts" value="<%=countrybean.getTranslation("Add")%> <%=countrybean.getTranslation(metaElement.metadata_element_sector)%> <%=countrybean.getTranslation("annual unit costs")%>">
<input type="submit" name ="retrieveMetadatqaElementCosts" value="<%=countrybean.getTranslation("Retrieve metadata from desinventar.net")%>" />
	<%-- 
	<input name="doneButton" type=button value='<%=countrybean.getTranslation("Done")%>' onClick="postTo('metadataGroup.jsp')">
	 --%>
	<input name="doneButton" type="submit" value='<%=countrybean.getTranslation("Done")%>'>
	</td></tr>

	<tr><td colspan="2" align="center">
	<br/><br/>
	<table cellpadding=2  width="90%" celspacing=0 border=1>
    <tr class="DI_TableHeader bodyclass">
    <th><%=countrybean.getTranslation("Edit")%></th>
    <th><%=countrybean.getTranslation("Delete")%></th>
    <th><%=countrybean.getTranslation("Metadata Year")%></th>
    <th><%=countrybean.getTranslation("Metadata Unit Cost")%></th>
    <th><%=countrybean.getTranslation("Metadata Unit Cost US")%></th>
    </tr>
<%
	stmt=con.createStatement();
	rset=stmt.executeQuery("select * from metadata_element_costs where metadata_element_key="+metaElement.getMetadata_element_key()+" and metadata_country='"+metaElement.metadata_country+"' "+"order by metadata_element_year desc ");
	int j=0;
	while (rset.next())
		{
		MetadataElementCosts annualValue=new MetadataElementCosts();
		annualValue.loadWebObject(rset);
		out.println("<tr class='bs'>");
		/*
		out.println("<td><a href= 'javascript:editField("+j+")'><img src='/DesInventar/images/edit_row.gif' alt='Edit field' border=0></a></td>");
		out.println("<td><a href= 'javascript:deleteField("+j+")'><img src='/DesInventar/images/delete_row.gif' alt='Delete field' border=0></a></td>");
		*/
		out.println("<td align='center'><input name='editMetadataElementCosts' id='editMetadataElementCosts"+j+"' type='image'");
		out.println(" src='/DesInventar/images/edit_row.gif' alt='Submit' border='0'");
		out.println(" onClick=\"editField("+"'editMetadataElementCosts', "+annualValue.metadata_element_year+", "+annualValue.metadata_element_unit_cost+", "+annualValue.metadata_element_unit_cost_us+")\"></td>");
		out.println("<td align='center'><input name='deleteMetadataElementCosts' id='deleteAnnualMetaCosts"+j+"' type='image'");
		out.println(" src='/DesInventar/images/delete_row.gif' alt='Submit' border='0'");
		out.println(" onClick=\"editField("+"'deleteMetadataElementCosts', "+annualValue.metadata_element_year+", "+annualValue.metadata_element_unit_cost+", "+annualValue.metadata_element_unit_cost_us+")\"></td>");
		out.println("<td align='center'>"+annualValue.metadata_element_year+"</td><td align='right'>"+annualValue.metadata_element_unit_cost+"</td><td align='right'>"+annualValue.metadata_element_unit_cost_us+"</td></tr>");
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

