<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<title>DesInventar on-line - Define Geography Attributes per Level</title>
</head>
<%@ page import = "org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.HashMap" %>
<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />

<%@ taglib uri="inventag.tld" prefix="inv" %>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
if (user.iusertype<20) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}%>

<%@ include file="/util/opendatabase.jspf" %>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
 
 
<% 

HashMap hDesInventarTables=new HashMap();

hDesInventarTables.put("attribute_metadata","attribute_metadata");
hDesInventarTables.put("causas","causas");
hDesInventarTables.put("datamodel","datamodel");
hDesInventarTables.put("diccionario","diccionario");
hDesInventarTables.put("event_grouping","event_grouping");
hDesInventarTables.put("eventos","eventos");
hDesInventarTables.put("extension","extension");
hDesInventarTables.put("extensioncodes","extensioncodes");
hDesInventarTables.put("extensiontabs","extensiontabs");
hDesInventarTables.put("fichas","fichas");
hDesInventarTables.put("fichas_seq","fichas_seq");
hDesInventarTables.put("info_maps","info_maps");
hDesInventarTables.put("lec_cpi","LEC_cpi");
hDesInventarTables.put("lec_exchange","LEC_exchange");
// hDesInventarTables.put("lev0","lev0");  allow here stats
// hDesInventarTables.put("lev1","lev1");   allow here stats
// hDesInventarTables.put("lev2","lev2");   allow here stats
hDesInventarTables.put("level_attributes","level_attributes");
hDesInventarTables.put("level_maps","level_maps");
hDesInventarTables.put("niveles","niveles");
// hDesInventarTables.put("regiones","regiones");  allow here stats
hDesInventarTables.put("words","words");
hDesInventarTables.put("words_seq","words_seq");
hDesInventarTables.put("wordsdocs","wordsdocs");



/******************************************************************
*  Process the Register request.
******************************************************************/
if (request.getParameter("cancelAttrib")!=null)
{
  dbCon.close();
  %><jsp:forward page='/inv/lev0Manager.jsp'/><%
}
String sSql="";
String sErrorMessage="";
int nLevel=0;
String[] sTable={"","",""};
String[] sCode={"","",""};
if (request.getParameter("saveAttrib")!=null)
  { 
	PreparedStatement pstmt=null;
	try
		{
		// the bean generator doesn't support changes in the primary key. must be done manually
		pstmt=con.prepareStatement("delete from level_attributes");
		pstmt.executeUpdate();
		for (nLevel=0; nLevel<3; nLevel++)
			{
			nLevel=htmlServer.extendedParseInt(request.getParameter("level_"+nLevel));
			sTable[nLevel]=htmlServer.not_null(request.getParameter("table_"+nLevel));
			sCode[nLevel]=htmlServer.not_null(request.getParameter("code_"+nLevel));
			pstmt=con.prepareStatement("insert into level_attributes (table_level,table_name,table_code) values (?,?,?)");
			pstmt.setInt(1,nLevel);
			pstmt.setString(2,sTable[nLevel]);
			pstmt.setString(3,sCode[nLevel]);
			pstmt.executeUpdate();	
			}
		pstmt.close();
		countrybean.getLevelsFromDB(con);
		//dbCon.close();
		%><jsp:forward page='/inv/lev0Manager.jsp'/><%
		}
	catch (Exception e)
		{
		sErrorMessage="SORRY: Levels could not be updated.<!--"+e.toString()+" -->";
		}	
  }
  
DatabaseMetaData dbMeta=null;
try {
	// gets the metadata of the database
	dbMeta = con.getMetaData();
	out.println("<!-- OK !! GETTING DB Metadata compatible -->");
	}
catch (Exception me)
	{
	out.println("<!-- ERROR GETTING DB Metadata - not compatible -->");
	}

%>

<script language="JavaScript">
<!--
function giveFocus() 
{
  document.desinventar.table_0.focus()
}

function submitForm() 
{
  document.desinventar.submit()
}

function resetForm() 
{
  document.desinventar.reset()
  document.desinventar.table_0.focus()
}


var currField;
function processFieldRequest(newField)
{
if (newField)
	document.getElementById(currField).value=newField;
}


