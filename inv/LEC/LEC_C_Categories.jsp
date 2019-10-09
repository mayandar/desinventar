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
	
	<p><a href="LEC_C.jsp">Volver al menú principal</a></p>
	
        <%
            // creates a very light rset with events
            stmt = con.createStatement();
			
			ResultSet rset2;
			Statement stmt2;
			stmt2 = con.createStatement();
        %>
        <script type="text/javascript">
    
            function submitform(id)
            {
                document.getElementById("selectedCat").value=id;
                document.desinventar.submit();
            }
            function setDefault(catName){
                document.getElementById("defaultCat").value=catName;
                document.desinventar.submit();
            }
        </script>

<%
        
    if (request.getParameter("selectedCat")!=null && request.getParameter("selectedCat")!=""){
        
        String sSelCat = webObject.check_quotes(request.getParameter("selectedCat"));
        boolean deleteCat = true;
		
		try {
			
			//Falta realizar un chequeo cuando se elimina esta fila de la tabla, pero no se elimina la categoría y se continua su uso
			
			stmt.executeQuery("DELETE FROM LEC_TimeLapse WHERE F_Cat = '" + sSelCat + "' AND S_Cat = '" + sSelCat + "'");
			stmt.executeQuery("DELETE * FROM LEC_Categories WHERE Category='" + sSelCat + "'"); 
			
			stmt.executeQuery("UPDATE LEC_IdSuceso SET NewCat = NULL, IdSuceso = NULL, PEconomica = 0");
			//stmt.executeQuery("DELETE * FROM LEC_PEconomicas");
		
		} catch (Exception e) {
			String msg = "";
			if (e.getMessage().contains("LEC_IdSuceso")) msg = "· Cause related \\n";
			if (e.getMessage().contains("LEC_TimeLapse")) msg += "· Time Lapse related ";
			
			out.print("<script type=\"text/javascript\">"
                + "alert(\"Cannot delete the category " + sSelCat + " because it is already in use \\n" + msg + "\");"
                + "</script>");
		}
		
    } else if(request.getParameter("add_category")!=null && request.getParameter("add_category")!=""){
        
        String catName = webObject.check_quotes(request.getParameter("add_category"));
        String catDesc = webObject.check_quotes(request.getParameter("add_description"));

        if (catName.toLowerCase().equals("default")) {
            out.print("<script type='text/javascript'>"
                + "alert(\"Can't add the category because it's a reserved word.\");"
                + "</script>");
        } else {
            stmt.executeQuery("INSERT INTO LEC_Categories "
                + "VALUES ('" + catName + "','" + catDesc + "')");
			stmt.executeQuery("INSERT INTO LEC_TimeLapse "
                + "VALUES ('" + catName + "','" + catName + "',1)");
        }
		
    }

