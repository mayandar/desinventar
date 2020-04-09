<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<title>DesInventar on-line - SDG Generation Management</title>
</head>
<%@ page import = "org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.dbutils" %>
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
function doConsolidate()
{
if (confirm('<%=countrybean.getTranslation("Are you sure?")%>'))
	 postTo("sdgManager.jsp?consolidate=yes");
}

function doImportSFM()
{
if (confirm('<%=countrybean.getTranslation("Are you sure?")%>'))
	postTo("sdgManager.jsp?importSFM=yes");
}


function doEvaluate()
{
if (confirm('<%=countrybean.getTranslation("Are you sure?")%>'))
	postTo("EL.jsp");
}

function doOverlap()
{
if (confirm('<%=countrybean.getTranslation("Are you sure?")%>'))
	postTo("sdgManager.jsp?removeOverlap=true")
}

function doCompound()
{
if (confirm('<%=countrybean.getTranslation("Are you sure?")%>'))
	postTo("sdgManager.jsp?calculateCompound=true")
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
 
<FORM name='desinventar' method="post" action="sdgManager.jsp">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<table cellspacing="0" cellpadding="0" border="0" width="1024">
<tr>
  <td align="center">
  <%=countrybean.getTranslation("Sendai Framework Manager")%></span>
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
   <span class="subtitle"><%=countrybean.getTranslation("Using MySQL Sendai_prod database in localhost")%></span>
   </td>
</tr>
<tr><td align="center">
	<br/>
	<table border="1" cellpadding="0" cellspacing="0" width=450>
	  <tr><td align="center">
      <br/>
<strong>DesInventar side steps:</strong>
<br/>
		<A class='linkText' href='javascript:doConsolidate()'><%=countrybean.getTranslation("Run DI consolidation program")%></a><br/>
<br/>
<strong>SFM only process steps:</strong>
<br/><br/>

		<A class='linkText' href='javascript:postTo("sdgExchange.jsp")'><%=countrybean.getTranslation(" Upload or edit Exchange rate data from SFM")%></a><br/>
        <A class='linkText' href='javascript:doImportSFM()'><%=countrybean.getTranslation(" Import all datacard and extension values from SFM")%></a><br/><br/>
<br/>
DI/SFM consolidated dataset steps<br/>
<font class="bss">Please run manually the import of the SDG database into the consolidated DesInventar database</font><br/> 
<br/>
		<A class='linkText' href='javascript:doOverlap()'><%=countrybean.getTranslation("Removal of overlapping records")%></a><br/><br/>
		<A class='linkText' href='javascript:doEvaluate()'><%=countrybean.getTranslation("Run Economic Loss calculation process")%></a><br/><br/>
		<A class='linkText' href='javascript:doCompound()'><%=countrybean.getTranslation("Calculation of compound indicators")%></a><br/><br/>
		<A class='linkText' href='javascript:postTo("sdgProduction.jsp")'><%=countrybean.getTranslation("Generation of final SDG indicators in DESA excel format")%></a><br/><br/>
 	</table>
	</td></tr>
	</table>
  </td>
 </tr>
</table>
</form>
<br/>
<strong>Process Log:</strong>
<%
sdgGenerationUtil  sdgImporter=new sdgGenerationUtil();
if (request.getParameter("consolidate")!=null)
	{
	String[] args={"--targetdb",countrybean.countrycode};
	dbutils.main(args);	
	}

if (request.getParameter("importSFM")!=null)
		sdgImporter.importSFM(countrybean, out);

if (request.getParameter("calculateCompound")!=null)
		{
			// execute the scripts
		ServletContext sc = getServletConfig().getServletContext();
		String strFileName=sc.getRealPath("scripts")+"/SFM_indicator_calculation_postgres";
		dbutils.executeFileScript(strFileName, con);
		}

%>	      
      
</body>
</html>

