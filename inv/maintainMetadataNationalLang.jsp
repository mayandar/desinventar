<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<%@ page import = "org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.webobject.users" %>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.HashMap" %>
<%@ page import = "java.math.BigDecimal" %>
<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id = "countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id = "metadata" class="org.lared.desinventar.webobject.MetadataNational" scope="session" />
<jsp:useBean id = "metadataNationalLang" class="org.lared.desinventar.webobject.MetadataNationalLang" scope="session" />
<jsp:useBean id = "Dictionary" class="org.lared.desinventar.webobject.diccionario" scope="session" />
<%
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
if (countrybean.countrycode.length()==0)
{%><jsp:forward page="/inv/index.jsp"/><%}%>
<%@ include file="checkUserIsLoggedIn.jsp" %>
<title>DesInventar on-line : <%=countrybean.countryname%> <%=countrybean.getTranslation("Metadata National Language Manager")%> </title>
</head>
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
<table width="1024" border="1" class="pageBackground" rules="none" height="500"><tr><td align="center" valign="top">
<!-- Content goes after this comment -->
<table width="580" border="0">
<tr><td align="center">
<font color="Blue"><%=countrybean.getTranslation("Region")%></font>
<b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font>
 - [<jsp:getProperty name ="countrybean" property="countrycode"/>]
</td></tr>
</table>
 <% if (user.iusertype < 20){ %>
 <jsp:forward page="noaccess.jsp"/>
 <%} %>  
<%@ include file="/util/opendatabase.jspf" %>
 <link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
<script type="text/javascript" src="/DesInventar/html/iheader.js"></script> 

 
<% 
int nSqlResult =0;
String sErrorMessage="";
HashMap<String, String> ISO_lang_code_map = new HashMap<String, String>();

ISO_lang_code_map.put("ar", "Arabic");
ISO_lang_code_map.put("zh", "Chinese");
ISO_lang_code_map.put("en", "English");
ISO_lang_code_map.put("fr", "French");
ISO_lang_code_map.put("ru", "Russian");
ISO_lang_code_map.put("es", "Spanish; Castilian");

