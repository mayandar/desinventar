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
	
	<%
		
		// creates a very light rset with events
		stmt = con.createStatement();
		
		ResultSet rset2;
		Statement stmt2;
		stmt2 = con.createStatement();
		
		//Copio los ids de los eventos de la tabla fichas en la tabla propia LEC_IdSuceso
		rset = stmt.executeQuery("SELECT * FROM LEC_IdSuceso");
		if (! rset.first()) {
			stmt.executeQuery("INSERT INTO LEC_IdSuceso (claveFichas, anio, Cause) "
				+ "SELECT fichas.clave, fichas.fechano, fichas.evento "
				+ "FROM fichas "
				+ "WHERE fichas.approved = 0 "
				+ "ORDER BY fichas.fechano, fichas.fechames, fichas.fechadia, fichas.clave"
				);
				
			//fecha
			//http://www.sql-und-xml.de/sql-tutorial/update-aktualisieren-der-zeilen.html
			stmt.executeQuery("UPDATE LEC_IdSuceso LEFT JOIN fichas "
							+ "ON LEC_IdSuceso.claveFichas = fichas.clave "
							+ "SET LEC_IdSuceso.fecha = " 
							+ "dateadd('d',fichas.fechadia - 1,dateadd('m',fichas.fechames - 1,dateadd('yyyy',fichas.fechano - 1900,'1900-01-01')))"
							);
							
			//test: select *, fichas.fechano, fichas.fechames, fichas.fechadia from LEC_IdSuceso Left join fichas ON fichas.clave = LEC_IdSuceso.claveFichas
				
			//status: 0 = ok, -1 = fecha no en el rango de análisis
			stmt.executeQuery("UPDATE LEC_IdSuceso SET status = 0, PEconomica = 0");
		}
		
		//TODO: Opción para reiniciar las tablas? 
		
	%>
		<p>Indicé</p>
		<p><a href="LEC_C_Period.jsp">Definir periodo de análisis</a></p>
		<p><a href="LEC_C_Categories.jsp">Definir categorías</a></p>
		<p><a href="LEC_C_CausesGrouping.jsp">Asignar causas (amenazas) en categorías</a></p>
		<p><a href="LEC_C_TimeLapse.jsp">Definir lapsos de tiempo de agrupación</a></p>
		<p><a href="LEC_C_CostosUnitarios.jsp">Definir valores unitarios de variables y generar CEP</a></p>
		<p><a href="LEC_C_Data.jsp">Importar y exportar data</a></p>
		
    </body>
</html>
<% dbCon.close(); %>
