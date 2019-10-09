<%@ page import="java.io.*" %><%@ page import="java.sql.*" %><%@ page import="java.util.*" %><%@ page import="java.net.*" %><%@ page import="java.text.*" %><%@ page import="org.json.*" %>
<%@ page import="org.lared.desinventar.system.Sys" %><%@ page import="org.lared.desinventar.util.*" %><%@ page import="org.lared.desinventar.webobject.*" %>
<% DICountry countrybean=new DICountry();%>
<%@ include file="/wdds/wdds.jspf" %>
<%@ include file="/util/opendatabase.jspf" %><%
response.setHeader("Content-Type", "text/plain; charset=utf-8");
String sWDDSLanguage=htmlServer.not_null(request.getParameter("LANGUAGE"));
String sWDDSInternalID=htmlServer.not_null(request.getParameter("INTERNAL"));
String sWDDSGlide=htmlServer.not_null(request.getParameter("GLIDE"));
String sWDDSEvent=htmlServer.not_null(request.getParameter("EVENTS"));
String sWDDSGeocode=htmlServer.not_null(request.getParameter("GEOCODES"));
String sWDDSLevel=htmlServer.not_null(request.getParameter("LEVEL"));
if (sWDDSLevel.length()==0) 
   sWDDSLevel="0";
String sWDDSDateFrom=htmlServer.not_null(request.getParameter("DATEFROM"));
String sWDDSDateTo=htmlServer.not_null(request.getParameter("DATETO"));
ArrayList sqlparams=new ArrayList();
PreparedStatement pstmt=null;

stmt=con.createStatement();

// convert WDDS parameters to DesInventar events/codes
switch (sWDDSLevel.charAt(0))
	{
	case '2':countrybean.asNivel1 = countrybean.loadArrayParameter(request, "GEOCODES");
    		countrybean.bHayNivel1 = (countrybean.asNivel1!=null);
			break;
	case '3':countrybean.asNivel2 = countrybean.loadArrayParameter(request, "GEOCODES");
    		countrybean.bHayNivel2 = (countrybean.asNivel2!=null);
			break;
	default :countrybean.asNivel0 = countrybean.loadArrayParameter(request, "GEOCODES");
    		countrybean.bHayNivel0 = (countrybean.asNivel0!=null);
			break;
	}
String[] asJsonEvents = countrybean.loadArrayParameter(request, "EVENTS");
if (asJsonEvents!=null)
	{
		countrybean.asEventos=new String[asJsonEvents.length];
		for (int k=0; k<asJsonEvents.length; k++)
		 	countrybean.asEventos[k]= asJsonEvents[k];
		countrybean.bHayEventos = true;
	}
// Process dates:
if (sWDDSDateFrom.length()>0)
	{
	sWDDSDateFrom=countrybean.strDate(sWDDSDateFrom); // will come back as yyyy-mm-dd
	if (sWDDSDateFrom.length()>9)
		{
		countrybean.fromyear = countrybean.extendedParseInt(sWDDSDateFrom.substring(0,4));
	    countrybean.frommonth = countrybean.extendedParseInt(sWDDSDateFrom.substring(5,7));
	    countrybean.fromday = countrybean.extendedParseInt(sWDDSDateFrom.substring(8,10));
		}
	}
if (sWDDSDateTo.length()>0)
	{
	sWDDSDateFrom=countrybean.strDate(sWDDSDateTo); // will come back as yyyy-mm-dd
	if (sWDDSDateFrom.length()>9)
		{
		countrybean.toyear = countrybean.extendedParseInt(sWDDSDateFrom.substring(0,4));
	    countrybean.tomonth = countrybean.extendedParseInt(sWDDSDateFrom.substring(5,7));
	    countrybean.today = countrybean.extendedParseInt(sWDDSDateFrom.substring(8,10));
		}
	}
 
