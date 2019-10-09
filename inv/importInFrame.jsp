<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<%@ page info="Reindex page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
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

<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/><body>
<script language="JavaScript">
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
String database,events,causes,levels,geography,data,definition,extension,maps,othercountrycode, 
	shiftlevel, newlev0,newlev0_name,newlev0_name_en, cleandatabase;
database=countrybean.not_null(request.getParameter("database"));
cleandatabase=countrybean.not_null(request.getParameter("cleandatabase"));
othercountrycode=countrybean.not_null(request.getParameter("othercountrycode"));
events=countrybean.not_null(request.getParameter("events"));
causes=countrybean.not_null(request.getParameter("causes"));
levels=countrybean.not_null(request.getParameter("levels"));
geography=countrybean.not_null(request.getParameter("geography"));
maps=countrybean.not_null(request.getParameter("maps"));
data=countrybean.not_null(request.getParameter("data"));
definition=countrybean.not_null(request.getParameter("definition"));
extension=countrybean.not_null(request.getParameter("extension"));
shiftlevel=countrybean.not_null(request.getParameter("shiftlevel"));
newlev0=countrybean.not_null(request.getParameter("newlev0"));
newlev0_name=countrybean.not_null(request.getParameter("newlev0_name"));
newlev0_name_en=countrybean.not_null(request.getParameter("newlev0_name_en"));
Connection diCon=null;
boolean ok=false;
MapUtil map=new MapUtil();
ServletContext sc = getServletConfig().getServletContext();
// just to RUN IT!!
Runtime rt=Runtime.getRuntime();
// get a connection to external DB
if (database.length()>0)
	{	
	// open ACCESS through 64 bit  driver 
	pooledConnection di6=new pooledConnection( Sys.sAccess64Driver, Sys.sAccess64DefaultString+database+";", null,null);
	
	ok=di6.getConnection();
	diCon=di6.connection;
	if (ok)
		{
		String sMapSource=database.substring(0,database.lastIndexOf("/")+1);
		String sBasePath=countrybean.country.sjetfilename;
		String sSourceCode=database.substring(database.length()-6,database.length()-4);
		String sMapFile="";
	    if (maps.equals("Y"))
		  {
		  try
			{
			if (!sBasePath.endsWith("/"))
			   sBasePath+="/";
			
			// todo:  change this section to rather copy shapefiles.
			sMapFile=map.getMapFileName(sMapSource, sSourceCode, "vent.txt");
			FileCopy.copy(sMapFile,sBasePath+countrybean.countrycode+"vent.txt");
	
			}
		  catch (Exception e)
			{
			System.out.println("Error importing/copying map file: "+sMapFile);
			}
		  } // if (maps.equals("Y"))
       }  // if (ok)
	} // if (database.length()>0)
else  // countrycode must be >""
	{
	// Load the country object from the DesInventar (default) database
	dbConnection dbDefaultCon; 
	Connection dcon; 
	boolean bdConnectionOK=false; 
	// opens the Default database 
	dbDefaultCon=new dbConnection();
	ok = dbDefaultCon.dbGetConnectionStatus();
	if (ok)
		{
		dcon=dbDefaultCon.dbGetConnection();
		// now it should read the names of the levels. 
		// It is done in the bean, so it can be reused as properties...
		country otherCountry= new country();
		otherCountry.scountryid=othercountrycode;
		otherCountry.getWebObject(dcon);
		// MUST return this connection!
		dbDefaultCon.close();	
		// now try to open it, to report the results and to 
		pooledConnection di6=new pooledConnection(otherCountry.sdriver,otherCountry.sdatabasename, otherCountry.susername,otherCountry.spassword);	
		ok=di6.getConnection();
		diCon=di6.connection;
		}
	}
if (ok)
	{
	if (cleandatabase.equals("Y"))
		   dbutils.cleanDatabase( con,   countrybean);
	dbutils importer=new dbutils();
	importer.importDI6 (con, diCon, out, countrybean,cleandatabase, events, causes, levels, geography, data, definition, extension, shiftlevel, newlev0, newlev0_name, newlev0_name_en);
    if (maps.equals("Y") && database.length()>0)
	  {
		map.regenerateRegions(con, sc.getRealPath("/"), countrybean);
	  }
	 }
else
	out.println("<strong>ERROR OPENING EXTERNAL DB</strong>");


// now, back to the manager
dbCon.close();
// CLOSE THE DI DATABASE
try{
diCon.close();
}
catch (Exception e){}

%>
<script language="JavaScript">
alert("<%=countrybean.getTranslation("ImportFinished")%>");
//parent.window.location="/DesInventar/inv/adminManager.jsp"
</script>
</body>
</html>

