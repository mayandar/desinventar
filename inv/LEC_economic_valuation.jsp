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
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
<script type="text/javascript" src="/DesInventar/html/iheader.js"></script> 
 
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
	var dVarValues=muertos.value+heridos.value+desaparece.value+valorloc.value+valorus.value+
	        vivafec.value+vivdest.value+kmvias.value+
			afectados.value+socorro.value+industrias.value+acueducto.value+alcantarillado.value+energia.value+
			comunicaciones.value+nhospitales.value+nescuelas.value+	nhectareas.value+cabezas.value+	kmvias.value+
			damnificados.value+evacuados.value+reubicados.value;
	if (dVarValues==0)
	   alert ("WARNING: NO Unit Values have been defined in Datacard.. Economic valuation may be zero.");
	 
	}	
return true;
}

// -->
</script>


<% 
int nSqlResult =0;
String sErrorMessage="";
// loads the datacard extension
woExtension.dbType=dbType;
woExtension.loadExtension(con,countrybean);
Dictionary dct = new Dictionary();
String sTargetVariable=dct.not_null(request.getParameter("target_var"));

if (request.getParameter("save_LEC_EV")!=null || request.getParameter("execute_LEC_EV")!=null)
   {
	woFicha.clave=0;
	woFicha.getForm(request, response, con);
	woExtension.getForm(request, response, con);
	LEC_util_valuation  lecValuator=new LEC_util_valuation();
	lecValuator.save_lec_parameters(countrybean, woFicha, woExtension, sTargetVariable);		
	if (request.getParameter("execute_LEC_EV")!=null)
		lecValuator.evaluate_economic_value(countrybean, con);
   }
 else
   {
   	woExtension.init();
   	woFicha.init();
   	woFicha.vivafec=500;
	woFicha.kmvias=200;
	woFicha.cabezas=200;
	woFicha.vivafec=8000;
	woFicha.nhectareas=800;
	woFicha.vivdest=22000;
	woFicha.nescuelas=90000;
	woFicha.nhospitales=800000;
	LEC_util_valuation  lecValuator=new LEC_util_valuation();
	sTargetVariable=lecValuator.load_lec_parameters(countrybean, woFicha, woExtension);
   }  
%>
   
<FORM name="desinventar" method="post" action="LEC_economic_valuation.jsp">
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
	<input type="submit" name="save_LEC_EV" value="<%=countrybean.getTranslation("Save Parameters")%>">
	<input type="submit" name="execute_LEC_EV" value="<%=countrybean.getTranslation("Calculate")%>" onClick="return bSomethingSelected()">
   
    <input name="doneButton" type=button value='<%=countrybean.getTranslation("Done")%>' onClick="postTo('adminManager.jsp')">
	</td></tr>
	<tr><td colspan="2" height="25"></td></tr>
    

    
   	<tr><td colspan="2" align="center">

<%@ include file="LEC_ficha.jsp" %>
<%
	try{rset.close();} catch (Exception eIgnr){}	
	try{stmt.close();} catch (Exception eIgnr){}
%>
	

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

