<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<%@ page import = "org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import="java.util.Calendar" %>
<%@ page import = "java.math.BigDecimal" %>
<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id = "metaElement" class="org.lared.desinventar.webobject.MetadataElement" scope="session" />
<jsp:useBean id = "metadataElementCost" class="org.lared.desinventar.webobject.MetadataElementCosts" scope="session" />
<jsp:useBean id="indicator" class="org.lared.desinventar.webobject.MetadataIndicator" scope="session" />
<%@ taglib uri="inventag.tld" prefix="inv" %>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%
indicator.indicator_key=indicator.extendedParseInt(request.getParameter("indicator_key"));
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
if (countrybean.countrycode.length()==0)
{%><jsp:forward page="/inv/index.jsp"/><%}%>
<%@ include file="checkUserIsLoggedIn.jsp" %>
<title>DesInventar on-line : <%=countrybean.countryname%> <%=countrybean.getTranslation("Metadata Element Costs Manager")%> </title>
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
<table width="1024" border="1" class="pageBackground" rules="none" height="500"><tr><td align="center" valign="top">
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
/******************************************************************
*  Process the Register request.
******************************************************************/
if (request.getParameter("cancel")!=null)
{
  dbCon.close();
  %><jsp:forward page='/inv/maintainMetadataElementCosts.jsp?indicator_key=<%=indicator.indicator_key %>'/><%
}
int top_year = Calendar.getInstance().get(Calendar.YEAR);
int bottom_year = 1980;
String sSql="";
String sErrorMessage="";
int action=metadataElementCost.extendedParseInt(request.getParameter("action"));
String sYear=request.getParameter("new_year");
String sValue=request.getParameter("new_cost");
String sValueUS=request.getParameter("new_cost_us");
int iYear = 0;
double dValue = 0.0;
double dValueUS = 0.0;
if(sValue != null && !metadataElementCost.isNumber(sValue)){
	sErrorMessage=countrybean.getTranslation("SORRY")+": "+countrybean.getTranslation("Metadata Element Unit Cost ")+" "+sValue+" "+countrybean.getTranslation(" is not a number");
}
else if(sValueUS != null && !metadataElementCost.isNumber(sValueUS)){
	sErrorMessage=countrybean.getTranslation("SORRY")+": "+countrybean.getTranslation("Metadata Element Unit Cost US ")+" "+sValue+" "+countrybean.getTranslation(" is not a number");
}
else 
 
{
	iYear = sYear != null ? metadataElementCost.extendedParseInt(sYear) : (action > 0 ? metadataElementCost.metadata_element_year : 0);
	dValue = (new BigDecimal(metadataElementCost.extendedParseDouble(sValue))).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue();
	dValueUS = (new BigDecimal(metadataElementCost.extendedParseDouble(sValueUS))).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue();
	if (request.getParameter("saveMetadataElementCosts")!=null)
	{
		if(iYear == 0 && action == 0){
			sErrorMessage=countrybean.getTranslation("SORRY")+": "+countrybean.getTranslation("Metadata Element Unit Cost Year ")+countrybean.getTranslation(" is required");
		}
		else
		{
 
		// checks for a NEW or DIFFERENT name
		int nr=0;
		if (dValue == metadataElementCost.metadata_element_unit_cost && dValueUS == metadataElementCost.metadata_element_unit_cost_us)
			{
			MetadataElementCosts metadataElementCostFromDb=new MetadataElementCosts();
			// metadataElementCostFromDb.metadata_element_key=metadataElementCostFromDb.extendedParseInt(request.getParameter("metadata_element_key"));
			metadataElementCostFromDb.metadata_element_key=metaElement.metadata_element_key;
			metadataElementCostFromDb.metadata_country=countrybean.countrycode;
			metadataElementCostFromDb.metadata_element_year=iYear;
			nr=metadataElementCostFromDb.getWebObject(con);
			if(nr > 0 
					&& ((new BigDecimal(metadataElementCostFromDb.metadata_element_unit_cost)).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue() != dValue 
						|| (new BigDecimal(metadataElementCostFromDb.metadata_element_unit_cost_us)).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue() != dValueUS
						)
			)
				nr=0;
			}
		// the new or different name exists...
		if (nr>0)
			{
			sErrorMessage=countrybean.getTranslation("SORRY")+": "+countrybean.getTranslation("Metadata national value ")+countrybean.getTranslation("alreadyexists");
			}
		else
			{
			// metadata.getForm(request,response,con);
			if (action==0)
				{
				metadataElementCost.metadata_element_key=metaElement.metadata_element_key;
				metadataElementCost.metadata_country=countrybean.countrycode;
				metadataElementCost.metadata_element_year=iYear;
				metadataElementCost.metadata_element_unit_cost=dValue;
				metadataElementCost.metadata_element_unit_cost_us=dValueUS;
				metadataElementCost.addWebObject(con);
				sErrorMessage = metadataElementCost.lastError;
				%><!-- ADDED RECORD: --><%-- <%=metadataElementCost.lastError--%><%
				}
			else
				/* TODO Update */
				{
				if (action==1)
					{
					PreparedStatement pstmt=null;
					try
						{
						// this statements implement DB-independent UPDATE ON CASCADE
						// Some databases (access, mysql) have problems/limitations on referential integrity constraints
						// Specifically, the implementation of ON UPDATE CASCADE ON DELETE ...  varies dramatically from 
						// platform to platform. In the future, these tables should have sequential surrogate keys.
						// a) creates new parent record
						metadataElementCost.getForm(request, response, con);
						metadataElementCost.metadata_element_key=metaElement.metadata_element_key;
						metadataElementCost.metadata_country=countrybean.countrycode;
						metadataElementCost.metadata_element_year=iYear;
						metadataElementCost.metadata_element_unit_cost=dValue;
						metadataElementCost.metadata_element_unit_cost_us=dValueUS;
						nr = metadataElementCost.updateWebObject(con);
						sErrorMessage = metadataElementCost.lastError;
						}
					catch (Exception e)
						{
						sErrorMessage="SORRY: national metadata cannot be updated.<!--"+e.toString()+" -->";
						}	
					try {pstmt.close();} catch (Exception cex){}
					%><!-- SECOND UPDATE: --><%-- <%=metadataElementCost.lastError--%><%
					}
					%>
					<!-- FIRST UPDATE: <%-- <%=Event.sSql --%> --><%-- <%=Event.lastError--%><%
				}	
			if (sErrorMessage.length()==0)
				{
				dbCon.close();
		    	%><jsp:forward page='/inv/maintainMetadataElementCosts.jsp'/><%
				}
			}	
	  }
	}
}
%>

