<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8");%>
<%@ page info="DesInventar On-Line data entry page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="woFicha" class="org.lared.desinventar.webobject.fichas" scope="session" />
<jsp:useBean id="woExtension" class="org.lared.desinventar.webobject.extension" scope="session" />
<%// checks for a session alive variable, or we have a new valid countrycode
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
if (countrybean.countrycode.length()==0)
	{%><jsp:forward page="/inv/index.jsp"/>
	<%}%>
<%@ include file="checkUserIsLoggedIn.jsp" %>
<%if (user.iusertype<1) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}%>
<%@ include file="/util/opendatabase.jspf" %>
<%
// webObjects for datacard(ficha) and extension
int nClave; 
int j=0; 
woExtension.dbType=dbType;
woFicha.dbType=dbType;
if (bConnectionOK)
	{
	if (request.getParameter("okDelCard")!=null)
		{
    	// get primary key from parameters
    	nClave=htmlServer.extendedParseInt(request.getParameter("clave"));
		woFicha.clave=nClave;
		woExtension.clave_ext=nClave;
		// FIRST, REMOVE EXTENSION PARTNER OF THE DATACARD:
		woExtension.deleteWebObject(con);
        // THEN, REMOVE THE DATACARD (will also remove from words index and associated  media files)
		woFicha.deleteWebObject(con);
		dbCon.close();
		// removes the entry from tips - it will not show real data
		CountryTip.getInstance().remove(countrybean.countrycode);

	   %><jsp:forward page="resultstab.jsp">
	   	 <jsp:param name="NoQuery" value="NoQuery"/>
		 </jsp:forward>
	   <%
		}
	}
int nStart=htmlServer.extendedParseInt(request.getParameter("nStart"));
%>
<html>
<head>
<title>Delete DataCard <%=countrybean.countryname%><%=countrybean.getTranslation("DataEntry")%></title>
</head>
<body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/iheader",countrybean.getLanguage(),out);%>
<%@ include file="validation.jsp" %>
<%@ taglib uri="inventag.tld" prefix="inv" %>
<%
{
int nTabActive=6; // 
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
<%}%>
<table width="840" border="1" class="pageBackground" rules="none" height="500"><tr><td align="center" valign="top">
<!-- Content goes after this comment -->
<table width="840" border="0">
<FORM NAME='desinventar' method="post" action='deletedatacard.jsp'>
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<tr><td>
<span class="warning"><strong></strong><%=countrybean.getTranslation("PleaseConfirmyouwishtodeletethisDatacard")%>:</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<span align="right" class="warningSmall">(<%=countrybean.getTranslation("thisoperationcantbeundone")%>)</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="submit"  name='okDelCard' value='<%=countrybean.getTranslation("ConfirmDelete")%>'>
<input type="button"  name='NODelCard' value='<%=countrybean.getTranslation("Cancel")%>' onClick="postTo('resultstab.jsp')">

</td></tr>
</table>
<%
if (bConnectionOK)
	{
	// sets the physical parameters of the location of templates- USE FOR DEVELOPMENT ONLY!
    // htmlServer.setFilePrefix("/tomcat/webapps/Desinventar/", "e:", "/tomcat/webapps/Desinventar/");
   	// get primary key from parameters
    nClave=htmlServer.extendedParseInt(request.getParameter("clave"));
	// gets the object from the database
	woFicha.clave=nClave;
	woFicha.getWebObject(con);
	woExtension.clave_ext=nClave;
	woExtension.getWebObject(con);
	// saves the clave as hidden input field so making it available at post
	out.println("<input type='hidden' name='clave' id='clave' value='"+nClave+"'>");
	// send it to client using its template
    %><%@ include file="i_ficha.jsp" %><%
	dbCon.close();
	}
 %>
<table width="840" border="0">
<tr><td align="center">
<input type="submit"  name='okDelCard' value='Confirm Delete'>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button"  name='NODelCard' value='Cancel' onClick="postTo('resultstab.jsp')">
</td></tr></table>
<input type='hidden' name='nStart' value='<%=nStart%>'>
</form>
<!-- Content goes before this comment -->
</td></tr></table>
</body>
</html>
