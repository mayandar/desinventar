<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<%@ page info="DesInventar On-Line main page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="woFicha" class="org.lared.desinventar.webobject.fichas" scope="session" />
<jsp:useBean id="woExtension" class="org.lared.desinventar.webobject.extension" scope="session" />
<%@ page contentType="text/html; charset=UTF-8" %><%@ page import="org.lared.desinventar.system.*" %><%
request.setCharacterEncoding("UTF-8"); 
// if this runs in an IFRAME under IE, this will allow cookies to stay...just magic!
((HttpServletResponse)response).addHeader("P3P", "CP=\"CAO PSA OUR\"");
((HttpServletResponse)response).addHeader("X-Frame-Options", "SAMEORIGIN");
%>
<%@ include file="checkUserIsLoggedIn.jsp" %>
<%
if (countrybean.countrycode.length()>0 && request.getParameter("usrtkn")!=null && !countrybean.userHash.equals(request.getParameter("usrtkn")))
 	{%><jsp:forward page="noaccess.jsp"/><%}		 
%>
<%-- open the default database to get basic data about the country --%>
<%@ include file="/util/opendefaultdatabase.jspf" %>
<%
if (request.getParameter("actiontab")!=null)
	{
	String sCountrycode=webObject.not_null(request.getParameter("countrycode"));
	if (sCountrycode.length()>0)
		{
		countrybean.init();
		countrybean.countrycode=sCountrycode;
		countrybean.country.scountryid=sCountrycode;
		countrybean.country.getWebObject(con);
		countrybean.countryname=countrybean.country.scountryname;
	    countrybean.dbType=countrybean.country.ndbtype;
	 	// Database exists, checks for version issues:
		ServletContext sc = getServletConfig().getServletContext();
		dbCon.close();
		dbCon=new dbConnection(countrybean.country.sdriver,countrybean.country.sdatabasename,
                      countrybean.country.susername,countrybean.country.spassword);
		bConnectionOK = dbCon.dbGetConnectionStatus();
		if (bConnectionOK)
			{	
			con=dbCon.dbGetConnection();
			}
 		dbCon.close();	
		}
     }
%>
<%@ include file="/util/router.jspf" %>
<title>DesInventar on-line : <%=countrybean.countryname%> Home </title>
</head>

<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/iheader",countrybean.getLanguage(),out);%> 
<%@ taglib uri="/inventag.tld" prefix="inv"%>
<%
int nTabActive=0; // results
String[] sTabNames={countrybean.getTranslation("Region"),countrybean.getTranslation("Geography"),countrybean.getTranslation("Events"),
           countrybean.getTranslation("Causes"),countrybean.getTranslation("Extension"),countrybean.getTranslation("Query"),
           countrybean.getTranslation("EditData"),countrybean.getTranslation("DataEntry"),countrybean.getTranslation("Admin"),
		   countrybean.getTranslation("Sendai"),countrybean.getTranslation("Security")};
String[] sTabIcons={"","","","","","","","","","","",""};
String[] sTabLinks={"javascript:postTo('index.jsp')","javascript:gotoPage('geographytab.jsp')","javascript:gotoPage('eventab.jsp')",
				"javascript:gotoPage('causetab.jsp')","javascript:gotoPage('extendedtab.jsp')","javascript:gotoPage('querytab.jsp')",
				"javascript:gotoPage('resultstab.jsp')","javascript:gotoPage('datacardtab.jsp')","javascript:gotoPageinconditional('admintab.jsp')",
				"javascript:gotoPage('sendaitab.jsp')","javascript:gotoPageinconditional('securitytab.jsp')"};
%>
<%@ include file="/util/tabs.jspf" %>

<table width="1024" border="1" id="contentFrame" class="pageBackground" rules="none"><tr><td valign="top">
<form method="post" action="/DesInventar/inv/index.jsp?rnd=<%=Math.round(Math.random()*9999)%>" name="desinventar" id="desinventar">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<!-- Content goes after this comment -->


<script language="javascript">
<!-- 

function bSomethingSelected()
{
if (document.desinventar.countrycode.selectedIndex==-1)
	{
	alert ("Please select a Region from the list...");
	return false;
	} 
return true;
}

function fillCountry()
{
 document.desinventar.countryname.value=countrycode.options[countrycode.selectedIndex].text;
 return true;
}

function gotoPage(tabpage)
{
// checks there's a selection
if (bSomethingSelected())
  with (document.desinventar)
	{
	// saves the country name for the setproperty
	countryname.value=countrycode.options[countrycode.selectedIndex].text;
	// saves the page to forward to...
    actiontab.value=tabpage;
	submit();
	}
else
 postTo(tabpage)
}

function gotoPageinconditional(tabpage)
{
// checks there's a selection
  with (document.desinventar)
	{
	// saves the country name for the setproperty
	if (countrycode.selectedIndex>=0)
		countryname.value=countrycode.options[countrycode.selectedIndex].text;
	// saves the page to forward to...
    actiontab.value=tabpage;
	submit();
	}
}

// -->
</script>

<table width="100%" cellspacing="2" cellpadding="2" border=0>
<tr>
    <td width="50">&nbsp;</td>
<td>
<FONT face=Arial color=#ff0000 size=4><STRONG><EM><%=countrybean.getTranslation("welcomeDesInventar")%>, <%=user.sfirstname%></EM></STRONG></FONT><br><br>
<%=countrybean.getTranslation("explainDesInventar")%>

    </td>
</tr>
<tr>
    <td width="50">&nbsp;</td>
    <td align="left">
	<table border="1"  cellpadding="2" cellspacing="0" width=450 class='IE_Table'>
	  <tr>
	  	  <!-- 
		  <td align="center" width="50%" class=bgDark>
          <div class="titleTextWhite">Defined regions:</div>
		  </td>
		   -->
		   <td align="center" class=bgDark>
          <div class="titleTextWhite"><%=countrybean.getTranslation("AuthorizedRegions")%>:</div>
		  </td>
	  </tr>
	  <tr>
		  <td align="center">
	     <br>
		 <SELECT name="countrycode" style="WIDTH: 400px; HEIGHT: 166px" size=10>
	     <inv:selectBase connection="<%= con %>" user="<%=user%>" selected="<%=countrybean.countrycode%>"/>
		 </SELECT><br>
		 <br> 
		 <input type='hidden' name="countryname" value="Nombre de pais">
		 <INPUT type='hidden'  name="actiontab" id="actiontab" value="index.jsp">
		 <INPUT type='hidden'  name="frompage" value="<%=request.getServletPath()%>">
	    </td>
     </tr>
	</table>
 </td>
</tr>
</form>
<tr>
    <td width="50">&nbsp;</td>
	<td>
		<table width="450" cellspacing="0" cellpadding="2" border="1" rules="none">
		<tr>
		    <th align="left"><!-- profile --></strong></th>
			<th><strong>You can access the following databases for analysis:</strong></th>
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
			<td nowrap><a class="blackLinks" href="/DesInventar/profiletab.jsp?countrycode=<%=sCountryId%>&continue=y">
			<%=sCountryName%></a></td>
			</tr><%
		 }
		%>
		</table>

	</td>
</tr>
</table>
<!-- End of Content area -->
</td></tr></table>
<%} // router%>
<% 	// close the database object 
dbCon.close();
%>
<script src="/DesInventar/inv/resize.js"></script>
</body>
</html>

