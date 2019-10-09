<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<title>DesInventar on-line</title>
</head>
<%@ page import = "org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.webobject.users" %>
<%@ page import="org.lared.desinventar.webobject.eventos" %>
<%@ page import="org.lared.desinventar.util.login" %>
<%@ page import="org.lared.desinventar.util.htmlServer" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id = "Event" class="org.lared.desinventar.webobject.eventos" scope="session" />
<%@ taglib uri="/inventag.tld" prefix="inv" %>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
if (user.iusertype<20) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}%> 
<%@ include file="/util/opendatabase.jspf" %>
<body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
 
 
<% 
int nSqlResult =0;
String sErrorMessage="";
PreparedStatement pstmt=null;
// important for the helper to return the right function
Event.dbType=countrybean.dbType;
if (request.getParameter("addEvent")!=null)
   {
    Event.init();
	dbCon.close();
	%><jsp:forward page="eventsUpdate.jsp?action=0"/><%
   }
else if (request.getParameter("editEvent")!=null)
   {
    Event.init();
	Event.nombre=request.getParameter("nombre");
	Event.getWebObject(con);
	dbCon.close();
	%><jsp:forward page="eventsUpdate.jsp?action=1"/><%
   }
else if (request.getParameter("mergeEvent")!=null)
   {
    Event.init();
	Event.nombre=request.getParameter("nombre");
	Event.getWebObject(con);
	dbCon.close();
	%><jsp:forward page="eventMerge.jsp"/><%
   }
