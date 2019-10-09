<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<%@ page info="DesConsultar Connection Diagnostics page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.system.Sys" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id = "metaElement" class="org.lared.desinventar.webobject.MetadataElement" scope="session" />
<jsp:useBean id="indicator" class="org.lared.desinventar.webobject.MetadataIndicator" scope="session" />
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%if (user.iusertype<20)
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}%>
<%@ include file="/util/opendatabase.jspf" %>
<%@ taglib uri="/inventag.tld" prefix="inv" %>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/iheader",countrybean.getLanguage(),out);%>
<%@ taglib uri="/inventag.tld" prefix="inv" %>
<%
int nTabActive=9; //
String[] sTabNames={countrybean.getTranslation("Region"),countrybean.getTranslation("Geography"),countrybean.getTranslation("Events"),
           countrybean.getTranslation("Causes"),countrybean.getTranslation("Extension"),countrybean.getTranslation("Query"),
           countrybean.getTranslation("EditData"),countrybean.getTranslation("DataEntry"),countrybean.getTranslation("Admin"),
		   countrybean.getTranslation("Sendai"),countrybean.getTranslation("Security")};
String[] sTabIcons={"","","","","","","","","","","",""};
String[] sTabLinks={"index.jsp","geographytab.jsp","eventab.jsp",
				"causetab.jsp","extendedtab.jsp","querytab.jsp",
				"resultstab.jsp","datacardtab.jsp","admintab.jsp",
				"sendaitab.jsp","securitytab.jsp"};
%>
<%@ include file="/util/tabs.jspf" %>

<script language="JavaScript">
<!--
function bSomethingSelected()
{
var bSome=false;
for (j=0; j<document.desinventar.new_element_key.length; j++)
    if (document.desinventar.new_element_key.selected[j])
		bSome=true;
	
if (document.desinventar.new_element_key.selectedIndex<=0 || bSome)
	{
	alert ("<%=countrybean.getTranslation("Please select an element ")%> <%=countrybean.getTranslation("fromthelist")%>...");
	return false;
	}
return true;
}

function editField(eventId, key, country)
{
	//alert("event_id="+eventId+", key="+key+", country="+country);
	var theForm = document.forms['desinventar'];
	var event = document.createElement('input');
	event.type = 'hidden';
	event.name = eventId ; // 'the key/name of the attribute/field that is sent to the server
	event.value = 'active';
	theForm.appendChild(event);
	var element_key = document.createElement('input');
	element_key.type = 'hidden';
	element_key.name = 'element_key' ; // 'the key/name of the attribute/field that is sent to the server
	element_key.value = key;
	theForm.appendChild(element_key);
	var element_country = document.createElement('input');
	element_country.type = 'hidden';
	element_country.name = 'element_country' ; // 'the key/name of the attribute/field that is sent to the server
	element_country.value = country;
	theForm.appendChild(element_country);
	document.desinventar.submit();
}
// -->
</script>
<%
String sIndicatorKey = request.getParameter("indicator_key");
if(sIndicatorKey != null)
	indicator.indicator_key=indicator.extendedParseInt(sIndicatorKey);
metaElement.init();
metaElement.dbType=countrybean.dbType;
MetadataElementIndicator metaElementIndicator=new MetadataElementIndicator();
MetadataElementLang metalang=new MetadataElementLang();
// if we are adding a new member
metaElement.metadata_element_key=metaElement.extendedParseInt(request.getParameter("new_element_key"));
if (request.getParameter("addMeta")!=null && metaElement.metadata_element_key>0)
	{
	//out.println("Adding key:"+metaElement.metadata_element_key);
	String[] metaKeys=request.getParameterValues("new_element_key");
	for (int j=0; j<metaKeys.length; j++)
		{			
			metaElement.metadata_element_key=metaElement.extendedParseInt(metaKeys[j]);
			dbutils.generateMetadataEntry(indicator.indicator_key, metaElement.metadata_element_key, countrybean, con);	            			
		}
	}
if (request.getParameter("retrieveMeta")!=null)
{
	request.setAttribute("country", countrybean.countrycode);
	request.setAttribute("indicator_key", indicator.indicator_key);
	%><jsp:forward page="importXMLInFrame.jsp?action=4" /><%
}
if (request.getParameter("newMeta")!=null)
	{
	metaElement.init();
	metaElement.metadata_element_key=metaElement.getMaximum("metadata_element_key", "metadata_element",con)+1;
	metaElement.metadata_country=countrybean.countrycode;
	metaElement.addWebObject(con);
	metaElementIndicator.indicator_key=indicator.indicator_key;
	metaElementIndicator.metadata_element_key=metaElement.metadata_element_key;
	metaElementIndicator.metadata_country=countrybean.countrycode;
	metaElementIndicator.addWebObject(con);
	dbutils.generateMetadataExtensions(con,metaElement);
	}
