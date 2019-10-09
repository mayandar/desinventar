<%@ page info="DesConsultar geocode server" session="true" %><%@ page import="java.sql.*"%><%@ page import="org.lared.desinventar.util.*" %><jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" /><jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" /><%
response.setHeader("Pragma", "no-cache");
response.setHeader("Cache-Control", "no-cache");
response.setDateHeader("Expires", 0);	
%><%@ include file="/util/opendatabase.jspf" %><%
// Query the account name & password
String sImageId=request.getParameter("imedia");
if (sImageId==null)
  sImageId="-1";
  
String sSql = "delete from media_file where imedia=?";		
PreparedStatement pstmt = con.prepareStatement(sSql);
pstmt.setInt(1,Integer.parseInt(sImageId));
pstmt.executeQuery();

// HERE:  it maybe should also delete the uploaded file...

out.print("%%OK%%\n");
// releases the statement
pstmt.close();
// returns the connection to the pool
dbCon.close();
%>