else if (request.getParameter("delEvent")!=null)
   {
	Event.nombre=request.getParameter("nombre");
	Event.getWebObject(con);
	// verify datacards for references!
	if (Event.getReferenceCount("evento", Event.nombre, "fichas", con)==0)
		{
	    // delete children in other tables
		try
			{
			pstmt = con.prepareStatement("update eventos set parent=NULL where parent=?");  // equivalent to a ON DELETE SET NULL !
			pstmt.setString(1, Event.nombre);
			pstmt.executeUpdate();
			}
		catch (Exception exfk)
			{}
		try
			{
			pstmt = con.prepareStatement("delete from event_grouping where nombre=?");  // equivalent to a ON DELETE CASCADE !
			pstmt.setString(1, Event.nombre);
			pstmt.executeUpdate();
			}
		catch (Exception exfk)
			{}
		pstmt.close();
		Event.deleteWebObject(con);
		}
	else
		sErrorMessage=countrybean.getTranslation("RecordcannotbeDeleted.Referencedby")+" "+countrybean.getTranslation("DataCards")+" "+countrybean.getTranslation("records_that_must_be_deleted");
   }
 else if (request.getParameter("translate_mergeEvent")!=null)
   {
   sErrorMessage="";
   stmt=con.createStatement();
   stmt.executeUpdate("update eventos set nombre_en ="+Event.sGetSQLFunction("UPPER")+"(nombre_en) where nombre_en is not null");
   rset=stmt.executeQuery("select * from eventos where nombre_en<>nombre and nombre_en is not null");
   while (rset.next())
   		{
	   Event.loadWebObject(rset);
	   String sSource=Event.nombre;
	   String sTarget=Event.nombre_en;
	   // makes sure the full english-english event exists
	   Event.nombre=Event.nombre_en;
	   int nrecs=Event.addWebObject(con);		   
	   pstmt=null;
	   // moves all events to the newly created English version
	   try{
	   		pstmt=con.prepareStatement("update fichas set evento=? where evento=?");
	   		pstmt.setString(1,sTarget);
	   		pstmt.setString(2,sSource);
			pstmt.executeUpdate();
	   		Event.nombre=sSource;
			if (nrecs>0)
				Event.deleteWebObject(con);
			}
		catch (Exception merx)
			{
			/// what?`
			sErrorMessage+="<br>Cound not translate/merge: "+merx.toString();
			}	
		}
   rset.close();
   stmt.close();
   }
 else if (request.getParameter("translate_mergeEventFrench")!=null)
   {
        HashMap hFrench=new HashMap();
   		hFrench.put("ACCIDENT","ACCIDENT");
		hFrench.put("ALLUVION","ALUVION");
		hFrench.put("OTHER","AUTRES");
		hFrench.put("AVALANCHE","AVALANCHE");
		hFrench.put("BIOLOGICAL","BIOLOGIQUE");
		hFrench.put("HEAT WAVE","CANICULE");
		hFrench.put("HEATWAVE","CANICULE");
		hFrench.put("HURRICANE","CICLON");
		hFrench.put("COASTLINE","COASTLINE");
		hFrench.put("EPIDEMIC","ÉPIDÉMIE");
		hFrench.put("ERUPTION","ÉRUPTION");
		hFrench.put("LEAK","ESCAPE");
		hFrench.put("EXPLOSION","EXPLOSION");
		hFrench.put("FOG","BROUILLARD");
		hFrench.put("ELECTRIC STORM","FOUDRE");
		hFrench.put("ELECTRICSTORM","FOUDRE");
		hFrench.put("THUNDERSTORM","FOUDRE");
		hFrench.put("THUNDER STORM","FOUDRE");
		hFrench.put("LIGHTNING","FOUDRE");
		hFrench.put("FROST","GEL");
		hFrench.put("LANDSLIDE","GLISSEMENT DE TERRAIN");
		hFrench.put("HAILSTORM","GRELE");
		hFrench.put("HAIL STORM","GRELE");
		hFrench.put("HIGH TIDE","HAUTE MAREE");
		hFrench.put("HIGHTIDE","HAUTE MAREE");
		hFrench.put("SURGE","HAUTE MAREE");
		hFrench.put("FIRE","INCENDIE");
		hFrench.put("FORESTFIRE","INCENDIE DE FORÊT");
		hFrench.put("FOREST FIRE","INCENDIE DE FORÊT");
		hFrench.put("FLOOD","INONDATION");
		hFrench.put("INTOXICATION","INTOXICATION");
		hFrench.put("LIQUEFACTION","LICUACION");
		hFrench.put("SNOWSTORM","NEIGE");
		hFrench.put("SNOW STORM","NEIGE");
		hFrench.put("PANIC","PANIQUE");
		hFrench.put("PLAGUE","PESTES");
		hFrench.put("RAIN","PLUIE");
		hFrench.put("HEAVY RAIN","PLUIE ABONDANTE");
		hFrench.put("RAINS","PLUIE");
		hFrench.put("FLASHFLOOD","INONDATION TORRENTIELLE");
		hFrench.put("FLASH FLOOD","INONDATION TORRENTIELLE");
		hFrench.put("SPATE","INONDATION TORRENTIELLE");
		hFrench.put("CONTAMINATION","POLLUTION");
		hFrench.put("DROUGHT","SÉCHERESSE");
		hFrench.put("SEDIMENTATION","SÉDIMENTATION");
		hFrench.put("STRUCTURE","EFFONDREMENT DE STRUCTURE");
		hFrench.put("STORM","TEMPÊTE");
		hFrench.put("STRONG WIND","VENTS FORTS");
		hFrench.put("STRONGWIND","VENTS FORTS");
		hFrench.put("WINDSTORM","VENTS TEMPETUEUX");
		hFrench.put("WIND STORM","VENTS TEMPETUEUX");
		hFrench.put("TORNADO","TORNADE");
		hFrench.put("EARTHQUAKE","TREMBLEMENT DE TERRE");
		hFrench.put("TSUNAMI","TSUNAMI");


   sErrorMessage="";
   stmt=con.createStatement();
   stmt.executeUpdate("update eventos set nombre_en ="+Event.sGetSQLFunction("UPPER")+"(nombre_en) where nombre_en is not null");
   rset=stmt.executeQuery("select * from eventos where nombre_en is not null");
   while (rset.next())
   		{
	   Event.loadWebObject(rset);
	   String sSource=Event.nombre;
	   String sTarget=(String) hFrench.get(Event.nombre_en);
	   if (sTarget==null) 
	     sTarget=sSource;
	   // makes sure the full english-english event exists
	   Event.nombre=sTarget;
	   Event.addWebObject(con);		   
	   pstmt=null;
	   // moves all events to the newly created English version
	   try{
	   		pstmt=con.prepareStatement("update fichas set evento=? where evento=?");
	   		pstmt.setString(1,sTarget);
	   		pstmt.setString(2,sSource);
			pstmt.executeUpdate();
	   		Event.nombre=sSource;
			Event.deleteWebObject(con);
			}
		catch (Exception merx)
			{
			/// what?`
			sErrorMessage+="<br>Cound not translate/merge: "+merx.toString();
			}	
		}
   rset.close();
   stmt.close();
   }