function setField(fieldName,k)
{
currField=fieldName;
if (document.getElementById("table_"+k).value.length>0)
	showDialogSz("/DesInventar/util/jdbcFieldServer.jsp?selected="+document.getElementById(fieldName).value+"&filename="+document.getElementById("table_"+k).value, 'processFieldRequest',null, 500, 800, "yes")
else
	alert('<%=countrybean.getTranslation("Missing Attribute table")%>');	
}

// -->
</script>
<%@ include file="/util/showDialog.jspf" %> 




<table cellspacing="0" cellpadding="2" border="0" width="850">
<form name="desinventar" action="levelAttributeManager.jsp" method="post">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<tr>
<td>

<table cellspacing="0" cellpadding="5" border="0" width="850" rules="none">
<tr>
    <td class='bgDark' height="25" td colspan="3"><span class="title"><%=countrybean.getTranslation("Attribute_Definition")%></span></td>
	</td>
</tr>
<tr><td colspan="3" height="5"></td></tr>
<TR>
<TD colspan=2 align="center"><span class="warning"><%=sErrorMessage%></span></TD>
</TR>
<% 
stmt = con.createStatement ();
// we assume all levels are always there, or none
rset = stmt.executeQuery("Select table_level,table_name,table_code from level_attributes order by table_level");
nLevel=0;
while (nLevel < 3)
 {
 if (rset.next())
 	{
	nLevel=rset.getInt("table_level");
 	sTable[nLevel]=htmlServer.not_null(rset.getString("table_name")).trim();
 	sCode[nLevel]=htmlServer.not_null(rset.getString("table_code")).trim();
	}
  nLevel++;
  }
rset.close();
stmt.close();
  
for (nLevel=0; nLevel<3; nLevel++)
{  
%>
 <INPUT type='hidden' size='15' maxlength='21' name='level_<%=nLevel%>' VALUE="<%=nLevel%>">
 
 <TR><td class=bgLight align='right' nowrap><%=countrybean.getTranslation("Level")%> <%=nLevel%>.&nbsp;&nbsp;&nbsp;  <%=countrybean.getTranslation("Table_Name")%> </td>
     <td>
<% if (dbMeta==null)
	{%>
	 <INPUT type='TEXT' size='30' maxlength='30' name='table_<%=nLevel%>' VALUE="<%=sTable[nLevel]%>">
<%  }
else
	{
%>	 <select name='table_<%=nLevel%>'>
	<option value=''></option>
<%    
      //Database Connection Objects
      String[] tableTypes = {"TABLE"};
      // gets the tables set
      ResultSet rsetmeta = dbMeta.getTables(null, null, null, tableTypes);
      while (rsetmeta.next())
      {
	    String sTablename=rsetmeta.getString("TABLE_NAME");
		if (hDesInventarTables.get(sTablename.toLowerCase())==null)
        	out.println("<option value='" + sTablename + "'"+ countrybean.strSelected(sTable[nLevel].toLowerCase(),sTablename.toLowerCase())+">" + sTablename+ "</option>");
      }
}
%>
	 </td>
     <td><%=countrybean.getTranslation("Code_Field")%> <INPUT type='TEXT' size='30' maxlength='30' name='code_<%=nLevel%>' VALUE="<%=sCode[nLevel]%>"></td>
	 <td><input type='button' name='buttCodeField' onclick="setField('code_<%=nLevel%>',<%=nLevel%>);" value="..."></td>
 </tr>
<%
  }
%>
	<TR>
	<TD colspan=3 height="20"></TD>
	</TR>
	<TR>
	<TD  valign="bottom"  align=right>
	</TD>
	<TD valign="bottom">
	<input name="saveAttrib" type=submit value='<%=countrybean.getTranslation("Save")%>'> &nbsp; &nbsp; &nbsp; &nbsp;
	<input name="cancelAttrib" type=submit value='<%=countrybean.getTranslation("Cancel")%>'>
	</TD>
	</Tr>

	<TR>
	<TD colspan=3 height="10"></TD>
	</TR>
	<TR>
</form>
</table>
</td>
</tr>
</table>
<script language="JavaScript">
<!-- 
giveFocus();
// -->
</script>
</BODY>
</html>
<%dbCon.close();%>












