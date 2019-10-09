<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<%@ page info="DesConsultar simple results page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ include file="/util/opendatabase.jspf" %> 
<head>
<title><%=countrybean.getTranslation("Expert")%></title>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
</head>
<script language="JavaScript">
var sExpertMode='<%=countrybean.not_null(request.getParameter("formula"))%>';
function doDiagOK()
	{
<%
boolean bIEBrowser = (request.getHeader("User-Agent").indexOf("MSIE")>0);
boolean bIEdge = (request.getHeader("User-Agent").indexOf("Edge")>0);
if (!bIEBrowser) { %>
	    opener.expertDone(document.desinventar.sExpertWhere.value+' ');
	<%}%>	
		window.returnValue = document.desinventar.sExpertWhere.value+' ';
		window.close();
	}
	
function cancelAction()
	{
    <% if (!bIEBrowser) { %>
		document.desinventar.sExpertWhere.value=opener.getExpertString();
	<%}
	else{%>	
	oArgs = window.dialogArguments.otherArgs;
	if (sExpertMode=="f")
		document.desinventar.sExpertWhere.value=oArgs.sExpertVariable;
	 else
		document.desinventar.sExpertWhere.value=oArgs.sExpertWhere;
	<%}%>	
		window.returnValue = document.desinventar.sExpertWhere.value;
	window.close();
    }
	
function validateSql()
{
frames.sqlserver.desinventar.sExpertWhere.value=document.desinventar.sExpertWhere.value;
frames.sqlserver.main_submit();
}
</script>

 <table width="100%" border="1" class="pageBackground" rules="none" height="100%">
<form name="desinventar" method=post action="expert.jsp" onSubmit="return false;">  <!-- never submit a modal dialog... -->
<tr><td valign="top">
<table width="100%" border="0">
<tr><td align="left">
<font class='ltbluelg'><%=countrybean.getTranslation("Region")%></font><font class='regionlink'>
<b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font>
 - [<jsp:getProperty name ="countrybean" property="countrycode"/>]
</td><td nowrap  align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<span class="subTitle"><%=countrybean.getTranslation("Expert")%></span>
</td>
</tr>
</table>

<script language="javascript">
<!-- 
function addVar()
{
var nIns=0;
var sOpt="";
var sText="";
with (document.desinventar)
  {
  for (nSel=0; nSel<availableVars.length; nSel++)
   if (availableVars.options[nSel].selected)
  	{
	sOpt=availableVars.options[nSel].value;
	availableVars.options[nSel].selected=false;
	if (sExpertMode=="f")
		{
		if (sExpertWhere.value.length>0)
			sExpertWhere.value+=" + ";
		sExpertWhere.value+=sOpt;
		}
	else
		{		

		if (sExpertWhere.value.length>0)
		   if (logic[1].checked)
				sExpertWhere.value+=" OR ";
			else	
				sExpertWhere.value+=" AND ";
		sExpertWhere.value+="("+sOpt;
		sText=availableVars.options[nSel].text;
			if (sText.substring(sText.length-1)=='#')
				sExpertWhere.value+=operator.options[operator.selectedIndex].value+"0) "
			else	
				sExpertWhere.value+=operator.options[operator.selectedIndex].value+"'abc') "
		}
  	}
  }
}

// -->	
</script>
<table width="580" border="0" cellpadding="0" cellspacing="0">
<tr><td colspan="3" align="center"><font class='subtitle'><%=countrybean.getTranslation("SelectVariables")%></FONT><br>
</td></tr>
<tr><td align="middle">
  <table border=1 cellpadding="0" cellspacing="0">
    <tr>
      <td class="DI_TableHeader"
 align="center" colspan=3><font color="White"><%=countrybean.getTranslation("Available")%></font></td>
    </tr>
	<tr>
		<td>
		<select ondblclick="addVar()" name="availableVars" multiple size=10 style="WIDTH: 450px;">

<option  ondblclick="addVar()" value='<%=countrybean.getTranslation("VSerial")%>'><%=countrybean.getTranslation("Serial")%> [abc]</option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VEvent")%>'><%=countrybean.getTranslation("Event")%>[abc]</option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VCause")%>'><%=countrybean.getTranslation("Cause")%>[abc]</option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VSource")%>'><%=countrybean.getTranslation("Source")%>[abc]</option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VMagnitude")%>'><%=countrybean.getTranslation("Magnitude")%>[abc]</option>