fichas woFicha=new fichas();
extension woExtension=new extension();
// loads the extension definition
woExtension.dbType=dbType;
woExtension.loadExtension(con,countrybean);
org.lared.desinventar.webobject.Dictionary dct = new org.lared.desinventar.webobject.Dictionary();
String sWhere=countrybean.getWhereSql(sqlparams);
if (sWDDSInternalID.length()>0)
	sWhere+=" AND (fichas.serial='"+sWDDSInternalID+"')";
String 	sSql = "SELECT fichas.serial,level0,level1,level2,"+
					"lev0.lev0_name_en as name0, lev1.lev1_name_en as name1, lev2.lev2_name_en as name2"+
                    "name0,name1,name2,"+
					"eventos.nombre_en as evento,"+
					"lugar,fechano,fechames,fechadia,muertos,heridos," +
					"desaparece,afectados,vivdest,vivafec,otros,di_comments,fuentes,valorloc,valorus,fechapor,fechafec," +
					"hay_muertos,hay_heridos,hay_deasparece,hay_afectados,hay_vivdest,hay_vivafec,hay_otros," +
					"socorro,salud,educacion,agropecuario,industrias,acueducto,alcantarillado,energia,comunicaciones," +
					"fichas.causa,descausa,transporte,magnitud2,nhospitales,nescuelas,nhectareas,cabezas,kmvias," +
					"duracion,damnificados,evacuados,hay_damnificados,hay_evacuados,hay_reubicados,reubicados,clave,glide,defaultab,approved"+
	                ", extension.* "+sWhere+" order by " +countrybean.getSortbySql();
