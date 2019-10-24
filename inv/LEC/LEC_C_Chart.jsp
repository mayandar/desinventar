
    <%@ page import = "org.lared.desinventar.util.dbConnection" %>
    <%@ page import = "org.lared.desinventar.webobject.users" %>
    <%@ page import = "org.lared.desinventar.util.*" %>
    <%@ page import = "org.lared.desinventar.webobject.*" %>
    <%@ page import = "java.sql.*" %>
    <%@ page import = "java.util.*" %>
    <%@ page import = "java.io.*" %>

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
    
<%
boolean bDebug = false;
if (bDebug) out.print("HELLO" + "</br>");
	
	stmt = con.createStatement();

	// size of the chart image		   
	int w=800;
	int h=250;
	
	if (request.getParameter("w")!= null && ! request.getParameter("w").equals("")) {
		String sT = webObject.check_quotes(request.getParameter("w"));
		try {
			w = Integer.parseInt(sT);
			if (w<200) w = 200;
			if (w>1200) w = 1200;
		} catch (Exception e) {
			w = 600;
		}
	}
	if (bDebug) out.print("w: " + String.valueOf(w) + "</br>");
	
	if (request.getParameter("h")!= null && ! request.getParameter("h").equals("")) {
		String sT = webObject.check_quotes(request.getParameter("h"));
		try {
			h = Integer.parseInt(sT);
			if (h<200) h = 200;
			if (h>1200) h = 800;
		} catch (Exception e) {
			h = 450;
		}
	}
	if (bDebug) out.print("h: " + String.valueOf(h) + "</br>");

	//-------------------------------------------------------------------------
	// 1*: Pie, 2: Barras, 3: XY, 4: Histograma
	
	String sGraph =  "";
	int iGraph = 1;
	boolean bOnlyData = false;
	
	if (request.getParameter("graph")!= null && ! request.getParameter("graph").equals("")) {
		sGraph = webObject.check_quotes(request.getParameter("graph"));
	} else if (request.getParameter("data")!= null && ! request.getParameter("data").equals("")) {
		sGraph = webObject.check_quotes(request.getParameter("data"));
		bOnlyData = true;
	}
	
	try {
		iGraph = Integer.parseInt(sGraph);
		if (iGraph<1) iGraph = 1;
		if (iGraph>4) iGraph = 4;
	} catch (Exception e) {
		iGraph = 1;
	}
	if (bDebug) out.print("iGraph: " + String.valueOf(iGraph) + "</br>");
	
	//-------------------------------------------------------------------------
	//1*: Registros, 2: Heridos, 4: Muertos, 8: Viviendas Afectadas, 16: Viviendas Destruidas, 32: Pérdida económica
	
	int iVariables = 1;
	if (request.getParameter("var")!= null && ! request.getParameter("var").equals("")) {		
		try {
			iVariables = Integer.parseInt(webObject.check_quotes(request.getParameter("var")));
			if (iVariables<1) iVariables = 1;
			//if (iVariables>4) iVariables = 4;
		} catch (Exception e) {
			iVariables = 1;
		}
	} 
	if (bDebug) out.print("iVariables: " + String.valueOf(iVariables) + "</br>");
	
	//-------------------------------------------------------------------------
	// 1*: Total (total todas las categorías), 2: Todas las categorías - old (antes de agrupación), 
	// 3: Todas las categorías - new (despues de agrupación), 4: Todos las causas 
	
	int iSeries = 1;
	if (request.getParameter("serie")!= null && ! request.getParameter("serie").equals("")) {
		try {
			iSeries = Integer.parseInt(webObject.check_quotes(request.getParameter("serie")));
			if (iSeries<1) iSeries = 1;
			if (iSeries>4) iSeries = 4;
		} catch (Exception e) {
			iSeries = 1;
		}
	} 
	if (bDebug) out.print("iSeries: " + String.valueOf(iSeries) + "</br>");
	
	//-------------------------------------------------------------------------
	// 1: Todos los registros, 2*: Solo los registros naturales, 3?: Solo antropogénicos?
	
	int iRegistros = 2;
	if (request.getParameter("reg")!= null && ! request.getParameter("reg").equals("")) {
		try {
			iRegistros = Integer.parseInt(webObject.check_quotes(request.getParameter("reg")));
			if (iRegistros<1) iRegistros = 1;
			if (iRegistros>2) iRegistros = 2;
		} catch (Exception e) {
			iRegistros = 2;
		}
	} 
	if (bDebug) out.print("iRegistros: " + String.valueOf(iRegistros) + "</br>");
	
	//-------------------------------------------------------------------------
	// 1: Todo el periodo, 2*: Solo los seleccionados
	
	int iPeriodo = 2;
	if (request.getParameter("periodo")!= null && ! request.getParameter("periodo").equals("")) {		
		try {
			iPeriodo = Integer.parseInt(webObject.check_quotes(request.getParameter("periodo")));
			if (iPeriodo<1) iPeriodo = 1;
			if (iPeriodo>2) iPeriodo = 2;
		} catch (Exception e) {
			iPeriodo = 2;
		}
	} 
	if (bDebug) out.print("iPeriodo: " + String.valueOf(iPeriodo) + "</br>");
	
	//-------------------------------------------------------------------------
	// 0*: Normal graph, 1: Grafico especial 1, ...
	
	int iSpecial = 0;
	if (request.getParameter("spc")!= null && ! request.getParameter("spc").equals("")) {		
		try {
			iSpecial = Integer.parseInt(webObject.check_quotes(request.getParameter("spc")));
			if (iSpecial<0) iPeriodo = 0;
			//if (iSpecial>2) iPeriodo = 2;
		} catch (Exception e) {
			iSpecial = 0;
		}
	} 
	if (bDebug) out.print("iSpecial: " + String.valueOf(iSpecial) + "</br>");
	
	//=========================================================================
	String sTablaCategoria = "OldCat";
	String sTablaCausa = "Cause";
	String sTablaAnio = "anio";
	//=========================================================================
	String sQuerySELECT = "";
	String sQueryFROM = " FROM LEC_IdSuceso LEFT JOIN fichas f ON f.clave = LEC_IdSuceso.claveFichas ";
	String sQueryWHERE = "";
	String sQueryGROUP = "";
	String sQueryORDER = "";
	
	//Selección de los registros a graficar, hasta este punto se incluyen:
	// - Registros antropogénicos
	// - Todas las fechas
	
	if (iSeries == 3) sTablaCategoria = "NewCat";
	
	if (iSeries == 1) { //Total
		//sTablaCategoria  = "";		
	} else if (iSeries == 2 || iSeries == 3) { //Categorias - old || new 
		sQuerySELECT += sTablaCategoria;
		sQueryGROUP = sTablaCategoria;
		sQueryORDER = sTablaCategoria;
	} else if (iSeries == 4) { //Causas
		sQuerySELECT += sTablaCausa;
		sQueryGROUP = sTablaCausa;
		sQueryORDER = sTablaCausa;
	}
	
	//-------------------------------------------------------------------------
	int iNVars = 0;
	HashMap hmVars = new HashMap();
	HashMap hmVarsQuery = new HashMap();
	
	if ((iVariables&1) == 1) {
		if (bDebug) out.print("1 </br>");
		if (sQuerySELECT.length() > 0) sQuerySELECT += ", ";
		sQuerySELECT += "COUNT(*)";
		
		iNVars++;
		hmVars.put(String.valueOf(iNVars), "Cuenta");
		hmVarsQuery.put(String.valueOf(iNVars), "");
	} 
	if ((iVariables&2) == 2) {
		if (bDebug) out.print("2 </br>");
		if (sQuerySELECT.length() > 0) sQuerySELECT += ", ";
		sQuerySELECT += "SUM(f.heridos)";
		
		iNVars++;
		hmVars.put(String.valueOf(iNVars), "Heridos");
		hmVarsQuery.put(String.valueOf(iNVars), "SUM(f.heridos)");
	} 
	if ((iVariables&4) == 4) {
		if (bDebug) out.print("4 </br>");
		if (sQuerySELECT.length() > 0) sQuerySELECT += ", ";
		sQuerySELECT += "SUM(f.muertos)";
		
		iNVars++;
		hmVars.put(String.valueOf(iNVars), "Muertos");
		hmVarsQuery.put(String.valueOf(iNVars), "SUM(f.muertos)");
	} 
	if ((iVariables&8) == 8) {
		if (bDebug) out.print("8 </br>");
		if (sQuerySELECT.length() > 0) sQuerySELECT += ", ";
		sQuerySELECT += "SUM(f.vivafec)";
		
		iNVars++;
		hmVars.put(String.valueOf(iNVars), "Viviendas afectadas");
		hmVarsQuery.put(String.valueOf(iNVars), "SUM(f.vivafec)");
	} 
	if ((iVariables&16) == 16) {
		if (bDebug) out.print("16 </br>");
		if (sQuerySELECT.length() > 0) sQuerySELECT += ", ";
		sQuerySELECT += "SUM(f.vivdest)";
		
		iNVars++;
		hmVars.put(String.valueOf(iNVars), "Viviendas destruidas");
		hmVarsQuery.put(String.valueOf(iNVars), "SUM(f.vivdest)");
	}
	if (iVariables == 32) { //debe definirse exclusivamente la variable a graficar
			
		if (bDebug) out.print("32 </br>");
		if (sQuerySELECT.length() > 0) sQuerySELECT += ", ";
		sQuerySELECT += "SUM(PEconomica)";
		
		sQueryFROM = " FROM LEC_IdSuceso ";
		iNVars = 1;
		
		hmVars.put(String.valueOf(iNVars), "Pérdida");
		hmVarsQuery.put(String.valueOf(iNVars), "SUM(PEconomica)");		
		
	}
	
	//-------------------------------------------------------------------------
	
	if (iRegistros == 2) { //solo registros de amenazas naturales
		//sQueryWHERE = "WHERE OldCat IS NOT NULL"; // <> '' 
		sQueryWHERE = " WHERE " + sTablaCategoria + " IS NOT NULL ";
	}
	if (iPeriodo == 2) { //solo el periodo seleccionado
		if (sQueryWHERE.length() > 0) sQueryWHERE += " AND "; else sQueryWHERE = " WHERE ";
		sQueryWHERE += "status  = 0 ";
	}
	
	//=========================================================================
	//Query 
	
	int iRangos[] = {1};
	String sLabels[] = {">=1"};
	String sQueryA = "";
	String sQueryB = "";
	
	String sQuery = "SELECT ";
	if (iGraph == 1) { //PIE 
		
		if (sQueryGROUP.length() > 0) sQueryGROUP = " GROUP BY " + sQueryGROUP;
		if (sQueryORDER.length() > 0) sQueryORDER = " ORDER BY " + sQueryORDER;
		
		sQuery += sQuerySELECT
				+ sQueryFROM 
				+ sQueryWHERE
				+ sQueryGROUP
				+ sQueryORDER;

	} else if (iGraph == 2) { //Columns
		//TODO
	} else if (iGraph == 3) { //XY
	
		if (sQueryGROUP.length() > 0) sQueryGROUP = " GROUP BY " + sQueryGROUP + ", anio"; else sQueryGROUP = " GROUP BY anio ";
		if (sQueryORDER.length() > 0) sQueryORDER = " ORDER BY " + sQueryORDER + ", anio"; else sQueryORDER = " ORDER BY anio";
		
		sQuery += "anio, " 
				+ sQuerySELECT
				+ sQueryFROM 
				+ sQueryWHERE
				+ sQueryGROUP
				+ sQueryORDER;
				
	} else if (iGraph == 4) { //Histograma - Columnas
		
		if (iSeries != 1 && iNVars > 1) {
			//Solo se permite una variable !!!
			iNVars = 1;
			out.print("Solo se puede emplear una variable cuando se definen multiples etiquetas");
		} 
		
		iRangos = new int[]{
					1,2,3,4,5,
					10,20,30,40,50,
					100,200,300,400,500,
					1000};//,2000,3000,4000,5000,
					//10000};
		sLabels = new String[]{
					">=1",">=2",">=3",">=4",">=5",
					">=10",">=20",">=30",">=40",">=50",
					">=100",">=200",">=300",">=400",">=500",
					">=1,000"};//,">=2,000",">=3,000",">=4,000",">=5,000",
					//">=10,000"};
				
		if (iVariables == 32) {
			iRangos = new int[]{
				10000,20000,30000,40000,50000,
				100000,200000,300000,400000,500000,
				1000000,2000000,3000000,4000000,5000000,
				10000000, 
				100000000,1000000000};
				//20000000,30000000,40000000,50000000,
			sLabels = new String[]{
				">=10,000",">=20,000",">=30,000",">=40,000",">=50,000",
				">=100,000",">=200,000",">=300,000",">=400,000",">=500,000",
				">=1'000,000",">=2'000,000",">=3'000,000",">=4'000,000",">=5'000,000",
				">=10'000,000",
				">=100'000,000",">=1 000'000,000"};
				//">=20'000,000",">=30'000,000",">=40'000,000",">=50'000,000",
		}
		
		/*
			sQueryA
			[SELECT q1.NC, COUNT(*)
			FROM (

			SELECT FIRST(NewCat) as NC, ]
			
			[SUM(f.heridos)] 
			
			sQuery
			[as SV, IdSuceso as IdS
			FROM LEC_IdSuceso LEFT JOIN fichas f ON f.clave = LEC_IdSuceso.claveFichas
			WHERE NewCat IS NOT NULL AND status = 0
			GROUP BY IdSuceso
			ORDER BY IdSuceso

			) q1
			WHERE q1.SV >= ] [10]
			
			GROUP BY q1.NC
		*/
		
		sQueryA = "SELECT";
		String sLbl = "";
		
		if (sQueryGROUP.length() > 0) {
			sQueryA += " q1.lbl,";
			sLbl = " FIRST(" + sQueryGROUP + ") as lbl, ";
			sQueryGROUP = " GROUP BY q1.lbl";
		}
		
		sQueryA += " COUNT(*) FROM (SELECT " + sLbl;
		sQuery = " as SV "
				+ sQueryFROM 
				+ sQueryWHERE
				+ " GROUP BY LEC_IdSuceso.IdSuceso"
				+ " ORDER BY LEC_IdSuceso.IdSuceso"
				+ ") q1 "
				+ "WHERE q1.SV >= ";
		
		sQueryB = sQueryGROUP;
				
		//sQuery = sQueryA + "SUM(f.heridos)" + sQuery + "100" + sQueryB;
		if (bDebug) {
			if (iVariables == 32) {
				out.print("</br></br>" + "Query: " + sQueryA + "PEconomica" + sQuery + "100" + sQueryB + " </br>");
			} else {
				out.print("</br></br>" + "Query: " + sQueryA + "SUM(f.heridos)" + sQuery + "100" + sQueryB + " </br>");
			}
		}
	}
	if (bDebug) out.print("</br></br>" + "Query: " + sQuery + " </br>");
	
	//=========================================================================
	//Chart general settings
	
	com.java4less.rchart.ChartLoader loader = new com.java4less.rchart.ChartLoader();
	//if (!bOnlyData) loader = new com.java4less.rchart.ChartLoader();
	
	ArrayList alColors = new ArrayList(){{add("RED"); add("BLUE"); add("GREEN"); add("ORANGE"); add("LIGHTSALMON"); add("AQUAMARINE"); add("CYAN"); 
					add("ORANGE"); add("PALEGREEN"); add("LIGHTYELLOW"); add("LIGHTPINK"); add("LIGHTBLUE"); add("DARKOLIVEGREEN");
					add("LIGHTCORAL"); add("LIGHTCYAN"); add("GREENYELLOW"); add("DARKORCHID"); add("DARKSALMON"); add("LIGHTSKYBLUE"); add("DARKTURQUOISE");
					add("YELLOW");add("DARKVIOLET"); add("FORESTGREEN"); add("FUCHSIA"); add("GOLDENROD"); add("GRAY"); add("GREEN"); add("HOTPINK"); 
					add("IVORY"); add("KHALI"); add("LAVENDER");add("LAWNGREEN"); add("LIGHTGRAY"); add("LIME"); add("LIMEGREEN"); add("MAGENTA"); 
					add("MEDIUMBLUE"); add("MEDIUMPURPLE"); add("MIDNIGHTBLUE");add("NAVY"); add("OLIVE"); add("ORANGERED"); add("ORCHID"); 
					add("PALETURQUOISE"); add("PALEVIOLETRED"); add("PINK"); add("PLUM"); add("PURPLE"); add("RED");add("SALMON"); add("SEAGREEN"); 
					add("SIENNA"); add("SKYBLUE"); add("SPRINGGREEN"); add("TELA"); add("TURQUOISE"); add("VIOLET"); add("YELLOWGREEN"); add("CORAL");
					add("GOLD"); add("AZURE"); add("BEIGE"); add("BLUE"); add("BORLYWOOD"); add("BROWN"); add("BLUEVIOLET"); add("DARKGOLGENROD");}};
	
	if (!bOnlyData) { 
		if (iGraph == 1) { // PIE			
			loader.setParameter("LEGEND","FALSE");
			loader.setParameter("SERIE_1","Pie");
			loader.setParameter("SERIE_TYPE_1","PIE");
			loader.setParameter("SERIE_FONT_1","ARIAL|BOLD|12");
			loader.setParameter("PIECHART_3D","true");
			loader.setParameter("PIE_LABEL_FORMAT","#LABEL#: #VALUE# (#PERCENTAGE#)");
			//loader.setParameter("SERIE_TOGETHER_1","true|false|true");
			//loader.setParameter("CHART_BORDER","1|BLACK|LINE");
		} else if (iGraph == 3 || iGraph == 4) { // XY, Histograma
			loader.setParameter("LEGEND", "TRUE");
			loader.setParameter("LEGEND_BORDER", "0.2|BLACK|LINE");
			loader.setParameter("LEGEND_FILL", "WHITE");
			
			loader.setParameter("XSCALE_MIN","0");
			loader.setParameter("YSCALE_MIN","0");
			
			loader.setParameter("GRIDX","true");
			loader.setParameter("GRIDY","true");
			loader.setParameter("XAXIS_START_WITH_BIG_TICK","false");
			loader.setParameter("YAXIS_START_WITH_BIG_TICK","false");
			loader.setParameter("XAXIS_GRID","0.2|BLACK|LINE");
			loader.setParameter("YAXIS_GRID","0.2|BLACK|LINE");
			
			loader.setParameter("YLABEL_VERTICAL","true");
			//XAXIS_ROTATE_LABELS=90 XAXIS_VERTICAL_LABELS=false.
			
			loader.setParameter("LEFT_MARGIN","0.15"); //15%
			loader.setParameter("BOTTOM_MARGIN","0.15"); 
			loader.setParameter("RIGHT_MARGIN","0.05"); 
			loader.setParameter("TOP_MARGIN","0.05"); 
			
			//--
			loader.setParameter("XLABEL","Year");
			loader.setParameter("YLABEL","Units");
		
			//loader.setParameter("YLABEL_VERTICAL","true");
		
			loader.setParameter("YAXIS_INTEGER","false");
			loader.setParameter("YAXIS_LABEL_FORMAT","#,###");
		
			loader.setParameter("TICK_INTERVALX","1");
			loader.setParameter("BIG_TICK_INTERVALX","5");
			
			//TICK_INTERVALY
			loader.setParameter("BIG_TICK_INTERVALY","1");
		}
		
		if (iGraph == 4) { //histograma	
			loader.setParameter("XLABEL","Affectation");
			
			//loader.setParameter("TICK_INTERVALX","1");
			loader.setParameter("BIG_TICK_INTERVALX","1");
			
			loader.setParameter("TICK_INTERVALY","1");
			//loader.setParameter("BIG_TICK_INTERVALY","1");
			
			loader.setParameter("XAXIS_VERTICAL_LABELS","true");
		
			loader.setParameter("YLABEL","# Events");
			//loader.setParameter("YLABEL_VERTICAL","true");
			
			if (iVariables == 32) loader.setParameter("XLABEL","Loss");
		} 
	}
	
	//=========================================================================
	//Data and chart values
	
	if (iGraph == 1) { // PIE	
	
		int iColor = 1;
		String Values = "";
		String Labels = "";
		
		if (iSpecial == 1) {
			/*
			// Opción: ejecutar consulta predefinida y obtener el número de registros naturales
			//		   cambiar NOT NULL a NULL y obtener el número de registros antrópicos
			// SELECT COUNT(*) FROM LEC_IdSuceso LEFT JOIN fichas f ON f.clave = LEC_IdSuceso.claveFichas WHERE OldCat IS NOT NULL AND status = 0;
			// SELECT COUNT(*) FROM LEC_IdSuceso LEFT JOIN fichas f ON f.clave = LEC_IdSuceso.claveFichas WHERE OldCat IS NULL AND status = 0;
			*/
			sQuery = "SELECT "
					+ "(SELECT COUNT(*) FROM LEC_IdSuceso WHERE OldCat IS NULL), "
					+ "(SELECT COUNT(*) FROM LEC_IdSuceso WHERE OldCat IS NOT NULL), "
					+ "MAX(Cause) "
					+ "FROM LEC_IdSuceso ";
			rset = stmt.executeQuery(sQuery);
			if (rset.first()) {
				Labels = "Antrophic|Natural";
				Values = String.valueOf(rset.getDouble(1)) + "|" + String.valueOf(rset.getDouble(2));
				
				if (!bOnlyData) {
					loader.setParameter("PIE_STYLE_1",(String)alColors.get(0));
					loader.setParameter("PIE_STYLE_2",(String)alColors.get(1));
				}
			}
		} else {
			rset = stmt.executeQuery(sQuery);
			while (rset.next()) {
				String cat = rset.getString(1);
				Labels += cat + "|";

				Values += String.valueOf(rset.getDouble(2)) + "|";
				//Values += String.valueOf(rset.getInt(2)) + "|";

				if (!bOnlyData) loader.setParameter("PIE_STYLE_" + String.valueOf(iColor),(String)alColors.get(iColor-1));
				iColor++;
			}
		}
		
		if (!bOnlyData) {
			loader.setParameter("SERIE_DATA_1",Values);
			//Labels, usados en el grafico al lado del valor
			//Names used in the legend : loader.setParameter("PIE_NAME_" + ,"qqq");
			loader.setParameter("SERIE_LABELS_1",Labels);
		} 
		
		//Print chart data
		out.print(Labels + "</br>");
		out.print(Values + "</br>");
	
	} else if (iGraph == 3) { // XY

		ArrayList alKeys = new ArrayList();
		HashMap hmXVal = new HashMap();
		HashMap hmYVal = new HashMap();

		double dXmax = Double.MIN_VALUE;
		double dXmin = Double.MAX_VALUE;
		double dYmax = Double.MIN_VALUE;
		double dYmin = Double.MAX_VALUE;

		rset = stmt.executeQuery(sQuery);
		
		int iDataCol = 2;
		if (iSeries == 1) iDataCol = 1;
		
		while (rset.next()){
		
            String sRowLbl = "Total";
			if (iSeries != 1) sRowLbl = rset.getString(2);
			
			for (int i = 1; i <= iNVars; i++){
				String rowLbl = sRowLbl + " - " + (String) hmVars.get(String.valueOf(i));
				if (iNVars == 1) rowLbl = sRowLbl;
				
				if (!alKeys.contains(rowLbl)) {
					alKeys.add(rowLbl);
					hmXVal.put(rowLbl, "");
					hmYVal.put(rowLbl, "");
				}
				
				double dAnio = (double) rset.getInt(1);
				if (dXmax<dAnio) dXmax = dAnio;if (dXmin>dAnio) dXmin = dAnio;
				
				double dYVal;
				//if (sOperator.equals("SUM")) {
					dYVal = rset.getDouble(iDataCol + i);
				//} else {
				//	dYVal = (double) rset.getInt(3);
				//}
				if (dYmax<dYVal) dYmax = dYVal;if (dYmin>dYVal) dYmin = dYVal;
				
				String sPrevX = (String) hmXVal.get(rowLbl);
				String sPrevY = (String) hmYVal.get(rowLbl);
				
				hmXVal.put(rowLbl, sPrevX + String.valueOf(dAnio) + "|");
				hmYVal.put(rowLbl, sPrevY + String.valueOf(dYVal) + "|");
			}  
        }
		
		if (!bOnlyData) {
			loader.setParameter("TICK_INTERVALY",String.valueOf((int)(dYmax/10)));
			
			loader.setParameter("XSCALE_MIN",String.valueOf(dXmin));
			loader.setParameter("XSCALE_MAX",String.valueOf(dXmax));
			//loader.setParameter("YSCALE_MIN",String.valueOf(dYMin));
			loader.setParameter("YSCALE_MAX",String.valueOf(dYmax));
		}
		
		for (int i = 0; i < alKeys.size(); i++) {
		
			String sSeries = String.valueOf(i+1);
			String slbl = (String) alKeys.get(i);
			
			//Print chart data
			out.print(slbl + "<br/>"
						+ "Xdata: " + (String) hmXVal.get(slbl) + "<br/>"
						+ "Ydata: " +(String) hmYVal.get(slbl) + "<br/>" + "<br/>");
			
			if (!bOnlyData) {
				loader.setParameter("SERIE_" + sSeries ,slbl);
				//loader.setParameter("SERIE_FONT_1","Arial|PLAIN|10");
				//SERIE_COLOR_1=RED
				loader.setParameter("SERIE_DATA_" + sSeries,(String) hmYVal.get(slbl));
				loader.setParameter("SERIE_DATAX_" + sSeries,(String) hmXVal.get(slbl));
				loader.setParameter("SERIE_STYLE_" + sSeries,"1|"+(String)alColors.get(i)+"|LINE");
				
				//loader.setParameter("SERIE_FORMAT_"+ sSeries,"#.0");

				loader.setParameter("SERIE_POINT_" + sSeries,"FALSE");
				//SERIE_POINT_1=true
				//SERIE_POINT_COLOR_1=RED        
			}
		}

	} else if (iGraph == 4) {		
		
		ArrayList alKeys = new ArrayList();
		HashMap hmXVal = new HashMap();
		HashMap hmYVal = new HashMap();

		double dXmax = Double.MIN_VALUE;
		double dXmin = Double.MAX_VALUE;
		double dYmax = Double.MIN_VALUE;
		double dYmin = Double.MAX_VALUE;

		int iLastRango = -1;

		//Statement stmt2 = con.createStatement();
		//ResultSet rset2;
		
		int iTPeriodo = 1;
		if (iSpecial == 1) {
			rset = stmt.executeQuery("SELECT COUNT(q1.a) FROM (SELECT anio as a FROM LEC_IdSuceso WHERE OldCat IS NOT NULL AND status = 0 GROUP BY anio) q1");
			if (rset.first()) iTPeriodo = rset.getInt(1);
		}
		
		//sQuery = sQueryA + "SUM(f.heridos)" + sQuery + "100" + sQueryB;
		
		for (int iVar = 1; iVar <= iNVars; iVar++) {
			
			String sQVar = (String) hmVarsQuery.get(String.valueOf(iVar));			
			if (sQVar.length() > 0) { //Proceso la variable
				
				for (int i = 0; i < iRangos.length; i ++){
					int iLimite = iRangos[i];
					
					rset = stmt.executeQuery(sQueryA + sQVar + sQuery + iLimite + sQueryB);
					while (rset.next()){
					
						String sRowLbl = "Total";
						if (iSeries != 1) sRowLbl = rset.getString(1);
						
						String rowLbl = sRowLbl + " - " + (String) hmVars.get(String.valueOf(iVar));
						if (iNVars == 1) rowLbl = sRowLbl;
						
						if (!alKeys.contains(rowLbl)) {
							alKeys.add(rowLbl);
							hmYVal.put(rowLbl, "");
						}
						
						double dYVal;
						
						if (iSeries != 1) dYVal = rset.getDouble(2); else dYVal = rset.getDouble(1);
						
						if (dYVal > 0) { 
							if (dXmax<iLimite) dXmax = iLimite;if (dXmin>iLimite) dXmin = iLimite;
							if (i > iLastRango) iLastRango = i;
							
							if (dYmax<dYVal) dYmax = dYVal;if (dYmin>dYVal) dYmin = dYVal;
							
							String sPrevY = (String) hmYVal.get(rowLbl);
							hmYVal.put(rowLbl, sPrevY + String.valueOf(dYVal) + "|");
						}
					}
				}
				
			}
		}
		
		String sHistLabel = sLabels[0];
		for (int i = 1; i <= iLastRango; i++) {
			sHistLabel += "|" + sLabels[i];
		}
			
		if (iSpecial == 0) {
			
			if (!bOnlyData) {
				loader.setParameter("BARCHART_BARSPACE","1");

				loader.setParameter("TICK_INTERVALY",String.valueOf((int)(dYmax/10)));
				loader.setParameter("YSCALE_MAX",String.valueOf(dYmax));

				//out.print(iLastRango + " : " + sHistLabel + "</br>");
				loader.setParameter("XAXIS_LABELS",sHistLabel);
			}
			
			for (int i = 0; i < alKeys.size(); i++) {
				String sSeries = String.valueOf(i+1);
				String slbl = (String) alKeys.get(i);
				
				//Print chart data
				out.print(slbl + "<br/>"
						+ "Xlabel (global): " + sHistLabel + "<br/>"
						+ "Ydata: " + (String) hmYVal.get(slbl) + "<br/>" + "<br/>");
				
				if (!bOnlyData) {
					loader.setParameter("SERIE_" + sSeries ,slbl);
					loader.setParameter("SERIE_TYPE_" + sSeries ,"BAR");
					loader.setParameter("SERIE_BORDER_TYPE_" + sSeries ,"RISED");
					//loader.setParameter("SERIE_FONT_1","Arial|PLAIN|10");
					
					loader.setParameter("SERIE_DATA_" + sSeries,(String) hmYVal.get(slbl));
					//loader.setParameter("SERIE_DATAX_" + sSeries,(String) hmXVal.get(slbl));
					loader.setParameter("SERIE_BAR_STYLE_" + sSeries,(String)alColors.get(i));
				}				
			}
			
		} else if (iSpecial == 1) {
			
			if (!bOnlyData) {
				loader.setParameter("TICK_LOG_INTERVALY","true");
				loader.setParameter("TICK_LOG_INTERVALX","true");
				
				loader.setParameter("XSCALE_MIN",String.valueOf(Math.pow(10, (long) Math.log10(dXmin))));
				loader.setParameter("XSCALE_MAX",String.valueOf(Math.pow(10, (long) Math.log10(dXmax) + 1)));
				
				loader.setParameter("YSCALE_MIN",String.valueOf(Math.pow(10, (long) Math.log10(dYmin/iTPeriodo) - 1)));
				loader.setParameter("YSCALE_MAX",String.valueOf(Math.pow(10, (long) Math.log10(dYmax/iTPeriodo) + 1)));
				
				loader.setParameter("YLABEL","Frecuency of events (1/year)");
				//loader.setParameter("YLABEL_VERTICAL","true");
				
				loader.setParameter("YAXIS_INTEGER","false");
				loader.setParameter("YAXIS_LABEL_FORMAT","#,###.0###");
				
				loader.setParameter("YSCALE_LOG","true");
				loader.setParameter("YSCALE_LOG_BASE","10");
				loader.setParameter("XSCALE_LOG","true");
				loader.setParameter("XSCALE_LOG_BASE","10");
			}
			
			for (int i = 0; i < alKeys.size(); i++) {
				String sSeries = String.valueOf(i+1);
				String slbl = (String) alKeys.get(i);
				
				String SX = "";
				String SY = "";
				
				String sYString = (String) hmYVal.get(slbl);
				String sYVals[] = sYString.split("\\|");
				
				SX = String.valueOf(iRangos[0]);
				SY = String.valueOf(Double.parseDouble(sYVals[0]) / iTPeriodo);
				for (int j = 1; j < sYVals.length; j++) {
					SX += "|" + String.valueOf(iRangos[j]);
					SY += "|" + String.valueOf(Double.parseDouble(sYVals[j])/iTPeriodo);
				}
				
				//Print chart data
				out.print(slbl + "<br/>"
						+ "Periodo: " + iTPeriodo + " años" + "<br/>"
						+ "Eventos: " + (String) hmYVal.get(slbl) + "<br/>"
						+ "XLabel: " + sHistLabel + "<br/>"
						+ "Xdata: " + SX + "<br/>"
						+ "Ydata: " + SY + "<br/>"
						+ "<br/>");
				
				if (!bOnlyData) {
					loader.setParameter("SERIE_" + sSeries ,slbl);
					//loader.setParameter("SERIE_FONT_1","Arial|PLAIN|10");
					loader.setParameter("SERIE_DATA_" + sSeries,SY);
					
					//loader.setParameter("SERIE_DATAX_" + sSeries,(String) hmXVal.get(slbl));
					loader.setParameter("SERIE_DATAX_" + sSeries,SX);
					loader.setParameter("SERIE_STYLE_" + sSeries,"1|"+(String)alColors.get(i)+"|LINE");
					
					//loader.setParameter("SERIE_FORMAT_"+ sSeries,"#.0");

					loader.setParameter("SERIE_POINT_" + sSeries,"FALSE");
					//SERIE_POINT_1=true
					//SERIE_POINT_COLOR_1=RED        
				}				
			}			
		}		
		
	}
	
	//=========================================================================
	//Chart
	
	if (!bOnlyData) {

		// create chart
		String encode="jpeg";
		response.setContentType("image/"+encode);
		response.setDateHeader ("Expires",0);

		loader.setParameter("CHART_FILL","WHITE");

		// get output stream
		java.io.OutputStream outb=response.getOutputStream();

		com.java4less.rchart.Chart chart=loader.build(false,false);
		
		// set size of the chart
		chart.setSize(w,h);
		
		// encode image and send output to the browser
		chart.saveToFile(outb,encode);			
		outb.close();

	}
	
	if (bDebug) out.print(" - BYE");
%>
