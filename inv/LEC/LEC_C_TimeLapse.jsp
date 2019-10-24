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
            function deleteTimeLapse(firstCat, secondCat){
                document.getElementById("selectedCategory1").value=firstCat;
                document.getElementById("selectedCategory2").value=secondCat;
                document.timeLapseForm.submit();
            }
        </script>

        <%
		
	boolean bTableChg = false;
        
    if(request.getParameter("selectedCategory1")!=null && request.getParameter("selectedCategory2")!=null &&
        request.getParameter("selectedCategory1")!="" && request.getParameter("selectedCategory2")!="") {

        String f_cat = webObject.check_quotes(request.getParameter("selectedCategory1"));
        String s_cat = webObject.check_quotes(request.getParameter("selectedCategory2"));
		
		if (f_cat.equals(s_cat)) {
			out.print("<script type=\"text/javascript\">"
            + "alert(\"The relation between '" + f_cat + "' and '" + s_cat + "' can't be removed!\");"
            + "</script>");
		} else {
			stmt.executeQuery("DELETE FROM LEC_TimeLapse WHERE F_Cat = '" + f_cat + "' AND S_Cat = '" + s_cat + "'");
			bTableChg = true;
		}
		
    } else if(request.getParameter("f_cat")!=null && request.getParameter("f_cat")!="" &&
		request.getParameter("s_cat")!=null && request.getParameter("s_cat")!="" &&
		request.getParameter("timeLapse")!=null && request.getParameter("timeLapse")!="") {

        String firstCat = webObject.check_quotes(request.getParameter("f_cat"));
        String secondCat = webObject.check_quotes(request.getParameter("s_cat"));
        String timeLapse  = webObject.check_quotes(request.getParameter("timeLapse"));
        
        rset = stmt.executeQuery(""
            + "SELECT TLapse "
            + "FROM LEC_TimeLapse "
            + "WHERE F_Cat = '" + firstCat + "' AND S_Cat = '" + secondCat + "'");

        if (rset.first()) { 
            out.print("<script type=\"text/javascript\">"
            + "alert(\"The relation between '" + firstCat + "' and '" + secondCat + "' already exist !\""
			+ "\n\r se ha actualizado el valor de " + String.valueOf(rset.getInt(1)) + " a " + timeLapse + " );"
            + "</script>");
            
			stmt.executeQuery("UPDATE LEC_TimeLapse SET TLapse = " + Integer.parseInt(timeLapse) 
				+ " WHERE F_Cat = '" + firstCat + "' AND S_Cat = '" + secondCat + "'");
				
        } else {
            stmt.executeQuery("INSERT INTO LEC_TimeLapse "
                + "VALUES ('" + firstCat + "','" + secondCat + "'," + Integer.parseInt(timeLapse) + ")");
        }
		
		bTableChg = true;
		
    } else if(request.getParameter("agr_level")!=null && request.getParameter("agr_level")!="") {
        //TODO: GLIDE???

        //Limpio los Id asignados
        stmt.executeQuery("UPDATE LEC_IdSuceso SET IdSuceso = NULL, NewCat = NULL, PEconomica = 0");
        //stmt.executeQuery("DELETE * FROM LEC_PEconomicas");
		
        boolean bAgrupar = true;
        if (request.getParameter("NoAgrupar")!=null && request.getParameter("NoAgrupar")!=""){
            stmt.executeQuery("UPDATE LEC_IdSuceso "
								+ "SET IdSuceso = claveFichas, "
								+ "NewCat = OldCat "
							+ "WHERE OldCat IS NOT NULL AND status = 0 ");
            bAgrupar = false;
        }
        
        //Reviso el nivel geopolitico de agrupación
        int iLevel = -1;
        String sLevel = ""; //Primera opción agrupación a nivel base de datos
        
        if (request.getParameter("agr_level").equals("level0")) iLevel = 0;
        if (request.getParameter("agr_level").equals("level1")) iLevel = 1;
        if (request.getParameter("agr_level").equals("level2")) iLevel = 2;
        
        //iLevel = 0;
        for (int i = 0; i <= iLevel; i++) {
            sLevel += ", fichas.level" + i;
        }

        //Obtengo la lista de agrupación por lapso de tiempo
        HashMap hmTL = new HashMap();
        rset = stmt.executeQuery(""
                + "SELECT * FROM LEC_TimeLapse "
                + "ORDER BY F_Cat, S_Cat");

        while (rset.next()){
            String firstCat = rset.getString("F_Cat");
            String secondCat = rset.getString("S_Cat");
            String timeLapse = String.valueOf(rset.getInt("TLapse"));
            HashMap hmInner = (HashMap) hmTL.get(firstCat);

            if (hmInner == null) hmInner = new HashMap();

            hmInner.put(secondCat, timeLapse);
            hmTL.put(firstCat, hmInner);
        }
        
        //SQL:UPDATE LEC_IdSuceso t1, LEC_IdSuceso t2 SET t1.IdSuceso = t2.IdSuceso WHERE (t1.Category = t2.Category AND t1.fecha >= t2.fecha AND t1.fecha < DATEADD('d',15,t2.fecha)) RETURNED: 408737 (496384 msecs) 
		//Miss: PoliticalLevel, InterCategories timelapses, ...
		
        //Time
        long start = System.currentTimeMillis();
        
        Statement st2 = con.createStatement();
        ResultSet rs2;
        
		//Contador por categoría
		HashMap hmCatCount = new HashMap();
		
        boolean bProc = true;
        
        while (bProc) {
		
			//Contador
			int iSuceso = 1;
			
            //out.print(sLevel + "</br>");
            rset = stmt.executeQuery(""
                    + "SELECT TOP 1 claveFichas, fecha, OldCat" + sLevel + " "
                    + "FROM LEC_IdSuceso "
                    + "LEFT JOIN fichas ON LEC_IdSuceso.claveFichas = fichas.clave "
                    + "WHERE IdSuceso IS NULL AND OldCat IS NOT NULL AND status = 0 "
					+ "ORDER BY fecha, claveFichas");
            
            if (rset.first()){
			
                int iClave = rset.getInt(1);
                String sFCat = rset.getString(3);
                java.sql.Date dtFirstRecord = rset.getDate(2);
                
				//SELECT FIRST(q1.a), COUNT(*) FROM (SELECT FIRST(anio) as a, COUNT(*) as c FROM LEC_IdSuceso GROUP BY IdSuceso) q1 WHERE q1.a = 1970 GROUP BY q1.a 
                //rs2 = st2.executeQuery("SELECT COUNT(*) FROM "
				//		+ "(SELECT FIRST(NewCat) as a, COUNT(*) as c FROM LEC_IdSuceso WHERE NewCat = '" + sFCat + "' GROUP BY IdSuceso) q1 "
				//		+ "GROUP BY q1.a");
                //if (rs2.first()) iSuceso = rs2.getInt(1) + 1;
				
				//New 120811:
                if (!hmCatCount.containsKey(sFCat)) {
					hmCatCount.put(sFCat, "1");
				}
				//
                iSuceso = Integer.parseInt((String) hmCatCount.get(sFCat));
				hmCatCount.put(sFCat, String.valueOf(iSuceso+1));
				
                String sIdSuceso = "@@" + sFCat + iSuceso;
                st2.executeQuery("UPDATE LEC_IdSuceso "
                        + "SET IdSuceso = '" + sIdSuceso + "', NewCat = '" + sFCat + "' "
                        + "WHERE claveFichas = " + iClave);
                
                if (bAgrupar) {
				
                    //Si se emplea un filtro por división politica               
                    String sPoliticalLevel = "";
                    for (int i = 0; i <= iLevel; i++) {
                        sPoliticalLevel += "AND f.level" + i + " = '" + rset.getString(4+i) + "' ";
                    }

                    //Busco registros relacionados por Amenaza
                    HashMap hm2 = (HashMap) hmTL.get(sFCat);
                    if (hm2 != null) {
                        String sHM2_keys[] = (String[]) hm2.keySet().toArray(new String[0]);

                        for (int j = 0; j < sHM2_keys.length; j++){
                            String sSCat = sHM2_keys[j];
                            int iRango = Integer.parseInt((String) hm2.get(sSCat));
							st2.executeQuery("UPDATE LEC_IdSuceso "
                            + "SET IdSuceso = '" + sIdSuceso + "', "
                            + "NewCat = '" + sFCat + "' "
                            + "WHERE claveFichas in ("
                                + "SELECT f.clave "
                                + "FROM LEC_IdSuceso l LEFT JOIN fichas f "
                                + "ON l.claveFichas = f.clave "
                                + "WHERE "
                                    + "IdSuceso is null AND "
                                    + "OldCat = '" + sSCat + "' AND "
									+ "status = 0 AND "
                                    + "fecha >= DATEADD('d',0,'" + dtFirstRecord + "') AND "
                                    + "fecha < DATEADD('d'," + iRango + ",'" + dtFirstRecord + "') "
                                    + sPoliticalLevel + ")");
                        }
                    }
                }

            } else {
                bProc = false;
            }
        }
		
        long end = System.currentTimeMillis();
        out.print("</br> Execution time was "+(end-start)+" ms. </br>");                    
		out.print("<script type=\"text/javascript\">"
                + "alert(\"Process finished in : " + (end-start) + " ms.\");"
                + "</script>");
        
    }
	
	
	//if table has change, delete the processed ones
	if (bTableChg) {
		stmt.executeQuery("UPDATE LEC_IdSuceso SET NewCat = NULL, IdSuceso = NULL, PEconomica = 0");
		//stmt.executeQuery("DELETE * FROM LEC_PEconomicas");
	}
        
        %>
        
        <form id="timeLapseForm" name="timeLapseForm" action="LEC_C_TimeLapse.jsp" method="POST">
            <table width="90%" border="1" cellspacing="0" cellpadding="0" class="bs">
                <tr bgcolor="#CCCCCC">
                    <th>Cause category</th>
                    <th>Effect category</th>
                    <th>Time lapse</th>
                    <th>Action</th>
                </tr>
                <%
                
                    ArrayList cat;
                    cat = new ArrayList();
                    
                    rset=stmt.executeQuery("SELECT Category FROM LEC_Categories");
        
                    while(rset.next()){
                        cat.add(rset.getString(1));
                    }
                
              rset = stmt.executeQuery("SELECT F_Cat, S_Cat, TLapse FROM LEC_TimeLapse ORDER BY F_Cat, S_Cat");
              
              while(rset.next()){
                  String firstCat = rset.getString("F_Cat");
                  String secondCat = rset.getString("S_Cat");
                  int timeLapse = rset.getInt("TLapse");
                  
                  out.print("<tr>"
                          + "<td>" + firstCat + "</td>"
                          + "<td>" + secondCat + "</td>"
                          + "<td>" + timeLapse + "</td>"
                          + "<td align=\"center\">"
                          + "<input type=\"image\" name=\"deleteTimeLapse\" value=\"Delete\" src=\"../images/dialog-cancel.png\""
                          + " onclick=\"deleteTimeLapse('" + firstCat + "','" + secondCat + "')\">"
                          + "</td></tr>");
              }
              
              String sOpts = "";
              for(int i = 0; i < cat.size(); i++){
                  sOpts += "<option value='" + cat.get(i) + "'>" + cat.get(i) + "</option>";
              }
              
              out.print("<tr><td>"
                      + "<select name='f_cat'>" + sOpts
                      + "</select></td>"
                      + "<td><select name=\"s_cat\">" + sOpts
                      + "</select></td>"
                      + "<td><input type=\"text\" name=\"timeLapse\" id=\"timeLapse\" value=\"\"></td>"
                      + "<td align=\"center\"><input type=\"image\" name=\"addTimeLapse\" value=\"Add\" src=\"../images/add.png\" onclick=\"document.timeLapseForm.submit()\"></td>"
                      + "</tr>");
                %>       
            </table> 
			
			<p>Seleccionando una relación existente entre categorías actualizará el valor</p>
			<p style="color:red;">Cualquier cambio eliminará todos los elementos calculados</p>
			
            <input type="hidden" id="selectedCategory1" name="selectedCategory1" value="">
            <input type="hidden" id="selectedCategory2" name="selectedCategory2" value="">
        </form>
        
        <form id="AgrupacionForm" name="AgrupacionForm" action="LEC_C_TimeLapse.jsp" method="POST">
                <select name="agr_level">
                    <option value ="global">Global</option>
                    <option value ="level0">level0</option>
                    <option value ="level1">level1</option>
                    <option value ="level2">level2</option>
                </select>
                <input type="submit" value="Agrupar" name="Agrupar"/>
                <input type="submit" value="Continuar sin agrupación" name="NoAgrupar"/>
				Please be patient this can take a long time, when finish a message box will be displayed
        </form>       
            
        
        <%  
            out.print("<p>Before Aggrupation</p>"
                    + "<table width=\"90%\" border=\"1\" cellspacing=\"0\" cellpadding=\"0\" class=\"bs\">"
                        + "<tr bgcolor=\"#CCCCCC\">"
                            + "<th>Category</th>"
                            + "<th>Events (Count)</th>"
                            + "<th>Injured (Sum)</th>"
                            + "<th>Death (Sum)</th>"
                            + "<th>Afected Houses (Sum)</th>"
                            + "<th>Destroyed Houses (Sum)</th>"
                        + "</tr>");
            rset = stmt.executeQuery(""
                    + "SELECT i.OldCat, COUNT(f.clave), SUM(f.heridos), SUM(f.muertos), "
                        + "SUM(f.vivafec), SUM(f.vivdest) "
                    + "FROM LEC_IdSuceso i LEFT JOIN fichas f ON f.clave = i.claveFichas "
					+ "WHERE i.OldCat IS NOT NULL AND status = 0 "
                    + "GROUP BY i.OldCat "
                    + "ORDER BY i.OldCat ASC"
                    );
            
            while (rset.next()){
                out.print("<tr>"
                            + "<td>" + rset.getString(1) + "</td>"
                            + "<td>" + rset.getInt(2) + "</td>"
                            + "<td>" + rset.getDouble(3) + "</td>"
                            + "<td>" + rset.getDouble(4) + "</td>"
                            + "<td>" + rset.getDouble(5) + "</td>"
                            + "<td>" + rset.getDouble(6) + "</td>"
                        + "</tr>");
            }
            out.print("</table>");
            
            
            out.print("<p>After Aggrupation</p>"
                    + "<table width=\"90%\" border=\"1\" cellspacing=\"0\" cellpadding=\"0\" class=\"bs\">"
                        + "<tr bgcolor=\"#CCCCCC\">"
                            + "<th>Category</th>"
                            + "<th>Events (Count)</th>"
                            + "<th>Injured (Sum)</th>"
                            + "<th>Death (Sum)</th>"
                            + "<th>Afected Houses (Sum)</th>"
                            + "<th>Destroyed Houses (Sum)</th>"
                        + "</tr>");
						
            rset = stmt.executeQuery(""
                    + "SELECT i.NewCat, COUNT(f.clave), SUM(f.heridos), SUM(f.muertos), "
                        + "SUM(f.vivafec), SUM(f.vivdest) "
                    + "FROM LEC_IdSuceso i LEFT JOIN fichas f ON f.clave = i.claveFichas "
					+ "WHERE i.OldCat IS NOT NULL AND i.NewCat IS NOT NULL AND status = 0 "
                    + "GROUP BY i.NewCat "
                    + "ORDER BY i.NewCat ASC"
                    );
            	
            while (rset.next()){
			
				rset2 = stmt2.executeQuery(""
					+ "SELECT COUNT(q1.c) "
					+ "FROM (SELECT IdSuceso as c FROM LEC_IdSuceso WHERE NewCat = '" + rset.getString(1) + "' GROUP BY IdSuceso) q1"
					);
				int iCount = 0;
				if (rset2.first()) iCount = rset2.getInt(1);
					
                out.print("<tr>"
                            + "<td>" + rset.getString(1) + "</td>"
                            + "<td>" + iCount + "</td>"
                            + "<td>" + rset.getDouble(3) + "</td>"
                            + "<td>" + rset.getDouble(4) + "</td>"
                            + "<td>" + rset.getDouble(5) + "</td>"
                            + "<td>" + rset.getDouble(6) + "</td>"
                        + "</tr>");
            }
            out.print("</table>");
            
            out.print("</br></br></br>");
            
            //IMPRIMO HISTOGRAMAS
            out.print("<table align=\"center\" width=\"90%\">"
                     + "<tr>"
                        + "<td colspan='2' align=\"center\">Total</td>"
                    + "</tr>"
                    + "<tr>"
                        + "<td colspan='2' align=\"center\">"
                            + "<img src=\"LEC_C_Chart.jsp?graph=4&var=30&serie=1\" style=\"border: none\" border=0 onclick=\"location.href='LEC_C_Chart.jsp?data=4&var=30&serie=1'\"><br/>"
                        + "</td>"
                    + "</tr>"
                    + "<tr>"
                        + "<td colspan='2' align=\"center\">"
                        + "Número de eventos con una afectación igual o superior a "
                        + "</td>"
                    + "</tr>"
                    + "<tr>"
                        + "<td align=\"center\">Frecuencía de Heridos</td>"
                        + "<td align=\"center\">Frecuencía de Muertos</td>"
                    + "</tr>"
                    + "<tr>"
                        + "<td align=\"center\">"
                            + "<img src=\"LEC_C_Chart.jsp?graph=4&var=2&serie=3\" style=\"border: none\" border=0 onclick=\"location.href='LEC_C_Chart.jsp?data=4&var=2&serie=3'\"><br/>"
                        + "</td>"
                        + "<td align=\"center\">"
                            + "<img src=\"LEC_C_Chart.jsp?graph=4&var=4&serie=3\" style=\"border: none\" border=0 onclick=\"location.href='LEC_C_Chart.jsp?data=4&var=4&serie=3'\">"
                        + "</td>"
                    + "</tr>"
                    + "<tr>"
                        + "<td align=\"center\">Frecuencía de Viviendas Afectadas</td>"
                        + "<td align=\"center\">Frecuencía de Viviendas Destruidas</td>"
                    + "</tr>"
                    + "<tr>"
                        + "<td align=\"center\">"
                            + "<img src=\"LEC_C_Chart.jsp?graph=4&var=8&serie=3\" style=\"border: none\" border=0  onclick=\"location.href='LEC_C_Chart.jsp?data=4&var=8&serie=3'\"><br/>"
                        + "</td>"
                        + "<td align=\"center\">"
                            + "<img src=\"LEC_C_Chart.jsp?graph=4&var=16&serie=3\" style=\"border: none\" border=0 onclick=\"location.href='LEC_C_Chart.jsp?data=4&var=16&serie=3'\">"
                        + "</td>"
                    + "</tr>"
                    + "</table>"
                    
                    );

        %>
        
        
                
    </body>
</html>
<% dbCon.close(); %>
