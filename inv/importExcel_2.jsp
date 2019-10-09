<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<%@ page info="Reindex page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>

<%@ page import="org.apache.poi.hssf.usermodel.HSSFCell" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFRow" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFSheet" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFWorkbook" %>
<%@ page import="org.apache.poi.poifs.filesystem.POIFSFileSystem" %>


<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<%!
String aOptions[];
parser  Parser=new parser();

String sSelectExcel(String sOptions,String svar)
{
String ret="<select name='"+svar+"'>"+sOptions+"</select>";
String sJavascript="";
for (int j=0; j<aOptions.length; j++)
	{
	if (svar.trim().equalsIgnoreCase(aOptions[j]))
	   sJavascript="document.desinventar."+svar+".selectedIndex="+(j+1);
	else{
		String svar2=(String)(Parser.hmVarTrans.get("fichas."+svar));
		if (svar2!=null)
	 	  if (svar2.equalsIgnoreCase(aOptions[j]))
	   		sJavascript="document.desinventar."+svar+".selectedIndex="+(j+1);
		}  
	}
if (sJavascript.length()>0)
 ret+="\n<script>"+ sJavascript+";</script>";

return ret;
}

%>
<head>
<title>DesInventar on-line - <%=countrybean.getTranslation("ImportEXCEL")%></title>
 </head>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%if (user.iusertype<20) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}%>
<%@ include file="/util/opendatabase.jspf" %>
<%@ taglib uri="/inventag.tld" prefix="inv" %>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>">
<script language="JavaScript">
<!-- 
function setReturnFolder(newFolder)
{
 if (newFolder)
  document.desinventar.filename.value=newFolder;
}

function browse()
{
sPath=document.desinventar.filename.value;
showDialog("/DesInventar/inv/browsefilefrm.jsp?currentPath="+sPath, 'setReturnFolder');
}

function validateDB()
{
if (document.desinventar.filename.value.length>0)
	{
	if (document.desinventar.filename.value.toLowerCase().indexOf(".xls")>0)
	   return true;
	}
alert("<%=countrybean.getTranslation("NoExcelSelected")%>");
return false;	
}
// -->
</script>

<form method="post" action="importExcel_2a.jsp" name="desinventar">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<table width="580" border="0">
<tr><td align="center">
<font color="Blue"><%=countrybean.getTranslation("Region")%></font>
<b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font>
 - [<jsp:getProperty name ="countrybean" property="countrycode"/>]
</td></tr>
</table>
<table width="100%" border="1">
<tr>
<td colspan=2  valign="top" nowrap><div class="subtitle"><%=countrybean.getTranslation("SelectMappingForVariables")%></div></td>
<%
String database,events,causes,levels,geography,data,definition,extension,firstrow,startrow,sheetnumber;
database=countrybean.not_null(request.getParameter("filename"));
events=countrybean.not_null(request.getParameter("events"));
causes=countrybean.not_null(request.getParameter("causes"));
geography=countrybean.not_null(request.getParameter("geography"));
data=countrybean.not_null(request.getParameter("data"));
extension=countrybean.not_null(request.getParameter("extension"));
firstrow=countrybean.not_null(request.getParameter("firstrow"));
startrow=countrybean.not_null(request.getParameter("startrow"));
sheetnumber=countrybean.not_null(request.getParameter("sheetnumber"));

Parser.buildTranslations(countrybean, true);

InputStream inp=null;
String sOptions="<option value='300'></option>";  /// TODO:  300 is hardcoded in ExcelLoader.java
try
	{
	inp = new FileInputStream(database);
	
	HSSFWorkbook wb = new HSSFWorkbook(new POIFSFileSystem(inp));
	HSSFSheet sheet=wb.getSheetAt(countrybean.extendedParseInt(sheetnumber));
	HSSFRow row=sheet.getRow(countrybean.extendedParseInt(firstrow));
	int nLastCol=row.getLastCellNum();
	aOptions=new String[nLastCol];
	for (short kCol=0; kCol<nLastCol; kCol++)
			{
				aOptions[kCol]="";
				try{
					HSSFCell cell = row.getCell(kCol);
					if (cell!=null)
						{
						if (cell.getCellType()==HSSFCell.CELL_TYPE_STRING)
							{
							sOptions+="<option value=\""+kCol+"\">"+cell.getStringCellValue()+"</option>";
							aOptions[kCol]=cell.getStringCellValue();
							}
						}
				}
				catch (Exception e){
				}
			}
	}
