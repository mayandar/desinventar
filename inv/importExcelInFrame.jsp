<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<%@ page info="Reindex page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Enumeration"%>
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
<%if (user.iusertype<20) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}%>
<%@ include file="/util/opendatabase.jspf" %>
<%
// get all parameters:
String database,events,causes,levels,geography,data,definition,extension,firstrow,startrow,sheetnumber;
database=countrybean.not_null(request.getParameter("filename"));
events=countrybean.not_null(request.getParameter("events"));
causes=countrybean.not_null(request.getParameter("causes"));
geography=countrybean.not_null(request.getParameter("geography"));
data=countrybean.not_null(request.getParameter("data"));
extension=countrybean.not_null(request.getParameter("extension"));
firstrow=countrybean.not_null(request.getParameter("firstrow"));
startrow=countrybean.not_null(request.getParameter("startrow"));
sheetnumber=countrybean.not_null(request.getParameter("sheetnumber"));
boolean ok=false;


String sFileToLoad=request.getParameter("filename");  // C:/bases_6/MyanmarPONJA/Operational dataV2.xls";
if (sFileToLoad!=null)
	{
	File f=new File(sFileToLoad);
	if (f.exists())
	  ok=true;
	}
if (ok)
	{
	
    Enumeration e;
    String sRequestParams ="";
	String sSep="?";
	for (e = request.getParameterNames(); e.hasMoreElements(); )
    {
      String param = (String) e.nextElement();
      sRequestParams+=sSep+param+"="+(request.getParameter(param)==null?"":request.getParameter(param));
	  sSep="&nbsp;|&nbsp;";
    }


%>
Import process started with parameters: <%=sRequestParams%><br>
<%
				
		ExcelLoader elLoader=new ExcelLoader();
		// not needed in the unit test: 
		elLoader.initProtoMap(con, countrybean);
		elLoader.setOut(out);
		// upload all column parameter mappings to ExcelLoader instance: 
		for (e = request.getParameterNames(); e.hasMoreElements(); )
	    {
	      String param = (String) e.nextElement();
	      if (request.getParameter(param)!=null)
		     {
			 int iVariable=countrybean.extendedParseInt(request.getParameter(param));
		     elLoader.sLoadMap.put(param, new Integer(iVariable));
			 }
	    }
		elLoader.nFirstRow=countrybean.extendedParseInt(firstrow);
		elLoader.nStartRow=countrybean.extendedParseInt(startrow);
		elLoader.nSpreadsheet=countrybean.extendedParseInt(sheetnumber);
			 
		elLoader.createExtension(request, con, countrybean);
		elLoader.loadFile (sFileToLoad, con, countrybean, request);
		}
else
	out.println("<strong>ERROR OPENING EXTERNAL DB</strong>");


// now, back to the manager
dbCon.close();
%>
<script language="JavaScript">
alert("<%=countrybean.getTranslation("ImportFinished")%>");
//parent.window.location="/DesInventar/inv/adminManager.jsp"
</script>
</body>
</html>

