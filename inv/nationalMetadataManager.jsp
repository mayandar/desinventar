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
<jsp:useBean id = "metadata" class="org.lared.desinventar.webobject.MetadataNational" scope="session" />
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
String sWhere = "metadata_country='"+countrybean.countrycode+"'";
PreparedStatement pstmt=null;
// important for the helper to return the right function
metadata.init();
metadata.dbType=countrybean.dbType;
Event.dbType=countrybean.dbType;
if (request.getParameter("add")!=null)
   {
	metadata.init();
//    Event.init();
	dbCon.close();
	%><jsp:forward page="nationalMetadataUpdate.jsp?action=0"/><%
   }
else if (request.getParameter("edit")!=null)
   {
	metadata.init();
//  Event.init();
	metadata.metadata_key=metadata.extendedParseInt(request.getParameter("metadata_key"));
	metadata.metadata_country=request.getParameter("countrycode");
	metadata.getWebObject(con);
	dbCon.close();
	%><jsp:forward page="nationalMetadataUpdate.jsp?action=1"/>
	<%--
   }
else if (request.getParameter("mergeEvent")!=null)
   {
    Event.init();
	Event.nombre=request.getParameter("nombre");
	Event.getWebObject(con);
	dbCon.close();
	%><jsp:forward page="eventMerge.jsp"/>
	--%>
	<%
   }
else if (request.getParameter("delete")!=null)
   {
	metadata.init();
	int metadata_key = 
	metadata.metadata_key=metadata.extendedParseInt(request.getParameter("metadata_key"));
	metadata.metadata_country=request.getParameter("countrycode");
	int rows = metadata.getWebObject(con);
	if(rows != 0){
		metadata.deleteWebObject(con);
	} else {
		sErrorMessage=countrybean.getTranslation("Could not find ")+" "+countrybean.getTranslation(metadata.metadata_variable);
	}
	/*
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
	*/
   }
/*  
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
		hFrench.put("EPIDEMIC","�PID�MIE");
		hFrench.put("ERUPTION","�RUPTION");
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
		hFrench.put("FORESTFIRE","INCENDIE DE FOR�T");
		hFrench.put("FOREST FIRE","INCENDIE DE FOR�T");
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
		hFrench.put("DROUGHT","S�CHERESSE");
		hFrench.put("SEDIMENTATION","S�DIMENTATION");
		hFrench.put("STRUCTURE","EFFONDREMENT DE STRUCTURE");
		hFrench.put("STORM","TEMP�TE");
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
*/

String sDisplayField="metadata_variable";
if (countrybean.getDataLanguage().equals("EN"))
	sDisplayField="metadata_variable";
%>
   
<script language="JavaScript">
<!--
function bSomethingSelected()
{
if (document.desinventar.metadata_key.selectedIndex==-1)
	{
	alert ("<%=countrybean.getTranslation("Pleaseselecta")%> <%=countrybean.getTranslation("national metadata")%> <%=countrybean.getTranslation("fromthelist")%>...");
	var x = document.getElementById("annualdata");  
	x.style.display = "none";
	var y = document.getElementById("translatedata");  
	y.style.display = "none";
	return false;
	} 
var x = document.getElementById("annualdata");  
x.style.display = "block";
var y = document.getElementById("translatedata");  
y.style.display = "block";
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

<FORM name="desinventar" method="post" action="nationalMetadataManager.jsp">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<input type="hidden" name="countrycode" id="countrycode" value="<%=countrybean.countrycode%>"> 
<table cellspacing="0" cellpadding="0" border="0" width="650">
<tr>
  <td width=50>&nbsp;</td>
  <td>
	<table cellspacing="0" cellpadding="0" border="0" width="650" rules="none">
	<tr>
	    <td height="25" colspan="6" class='bgDark' align="center">
	    <span class="title"><%=countrybean.getTranslation("National Metadata Manager")%></span>
		</td>
	</tr>
	<tr><td colspan="6" height="5"></td></tr>
	<TR>
	<TD colspan="6" align="center"><span class="warning"><%=sErrorMessage%></span></TD>
	</TR>
	<tr><td colspan="6" height="5"></td></tr>
	<tr><td colspan="6" align="center">
	<SELECT name="metadata_key" style="WIDTH: 350px; HEIGHT: 166px" size='10'  onChange="return bSomethingSelected()">
	<inv:select tablename='metadata_national' selected='<%=metadata.metadata_key%>' connection='<%= con %>'
    	fieldname="<%=sDisplayField%>" codename='metadata_key' ordername='metadata_variable'
    	whereclause="<%=sWhere%>"
    	/>
    </SELECT><br>
    <%--  
	<input type="button" name="upEvent" value="<%=countrybean.getTranslation("upEvent")%>" onClick="event_up()">
	<input type="button" name="dnEvent" value="<%=countrybean.getTranslation("downEvent")%>" onClick="event_down()">
      --%>
	</td></tr>
	<tr><td colspan="6" height="25"></td></tr>
	<tr>
		<td colspan="6" align="center">
		<input type="submit" name="add" value="<%=countrybean.getTranslation("Add national metadata")%>">
		<input type="submit" name="edit" value="<%=countrybean.getTranslation("Edit national metadata")%>" onClick="return bSomethingSelected()">
		<input type="submit" name="delete" value="<%=countrybean.getTranslation("Delete national metadata")%>" onClick="return confirmDelete()">
		</td>
	</tr>
	<tr><td colspan="6" height="25"></td></tr>
	<tr>
		<td colspan="1" width="25%" height="25"></td>
		<td colspan="2" width="25%" align="center">
		<input type="submit" name="maintainAnnualData" id="annualdata" value="<%=countrybean.getTranslation("Maintain Annual Data")%>" style="display:none">
		</td>
		<td colspan="2" width="25%" align="center">
		<input type="submit" name="translateMetadata" id="translatedata" value="<%=countrybean.getTranslation("Translate meta data")%>" style="display:none">
		<td colspan="1" width="25%" height="25"></td>
		</td>
	</tr>
	</table>
  </td>
 </tr>
</table>
</form>
</body>
</html>
<% dbCon.close(); %>

