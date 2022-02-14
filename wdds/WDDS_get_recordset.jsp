<?xml version="1.0" encoding="UTF-8"?>
<disaster_recordset xmlns="https://www.gripweb.org/wdds/wdds_r" version="1.0.0">
<!-- Disaster Database data: record set -->
<%@ page import="java.io.*" %><%@ page import="java.sql.*" %><%@ page import="java.util.*" %><%@ page import="java.net.*" %><%@ page import="java.text.*" %>
<%@ page import="org.lared.desinventar.system.Sys" %><%@ page import="org.lared.desinventar.util.*" %><%@ page import="org.lared.desinventar.webobject.*" %>
<% DICountry countrybean=new DICountry();%>
<%@ include file="/wdds/wdds.jspf" %>
<%@ include file="/util/opendatabase.jspf" %><%
response.setHeader("Content-Type", "text/xml; charset=utf-8");
/*
response.setHeader("Pragma", "no-cache");
response.setHeader("Cache-Control", "no-cache");
response.setDateHeader("Expires", 0);%>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="cache-control" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="01-01-1999">
<%// Get all WDDS parameters
*/
String sWDDSFormatRequest=htmlServer.not_null(request.getParameter("FORMAT"));
String sWDDSLanguage=htmlServer.not_null(request.getParameter("LANGUAGE"));
String sWDDSInternalID=htmlServer.not_null(request.getParameter("INTERNAL"));
String sWDDSGlide=htmlServer.not_null(request.getParameter("GLIDE"));
String sWDDSEvent=htmlServer.not_null(request.getParameter("EVENTS"));
String sWDDSGeocode=htmlServer.not_null(request.getParameter("GEOCODES"));
String sWDDSLevel=htmlServer.not_null(request.getParameter("LEVEL"));
if (sWDDSLevel.length()==0) sWDDSLevel+="0";
String sWDDSDateFrom=htmlServer.not_null(request.getParameter("DATEFROM"));
String sWDDSDateTo=htmlServer.not_null(request.getParameter("DATETO"));

