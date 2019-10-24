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
            // creates a very light rset with events
            stmt = con.createStatement();
			
			ResultSet rset2;
			Statement stmt2;
			stmt2 = con.createStatement();
        %>
        <script type="text/javascript">
            function selectCat(eventName,catName){
                document.getElementById("selectedEvent").value=eventName;
                document.getElementById("selectedCategory").value=catName;
                document.eventForm.submit();
            }
        </script>

    <%    

    if(request.getParameter("selectedEvent")!=null && request.getParameter("selectedEvent")!=""){

        String causeName=webObject.check_quotes(request.getParameter("selectedEvent"));
        String catName=webObject.check_quotes(request.getParameter("selectedCategory"));

        if (catName.toLowerCase().equals("default")){
			stmt.executeQuery("UPDATE LEC_IdSuceso SET OldCat = NULL WHERE Cause = '" + causeName + "'");
        } else {
			stmt.executeQuery("UPDATE LEC_IdSuceso SET OldCat = '" + catName + "' WHERE Cause = '" + causeName + "'");
        }		
		
		stmt.executeQuery("UPDATE LEC_IdSuceso SET NewCat = NULL, IdSuceso = NULL, PEconomica = 0");
		//stmt.executeQuery("DELETE * FROM LEC_PEconomicas");
		
    }

    %>
         
        <form id="eventForm" name="eventForm" action="LEC_C_CausesGrouping.jsp" method="POST">
		<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
            <table width="90%" border="1" cellspacing="0" cellpadding="0" class="bs">
				
                <tr bgcolor="#CCCCCC">
                    <th>Cause</th>   
                    <th>Cause(English) </th>
                    <th>N Events</th>
					<th>Injured</th>
					<th>Deaths</th>
					<th>Affected houses</th>
					<th>Destroyed houses</th>
                    <th>Category relate</th>
					<th>Change category</th>
                </tr>
                
                <%
                    ArrayList cat2;
                    cat2 = new ArrayList();
                    cat2.add("default");
                    
                    rset=stmt.executeQuery("SELECT Category FROM LEC_Categories");
                    while(rset.next()){
                        cat2.add(rset.getString(1));
                    }
                    
                    //get the events
					rset = stmt.executeQuery(""
							+ "SELECT Cause, COUNT(*),  SUM(f.heridos), SUM(f.muertos), SUM(f.vivafec), SUM(f.vivdest) "
							+ "FROM LEC_IdSuceso LEFT JOIN fichas f ON f.clave = LEC_IdSuceso.claveFichas "
							+ "WHERE status = 0 "
							+ "GROUP BY Cause "
							+ "ORDER BY Cause ASC"
							);
					
                    while(rset.next()){
                        String sName=rset.getString(1);
						
						String sName_en="";
						rset2 = stmt2.executeQuery("SELECT nombre_en FROM eventos WHERE nombre = '" + sName + "'");
                        if (rset2.first()) sName_en = rset2.getString(1);
						
						
                        String sCat="";
						rset2 = stmt2.executeQuery("SELECT FIRST(OldCat) FROM LEC_IdSuceso WHERE Cause = '" + sName + "'");
						if (rset2.first()) sCat = rset2.getString(1);
						
						String sTotRow = "<td align=\"center\">" + rset.getString(2) + "</td>"
										+ "<td align=\"center\">" + rset.getString(3) + "</td>"
										+ "<td align=\"center\">" + rset.getString(4) + "</td>"
										+ "<td align=\"center\">" + rset.getString(5) + "</td>"
										+ "<td align=\"center\">" + rset.getString(6) + "</td>";
						
                        if (sName_en == null || sName_en.length()==0)
                          sName_en=sName;
                        
                        boolean bFound=true;
                        String catColor = "black";
                        
                        if (sCat==null){
                            sCat="default";
                            bFound=false;                    
                            catColor = "red";
                        }
                        
                        String sOption = "";
                        for(int i = 0; i < cat2.size(); i++){
                            sOption += "<option onclick=\"selectCat('" + sName + "','" + cat2.get(i) + "')\" value='" + cat2.get(i) + "'";
                            if(cat2.get(i).equals(sCat)) sOption += " selected";
                            sOption += ">" + cat2.get(i) + "</option>";
                        }
                        
                        out.print("<tr>"
                                + "<td>" + sName + "</td>"
                                + "<td>" + sName_en + "</td>"
								+ sTotRow);
						
						if (sCat.equals("default")) out.print("<td>" + "&nbsp;" + "</td>"); else out.print("<td>" + sCat + "</td>");
								
                        out.print("<td align=\"center\">"
									+ "<select style=\"color:" + catColor + "\" name='category'>"
									+ sOption + "</select>"
                                + "</td>"
                                + "</tr>" 
                                );
                        }
                    %>
            </table>
			
			<p>En los graficos y procesos posteriores solo se emplean los eventos asignados a una categoría</p>
			<p style="color:red;">Cualquier cambio eliminará todos los elementos calculados</p>
			
            <input type="hidden" id="selectedEvent" name="selectedEvent" value="">
            <input type="hidden" id="selectedCategory" name="selectedCategory" value="">
        </form>
        <br>

        <p></p>
        <table align="center" width="90%">
            <tr>
                <td align="center">DataCards</td>
                <td align="center">DataCards por categoría</td>
            </tr>
            <tr>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=1&var=1&serie=1&spc=1" style="border: none" border=0 onClick="location.href='LEC_C_Chart.jsp?data=1&var=1&serie=1&spc=1'"><br/>
                    </td>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=1&var=1&serie=2" style="border: none" border=0 onClick="location.href='LEC_C_Chart.jsp?data=1&var=1&serie=2'">
                    </td>
            </tr>
            
            <tr>
                <td align="center">Heridos por categoría</td>
                <td align="center">Muertos por categoría</td>
            </tr>
            <tr>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=1&var=2&serie=2" style="border: none" border=0 onClick="location.href='LEC_C_Chart.jsp?data=1&var=2&serie=2'">
                    </td>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=1&var=4&serie=2" style="border: none" border=0 onClick="location.href='LEC_C_Chart.jsp?data=1&var=4&serie=2'">
                    </td>
            </tr>
            
            <tr>
                <td align="center">Viviendas afectadas por categoría</td>
                <td align="center">Viviendas destruidas por categoría</td>
            </tr>
            <tr>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=1&var=8&serie=2" style="border: none" border=0 onClick="location.href='LEC_C_Chart.jsp?data=1&var=8&serie=2'">
                    </td>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=1&var=16&serie=2" style="border: none" border=0 onClick="location.href='LEC_C_Chart.jsp?data=1&var=16&serie=2'">
                    </td>
            </tr>
        </table>
        <br/>
        
        <p></p>
        <table align="center" width="90%">
            <tr>
                <td align="center">DataCards</td>
                <td align="center">DataCards por causa</td>
            </tr>
            <tr>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=1&var=1&serie=1&spc=1" style="border: none" border=0 onClick="location.href='LEC_C_Chart.jsp?data=1&var=1&serie=1&spc=1'"><br/>
                    </td>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=1&var=1&serie=4" style="border: none" border=0 onClick="location.href='LEC_C_Chart.jsp?data=1&var=1&serie=4'">
                    </td>
            </tr>
            
            <tr>
                <td align="center">Heridos por causa</td>
                <td align="center">Muertos por causa</td>
            </tr>
            <tr>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=1&var=2&serie=4" style="border: none" border=0 onClick="location.href='LEC_C_Chart.jsp?data=1&var=2&serie=4'">
                    </td>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=1&var=4&serie=4" style="border: none" border=0 onClick="location.href='LEC_C_Chart.jsp?data=1&var=4&serie=4'">
                    </td>
            </tr>
            
            <tr>
                <td align="center">Viviendas afectadas por causa</td>
                <td align="center">Viviendas destruidas por causa</td>
            </tr>
            <tr>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=1&var=8&serie=4" style="border: none" border=0 onClick="location.href='LEC_C_Chart.jsp?data=1&var=8&serie=4'">
                    </td>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=1&var=16&serie=4" style="border: none" border=0 onClick="location.href='LEC_C_Chart.jsp?data=1&var=16&serie=4'">
                    </td>
            </tr>
        </table>
        <br/>
        
        <p></p>
        <table align="center" width="90%">
            <tr>
                <td align="center">DataCards (Total) por año </td>
                <td align="center">Variables (Total) por año</td>
            </tr>
            <tr>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=3&var=1&serie=1" style="border: none" border=0 onClick="location.href='LEC_C_Chart.jsp?data=3&var=1&serie=1'"><br/>
                    </td>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=3&var=30&serie=1" style="border: none" border=0 onClick="location.href='LEC_C_Chart.jsp?data=3&var=30&serie=1'">
                    </td>
            </tr>
            
            <tr>
                <td align="center">Heridos (por causa) por año</td>
                <td align="center">Muertos (por causa) por año</td>
            </tr>
            <tr>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=3&var=2&serie=4" style="border: none" border=0 onClick="location.href='LEC_C_Chart.jsp?data=3&var=2&serie=4'">
                    </td>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=3&var=4&serie=4" style="border: none" border=0 onClick="location.href='LEC_C_Chart.jsp?data=3&var=4&serie=4'">
                    </td>
            </tr>
            
            <tr>
                <td align="center">Viviendas afectadas (por causa) por año</td>
                <td align="center">Viviendas destruidas (por causa) por año</td>
            </tr>
            <tr>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=3&var=8&serie=4" style="border: none" border=0 onClick="location.href='LEC_C_Chart.jsp?data=3&var=8&serie=4'">
                    </td>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=3&var=16&serie=4" style="border: none" border=0 onClick="location.href='LEC_C_Chart.jsp?data=3&var=16&serie=4'">
                    </td>
            </tr>
        </table>
        <br/>
        
    </body>
<% dbCon.close(); %>
</html>
