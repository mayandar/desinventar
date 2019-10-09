<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<%@ page info="front page of DesConsultar On-Line" session="true" %> 
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.*" %>
<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id = "metadata" class="org.lared.desinventar.webobject.MetadataNational" scope="session" />
<jsp:useBean id = "metadataNationalValue" class="org.lared.desinventar.webobject.MetadataNationalValues" scope="session" />
<jsp:useBean id = "Dictionary" class="org.lared.desinventar.webobject.diccionario" scope="session" />
<%@ taglib uri="/inventag.tld" prefix="inv" %>
<%
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
if (countrybean.countrycode.length()==0)
{%><jsp:forward page="/inv/index.jsp"/><%}%>
<%@ include file="checkUserIsLoggedIn.jsp" %>
<title>DesInventar on-line : <%=countrybean.countryname%> <%=countrybean.getTranslation("Metadata National Download Manager")%> </title>
</head>
<%@ include file="/util/opendatabase.jspf" %>
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
<%-- open country database--%>
<%-- 
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/iheader",countrybean.getLanguage(),out);%>
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/header",countrybean.getLanguage(),out);%>
 --%>
<%
DownloadTable downloadTable = new DownloadTable();
ServletContext sc = getServletConfig().getServletContext();
String sSourcePath= sc.getRealPath("/download");
if (!sSourcePath.endsWith("/"))
	sSourcePath+="/";

int action=webObject.extendedParseInt(request.getParameter("action"));
String variableName = request.getParameter("variable");
if (request.getParameter("done")!=null)
{
  if(action == 1){
	  dbCon.close();
  %><jsp:forward page='/inv/metadataNationalManager.jsp'/><%
  }
  if(action == 2){
	  dbCon.close();
  %><jsp:forward page='/inv/maintainMetadataNationalValue.jsp'/><%
  }
}

String sXML="";
switch (action){
case 1: sXML="DI_export_metadata_national_";
		break;
case 2: sXML="DI_export_metadata_national_"+metadata.metadata_variable+"_";
		break;
		/* TODO: Implement export_metadata_element at here or into separated jsp file
case 3: sXML="DI_export_metadata_national_";
		break;
case 4: sXML="DI_export_metadata_national_";
		break;
		*/
}
sXML = sXML + countrybean.country.scountryid+".xml";

PrintStream xmlout = new PrintStream(sSourcePath+sXML,"UTF-8");


xmlout.println("<?xml version=\"1.0\"  encoding=\"UTF-8\" ?>");
xmlout.println("<DESINVENTAR>");
try	{
	String whereClause = "";
	switch(action){
	case 1:
		whereClause = whereClause+"where metadata_country='"+countrybean.countrycode+"'";
		downloadTable.outputTable ("metadata_national", xmlout, con, whereClause);
		downloadTable.outputTable ("metadata_national_values", xmlout, con, whereClause);
		downloadTable.outputTable ("metadata_national_lang", xmlout, con, whereClause);
		break;
	case 2:
		whereClause = whereClause+"where metadata_country='"+countrybean.countrycode+"'"
					+" and metadata_key="+metadata.metadata_key;
		downloadTable.outputTable ("metadata_national_values", xmlout, con, whereClause);
		break;
	}
	/*
	downloadTable.outputTable ("metadata_national", xmlout, con, whereClause);
	downloadTable.outputTable ("metadata_national_values", xmlout, con, whereClause);
	downloadTable.outputTable ("metadata_national_lang", xmlout, con, whereClause);

	downloadTable.outputTable ("metadata_indicator", xmlout, con, whereClause);
	downloadTable.outputTable ("metadata_indicator_lang", xmlout, con, whereClause);
	
	downloadTable.outputTable ("metadata_element", xmlout, con, whereClause);
	downloadTable.outputTable ("metadata_element_costs", xmlout, con, whereClause); 
	downloadTable.outputTable ("metadata_element_lang", xmlout, con, whereClause);
	
	downloadTable.outputTable ("metadata_element_indicator", xmlout, con, whereClause);
	*/

	stmt = con.createStatement ();
	// we assume all levels are always there, or none
	rset = stmt.executeQuery("Select table_level,table_name,table_code from level_attributes order by table_level");
	while (rset.next())
	 	{
		String sTable=htmlServer.not_null(rset.getString("table_name")).trim();
		// TODO: not clear how this will happen!!!  outputTable (sTable, out, con);
		}
    rset.close();
	stmt.close();	
	}
catch(Exception ex1)
	{
	out.println("<!-- Error in XML export: "+ex1.toString()+" -->");
	}	
dbCon.close();

xmlout.println("</DESINVENTAR>");
xmlout.close();

%>

<%
	String sLink=sXML.substring(0,sXML.lastIndexOf('.'))+".zip";
	// Verifies the downloadable zip exists
	String destZipFile=sSourcePath+sLink;					
	ZipUtil zipper=new ZipUtil();
 
	ArrayList<String> sShapes=new ArrayList<String>();    
	sShapes.add(sSourcePath+sXML);
	
	int MAXCODES=3;
	LevelMaps imlayer=new LevelMaps();
	for (int k=0; k<MAXCODES; k++)
	{
		imlayer.init();
		imlayer.map_level=k;
		imlayer.getWebObject(con);
		if (imlayer.filetype.equals("1") && imlayer.filename.length()>0 && (new File(imlayer.filename)).exists())
			{
			sShapes.add(imlayer.filename);
			sShapes.add(imlayer.filename.substring(0,imlayer.filename.length()-3)+"dbf");
			sShapes.add(imlayer.filename.substring(0,imlayer.filename.length()-3)+"shx");						
			}
	}

    // all files in one pack
	ZipUtil.zipFolder(sShapes, destZipFile);

	File f= new File(destZipFile);
	String sSizeKb="n/a";
	if (f.exists())
		sSizeKb=DICountry.formatDouble(f.length()/(1024.0*1024),-2)+" Mb";

%>
<FORM name="desinventar" method="post" action="metadataNationalDownload.jsp">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<input type="hidden" name="countrycode" id="countrycode" value="<%=countrybean.countrycode%>"> 
<input type="hidden" name="action" id="action" value="<%=action%>"> 
<table cellspacing="0" cellpadding="0" border="0" width="850">
<tr>
  <td width=50>&nbsp;</td>
  <td>
	<table cellspacing="0" cellpadding="0" border="0" width="650" rules="none">
	<tr>
	    <td height="25" colspan="2" class='bgDark' align="center">
	    <span class="title"><%=countrybean.getTranslation("National Metadata Manager")%></span>
		</td>
	</tr>
	<tr><td colspan="2" height="25">&nbsp;</td></tr>
	<tr>
		<td colspan="2" align="center">
		"<%=sLink%>" <%=countrybean.getTranslation("file is generated!")%>
		</td>
	</tr>
	<tr><td colspan="2" height="25">&nbsp;</td></tr>
	<tr>
		<td colspan="2" align="center">
		<input type="button" name="download" value="Download" onclick="location.href='/DesInventar/download/<%=sLink%>';" />
		<input type="submit" name="done" value="Done">
		</td>
	</tr>
	</table>
  </td>
 </tr>
</table>
</form>
<%-- 
<a href="/DesInventar/download/<%=sLink%>" alt="" border="0">Click here to download the database XML export and map files (<%=sSizeKb%>)</a>
 --%>
</body>
</html>