<!-- <option ondblclick="addVar()" value='<%=countrybean.getTranslation("VDataCards")%>'><%=countrybean.getTranslation("DataCards")%> #</option> -->

<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VDeaths")%>'><%=countrybean.getTranslation("Deaths")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VInjured")%>'><%=countrybean.getTranslation("Injured")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VMissing")%>'><%=countrybean.getTranslation("Missing")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VDestroyedHouses")%>'><%=countrybean.getTranslation("DestroyedHouses")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VAffectedHouses")%>'><%=countrybean.getTranslation("AffectedHouses")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VVictims")%>'><%=countrybean.getTranslation("Victims")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VAffected")%>'><%=countrybean.getTranslation("Affected")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VRelocated")%>'><%=countrybean.getTranslation("Relocated")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VEvacuated")%>'><%=countrybean.getTranslation("Evacuated")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VLossesUSD")%>'><%=countrybean.getTranslation("LossesUSD")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VLossesLocal")%>'><%=countrybean.getTranslation("LossesLocal")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VEducationcenters")%>'><%=countrybean.getTranslation("Educationcenters")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VHospitals")%>'><%=countrybean.getTranslation("Hospitals")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VDamagesincrops")%>'><%=countrybean.getTranslation("Damagesincrops")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VCatle")%>'><%=countrybean.getTranslation("Catle")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VDamagesinroads")%>'><%=countrybean.getTranslation("Damagesinroads")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VWithDeaths")%>'><%=countrybean.getTranslation("WithDeaths")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VWithInjured")%>'><%=countrybean.getTranslation("WithInjured")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VWithMissing")%>'><%=countrybean.getTranslation("WithMissing")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VWithHousesDestroyed")%>'><%=countrybean.getTranslation("WithHousesDestroyed")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VWithHousesAffected")%>'><%=countrybean.getTranslation("WithHousesAffected")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VWithVictims")%>'><%=countrybean.getTranslation("WithVictims")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VWithAffected")%>'><%=countrybean.getTranslation("WithAffected")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VWithRelocated")%>'><%=countrybean.getTranslation("WithRelocated")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VWithEvacuated")%>'><%=countrybean.getTranslation("WithEvacuated")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VEducation")%>'><%=countrybean.getTranslation("Education")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VHealth")%>'><%=countrybean.getTranslation("Health")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VAgriculture")%>'><%=countrybean.getTranslation("Agriculture")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VWater")%>'><%=countrybean.getTranslation("Water")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VSewerage")%>'><%=countrybean.getTranslation("Sewerage")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VIndustrial")%>'><%=countrybean.getTranslation("Industrial")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VCommunications")%>'><%=countrybean.getTranslation("Communications")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VTransportation")%>'><%=countrybean.getTranslation("Transportation")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VPower")%>'><%=countrybean.getTranslation("Power")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VRelief")%>'><%=countrybean.getTranslation("Relief")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VOthersectors")%>'><%=countrybean.getTranslation("Othersectors")%> # </option>

<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VYear")%>'><%=countrybean.getTranslation("Year")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VMonth")%>'><%=countrybean.getTranslation("Month")%> # </option>
<option onDblClick="addVar()" value='<%=countrybean.getTranslation("VDay")%>'><%=countrybean.getTranslation("Day")%> # </option>

<%
extension woExtension = new extension();
woExtension.loadExtension(con,countrybean);