if (request.getParameter("maintaintMetadataElementCosts")!=null)
	{
	metaElement.metadata_element_key=metaElement.extendedParseInt(request.getParameter("element_key"));
	metaElement.metadata_country=request.getParameter("element_country");
	metaElement.getWebObject(con);
	dbCon.close();
	%><jsp:forward page="maintainMetadataElementCosts.jsp"/><%
   }
boolean bSave=(request.getParameter("newMeta")!=null) || (request.getParameter("edit_rice")!=null) || (request.getParameter("addMeta")!=null) || (request.getParameter("saveMeta")!=null) || (request.getParameter("deleteMeta")!=null);
%>

<FORM name="desinventar" method="post" action="metadataGroup.jsp">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>">
<input type="hidden" name="indicator_key" value="<%=indicator.indicator_key%>">
<br/><br/>
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="bss">
<tr>
	<td align="left" valign="top" colspan="14">
	<!-- Content goes after this comment -->
    <table width="90%" border="0">
        <tr><td align="left">
         <font color="Blue"><%=countrybean.getTranslation("Region")%></font>
         <b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font>
          - [<jsp:getProperty name ="countrybean" property="countrycode"/>]
         </td>
        </tr>
    </table>
	<!-- Content goes before this comment -->
	</td>
</tr>
<tr><td align="left" colspan="14">
<span class=subTitle><%=countrybean.getTranslation("DesInventar Sendai Metadata Manager")%></span><br>
<br>
</td></tr>
<tr><td align="left" colspan="14">
<%=countrybean.getTranslation("Select the Metadata Group you want to create/edit:")%>
<br/><br/>
</td></tr>
<tr class="DI_TableHeader bss">
    <td><img src="/DesInventar/images/delete_row.gif" alt="Delete metadata" border=0></td>
    <td>Code</td>
    <td>Type of Asset</td>
    <td>Sector</td>
    <td>Description</td>
    <td>Unit</td>
    <td>Measure</td>
    <td>Average size</td>
    <td>% Equip.</td>
    <td>% Infra.</td>
    <td>% damage</td>
    <td># Workers</td>
    <td>Method/Formula</td>
</tr>
<%
stmt=con.createStatement();
String sSql="Select *  from  (metadata_element e join metadata_element_indicator ei on e.metadata_element_key=ei.metadata_element_key) where e.metadata_country='"
						+countrybean.countrycode+"' and ei.indicator_key="+indicator.indicator_key+" and e.metadata_country=ei.metadata_country  order by e.metadata_element_key";
out.println("<!-- Meta SQL= "+sSql+" -->");
ArrayList<Integer> alDeleted=new ArrayList<Integer>();

if ( request.getParameter("deleteMeta")!=null)
{
	rset=stmt.executeQuery(sSql);
	while (rset.next())
	{
		int mKey=rset.getInt("metadata_element_key");
		if ("Y".equals(request.getParameter("delete"+mKey)))
			alDeleted.add(mKey);
	}
	// deletes all things out of a database cursor..
	for (int j=0; j<alDeleted.size(); j++)
			{
				metaElement.metadata_element_key=alDeleted.get(j);
				metaElement.metadata_country=countrybean.countrycode;
				// delete all related records
				metaElementIndicator.indicator_key=indicator.indicator_key;
				metaElementIndicator.metadata_element_key=metaElement.metadata_element_key;
				metaElementIndicator.metadata_country=countrybean.countrycode.toLowerCase();
				metaElementIndicator.deleteWebObject(con);
				stmt.executeUpdate("delete from metadata_element_lang where metadata_element_key="+metaElement.metadata_element_key+
									" and metadata_country='"+metaElementIndicator.metadata_country+"'");
				stmt.executeUpdate("delete from metadata_element_costs where metadata_element_key="+metaElement.metadata_element_key+
									" and metadata_country='"+metaElementIndicator.metadata_country+"'");			
	
				metaElement.deleteWebObject(con);
				dbutils.removeMetadataExtensions(con,metaElement);
	
			}
}


