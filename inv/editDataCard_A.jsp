<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8");%>
<%@ page info="DesInventar On-Line edit data page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="woFicha" class="org.lared.desinventar.webobject.fichas" scope="session" />
<jsp:useBean id="woExtension" class="org.lared.desinventar.webobject.extension" scope="session" />
<%// checks for a session alive variable, or we have a new valid countrycode
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
if (countrybean.countrycode.length()==0)
	{%><jsp:forward page="/inv/index.jsp"/>
	<%}%>
<%@ include file="checkUserIsLoggedIn.jsp" %>
<%if (user.iusertype<1) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}%>
<%
if (request.getParameter("quit")!=null)	   	
		{
	   %><jsp:forward page="datacardtab.jsp" /><%
		}
 %>
<%@ include file="/util/opendatabase.jspf" %>
<head>
<title><%=countrybean.countryname%><%=countrybean.getTranslation("DataEntry")%></title>
</head>
<body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/iheader",countrybean.getLanguage(),out);%>
<%@ taglib uri="/inventag.tld" prefix="inv" %>
<%
{
int nTabActive=7; // 
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
<%}%>

<table width="100%" border="1" class="pageBackground" rules="none">
<tr><td align="left" valign="top">
<!-- Content goes after this comment -->
	<table width="1000" border="0">
	<tr><td align="center">
	<font color="Blue"><%=countrybean.getTranslation("Region")%></font>
	<b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font>
	- [<jsp:getProperty name ="countrybean" property="countrycode"/>]
	</td></tr>
	</table>
