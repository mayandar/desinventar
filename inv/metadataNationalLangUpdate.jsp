<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<%@ page import = "org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import="java.util.Calendar" %>
<%@ page import = "java.math.BigDecimal" %>
<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id = "metadata" class="org.lared.desinventar.webobject.MetadataNational" scope="session" />
<jsp:useBean id = "metadataNationalLang" class="org.lared.desinventar.webobject.MetadataNationalLang" scope="session" />
<%@ taglib uri="inventag.tld" prefix="inv" %>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
if (countrybean.countrycode.length()==0)
{%><jsp:forward page="/inv/index.jsp"/><%}%>
<%@ include file="checkUserIsLoggedIn.jsp" %>
<title>DesInventar on-line : <%=countrybean.countryname%> <%=countrybean.getTranslation("Metadata National Language Manager")%> </title>
</head>
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/iheader",countrybean.getLanguage(),out);%>
<%@ taglib uri="inventag.tld" prefix="inv" %>


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
<%-- 
<table width="1024" border="1" class="pageBackground" rules="none" height="500"><tr><td align="center" valign="top">
 --%>
<!-- Content goes after this comment -->
<br/><br/>
<table width="850" border="0">
<tr><td align="center">
<font color="Blue"><%=countrybean.getTranslation("Region")%></font>
<b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b>
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
/******************************************************************
*  Process the Register request.
******************************************************************/
if (request.getParameter("cancel")!=null)
{
  dbCon.close();
  %><jsp:forward page='/inv/metadataNationalManager.jsp'/><%
}
String sSql="";
String sErrorMessage="";
int action=webObject.extendedParseInt(request.getParameter("action"));
String tLang=request.getParameter("new_lang");
String sLang= tLang;
String sDescription=request.getParameter("new_description");
String ISO_lang_code[][] = {
		{"ar", "Arabic"},                        // six official languages first
		{"zh", "Chinese"},
		{"en", "English"},
		{"fr", "French"},
		{"ru", "Russian"},
		{"es", "Spanish; Castilian"},

		{"ab", "Abkhazian"},
		{"aa", "Afar"},
		{"af", "Afrikaans"},
		{"ak", "Akan"},
		{"sq", "Albanian"},
		{"am", "Amharic"},
		{"hy", "Armenian"},
		{"as", "Assamese"},
		{"av", "Avaric"},
		{"ae", "Avestan"},
		{"ay", "Aymara"},
		{"az", "Azerbaijani"},
		{"bm", "Bambara"},
		{"ba", "Bashkir"},
		{"eu", "Basque"},
		{"be", "Belarusian"},
		{"bn", "Bengali"},
		{"bh", "Bihari languages"},
		{"bi", "Bislama"},
		{"bs", "Bosnian"},
		{"br", "Breton"},
		{"bg", "Bulgarian"},
		{"my", "Burmese"},
		{"km", "Central Khmer"},
		{"ch", "Chamorro"},
		{"ce", "Chechen"},
		{"ny", "Chichewa; Chewa; Nyanja"},
		{"cv", "Chuvash"},
		{"kw", "Cornish"},
		{"co", "Corsican"},
		{"cr", "Cree"},
		{"hr", "Croatian"},
		{"cs", "Czech"},
		{"da", "Danish"},
		{"dv", "Divehi; Dhivehi; Maldivian"},
		{"nl", "Dutch; Flemish"},
		{"dz", "Dzongkha"},
		{"eo", "Esperanto"},
		{"et", "Estonian"},
		{"ee", "Ewe"},
		{"fo", "Faroese"},
		{"fj", "Fijian"},
		{"fi", "Finnish"},
		{"ff", "Fulah"},
		{"gd", "Gaelic; Scottish Gaelic"},
		{"lg", "Ganda"},
		{"ka", "Georgian"},
		{"de", "German"},
		{"el", "Greek"},
		{"gn", "Guarani"},
		{"gu", "Gujarati"},
		{"ht", "Haitian; Haitian Creole"},
		{"ha", "Hausa"},
		{"he", "Hebrew"},
		{"hz", "Herero"},
		{"hi", "Hindi"},
		{"ho", "Hiri Motu"},
		{"hu", "Hungarian"},
		{"is", "Icelandic"},
		{"io", "Ido"},
		{"ig", "Igbo"},
		{"id", "Indonesian"},
		{"iu", "Inuktitut"},
		{"ik", "Inupiaq"},
		{"ga", "Irish"},
		{"it", "Italian"},
		{"ja", "Japanese"},
		{"jv", "Javanese"},
		{"kl", "Kalaallisut; Greenlandic"},
		{"kn", "Kannada"},
		{"kr", "Kanuri"},
		{"ks", "Kashmiri"},
		{"kk", "Kazakh"},
		{"ki", "Kikuyu; Gikuyu"},
		{"rw", "Kinyarwanda"},
		{"ky", "Kirghiz; Kyrgyz"},
		{"kv", "Komi"},
		{"kg", "Kongo"},
		{"ko", "Korean"},
		{"kj", "Kuanyama; Kwanyama"},
		{"ku", "Kurdish"},
		{"lo", "Lao"},
		{"la", "Latin"},
		{"lv", "Latvian"},
		{"li", "Limburgan; Limburger; Limburgish"},
		{"ln", "Lingala"},
		{"lt", "Lithuanian"},
		{"lu", "Luba-Katanga"},
		{"lb", "Luxembourgish; Letzeburgesch"},
		{"mk", "Macedonian"},
		{"mg", "Malagasy"},
		{"ms", "Malay"},
		{"ml", "Malayalam"},
		{"mt", "Maltese"},
		{"gv", "Manx"},
		{"mi", "Maori"},
		{"mr", "Marathi"},
		{"mh", "Marshallese"},
		{"mn", "Mongolian"},
		{"na", "Nauru"},
		{"nv", "Navajo; Navaho"},
		{"nd", "Ndebele, North; North Ndebele"},
		{"nr", "Ndebele, South; South Ndebele"},
		{"ng", "Ndonga"},
		{"ne", "Nepali"},
//		{"nb", "Norwegian"}, // Covered by no
		{"se", "Northern Sami"},
		{"no", "Norwegian"},
		{"nn", "Norwegian Nynorsk; Nynorsk, Norwegian"},
		{"oc", "Occitan"},
		{"oj", "Ojibwa"},
		{"or", "Oriya"},
		{"om", "Oromo"},
		{"os", "Ossetian; Ossetic"},
		{"pi", "Pali"},
		{"pa", "Panjabi; Punjabi"},
		{"fa", "Persian"},
		{"pl", "Polish"},
		{"pt", "Portuguese"},
		{"ps", "Pushto; Pashto"},
		{"qu", "Quechua"},
		{"ro", "Romanian; Moldavian; Moldovan"},
		{"rm", "Romansh"},
		{"rn", "Rundi"},
		{"sm", "Samoan"},
		{"sg", "Sango"},
		{"sa", "Sanskrit"},
		{"sc", "Sardinian"},
		{"sr", "Serbian"},
		{"st", "Sesotho"},
		{"sn", "Shona"},
		{"ii", "Sichuan Yi; Nuosu"},
		{"sd", "Sindhi"},
		{"si", "Sinhala; Sinhalese"},
		{"sk", "Slovak"},
		{"sl", "Slovenian"},
		{"so", "Somali"},
		{"su", "Sundanese"},
		{"sw", "Swahili"},
		{"ss", "Swati"},
		{"sv", "Swedish"},
		{"tl", "Tagalog"},
		{"ty", "Tahitian"},
		{"tg", "Tajik"},
		{"ta", "Tamil"},
		{"tt", "Tatar"},
		{"te", "Telugu"},
		{"th", "Thai"},
		{"bo", "Tibetan"},
		{"ti", "Tigrinya"},
		{"to", "Tonga (Tonga Islands)"},
		{"ts", "Tsonga"},
		{"tn", "Tswana"},
		{"tr", "Turkish"},
		{"tk", "Turkmen"},
		{"tw", "Twi"},
		{"ug", "Uighur; Uyghur"},
		{"uk", "Ukrainian"},
		{"ur", "Urdu"},
		{"uz", "Uzbek"},
		{"ve", "Venda"},
		{"vi", "Vietnamese"},
		{"vo", "Volap체k"},
		{"wa", "Walloon"},
		{"cy", "Welsh"},
		{"fy", "Western Frisian"},
		{"wo", "Wolof"},
		{"xh", "Xhosa"},
		{"yi", "Yiddish"},
		{"yo", "Yoruba"},
		{"za", "Zhuang; Chuang"},
		{"zu", "Zulu"}
	};
	if (request.getParameter("saveMetadataLang")!=null)
	{
		
		//if(!metadataNationalLang.not_null(sLang).equals(metadataNationalLang.metadata_lang))
		//{ 
		// checks for a NEW or DIFFERENT name
		int nr=0;
		if (webObject.not_null(sDescription).equals(metadataNationalLang.metadata_description))
			{
			MetadataNationalLang metadataNationalLangFromDb=new MetadataNationalLang();
			metadataNationalLangFromDb.metadata_key=webObject.extendedParseInt(request.getParameter("metadata_key"));
			metadataNationalLangFromDb.metadata_country=countrybean.countrycode;
			metadataNationalLangFromDb.metadata_lang=metadataNationalLang.metadata_lang;
			nr=metadataNationalLangFromDb.getWebObject(con);
			if(nr > 0 && !metadataNationalLangFromDb.metadata_description.equals(webObject.not_null(sDescription)))
				nr=0;
			}
		// the new or different name exists...
		if (nr>0)
			{
			sErrorMessage=countrybean.getTranslation("SORRY")+": "+countrybean.getTranslation("Metadata national language ")+countrybean.getTranslation("alreadyexists");
			}
		else
			{
			metadata.getForm(request,response,con);
			if (action==0)
				{
				if(sLang == null){
					sErrorMessage=countrybean.getTranslation("SORRY")+": "+countrybean.getTranslation("National language code")+countrybean.getTranslation(" is required");
				}
				else {
					metadataNationalLang.metadata_key=metadata.metadata_key;
					metadataNationalLang.metadata_country=countrybean.countrycode;
					metadataNationalLang.metadata_description=sDescription;
					metadataNationalLang.metadata_lang=sLang;
					metadataNationalLang.addWebObject(con);
					sErrorMessage = metadataNationalLang.lastError;
				}
				%><!-- ADDED RECORD: --><%-- <%=metadataNationalLang.lastError--%><%
				}
			else
				/* TODO Update */
				{
				if (action==1)
					{
					PreparedStatement pstmt=null;
					try
						{
						// this statements implement DB-independent UPDATE ON CASCADE
						// Some databases (access, mysql) have problems/limitations on referential integrity constraints
						// Specifically, the implementation of ON UPDATE CASCADE ON DELETE ...  varies dramatically from 
						// platform to platform. In the future, these tables should have sequential surrogate keys.
						// a) creates new parent record
						// metadataNationalLang.getForm(request, response, con);
						metadataNationalLang.metadata_key=metadata.metadata_key;
						metadataNationalLang.metadata_country=countrybean.countrycode;
						metadataNationalLang.metadata_description=sDescription;
						// metadataNationalLang.metadata_lang=sLang;
						nr = metadataNationalLang.updateWebObject(con);
						sErrorMessage = metadataNationalLang.lastError;
						}
					catch (Exception e)
						{
						sErrorMessage="SORRY: national metadata cannot be updated.<!--"+e.toString()+" -->";
						}	
					try {pstmt.close();} catch (Exception cex){}
					%><!-- SECOND UPDATE: --><%-- <%=metadataNationalLang.lastError--%><%
					}
					%>
					<!-- FIRST UPDATE: <%-- <%=Event.sSql --%> --><%-- <%=Event.lastError--%><%
				}	
			if (sErrorMessage.length()==0)
				{
				dbCon.close();
		    	%><jsp:forward page='/inv/maintainMetadataNationalLang.jsp'/><%
				}
			}	
	  // }
	}

