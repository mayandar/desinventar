<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<%@ page info="DesConsultar Connection Diagnostics page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
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
<%@ taglib uri="inventag.tld" prefix="inv" %>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>

<script type="text/javascript">

function bSomethingSelected()
{
if (document.desinventar.new_element_key.selectedIndex<=0)
	{
	alert ("<%=countrybean.getTranslation("Please select an element ")%> <%=countrybean.getTranslation("fromthelist")%>...");
	return false;
	}
return true;
}

function cancelAction()
{
	window.close();
	return true;
}
function CloseMySelf(metaKeys) {
    try {
        window.opener.HandlePopupResult(metaKeys);
    }
    catch (err) {}
    window.close();
    return true;
}

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
	String metaKeyArrayString = "";
	for (int j=0; j<metaKeys.length; j++)
		{
			metaElement.metadata_element_key=metaElement.extendedParseInt(metaKeys[j]);
			metaElement.metadata_country="@@@";
			metaElement.getWebObject(con);
			dbutils.generateMetadataEntry(indicator.indicator_key, metaElement.metadata_element_key, countrybean, con);	            			
		
			metaKeyArrayString = metaKeyArrayString+
					",{selector:'"+metaElement.metadata_element_sector+"'"+
					",key:"+metaElement.metadata_element_key+
					",measurement:'"+(metaElement.metadata_element_measurement == null ? "" : metaElement.metadata_element_measurement)+"'"+
					",unit:'"+(metaElement.metadata_element_unit == null ? "" : metaElement.metadata_element_unit)+"'"+
					"}";

		}
	metaKeyArrayString = "["+metaKeyArrayString.substring(1)+"]";
	%>
	<script>
	CloseMySelf(<%=metaKeyArrayString %>);
	</script>
	<%
	}
// boolean bSave=(request.getParameter("newMeta")!=null) || (request.getParameter("edit_rice")!=null) || (request.getParameter("addMeta")!=null) || (request.getParameter("saveMeta")!=null) || (request.getParameter("deleteMeta")!=null);
%>

<FORM name="desinventar" method="post" action="metadataGroupModal.jsp">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>">
<input type="hidden" name="indicator_key" value="<%=indicator.indicator_key%>">
<br/><br/>
<table width="50%" border="0" cellpadding="0" cellspacing="0" class="bss">
<tr><td align="left" colspan="7">
<span class=subTitle><%=countrybean.getTranslation("DesInventar Sendai Metadata Manager")%></span><br>
<br>
</td></tr>
<tr><td align="left" colspan="7">
<%=countrybean.getTranslation("Select the Metadata Group you want to create/edit:")%>
<br/><br/>
</td></tr>
<%
stmt=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
String sWhere="m.metadata_country='@@@' and indicator_key="+indicator.indicator_key+
		 " and m.metadata_element_key not in (select metadata_element_key from metadata_element_indicator where metadata_country='" +countrybean.countrycode+"')";
String sOrder=countrybean.dbHelper[countrybean.dbType].sGetSQLFunction("LEN")+"(metadata_element_code),m.metadata_element_sector";
if (indicator.indicator_key>2)
   sOrder="m.metadata_element_key";
String sField=countrybean.dbHelper[countrybean.dbType].sqlNvl("l.metadata_element_sector","m.metadata_element_sector");
%>
<tr>
<td colspan="7" valign="top">
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
    <br/><br>
    <font class=bss><%=countrybean.getTranslation("Use Ctrl-Click and/or Shift-Click to deselect or for multiple selections.")%>
    <br/><br>
</td>
</tr>
<tr border="0">
<td align="center" colspan="2">
	<input type="submit" name="addMeta" value='<%=countrybean.getTranslation("Add")%>' onClick="return bSomethingSelected()">
</td>
<td align="left" colspan="2">
	<input type="button" name="cancel" value='<%=countrybean.getTranslation("Cancel")%>' onclick="return cancelAction()">
</td>
<td colspan="5">&nbsp;</td>
</tr>

</table>
<br><br>
</body>
</html>
