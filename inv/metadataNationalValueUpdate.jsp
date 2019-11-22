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
<jsp:useBean id = "metadata" class="org.lared.desinventar.webobject.MetadataNational" scope="session" />
<jsp:useBean id = "metadataNationalValue" class="org.lared.desinventar.webobject.MetadataNationalValues" scope="session" />
<%@ taglib uri="inventag.tld" prefix="inv" %>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
if (countrybean.countrycode.length()==0)
{%><jsp:forward page="/inv/index.jsp"/><%}%>
<%@ include file="checkUserIsLoggedIn.jsp" %>
<title>DesInventar on-line : <%=countrybean.countryname%> <%=countrybean.getTranslation("Metadata National Value Manager")%> </title>
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
/******************************************************************
*  Process the Register request.
******************************************************************/
if (request.getParameter("cancel")!=null)
{
  dbCon.close();
  %><jsp:forward page='/inv/metadataNationalManager.jsp'/><%
}
int top_year = Calendar.getInstance().get(Calendar.YEAR);
int bottom_year = 1980;
String sSql="";
String sErrorMessage="";
int action=webObject.extendedParseInt(request.getParameter("action"));
String sYear=request.getParameter("new_year");
String sValue=request.getParameter("new_value");
String sValueUS=request.getParameter("new_value_us");
int iYear = 0;
double dValue = 0.0;
double dValueUS = 0.0;
if(sValue != null && !metadataNationalValue.isNumber(sValue)){
	sErrorMessage=countrybean.getTranslation("SORRY")+": "+countrybean.getTranslation("Metadata national value ")+" "+sValue+" "+countrybean.getTranslation(" is not a number");
}
else if(sValue != null && !metadataNationalValue.isNumber(sValue)){
	sErrorMessage=countrybean.getTranslation("SORRY")+": "+countrybean.getTranslation("Metadata national value ")+" "+sValue+" "+countrybean.getTranslation(" is not a number");
}
else 

{
	iYear = sYear != null ? webObject.extendedParseInt(sYear) : (action > 0 ? metadataNationalValue.metadata_year : 0);
	dValue = (new BigDecimal(webObject.extendedParseDouble(sValue))).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue();
	dValueUS = (new BigDecimal(webObject.extendedParseDouble(sValueUS))).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue();
	if (request.getParameter("saveMetadataValue")!=null)
	{
		if(iYear == 0 && action == 0){
			sErrorMessage=countrybean.getTranslation("SORRY")+": "+countrybean.getTranslation("Metadata national year ")+countrybean.getTranslation(" is required");
		}
		else
		{
 
		// checks for a NEW or DIFFERENT name
		int nr=0;
		if (dValue == metadataNationalValue.metadata_value && dValueUS == metadataNationalValue.metadata_value_us)
			{
			MetadataNationalValues metadataNationalValueFromDb=new MetadataNationalValues();
			metadataNationalValueFromDb.metadata_key=webObject.extendedParseInt(request.getParameter("metadata_key"));
			metadataNationalValueFromDb.metadata_country=countrybean.countrycode;
			metadataNationalValueFromDb.metadata_year=iYear;
			nr=metadataNationalValueFromDb.getWebObject(con);
			if(nr > 0 
					&& ((new BigDecimal(metadataNationalValueFromDb.metadata_value)).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue() != dValue 
						|| (new BigDecimal(metadataNationalValueFromDb.metadata_value_us)).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue() != dValueUS
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
				metadataNationalValue.metadata_key=metadata.metadata_key;
				metadataNationalValue.metadata_country=countrybean.countrycode;
				metadataNationalValue.metadata_year=iYear;
				metadataNationalValue.metadata_value=dValue;
				metadataNationalValue.metadata_value_us=dValueUS;
				metadataNationalValue.addWebObject(con);
				sErrorMessage = metadataNationalValue.lastError;
				%><!-- ADDED RECORD: --><%-- <%=metadataNationalValue.lastError--%><%
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
						metadataNationalValue.getForm(request, response, con);
						metadataNationalValue.metadata_key=metadata.metadata_key;
						metadataNationalValue.metadata_country=countrybean.countrycode;
						metadataNationalValue.metadata_year=iYear;
						metadataNationalValue.metadata_value=dValue;
						metadataNationalValue.metadata_value_us=dValueUS;
						nr = metadataNationalValue.updateWebObject(con);
						sErrorMessage = metadataNationalValue.lastError;
						}
					catch (Exception e)
						{
						sErrorMessage="SORRY: national metadata cannot be updated.<!--"+e.toString()+" -->";
						}	
					try {pstmt.close();} catch (Exception cex){}
					%><!-- SECOND UPDATE: --><%-- <%=metadataNationalValue.lastError--%><%
					}
					%>
					<!-- FIRST UPDATE: <%-- <%=Event.sSql --%> --><%-- <%=Event.lastError--%><%
				}	
			if (sErrorMessage.length()==0)
				{
				dbCon.close();
		    	%><jsp:forward page='/inv/maintainMetadataNationalValue.jsp'/><%
				}
			}	
	  }
	}
}
%>



<form name="desinventar" action="metadataNationalValueUpdate.jsp" method="post" onSubmit="return validateFields()">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<input type="hidden" name="action" value="<%=action %>">
<input type="hidden" name="metadata_key" value="<%=metadataNationalValue.metadata_key %>">
<input type="hidden" name="metadata_countrycode" id="countrycode" value="<%=countrybean.countrycode %>"> 
<table cellspacing="0" cellpadding="2" border="0" width="750">
<tr>
    <td class='bgDark' height="25" colspan="2"><span class="titleText"><%=countrybean.getTranslation("Definitionof")%> <%=countrybean.getTranslation("Metadata national value")%> </span></td>
</tr>
<tr><td colspan="2" height="5"></td></tr>
<TR>
<TD colspan='2' align="center"><span class="warning"><%=sErrorMessage%></span></TD>
</TR>
<TR>
	<td width='220' class='bgLight' align='right'><%=countrybean.getTranslation("Metadata national value year")%>:</td>
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
	<td width='220' class='bgLight' align='right'><%=countrybean.getTranslation("Metadata national value")%>:</td>
	<td>  <INPUT type='TEXT' size='31' maxlength='200' name='new_value' VALUE="<%=metadataNationalValue.metadata_value%>"></td>
</tr>
<tr>
	<td width='220' class='bgLight' align='right'><%=countrybean.getTranslation("Metadata national value US")%>:</td>
	<td>  <INPUT type='TEXT' size='31' maxlength='200' name='new_value_us' VALUE="<%=metadataNationalValue.metadata_value_us%>"></td>
</tr>

	<TR>
	<TD colspan='3' height="20"></TD>
	</TR>
	<TR>
	<TD  valign="bottom"  align='right'>
	</TD>
	<TD valign="bottom">
	<input name="saveMetadataValue" type='submit' value='<%=countrybean.getTranslation("Save")%> <%=countrybean.getTranslation("Metadata national value")%>'> &nbsp; &nbsp; &nbsp; &nbsp;
	<input name="cancelMetadataValue" type='button' value='<%=countrybean.getTranslation("Cancel")%>' onClick="postTo('maintainMetadataNationalValue.jsp')">
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












