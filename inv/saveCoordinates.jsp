<?xml version="1.0"  encoding="UTF-8" ?>
<%@ page import="java.io.*" %><%@ page import="java.sql.*" %><%@ page import="java.util.*" %><%@ page import="java.text.*" %><%@ page import="org.lared.desinventar.system.Sys" %><%@ page import="org.lared.desinventar.util.*" %><%@ page import="org.lared.desinventar.webobject.*" %><jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" /><jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<%@ include file="/util/opendatabase.jspf" %>
<DESINVENTAR_GEOCODE_RESULT>
<%
String sSql="";
try	{
    String sLat=request.getParameter("latitude");
    String sLon=request.getParameter("longitude");
    String sKey=request.getParameter("key");
	stmt=con.createStatement();
    sSql="update fichas set latitude="+sLat+", longitude="+sLon+" where clave="+sKey;
	// System.out.print("SQL="+sSql);
	stmt.executeUpdate(sSql);
	out.println("OK");
	//System.out.println("...OK");
	}
catch(Exception ex1)
	{
	out.println("ERROR saving geocodes : "+ex1.toString()+" ||| "+sSql);
	}
try{
	stmt.close();
   }
catch(Exception ex1)
	{
	}

dbCon.close();
%></DESINVENTAR_GEOCODE_RESULT>
