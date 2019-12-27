<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<%@ page info="Reindex page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.map.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>

<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />

<html>
<head>
	<title>Tabbed Importer</title>
</head>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body>
<script language="JavaScript">
// http://localhost:8081/DesInventar/inv/importInFrame.jsp?events=Y&causes=Y&levels=Y&geography=Y&data=Y&definition=Y&extension=Y&database=C:/bases_6/Colombia/copmap.mdb
// document.body.scroll='no';
document.body.scroll='auto';
</script>
<% // Java declarations  
int nClave;
int j=0; %>
<% // opens the database %>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%@ include file="/util/opendatabase.jspf" %>
<%
// get all parameters:
String database,events,causes,levels,geography,data,definition,extension,maps,othercountrycode, 
	shiftlevel, newlev0,newlev0_name,newlev0_name_en,cleandatabase;
String metadata;
database=countrybean.not_null(request.getParameter("database"));
events=countrybean.not_null(request.getParameter("events"));
causes=countrybean.not_null(request.getParameter("causes"));
levels=countrybean.not_null(request.getParameter("levels"));
geography=countrybean.not_null(request.getParameter("geography"));
maps=countrybean.not_null(request.getParameter("maps"));
data=countrybean.not_null(request.getParameter("data"));
definition=countrybean.not_null(request.getParameter("definition"));
extension=countrybean.not_null(request.getParameter("extension"));
cleandatabase=countrybean.not_null(request.getParameter("cleandatabase"));
metadata=countrybean.not_null(request.getParameter("metadata"));
boolean ok=false;

/* For local test */
String remotefile="http://127.0.0.1/DesInventar/inv/tableDownload.jsp?";
/* For www.Desinventar,net 
String remotefile="https://www.desinventar.net/DesInventar/inv/tableDownload.jsp?";
*/

int iAction = webObject.extendedParseInt(request.getParameter("action"));
String sCountry = "";
int iVariable = 0;
int element_key = 0;
int indicator_key= 0;
String returnPoint = "";
MapUtil map=new MapUtil();
ServletContext sc = getServletConfig().getServletContext();
// get a connection to external DB
database=countrybean.not_null(database).trim();
String sErrorMessage="";
if(iAction > 0){
	URL url = null;
	URLConnection urlConnection = null;
	InputStream in = null;
//	remotefile = "DI_retrieve_metadata_national_kor.xml";
	try{
		switch(iAction){
		case 1:
			returnPoint = "metadataNationalManager.jsp";
			sCountry = (String) request.getAttribute("country");
			url = new URL(remotefile+"country="+sCountry+"&action="+iAction);
			request.removeAttribute("country");
			break;
		case 2:
			returnPoint = "metadataNationalManager.jsp";
			sCountry = (String)request.getAttribute("country");
			iVariable = ((Integer)request.getAttribute("variable")).intValue();
			url = new URL(remotefile+"country="+sCountry+"&variable="+iVariable+"&action="+iAction);
			request.removeAttribute("country");
			request.removeAttribute("variable");
			break;
		case 3:
			returnPoint = request.getHeader("referer");
			sCountry = (String) request.getAttribute("country");
			url = new URL(remotefile+"country="+sCountry+"&action="+iAction);
			request.removeAttribute("country");
			break;
		case 4:
			sCountry = (String)request.getAttribute("country");
			indicator_key = ((Integer)request.getAttribute("indicator_key")).intValue();
			url = new URL(remotefile+"country="+sCountry+"&indicator_key="+indicator_key+"&action="+iAction);
			request.removeAttribute("country");
			request.removeAttribute("indicator_key");
			returnPoint = "metadataGroup.jsp?indicator_key="+indicator_key;
			break;
		case 5:
			sCountry = (String)request.getAttribute("country");
			indicator_key = ((Integer)request.getAttribute("indicator_key")).intValue();
			element_key = ((Integer)request.getAttribute("element_key")).intValue();
			url = new URL(remotefile+"country="+sCountry+"&indicator_key="+indicator_key+"&action="+iAction+"&element_key="+element_key);
			request.removeAttribute("country");
			request.removeAttribute("indicator_key");
			request.removeAttribute("element_key");
			returnPoint = "maintainMetadataElementCosts.jsp?indicator_key="+indicator_key+"&element_key="+element_key;
			break;
		}
		urlConnection = url.openConnection();
		in = urlConnection.getInputStream();
	}
	catch(Exception ex1){
		sErrorMessage = ex1.getMessage();
	}
	if(in != null){
		XmlReader Xml = new XmlReader(in);
//		Xml.setOptions(metadata, events,causes,levels,geography,data,definition,extension,maps);
		Xml.setOptions("Y", null,null,null,null,null,null,null,null);
		Xml.setCountryCode (countrybean.countrycode);
		
//		if (cleandatabase.equals("Y"))
//		   dbutils.cleanDatabase( con,   countrybean);
		try {
				Xml.start(con,countrybean.dbType);					
			}
		catch (Exception exml)
			{
						System.out.println("[DI] Error reported by XML importer:"+exml.toString());
			}
		in.close();
		dbCon.close();
	} else { %>
		<script language="JavaScript">
		alert("<%=sErrorMessage %>");
		//parent.window.location="/DesInventar/inv/adminManager.jsp"
		</script>
		<%
	}
	%>
		<script language="JavaScript">
		alert("<%=countrybean.getTranslation("Retrieve Finished") %>");
		//parent.window.location="/DesInventar/inv/adminManager.jsp"
		switch(iAction){
		case 1: 
			response.sendRedirect(returnPoint);
	   		break;
		case 2:
			response.sendRedirect(returnPoint);
		case 3:
			window.history.back();
			break;
		case 4:
	   		window.history.back();
	   		break;
		case 5:
			response.sendRedirect(returnPoint);
	   		break;
		}
		</script>

		<% 
		response.sendRedirect(returnPoint);
		// response.sendRedirect(request.getHeader("referer"));
} 
else 
{
if (database.length()>0)
	{
		try{
			File f=new File (database);
			if (f.exists() && f.isFile() && f.canRead())
				ok=true;				
			}
			catch (Exception ex)
			{
			out.println("INVALID FILE.  Exception thrown:"+ex.toString());
			}
	} // if (database.length()>0)
  if (ok)
	{
		XmlReader Xml = new XmlReader(database);
		Xml.setOptions(metadata, events,causes,levels,geography,data,definition,extension,maps);
		Xml.setCountryCode (countrybean.countrycode);
		if (cleandatabase.equals("Y"))
		   dbutils.cleanDatabase( con,   countrybean);
		try {
				Xml.start(con,countrybean.dbType);					
			}
		catch (Exception exml)
			{
						System.out.println("[DI] Error reported by XML importer:"+exml.toString());
			}
	}
else
	out.println("<strong>ERROR OPENING EXTERNAL DB</strong>");

}
// now, back to the manager
dbCon.close();
%>
<script language="JavaScript">
alert("<%=countrybean.getTranslation("ImportFinished")%>");
//parent.window.location="/DesInventar/inv/adminManager.jsp"
</script>
</body>
</html>