ISO_lang_code_map.put("aa", "Afar");
ISO_lang_code_map.put("ab", "Abkhazian");
ISO_lang_code_map.put("ae", "Avestan");
ISO_lang_code_map.put("af", "Afrikaans");
ISO_lang_code_map.put("ak", "Akan");
ISO_lang_code_map.put("am", "Amharic");
ISO_lang_code_map.put("as", "Assamese");
ISO_lang_code_map.put("av", "Avaric");
ISO_lang_code_map.put("ay", "Aymara");
ISO_lang_code_map.put("az", "Azerbaijani");
ISO_lang_code_map.put("ba", "Bashkir");
ISO_lang_code_map.put("be", "Belarusian");
ISO_lang_code_map.put("bg", "Bulgarian");
ISO_lang_code_map.put("bh", "Bihari languages");
ISO_lang_code_map.put("bi", "Bislama");
ISO_lang_code_map.put("bm", "Bambara");
ISO_lang_code_map.put("bn", "Bengali");
ISO_lang_code_map.put("bo", "Tibetan");
ISO_lang_code_map.put("br", "Breton");
ISO_lang_code_map.put("bs", "Bosnian");
ISO_lang_code_map.put("ce", "Chechen");
ISO_lang_code_map.put("ch", "Chamorro");
ISO_lang_code_map.put("co", "Corsican");
ISO_lang_code_map.put("cr", "Cree");
ISO_lang_code_map.put("cs", "Czech");
ISO_lang_code_map.put("cv", "Chuvash");
ISO_lang_code_map.put("cy", "Welsh");
ISO_lang_code_map.put("da", "Danish");
ISO_lang_code_map.put("de", "German");
ISO_lang_code_map.put("dv", "Divehi; Dhivehi; Maldivian");
ISO_lang_code_map.put("dz", "Dzongkha");
ISO_lang_code_map.put("ee", "Ewe");
ISO_lang_code_map.put("el", "Greek");
ISO_lang_code_map.put("eo", "Esperanto");
ISO_lang_code_map.put("et", "Estonian");
ISO_lang_code_map.put("eu", "Basque");
ISO_lang_code_map.put("fa", "Persian");
ISO_lang_code_map.put("ff", "Fulah");
ISO_lang_code_map.put("fi", "Finnish");
ISO_lang_code_map.put("fj", "Fijian");
ISO_lang_code_map.put("fo", "Faroese");
ISO_lang_code_map.put("fy", "Western Frisian");
ISO_lang_code_map.put("ga", "Irish");
ISO_lang_code_map.put("gd", "Gaelic; Scottish Gaelic");
ISO_lang_code_map.put("gn", "Guarani");
ISO_lang_code_map.put("gu", "Gujarati");
ISO_lang_code_map.put("gv", "Manx");
ISO_lang_code_map.put("ha", "Hausa");
ISO_lang_code_map.put("he", "Hebrew");
ISO_lang_code_map.put("hi", "Hindi");
ISO_lang_code_map.put("ho", "Hiri Motu");
ISO_lang_code_map.put("hr", "Croatian");
ISO_lang_code_map.put("ht", "Haitian; Haitian Creole");
ISO_lang_code_map.put("hu", "Hungarian");
ISO_lang_code_map.put("hy", "Armenian");
ISO_lang_code_map.put("hz", "Herero");
ISO_lang_code_map.put("id", "Indonesian");
ISO_lang_code_map.put("ie", "Interlingue; Occidental");
ISO_lang_code_map.put("ig", "Igbo");
ISO_lang_code_map.put("ii", "Sichuan Yi; Nuosu");
ISO_lang_code_map.put("ik", "Inupiaq");
ISO_lang_code_map.put("io", "Ido");
ISO_lang_code_map.put("is", "Icelandic");
ISO_lang_code_map.put("it", "Italian");
ISO_lang_code_map.put("iu", "Inuktitut");
ISO_lang_code_map.put("ja", "Japanese");
ISO_lang_code_map.put("jv", "Javanese");
ISO_lang_code_map.put("ka", "Georgian");
ISO_lang_code_map.put("kg", "Kongo");
ISO_lang_code_map.put("ki", "Kikuyu; Gikuyu");
ISO_lang_code_map.put("kj", "Kuanyama; Kwanyama");
ISO_lang_code_map.put("kk", "Kazakh");
ISO_lang_code_map.put("kl", "Kalaallisut; Greenlandic");
ISO_lang_code_map.put("km", "Central Khmer");
ISO_lang_code_map.put("kn", "Kannada");
ISO_lang_code_map.put("ko", "Korean");
ISO_lang_code_map.put("kr", "Kanuri");
ISO_lang_code_map.put("ks", "Kashmiri");
ISO_lang_code_map.put("ku", "Kurdish");
ISO_lang_code_map.put("kv", "Komi");
ISO_lang_code_map.put("kw", "Cornish");
ISO_lang_code_map.put("ky", "Kirghiz; Kyrgyz");
ISO_lang_code_map.put("la", "Latin");
ISO_lang_code_map.put("lb", "Luxembourgish; Letzeburgesch");
ISO_lang_code_map.put("lg", "Ganda");
ISO_lang_code_map.put("li", "Limburgan; Limburger; Limburgish");
ISO_lang_code_map.put("ln", "Lingala");
ISO_lang_code_map.put("lo", "Lao");
ISO_lang_code_map.put("lt", "Lithuanian");
ISO_lang_code_map.put("lu", "Luba-Katanga");
ISO_lang_code_map.put("lv", "Latvian");
ISO_lang_code_map.put("mg", "Malagasy");
ISO_lang_code_map.put("mh", "Marshallese");
ISO_lang_code_map.put("mi", "Maori");
ISO_lang_code_map.put("mk", "Macedonian");
ISO_lang_code_map.put("ml", "Malayalam");
ISO_lang_code_map.put("mn", "Mongolian");
ISO_lang_code_map.put("mr", "Marathi");
ISO_lang_code_map.put("ms", "Malay");
ISO_lang_code_map.put("mt", "Maltese");
ISO_lang_code_map.put("my", "Burmese");
ISO_lang_code_map.put("na", "Nauru");
ISO_lang_code_map.put("nb", "Norwegian");
ISO_lang_code_map.put("nd", "Ndebele, North; North Ndebele");
ISO_lang_code_map.put("ne", "Nepali");
ISO_lang_code_map.put("ng", "Ndonga");
ISO_lang_code_map.put("nl", "Dutch; Flemish");
ISO_lang_code_map.put("nn", "Norwegian Nynorsk; Nynorsk, Norwegian");
ISO_lang_code_map.put("no", "Norwegian");
ISO_lang_code_map.put("nr", "Ndebele, South; South Ndebele");
ISO_lang_code_map.put("nv", "Navajo; Navaho");
ISO_lang_code_map.put("ny", "Chichewa; Chewa; Nyanja");
ISO_lang_code_map.put("oc", "Occitan");
ISO_lang_code_map.put("oj", "Ojibwa");
ISO_lang_code_map.put("om", "Oromo");
ISO_lang_code_map.put("or", "Oriya");
ISO_lang_code_map.put("os", "Ossetian; Ossetic");
ISO_lang_code_map.put("pa", "Panjabi; Punjabi");
ISO_lang_code_map.put("pi", "Pali");
ISO_lang_code_map.put("pl", "Polish");
ISO_lang_code_map.put("ps", "Pushto; Pashto");
ISO_lang_code_map.put("pt", "Portuguese");
ISO_lang_code_map.put("qu", "Quechua");
ISO_lang_code_map.put("rm", "Romansh");
ISO_lang_code_map.put("rn", "Rundi");
ISO_lang_code_map.put("ro", "Romanian; Moldavian; Moldovan");
ISO_lang_code_map.put("rw", "Kinyarwanda");
ISO_lang_code_map.put("sa", "Sanskrit");
ISO_lang_code_map.put("sc", "Sardinian");
ISO_lang_code_map.put("sd", "Sindhi");
ISO_lang_code_map.put("se", "Northern Sami");
ISO_lang_code_map.put("sg", "Sango");
ISO_lang_code_map.put("si", "Sinhala; Sinhalese");
ISO_lang_code_map.put("sk", "Slovak");
ISO_lang_code_map.put("sl", "Slovenian");
ISO_lang_code_map.put("sm", "Samoan");
ISO_lang_code_map.put("sn", "Shona");
ISO_lang_code_map.put("so", "Somali");
ISO_lang_code_map.put("sq", "Albanian");
ISO_lang_code_map.put("sr", "Serbian");
ISO_lang_code_map.put("ss", "Swati");
ISO_lang_code_map.put("st", "Sesotho");
ISO_lang_code_map.put("su", "Sundanese");
ISO_lang_code_map.put("sv", "Swedish");
ISO_lang_code_map.put("sw", "Swahili");
ISO_lang_code_map.put("ta", "Tamil");
ISO_lang_code_map.put("te", "Telugu");
ISO_lang_code_map.put("tg", "Tajik");
ISO_lang_code_map.put("th", "Thai");
ISO_lang_code_map.put("ti", "Tigrinya");
ISO_lang_code_map.put("tk", "Turkmen");
ISO_lang_code_map.put("tl", "Tagalog");
ISO_lang_code_map.put("tn", "Tswana");
ISO_lang_code_map.put("to", "Tonga (Tonga Islands)");
ISO_lang_code_map.put("tr", "Turkish");
ISO_lang_code_map.put("ts", "Tsonga");
ISO_lang_code_map.put("tt", "Tatar");
ISO_lang_code_map.put("tw", "Twi");
ISO_lang_code_map.put("ty", "Tahitian");
ISO_lang_code_map.put("ug", "Uighur; Uyghur");
ISO_lang_code_map.put("uk", "Ukrainian");
ISO_lang_code_map.put("ur", "Urdu");
ISO_lang_code_map.put("uz", "Uzbek");
ISO_lang_code_map.put("ve", "Venda");
ISO_lang_code_map.put("vi", "Vietnamese");
ISO_lang_code_map.put("vo", "Volap체k");
ISO_lang_code_map.put("wa", "Walloon");
ISO_lang_code_map.put("wo", "Wolof");
ISO_lang_code_map.put("xh", "Xhosa");
ISO_lang_code_map.put("yi", "Yiddish");
ISO_lang_code_map.put("yo", "Yoruba");
ISO_lang_code_map.put("za", "Zhuang; Chuang");
ISO_lang_code_map.put("zu", "Zulu");