boolean bLight=true;
String sBgClass="bodymedlight";
// now, all deleted ones are out, regenerates the page
rset=stmt.executeQuery(sSql);
while (rset.next())
{
	metaElement.loadWebObject(rset);
	metalang.metadata_country=countrybean.countrycode;
	metalang.metadata_element_key=metaElement.metadata_element_key;
	metalang.metadata_lang=countrybean.getLanguage().toLowerCase();
	int nLangRecs=metalang.getWebObject(con);
	// if this is a new language, load metalang with English. This may be unnesecary with the above code 
	if (nLangRecs==0)
		{
		metalang.metadata_lang="en";
		metalang.getWebObject(con);
		metalang.metadata_lang=countrybean.getLanguage().toLowerCase();
		}
		
	int k=metaElement.metadata_element_key;  // just to have something very short
	if (bSave && request.getParameter("metadata_element_key"+k)!=null)   // new elements will have no data in the form, not retrieving/saving them
	{
			// GET_FORM()
			metaElement.setMetadata_element_code(metaElement.not_null(request.getParameter("metadata_element_code"+k)));
			metaElement.setMetadata_element_fao(metaElement.not_null(request.getParameter("metadata_element_fao"+k)));
			// these are language dependent fields, go to metalang
			metalang.setMetadata_element_sector(metaElement.not_null(request.getParameter("metadata_element_sector"+k)));
			metalang.setMetadata_element_source(metaElement.not_null(request.getParameter("metadata_element_source"+k)));
			metalang.setMetadata_element_description(metaElement.not_null(request.getParameter("metadata_element_description"+k)));
			metalang.setMetadata_element_unit(metaElement.not_null(request.getParameter("metadata_element_unit"+k)));
            // and to the main element
			metaElement.setMetadata_element_sector(metaElement.not_null(request.getParameter("metadata_element_sector"+k)));
			metaElement.setMetadata_element_source(metaElement.not_null(request.getParameter("metadata_element_source"+k)));
			metaElement.setMetadata_element_description(metaElement.not_null(request.getParameter("metadata_element_description"+k)));
			metaElement.setMetadata_element_unit(metaElement.not_null(request.getParameter("metadata_element_unit"+k)));

			// language independent fields
			metaElement.setMetadata_element_measurement(metaElement.not_null(request.getParameter("metadata_element_measurement"+k)));
			metaElement.setMetadata_element_average_size(request.getParameter("metadata_element_average_size"+k));
			metaElement.setMetadata_element_equipment(request.getParameter("metadata_element_equipment"+k));
			metaElement.setMetadata_element_infrastr(request.getParameter("metadata_element_infrastr"+k));
			metaElement.setMetadata_element_damage_r(request.getParameter("metadata_element_damage_r"+k));
			metaElement.setMetadata_element_formula(metaElement.not_null(request.getParameter("metadata_element_formula"+k)));
			metaElement.setMetadata_element_workers(request.getParameter("metadata_element_workers"+k));
			metaElement.updateWebObject(con);
			metalang.updateWebObject(con);
			dbutils.updateMetadataExtensions(con,metaElement);

	}

%>

<tr class="bss" style="height:8px; font-size:9px; font-weight:100;">
    <td><input class='bss' name='delete<%=k%>' type="checkbox" value='Y'></td>
    <td>
    	<INPUT type='hidden' 									name='metadata_element_key<%=k%>' VALUE="<%=metaElement.metadata_element_key%>">
		<INPUT type='hidden' 									name='metadata_country<%=k%>' VALUE="<%=metaElement.metadata_country%>">
        <INPUT type='hidden' 									name='metadata_lang<%=k%>' VALUE="<%=countrybean.getLanguage().toLowerCase()%>">        
		<INPUT class="bss" type='TEXT' size='10' maxlength='15' name='metadata_element_code<%=k%>' VALUE="<%=metaElement.metadata_element_code%>">
        <INPUT type='hidden' size='10' maxlength='15' name='metadata_element_fao<%=k%>' VALUE="<%=metaElement.metadata_element_fao%>">
        </td>

    <td>  <INPUT class="bss" type='TEXT' size='30' maxlength='250' name='metadata_element_sector<%=k%>' VALUE="<%=metaElement.metadata_element_sector%>"></td>
    <td>  <INPUT class="bss" type='TEXT' size='30' maxlength='250' name='metadata_element_source<%=k%>' VALUE="<%=metaElement.metadata_element_source%>"></td>
    <td>  <INPUT class="bss" type='TEXT' size='20' maxlength='250' name='metadata_element_description<%=k%>' VALUE="<%=metaElement.metadata_element_description%>"></td>
    <td>  <INPUT class="bss" type='TEXT' size='15' maxlength='30' name='metadata_element_unit<%=k%>'  VALUE="<%=metaElement.metadata_element_unit%>"></td>
    <td>  <INPUT class="bss" type='TEXT' size='5' maxlength='10'  name='metadata_element_measurement<%=k%>' VALUE="<%=metaElement.metadata_element_measurement%>"></td>
    <td>  <INPUT class="bss" type='TEXT' size='10' maxlength='22' name='metadata_element_average_size<%=k%>' VALUE="<%=metaElement.metadata_element_average_size%>"></td>
    <td nowrap>  <INPUT class="bss" type='TEXT' size='5' maxlength='22' name='metadata_element_equipment<%=k%>' VALUE="<%=metaElement.metadata_element_equipment%>">%</td>
    <td nowrap>  <INPUT class="bss" type='TEXT' size='5' maxlength='22' name='metadata_element_infrastr<%=k%>' VALUE="<%=metaElement.metadata_element_infrastr%>">%</td>
    <td nowrap>  <INPUT class="bss" type='TEXT' size='5' maxlength='22' name='metadata_element_damage_r<%=k%>' VALUE="<%=metaElement.metadata_element_damage_r%>">%</td>
    <%-- 
    <INPUT class="bss" type='submit' size='12' maxlength='22' name='edit_price' value='...' name='maintenance_<%=k%>'>
		out.println("<td align='center'><input name='editAnnualMetaValue' id='editAnnualMetaValue"+j+"' type='image'");
		out.println(" src='/DesInventar/images/edit_row.gif' alt='Submit' border='0'");
		out.println(" onClick=\"editField("+"'editMetadataNationalValue', "+annualValue.metadata_year+", "+annualValue.metadata_value+")\"></td>");
     --%>
    <input class="bss" name='editMetaElementCosts' id='editMetaElementCosts' type='image'  src='/DesInventar/images/edit_row.gif' 
    	alt='Submit' border='0' 
    	onClick="editField('maintaintMetadataElementCosts', <%=metaElement.metadata_element_key%>, '<%=metaElement.metadata_country%>')" >
    </td>
    <td>  <INPUT class="bss" type='TEXT' size='5' maxlength='11' name='metadata_element_workers<%=k%>' VALUE="<%=metaElement.metadata_element_workers%>"></td>
    <td>  <INPUT class="bss" type='TEXT' size='50'                name='metadata_element_formula<%=k%>' VALUE="<%=metaElement.metadata_element_formula%>"></td>
</tr>

<%  
}
rset.close();
String sWhere="m.metadata_country='@@@' and indicator_key="+indicator.indicator_key+
		 " and m.metadata_element_key not in (select metadata_element_key from metadata_element_indicator where metadata_country='" +countrybean.countrycode+"')";
