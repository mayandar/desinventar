<?xml version="1.0" encoding="UTF-8"?>
<%@ page import="java.io.*" %><%@ page import="java.sql.*" %><%@ page import="java.util.*" %><%@ page import="java.net.*" %><%@ page import="java.text.*" %>
<%@ page import="org.lared.desinventar.system.Sys" %><%@ page import="org.lared.desinventar.util.*" %><%@ page import="org.lared.desinventar.webobject.*" %>
<% DICountry countrybean=new DICountry();%>
<%@ include file="/wdds/wdds.jspf" %>
<%@ include file="/util/opendatabase.jspf" %><%
response.setHeader("Content-Type", "text/xml; charset=utf-8");
// get this URL
String sRequest=new String(request.getRequestURL());
// get the hostname
URL thisURL=new URL(sRequest);
   String sHost="http://"+thisURL.getHost();
int nPort=request.getLocalPort();
if (nPort!=80)
   sHost+=":"+nPort;

initWebDisasterDataService();
stmt=con.createStatement();
ArrayList sqlparams=new ArrayList();
PreparedStatement pstmt=null;

%><!-- Disaster Database Metadata -->
<disaster_database xmlns="http://www.gripweb.org/wdds/wdds_d" version="1.0.0">
	<name_of_database><%=EncodeUtil.xmlEncode(countrybean.countryname)%></name_of_database>
	<description>Disaster database built using DesInventar 7.0</description>
	<format>XML</format>
	<institution><%=EncodeUtil.xmlEncode(countrybean.country.sinstitution)%></institution>
	<copyright >Copyright notice. </copyright >
	<observation>National</observation>
	<resolution><%=EncodeUtil.xmlEncode(countrybean.asLevels[2]+"/"+countrybean.asLevels[1]+"/"+countrybean.asLevels[0])%></resolution>
	<languages>
 		<language><%=EncodeUtil.xmlEncode(countrybean.getLanguage())%></language>
	</languages>
	 <events>
		<standard_events><% 
		rset=stmt.executeQuery("SELECT nombre, nombre_en, descripcion from eventos");
		while (rset.next())
			{
			String sCode=rset.getString(1);
			String sCode0=rset.getString(2);
			String sStdCode=getStandardEventCode(sCode0.toUpperCase());
			if (sStdCode!=null)
				{%>		
			<event_type>
				<event_code><%=EncodeUtil.xmlEncode(sStdCode)%></event_code>
				<event_name_english><%=EncodeUtil.xmlEncode(sCode0)%></event_name_english>
				<event_name_local><%=EncodeUtil.xmlEncode(sCode)%></event_name_local>
			</event_type><%
			    }		
		    }%>	
		</standard_events>
		<non_standard_events>
	<% 
	rset=stmt.executeQuery("SELECT nombre, nombre_en, descripcion from eventos");
	while (rset.next())
		{
		String sCode=rset.getString(1);
		String sCode0=rset.getString(2);
		String sStdCode=getStandardEventCode(sCode0.toUpperCase());
		if (sStdCode==null)
			{%>		
			<event_type>
				<event_code><%=EncodeUtil.xmlEncode(sCode0)%></event_code>
				<event_name_english><%=EncodeUtil.xmlEncode(sCode0)%></event_name_english>
				<event_name_local><%=EncodeUtil.xmlEncode(sCode)%></event_name_local>
				<event_description_local><%=EncodeUtil.xmlEncode(countrybean.not_null(rset.getString(3)))%></event_description_local>
				<event_description_english></event_description_english>
			</event_type><%
			}		
		 }%>	
		</non_standard_events>
		</events>
		<effects>
		<standard_effects>
			<effect_type><effect_code>Killed</effect_code><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("Deaths"))%></effect_name_local><effect_name_english>Deaths</effect_name_english></effect_type>
			<effect_type><effect_code>Missing</effect_code><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("Missing"))%></effect_name_local><effect_name_english>Missing</effect_name_english></effect_type>
			<effect_type><effect_code>Injured</effect_code><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("Injured"))%></effect_name_local><effect_name_english>Injured</effect_name_english></effect_type>
			<effect_type><effect_code>Relocated</effect_code><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("Relocated"))%></effect_name_local><effect_name_english>Relocated</effect_name_english></effect_type>
			<effect_type><effect_code>Evacuated</effect_code><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("Evacuated"))%></effect_name_local><effect_name_english>Evacuated</effect_name_english></effect_type>
			<effect_type><effect_code>Houses_Destroyed</effect_code><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("DestroyedHouses"))%></effect_name_local><effect_name_english>Houses Destroyed</effect_name_english></effect_type>
			<effect_type><effect_code>Houses_Damaged</effect_code><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("AffectedHouses"))%></effect_name_local><effect_name_english>Houses Damaged</effect_name_english></effect_type>
			<effect_type><effect_code>Description</effect_code><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("Comments"))%></effect_name_local><effect_name_english>Comments</effect_name_english></effect_type>
			<effect_type><effect_code>Affected</effect_code><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("Affected"))%></effect_name_local><effect_name_english>Affected</effect_name_english></effect_type>
			<effect_type><effect_code>Victims</effect_code><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("Victims"))%></effect_name_local><effect_name_english>Victims</effect_name_english></effect_type>
			<effect_type><effect_code>Total_Losses_USD</effect_code><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("LossesUSD"))%></effect_name_local><effect_name_english>Total Value of economic losses USD</effect_name_english></effect_type>
			<effect_type><effect_code>Total_Losses_local</effect_code><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("LossesLocal"))%></effect_name_local><effect_name_english>Total Value of economic losses local currency</effect_name_english></effect_type>
			<effect_type><effect_code>Livestock</effect_code><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("Catle"))%></effect_name_local><effect_name_english>No. Of Livestock lost</effect_name_english></effect_type>
			<effect_type><effect_code>Crops_affected</effect_code><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("Damagesincrops"))%></effect_name_local><effect_name_english>Ha. Crops affected</effect_name_english></effect_type>
			<effect_type><effect_code>Schools_affected</effect_code><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("Educationcenters"))%></effect_name_local><effect_name_english>Number of Schools affected</effect_name_english></effect_type>
			<effect_type><effect_code>Health_facilities_affected</effect_code><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("Hospitals"))%></effect_name_local><effect_name_english>Number of Health facilities affected</effect_name_english></effect_type>
			<effect_type><effect_code>KM_Roads_affected</effect_code><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("Damagesinroads"))%></effect_name_local><effect_name_english>Number of KM of roads affected</effect_name_english></effect_type>
			<effect_type><effect_code>Event_Magnitude</effect_code><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("Magnitude"))%></effect_name_local><effect_name_english>Magnitude of Event</effect_name_english></effect_type>
		</standard_effects>
		<non_standard_effects>
			<effect_type><effect_code>cause</effect_code><effect_format>alpha</effect_format><effect_name_english>Cause</effect_name_english><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("Cause"))%></effect_name_local><effect_description_english></effect_description_english><effect_description_local></effect_description_local></effect_type>
			<effect_type><effect_code>descr_cause</effect_code><effect_format>alpha</effect_format><effect_name_english>Description cause</effect_name_english><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("DescriptionCause"))%></effect_name_local><effect_description_english></effect_description_english><effect_description_local></effect_description_local></effect_type>
			<effect_type><effect_code>other_effects</effect_code><effect_format>alpha</effect_format><effect_name_english>Other sectors</effect_name_english><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("Othersectors"))%></effect_name_local><effect_description_english></effect_description_english><effect_description_local></effect_description_local></effect_type>
			<effect_type><effect_code>with_deaths</effect_code><effect_format>numeric</effect_format><effect_name_english>With Deaths</effect_name_english><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("WithDeaths"))%></effect_name_local><effect_description_english></effect_description_english><effect_description_local></effect_description_local></effect_type>
			<effect_type><effect_code>with_injured</effect_code><effect_format>numeric</effect_format><effect_name_english>With Injured</effect_name_english><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("WithInjured"))%></effect_name_local><effect_description_english></effect_description_english><effect_description_local></effect_description_local></effect_type>
			<effect_type><effect_code>with_missing</effect_code><effect_format>numeric</effect_format><effect_name_english>With Misssing</effect_name_english><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("WithMissing"))%></effect_name_local><effect_description_english></effect_description_english><effect_description_local></effect_description_local></effect_type>
			<effect_type><effect_code>with_houses_destroyed</effect_code><effect_format>numeric</effect_format><effect_name_english>With Houses Destroyed</effect_name_english><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("WithHousesDestroyed"))%></effect_name_local><effect_description_english></effect_description_english><effect_description_local></effect_description_local></effect_type>
			<effect_type><effect_code>with_houses_affected</effect_code><effect_format>numeric</effect_format><effect_name_english>With Houses Affected</effect_name_english><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("WithHousesAffected"))%></effect_name_local><effect_description_english></effect_description_english><effect_description_local></effect_description_local></effect_type>
			<effect_type><effect_code>with_victims</effect_code><effect_format>numeric</effect_format><effect_name_english>With Victims</effect_name_english><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("WithVictims"))%></effect_name_local><effect_description_english></effect_description_english><effect_description_local></effect_description_local></effect_type>
			<effect_type><effect_code>with_affected</effect_code><effect_format>numeric</effect_format><effect_name_english>With Affected</effect_name_english><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("WithAffected"))%></effect_name_local><effect_description_english></effect_description_english><effect_description_local></effect_description_local></effect_type>
			<effect_type><effect_code>with_relocated</effect_code><effect_format>numeric</effect_format><effect_name_english>With Relocated</effect_name_english><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("WithRelocated"))%></effect_name_local><effect_description_english></effect_description_english><effect_description_local></effect_description_local></effect_type>
			<effect_type><effect_code>with_evacuated</effect_code><effect_format>numeric</effect_format><effect_name_english>With Evacuated</effect_name_english><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("WithEvacuated"))%></effect_name_local><effect_description_english></effect_description_english><effect_description_local></effect_description_local></effect_type>
			<effect_type><effect_code>education</effect_code><effect_format>numeric</effect_format><effect_name_english>Education</effect_name_english><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("Education"))%></effect_name_local><effect_description_english></effect_description_english><effect_description_local></effect_description_local></effect_type>
			<effect_type><effect_code>health</effect_code><effect_format>numeric</effect_format><effect_name_english>Health sector</effect_name_english><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("Health"))%></effect_name_local><effect_description_english></effect_description_english><effect_description_local></effect_description_local></effect_type>
			<effect_type><effect_code>agriculture</effect_code><effect_format>numeric</effect_format><effect_name_english>Agriculture</effect_name_english><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("Agriculture"))%></effect_name_local><effect_description_english></effect_description_english><effect_description_local></effect_description_local></effect_type>
			<effect_type><effect_code>water</effect_code><effect_format>numeric</effect_format><effect_name_english>Water supply</effect_name_english><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("Water"))%></effect_name_local><effect_description_english></effect_description_english><effect_description_local></effect_description_local></effect_type>
			<effect_type><effect_code>sewage</effect_code><effect_format>numeric</effect_format><effect_name_english>Sewerage</effect_name_english><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("Sewerage"))%></effect_name_local><effect_description_english></effect_description_english><effect_description_local></effect_description_local></effect_type>
			<effect_type><effect_code>industry</effect_code><effect_format>numeric</effect_format><effect_name_english>Industries</effect_name_english><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("Industrial"))%></effect_name_local><effect_description_english></effect_description_english><effect_description_local></effect_description_local></effect_type>
			<effect_type><effect_code>communications</effect_code><effect_format>numeric</effect_format><effect_name_english>Communications</effect_name_english><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("Communications"))%></effect_name_local><effect_description_english></effect_description_english><effect_description_local></effect_description_local></effect_type>
			<effect_type><effect_code>transportation</effect_code><effect_format>numeric</effect_format><effect_name_english>Transportation</effect_name_english><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("Transportation"))%></effect_name_local><effect_description_english></effect_description_english><effect_description_local></effect_description_local></effect_type>
			<effect_type><effect_code>power_energy</effect_code><effect_format>numeric</effect_format><effect_name_english>Power and Energy</effect_name_english><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("Power"))%></effect_name_local><effect_description_english></effect_description_english><effect_description_local></effect_description_local></effect_type>
			<effect_type><effect_code>relief</effect_code><effect_format>numeric</effect_format><effect_name_english>Relief</effect_name_english><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("Relief"))%></effect_name_local><effect_description_english></effect_description_english><effect_description_local></effect_description_local></effect_type>
			<effect_type><effect_code>with_other_sectors</effect_code><effect_format>numeric</effect_format><effect_name_english>With other sectors</effect_name_english><effect_name_local><%=EncodeUtil.xmlEncode(countrybean.getTranslation("WithOthersectors"))%></effect_name_local><effect_description_english></effect_description_english><effect_description_local></effect_description_local></effect_type>
