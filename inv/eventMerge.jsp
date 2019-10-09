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
<% 
int nSqlResult =0;
String sErrorMessage="";
if (request.getParameter("doneMerging")!=null)
   {
	dbCon.close();
	%><jsp:forward page="eventManager.jsp"/><%
   }
if (request.getParameter("mergeEvent")!=null)
   {
	Event.nombre=request.getParameter("nombre");
	Event.getWebObject(con);
   }
   
if (request.getParameter("DO_mergeEvent")!=null)
   {
   String[] sSource=request.getParameterValues("fromevent");
   String sTarget=request.getParameter("toevent");
   PreparedStatement pstmt=null;
   int nUpdates=0;
   int nDelete=0;
   
   for (int nVar=0; nVar<sSource.length; nVar++)
   		{
	   try{
			pstmt=con.prepareStatement("update fichas set evento=?, di_comments=trim("+
					Event.dbHelper[countrybean.dbType].sqlConcat(
						Event.dbHelper[countrybean.dbType].sqlConcat(Event.dbHelper[countrybean.dbType].sqlNvl("di_comments","''"),"'  '"), "evento")+") where evento=?");
			pstmt.setString(1,sTarget);
			pstmt.setString(2,sSource[nVar]);
			nUpdates=pstmt.executeUpdate();
			pstmt.close();
	
			Event.nombre=sSource[nVar];
			Event.getWebObject(con);
			nDelete=Event.deleteWebObject(con);
			sErrorMessage+="<br>Merge operation results "+sSource[nVar]+" -> "+sTarget+", "+nUpdates+" datacards updated, "+nDelete+" event(s) record deleted";
			}
		catch (Exception merx)
			{
			/// what?
			sErrorMessage+="<br>ERROR merging: "+merx.toString();
			System.out.println("[DI10] ["+countrybean.countrycode+"] error merging  "+sSource[nVar]+"  "+sTarget+": "+merx.toString());
			}				
		}
 
   }

String sDisplayField="nombre";
if (countrybean.getDataLanguage().equals("EN"))
	sDisplayField="nombre_en";
%>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
 <body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>">  
<script language="JavaScript">
<!--
function bSomethingSelected()
{
if (document.desinventar.fromevent.selectedIndex==-1 || document.desinventar.toevent.selectedIndex==-1)
	{
	alert ("<%=countrybean.getTranslation("Pleaseselecta")%> <%=countrybean.getTranslation("Event")%> <%=countrybean.getTranslation("fromthelist")%>...");
	return false;
	} 
if (document.desinventar.fromevent.selectedIndex==document.desinventar.toevent.selectedIndex)
	{
	alert ("<%=countrybean.getTranslation("Merging events must be different than merged")%>");
	return false;
	} 
for (nSel=0; nSel<document.desinventar.fromevents.length; nSel++)
   if (document.desinventar.fromevents.options[nSel].selected)
		if (nSel==document.desinventar.toevent.selectedIndex)
			{
			alert ("<%=countrybean.getTranslation("Merging events must be different than merged")%>");
			return false;
			}
return true;
}


function bAreYourSure()
{
return confirm ("Are you sure - this will translate your database events to English, cannot be undone...");
}

// -->
</script>

<FORM name="desinventar" method="post" action="eventMerge.jsp">
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
	<tr><td><strong><%=countrybean.getTranslation("Convert this event:")%></strong></td><td><strong><%=countrybean.getTranslation("INTO this event:")%></strong></td></tr>
	<tr><td align="center">
	<SELECT name="fromevent" multiple style="WIDTH: 350px; HEIGHT: 166px" size=10>
	<inv:select tablename='eventos' selected='<%=Event.nombre%>' connection='<%= con %>'
    	fieldname="<%=sDisplayField%>" codename='nombre' ordername='nombre'/>
    </SELECT>
	</td><td align="center">
	<SELECT name="toevent" style="WIDTH: 350px; HEIGHT: 166px" size=10>
	<inv:select tablename='eventos' selected='<%="none"%>' connection='<%= con %>'
    	fieldname="<%=sDisplayField%>" codename='nombre' ordername='nombre'/>
    </SELECT>
	</td></tr>
	<tr><td colspan="2" height="25"></td></tr>
	<tr><td colspan="2" align="center">
	<input type="submit" name="DO_mergeEvent" value="<%=countrybean.getTranslation("Merge")%>" onClick="return bSomethingSelected()">
	<input name="doneMerging" type=submit value='<%=countrybean.getTranslation("Done")%>'>
	</td></tr>
	</table>
  </td>
 </tr>
</table>
</form>
</body>
</html>
<% dbCon.close(); %>