if (request.getParameter("addMetadataNationalLang")!=null)
   {
	metadataNationalLang.init();
	metadataNationalLang.dbType = metadata.dbType;
	metadataNationalLang.metadata_country = metadata.metadata_country;
	metadataNationalLang.metadata_key = metadata.metadata_key;
	dbCon.close();
	%><jsp:forward page="metadataNationalLangUpdate.jsp?action=0"/><%
   }
else if (request.getParameter("editMetadataNationalLang")!=null)
   {
	metadataNationalLang.init();
	metadataNationalLang.dbType = metadata.dbType;
	metadataNationalLang.metadata_country = metadata.metadata_country;
	metadataNationalLang.metadata_key = metadata.metadata_key;
	metadataNationalLang.metadata_lang = request.getParameter("new_lang");
	metadataNationalLang.metadata_description = request.getParameter("new_description");
	metadataNationalLang.getWebObject(con);
	dbCon.close();
	%><jsp:forward page="metadataNationalLangUpdate.jsp?action=1"/><%
   }
else if (request.getParameter("deleteMetadataNationalLang")!=null)
   {
	metadataNationalLang.init();
	metadataNationalLang.dbType = metadata.dbType;
	metadataNationalLang.metadata_country = countrybean.countrycode;
	metadataNationalLang.metadata_key = metadata.metadata_key;
	metadataNationalLang.metadata_lang = request.getParameter("new_lang");
	nSqlResult = metadataNationalLang.getWebObject(con);
	if(nSqlResult < 1){
		sErrorMessage = metadataNationalLang.lastError;
	} else {
		nSqlResult = metadataNationalLang.deleteWebObject(con);
		if(nSqlResult < 1)
			sErrorMessage = metadataNationalLang.lastError;
	}
	dbCon.close();
	%><%-- <jsp:forward page="metadataNationalLangUpdate.jsp?action=2"/> --%><%
   }

