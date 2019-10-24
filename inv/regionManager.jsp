<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<title>DesInventar on-line : Region Administration</title>
</head>
 <%@ page info="DesInventar On-Line" session="true" %> 
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.*" %> 
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<%@ taglib uri="inventag.tld" prefix="inv" %>
<%
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
%>
<%@ include file="checkUserIsLoggedIn.jsp" %>
<%if (user.iusertype<40) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}%>
<%@ include file="/util/opendefaultdatabase.jspf" %>
<jsp:useBean id = "Region" class="org.lared.desinventar.webobject.country" scope="session" />
<% 
int nSqlResult =0;
String sErrorMessage="";
if (request.getParameter("addRegion")!=null)
   {
    Region.init();
	Region.ndbtype=6;
	Region.sdriver="org.apache.derby.jdbc.EmbeddedDriver";
	Region.sdatabasename="jdbc:derby:DATABASE;create=true";
	Region.bpublic=1; // public by default!!!
	dbCon.close();
	%><jsp:forward page="regionsUpdate.jsp?action=0"/><%
   }
else if (request.getParameter("editRegion")!=null)
   {
    Region.init();
	Region.scountryid=Region.not_null(request.getParameter("scountryid"));
	Region.getWebObject(con);
	dbCon.close();
	%><jsp:forward page="regionsUpdate.jsp?action=1"/><%
   }
else if (request.getParameter("delRegion")!=null)
   {
    // until final deletion code (plus user=permissions)
	Region.scountryid=Region.not_null(request.getParameter("scountryid"));
	Region.getWebObject(con);
	Region.bpublic=0;
	Region.updateWebObject(con);
	if (Region.getReferenceCount("country", Region.scountryid, "user_permissions", con)==0)
		{
		Region.deleteWebObject(con);
		countrybean.country.scountryid="";
	    countrybean.countrycode="";
	    countrybean.countryname="";
		dbCon.close();
		// to avoid old connections to be reused.
		dbConnection.resetPool();
		// opens the database 
		dbCon=new dbConnection();
		bConnectionOK = dbCon.dbGetConnectionStatus();
		if (bConnectionOK)
			con=dbCon.dbGetConnection();
		}
	else
		sErrorMessage=countrybean.getTranslation("CannotBeDeletedNote");
   }
%>
<script type="text/javascript" src="/DesInventar/html/iheader.js"></script> 
<script language="JavaScript">
<!--
function bSomethingSelected()
{
if (document.desinventar.scountryid.selectedIndex==-1)
	{
	alert ("<%=countrybean.getTranslation("Pleaseselecta")%> <%=countrybean.getTranslation("Region")%> <%=countrybean.getTranslation("fromthelist")%>...");
	return false;
	} 
return true;
}

function confirmDelete()
{
if (bSomethingSelected())
	{
	return confirm ("<%=countrybean.getTranslation("Areyousureyouwanttodeletethis")%> <%=countrybean.getTranslation("Region")%> ?");
	} 
else 
  return false;
}

// -->
</script>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
 
<table width="850" cellspacing="2" cellpadding="2" border=0>
<form method="post" action="regionManager.jsp" name="desinventar"  id="desinventar">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<tr>
 <td align="center">
	<table border="0" bordercolor="gray" cellpadding="0" cellspacing="0" width=450 rules="none">
	<tr>
	    <td height="25" class='bgDark' align="center"><span class="title"><%=countrybean.getTranslation("DesInventarRegionManager")%></span></td>
	</tr>
	<tr><td height="5"></td></tr>
	<tr><td height="5"></td></tr>
	<TR><TD align="center"><span class="warning"><%=sErrorMessage%></span></TD></TR>
	<tr><td height="5"></td></tr>
	<tr><td align="center"><span class="titleTextWhite"><%=countrybean.getTranslation("AvailableRegions")%>:</span></td>
	<tr><td align="center">
	<% 
	String sWhere="";
	%>
	<SELECT name="scountryid" style="WIDTH: 450px; HEIGHT: 166px" size=10>
	<inv:select tablename='country' selected='<%=Region.scountryid%>' connection='<%= con %>'
    fieldname="sCountryName" codename='scountryid' ordername='sCountryName'/>
    </SELECT>
	</td></tr>
	<tr><td height="25"></td></tr>
	<tr><td align="center">
	<input type="submit" name="addRegion" value="<%=countrybean.getTranslation("Add")%> <%=countrybean.getTranslation("Region")%>">
	<input type="submit" name="editRegion" value="<%=countrybean.getTranslation("Edit")%> <%=countrybean.getTranslation("Region")%>" onClick="return bSomethingSelected()">
	<input type="submit" name="delRegion" value="<%=countrybean.getTranslation("Delete")%> <%=countrybean.getTranslation("Region")%>" onClick="return confirmDelete()"><br>
    <br>
	<input name="doneRegions" type='button' onclick='postTo("adminManager.jsp")' value='<%=countrybean.getTranslation("Done")%>'>
	</td></tr>
	</table>
 </td>
</tr>
<tr><td><br></td></tr>
<tr><td>


		<table width="450" cellspacing="1" cellpadding="2" border="1" rules="none">
		<tr>
		    <th></th>
			<th colspan="4"><strong>Summary of your database configuration:</strong><br><br></th>
		</tr>
		<tr>
		    <th align="left"></th>
			<th nowrap><strong><%=countrybean.getTranslation("Code")%></strong>&nbsp;</td>
			<th nowrap><strong><%=countrybean.getTranslation("Region")%></strong>&nbsp;</td>
			<th nowrap><%=countrybean.getTranslation("DatabaseType")%>&nbsp;</td>
			<th nowrap><%=countrybean.getTranslation("sDbDriverName")%>&nbsp;</td>
			<th nowrap><%=countrybean.getTranslation("DirectoryWithMapfiles")%>&nbsp;</td>
		</tr>
		<%
		Statement stmt=con.createStatement();
		ResultSet rset=stmt.executeQuery("SELECT * FROM Country order by scountryname");
		String sSetDescriptors="";
		String sCountryId="";
		String sCountryName="";
		country cCountry=new country();
		boolean bLight=false;
		String sBgClass="";
		int index=0;
		while (rset.next())
		 {
		 // same order as in query...
		 cCountry.loadWebObject(rset);
		 sCountryId=cCountry.scountryid;
		 sCountryName=cCountry.scountryname;
		 // debug: System.out.println("country:" + sCountryId+"-"+sCountryName);
		 if (bLight)
			  sBgClass=" class='bodymedlight'";
		    else
			  sBgClass=" class='bodylight'";
		    bLight=!bLight;
		   %><tr<%=sBgClass%>>
		    <td width=30>&nbsp;</td>
			<td nowrap><strong><%=sCountryId%></strong>&nbsp;</td>
			<td nowrap><strong><%=sCountryName%></strong>&nbsp;</td>
			<td nowrap><%=Sys.strDatabaseType[cCountry.ndbtype]%>&nbsp;</td>
			<td nowrap><%=cCountry.sdriver%>&nbsp;</td>
			<td nowrap><%=cCountry.sjetfilename%>&nbsp;</td>
			</tr><%
		 }
		%>
		</table>



</td></tr></table>
</form>
<br> 
<br>
<% 	// close the database object 
dbCon.close();
%>
</body>
</html>

