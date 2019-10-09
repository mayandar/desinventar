<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<%@ page info="DesInventar On-Line" session="true" %> 
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %> 
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id = "Region" class="org.lared.desinventar.webobject.country" scope="session" />
<%@ page import="org.lared.desinventar.system.Sys" %>
<%
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
%>
<%@ include file="checkUserIsLoggedIn.jsp" %>
<%if (user.iusertype<20) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}
  
  //NOTE: the ODBC-JDBC bridge doesn't support UNICODE (nor UTF-8) 
   response.setContentType("text/html; charset=UTF-8");
   request.setCharacterEncoding("UTF-8"); 
%>
<html>
<head>
<title>DesInventar on-line : Region Update</title>
</head>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
 
<%@ taglib uri="/inventag.tld" prefix="inv" %>
<%@ include file="/util/opendefaultdatabase.jspf" %>
<%=Region.lastError%>

<%
boolean bCachePage=true;
if (request.getParameter("action")!=null)
   if (request.getParameter("action").equals("0"))
       bCachePage=false;
if (!bCachePage)
	{
	response.setHeader("Pragma", "no-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
	}
/******************************************************************
*  Process the Edit/ADD request.
******************************************************************/
String sErrorMessage="";
String sSql="";
String scountryid=Region.not_null(request.getParameter("scountryid")).toLowerCase();
String[] asWizards= {
	"/inv/JDBCConnectionWizard.jsp",
	"/inv/ConnectionWizard.jsp",
	"/inv/JDBCConnectionWizard.jsp",
	"/inv/JDBCConnectionWizard.jsp",
	"/inv/ConnectionWizard.jsp",
	"/inv/JDBCConnectionWizard.jsp",
	"/inv/JDBCConnectionWizard.jsp",
	"/inv/JDBCConnectionWizard.jsp",
	"/inv/JDBCConnectionWizard.jsp",
	""};

if (request.getParameter("cancelRegion")!=null)
{
  dbCon.close();
  %><jsp:forward page='/inv/regionManager.jsp'/><%
}
if (request.getParameter("saveRegion")!=null)
  { 
  if (request.getParameter("action").equals("0"))
	{
	try
		{
		// checks if there is a user with that username
		Statement stmt = con.createStatement ();
		sSql = "select scountryid from country where scountryid='" + scountryid + "'";
		ResultSet rset = stmt.executeQuery(sSql);
		if (rset.next())
			{
			sErrorMessage=countrybean.getTranslation("SORRY")+": "+countrybean.getTranslation("Code")+" "+scountryid+" "+countrybean.getTranslation("alreadyexists.Pleasechooseanothercode");
			}
		else
		  {
		  Region.getForm(request,response,con);
		  Region.scountryid=Region.scountryid.toLowerCase();
		  Region.addWebObject(con);
		  out.println("<!--   PROCESS: -->"+Region.lastError);
		  // releases the resultset
		  rset.close();
		  // releases the statement
		  stmt.close();
		  dbCon.close();
		  // It is done in the bean, so it can be reused as properties...
		  countrybean.country.scountryid=Region.scountryid.toLowerCase();
		  countrybean.country.getWebObject(con);
		  countrybean.countrycode=countrybean.country.scountryid;
	      countrybean.countryname=countrybean.country.scountryname;
		  countrybean.dbType=countrybean.country.ndbtype;
 		  %><jsp:forward page="<%=asWizards[Region.ndbtype]%>"/><%
		  }
		}
	catch (Exception ex)
		{ //Trap SQL errors
	    out.println( "<!--Error processing Region creation: " + ex.toString() + "-->");
		}
      }
  else
	  {  
		Region.getForm(request,response,con);
	  	Region.updateWebObject(con);
	    countrybean.country.scountryid=Region.scountryid.toLowerCase();
		countrybean.country.getWebObject(con);
		countrybean.countrycode=countrybean.country.scountryid;
	    countrybean.countryname=countrybean.country.scountryname;
	    countrybean.dbType=countrybean.country.ndbtype;
	    out.println("<!-- EDIT PROCESS: -->"+Region.lastError);
		dbCon.close();
		dbConnection.resetPool();
 		%><jsp:forward page='<%=asWizards[Region.ndbtype]%>'/><%
		}
  }
%>


<script language="JavaScript">
<!-- 


asDrivers = new Array	(
	"oracle.jdbc.driver.OracleDriver",						
	"<%=EncodeUtil.jsEncode(Sys.sAccess64Driver)%>",  // "net.ucanaccess.jdbc.UcanaccessDriver",  // "com.inzoom.jdbcado.Driver",                     
	"com.microsoft.sqlserver.jdbc.SQLServerDriver",  
	"com.mysql.jdbc.Driver",
	"sun.jdbc.odbc.JdbcOdbcDriver",
	"org.postgresql.Driver",
	"org.apache.derby.jdbc.EmbeddedDriver",
	"org.sqlite.JDBC",
	"<driver.class>");
	
var sDefault64Ucan="<%=EncodeUtil.jsEncode(Sys.sAccess64DefaultString)%>";
var sDefaultIZMADOString="<%=EncodeUtil.jsEncode(Sys.sDefaultIZMADOString)%>";
var sDefaultODBCtring="<%=EncodeUtil.jsEncode(Sys.sDefaultODBCtring)%>";

var sDefaultString="<%=EncodeUtil.jsEncode(Sys.sDefaultIZMADOString)%>";

// new default for both 32 and 64 bit environments
var sDefaultAccessString=sDefaultString;

	
asConnects=new Array(
	"jdbc:oracle:thin:@localhost:1521:DATABASE",                                
	"<%=EncodeUtil.jsEncode(Sys.sDefaultAccessString)%>",   
	"jdbc:sqlserver://localhost:1433;databaseName=DATABASE;",    
	"jdbc:mysql://localhost:3306/DATABASE",
	"jdbc:odbc:ODBC_CONNECT_STRING",   
	"jdbc:postgresql://localhost/DATABASE",
	"jdbc:derby:DATABASE;create=true",
	"jdbc:sqlite:DATABASE",
	"jdbc:<DRIVER>:DATABASE"
	);

var nOriginalDbType=<%=Region.ndbtype%>;
var sOriginalConnect="<%=EncodeUtil.jsEncode(Region.sdatabasename)%>";
var sOriginalDriver="<%=EncodeUtil.jsEncode(Region.sdriver)%>";


function setDriver()
{
with (document.desinventar)
	{
	sdriver.value=asDrivers[ndbtype.value];	
	// verifies the connection string corresponds to the driver. If not, changes it to a right one - a model
	pos=sdatabasename.value.substring(5).indexOf(":"); //  signature of the driver
	if (sdatabasename.value.substring(0,5+pos)!=asConnects[ndbtype.value].substring(0,5+pos))
		{
		if (nOriginalDbType==ndbtype.value && sOriginalConnect.length>0)
			 {
				 sdatabasename.value=sOriginalConnect;
				 sdriver.value=sOriginalDriver;
			 }
		else	 
			 sdatabasename.value=asConnects[ndbtype.value];
		}
	}
}

function setDefault()
{
	setIzmado();
}



function setUcan()
{
sDefaultAccessString=sDefaultString;
asDrivers[1]="<%=EncodeUtil.jsEncode(Sys.sAccess64Driver)%>";
asDrivers[4]=asDrivers[1];
setODBC();
}

function setIzmado()
{
sDefaultAccessString=sDefaultIZMADOString;
asDrivers[1]="<%=EncodeUtil.jsEncode(Sys.sAccessIzmadoDriver)%>";
asDrivers[4]=asDrivers[1];
setODBC();
}

function setPlainODBC()
{
sDefaultAccessString=sDefaultODBCtring;
asDrivers[1]="<%=EncodeUtil.jsEncode(Sys.sAccessODBCDriver)%>";
asDrivers[4]=asDrivers[1];
setODBC();
}

function setReturnFolder(newFolder)
{
 if (newFolder)
  document.desinventar.sjetfilename.value=newFolder;
 setODBC();
 }

function browse()
{
sPath=document.desinventar.sjetfilename.value;
var newFolder=showDialog("/DesInventar/inv/browsedirfrm.jsp?currentPath="+sPath, 'setReturnFolder');
//var newFolder=showNonModalDialog("/DesInventar/inv/browsedirfrm.jsp?currentPath="+sPath, null);
}

function setODBC()
{
// changes the string 'DATASOURCE' for something more realistic
var sConnector=document.desinventar.sjetfilename.value;
if (sConnector.charAt(sConnector.length-1)!="/")
	sConnector+="/";
while (sConnector.indexOf("/")>0)
	sConnector=sConnector.replace("/","\\");

asConnects[1]=sDefaultAccessString+sConnector;
asConnects[1]+="invent"+document.desinventar.scountryid.value+".mdb;";
asConnects[4]=asConnects[1];

// the case of derby
asConnects[6]="jdbc:derby:"+sConnector;
asConnects[6]+="derbyDB_"+document.desinventar.scountryid.value+";create=true";

// the case of derby
asConnects[7]="jdbc:sqlite:"+sConnector;
asConnects[7]+="\desinventar.db"; //+document.desinventar.scountryid.value;
if (document.desinventar.ndbtype.value==1 || document.desinventar.ndbtype.value==4  || document.desinventar.ndbtype.value==6  || document.desinventar.ndbtype.value==7)
  {
  document.desinventar.sdatabasename.value=asConnects[document.desinventar.ndbtype.value];
  document.desinventar.sdriver.value=asDrivers[document.desinventar.ndbtype.value];  
  }
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

function lengthvalidation(entered, alertbox)
{
with (entered)
	{
    value=trim(value);
	if (value!=null && value!="" && value.length>2000)
		{	
		if (alertbox!="") 
				alert(alertbox);
		return false;
		}
	else 
		return true;
	}
}


var cancelling=false;

function validateRegion()
{
var ok=true;
if (!cancelling)
	{
	ok= emptyvalidation(document.desinventar.scountryid,'<%=countrybean.getTranslation("CountryIdMandatory")%>!..');
	if (ok)
		ok= emptyvalidation(document.desinventar.scountryname,'<%=countrybean.getTranslation("CountryNameMandatory")%>!..');
	if (ok)
		ok= emptyvalidation(document.desinventar.sjetfilename,'<%=countrybean.getTranslation("CountryFolderMandatory")%>!..');
	if (ok)
		ok= emptyvalidation(document.desinventar.sdriver,'<%=countrybean.getTranslation("CountryDriverMandatory")%>!..');
	if (ok)
		ok= emptyvalidation(document.desinventar.sdatabasename,'<%=countrybean.getTranslation("CountryConnectMandatory")%>!..');
	if (ok)
		ok= lengthvalidation(document.desinventar.sdescriptionen,'<%=countrybean.getTranslation("Maximum_2000_chars")%>!..');
	if (ok)
		ok= lengthvalidation(document.desinventar.sdescriptiones,'<%=countrybean.getTranslation("Maximum_2000_chars")%>!..');
	}
return ok;
}

function setCancel()
{
cancelling=true;
}
// -->
</script>

<%@ include file="/util/showDialog.jspf" %> 

<table width="100%" cellspacing="2" cellpadding="2" border=0 align=>
<form method="post" action="regionsUpdate.jsp" name="desinventar" onSubmit="return validateRegion();">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<TR><TD align="center"><span class="warning"><%=sErrorMessage%></span></TD></TR>
<tr>
 <td align="left">
	<span class="title">
	<%=countrybean.getTranslation("RegionBasicInformation")%>:</span><br><br>	
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr><td class=bgLight><%=countrybean.getTranslation("RegionCode")%>:</td><td>  
	<INPUT type='hidden' name='action' VALUE='<%=request.getParameter("action")%>'>
<%if (request.getParameter("action").equals("0"))
	{%>
	<INPUT type='TEXT' size='5' maxlength='5' name='scountryid' VALUE="">
<%  }
  else
    {%>
	<strong><%=htmlServer.htmlEncode(Region.scountryid)%></strong>
	<INPUT type='hidden' size='5' maxlength='5' name='scountryid' VALUE="<%=htmlServer.htmlEncode(Region.scountryid)%>">
<%  }%>
	</td></tr>
	<tr><td class=bgLight><%=countrybean.getTranslation("RegionName")%>:</td><td>  <INPUT type='TEXT' size='50' maxlength='50' name='scountryname' VALUE="<%=htmlServer.htmlEncode(Region.scountryname)%>"></td></tr>
	<tr><td class=bgLight><%=countrybean.getTranslation("DirectoryWithMapfiles")%>:</td><td>  <INPUT type='TEXT' size='100' maxlength='250' name='sjetfilename' onChange="setODBC()" VALUE="<%=htmlServer.htmlEncode(Region.sjetfilename)%>"> 
						<INPUT type='button' name='browsebtn'  VALUE="<%=countrybean.getTranslation("Browse")%>" onClick="browse()"><span class="warning"><strong>****</strong></span></td></tr>
	<tr><td class=bgLight><%=countrybean.getTranslation("AVAILABLEtoPUBLIC")%>?:</td><td>  
		<select name='bpublic'>
	    <option value='1'<%=Region.strSelected(Region.bpublic,1)%>><%=countrybean.getTranslation("yesAvailable")%>
	    <option value='0'<%=Region.strSelected(Region.bpublic,0)%>><%=countrybean.getTranslation("notAvailable")%>
		</select>
	<tr><td class=bgLight><%=countrybean.getTranslation("DatabaseType")%>:</td><td nowrap>  
		<select name ='ndbtype' onChange="setDriver()">
	    <option value='0'<%=Region.strSelected(Region.ndbtype,0)%>><%=countrybean.getTranslation("Oracle")%>
    	<option value='1'<%=Region.strSelected(Region.ndbtype,1)%>><%=countrybean.getTranslation("ODBCnoAuthentication")%>;
  		<option value='2'<%=Region.strSelected(Region.ndbtype,2)%>><%=countrybean.getTranslation("MicrosoftSQLServer")%>
  		<option value='3'<%=Region.strSelected(Region.ndbtype,3)%>><%=countrybean.getTranslation("MySQL")%>
  		<option value='4'<%=Region.strSelected(Region.ndbtype,4)%>><%=countrybean.getTranslation("ODBCGeneric")%>
  		<option value='5'<%=Region.strSelected(Region.ndbtype,5)%>><%=countrybean.getTranslation("PostgreSQL")%>
 		<option value='6'<%=Region.strSelected(Region.ndbtype,6)%>><%=countrybean.getTranslation("Derby")%>
 		<!-- NOT YET!!: 
        <option value='7'<%=Region.strSelected(Region.ndbtype,7)%>><%=countrybean.getTranslation("SQLite")%> 
        -->
	    </select>
		
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<span class='bss'>
	<%=countrybean.getTranslation("For MS ACCESS")%>:
	<input type="Radio" name='drvtype' value='0' onClick="setUcan()" <%=countrybean.strChecked(Region.sdriver.equals(Sys.sAccess64Driver))%>><%=countrybean.getTranslation("64 bit, UTF-8 driver")%>  
	<input type="Radio" name='drvtype' value='1' onClick="setIzmado()" <%=countrybean.strChecked(Region.sdriver.equals(Sys.sAccessIzmadoDriver))%>><%=countrybean.getTranslation("32-bit UTF-8 driver")%>  
	<input type="Radio" name='drvtype' value='2' onClick="setPlainODBC()"<%=countrybean.strChecked(Region.sdriver.equals(Sys.sAccessODBCDriver))%>><%=countrybean.getTranslation("ODBC plain driver")%>  
    </span>
	
    </td></tr>
	
	<tr><td class=bgLight><%=countrybean.getTranslation("sDbDriverName")%>:</td><td>  <INPUT type='TEXT' size='50' maxlength='100' name='sdriver' VALUE="<%=htmlServer.htmlEncode(Region.sdriver)%>"></td></tr>
	<tr><td class=bgLight><%=countrybean.getTranslation("sDataBaseName")%>:</td><td>  <INPUT type='TEXT' size='120' maxlength='250' name='sdatabasename' VALUE="<%=htmlServer.htmlEncode(Region.sdatabasename)%>"></td></tr>
	<tr><td class=bgLight><%=countrybean.getTranslation("sDbUserName")%>:</td><td>  <INPUT type='TEXT' size='30' maxlength='30' name='susername' VALUE="<%=htmlServer.htmlEncode(Region.susername)%>"></td></tr>
	<tr><td class=bgLight><%=countrybean.getTranslation("sDbPassword")%>:</td><td>  <INPUT type='password' size='30' maxlength='30' name='spassword' VALUE="<%=htmlServer.htmlEncode(Region.spassword)%>"></td></tr>
	<tr><td height="4"></td><td height="4"></td></tr>
	<tr><td class=bgLight><%=countrybean.getTranslation("Institution")%>:</td><td>  <INPUT type='TEXT' size='50' maxlength='50' name='sinstitution' VALUE="<%=htmlServer.htmlEncode(Region.sinstitution)%>"></td></tr>
	<tr><td class=bgLight><%=countrybean.getTranslation("Periodcovered")%>:</td><td>  <INPUT type='TEXT' size='50' maxlength='50' name='speriod' VALUE="<%=htmlServer.htmlEncode(Region.speriod)%>"></td></tr>
	<tr><td class=bgLight><%=countrybean.getTranslation("LastUpdatedYYYY-MM-DD")%>:</td><td>  <INPUT type='TEXT' size='20' maxlength='20' name='slastupdated' VALUE="<%=htmlServer.htmlEncode(Region.slastupdated)%>"></td></tr>
	<tr><td class=bgLight><%=countrybean.getTranslation("Description")%> (<%=countrybean.getTranslation("English")%>):</td><td><textarea cols='80' rows="4" maxlength='2000' name='sdescriptionen'><%=htmlServer.htmlEncode(Region.sdescriptionen)%></textarea></td></tr>
	<tr><td class=bgLight><%=countrybean.getTranslation("Description")%> (<%=countrybean.getTranslation("Spanish")%>):</td><td><textarea cols='80' rows="4" maxlength='2000' name='sdescriptiones'><%=htmlServer.htmlEncode(Region.sdescriptiones)%></textarea></td></tr>
	<tr><td class=bgLight><%=countrybean.getTranslation("Webpage")%>  (<%=countrybean.getTranslation("English")%>):</td><td>  <INPUT type='TEXT' size='80' maxlength='250' name='spageen' VALUE="<%=htmlServer.htmlEncode(Region.spageen)%>"></td></tr>
	<tr><td class=bgLight><%=countrybean.getTranslation("Webpage")%> (<%=countrybean.getTranslation("Spanish")%>):</td><td>  <INPUT type='TEXT' size='80' maxlength='250' name='spagees' VALUE="<%=htmlServer.htmlEncode(Region.spagees)%>"></td></tr>
	<tr><td class=bgLight>&nbsp;</td><td></td></tr>
	<TR>
	<TD></TD>
	<TD>
	<input name="saveRegion" type=submit value='<%=countrybean.getTranslation("Save")%> <%=countrybean.getTranslation("Region")%>'> &nbsp; &nbsp; &nbsp; &nbsp;
	<input name="cancelRegion" type=submit value='<%=countrybean.getTranslation("Cancel")%>' onClick="setCancel()">
	</TD>
	</Tr>
	</table>
 </td>
</tr>
</form>
</table>
<br>
<% 	// close the database object 
dbCon.close();
%>
</body>
</html>