String sField=countrybean.dbHelper[countrybean.dbType].sqlNvl("label_campo","label_campo_en");
if (countrybean.getDataLanguage().equals("EN"))
{
sField=countrybean.dbHelper[countrybean.dbType].sqlNvl("label_campo_en","label_campo");
}

%>
   
<script language="JavaScript">
<!--
function confirmDelete()
{
	return confirm ("<%=countrybean.getTranslation("Areyousureyouwanttodeletethis")%> <%=countrybean.getTranslation("field")%>?");
}

function editField(eventId, lang, description)
{
	// alert("event_id="+eventId+", lang="+lang+", description="+description);
	if(eventId === 'deleteMetadataNationalLang')
	{
		if (!confirmDelete())
			return false;
	}
	var theForm = document.forms['desinventar'];
	var event = document.createElement('input');
	event.type = 'hidden';
	event.name = eventId ; // 'the key/name of the attribute/field that is sent to the server
	event.value = 'active';
	theForm.appendChild(event);
	var new_lang = document.createElement('input');
	new_lang.type = 'hidden';
	new_lang.name = 'new_lang' ; // 'the key/name of the attribute/field that is sent to the server
	new_lang.value = lang;
	theForm.appendChild(new_lang);
	var new_description = document.createElement('input');
	new_description.type = 'hidden';
	new_description.name = 'new_description' ; // 'the key/name of the attribute/field that is sent to the server
	new_description.value = description;
	theForm.appendChild(new_description);
	document.desinventar.submit();
}
//-->
</script>

