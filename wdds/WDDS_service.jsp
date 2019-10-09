<%@ page import="java.io.*" %><%@ page import="java.sql.*" %><%@ page import="java.util.*" %><%@ page import="java.net.*" %><%@ page import="java.text.*" %>
<%@ page import="org.lared.desinventar.system.Sys" %><%@ page import="org.lared.desinventar.util.*" %><%@ page import="org.lared.desinventar.webobject.*" %>
<% DICountry countrybean=new DICountry();%>
<%
    
    String sWDDSrequest=htmlServer.not_null(request.getParameter("REQUEST"));
    String sWDDSservice=htmlServer.not_null(request.getParameter("SERVICE"));
    String sWDDSVersionRequest=htmlServer.not_null(request.getParameter("VERSION"));
     
    if (sWDDSservice.equalsIgnoreCase("wdds"))
    {
    	if (sWDDSrequest.equalsIgnoreCase("GetCapabilities"))
    	{
		%><jsp:forward page="WDDS_capabilities.jsp"/><%
    	}
    	else if (sWDDSrequest.equalsIgnoreCase("GetDescriptor"))
    	{
    	%><jsp:forward page="WDDS_descriptor.jsp"/><%
    	}
    	else if (sWDDSrequest.equalsIgnoreCase("GetDisasterRecord"))
    	{
    	%><jsp:forward page="WDDS_get_record.jsp"/><%
    	}
    	else if (sWDDSrequest.equalsIgnoreCase("GetDisasterRecordSet"))
    	{
    	%><jsp:forward page="WDDS_get_recordset.jsp"/><%
    	}
	else
		{
		response.setHeader("Content-Type", "text/xml; charset=utf-8");
		%><?xml version="1.0" encoding="UTF-8"?>
		<disaster_database_exception>
			<!-- Disaster Database Error -->
			<error_description>	Unrecognized WDDS REQUEST parameter:  <%=sWDDSrequest%></error_description>
		</disaster_database_exception>
		<%} 
    }  
else
{
response.setHeader("Content-Type", "text/xml; charset=utf-8");
%><?xml version="1.0" encoding="UTF-8"?>
<disaster_database_exception>
	<!-- Disaster Database Error -->
	<error_description>	Unrecognized SERVICE request:  <%=sWDDSservice%></error_description>
</disaster_database_exception>
<%}%>	