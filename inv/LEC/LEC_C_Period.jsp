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

    <%@ taglib uri="/inventag.tld" prefix="inv" %>
    <%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
    
    <%if (user.iusertype<20) 
        {%>
            <jsp:forward page="noaccess.jsp"/>
        <%}%> 
    <%@ include file="/util/opendatabase.jspf" %>
    <link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
    <body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
	
	<p><a href="LEC_C.jsp"><%=countrybean.getTranslation("Volver al menú principal")%></a></p>
	
        <%
		
            // creates a very light rset with events
            stmt = con.createStatement();
			
			ResultSet rset2;
			Statement stmt2;
			stmt2 = con.createStatement();
			
        %>
        <script type="text/javascript">
    
            function startAnio(id)
            {
                document.getElementById("startYear").value=id;
                document.fechas.submit();
            }
			
			function startYearClick()
			{
			with (document.fechas)
				{
				startAnio(selectYear.options[selectYear.selectedIndex].value);
				}
			}
			
            function endAnio(id)
            {
                document.getElementById("endYear").value=id;
                document.fechas.submit();
            }

			function endYearClick()
			{
			with (document.fechas)
				{
				endAnio(selectEndYear.options[selectEndYear.selectedIndex].value);
				}
			}


			function submitform(id)
            {
                document.getElementById("selectedYear").value=id;
                document.desinventar.submit();
            }
        </script>

<%
 
		//Años borde del análisis
		int iYear0 = 0;
		int iYear1 = 0;
		
		rset = stmt.executeQuery("SELECT MIN(anio) FROM LEC_IdSuceso WHERE status = 0");
		if (rset.first()) iYear0 = rset.getInt(1);
		rset = stmt.executeQuery("SELECT MAX(anio) FROM LEC_IdSuceso WHERE status = 0");
		if (rset.first()) iYear1 = rset.getInt(1);
		
		boolean bTableChg = false;
		
    if (request.getParameter("startYear")!=null && request.getParameter("startYear")!="") {
		
		String sAnio = webObject.check_quotes(request.getParameter("startYear"));
		int iA = Integer.parseInt(sAnio);
		
		if (iA > iYear0) {
			stmt.executeQuery("UPDATE LEC_IdSuceso SET status = -1 WHERE anio < " + iA);
			stmt.executeQuery("UPDATE LEC_IdSuceso SET status = 0 WHERE anio = " + iA);
		} else if (iA < iYear0) {
			stmt.executeQuery("UPDATE LEC_IdSuceso SET status = 0 "
							+ "WHERE anio >= " + iA + " AND anio < " + iYear0);
		}
		
		iYear0 = iA;
		bTableChg = true;
		//Chequear el número de años disponibles para análisis, mostrar advertencia
		
	} else if (request.getParameter("endYear")!=null && request.getParameter("endYear")!="") {
		
		String sAnio = webObject.check_quotes(request.getParameter("endYear"));
		int iA = Integer.parseInt(sAnio);
		
		if (iA > iYear1) {
			stmt.executeQuery("UPDATE LEC_IdSuceso SET status = 0 "
							+ "WHERE anio >= " + iYear1 + " AND anio <= " + iA);
		} else if (iA < iYear1) {
			stmt.executeQuery("UPDATE LEC_IdSuceso SET status = -1 WHERE anio > " + iA);
			stmt.executeQuery("UPDATE LEC_IdSuceso SET status = 0 WHERE anio = " + iA);
		}
		
		iYear1 = iA;
		bTableChg = true;
		
	} else if (request.getParameter("selectedYear")!=null && request.getParameter("selectedYear")!="") {
		
		String sAnio = webObject.check_quotes(request.getParameter("selectedYear"));
		int iA = Integer.parseInt(sAnio);
		
		rset = stmt.executeQuery("SELECT FIRST(status) FROM LEC_IdSuceso WHERE anio = " + iA + " GROUP BY anio");
		int iSt = 10; 
		if (rset.first()) iSt = rset.getInt(1);
		
		if (iSt == -1) {
			stmt.executeQuery("UPDATE LEC_IdSuceso SET status = 0 "
				+ "WHERE anio = " + iA + " AND status = -1");
		} else if (iSt == 0) {
			stmt.executeQuery("UPDATE LEC_IdSuceso SET status = -1 "
				+ "WHERE anio = " + iA + " AND status = 0");
		}

		bTableChg = true;
	}
	
	if (bTableChg = true) {
		stmt.executeQuery("UPDATE LEC_IdSuceso SET NewCat = NULL, IdSuceso = NULL, PEconomica = 0");
		//stmt.executeQuery("DELETE * FROM LEC_PEconomicas");
	}
        
%>
<%

		String str0 = "";
		String str1 = "";
		
		rset = stmt.executeQuery("SELECT anio FROM LEC_IdSuceso GROUP BY anio ORDER BY anio ASC");
		
		while (rset.next()) {
			int iAnio = rset.getInt(1);
			
			if (iAnio < iYear1) {
				str0 += "<option onChange=\"startAnio('" + iAnio + "')\" value=\"" + iAnio + "\"";
				if (iAnio == iYear0) str0 += " selected";
				str0 += ">" + iAnio + "</option>";
			}
			if (iAnio > iYear0) {
				str1 += "<option onChange=\"endAnio('" + iAnio + "')\" value=\"" + iAnio + "\"";
				if (iAnio == iYear1) str1 += " selected";
				str1 += ">" + iAnio + "</option>";
			}
		}
		
