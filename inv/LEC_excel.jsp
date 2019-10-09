<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<title>DesInventar on-line - Economic Valuation Utility</title>
</head>
<%@ page import = "org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.webobject.users" %>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import = "java.sql.*" %>

<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="woFicha" class="org.lared.desinventar.webobject.fichas" scope="session" />
<jsp:useBean id="woExtension" class="org.lared.desinventar.webobject.extension" scope="session" />

<%@ taglib uri="/inventag.tld" prefix="inv" %>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%if (user.iusertype<20) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}%> 
<%@ include file="/util/opendatabase.jspf" %>
<% 
int nSqlResult =0;
String sErrorMessage="";
// loads the datacard extension
woExtension.dbType=dbType;
woExtension.loadExtension(con,countrybean);
Dictionary dct = new Dictionary();
String sTargetVariable=dct.not_null(request.getParameter("target_var"));

if (request.getParameter("execute_LEC_XLS")!=null)
   {
	dbCon.close();   	
	response.sendRedirect("LEC_empirical_excel.jsp?group_option="+request.getParameter("group_option")+"&target_var="+request.getParameter("target_var"));
   }
LEC_util_valuation  lecValuator=new LEC_util_valuation();
if (sTargetVariable.length()==0)
   sTargetVariable=lecValuator.load_lec_parameters(countrybean, woFicha, woExtension);
int nOption=webObject.extendedParseInt(request.getParameter("group_option"));

%>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
 
 <script language="JavaScript">
<!--
function bSomethingSelected()
{
with (document.desinventar)
	{
	if (target_var.selectedIndex<1)
		{
		alert ("<%=countrybean.getTranslation("Please select a target variable...")%>");
		return false;
		}
	}	
return true;
}

// -->
</script>
   
<FORM name="desinventar" method="post" action="LEC_excel.jsp">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<table cellspacing="0" cellpadding="0" border="0" width="750">
<tr>
  <td width=50>&nbsp;</td>
  <td>
	<table cellspacing="0" cellpadding="5" border="0" width="650" rules="none">
	<tr>
        <td><font color="Blue"><%=countrybean.getTranslation("Region")%> </font><b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font> - [<jsp:getProperty name ="countrybean" property="countrycode"/>]</td>
	    <td height="25" td colspan="2" class='bgDark' align="center"><br/><span class="title"><%=countrybean.getTranslation("Economic Valuation Utility")%></span></td>
	</tr>
	<tr><td colspan="2" height="5"></td></tr>
	<TR>
	<TD colspan=2 align="center"><span class="warning"><%=sErrorMessage%></span></TD>
	</TR>
	<tr><td colspan="2" height="5"></td></tr>
	<tr><td colspan="2" align="center">
	<input type="submit" name="execute_LEC_XLS" value="<%=countrybean.getTranslation("Generate Excel")%>" onClick="return bSomethingSelected()">   
    <input name="doneButton" type=button value='<%=countrybean.getTranslation("Done")%>' onClick="window.location='adminManager.jsp'">
	</td></tr>
	<tr><td colspan="2" height="25"></td></tr>
    <tr><td colspan="2" align="left" class="bodymedlight">
    
             <b><i><font class='subTitle'><%=countrybean.getTranslation("Target Variable with Economic Loss Assessment: ")%></font></i></b>
             <select name="target_var" id="target_var">
             <option value=""></option> 
             <option value="valorus"<%=dct.strSelected("valorus",sTargetVariable)%>><%=countrybean.getTranslation("LossesUSD")%></option>
             <option value="valorloc"<%=dct.strSelected("valorloc",sTargetVariable)%>><%=countrybean.getTranslation("LossesLocal")%></option>

<%     for (int k = 0; k < woExtension.vFields.size(); k++)
     {
	 dct = (org.lared.desinventar.webobject.Dictionary) woExtension.vFields.get(k);
	 if (dct.fieldtype==extension.INTEGER  ||
		 dct.fieldtype==extension.FLOATINGPOINT  ||
		 dct.fieldtype==extension.CURRENCY)		 
			{%>
             <option value="<%=dct.nombre_campo%>"<%=dct.strSelected(dct.nombre_campo,sTargetVariable)%>><%=htmlServer.htmlEncode(countrybean.getLocalOrEnglish(dct.label_campo,dct.label_campo_en))%></option>
			<%}
     }%>
             </select>
             <br/><br/>
    		
             <b><i><font class='subTitle'><%=countrybean.getTranslation("Options for Grouping: ")%></font></i></b>
             <select name="group_option" id="group_option">
             <option value="0" <%=countrybean.strSelected(0,nOption)%>><%=countrybean.getTranslation("Simple Grouping by Event/Geography level 0/Date")%> </option>
             <option value="1"<%=countrybean.strSelected(1,nOption)%>><%=countrybean.getTranslation("Grouping by GLIDE number")%> </option>
             <option value="2"<%=countrybean.strSelected(2,nOption)%>><%=countrybean.getTranslation("No Grouping")%></option>
             </select>
    
	</td></tr>
    <tr><td colspan="2" height="25"></td></tr>
    <tr><td colspan="2" align="center">
		<!-- Exchange rate and inflation series -->
    
   	    </td>
    </tr>
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

