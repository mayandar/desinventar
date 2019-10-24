<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>DesInventar on-line - EMDAT matching assistant</title>
</head>
<%@ page import = "org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import = "java.sql.*" %>
<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id = "Dictionary" class="org.lared.desinventar.webobject.diccionario" scope="session" />

<%@ taglib uri="inventag.tld" prefix="inv" %>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%@ include file="/util/opendatabase.jspf" %>
<%
/******************************************************************
*  Process the request.
******************************************************************/
String sErrorMessage="";
int emdatSelected=webObject.extendedParseInt(request.getParameter("emdat"));
// loads the selected emdat
fichas emdatMain=new fichas();
fichas emdat=new fichas();
fichas desinv=new fichas();
stmt=con.createStatement();
if (emdatSelected>0)
  	{
        rset=stmt.executeQuery("select * from emdat where clave="+emdatSelected);
		if (rset.next())
			emdatMain.loadWebObject(rset);	
 	}
if (request.getParameter("saveField")!=null && emdatSelected>0)
    if (request.getParameterValues("desinventar") != null)
    {
	  String[] asArray = request.getParameterValues("desinventar");
	  for (int j=0; j<asArray.length; j++)
	  	{
			desinv.clave=webObject.extendedParseInt(asArray[j]);
			desinv.getWebObject(con);
			desinv.glide=emdatMain.serial;
			desinv.updateWebObject(con);
		}
	}
String sMortality=webObject.not_null(request.getParameter("matchfield"));
boolean bMortality="M".equals(request.getParameter("matchfield"));
%>

<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
 

<script language="JavaScript">
<!--

function submitForm() 
{
  document.desinventar.submit()
}

function resetForm() 
{
  document.desinventar.reset()
  document.desinventar.questions.focus()
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

return ok;
}

// -->
</script>



<table cellspacing="0" cellpadding="2" border="0" width="100%">
<tr>
<td>
<table cellspacing="0" cellpadding="5" border="1" width="100%" rules="none">
<form name="desinventar" action="emdatMatcher.jsp" method="post" onSubmit="return validateFields()">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<tr>
    <td class='bgDark' height="25"><span class="titleText"><%=countrybean.getTranslation(" EMDAT matching assistant")%></span></td>
	<td><input type="radio" name="matchfield" <%=webObject.strChecked(sMortality,"E")%> value="E" onChange="submit()">Economic losses &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <input type="radio" name="matchfield" <%=webObject.strChecked(sMortality,"M")%> value="M" onChange="submit()">Mortality losses
    <td/>
</tr>
<TR>
<TD colspan=2 align="center"><span class="warning"><%=sErrorMessage%></span></TD>
</TR>
<tr>
  <td> <%=countrybean.getTranslation("EMDAT records")%></td>
  <td> <%=countrybean.getTranslation("GAR Universe records ")%></td>
</tr>
<tr>
  <td><select size="50" name='emdat' id='emdat' onChange="submit()" style="font-family:'Courier New', Courier, monospace; width:550px">
  <%
  rset=stmt.executeQuery("select * from emdat where hasmatch"+(bMortality?"_m":"")+"=1 order by "+(bMortality?"muertos":"valorus")+"  desc");
  while (rset.next())
  	{
	emdat.loadWebObject(rset);	
    out.println("<option value='"+emdat.clave+"'"+webObject.strSelected(emdatSelected,emdat.clave)+">"+
				emdat.serial+" "+
				emdat.level0+" "+
				webObject.strDate(emdat.fechano,emdat.fechames,emdat.fechadia)+" "+
				emdat.name0+"&nbsp;&nbsp;&nbsp;"+
				emdat.evento+"&nbsp;&nbsp;&nbsp;"+
				webObject.formatDouble(emdat.muertos,0)+"&nbsp;&nbsp;&nbsp;"+
				webObject.formatDouble(emdat.valorus,0)+	
				"</option>"
	            );		
	}
  %>
      </select></td>
  <td><select size="50" name='desinventar' id='desinventar' multiple style="font-family:'Courier New', Courier, monospace; width:550px">
  <%
  String sQuery="select * from fichas where level0='"+emdatMain.level0+"' and fechano between "+(emdatMain.fechano-1)+" and "+(emdatMain.fechano+1)+" order by level0, fechano,fechames,fechadia";
  rset=stmt.executeQuery(sQuery);
  while (rset.next())
  	{
	desinv.loadWebObject(rset);	
    out.println("<option value='"+desinv.clave+"'>"+
				desinv.level0+"  "+
				webObject.strDate(desinv.fechano,desinv.fechames,desinv.fechadia)+" "+
				desinv.evento+"&nbsp;&nbsp;&nbsp;"+
				// desinv.name0+"&nbsp;&nbsp;&nbsp;"+
				desinv.name1+"&nbsp;&nbsp;&nbsp;"+
				desinv.name0+"&nbsp;&nbsp;&nbsp;"+
				webObject.formatDouble(desinv.muertos,0)+"&nbsp;&nbsp;&nbsp;"+
				webObject.formatDouble(desinv.valorus,0)+"&nbsp;&nbsp;&nbsp;"+	
				desinv.glide+
				
				"</option>"
	            );		
	}
  rset.close();
  stmt.close();
  dbCon.close();
  %>
<!--<%=sQuery%>  -->
  </select></td>
</tr>
<TR>
    <td colspan=3 align="center">
	<input name="saveField" type=submit value='<%=countrybean.getTranslation("Match records")%>'> 
	</TD>
</Tr>
</form>
</table>
</td>
</tr>
</table>


</BODY>
</html>