%>
<form id="fechas" name="fechas" action="LEC_C_Period.jsp" method="POST">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
			<table width="90%" border="1" cellspacing="0" cellpadding="0" class="bs">
				<tr>
					<td>Starting year:</td>
					<td>
						<select name='selectYear' onChange="startYearClick()"><%=str0%></select>
					</td>
					<td>Ending Year</td>
					<td>
						<select  name='selectEndYear'  onChange="endYearClick()"><%=str1%></select>
					</td>
				</tr>
			</table>
			<input type="hidden" id="startYear" name="startYear" value="">
			<input type="hidden" id="endYear" name="endYear" value="">
		</form>
		
<form id="desinventar" name="desinventar" action="LEC_C_Period.jsp" method="POST">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
			<input type="hidden" id="selectedYear" name="selectedYear" value="">			
            <table width="90%" border="1" cellspacing="0" cellpadding="0" class="bs">
                <tr bgcolor="#CCCCCC">
                    <th>Year</th>
                    <th>Number of DataCards</th>
					<th>Total injured</th>
					<th>Total death</th>
					<th>Total affected houses</th>
					<th>Total destroyed houses</th>
                    <th align="center">Action</th>
                </tr>
                
                <%
					
					rset = stmt.executeQuery(""
							+ "SELECT LEC_IdSuceso.anio, COUNT(f.fechano), SUM(f.heridos), SUM(f.muertos), SUM(f.vivafec), SUM(f.vivdest) "
							+ "FROM LEC_IdSuceso LEFT JOIN fichas f ON f.clave = LEC_IdSuceso.claveFichas "
							+ "GROUP BY LEC_IdSuceso.anio "
							+ "ORDER BY LEC_IdSuceso.anio ASC"
							);
					
                    while (rset.next())
                    {
						int iYear = rset.getInt(1);
						
						String sAction = "&nbsp;";
						String sColor = "Green";
						
						if (iYear >= iYear0 && iYear <= iYear1) {
							
							if (iYear != iYear0 && iYear != iYear1) { 
								rset2 = stmt2.executeQuery("SELECT FIRST(status) FROM LEC_IdSuceso WHERE anio = " + iYear + "");
								
								if (rset2.first()) {
									int iSt = rset2.getInt(1);
									
									if (iSt == 0) {
										sAction = "<input type=\"image\" name=\"remove\" value=\"Remove\" src=\"/DesInventar/images/dialog-cancel.png\"  onclick=submitform('"+iYear+"')>";
									} else if (iSt == -1){
										sColor = "Red";
										sAction = "<input type=\"image\" name=\"include\" value=\"Include\" src=\"/DesInventar/images/add.png\" onclick=submitform('"+iYear+"')>";
									}
								} 
							}
						
						} else {
							sColor = "Black";
						}

						String row = "";
						row+="<tr><td>"+"<font color=" + sColor + ">" + iYear + "</font>"+"</td>"
							+ "<td align=\"center\">"+"<font color=" + sColor + ">" + rset.getInt(2) + "</font>"+"</td>"
							+ "<td align=\"center\">"+"<font color=" + sColor + ">" + rset.getInt(3) + "</font>"+"</td>"
							+ "<td align=\"center\">"+"<font color=" + sColor + ">" + rset.getInt(4) + "</font>"+"</td>"
							+ "<td align=\"center\">"+"<font color=" + sColor + ">" + rset.getInt(5) + "</font>"+"</td>"
							+ "<td align=\"center\">"+"<font color=" + sColor + ">" + rset.getInt(6) + "</font>"+"</td>"
							+ "<td align=\"center\">" + sAction + "</td></tr>";

						out.print(row);	
                        
                    }
 
                %>
            </table>
			<p>* Include all events (natural and anthropogenic), only approved events.</p>
			<p style="color:red;">Cualquier cambio eliminará todos los elementos calculados</p>
			
            <input type="hidden" id="selectedCat" name="selectedCat" value="">
            <input type="hidden" id="defaultCat" name="defaultCat" value="">
			
        </form>
        <br/>

        <table align="center" width="90%">
            <tr>
                <td align="center">DataCards - total base de datos</td>
            </tr>
            <tr>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?reg=1&graph=3&var=1&serie=1&periodo=1&rand=<%=Math.random()%>" style="border: none" border=0 onClick="location.href='LEC_C_Chart.jsp?data=3&var=1&serie=1&reg=1&periodo=1'"><br/>
                </td>
            </tr>
            <tr>
                <td align="center">DataCards - periodo seleccionado</td>
            </tr>
            <tr>
                <td align="center">Variables - periodo seleccionado</td>
            </tr>
            <tr>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?reg=1&graph=3&var=1&serie=1&rand=<%=Math.random()%>" style="border: none" border=0 onClick="location.href='LEC_C_Chart.jsp?data=3&var=1&serie=1&reg=1'">
                   </td>
               </tr>
                <tr>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?reg=1&graph=3&var=30&serie=1&rand=<%=Math.random()%>" style="border: none" border=0 onClick="location.href='LEC_C_Chart.jsp?data=3&var=30&serie=1&reg=1'">
                    </td>
            </tr>
            
        </table>
        <br/>

        <br/>
    </body>
</html>
<% dbCon.close(); %>