%>
        
        <form id="desinventar" name="desinventar" action="LEC_C_Categories.jsp" method="POST">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
            <table width="90%" border="1" cellspacing="0" cellpadding="0" class="bs">
                <tr bgcolor="#CCCCCC">
                    <th>Category</th>
                    <th>Description</th>
                    <th>Number of DataCards</th>
					<th>Injured</th>
					<th>Deaths</th>
					<th>Affected houses</th>
					<th>Destroyed houses</th>
                    <th align="center">Default</th>            
                    <th align="center">Action</th>
                </tr>
                
                    <tr>
                    <td>Antrophic events</td>
                    <td>Human made events</td>
                    
				<%
					rset=stmt.executeQuery("SELECT COUNT(*), SUM(f.heridos), SUM(f.muertos), SUM(f.vivafec), SUM(f.vivdest) "
										+ "FROM LEC_IdSuceso LEFT JOIN fichas f ON f.clave = LEC_IdSuceso.claveFichas "
										+ "WHERE OldCat is NULL AND status = 0");
					
					String sValsRow = "<td align=\"center\">0</td><td align=\"center\">0</td><td align=\"center\">0</td><td align=\"center\">0</td><td align=\"center\">0</td>";
					
					if (rset.first()) sValsRow =  "<td align=\"center\">" + rset.getString(1) + "</td>"
												+ "<td align=\"center\">" + rset.getString(2) + "</td>" 
												+ "<td align=\"center\">" + rset.getString(3) + "</td>"
												+ "<td align=\"center\">" + rset.getString(4) + "</td>"
												+ "<td align=\"center\">" + rset.getString(5) + "</td>";
					//out.print(rset.getString(1));
					out.print(sValsRow);
				%>
                    
                    <td align='center'><input disabled checked type="checkbox" name="default" value="default" /></td>
                    <td align="center">&nbsp;</td>
                </tr>
                <%
					
					rset = stmt.executeQuery(""
							+ "SELECT * "
							+ "FROM LEC_Categories "
							+ "ORDER BY Category "
							);
							
                    ArrayList cat = new ArrayList();
                    while (rset.next())
                    {
                        String category = rset.getString(1);
                        cat.add(category);
						
						rset2 = stmt2.executeQuery(""
										+ "SELECT Count(*), SUM(f.heridos), SUM(f.muertos), SUM(f.vivafec), SUM(f.vivdest) "
										+ "FROM LEC_IdSuceso LEFT JOIN fichas f ON f.clave = LEC_IdSuceso.claveFichas "
										+ "WHERE OldCat = '" + category + "'  AND status = 0"
										);
										
						//int iCount = 0;
						//if (rset2.first()) iCount = rset2.getInt(1);
						
						sValsRow = "<td align=\"center\">0</td><td align=\"center\">0</td><td align=\"center\">0</td><td align=\"center\">0</td><td align=\"center\">0</td>";
					
						if (rset2.first()) sValsRow = "<td align=\"center\">" + rset2.getString(1) + "</td>" 
													+ "<td align=\"center\">" + rset2.getString(2) + "</td>" 
													+ "<td align=\"center\">" + rset2.getString(3) + "</td>"
													+ "<td align=\"center\">" + rset2.getString(4) + "</td>"
													+ "<td align=\"center\">" + rset2.getString(5) + "</td>";
						
						String sDesc = rset.getString(2);
						if (sDesc.length() == 0) sDesc = "&nbsp;"; 

                        String row = "";
                        row+="<tr><td>"+category+"</td><td>"+sDesc+"</td>";
                        //row+="<td align=\"center\">"+iCount+"</td>";
						row+=sValsRow;
                        row+="<td align='center'><input ";
                        row+="disabled ";
                        row+="type=\"checkbox\" name=\"default\" value=\"default\"";
                        row+="></td>";                         
                        row+="<td align=\"center\"><input type=\"image\" name=\"delete\" value=\"Delete\"";
                        row+=" src=\"../images/dialog-cancel.png\" onclick=submitform('"+category+"')></td></tr>";

                        out.print(row);
                    }
 
                %>
                
                <tr>
                    <td><input type="text" name="add_category"></td>
                    <td><input type="text" name="add_description"></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;</td>
					<td align="center">&nbsp;</td>
                    <td align="center">&nbsp;</td>
					<td align="center">&nbsp;</td>
                    <td align="center">&nbsp;</td>
                    <td align="center"><input type="image" name="add" value="Add" src="../images/add.png" onclick="document.desinventar.submit()"></td>
                </tr>
            </table>
			<p>The default category has to be assigned to any non-natural hazard. This category will be considered as the antrophic events.</p>
			
            <input type="hidden" id="selectedCat" name="selectedCat" value="">
            <input type="hidden" id="defaultCat" name="defaultCat" value="">
        </form>
        <br/>

        <table align="center" width="90%">
            <tr>
                <td align="center">DataCards</td>
                <td align="center">DataCards por categoría</td>
            </tr>
            <tr>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=1&var=1&serie=1&spc=1" style="border: none" border=0 onclick="location.href='LEC_C_Chart.jsp?data=1&var=1&serie=1&spc=1'"><br/>
                    </td>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=1&var=1&serie=2" style="border: none" border=0 onclick="location.href='LEC_C_Chart.jsp?data=1&var=1&serie=2'">
                    </td>
            </tr>
            
            <tr>
                <td align="center">Heridos por categoría</td>
                <td align="center">Muertos por categoría</td>
            </tr>
            <tr>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=1&var=2&serie=2" style="border: none" border=0 onclick="location.href='LEC_C_Chart.jsp?data=1&var=2&serie=2'">
                    </td>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=1&var=4&serie=2" style="border: none" border=0 onclick="location.href='LEC_C_Chart.jsp?data=1&var=4&serie=2'">
                    </td>
            </tr>
            
            <tr>
                <td align="center">Viviendas afectadas por categoría</td>
                <td align="center">Viviendas destruidas por categoría</td>
            </tr>
            <tr>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=1&var=8&serie=2" style="border: none" border=0 onclick="location.href='LEC_C_Chart.jsp?data=1&var=8&serie=2'">
                    </td>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=1&var=16&serie=2" style="border: none" border=0 onclick="location.href='LEC_C_Chart.jsp?data=1&var=16&serie=2'">
                    </td>
            </tr>
        </table>
        <br/>
        
        
        <table align="center" width="90%">
            <tr>
                <td align="center">DataCards (Total) por año </td>
                <td align="center">Variables (Total) por año</td>
            </tr>
            <tr>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=3&var=1&serie=1" style="border: none" border=0 onclick="location.href='LEC_C_Chart.jsp?data=3&var=1&serie=1'"><br/>
                    </td>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=3&var=30&serie=1" style="border: none" border=0 onclick="location.href='LEC_C_Chart.jsp?data=3&var=30&serie=1'">
                    </td>
            </tr>
            
            <tr>
                <td align="center">Heridos (por categoría) por año</td>
                <td align="center">Muertos (por categoría) por año</td>
            </tr>
            <tr>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=3&var=2&serie=2" style="border: none" border=0 onclick="location.href='LEC_C_Chart.jsp?data=3&var=2&serie=2'">
                    </td>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=3&var=4&serie=2" style="border: none" border=0 onclick="location.href='LEC_C_Chart.jsp?data=3&var=4&serie=2'">
                    </td>
            </tr>
            
            <tr>
                <td align="center">Viviendas afectadas (por categoría) por año</td>
                <td align="center">Viviendas destruidas (por categoría) por año</td>
            </tr>
            <tr>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=3&var=8&serie=2" style="border: none" border=0 onclick="location.href='LEC_C_Chart.jsp?data=3&var=8&serie=2'">
                    </td>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=3&var=16&serie=2" style="border: none" border=0 onclick="location.href='LEC_C_Chart.jsp?data=3&var=16&serie=2'">
                    </td>
            </tr>
        </table>
        <br/>
    </body>
</html>
<% dbCon.close(); %>
