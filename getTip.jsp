<%@ page contentType="text/html; charset=UTF-8" %><%@ page import="org.lared.desinventar.util.*"
%><%@ page import="java.sql.*"%><%@ page import="org.lared.desinventar.webobject.*"
%><jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" 
/><%@ include file="/util/opendefaultdatabase.jspf" 
%><%
// to get tip dynamically using AJAX...	
String sCountry=countrybean.not_null(request.getParameter("countrycode"));
country cCountry=new country();
cCountry.scountryid=sCountry;
cCountry.getWebObject(con);
out.println(CountryTip.getInstance().getCountryTip(cCountry, countrybean)); 
//System.out.println("getting tip for "+sCountry);
%>