%>

<script language="JavaScript">
<!--
function submitForm() 
{
  document.desinventar.submit()
}

function resetForm() 
{
  document.desinventar.reset()
//  document.desinventar.nombre.focus()
}

var notValidChars = " '\/<>";

function validate_alpha(entered,alertbox)
{
validateFlag=true;
for (j=0; j<entered.value.length; j++)
	{
    toCheck=entered.value.charAt(j);
	if (notValidChars.indexOf(toCheck)>=0)
		validateFlag=false;
	} 
if (!validateFlag)
	alert(alertbox);
return validateFlag;
}

function trim(strVariable)
{
if (strVariable==null)
	return "";
var len=strVariable.length;
if (len==0)
	return "";
// first part:  trims blanks to the right
var index=len-1;
while ((index>0) && (strVariable.charAt(index)==" ")) index--;
strVariable=strVariable.substring(0,index+1);
// second part:  trims leading blanks
len=strVariable.length;
index=0;
while ((index<len) && (strVariable.charAt(index)==" ")) index++;
strVariable=strVariable.substring(index,len);
return strVariable;
}

function emptyvalidation(entered, alertbox)
{
with (entered)
	{
    value=trim(value);
	if (value==null || value=="")
		{	
		if (alertbox!="") 
			alert(alertbox);
		return false;
		}
	else 
		return true;
	}
}


