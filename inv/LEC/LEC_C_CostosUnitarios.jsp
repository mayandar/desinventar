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
        %>
        <script type="text/javascript">

			function submitFrm(sVar)
			{
				document.getElementById("selVar").value=sVar;
				document.getElementById("selVarNewVal").value=document.getElementById("input" + sVar).value;
				//alert(sVar + ": " + document.getElementById("input" + sVar).value);
				document.CostosUnitarios.submit();
			}
			function validate(sVar){ 
				//http://stackoverflow.com/questions/469357/html-text-input-allow-only-numeric-input
				//Vitim.us - Nov 15 '11 at 18:23

				var charsAllowed="0123456789";
				var allowed;
				var inp = document.getElementById("input" + sVar);
				
				for(var i=0;i<inp.value.length;i++){       
					allowed=false;
					for(var j=0;j<charsAllowed.length;j++){
						if(inp.value.charAt(i)==charsAllowed.charAt(j) ){ allowed=true; }
					}
					if(allowed==false){ inp.value = inp.value.replace(inp.value.charAt(i),""); i--; }
				}
				document.getElementById("lbl" + sVar).value = "Edit not saved, click in the pencil icon";
				return true;
			}

        </script>

<%
		
		if (request.getParameter("selVar")!=null && request.getParameter("selVar")!=""
				&& request.getParameter("selVarNewVal")!=null && request.getParameter("selVarNewVal")!=""){
				
				String var = request.getParameter("selVar");
				String val = request.getParameter("selVarNewVal");
				
				try {
					int iVal = Integer.parseInt(val);
					stmt.executeQuery("UPDATE LEC_CostosUnitarios SET CUnitario = " + iVal + " WHERE descripcion = '" + var + "'");
					
					stmt.executeQuery("UPDATE LEC_IdSuceso SET PEconomica = 0");
					
				} catch (Exception e) {
					out.print("<script type=\"text/javascript\">alert('Se requiere un valor númerico!');</script>");
				}
				
		} else if (request.getParameter("Valorar")!=null && request.getParameter("Valorar")!="") {
			
			//Limpio la tabla de agrupación
			//stmt.executeQuery("DELETE * FROM LEC_PEconomicas");
			stmt.executeQuery("UPDATE LEC_IdSuceso SET PEconomica = 0");
			
			//Obtengo los valores unitarios
			rset = stmt.executeQuery("SELECT * FROM LEC_CostosUnitarios ORDER BY clave");
			
			String sQuery = "";
			//int iVals[] = new int[7];
			//int i = 0;
			while (rset.next()){
				//iVals[i] = rset.getInt(2);
				//i++;
				if (sQuery.length() != 0) sQuery += " + ";
				sQuery += "f." + rset.getString(2) + " * " + rset.getString(4);
			}
			
			//TODO, posibilidad de incluir cualquier variable de la base de datos, 
			// id, colName, Descripcion, Valor -> "f." + colName[id] + "*" + Valor[id]
			
			
			stmt.executeQuery("UPDATE LEC_IdSuceso i "
							+ "LEFT JOIN fichas f ON f.clave = i.claveFichas "
							+ "SET PEconomica = ("
								+ sQuery
							+ ") "
							+ "WHERE i.NewCat IS NOT NULL "
							);
						
		}
            
%>
        
        <form id="CostosUnitarios" name="CostosUnitarios" action="LEC_C_CostosUnitarios.jsp" METHOD="POST">
		<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
			
            <table width="90%" border="1" cellspacing="0" cellpadding="0" class="bs">
				<col width="20%" />
				<col width="20%" />
				<col width="20%" />
				<col width="30%" />
				<col width="10%" />
				
                <tr bgcolor="#CCCCCC">
                    <th>Variable</th>
                    <th>Unit cost</th>
					<th>New Unit Cost</th>
                    <th>&nbsp;</th>
                    <th align="center">Action</th>
                </tr>
                
                <%
                
                    rset=stmt.executeQuery(""
                            + "SELECT * FROM LEC_CostosUnitarios");
                    
                    while (rset.next())
                    {
                        String variable = rset.getString(3);
						int unitario = rset.getInt(4);			

                        String row = "";
                        row+="<tr><td>"+variable+"</td>";
						row+="<td>"+unitario+"</td>";
						row+="<td><input type=\"number\" id='input"+ variable +"' name='input"+ variable +"' value='"+unitario+"' onchange=\"validate('"+variable+"')\"></td>";
						row+="<td><input size='40' type=\"text\" disabled id='lbl"+ variable +"' name='lbl"+ variable +"' value='' style=\"border: none; color:red; background: white\"></td>";
                        row+="<td align=\"center\"><input type=\"image\" name=\"modify\" value=\"Modify\"";
                        row+=" src=\"../images/edit_row.gif\" onclick=submitFrm('"+variable+"')></td></tr>";

                        out.print(row);
                    }
 
                %>
                
                
                <tr>
                    <td colspan="5">&nbsp;
                        
                    </td>
                </tr>
            </table>
			
			<p style="color:red;">Cualquier cambio eliminará cualquier valoración presente</p>
			
            <input type="hidden" id="selVar" name="selVar" value="">
            <input type="hidden" id="selVarNewVal" name="selVarNewVal" value="">
        </form>
        <br/>
		
		<form>
			Estimate economic loss of the events
			<input type="submit" value="Valorar" name="Valorar"/>
		</form>
		
		<%
			rset = stmt.executeQuery("SELECT SUM(PEconomica) FROM LEC_IdSuceso");
			double dTotal = 0;
			if (rset.first()) dTotal = rset.getDouble(1);
			
			if (dTotal > 0) {
		%>

        <table align="center" width="90%">
            <tr>
                <td align="center">Pérdidas económicas totales por año</td>
                <td align="center">Pérdidas económicas por Categoría y por año</td>
            </tr>
            <tr>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=3&var=32&serie=1" style="border: none" border=0 onClick="location.href='LEC_C_Chart.jsp?data=3&var=32&serie=1'"><br/>
                    </td>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=3&var=32&serie=3" style="border: none" border=0 onClick="location.href='LEC_C_Chart.jsp?data=3&var=32&serie=3'">
                    </td>
            </tr>
			
			<tr>
                <td align="center">Frecuencia de pérdidas (Total)</td>
                <td align="center">Frecuencia de pérdidas (por Categoría)</td>
            </tr>
            <tr>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=4&var=32&serie=1" style="border: none" border=0 onClick="location.href='LEC_C_Chart.jsp?data=4&var=32&serie=1'"><br/>
                    </td>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=4&var=32&serie=3" style="border: none" border=0 onClick="location.href='LEC_C_Chart.jsp?data=4&var=32&serie=3'">
                    </td>
            </tr>
			
			<tr>
                <td align="center">Curva de excedencia de pérdidas (Total)</td>
                <td align="center">Curva de excedencia de pérdidas (por Categoría)</td>
            </tr>
            <tr>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=4&var=32&serie=1&spc=1" style="border: none" border=0 onClick="location.href='LEC_C_Chart.jsp?data=4&var=32&serie=1&spc=1'"><br/>
                    </td>
                <td align="center">
                    <img src="LEC_C_Chart.jsp?graph=4&var=32&serie=3&spc=1" style="border: none" border=0 onClick="location.href='LEC_C_Chart.jsp?data=4&var=32&serie=3&spc=1'">
                    </td>
            </tr>
			
        </table>
        <br/>
		<%
			}
		%>
        <br/>
    </body>
</html>
<% dbCon.close(); %>