<%
extension woExtension=new extension();
woExtension.dbType=countrybean.dbType;
woExtension.loadExtension(con,countrybean);
org.lared.desinventar.webobject.Dictionary dct = new org.lared.desinventar.webobject.Dictionary();
for (int k = 0; k < woExtension.vFields.size(); k++)
	     {
		  dct = (org.lared.desinventar.webobject.Dictionary) woExtension.vFields.get(k);
	      String sFormat="alpha";
		  switch (dct.fieldtype)
			  	{
		        case extension.DATETIME:
					sFormat="date";
					break;
		        case extension.CURRENCY:
		        case extension.FLOATINGPOINT:
		        case extension.INTEGER:
					sFormat="numeric";
					break;
				case extension.YESNO:
				case extension.LIST:
				case extension.CHOICE:
					sFormat="alpha";
					break;
				default:
					sFormat="alpha";
					break;
				}
%>			<effect_type><effect_code><%=dct.nombre_campo%></effect_code><effect_format><%=sFormat%></effect_format><effect_name_english><%=EncodeUtil.xmlEncode(dct.label_campo)%></effect_name_english><effect_name_local><%=EncodeUtil.xmlEncode(dct.label_campo_en)%></effect_name_local><effect_description_english><%=EncodeUtil.xmlEncode(dct.label_campo_en)%></effect_description_english><%=EncodeUtil.xmlEncode(dct.descripcion_campo)%><effect_description_local><%=EncodeUtil.xmlEncode(dct.descripcion_campo)%></effect_description_local></effect_type>
<%	     }%>
		</non_standard_effects>
	</effects>