function validateFields()
{
var ok=true;
ok= emptyvalidation(document.desinventar.newname,' <%=countrybean.getTranslation("Name")%> <%=countrybean.getTranslation("ismandatory")%>!..')
return ok;
}
// -->
</script>



<form name="desinventar" action="metadataNationalLangUpdate.jsp" method="post" onSubmit="return validateFields()">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<input type="hidden" name="action" value="<%=action %>">
<input type="hidden" name="metadata_key" value="<%=metadataNationalLang.metadata_key %>">
<input type="hidden" name="metadata_countrycode" id="countrycode" value="<%=countrybean.countrycode %>"> 
<table cellspacing="0" cellpadding="2" border="0" width="750">
<tr>
    <td class='bgDark' height="25" colspan="2"><span class="titleText"><%=countrybean.getTranslation("Definitionof")%> <%=countrybean.getTranslation("Metadata national value")%> </span></td>
</tr>
<tr><td colspan="2" height="5"></td></tr>
<TR>
<TD colspan='2' align="center"><span class="warning"><%=sErrorMessage%></span></TD>
</TR>
<TR>
	<td width='220' class='bgLight' align='right'><%=countrybean.getTranslation("National language code")%>:</td>
	<td> 
	<% if (action == 0) 
		{ %> 	
		<select id="new_lang" name="new_lang" size="10">
	<%  } 
		else 
		{ %>
		<select id="new_lang" name="new_lang" size="1" disabled>
	<%  }
		for(int i = 0; i < ISO_lang_code.length ; i++){
			if(ISO_lang_code[i][0].equals(metadataNationalLang.metadata_lang)) 
			{
			%>
			<option value='<%=ISO_lang_code[i][0]%>' selected ><%=ISO_lang_code[i][1]%></option>
			<%
			} 
			else 
			{ %>
			<option value='<%=ISO_lang_code[i][0]%>' ><%=ISO_lang_code[i][1]%></option>
			<%
			}
		}
	%>
		</select>
	</td>
</tr>
<tr>
	<td width='220' class='bgLight' align='right'><%=countrybean.getTranslation("National language description")%>:</td>
	<td>  <INPUT type='TEXT' size='31' maxlength='200' name='new_description' VALUE="<%=htmlServer.htmlEncode(metadataNationalLang.metadata_description)%>"></td>
</tr>

	<TR>
	<TD colspan='3' height="20"></TD>
	</TR>
	<TR>
	<TD  valign="bottom"  align='right'>
	</TD>
	<TD valign="bottom">
	<input name="saveMetadataLang" type='submit' value='<%=countrybean.getTranslation("Save")%> <%=countrybean.getTranslation("Metadata national language")%>'> &nbsp; &nbsp; &nbsp; &nbsp;
	<input name="cancelMetadataValue" type='button' value='<%=countrybean.getTranslation("Cancel")%>' onClick="postTo('maintainMetadataNationalLang.jsp')">
	</TD>
	</Tr>

	<TR>
	<TD colspan='3' height="10"></TD>
	</TR>
	<TR>
</table>
</form>
<script language="JavaScript">
<!-- 
giveFocus();
// -->
</script>
</BODY>
</html>
<% dbCon.close(); %>