try
	{
	pstmt=con.prepareStatement(sSql);
	for (int k=0; k<sqlparams.size(); k++)
				pstmt.setString(k+1, (String)sqlparams.get(k));
	rset=pstmt.executeQuery();
	int irec=0;
	out.println("{[");
	while (rset.next())
		{
		woFicha.loadWebObject(rset);
		woExtension.loadWebObject(rset);
   	    String sStartDate=woFicha.strDate(woFicha.fechano, Math.max(1,woFicha.fechames), Math.max(1,woFicha.fechadia));
		String sEndDate=sStartDate;
		java.util.Date tmpDate = woFicha.formatter.parse(sStartDate, new ParsePosition(0));
		if (tmpDate!=null)
			{
			Calendar cCal=Calendar.getInstance();
    		cCal.setTime(tmpDate);
			cCal.add(Calendar.DATE, woFicha.duracion);
			sEndDate=woFicha.strDate(cCal.getTime());
			}			
		JSONObject recordObj = new JSONObject();  
		recordObj.put("serial","\""+woFicha.serial+"\"");
		recordObj.put("glide","\""+woFicha.glide+"\"");
		recordObj.put("timestamp","\""+sStartDate+"\"");
		recordObj.put("duration","\""+woFicha.duracion+"\"");
		recordObj.put("longitude","\""+woFicha.longitude+"\"");
		recordObj.put("latitude","\""+woFicha.latitude+"\"");
		recordObj.put("information_source","\""+woFicha.fuentes+"\"");
		recordObj.put("level0","\""+woFicha.level0+"\"");
		recordObj.put("level1","\""+woFicha.level1+"\"");
		recordObj.put("level2","\""+woFicha.level2+"\"");
		recordObj.put("name0","\""+woFicha.name0+"\"");
		recordObj.put("name1","\""+woFicha.name1+"\"");
		recordObj.put("name2","\""+woFicha.name2+"\"");
		recordObj.put("hazard","\""+woFicha.evento+"\"");
		recordObj.put("serial","\""+woFicha.serial+"\"");
		recordObj.put("serial","\""+woFicha.serial+"\"");
		recordObj.put("serial","\""+woFicha.serial+"\"");
 
		recordObj.put("Killed","\""+woFicha.muertos+"\"");
		recordObj.put("Missing","\""+woFicha.desaparece+"\"");
		recordObj.put("Injured","\""+woFicha.heridos+"\"");
		recordObj.put("Relocated","\""+woFicha.reubicados+"\"");
		recordObj.put("Evacuated","\""+woFicha.evacuados+"\"");
		recordObj.put("Houses_Destroyed","\""+woFicha.vivdest+"\"");
		recordObj.put("Houses_Damaged","\""+woFicha.vivafec+"\"");
		recordObj.put("Description","\""+woFicha.di_comments+"\"");
		recordObj.put("Affected","\""+woFicha.afectados+"\"");
		recordObj.put("Victims","\""+woFicha.damnificados+"\"");
		recordObj.put("Total_Losses_USD","\""+woFicha.valorus+"\"");
		recordObj.put("Total_Losses_local","\""+woFicha.valorloc+"\"");
		recordObj.put("Livestock","\""+woFicha.cabezas+"\"");
		recordObj.put("Crops_affected","\""+woFicha.nhectareas+"\"");
		recordObj.put("Schools_affected","\""+woFicha.nescuelas+"\"");
		recordObj.put("Health_facilities_affected","\""+woFicha.nhospitales+"\"");
		recordObj.put("KM_Roads_affected","\""+woFicha.kmvias+"\"");
		recordObj.put("Event_Magnitude","\""+woFicha.magnitud2+"\"");
		recordObj.put("cause","\""+woFicha.causa+"\"");
		recordObj.put("descr_cause","\""+woFicha.descausa+"\"");
		recordObj.put("other_effects","\""+woFicha.otros+"\"");
		recordObj.put("with_deaths","\""+woFicha.hay_muertos+"\"");
		recordObj.put("with_injured","\""+woFicha.hay_heridos+"\"");
		recordObj.put("with_missing","\""+woFicha.hay_deasparece+"\"");
		recordObj.put("with_houses_destroyed","\""+woFicha.hay_vivdest+"\"");
		recordObj.put("with_houses_affected","\""+woFicha.hay_vivafec+"\"");
		recordObj.put("with_victims","\""+woFicha.hay_damnificados+"\"");
		recordObj.put("with_affected","\""+woFicha.hay_afectados+"\"");
		recordObj.put("with_relocated","\""+woFicha.hay_reubicados+"\"");
		recordObj.put("with_evacuated","\""+woFicha.hay_evacuados+"\"");
		recordObj.put("education","\""+woFicha.educacion+"\"");
		recordObj.put("health","\""+woFicha.salud+"\"");
		recordObj.put("agriculture","\""+woFicha.agropecuario+"\"");
		recordObj.put("water","\""+woFicha.acueducto+"\"");
		recordObj.put("sewage","\""+woFicha.alcantarillado+"\"");
		recordObj.put("industry","\""+woFicha.industrias+"\"");
		recordObj.put("communications","\""+woFicha.comunicaciones+"\"");
		recordObj.put("transportation","\""+woFicha.transporte+"\"");
		recordObj.put("power_energy","\""+woFicha.energia+"\"");
		recordObj.put("relief","\""+woFicha.socorro+"\"");
		recordObj.put("with_other_sectors","\""+woFicha.hay_otros+"\"");

/*
        for (int k = 0; k < woExtension.vFields.size(); k++)
	     {
		  dct = (org.lared.desinventar.webobject.Dictionary) woExtension.vFields.get(k);
  	 	  dct.countrybean=countrybean;
		  recordObj.put("\""+dct.label_campo+"\"","\""+dct.getValue()+"\"");
		 }
		
*/
		// spits this object
		if (irec>0)
		   out.println(",");

		out.print(recordObj.toString());  
		irec++;
	  }
		
	}
	catch (Exception e)
	{
	out.println("<ERROR><strong>ERROR: there has been an error executing your query: </strong>: "+e.toString()+"</ERROR>");
	}

	out.println("]}");
	 
 	// close the database object 
    try	{rset.close(); }catch (Exception e){out.println("<!-- closing r:"+e.toString()+" -->");}	
	try	{stmt.close();}catch (Exception e){out.println("<!-- closing s:"+e.toString()+" -->");}	
	try	{pstmt.close();}catch (Exception e){out.println("<!-- closing ps:"+e.toString()+" -->");}	
	dbCon.close(); 
%>
