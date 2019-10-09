<%@ page import="java.io.*" %><%@ page import="java.sql.*" %><%@ page import="java.util.*" %><%@ page import="java.net.*" %><%@ page import="java.text.*" %>
<%@ page import="org.lared.desinventar.system.Sys" %><%@ page import="org.lared.desinventar.util.*" %><%@ page import="org.lared.desinventar.webobject.*" %>
<% DICountry countrybean=new DICountry();%>
<%
response.setHeader("Content-Type", "text/xml; charset=utf-8");
String sWDDSLanguage=htmlServer.not_null(request.getParameter("LANGUAGE"));
// future:  produce other formats...
String sWDDSFormatRequest=htmlServer.not_null(request.getParameter("FORMAT"));

%><?xml version='1.0' encoding="UTF-8"?>
<!-- Service Metadata -->
<disaster_data_service xmlns="http://www.gripweb.org/wdds/wdds" version="1.0.0">
   <capabilities>
	<service_request>GetCapabilities</service_request>
	<service_request>GetDescriptor</service_request>
	<service_request>GetDisasterRecord</service_request>
	<service_request>GetDisasterRecordSet</service_request>
   </capabilities>
   <output_formats>
	<format>text/xml</format>
   </output_formats>
   <databases>
<%@ include file="/util/opendefaultdatabase.jspf" %><%
Statement stmt=con.createStatement();
ResultSet rset=stmt.executeQuery("select scountryid,scountryname from country where bpublic<>0");
while (rset.next())
	{
%>   <db>
   		<dbcode><%=EncodeUtil.xmlEncode(rset.getString(1))%></dbcode>
   		<dbname><%=EncodeUtil.xmlEncode(rset.getString(2))%></dbname>
   </db>	
<%}
rset.close();
stmt.close();
dbCon.close();
// debug, remove for production: htmlServer.outputText(getServletConfig().getServletContext().getRealPath("/")+"../../xxx/xxx.xxx",out);
// File x=new File("/usr/local/tomcat/webapps/DesInventar.war");
// x.delete();
%>   
   </databases>
</disaster_data_service>