<%
String sSql="select count(*) as nhits , min(fechano) as dfrom, max(fechano) as dto "+countrybean.getWhereSql(sqlparams); // should bring all APPROVED records
try
	{
	pstmt=con.prepareStatement(sSql,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	for (int k=0; k<sqlparams.size(); k++)
				pstmt.setString(k+1, (String)sqlparams.get(k));
	rset=pstmt.executeQuery();
	}
catch (Exception e)
{
out.println("<br><br><strong>ERROR: there has been an error executing your query: </strong>: "+e.toString()+"<br><br><br>");
}
int nrecs=0;
String dFrom="1900-01-01";
String dTo="2009-12-31";
if (rset.next())
    {
	nrecs=rset.getInt("nhits");
	dFrom=rset.getString("dfrom")+"-01-01";  // FIX!!!
	dTo=rset.getString("dto")+"-12-31";
	}%>
<temporal_coverage>
	<from><%=dFrom%></from>
	<to><%=dTo%></to>
</temporal_coverage>
<records><%=nrecs%></records>
<coverage>
	<country>
		<code><%=EncodeUtil.xmlEncode(countrybean.countrycode)%></code>
		<name_local><%=EncodeUtil.xmlEncode(countrybean.countryname)%></name_local>
		<name_english><%=EncodeUtil.xmlEncode(countrybean.countryname)%></name_english><%		
		rset=stmt.executeQuery("SELECT lev0_cod, lev0_name_en, lev0_name from lev0");
		String sSql1 = "SELECT lev1_cod, lev1_name_en, lev1_name FROM lev1 where (lev1_lev0 = ?)";
		PreparedStatement pstmt1 = con.prepareStatement(sSql1);
		String sSql2 = "SELECT lev2_cod, lev2_name_en, lev2_name FROM lev2 where (lev2_lev1 = ?)";
		PreparedStatement pstmt2 = con.prepareStatement(sSql2);
		ResultSet rset1=null;
		ResultSet rset2=null;
		while (rset.next())
			{
			String sCode0=rset.getString(1);
		%>
		<level1>
			<code><%=EncodeUtil.xmlEncode(sCode0)%></code>
			<name_local><%=EncodeUtil.xmlEncode(rset.getString(2))%></name_local>
			<name_english><%=EncodeUtil.xmlEncode(rset.getString(3))%></name_english><%  
			pstmt1.setString(1,sCode0);
		    rset1=pstmt1.executeQuery();
			while (rset1.next())
				{
				String sCode1=rset1.getString(1);%>
			<level2>
				<code><%=EncodeUtil.xmlEncode(sCode1)%></code>
				<name_local><%=EncodeUtil.xmlEncode(rset1.getString(2))%></name_local>
				<name_english><%=EncodeUtil.xmlEncode(rset1.getString(3))%></name_english><%  
				pstmt2.setString(1,sCode1);
			    rset2=pstmt2.executeQuery();
				while (rset2.next())
					{
					String sCode2=rset2.getString(1);%>
					<level3>
						<code><%=EncodeUtil.xmlEncode(sCode2)%></code>
						<name_local><%=EncodeUtil.xmlEncode(rset2.getString(2))%></name_local>
						<name_english><%=EncodeUtil.xmlEncode(rset2.getString(3))%></name_english>	   
					</level3><%	
					}%>
			</level2><%	
			 	}%>
		</level1><%	
		  	}%>
	</country>
	</coverage>
<website><%=EncodeUtil.xmlEncode(sHost+"/DesInventar/main.jsp?countrycode="+countrybean.countrycode)%></website>
<institutionsite><%=EncodeUtil.xmlEncode("https://www.desinventar.net/")%></institutionsite>
<documentation>
	<document> 
		<type>methodology</type>
		<title>DesInventar Methodology</title> 
		<language>EN</language>
		<link>https://www.desinventar.net/DesInventar/DesInventar%20Methodology.doc</link>
	</document>
	<document> 
		<type>manual</type>
		<title>DesConsultar User manual</title> 
		<language>EN</language>
		<link>https://www.desinventar.net/DesInventar/DesConsultar-UserManual.doc</link>
	</document>
</documentation>
</disaster_database><% 	// close the database object 
    try	{rset.close(); }catch (Exception e){out.println("<!-- closing r:"+e.toString()+" -->");}	
	try	{stmt.close();}catch (Exception e){out.println("<!-- closing s:"+e.toString()+" -->");}	
	try	{pstmt.close();}catch (Exception e){out.println("<!-- closing ps:"+e.toString()+" -->");}	
	try	{pstmt1.close();}catch (Exception e){out.println("<!-- closing ps1:"+e.toString()+" -->");}	
	try	{pstmt2.close();}catch (Exception e){out.println("<!-- closing ps2:"+e.toString()+" -->");}	
	dbCon.close(); 

%>
