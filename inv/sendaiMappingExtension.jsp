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
<jsp:useBean id = "Dictionary" class="org.lared.desinventar.webobject.diccionario" scope="session" />
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
if (document.desinventar.source_extension.selectedIndex==-1 || document.desinventar.source_extension.selectedIndex==-1)
	{
	alert ('<%=countrybean.getTranslation("Please select a mapping pair")%>');
	return false;
	} 
return true;
}
// -->
</script>
<%
// process merge, if requested


// prepare for next merge (code duplicated in ficha.jsp and i_ficha.jsp, sorry):
String sHtmlFolder=getServletConfig().getServletContext().getRealPath("html")+"/";
String[] sTemplate={"datacard_","datacard_","datacard_UN","datacard_UN"};   // tries in order: datacard_ccc_ll, datacard_ccc, datacard_def_ll, datacard_def    
ArrayList alProcessedFields=null;
org.lared.desinventar.webobject.Dictionary dct = new org.lared.desinventar.webobject.Dictionary();
dct.nombre_campo="LIVING_DMGD_DWELLINGS"; // very unlikely defined outside sendai
dct.dbType=countrybean.dbType;
int nSendai=dct.getWebObject(con);
 
sTemplate[0]+=countrybean.countrycode.toUpperCase();
sTemplate[1]+=countrybean.countrycode.toUpperCase();
if (!countrybean.getLanguage().toLowerCase().equals("en"))
	{
	sTemplate[0]+="_"+countrybean.getLanguage().toLowerCase();
	sTemplate[2]+="_"+countrybean.getLanguage().toLowerCase();
	}
int iTemplate=0;
File tmpl=new File(sHtmlFolder+sTemplate[0]+".html");
while (iTemplate<3 && !tmpl.exists())
	tmpl=new File(sHtmlFolder+sTemplate[++iTemplate]+".html");

if (tmpl.exists() && nSendai>0)
{
String sTempl=sHtmlFolder+sTemplate[iTemplate]+".html";
//System.out.println("[DI9] merge using template: "+	sTempl);

//woFicha.addExtensionHashMap(woExtension);
alProcessedFields=dct.extractFieldsFromTemplate(sTempl);	
}
String sErrorMessage="";

String sSource=request.getParameter("source_ext");
String[] aSource=request.getParameterValues("source_ext");
if (aSource!=null && aSource.length>1)
	{
		sSource=aSource[0];
		for (int j=1; j<aSource.length; j++)
			sSource+=" + "+aSource[j];		
	}
String sTarget=request.getParameter("destination_ext");
if (request.getParameter("mergeMeta")!=null || request.getParameter("mergeMetaWithDelete")!=null )
   {
   int nUpdates=0;   
   try{
   		stmt=con.createStatement();
		nUpdates=stmt.executeUpdate("update extension set "+sTarget+"="+sSource);
		stmt.close();		
	    Dictionary.init();
		if (request.getParameter("mergeMetaWithDelete")!=null)
		   {
			Dictionary.nombre_campo=sSource;
			stmt=con.createStatement ();
			String sSql="";
			int nDeletedVar=0;
			try	{
				// remove variable from the database!!!
				sSql="alter table extension drop column "+Dictionary.nombre_campo;
				stmt.executeUpdate(sSql);
				try	{
					sSql="delete from extensioncodes where field_name='"+Dictionary.nombre_campo+"'";
					stmt.executeUpdate(sSql);
					Dictionary.deleteWebObject(con);
					}
				catch (Exception e3)
					{
					sErrorMessage+="Warning: problem deleting codes/field (cannot be deleted)...("+e3.toString()+" <!--"+sSql+"--> )";
					}	
				}
			catch (Exception e3)
				{
				sErrorMessage="WARNING: Field could not be deleted from database, please remove manually...("+e3.toString()+" <!--"+sSql+"--> )";
				}	
			finally
				{
				stmt.close();
				}
				
		    }
		sErrorMessage="Mapping extension operation results: "+sSource+" -> "+sTarget+", "+nUpdates+" records updated";
   		}
	catch (Exception merx)
		{
		/// what?
		sErrorMessage="ERROR mapping extension: "+merx.toString();
		System.out.println("[DI10] error merging  "+sSource+"  "+sTarget+": "+merx.toString());
		}	
   }

