<%@ page import="java.io.*" %><%@ page import="java.sql.*" %><%@ page import="java.util.*" %><%@ page import="java.net.*" %><%@ page import="java.text.*" %>
<%@ page import="org.lared.desinventar.system.Sys" %><%@ page import="org.lared.desinventar.util.*" %><%@ page import="org.lared.desinventar.webobject.*" %>
<% DICountry countrybean=new DICountry();%>
<%
    
    String sJSONrequest=htmlServer.not_null(request.getParameter("REQUEST"));
    String sJSONservice=htmlServer.not_null(request.getParameter("SERVICE"));
    String sJSONVersionRequest=htmlServer.not_null(request.getParameter("VERSION"));
     
    if (sJSONservice.equalsIgnoreCase("json"))
    {
    	if (sJSONrequest.equalsIgnoreCase("GetCapabilities"))
    	{
		%><jsp:forward page="json_capabilities.jsp"/><%
    	}
    	else if (sJSONrequest.equalsIgnoreCase("GetDescriptor"))
    	{
    	%><jsp:forward page="json_descriptor.jsp"/><%
    	}
    	else if (sJSONrequest.equalsIgnoreCase("GetDisasterRecord"))
    	{
    	%><jsp:forward page="json_get_record.jsp"/><%
    	}
    	else if (sJSONrequest.equalsIgnoreCase("GetDisasterRecordSet"))
    	{
    	%><jsp:forward page="json_get_recordset.jsp"/><%
    	}
	else
		{
		response.setHeader("Content-Type", "text/xml; charset=utf-8");
		%><?xml version="1.0" encoding="UTF-8"?>
		<disaster_database_exception>
			<!-- Disaster Database Error -->
			<error_description>	Unrecognized JSON REQUEST parameter:  <%=sJSONrequest%></error_description>
		</disaster_database_exception>
		<%} 
    }  
else
{
response.setHeader("Content-Type", "text/xml; charset=utf-8");
%><?xml version="1.0" encoding="UTF-8"?>
<disaster_database_exception>
	<!-- Disaster Database Error -->
	<error_description>	Unrecognized SERVICE request:  <%=sJSONservice%></error_description>
</disaster_database_exception>
<%}%>	