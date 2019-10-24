<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<title>DesInventar on-line - Inflation and exhaange rate conversion Utility</title>
</head>
<%@ page import = "org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.webobject.users" %>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>

<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="woFicha" class="org.lared.desinventar.webobject.fichas" scope="session" />
<jsp:useBean id="woExtension" class="org.lared.desinventar.webobject.extension" scope="session" />

<%@ taglib uri="inventag.tld" prefix="inv" %>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%if (user.iusertype<20) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}%> 
<%@ include file="/util/opendatabase.jspf" %>
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
	var dVarValues=1;
	if (dVarValues==0)
	   alert ("WARNING: NO Exchange rate/Inflation Values have been defined in page.. Economic valuation may be zero.");
	 
	}	
return true;
}

// -->
</script>


<% 
int nSqlResult=0;
int[] years=null;
double[] inflation=null;
double[] exchange_rate=null;
String sErrorMessage="";
int nYears=0;
int nMaxYear=Calendar.getInstance().get(Calendar.YEAR);
int nMinYear=nMaxYear-30;

// loads the datacard extension
woExtension.dbType=dbType;
woExtension.loadExtension(con,countrybean);
org.lared.desinventar.webobject.Dictionary dct = new org.lared.desinventar.webobject.Dictionary();

String sInflationTargetVariable=dct.not_null(request.getParameter("target_var"));
int nOption=webObject.extendedParseInt(request.getParameter("calc_option"));
if (request.getParameter("save_EXCH_INFL")!=null || 
	request.getParameter("LEC_add_early_year")!=null || 
	request.getParameter("LEC_add_late_year")!=null || 
	request.getParameter("execute_EXCH_INFL")!=null)
   {
    String[] sYears=request.getParameterValues("years");  
	String[] sInflation=request.getParameterValues("inflation");  
	String[] sRate=request.getParameterValues("rates"); 
	nYears=sYears.length;
	int nOffset=0;
	if (request.getParameter("LEC_add_early_year")!=null)
		{
		nOffset=1;
		nYears++;
		}
	years=new int[nYears]; 
	inflation=new double[nYears]; 
	exchange_rate=new double[nYears]; 
	for (int j=0; j<nYears; j++)
		{
		years[j+nOffset]=webObject.extendedParseInt(sYears[j]);
		inflation[j+nOffset]=webObject.extendedParseDouble(sInflation[j]);
		exchange_rate[j+nOffset]=webObject.extendedParseDouble(sRate[j]);
		nMinYear=Math.min(nMinYear,years[j+nOffset]);
		nMaxYear=Math.max(nMaxYear,years[j+nOffset]);
		}
	if (request.getParameter("LEC_add_early_year")!=null)
		nMinYear--;
	years[0]=nMinYear;		
	LEC_util_valuation  lecValuator=new LEC_util_valuation();	
	if (request.getParameter("save_EXCH_INFL")!=null || 
		request.getParameter("execute_EXCH_INFL")!=null)
		lecValuator.save_inflation_parameters(con, years, inflation, exchange_rate);		
	if (request.getParameter("execute_EXCH_INFL")!=null)
		lecValuator.evaluate_inflation_exchange(countrybean, con,sInflationTargetVariable, nOption);
   }
	String sSql="";
	//Statement stmt=null;
	//ResultSet rset=null;
	try{
		stmt=con.createStatement();
		// Will provide for 30 years at least, startiung this year...
		rset=stmt.executeQuery("select min(lec_year) as nminyear, max(lec_year) as nmaxyear, count(*) as nyears from LEC_cpi");
		if (rset.next())
		  if (rset.getInt(3)>0)
			{
			nMinYear=Math.min(nMinYear,rset.getInt(1));
			nMaxYear=Math.max(nMaxYear,rset.getInt(2));
			}	
		rset=stmt.executeQuery("select min(lec_year) as nminyear, max(lec_year) as nmaxyear, count(*) as nyears  from LEC_exchange");
		if (rset.next())
		  if (rset.getInt(3)>0)
			{
			nMinYear=Math.min(nMinYear,rset.getInt(1));
			nMaxYear=Math.max(nMaxYear,rset.getInt(2));
			}
		nYears=	nMaxYear-nMinYear+1;		
		years=new int[nYears];
		for (int j=0; j<nYears; j++)
			years[j]=nMinYear+j;
		inflation=new double[nYears];
		exchange_rate=new double[nYears];

		rset=stmt.executeQuery("select * from LEC_cpi");
		while (rset.next())
		{
		int iYear=rset.getInt(1)-nMinYear;
		inflation[iYear]=rset.getDouble(2);
		}
		rset=stmt.executeQuery("select * from LEC_exchange");
		while (rset.next())
		{
		int iYear=rset.getInt(1)-nMinYear;
		exchange_rate[iYear]=rset.getDouble(2);
		}
	}
	catch (Exception e)
	{
		System.out.println("[DI9] Error retrieving exchange/inflation... "+e.toString());
	}
	finally{
		try{rset.close();}catch(Exception e){}
		try{stmt.close();}catch(Exception e){}
	}		
