<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<title>DesInventar on-line - SDG Generation Management</title>
</head>
<%@ page import = "org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.login" %>
<%@ page import="org.lared.desinventar.util.htmlServer" %>
<%@ page import="org.lared.desinventar.sendai.sdgGenerationUtil" %>
<%@ page import="org.lared.desinventar.webobject.diccionario" %>
<%@ page import = "java.io.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.text.*" %>
<%@ page import = "java.util.*" %>
<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%@ taglib uri="inventag.tld" prefix="inv" %>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%
if (user.iusertype<99) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}%> 

<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/iheader",countrybean.getLanguage(),out);%>
<script type="text/javascript" src="/DesInventar/html/iheader.js"></script> 
<script language="javascript">

function SyncScroll(rolling) 
{
    
	var div = document.getElementById(rolling);
	aScrolls=["codes","years","names","rates"];
    for (j=0;  j<4; j++)
	  if (rolling!=aScrolls[j])
		{
		var div1 = document.getElementById(aScrolls[j]);
    	div1.scrollTop = div.scrollTop;
		}
}
</script> 
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
<br/><br/>
 
<FORM name='desinventar' method="post" action="sdgExchange.jsp">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<table cellspacing="0" cellpadding="0" border="0" width="1024">
<tr>
  <td align="center">
  <%=countrybean.getTranslation("Uload and Edit Exchane rate values - Sendai Framework Manager")%></span>
  </td>
</tr>
<tr>
	<td align="center" valign="top">
         <font color="Blue"><%=countrybean.getTranslation("Region")%></font>
         <b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b>
          - [<jsp:getProperty name ="countrybean" property="countrycode"/>]
	</td>
</tr>
<tr>
   <td height="25" class='bgDark' align="center">
   <span class="subtitle"><%=countrybean.getTranslation("Updating national_metadata_cost tables in localhost")%></span><br/>
   <span class="bss"><%=countrybean.getTranslation("Fill the columns, one country per line on each list (Tip: from excel just copy the columnd and paste it here)")%></span>
   </td>
</tr>
<tr>
  <td align="center">
	<br/>
    <table cellpadding="4" cellspacing="0" border=1>
    <tr>
    	<td><%=countrybean.getTranslation("Country Code")%></td>
    	<td><%=countrybean.getTranslation("Country Name")%></td>
    	<td><%=countrybean.getTranslation("Year")%></td>
    	<td><%=countrybean.getTranslation("Exchange rate LCU to US")%></td>
    </tr>
	 <% 
     // loads here whatever is in the metadata_national_values for Sendai Variable 4
     sdgGenerationUtil  sdgImporter=new sdgGenerationUtil();
	 
	 if (request.getParameter("saveRates")!=null)
		{
			String sCodes=request.getParameter("codes");
			String sYears=request.getParameter("years");
			String sRates=request.getParameter("rates");			
			sdgImporter.uploadRates(countrybean, out, sCodes, sYears, sRates);
		}

	 String[] arrRateStrings= new String[4];
     sdgImporter.getRates(countrybean, out, arrRateStrings);
   %>
    <tr>
    <td align="center"><textarea id="codes" name="codes" cols="10" rows="30" onScroll="SyncScroll('codes')"><%=arrRateStrings[0]%></textarea></td>
   	<td valign="top"><textarea id="names" name="names" cols="30" rows="30"  onScroll="SyncScroll('names')" disabled><%=arrRateStrings[3]%></textarea></td>
    <td align="center"><textarea id="years" name="years" cols="6" rows="30" onScroll="SyncScroll('years')"><%=arrRateStrings[1]%></textarea></td>
    <td align="center"><textarea id="rates" name="rates" cols="15" rows="30" onScroll="SyncScroll('rates')"><%=arrRateStrings[2]%></textarea></td>
    </tr> 
  </table>    
  </td>
 </tr>
</table>
<input type="submit" name="saveRates" value="Save these values"> &nbsp;
<input type="button" name="cencel" value="Cancel" onClick="window.location='sdgManager.jsp'"> &nbsp;
</form>
<strong>Process Log:</strong>

      
</body>
</html>

