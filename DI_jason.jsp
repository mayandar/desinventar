<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "https://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.fichas" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%@ include file="/util/opendatabase.jspf" %>
<%
    JSONObject object = new JSONObject();
 
    object.put("name",countrybean.countryname);
    object.put("iso",countrybean.countrycode);
    object.put("int", new Integer(12345));
    object.put("Mark", new Double(99));
    object.put("mail", "deepa@ebullitent.com");
    object.put("City", "Chennai");

 
/*
    int length = 1000; //object.length();
    String opt = object.optString("name");
    boolean data = false; //object.isNull("name");
    String getMark = object.getString("Mark");
    String getCity = (String) object.get("City");
    boolean mail = object.has("mail");
    //object.append("mark1","98");
*/
    out.println(object);
%>
 