String sDisplayField="nombre";
if (countrybean.getDataLanguage().equals("EN"))
	sDisplayField="nombre_en";
%>
   
<script language="JavaScript">
<!--
function bSomethingSelected()
{
if (document.desinventar.nombre.selectedIndex==-1)
	{
	alert ("<%=countrybean.getTranslation("Pleaseselecta")%> <%=countrybean.getTranslation("Event")%> <%=countrybean.getTranslation("fromthelist")%>...");
	return false;
	} 
return true;
}

function confirmDelete()
{
if (bSomethingSelected())
	{
	return confirm ("<%=countrybean.getTranslation("Areyousureyouwanttodeletethis")%> <%=countrybean.getTranslation("Event")%>  ?");
	} 
else 
  return false;
}

function bAreYourSure()
{
return confirm ("<%=countrybean.getTranslation("Are you sure you want to TRANSLATE ALL to English (this cannot be undone!) ?")%>");
}


function event_up()
{
if (document.desinventar.nombre.selectedIndex>0)
	{
	document.desinventar.swapevent.value=document.desinventar.nombre.options[document.desinventar.nombre.selectedIndex-1].value;
	document.desinventar.submit();
	}
}


function event_down()
{
if (document.desinventar.nombre.selectedIndex>=0 && document.desinventar.nombre.selectedIndex<document.desinventar.nombre.options.length-1)
	{
	document.desinventar.swapevent.value=document.desinventar.nombre.options[document.desinventar.nombre.selectedIndex+1].value;
	document.desinventar.submit();
	}
}

// -->
</script>

<FORM name="desinventar" method="post" action="eventManager.jsp">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<table cellspacing="0" cellpadding="0" border="0" width="650">
<tr>
  <td width=50>&nbsp;</td>
  <td>
	<table cellspacing="0" cellpadding="5" border="0" width="650" rules="none">
	<tr>
	    <td height="25" td colspan="2" class='bgDark' align="center"><span class="title"><%=countrybean.getTranslation("EventManager")%></span></td>
		</td>
	</tr>
	<tr><td colspan="2" height="5"></td></tr>
	<TR>
	<TD colspan=2 align="center"><span class="warning"><%=sErrorMessage%></span></TD>
	</TR>
	<tr><td colspan="2" height="5"></td></tr>
	<tr><td colspan="2" align="center">
	<SELECT name="nombre" style="WIDTH: 350px; HEIGHT: 166px" size=10>
	<inv:select tablename='eventos' selected='<%=Event.nombre%>' connection='<%= con %>'
    	fieldname="<%=sDisplayField%>" codename='nombre' ordername='nombre'/>
    </SELECT><br>
	<input type="button" name="upEvent" value="<%=countrybean.getTranslation("upEvent")%>" onClick="event_up()">
	<input type="button" name="dnEvent" value="<%=countrybean.getTranslation("downEvent")%>" onClick="event_down()">
	</td></tr>
	<tr><td colspan="2" height="25"></td></tr>
	<tr><td colspan="2" align="center">
	<input type="submit" name="addEvent" value="<%=countrybean.getTranslation("Add")%> <%=countrybean.getTranslation("Event")%>">
	<input type="submit" name="editEvent" value="<%=countrybean.getTranslation("Edit")%> <%=countrybean.getTranslation("Event")%>" onClick="return bSomethingSelected()">
	<input type="submit" name="delEvent" value="<%=countrybean.getTranslation("Delete")%> <%=countrybean.getTranslation("Event")%>" onClick="return confirmDelete()">
	<input type="submit" name="mergeEvent" value="<%=countrybean.getTranslation("Merge With Other Event")%>" onClick="return bSomethingSelected()">
	<br/><br/><br/><br/>
 	<input type="submit" name="translate_mergeEvent" value="<%=countrybean.getTranslation("Translate ALL to English")%>"  onclick="return bAreYourSure()">
 	<input type="submit" name="translate_mergeEventFrench" value="<%=countrybean.getTranslation("Translate ALL to French")%>"  onclick="return bAreYourSure()">
	</td></tr>
	</table>
  </td>
 </tr>
</table>
</form>
</body>
</html>
<% dbCon.close(); %>

