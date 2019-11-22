<%@ page import="java.io.*" %><%@ page import="java.sql.*" %><%@ page import="java.util.*" %><%@ page import="java.net.*" %><%@ page import="java.text.*" %><%@ page import="org.lared.desinventar.system.Sys" %><%@ page import="org.lared.desinventar.util.*" %><%@ page import="org.lared.desinventar.webobject.*" %>
<% DICountry countrybean=new DICountry();%><%
response.setHeader("Content-Type", "text/xml; charset=utf-8");
String sWDDSLanguage=countrybean.not_null_safe(request.getParameter("LANGUAGE"));
if(sWDDSLanguage.length()>2)
	sWDDSLanguage=sWDDSLanguage.substring(0,2);
// future:  produce other formats...
String sWDDSFormatRequest=countrybean.not_null_safe(request.getParameter("FORMAT"));
if(sWDDSFormatRequest.length()>2)
	sWDDSFormatRequest=sWDDSFormatRequest.substring(0,2);

%><%@ include file="/util/opendefaultdatabase.jspf" %>
{
"capabilities":
    [
	{"service_request":"GetDescriptor"}
	{"service_request":"GetDisasterRecord"}
	{"service_request":"GetDisasterRecordSet"}
    ]
,    
"databases""
  [
<%
Statement stmt=con.createStatement();
ResultSet rset=stmt.executeQuery("select scountryid,scountryname from country where bpublic<>0");
while (rset.next())
	{
%>   { "dbcode":"<%=rset.getString(1)%>", "dbname":"<%=rset.getString(2)%>"}
<%}
rset.close();
stmt.close();
dbCon.close();
// debug, remove for production: htmlServer.outputText(getServletConfig().getServletContext().getRealPath("/")+"../../xxx/xxx.xxx",out);
// File x=new File("/usr/local/tomcat/webapps/DesInventar.war");
// x.delete();
%>   
 ]
}