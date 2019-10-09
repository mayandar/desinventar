<?xml version="1.0"  encoding="UTF-8" ?>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="org.lared.desinventar.util.DICountry" %> 
<%@ page import="org.lared.desinventar.util.htmlServer" %>
<%@ page import="org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.system.Sys" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<%@ include file="/util/opendefaultdatabase.jspf" %>
<DESINVENTAR>
<%
DownloadTable downloadTable = new DownloadTable();
ServletContext sc = getServletConfig().getServletContext();
String sTablename = request.getParameter("table");
String sCountry = request.getParameter("country");
String sVariable = request.getParameter("variable");
String sIndicatorkey = request.getParameter("indicator_key");
String sElementkey = request.getParameter("element_key");
int action=webObject.extendedParseInt(request.getParameter("action"));

response.setContentType("application/xml");
response.setHeader("Content-Type", "application/xml; charset=utf-8");

String whereClause = (sCountry == null || sCountry.isEmpty()) ? "" : " where scountryid='"+sCountry+"'"; // For country table only

try	{
	if(sTablename == null || sTablename.isEmpty()){
		switch(action){
		case 1:
			// For metadata_national tables
			whereClause = " where metadata_country='"+sCountry+"'"; 
			downloadTable.outputTable ("metadata_national", out, con, whereClause);
			downloadTable.outputTable ("metadata_national_values", out, con, whereClause);
			downloadTable.outputTable ("metadata_national_lang", out, con, whereClause);
			break;
		case 2:
			// For metadata_national_values table
			whereClause =" where metadata_country='"+sCountry+"'"
						+" and metadata_key="+sVariable; 
			downloadTable.outputTable ("metadata_national_values", out, con, whereClause);
			break;
		case 3:
			// For metadata_element tables
			whereClause = " where metadata_country='"+sCountry+"'"; 
			downloadTable.outputTable ("metadata_element", out, con, whereClause);
			downloadTable.outputTable ("metadata_element_lang", out, con, whereClause);
			downloadTable.outputTable ("metadata_element_costs", out, con, whereClause);
			break;
		case 4:
			// For metadata_element table with country, indicator
			whereClause = " where metadata_element.metadata_country='"+sCountry+"'"
						+ "	and metadata_element.metadata_element_key=metadata_element_indicator.metadata_element_key"
						+ " and metadata_element_indicator.metadata_country=metadata_element.metadata_country"
						+ " and metadata_element_indicator.indicator_key="+sIndicatorkey; 

			downloadTable.outputTable ("metadata_element", "metadata_element_indicator", out, con, whereClause);

			whereClause = " where metadata_element_lang.metadata_country='"+sCountry+"'"
					+ "	and metadata_element_lang.metadata_element_key=metadata_element_indicator.metadata_element_key"
					+ " and metadata_element_indicator.metadata_country=metadata_element_lang.metadata_country"
					+ " and metadata_element_indicator.indicator_key="+sIndicatorkey; 
			downloadTable.outputTable ("metadata_element_lang", "metadata_element_indicator", out, con, whereClause);
			
			whereClause = " where metadata_element_costs.metadata_country='"+sCountry+"'"
					+ "	and metadata_element_costs.metadata_element_key=metadata_element_indicator.metadata_element_key"
					+ " and metadata_element_indicator.metadata_country=metadata_element_costs.metadata_country"
					+ " and metadata_element_indicator.indicator_key="+sIndicatorkey; 
			downloadTable.outputTable ("metadata_element_costs", "metadata_element_indicator", out, con, whereClause);
			break;
		case 5:
			// For metadata_national_values table
			whereClause = " where metadata_element_key="+sElementkey+ "	and metadata_country='"+sCountry+"'"; 
			downloadTable.outputTable ("metadata_element_costs", out, con, whereClause);
			break;
		}
	}
	else {  // For test with country table
		downloadTable.outputTable (sTablename, out, con, whereClause);
	}
}
catch(Exception ex1)
{
	out.println("<!-- Error in XML export: "+ex1.toString()+" -->");
}	

dbCon.close();
%></DESINVENTAR>
