<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<title>DesInventar on-line - System Parameters</title>
</head>
<%@ page import = "org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.system.*" %>
<%@ page import = "java.sql.*" %>
<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%@ taglib uri="/inventag.tld" prefix="inv" %>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
 
 
<%
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
if (user.iusertype<99) 
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
/******************************************************************
*  Process the Register request.
******************************************************************/
if (request.getParameter("cancelParams")!=null)
{
  %><jsp:forward page='/inv/adminManager.jsp'/><%
}
String sSql="";
String sErrorMessage="";
if (request.getParameter("saveParams")!=null)
  { 
    Sys.strPlatform = htmlServer.not_null(request.getParameter("strPlatform"));
    Sys.iDatabaseType = Integer.parseInt(htmlServer.not_null(request.getParameter("iDatabaseType")));
    Sys.sDbDriverName = htmlServer.not_null(request.getParameter("sDbDriverName"));
    Sys.sDataBaseName = htmlServer.not_null(request.getParameter("sDataBaseName"));
    Sys.sDbUserName = htmlServer.not_null(request.getParameter("sDbUserName"));
    Sys.sDbPassword = htmlServer.not_null(request.getParameter("sDbPassword"));
    Sys.sMaxConnections = htmlServer.not_null(request.getParameter("sMaxConnections"));
    Sys.sDbPoolLogFile = htmlServer.not_null(request.getParameter("sDbPoolLogFile"));
    Sys.strFilePrefix = htmlServer.not_null(request.getParameter("strFilePrefix"));
    Sys.strAbsPrefix = htmlServer.not_null(request.getParameter("strAbsPrefix"));
    Sys.sDefaultDir = htmlServer.not_null(request.getParameter("sDefaultDir"));
    Sys.sMailOutServerIp = htmlServer.not_null(request.getParameter("sMailOutServerIp"));
    Sys.sMailOutServerPort = htmlServer.not_null(request.getParameter("sMailOutServerPort"));
    Sys.sMailOutProtocol = htmlServer.not_null(request.getParameter("sMailOutProtocol"));
    Sys.bRequireLogin = webObject.strToBool(request.getParameter("RequireLogin"));
	Sys.sGoogleKey = htmlServer.not_null(request.getParameter("sGoogleKey"));
	
    // NOT IMPLEMENTED NOR CAPTURED:
    // strMailDir = htmlServer.not_null(request.getParameter("strMailDir"));
    // sMailUserName = htmlServer.not_null(request.getParameter("sMailUserName"));
    // sMailPassword = htmlServer.not_null(request.getParameter("sMailPassword"));
    // sMailInServerIp = htmlServer.not_null(request.getParameter("sMailInServerIp"));
    // sMailInServerPort = htmlServer.not_null(request.getParameter("sMailInServerPort"));
    // sMailInProtocol = htmlServer.not_null(request.getParameter("sMailInProtocol"));
	Sys.saveProps();
  %><jsp:forward page='/inv/adminManager.jsp'/><%
  }
%>

<script language="JavaScript">
<!--
function giveFocus() 
{
  document.desinventar.strPlatform.focus()
}

function submitForm() 
{
  document.desinventar.submit()
}

function resetForm() 
{
  document.desinventar.reset()
  document.desinventar.name0.focus()
}

asDrivers = new Array	(
	"oracle.jdbc.driver.OracleDriver",						
	"<%=EncodeUtil.jsEncode(Sys.sAccess64Driver)%>",                     
	"com.microsoft.sqlserver.jdbc.SQLServerDriver",  
	"com.mysql.jdbc.Driver",
	"sun.jdbc.odbc.JdbcOdbcDriver",
	"org.postgresql.Driver",
	"org.apache.derby.jdbc.EmbeddedDriver",
	"com.inzoom.jdbcado.Driver",                     
	"",
	"");
	
<%
ServletContext sc = getServletConfig().getServletContext();
// DI7.0 ships with this empty DesInventar access database
String sSourcePath= sc.getRealPath("/desinventar.mdb");
sSourcePath=sSourcePath.replace("/","\\");
%>

var sDefaultAccessString="<%=EncodeUtil.jsEncode(Sys.sDefaultAccessString)%>";
var sDefaultAccessMainString="<%=EncodeUtil.jsEncode(Sys.sDefaultAccessMainString)%>";
	
