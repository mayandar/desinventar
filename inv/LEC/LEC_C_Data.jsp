<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
    
    <head>
        <title>DesInventar on-line - Economic Valuation Utility</title>
    </head>
    
    <%@ page import = "org.lared.desinventar.util.dbConnection" %>
    <%@ page import = "org.lared.desinventar.webobject.users" %>
    <%@ page import = "org.lared.desinventar.util.*" %>
    <%@ page import = "org.lared.desinventar.webobject.*" %>
    <%@ page import = "java.sql.*" %>
    <%@ page import = "java.util.*" %>
    <%@ page import = "java.io.*" %>
    <%@ page import = "java.net.*" %>

    <jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
    <jsp:useBean id = "countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
    <jsp:useBean id = "Dictionary" class="org.lared.desinventar.webobject.diccionario" scope="session" />
    <jsp:useBean id = "woFicha" class="org.lared.desinventar.webobject.fichas" scope="session" />
    <jsp:useBean id = "woExtension" class="org.lared.desinventar.webobject.extension" scope="session" />

    <%@ taglib uri="../inventag.tld" prefix="inv" %>
    <%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
    
    <%if (user.iusertype<20) 
        {%>
            <jsp:forward page="noaccess.jsp"/>
        <%}%> 
    <%@ include file="/util/opendatabase.jspf" %>
	
    <link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
    
	<body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
		<p><a href="LEC_C.jsp">Volver al menú principal</a></p>
		
		<%
		/*
			if (request.getParameter("expXls")!=null && request.getParameter("expXls")!="") {
			} else if (request.getParameter("expSQL")!=null && request.getParameter("expSQL")!="") {
			} else if (request.getParameter("impXls")!=null && request.getParameter("impXls")!="") {
			}
		*/
		%>
		
		<p><a href="LEC_C_exportXML.jsp">Exportar afectación en XML con ID generado (Sin acumular por evento)</a></p>
		<p><a href="LEC_C_exportXML.jsp?acc=si">Exportar afectación en XML (Acumulando por evento)</a></p>
		<p><a href="LEC_C_exportSQL.jsp">Exportar tablas de configuración en SQL</a></p>
		<p>Importar tablas de configuración - pendiente !!!</p>
		
		
		
		
    </body>
</html>
<% dbCon.close(); %>