<!-- Content goes before this comment -->
</td></tr>
</table><br/>
<form name="desinventar" method="post" action="editDataCard.jsp"> 
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<%@ taglib uri="/inventag.tld" prefix="inv" %>
<% // Java declarations
ArrayList sqlparams=new ArrayList();
PreparedStatement pstmt=null;
// loads the datacard extension
woExtension.dbType=dbType;
woFicha.dbType=dbType;
woExtension.loadExtension(con,countrybean);
int nClave=0; 
int j=0; 
int start=0; 
int current=0; 
String toSearch=""; 
current=0;
start=htmlServer.extendedParseInt(request.getParameter("start"));	
int action=htmlServer.extendedParseInt(request.getParameter("action"));	
if (start==0) start=1;
toSearch=htmlServer.not_null(request.getParameter("tosearch"));	
countrybean.bViewStandard=request.getParameter("viewStandard")!=null;
// open the database 
if (bConnectionOK)
	{
	if ((request.getParameter("saveCard")!=null) || (request.getParameter("addMedia")!=null))
		{
    	// get primary key from parameters
    	nClave=htmlServer.extendedParseInt(request.getParameter("clave"));	
		// gets the object from the database
		woFicha.clave=nClave;
		woFicha.getForm(request, response, con);
		// update the webObject
		woFicha.updateWebObject(con); 
		out.println("<!-- DataCard saving: -->"+woFicha.lastError);
		// UPDATE EXTENSION PARTNER OF THE DATACARD (fixing possible issues caused by DI6!):
		woExtension.clave_ext=nClave;
		int nr=woExtension.getWebObject(con); 
		woExtension.getForm(request, response, con);
		// this field is lost during getForm-its ok
		woExtension.clave_ext=nClave;
		if (nr==1)
			nr=woExtension.updateWebObject(con); 
		else	
			nr=woExtension.addWebObject(con); 
		out.println("<!-- Ext saving: -->"+woExtension.lastError);
		//out.println("<!--SQL="+woExtension.sSql+"-->");		
		// removes the entry from tips - it will not show real data
		CountryTip.getInstance().remove(countrybean.countrycode);
		if (request.getParameter("addMedia")!=null)
			{%>
			<jsp:forward page="mediaLoader.jsp?editmode=editDataCard"/>
			<%}		
		}
    else if (request.getParameter("deleteThisCard")!=null)
		{
    	// get primary key from parameters
    	nClave=htmlServer.extendedParseInt(request.getParameter("clave"));	
		//CODE TO delete EXTENSION PARTNER OF THE DATACARD:
		woExtension.clave_ext=nClave;
		woExtension.deleteWebObject(con); 
		// delete the parent datacard object from the database
		woFicha.clave=nClave;
		// deletes the datacard
		woFicha.deleteWebObject(con);
		// removes the entry from tips - it will not show real data
		CountryTip.getInstance().remove(countrybean.countrycode);
		}
   try
		{
        // rset will be scrollable, will not show changes made by others, and read only
		try
			{
	    	pstmt=con.prepareStatement("select fichas.serial, fichas.clave "+countrybean.getWhereSql(countrybean.nApproved,sqlparams)+" order by "+countrybean.getSortbySql(),
		                            ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);

			for (int k=0; k<sqlparams.size(); k++)
						pstmt.setString(k+1, (String)sqlparams.get(k));
			rset=pstmt.executeQuery();
			}
		catch (Exception e)
			{
			System.out.println("[DI9]"+e.toString());
			}	

		if (request.getParameter("nextcard")!=null)
	   		{
			++start;
			if (rset.absolute(start))
				{
				nClave=rset.getInt("clave");
				}
			else if (rset.last())
				{
				start=rset.getRow(); 
			    nClave=rset.getInt("clave");
				}
			}
	    else if (request.getParameter("previouscard")!=null)
	   		{
			if (start>1)
		   		{
		   		start--;
		   		rset.absolute(start);
  			    nClave=rset.getInt("clave");
		   		}
			}
	    else if (request.getParameter("firstcard")!=null)
	   	 	{
			start=1;
			rset.first(); 			
    		nClave=rset.getInt("clave");
			}
	    else if (request.getParameter("lastcard")!=null)
	   		{
			rset.last(); 			
			start=rset.getRow(); 
			nClave=rset.getInt("clave");
			}
	    else if (request.getParameter("searchcard")!=null)
	   		{
			rset.absolute(start);
			boolean bMore=true;
			while (bMore)
			   {
			   nClave=rset.getInt("clave");
			   if (rset.getString("serial").equalsIgnoreCase(toSearch))
			     bMore=false;
			   else
			     {
				 bMore=rset.next();
				 start++;
				 }
			   }
			if (rset.isAfterLast())
				{
				rset.last();
				start=rset.getRow(); 
			    nClave=rset.getInt("clave");
				}
			}
	   else
	   		{ // first call to the editdata stuff. comes from the outside with start=? 
	   		if (rset.absolute(start))
				nClave=rset.getInt("clave");
			else 
				{
				try{stmt.close();} catch (Exception e){}
				dbCon.close();
	   			%><jsp:forward page="noDataCard.jsp" /><%
				}
			}		
		}
	catch (Exception e)
		{
		out.println("AN ERROR OCCURRED...<!-"+e.toString()+"-->");
		}				
    try{stmt.close();} catch (Exception e){}
	
	// gets the object from the database
	woFicha.clave=nClave;
	woFicha.getWebObject(con); 
	woExtension.clave_ext=nClave;
	woExtension.getWebObject(con); 
	out.println("<input type='hidden' name='clave' value='"+nClave+"'>");
	out.println("<input type='hidden' name='start' value='"+start+"'>");
	out.println("<input type='hidden' name='action' value='"+action+"'>");
    %>
	
<script language="JavaScript">
<!--
function  confirmDelete()
{
return confirm ("<%=countrybean.getTranslation("PleaseConfirmyouwishtodeletethisDatacard")%> - <%=countrybean.getTranslation("thisoperationcantbeundone")%>!!");
}
// -->
</script> 
<table width="620" border="0">
<tr><td align="center">
<input type="submit" value=" &lt;&lt; " name="firstcard">
<input type="submit" value=" &lt; " name="previouscard">
<input type="submit" value=" &gt; " name="nextcard">
<input type="submit" value=" &gt;&gt; " name="lastcard">
<input type="submit" value="<%=countrybean.getTranslation("Findserial")%>:" name="searchcard">
<input type="text" value='<%=toSearch%>' name="tosearch" size="15" maxlength="16">
<%
int nTarget="0"; // "ABCD";
if (action==0)
	{
	%><input type="submit" name= 'saveCard' value='<%=countrybean.getTranslation("Save")%>'  onclick=" return chkForm()">&nbsp;&nbsp;
  	  <input type="submit" name= 'addMedia' value='<%=countrybean.getTranslation("Upload media")%>'  onclick=" return chkForm()"><%
	}
else
	{
	%><input type="submit" name= 'deleteThisCard' value='<%=countrybean.getTranslation("Delete")%>' onClick=" return confirmDelete()"><%
	}%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="submit" value="<%=countrybean.getTranslation("Done")%>" name="quit">
</td></tr>
</table>

    <%@ include file="validation.jsp" %>
	<%@ include file="i_ficha.jsp" %>
	<%@ include file="addDisaggregation.jsp" %>
	<%
	
	try	{rset.close(); }catch (Exception e){out.println("<!-- closing r:"+e.toString()+" -->");}	
	try	{pstmt.close();}catch (Exception e){out.println("<!-- closing ps:"+e.toString()+" -->");}	
	dbCon.close();
	}
 %> 
</form>
</body>
</html>