<FORM name="desinventar" id="maintainMetadataNationalLang" method="post" action="maintainMetadataNationalLang.jsp">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<input type="hidden" name="metadata_key" value="<%=metadataNationalLang.metadata_key %>">
<input type="hidden" name="metadata_countrycode" id="countrycode" value="<%=countrybean.countrycode %>"> 
<table cellspacing="0" cellpadding="0" border="0" width="850">
<tr>
  <td width=50>&nbsp;</td>
  <td>
	<table cellspacing="0" cellpadding="5" border="0" width="850" rules="none">
	<tr>
	    <td height="25" td colspan="2" class='bgDark' align="center"><span class="title"><%=countrybean.getTranslation("Annual Metadata Value Manager")%></span></td>
		</td>
	</tr>
	<tr><td colspan="2" height="5"></td></tr>
	<TR>
	<TD colspan=2 align="center"><span class="warning"><%=sErrorMessage%></span></TD>
	</TR>
	<tr><td colspan="2" align="center">
	<input type="submit" name="addMetadataNationalLang" value="<%=countrybean.getTranslation("Add")%> <%=countrybean.getTranslation(metadata.metadata_variable)%> <%=countrybean.getTranslation("language translation")%>">
   <input name="doneButton" type=button value='<%=countrybean.getTranslation("Done")%>' onClick="postTo('metadataNationalManager.jsp')">
	</td></tr>

	<tr><td colspan="2" align="center">
	<br/><br/>
	<table cellpadding=2  width="90%" celspacing=0 border=1>
    <tr class="DI_TableHeader bodyclass">
    <th><%=countrybean.getTranslation("Edit")%></th>
    <th><%=countrybean.getTranslation("Delete")%></th>
    <th><%=countrybean.getTranslation("Metadata Language")%></th>
    <th><%=countrybean.getTranslation("Metadata Description")%></th>
    </tr>
<%
	stmt=con.createStatement();
	rset=stmt.executeQuery("select * from metadata_national_lang order by metadata_lang");
	int j=0;
	while (rset.next())
		{
		MetadataNationalLang nationalLang=new MetadataNationalLang();
		nationalLang.loadWebObject(rset);
		out.println("<tr class='bs'>");
		out.println("<td align='center'><input name='editMetadataNationalLang"+j+"' id='editMetadataNationalLang"+j+"' type='image'");
		out.println(" src='/DesInventar/images/edit_row.gif' alt='Submit' border='0'");
		out.println(" onClick=\"editField("+"'editMetadataNationalLang', '"+nationalLang.metadata_lang+"', '"+nationalLang.metadata_description+"')\"></td>");
		out.println("<td align='center'><input name='deleteMetadataNationalLang"+j+"' id='deleteMetadataNationalLang"+j+"' type='image'");
		out.println(" src='/DesInventar/images/delete_row.gif' alt='Submit' border='0'");
		out.println(" onClick=\"editField("+"'deleteMetadataNationalLang', '"+nationalLang.metadata_lang+"', '"+nationalLang.metadata_description+"')\"></td>");
		out.println("<td align='center'>"+ISO_lang_code_map.get(nationalLang.metadata_lang)+"</td><td align='left'>"+nationalLang.metadata_description+"</td></tr>");
		j++;
		}
	rset.close();	
	stmt.close();
%>
	
     </table>
	</td></tr>
	</table>
  </td>
 </tr>
</table>
</form>
</body>
</html>
<% dbCon.close(); %>