// allocates a dictionary object to read each record
Dictionary dct = new Dictionary();
for (int k = 0; k < woExtension.vFields.size(); k++)
    {
    dct = (Dictionary) woExtension.vFields.get(k);
    boolean bIsNumeric=false;
    if (dct.nDataType==Types.DECIMAL
       || dct.nDataType==Types.DOUBLE
       || dct.nDataType==Types.FLOAT
       || dct.nDataType==Types.NUMERIC
       || dct.nDataType==Types.REAL
       || dct.nDataType==Types.SMALLINT
       || dct.nDataType==Types.INTEGER
	   )
		bIsNumeric=true;
	 String sDescription=dct.label_campo;
	 String sField=dct.nombre_campo;
	 if (sDescription==null)
			sDescription=sField;
	 if (sField!=null)
	     if (bIsNumeric)
	 		{
		  %><option onDblClick="addVar()" value="<%=sField%>"><%=sDescription%> #</option>
		  <%}
		else
	 		{
		  %><option onDblClick="addVar()" value="<%=sField%>"><%=sDescription%> [abc]</option>
		  <%}
		        
	}

    for (int aj=0; aj<3; aj++)
    	if (countrybean.laAttrs[aj]!=null && countrybean.laAttrs[aj].table_level==aj && countrybean.laAttrs[aj].table_name.length()>0 && countrybean.laAttrs[aj].table_code.length()>0)
		{
		attributes aAttribs = new attributes();
		aAttribs.loadAttributes(con,countrybean,aj);
		
		java.util.ArrayList varFields=aAttribs.nFields;
		// allocates a dictionary object to read each record
		for (int k = 0; k < varFields.size(); k++)
		    {
			String sField=(String) (varFields.get(k));
		  %><option onDblClick="addVar()" value="DA_<%=aj%>.<%=sField%>"><%=sField%> #</option>
		  <%}	
		
		}

%>		

		</select>
	</td>
  </tr>
</table>  	
</td>
</tr>
<tr>
  <td align="center"><input type="button" name="addvariable"  value=" <%=countrybean.getTranslation("Add")%>" onClick="addVar()">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
     					 <input type="radio" name="logic" value="AND"<%=countrybean.strChecked(countrybean.logic,"AND")%>>  <%=countrybean.getTranslation("AND")%>
  					     <input type="radio" name="logic" value="OR"<%=countrybean.strChecked(countrybean.logic,"OR")%>>  <%=countrybean.getTranslation("OR")%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						 <select name="operator">
						 <option value="=">=</option>
						 <option value=">" selected>&gt;</option>
						 <option value="<">&lt;</option>
						 <option value="<>">&lt;&gt;</option>
						 <option value=">=">&gt;=</option>
						 <option value="<=">&lt;=</option>
						 </select>
						 
  </td>
</tr>

<tr>
<td colspan="3" align="center" >
 <br><font class='instruction'><%=countrybean.getTranslation("selectVariablesInstructions")%></font><br>
</td>
</tr>
<tr>
<td colspan="3" align="center" >
   <table  cellspacing="0" cellpadding="0" border="0">
    <tr>
     <td class=bss><%=countrybean.getTranslation("ExpertSelection")%></td>
     <td class=bss><textarea cols="75" rows='5' name="sExpertWhere"/></textarea>     </td> 
	</tr>
   </table>
 </td>
</tr>
<script language="JavaScript">
if (window.dialogArguments != null)
	{
	oArgs = window.dialogArguments.otherArgs;
	if (sExpertMode=="f")
		document.desinventar.sExpertWhere.value=oArgs.sExpertVariable;
	 else
		document.desinventar.sExpertWhere.value=oArgs.sExpertWhere;
	}
else
    document.desinventar.sExpertWhere.value=opener.getExpertString();
</script>

</table>


<table cellpadding="0" cellspacing="0" border="0" ALIGN="CENTER" width="100%">
<tr><td align="center" colspan=3>
     <input type="button" name="validate" value="<%=countrybean.getTranslation("Validate")%>" onClick="validateSql()">
     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	 <input type='button' name='okbut' onClick="javascript:doDiagOK()" value="<%=countrybean.getTranslation("Save")%>">
	 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	 <input type='button' name='cancbut' onClick="javascript:cancelAction()" value="<%=countrybean.getTranslation("Cancel")%>">
	 <input type='hidden' name='valid'>
</td></tr>
</table>
</form>
</td></tr>
<tr><td>
<iframe id="sqlserver" name="sqlserver" height="0" width="0" frameborder="0" src="expert_validate.jsp?formula=<%=countrybean.not_null(request.getParameter("formula"))%>"></iframe>
</td></tr>
</table>
</body>
<%
dbCon.close();
%>
</html>