%>
   
<FORM name="desinventar" method="post" action="LEC_inflation_exchange.jsp">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<table cellspacing="0" cellpadding="0" border="0" width="750">
<tr>
  <td width=50>&nbsp;</td>
  <td>
	<table cellspacing="0" cellpadding="5" border="0" width="100%" rules="none">
	<tr>
        <td><font color="Blue"><%=countrybean.getTranslation("Region")%> </font><b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font> - [<jsp:getProperty name ="countrybean" property="countrycode"/>]</td>
	    <td height="25" td colspan="2" class='bgDark' align="center"><br/><span class="title"><%=countrybean.getTranslation("Economic Valuation Utility - Exchange and Inflation module")%></span></td>
	</tr>
	<tr><td colspan="2" height="5"></td></tr>
	<TR>
	<TD colspan=2 align="center"><span class="warning"><%=sErrorMessage%></span></TD>
	</TR>
	<tr><td colspan="2" height="5"></td></tr>
	<tr><td colspan="2" align="center">
	<input type="submit" name="save_EXCH_INFL" value="<%=countrybean.getTranslation("Save Parameters")%>">
	<input type="submit" name="execute_EXCH_INFL" value="<%=countrybean.getTranslation("Calculate Inflation/Exchange")%>" onClick="return bSomethingSelected()">   
    <input name="doneButton" type=button value='<%=countrybean.getTranslation("Done")%>' onClick="window.location='adminManager.jsp'">
	</td></tr>
	<tr><td colspan="2" height="5"></td></tr>
	<tr><td colspan="2" align="center" class="bodymedlight">
    
             <b><i><font class='subTitle'><%=countrybean.getTranslation("Target Variable for Present Value USD: ")%></font></i></b>
             <select name="target_var" id="target_var">
             <option value=""></option>
<!-- Too dangerous, could be used, but controled with option 4 ONLY!!!
             <option value="valorus"<%=dct.strSelected("valorus",sInflationTargetVariable)%>><%=countrybean.getTranslation("LossesUSD")%></option>
-->
<%     for (int k = 0; k < woExtension.vFields.size(); k++)
     {
	 dct = (org.lared.desinventar.webobject.Dictionary) woExtension.vFields.get(k);
	 if (dct.fieldtype==extension.INTEGER  ||
		 dct.fieldtype==extension.FLOATINGPOINT  ||
		 dct.fieldtype==extension.CURRENCY)		 
			{%>
             <option value="<%=dct.nombre_campo%>"<%=dct.strSelected(dct.nombre_campo,sInflationTargetVariable)%>><%=htmlServer.htmlEncode(countrybean.getLocalOrEnglish(dct.label_campo,dct.label_campo_en))%></option>
			<%}
     }%>
             </select>
             <br/>
    		
             <b><i><font class='subTitle'><%=countrybean.getTranslation("Options for Present Value USD: ")%></font></i></b><br/>
             <select name="calc_option" id="calc_option">
             <option value="0" <%=countrybean.strSelected(0,nOption)%>><%=countrybean.getTranslation("Use maximum of Local and USD losses")%> </option>
             <option value="1"<%=countrybean.strSelected(1,nOption)%>><%=countrybean.getTranslation("Priority to Local currency losses")%> </option>
             <option value="2"<%=countrybean.strSelected(2,nOption)%>><%=countrybean.getTranslation("Priority to USD losses")%></option>
             <option value="3"<%=countrybean.strSelected(3,nOption)%>><%=countrybean.getTranslation("Use only Local currency losses")%></option>
             <option value="4"<%=countrybean.strSelected(4,nOption)%>><%=countrybean.getTranslation("Use only USD losses")%></option>
             <option value="5"<%=countrybean.strSelected(5,nOption)%>><%=countrybean.getTranslation("Use SUM of Local and  USD losses")%></option>
             </select>
    
	</td></tr>
	<tr><td colspan="2" height="5"></td></tr>
    
	<tr><td colspan="2" height="25"></td></tr>    
   	<tr><td colspan="2" align="center">
	<table cellspacing="0" cellpadding="1" border="1" width="100%" class="bss">
    <tr>
        <th><%=countrybean.getTranslation("Year" )%></th>
        <th><%=countrybean.getTranslation("Exchange rate" )%></th>
        <th><%=countrybean.getTranslation("Inflation rate" )%></th>
    </tr>
    <tr><td  colspan="3" align="center"><input type="submit" name="LEC_add_early_year" value="<%=countrybean.getTranslation("Add year")%>"></td></tr>
     <!-- vectors here -->
     <%for (int j=0; j<nYears; j++){%>
    <tr>
    <td><input type='text' size="5" maxlength="5" name="years" value='<%=years[j]%>' class="bss"></td>
    <td><input type='text' size="12" maxlength="12" name="rates" value='<%=exchange_rate[j]%>' class="bss"></td>
    <td><input type='text' size="12" maxlength="12" name="inflation" value='<%=inflation[j]%>' class="bss"></td>
    </tr>
    <%}%>    
	</table>
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