asConnects=new Array(
	"jdbc:oracle:thin:@localhost:1521:DATABASE",                                
	"<%=EncodeUtil.jsEncode(Sys.sDefaultAccessMainString)%>",   
	"jdbc:sqlserver://localhost:1433;databaseName=DATABASE;",    
	"jdbc:mysql://localhost:3306/DATABASE",
	"jdbc:odbc:DATABASE_ODBC_CONNECT_STRING",   
	"jdbc:postgresql://localhost/DATABASE",
	"jdbc:derby:/etc/desinventar/desinventar_DB;create=true",
	"jdbc:: ",
	"jdbc:: "
	);

function setDriver()
{
with (document.desinventar)
	{
	sDbDriverName.value=asDrivers[iDatabaseType.value];	
	pos=sDataBaseName.value.substring(5).indexOf(":");
	if (sDataBaseName.value.substring(0,5+pos)!=asConnects[iDatabaseType.value].substring(0,5+pos))
		sDataBaseName.value=asConnects[iDatabaseType.value];	
	}
}
// -->
</script>



<table cellspacing="0" cellpadding="0" border="0" width="800">
<form name="desinventar" action="parameterManager.jsp" method="post">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<tr>
    <td class='bgDark' height="25" td colspan="3"><span class="title"><%=countrybean.getTranslation("DesInventarSystemBasicParameters")%></span></td>
	</td>
</tr>
<tr><td colspan="3" height="5"></td></tr>
<TR>
<TD colspan=2 align="center" class=bgLightLight><span class="warning"><%=countrybean.getTranslation("ParameterWarning")%><br>
 <%=sErrorMessage%></span></TD>