catch (Exception ex2)
	{
	out.println("[DI9] ERROR: exception loading(2)..="+ex2.toString());
	}
try {inp.close();} catch (Exception e){};
%>
<INPUT type='hidden' name='filename'  VALUE='<%=database %>'> 
<INPUT type='hidden' name='events'  VALUE='<%=events %>'>	 
<INPUT type='hidden' name='causes'  VALUE='<%=causes %>'>		 
<INPUT type='hidden' name='geography'  VALUE='<%=geography %>'>
<INPUT type='hidden' name='data'  VALUE='<%=data %>' >
<INPUT type='hidden' name='extension'  VALUE='<%=extension %>'>
<INPUT type='hidden' name='firstrow'  VALUE='<%=firstrow %>'>
<INPUT type='hidden' name='startrow'  VALUE='<%=startrow %>'>
<INPUT type='hidden' name='sheetnumber'  VALUE='<%=sheetnumber %>'>

</tr>
<tr><td height="20" width='35%'></td><td></td></tr>

<tr><td><%=countrybean.getTranslation("Serial")%>: </td><td><%=sSelectExcel(sOptions,"serial")%> <input type='checkbox' name='serial_auto' checked><%=countrybean.getTranslation("Automatic")%></td></tr>
<tr><td><%=countrybean.getTranslation("Event")%>: </td><td><%=sSelectExcel(sOptions,"evento")%> 
      <SELECT name="evento_fixed" class=bs><option value='' selected></option>
<%	 String sDisplayField="nombre";
	    if (countrybean.getDataLanguage().equals("EN"))
		   sDisplayField="nombre_en";  %>
       <inv:select tablename='eventos' selected='' connection='<%= con %>' fieldname="<%=sDisplayField%>" codename='nombre' ordername='serial'/>
	   </SELECT>  </td></tr>
<tr><td><%=countrybean.getTranslation("Code")%> - <%=countrybean.asLevels[0] %>: </td><td><%=sSelectExcel(sOptions,"level0")%><font color='red'>*</font></td></tr>
<tr><td><%=countrybean.getTranslation("Name")%> - <%=countrybean.asLevels[0] %>: </td><td><%=sSelectExcel(sOptions,"name0")%></td></tr>
<tr><td><%=countrybean.getTranslation("Code")%> - <%=countrybean.asLevels[1] %>: </td><td><%=sSelectExcel(sOptions,"level1")%></td></tr>
<tr><td><%=countrybean.getTranslation("Name")%> - <%=countrybean.asLevels[1] %>: </td><td><%=sSelectExcel(sOptions,"name1")%></td></tr>
<tr><td><%=countrybean.getTranslation("Code")%> - <%=countrybean.asLevels[2] %>: </td><td><%=sSelectExcel(sOptions,"level2")%></td></tr>
<tr><td><%=countrybean.getTranslation("Name")%> - <%=countrybean.asLevels[2] %>: </td><td><%=sSelectExcel(sOptions,"name2")%></td></tr>
<tr><td><%=countrybean.getTranslation("Year")%>: </td><td><%=sSelectExcel(sOptions,"fechano")%><font color='red'>*!</font></td></tr>
<tr><td><%=countrybean.getTranslation("Month")%>: </td><td><%=sSelectExcel(sOptions,"fechames")%></td></tr>
<tr><td><%=countrybean.getTranslation("Day")%>: </td><td><%=sSelectExcel(sOptions,"fechadia")%></td></tr>
<tr><td><%=countrybean.getTranslation("Date")%>: </td><td><%=sSelectExcel(sOptions,"date")%> <input type='text' name='date_fixed' maxlength="10" size="12"><font color='red'><%=countrybean.getTranslation("(YYYY-MM-DD)")%>*</font></td></tr>
<tr><td><%=countrybean.getTranslation("Duration")%>: </td><td><%=sSelectExcel(sOptions,"duracion")%><input type='text' name='duracion_fixed' maxlength="5" size="7"></td></tr>
<tr><td><%=countrybean.getTranslation("Location")%>: </td><td><%=sSelectExcel(sOptions,"lugar")%></td></tr>
<tr><td><%=countrybean.getTranslation("Latitude")%>: </td><td><%=sSelectExcel(sOptions,"latitude")%></td></tr>
<tr><td><%=countrybean.getTranslation("Longitude")%>: </td><td><%=sSelectExcel(sOptions,"longitude")%></td></tr>
<tr><td><%=countrybean.getTranslation("Cause")%>: </td><td><%=sSelectExcel(sOptions,"causa")%> <SELECT name="causa_fixed" class='bs'><option value=""></option>
	    <inv:select tablename='causas' selected='<%=countrybean.asCausas%>' connection='<%= con %>' fieldname="causa" codename='causa' ordername='causa'/></SELECT></td></tr>