<script language="JavaScript">

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



<form name="desinventar" action="metadataElementCostsUpdate.jsp" method="post" onSubmit="return validateFields()">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<input type="hidden" name="indicator_key" value="<%=indicator.indicator_key%>">
<input type="hidden" name="action" value="<%=action %>">
<input type="hidden" name="metadata_key" value="<%=metaElement.metadata_element_key %>">
<input type="hidden" name="metadata_countrycode" id="countrycode" value="<%=countrybean.countrycode %>"> 
<table cellspacing="0" cellpadding="2" border="0" width="750">
<tr>
    <td class='bgDark' height="25" td colspan="2"><span class="titleText"><%=countrybean.getTranslation("Definitionof")%> <%=countrybean.getTranslation("Metadata national value")%> </span></td>
	</td>
</tr>
<tr><td colspan="2" height="5"></td></tr>
<TR>
<TD colspan='2' align="center"><span class="warning"><%=sErrorMessage%></span></TD>
</TR>
<TR>
	<td width='280' class='bgLight' align='right'><%=countrybean.getTranslation("Metadata Element Unit Cost Year")%>:</td>
	<td> 
	<% if (action == 0) { %> 	
		<select id="new_year" name="new_year" width="10" >
				<option value='0' ><%="" %></option>
	<% } else { %>
		<select id="new_year" name="new_year" width="10" disabled>
				<option value='0' ><%="" %></option>
	<% }
			for(int i = top_year; i >= bottom_year; i--){
				if(i == iYear) {
				%>
				<option value='<%=i%>' selected ><%=i %></option>
				<%
				} else { %>
				<option value='<%=i%>' ><%=i %></option>
				<%
				}
			}
	%>
		</select>
	</td>
</tr>
<tr>
	<td width='220' class='bgLight' align='right'><%=countrybean.getTranslation("Metadata Element Unit Cost")%>:</td>
	<td>  <INPUT type='TEXT' size='31' maxlength='200' name='new_cost' VALUE="<%=htmlServer.htmlEncode(metadataElementCost.metadata_element_unit_cost)%>"></td>
</tr>
<tr>
	<td width='220' class='bgLight' align='right'><%=countrybean.getTranslation("Metadata Element Unit Cost US")%>:</td>
	<td>  <INPUT type='TEXT' size='31' maxlength='200' name='new_cost_us' VALUE="<%=htmlServer.htmlEncode(metadataElementCost.metadata_element_unit_cost_us)%>"></td>
</tr>

	<TR>
	<TD colspan='3' height="20"></TD>
	</TR>
	<TR>
	<TD  valign="bottom"  align='right'>
	</TD>
	<TD valign="bottom">
	<input name="saveMetadataElementCosts" type='submit' value='<%=countrybean.getTranslation("Save")%> <%=countrybean.getTranslation("Metadata national value")%>'> &nbsp; &nbsp; &nbsp; &nbsp;
	<%-- 
	<input name="cancelMetadataElementCosts" type='button' value='<%=countrybean.getTranslation("Cancel")%>' onClick="postTo('maintainMetadataElementCosts.jsp')">
	 --%>
	<input name="cancel" type='submit' value='<%=countrybean.getTranslation("Cancel")%>' >
	</TD>
	</Tr>

	<TR>
	<TD colspan='3' height="10"></TD>
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
<% dbCon.close(); %>