</TR>
<tr><td colspan="3" height="5"></td></tr>
 <TR><td  class=bgLight align='right' nowrap><%=countrybean.getTranslation("SupportedPlatforms")%>:</td>
     <td align="left"><INPUT type='TEXT' size='60' maxlength='60' name='strPlatform' VALUE='<%=Sys.strPlatform%>'></td>
 </tr>
 <TR><td  class=bgLight align='right' nowrap><%=countrybean.getTranslation("AccessToDesInventarModule")%>:</td>
     <td>
 		<select name ='RequireLogin'">
		<option value='false'<%=user.strSelected(!Sys.bRequireLogin)%>><%=countrybean.getTranslation("Anonymous")%>
	    <option value='true'<%=user.strSelected(Sys.bRequireLogin)%>><%=countrybean.getTranslation("Authentication")%>
	    </select>
	 </td>
 </tr>
 <TR><td  class=bgLight align='right' nowrap><%=countrybean.getTranslation("DatabaseType")%>:</td>
     <td>
 		<select name ='iDatabaseType' onChange="setDriver()">
	    <option value='0'<%=user.strSelected(Sys.iDatabaseType,0)%>><%=countrybean.getTranslation("Oracle")%>
    	<option value='1'<%=user.strSelected(Sys.iDatabaseType,1)%>><%=countrybean.getTranslation("ODBCnoAuthentication")%>
  		<option value='2'<%=user.strSelected(Sys.iDatabaseType,2)%>><%=countrybean.getTranslation("MicrosoftSQLServer")%>;
  		<option value='3'<%=user.strSelected(Sys.iDatabaseType,3)%>><%=countrybean.getTranslation("MySQL")%>
  		<option value='4'<%=user.strSelected(Sys.iDatabaseType,4)%>><%=countrybean.getTranslation("ODBCGeneric")%>
  		<option value='5'<%=user.strSelected(Sys.iDatabaseType,5)%>><%=countrybean.getTranslation("PostgreSQL")%>
  		<option value='6'<%=user.strSelected(Sys.iDatabaseType,6)%>><%=countrybean.getTranslation("Derby")%>
	    </select>

	 </td>
 </tr>
 <TR><td  class=bgLight align='right' nowrap><%=countrybean.getTranslation("sDbDriverName")%>:</td>
     <td><INPUT type='TEXT' size='60' maxlength='60' name='sDbDriverName' VALUE='<%=Sys.sDbDriverName%>'></td>
 </tr>
 <TR><td  class=bgLight align='right' nowrap> <%=countrybean.getTranslation("sDataBaseName")%>:</td>
     <td><INPUT type='TEXT' size='120' maxlength='260' name='sDataBaseName' VALUE='<%=Sys.sDataBaseName%>'></td>
 </tr>
 <TR><td  class=bgLight align='right' nowrap><%=countrybean.getTranslation("sDbUserName")%>:</td>
     <td><INPUT type='TEXT' size='30' maxlength='30' name='sDbUserName' VALUE='<%=Sys.sDbUserName%>'></td>
 </tr>
 <TR><td  class=bgLight align='right' nowrap><%=countrybean.getTranslation("sDbPassword")%>:</td>
     <td><INPUT type='TEXT' size='30' maxlength='30' name='sDbPassword' VALUE='<%=Sys.sDbPassword%>'></td>
 </tr>
 <TR><td  class=bgLight align='right' nowrap><%=countrybean.getTranslation("sMaxConnections")%>:</td>
     <td><INPUT type='TEXT' size='3' maxlength='3' name='sMaxConnections' VALUE='<%=Sys.sMaxConnections%>'></td>
 </tr>
 <TR><td  class=bgLight align='right' nowrap><%=countrybean.getTranslation("sDbPoolLogFile")%>:</td>
     <td><INPUT type='TEXT' size='60' maxlength='60' name='sDbPoolLogFile' VALUE='<%=Sys.sDbPoolLogFile%>'></td>
 </tr>
 <TR><td  class=bgLight align='right' nowrap><%=countrybean.getTranslation("strFilePrefix")%>:</td>
     <td><INPUT type='TEXT' size='60' maxlength='60' name='strFilePrefix' VALUE='<%=Sys.strFilePrefix%>'></td>
 </tr>
 <TR><td  class=bgLight align='right' nowrap><%=countrybean.getTranslation("strAbsPrefix")%>:</td>
     <td><INPUT type='TEXT' size='60' maxlength='60' name='strAbsPrefix' VALUE='<%=Sys.strAbsPrefix%>'></td>
 </tr>
 <TR><td  class=bgLight align='right' nowrap><%=countrybean.getTranslation("sDefaultDir")%>:</td>
     <td><INPUT type='TEXT' size='60' maxlength='60' name='sDefaultDir' VALUE='<%=Sys.sDefaultDir%>'></td>
 </tr>
 <TR><td  class=bgLight align='right' nowrap><%=countrybean.getTranslation("sMailOutServerIp")%>:</td>
     <td><INPUT type='TEXT' size='20' maxlength='20' name='sMailOutServerIp' VALUE='<%=Sys.sMailOutServerIp%>'></td>
 </tr>
 <TR><td  class=bgLight align='right' nowrap><%=countrybean.getTranslation("sMailOutServerPort")%>:</td>
     <td><INPUT type='TEXT' size='6' maxlength='6' name='sMailOutServerPort' VALUE='<%=Sys.sMailOutServerPort%>'></td>
 </tr>
 <TR><td  class=bgLight align='right' nowrap><%=countrybean.getTranslation("sMailOutProtocol")%>:</td>
     <td><INPUT type='TEXT' size='30' maxlength='30' name='sMailOutProtocol' VALUE='<%=Sys.sMailOutProtocol%>'></td>
 </tr>

 <TR><td  class=bgLight align='right' nowrap><%=countrybean.getTranslation("Google Key")%>:</td>
     <td><INPUT type='TEXT' size='120' maxlength='128' name='sGoogleKey' VALUE='<%=Sys.sGoogleKey%>'></td>
 </tr>

	<TR>
	<TD colspan=3 height="20"></TD>
	</TR>
	<TR>
	<TD  valign="bottom"  align=right>
	</TD>
	<TD valign="bottom">
	<input name="saveParams" type=submit value='<%=countrybean.getTranslation("SaveParameters")%>'> &nbsp; &nbsp; &nbsp; &nbsp;
	<input name="cancelParams" type=submit value='<%=countrybean.getTranslation("Cancel")%>'>
	</TD>
	</Tr>

	<TR>
	<TD colspan=3 height="10"></TD>
	</TR>
	<TR>
</form>
</table>
<script language="JavaScript">
<!-- 
giveFocus();
// -->
</script>
</BODY>
</html>












