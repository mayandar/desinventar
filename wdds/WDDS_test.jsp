<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>DesConsultar on-line WDDS test-demo page</title>
</head>
<%@ page info="front page of DesConsultar On-Line" session="true" %> 
<%@ page import="java.sql.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.map.*" %>
<%@ page import="org.lared.desinventar.system.Sys" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%
String sLang="EN";
if (request.getParameter("lang")!=null)
	sLang=request.getParameter("lang");

htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/header",sLang,out);%>
 
<table cellpadding="2" cellspacing="2" width="800">
<tr><td align="left"><h3>WDDS  test/demo page</h3></td></tr>
<tr><td>Risk identification is one of five priority areas in the Hyogo Framework for Action, a principal vehicle for international cooperation 
on disaster reduction. One of the key activities that comprise risk identification is the systematic collection 
of an evidence base on disaster-related losses in the form of Disaster databases.<br/>
<br/>
Historical loss data collection is necessary not only for risk assessment but also for measuring progress 
towards achieving the expected outcome of the Hyogo Framework of Action - the substantial reduction of disaster losses.<br/> 
<br/>
In order to provide governments, researchers, academicians and in general the international community<br/>
 the opportunity to use and leverage existing indicators about historical loss data in different
 regions of the world, the Global Risk Identification programme has promoted the idea of producing a series 
 of recommendations in the form of Disaster Database Standards.<br/>
<br/>
Links in this page showcase how the standard works, based on its implementation on DesInventar Server 9.2.11.<br>
<br>
The base address for the service in DesInventar is <a href="#">/DesInventar/wdds/WDDS_service.jsp</a>

<br>
Please see additional notes at the bottom of the page, and note links will open in a new window which may be sent back when you come back to this page.<br> 
</td></tr>
<tr><td>
<br/>
<br/>
<a target='otherWin' href="/DesInventar/wdds/WDDS_service.jsp?SERVICE=wdds&REQUEST=getCapabilities&VERSION=1.0.0">REQUEST: GetCapabilities</a><br/>
<br/>
<a target='otherWin' href="/DesInventar/wdds/WDDS_service.jsp?SERVICE=wdds&REQUEST=GetDescriptor&VERSION=1.0.0&countrycode=co">REQUEST: GetDescriptor of a database (Colombia)</a><br/>
<br/>
<a target='otherWin' href="/DesInventar/wdds/WDDS_service.jsp?SERVICE=wdds&REQUEST=GetDisasterRecord&VERSION=1.0.0&countrycode=co&INTERNAL=1990-0247">REQUEST: GetDisasterRecord (Colombia, record with id=1990-0247)</a><br/>
<br/>
<a target='otherWin' href="/DesInventar/wdds/WDDS_service.jsp?SERVICE=wdds&REQUEST=GetDisasterRecordSet&VERSION=1.0.0&countrycode=co&EVENTS=LS&GEOCODES=11&LEVEL=1">REQUEST: GetDisasterRecordSet (Colombia, Landslides in Bogota, from year 2000 )</a><br/>
<br/>
</td></tr>
<tr><td></td></tr>
<tr><td><h4>About this implementation:</h4><br/>
<ul>
<li>As this is still version 1.0.0 there is no version negotiation yet. Will be added in the near future.</li>
<li>XML schema definitions will be made available soon as per the XML file headers</li>
<li>No aggregation yet. Please come again and check for it soon.</li>
</ul>

</td></tr>
</table>

<br>
     <A  class="linkText" href="/DesInventar/index.jsp" class='linkText'><%=countrybean.getTranslation("Home")%></a>
<br>

<%@ include file="/html/footer.html" %> 
</body>
</html>
