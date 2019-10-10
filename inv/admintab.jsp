<%@ page info="DesInventar On-Line main page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<%
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
%>
<%@ include file="checkUserIsLoggedIn.jsp" %>
<%
// load language code (if available)
if (request.getParameter("lang")!=null)
	countrybean.setLanguage(request.getParameter("lang"));
// load DATA language code (if available)
if (request.getParameter("datalng")!=null)
	countrybean.setDataLanguage(request.getParameter("datalng"));
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>DesInventar on-line : <%=countrybean.countryname%> <%=countrybean.getTranslation("Administration")%> </title>
</head>
 <%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/iheader",countrybean.getLanguage(),out);%>
<%@ taglib uri="/inventag.tld" prefix="inv" %>
<!-- DI TOP OPEN -->
<script language="javascript">
<!-- 

var countrycode="<%=countrybean.countrycode%>";
function gotoPage(tabpage)
{
// checks there's a selection
if (countrycode.length>0)
	{
	postTo(tabpage);
	}
else
	postTo("/DesInventar/inv/index.jsp");
}
// -->
</script>

<%
int nTabActive=8; // results
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
<br/>
<FORM NAME="desinventar" method="post">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
</FORM>
<!-- Content goes after this comment -->
<% if (user.iusertype>=20) 
{
  if (request.getParameter("sub")==null)
  	{%>
	<iframe width="100%" height="100%" id="contentFrame" align="left" src="adminManager.jsp?usrtkn=<%=countrybean.userHash%>"></iframe>
  <%}
  else
    {
	String nextPage=request.getParameter("sub");
	// see if there is a  default request, and put all parameters
	String sParSep="?";
	for (java.util.Enumeration e=request.getParameterNames(); e.hasMoreElements(); )
				{
				String param= (String) e.nextElement();
				String value= request.getParameter(param);
				nextPage+= sParSep+param+"="+value;
				sParSep="&";
				}
	nextPage+=sParSep+"usrtkn="+countrybean.userHash;			
	%>	
	<iframe width="100%" height="100%" id="contentFrame" src="<%=nextPage%>"></iframe>
  <%}
}  
else
{%>
<iframe width="100%" height="100%" id="contentFrame" src="noaccess.jsp?inframe=yes"></iframe>
<%}%>
<!-- Content goes before this comment -->
<!--script src="/DesInventar/inv/resize.js"></script-->
</body>
</html>

