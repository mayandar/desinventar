<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<title>DesInventar on-line - Define Geography Levels</title>
</head>
<%@ page import = "org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import = "java.sql.*" %>
<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />

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
/******************************************************************
*  Process the Register request.
******************************************************************/
if (request.getParameter("cancelLevel")!=null)
{
  dbCon.close();
  %><jsp:forward page='/inv/lev0Manager.jsp'/><%
}
String sSql="";
String sErrorMessage="";
if (request.getParameter("saveLevel")!=null)
  { 
	PreparedStatement pstmt=null;
	try
		{
		String sLevelid="";
		String sLevelid_en="";
		int nCodeLen=0;
		// the bean generator doesn't support changes in the primary key. must be done manually
		pstmt=con.prepareStatement("delete from niveles");
		pstmt.executeUpdate();
		for (int nLevel=0; nLevel<3; nLevel++)
			{
			sLevelid=htmlServer.not_null(request.getParameter("descripcion_"+nLevel)).trim();
			sLevelid_en=htmlServer.not_null(request.getParameter("descripcion_en_"+nLevel)).trim();
			nCodeLen=htmlServer.extendedParseInt(request.getParameter("longitud_"+nLevel));
			pstmt=con.prepareStatement("insert into niveles (descripcion, descripcion_en, longitud, nivel) values (?,?,?,?)");
			pstmt.setString(1,sLevelid);
			pstmt.setString(2,sLevelid_en);
			pstmt.setInt(3,nCodeLen);
			pstmt.setInt(4,nLevel+1);
			pstmt.executeUpdate();	
			}
		pstmt.close();
		countrybean.getLevelsFromDB(con);
		dbCon.close();
		%><jsp:forward page='/inv/lev0Manager.jsp'/><%
		}
	catch (Exception e)
		{
		sErrorMessage="SORRY: Levels could not be updated.<!--"+e.toString()+" -->";
		}	
  }
%>

<script language="JavaScript">
<!--
function giveFocus() 
{
  document.desinventar.descripcion_0.focus()
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


// -->
</script>



<form name="desinventar" action="levelManager.jsp" method="post">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<table cellspacing="0" cellpadding="2" border="0" width="650">
<tr>
<td>

<table cellspacing="0" cellpadding="5" border="0" width="750" rules="none">
<tr>
    <td class='bgDark' height="25" td colspan="3"><span class="title"><%=countrybean.getTranslation("GeographicLevelDefinition")%></span></td>
	</td>
</tr>
<tr><td colspan="3" height="5"></td></tr>
<TR>
<TD colspan=2 align="center"><span class="warning"><%=sErrorMessage%></span></TD>
</TR>
<% 
stmt = con.createStatement ();
rset = stmt.executeQuery("Select descripcion,descripcion_en, longitud from niveles order by nivel");
int nLevel=0;
String sDesc="";
String sDesc_en="";
int nLong=2;
while (nLevel < 3)
 {
 nLong=2*nLevel+2;
 if (rset.next())
 	{
 	sDesc=htmlServer.not_null(rset.getString("descripcion")).trim();
 	sDesc_en=htmlServer.not_null(rset.getString("descripcion_en")).trim();
	nLong=rset.getInt("longitud");
	}
%>
 <INPUT type='hidden' size='15' maxlength='21' name='nivel_<%=nLevel%>' VALUE="<%=nLevel%>">
 
 <TR><td class=bgLight align='right' nowrap><%=countrybean.getTranslation("Level")%> <%=nLevel%>.&nbsp;&nbsp;&nbsp;  <%=countrybean.getTranslation("Name")%>:</td>
     <td><INPUT type='TEXT' size='30' maxlength='25' name='descripcion_<%=nLevel%>' VALUE="<%=htmlServer.htmlEncode(sDesc)%>"></td>
     <td>English:<INPUT type='TEXT' size='30' maxlength='25' name='descripcion_en_<%=nLevel%>' VALUE="<%=htmlServer.htmlEncode(sDesc_en)%>"></td>
    <td align='left' nowrap><%=countrybean.getTranslation("Codelength")%>:<INPUT type='TEXT' size='5' maxlength='5' name='longitud_<%=nLevel%>' VALUE="<%=nLong%>"></td>
 </tr>
<%nLevel++;
  }
rset.close();
stmt.close();
%>
	<TR>
	<TD colspan=3 height="20"></TD>
	</TR>
	<TR>
	<TD  valign="bottom"  align=right>
	</TD>
	<TD valign="bottom">
	<input name="saveLevel" type=submit value='<%=countrybean.getTranslation("Save")%>'> &nbsp; &nbsp; &nbsp; &nbsp;
	<input name="cancelLevel" type=submit value='<%=countrybean.getTranslation("Cancel")%>'>
	</TD>
	</Tr>

	<TR>
	<TD colspan=3 height="10"></TD>
	</TR>
	<TR>
</table>
</td>
</tr>
</table>
</form>
<script language="JavaScript">
<!-- 
giveFocus();
// -->
</script>
</BODY>
</html>
<%dbCon.close();%>