String sOrder=countrybean.dbHelper[countrybean.dbType].sGetSQLFunction("LEN")+"(metadata_element_code),m.metadata_element_sector";
if (indicator.indicator_key>2)
   sOrder="m.metadata_element_key";
String sField=countrybean.dbHelper[countrybean.dbType].sqlNvl("l.metadata_element_sector","m.metadata_element_sector");
%>
<tr><td></td><td colspan="13" valign="top">
<br/><br/>
    <input type="submit" name="newMeta" value='<%=countrybean.getTranslation("New Element")%>'>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <input type="submit" name="saveMeta" value='<%=countrybean.getTranslation("Save Edits")%>'>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <input type="submit" name="deleteMeta" value='<%=countrybean.getTranslation("Delete Selected")%>'>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="submit" name="retrieveMeta" value="<%=countrybean.getTranslation("Retrieve metadata from desinventar.net")%>" />
<br/><br/>
	<SELECT name="new_element_key" size="15" multiple style="WIDTH: 450px;">
 	    <inv:select tablename='((metadata_element m join metadata_element_indicator i on m.metadata_element_key=i.metadata_element_key) left join metadata_element_lang l on m.metadata_element_key=l.metadata_element_key)' 
        connection='<%= con %>'
    	fieldname='<%=sField%>'  
		codename='m.metadata_element_key' 
        ordername='<%=sOrder%>'
    	language='<%=countrybean.getLanguage().toLowerCase()%>' 
        languagefield="metadata_lang"
    	whereclause='<%=sWhere%>'
    />
    </SELECT>
     <input type="submit" name="addMeta" value='<%=countrybean.getTranslation("Add")%>' onClick="return bSomethingSelected()">
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <br/><br>
    <font class=bss><%=countrybean.getTranslation("Use Ctrl-Click and/or Shift-Click to deselect or for multiple selections.")%>
    <br/><br>
</td></tr>
<tr><td align="center" colspan="14">
    <input type="button" name="endMeta" value='<%=countrybean.getTranslation("Done")%>' onClick="document.location='metadataManager.jsp'">
 </td></tr>

</table>
<br><br>
</body>
</html>