initWebDisasterDataService();
stmt=con.createStatement();
ArrayList sqlparams=new ArrayList();
PreparedStatement pstmt=null;

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
String[] asWddsEvents = countrybean.loadArrayParameter(request, "EVENTS");
if (asWddsEvents!=null)
	{
	ArrayList aEvents=new ArrayList();
	int nEvents=0;
	rset=stmt.executeQuery("select nombre_en, nombre from eventos");
	while (rset.next())
		{
		String sDIEvent_en=rset.getString(1);
		String sDIEvent=rset.getString(2);
		if (sDIEvent_en==null)
		 sDIEvent_en=sDIEvent;
		for (int k=0; k<asWddsEvents.length; k++)
	   		{
			if (asWddsEvents[k].equals((String)hmStandardEvents.get(sDIEvent_en.toUpperCase())))
			   aEvents.add(sDIEvent);
			}
		}
	if (aEvents.size()>0)
		{
		countrybean.asEventos=new String[aEvents.size()];
		for (int k=0; k<aEvents.size(); k++)
		 	countrybean.asEventos[k]=(String) aEvents.get(k);
		countrybean.bHayEventos = true;
		}
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
 
// get this URL
String sRequest=new String(request.getRequestURL());
// get the hostname
URL thisURL=new URL(sRequest);
   String sHost="http://"+thisURL.getHost();
int nPort=request.getLocalPort();
if (nPort!=80)
   sHost+=":"+nPort;

fichas woFicha=new fichas();
extension woExtension=new extension();
// loads the extension definition
woExtension.dbType=dbType;
woExtension.loadExtension(con,countrybean);
org.lared.desinventar.webobject.Dictionary dct = new org.lared.desinventar.webobject.Dictionary();
String sWhere=countrybean.getWhereSql(sqlparams);
if (sWDDSInternalID.length()>0)
	{
	sWhere+=" AND (fichas.serial='"+sWDDSInternalID+"')";
    }
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
	while (rset.next())
		{
		irec++;
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
 
		%>
		
<disaster_record_data>
  <internal_id><%=woFicha.serial%></internal_id>	
   <glide><%=woFicha.glide%></glide>
   <timestamp><%=sStartDate%></timestamp>
   <timestamp_end><%=sStartDate%></timestamp_end>
   <crs>crs:84</crs>
   <longitude></longitude>
   <latitude></latitude>
   <information_source><%=woFicha.fuentes%></information_source >
   <geographic_code><%=woFicha.level0%></geographic_code>
   <geographic_code><%=woFicha.level1%></geographic_code>
   <geographic_code><%=woFicha.level2%></geographic_code>
<% String sStdCode=getStandardEventCode(woFicha.evento.toUpperCase());
   if (sStdCode!=null){
%>			<event_type><%=EncodeUtil.xmlEncode(sStdCode)%></event_type>
<% }
else
   {
%>			<event_type><%=EncodeUtil.xmlEncode(woFicha.evento)%></event_type>
<%}%>		

   <other_event_types>
<% sStdCode=getStandardEventCode(woFicha.causa.toUpperCase());
   if (sStdCode!=null){
%>			<event_type><%=EncodeUtil.xmlEncode(sStdCode)%></event_type>
<%}%>		
   </other_event_types>
   <effects>	
			<effect code="Killed"><%=woFicha.muertos%></effect>
			<effect code="Missing"><%=woFicha.desaparece%></effect>
			<effect code="Injured"><%=woFicha.heridos%></effect>
			<effect code="Relocated"><%=woFicha.reubicados%></effect>
			<effect code="Evacuated"><%=woFicha.evacuados%></effect>
			<effect code="Houses_Destroyed"><%=woFicha.vivdest%></effect>
			<effect code="Houses_Damaged"><%=woFicha.vivafec%></effect>
			<effect code="Description"><%=woFicha.di_comments%></effect>
			<effect code="Affected"><%=woFicha.afectados%></effect>
			<effect code="Victims"><%=woFicha.damnificados%></effect>
			<effect code="Total_Losses_USD"><%=woFicha.valorus%></effect>
			<effect code="Total_Losses_local"><%=woFicha.valorloc%></effect>
			<effect code="Livestock"><%=woFicha.cabezas%></effect>
			<effect code="Crops_affected"><%=woFicha.nhectareas%></effect>
			<effect code="Schools_affected"><%=woFicha.nescuelas%></effect>
			<effect code="Health_facilities_affected"><%=woFicha.nhospitales%></effect>
			<effect code="KM_Roads_affected"><%=woFicha.kmvias%></effect>
			<effect code="Event_Magnitude"><%=woFicha.magnitud2%></effect>
			<effect code="cause"><%=woFicha.causa%></effect>
			<effect code="descr_cause"><%=woFicha.descausa%></effect>
			<effect code="other_effects"><%=woFicha.otros%></effect>
			<effect code="with_deaths"><%=woFicha.hay_muertos%></effect>
			<effect code="with_injured"><%=woFicha.hay_heridos%></effect>
			<effect code="with_missing"><%=woFicha.hay_deasparece%></effect>
			<effect code="with_houses_destroyed"><%=woFicha.hay_vivdest%></effect>
			<effect code="with_houses_affected"><%=woFicha.hay_vivafec%></effect>
			<effect code="with_victims"><%=woFicha.hay_damnificados%></effect>
			<effect code="with_affected"><%=woFicha.hay_afectados%></effect>
			<effect code="with_relocated"><%=woFicha.hay_reubicados%></effect>
			<effect code="with_evacuated"><%=woFicha.hay_evacuados%></effect>
			<effect code="education"><%=woFicha.educacion%></effect>
			<effect code="health"><%=woFicha.salud%></effect>
			<effect code="agriculture"><%=woFicha.agropecuario%></effect>
			<effect code="water"><%=woFicha.acueducto%></effect>
			<effect code="sewage"><%=woFicha.alcantarillado%></effect>
			<effect code="industry"><%=woFicha.industrias%></effect>
			<effect code="communications"><%=woFicha.comunicaciones%></effect>
			<effect code="transportation"><%=woFicha.transporte%></effect>
			<effect code="power_energy"><%=woFicha.energia%></effect>
			<effect code="relief"><%=woFicha.socorro%></effect>
			<effect code="with_other_sectors"><%=woFicha.hay_otros%></effect>
<%
for (int k = 0; k < woExtension.vFields.size(); k++)
	     {
		  dct = (org.lared.desinventar.webobject.Dictionary) woExtension.vFields.get(k);
  	 	  dct.countrybean=countrybean;
%>			<effect code="<%=dct.label_campo%>"><%=EncodeUtil.xmlEncode(dct.getValue())%></effect>
<%	     }%>
   </effects>		
</disaster_record_data>
<% 	// close the database object 
		}
	}
catch (Exception e)
{
out.println("<ERROR><strong>ERROR: there has been an error executing your query: </strong>: "+e.toString()+"</ERROR>");
}	 
%>
</disaster_recordset><% 	// close the database object 
    try	{rset.close(); }catch (Exception e){out.println("<!-- closing r:"+e.toString()+" -->");}	
	try	{stmt.close();}catch (Exception e){out.println("<!-- closing s:"+e.toString()+" -->");}	
	try	{pstmt.close();}catch (Exception e){out.println("<!-- closing ps:"+e.toString()+" -->");}	
	dbCon.close(); 
%>