<tr><td><%=countrybean.getTranslation("DescriptionCause")%>: </td><td><%=sSelectExcel(sOptions,"descausa")%> <input type='text' name='descausa_fixed' maxlength="60" size="40"></td></tr>
<tr><td><%=countrybean.getTranslation("Source")%>: </td><td><%=sSelectExcel(sOptions,"fuentes")%> <input type='text' name='fuentes_fixed' maxlength="40" size="40"></td></tr>
<tr><td><%=countrybean.getTranslation("Magnitude")%>: </td><td><%=sSelectExcel(sOptions,"magnitud2")%> <input type='text' name='magnitud2_fixed' maxlength="20" size="20"></td></tr>
<tr><td><%=countrybean.getTranslation("GLIDEnumber")%>: </td><td><%=sSelectExcel(sOptions,"glide")%> <input type='text' name='glide_fixed' maxlength="18" size="18"></td></tr>
<tr><td><%=countrybean.getTranslation("Othersectors")%>: </td><td><%=sSelectExcel(sOptions,"otros")%></td></tr>
<tr><td><%=countrybean.getTranslation("Deaths")%>: </td><td><%=sSelectExcel(sOptions,"muertos")%></td></tr>
<tr><td><%=countrybean.getTranslation("Injured")%>: </td><td><%=sSelectExcel(sOptions,"heridos")%></td></tr>
<tr><td><%=countrybean.getTranslation("Missing")%>: </td><td><%=sSelectExcel(sOptions,"desaparece")%></td></tr>
<tr><td><%=countrybean.getTranslation("DestroyedHouses")%>: </td><td><%=sSelectExcel(sOptions,"vivdest")%></td></tr>
<tr><td><%=countrybean.getTranslation("AffectedHouses")%>: </td><td><%=sSelectExcel(sOptions,"vivafec")%></td></tr>
<tr><td><%=countrybean.getTranslation("Victims")%>: </td><td><%=sSelectExcel(sOptions,"damnificados")%></td></tr>
<tr><td><%=countrybean.getTranslation("Affected")%>: </td><td><%=sSelectExcel(sOptions,"afectados")%></td></tr>
<tr><td><%=countrybean.getTranslation("Relocated")%>: </td><td><%=sSelectExcel(sOptions,"reubicados")%></td></tr>
<tr><td><%=countrybean.getTranslation("Evacuated")%>: </td><td><%=sSelectExcel(sOptions,"evacuados")%></td></tr>
<tr><td><%=countrybean.getTranslation("LossesUSD")%>: </td><td><%=sSelectExcel(sOptions,"valoruS")%></td></tr>
<tr><td><%=countrybean.getTranslation("LossesLocal")%>: </td><td><%=sSelectExcel(sOptions,"valorloc")%></td></tr>
<tr><td><%=countrybean.getTranslation("Educationcenters")%>: </td><td><%=sSelectExcel(sOptions,"nescuelas")%></td></tr>
<tr><td><%=countrybean.getTranslation("Hospitals")%>: </td><td><%=sSelectExcel(sOptions,"nhospitales")%></td></tr>
<tr><td><%=countrybean.getTranslation("Damagesincrops")%>: </td><td><%=sSelectExcel(sOptions,"nhectareas")%></td></tr>
<tr><td><%=countrybean.getTranslation("Catle")%>: </td><td><%=sSelectExcel(sOptions,"cabezas")%></td></tr>
<tr><td><%=countrybean.getTranslation("Damagesinroads")%>: </td><td><%=sSelectExcel(sOptions,"kmmvias")%></td></tr>
<tr><td><%=countrybean.getTranslation("WithDeaths")%>: </td><td><%=sSelectExcel(sOptions,"hay_muertos")%></td></tr>
<tr><td><%=countrybean.getTranslation("WithInjured")%>: </td><td><%=sSelectExcel(sOptions,"hay_heridos")%></td></tr>
<tr><td><%=countrybean.getTranslation("WithMissing")%>: </td><td><%=sSelectExcel(sOptions,"hay_deasparece")%></td></tr>
<tr><td><%=countrybean.getTranslation("WithHousesDestroyed")%>: </td><td><%=sSelectExcel(sOptions,"hay_vivdest")%></td></tr>
<tr><td><%=countrybean.getTranslation("WithHousesAffected")%>: </td><td><%=sSelectExcel(sOptions,"hay_vivafec")%></td></tr>
<tr><td><%=countrybean.getTranslation("WithVictims")%>: </td><td><%=sSelectExcel(sOptions,"hay_damnificados")%></td></tr>
<tr><td><%=countrybean.getTranslation("WithAffected")%>: </td><td><%=sSelectExcel(sOptions,"hay_afectados")%></td></tr>
<tr><td><%=countrybean.getTranslation("WithRelocated")%>: </td><td><%=sSelectExcel(sOptions,"hay_reubicados")%></td></tr>
<tr><td><%=countrybean.getTranslation("WithEvacuated")%>: </td><td><%=sSelectExcel(sOptions,"hay_evacuados")%></td></tr>
<tr><td><%=countrybean.getTranslation("Education")%>: </td><td><%=sSelectExcel(sOptions,"educacion")%></td></tr>
<tr><td><%=countrybean.getTranslation("Health")%>: </td><td><%=sSelectExcel(sOptions,"salud")%></td></tr>
<tr><td><%=countrybean.getTranslation("Agriculture")%>: </td><td><%=sSelectExcel(sOptions,"agropecuario")%></td></tr>
<tr><td><%=countrybean.getTranslation("Water")%>: </td><td><%=sSelectExcel(sOptions,"acueducto")%></td></tr>
<tr><td><%=countrybean.getTranslation("Sewerage")%>: </td><td><%=sSelectExcel(sOptions,"alcantarillado")%></td></tr>
<tr><td><%=countrybean.getTranslation("Industrial")%>: </td><td><%=sSelectExcel(sOptions,"industrias")%></td></tr>
<tr><td><%=countrybean.getTranslation("Communications")%>: </td><td><%=sSelectExcel(sOptions,"comunicaciones")%></td></tr>
<tr><td><%=countrybean.getTranslation("Transportation")%>: </td><td><%=sSelectExcel(sOptions,"transporte")%></td></tr>
<tr><td><%=countrybean.getTranslation("Power")%>: </td><td><%=sSelectExcel(sOptions,"energia")%></td></tr>
<tr><td><%=countrybean.getTranslation("Relief")%>: </td><td><%=sSelectExcel(sOptions,"socorro")%></td></tr>
<tr><td><%=countrybean.getTranslation("WithOthersectors")%>: </td><td><%=sSelectExcel(sOptions,"hay_otros")%></td></tr>
<tr><td><%=countrybean.getTranslation("Comments")%>: </td><td><%=sSelectExcel(sOptions,"di_comments")%></td></tr>
<tr><td><%=countrybean.getTranslation("By")%>: </td><td><%=sSelectExcel(sOptions,"fechapor")%>  <input type='text' name='fechapor_fixed' maxlength="12" size="13"></td></tr>
<tr><td><%=countrybean.getTranslation("Date")%>: </td><td><%=sSelectExcel(sOptions,"fechafec")%>  <input type='text' name='fechafec_fixed' maxlength="10" size="11"></td></tr>

		
<%

		extension extended=new extension();
		extended.loadExtension(con, countrybean);
		// allocates a dictionary object to read each field, puts all extended fields in the load map
		Dictionary dct = new Dictionary();
		for (int j = 0; j < extended.vFields.size(); j++)
			{
			dct = (Dictionary) extended.vFields.get(j);
%><tr><td><%=dct.label_campo%>: </td><td><%=sSelectExcel(sOptions,dct.nombre_campo)%></td></tr>
<%			}
%>
<tr>
  <td></td>
  <td><br><br><INPUT type='submit' size='50' maxlength='50' name='continue'  VALUE='<%=countrybean.getTranslation("Continue")%>'> </td>		 
</tr>
<tr>
  <td colspan="2"><br><br><font class=warning><%=countrybean.getTranslation("ImportExcelNotice")%></font></td>		 
</tr>
</table>
</form>
</body>
</html>

<% dbCon.close(); %>