%>
<FORM name="desinventar" method="post" action="sendaiMappingExtension.jsp">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<br/><br/> 
<table width="1024" border="0" rules="none">
<tr>
	<td align="center" valign="top">
	<!-- Content goes after this comment -->
    <table width="90%" border="0">
        <tr><td align="center">
         <font color="Blue"><%=countrybean.getTranslation("Region")%></font>
         <b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font>
          - [<jsp:getProperty name ="countrybean" property="countrycode"/>]
         </td>
        </tr>
    </table>
	<!-- Content goes before this comment -->
	</td>
</tr>
<tr><td align="left">
<span class=subTitle><%=countrybean.getTranslation("DesInventar Sendai Metadata Manager")%></span><br>
<br>
</td></tr>
<TR><TD colspan=2 align="center"><span class="warning"><%=sErrorMessage%></span></TD></TR>
<tr><td align="left" colspan="2">
<%=countrybean.getTranslation("Select the Extension Variable and the Sendai Indicator you want to merge:")%>
<br/><br/>
</td></tr>
 <tr><td>
	<%=countrybean.getTranslation("Extension Variables available to merge:")%>
	<br/> 
	<SELECT name="source_ext" style="WIDTH: 500px; HEIGHT: 230px; margin-left:30px;" size='10' multiple>
    <%
	StringBuffer sWhere=new StringBuffer("nombre_campo not in ('@@@'");
	for (int j=0; j<alProcessedFields.size(); j++)
		{
		sWhere.append(",'");
		sWhere.append((String)(alProcessedFields.get(j)));
		sWhere.append("'");
		}
	sWhere.append(")");
	sWhere.append("and (not nombre_campo like 'LOSS_%')and(not nombre_campo like 'TOTAL_%') and (not nombre_campo like 'DAMAGED_%')and (not nombre_campo like 'DESTRYD_%')");
	String sSelected="@@@";
	%>
   	<inv:select tablename='diccionario' selected='<%= sSelected %>' connection='<%= con %>'
    	fieldname="label_campo_en" codename='nombre_campo' ordername='orden' whereclause='<%=sWhere.toString()%>'/>
 	</SELECT>
    <br/><br>
</td><td>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<%=countrybean.getTranslation("Select Sendai Indicator you want data to merge to:")%>
	<br/> 
	<SELECT name="destination_ext" style="WIDTH: 500px; HEIGHT: 230px; margin-left:30px;" size='10'>
    <%
	sWhere=new StringBuffer("nombre_campo in ('@@@'");
	for (int j=0; j<alProcessedFields.size(); j++)
		{
		sWhere.append(",'");
		sWhere.append((String)(alProcessedFields.get(j)));
		sWhere.append("'");
		}
	sWhere.append(")");
	sWhere.append(" OR (nombre_campo like 'LOSS_%') OR(nombre_campo like 'TOTAL_%') OR (nombre_campo like 'DAMAGED_%') OR (nombre_campo like 'DESTRYD_%')");
	%>
   	<inv:select tablename='diccionario' selected='<%= sSelected %>' connection='<%= con %>'
    	fieldname="label_campo" codename='nombre_campo' ordername='orden' whereclause='<%=sWhere.toString()%>'/>
 	</SELECT>
    <br/><br>
</td></tr>
 <tr><td align="center" colspan="2">
    <input type="submit" name="mergeMeta" value='<%=countrybean.getTranslation("Transfer the extension data into selected Sendai Indicator")%>' onClick="return bSomethingSelected()"><br/><br/><br/>
    <input type="submit" name="mergeMetaWithDelete" value='<%=countrybean.getTranslation("Transfer the extension data into selected Sendai Indicator and DELETE extension")%>' onClick="return bSomethingSelected()"><br/><br/><br/>
    <input type="button" name="endMeta" value='<%=countrybean.getTranslation("Done")%>' onClick="document.location='sendaitab.jsp'">
 </td></tr>

</table>
<br><br>
</body>
</html>
