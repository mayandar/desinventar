<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8");%>
<%@ page info="DesInventar On-Line data entry page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="woFicha" class="org.lared.desinventar.webobject.fichas" scope="session" />
<jsp:useBean id="woExtension" class="org.lared.desinventar.webobject.extension" scope="session" />
<%
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
// checks for a session alive variable, or we have a new valid countrycode
if (countrybean.countrycode.length()==0)
	{%><jsp:forward page="/inv/index.jsp"/>
	<%}%>
<%@ include file="checkUserIsLoggedIn.jsp" %>
<%if (user.iusertype<1) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}%>
<%@ include file="/util/opendatabase.jspf" %>
<%if (request.getParameter("quit")!=null)	   	
		{
	     %><jsp:forward page="resultstab.jsp"/><%
		}
 %>
<html>
<head>
<title><%=countrybean.countryname%><%=countrybean.getTranslation("DataEntry")%></title>
</head>
<body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/iheader",countrybean.getLanguage(),out);%> 
<% 
ArrayList sqlparams=new ArrayList();
PreparedStatement pstmt=null;
int j=0;
woExtension.dbType=dbType;
woFicha.dbType=dbType;
// loads the datacard extension
woExtension.loadExtension(con,countrybean);
// get primary key from parameters
if (request.getParameter("clave")!=null)
	{
		woFicha.clave=htmlServer.extendedParseInt(request.getParameter("clave"));	
	}

int start=htmlServer.extendedParseInt(request.getParameter("start"));
String toSearch=htmlServer.not_null(request.getParameter("searchcard"));;

if (bConnectionOK)
	{
	if ((request.getParameter("saveCard")!=null) || (request.getParameter("addMedia")!=null))
		{
		// gets the object from the database
		woFicha.getForm(request, response, con);
		// send it thru its template
		woFicha.updateWebObject(con); 
		//out.println("<!-- Ficha: -->"+woFicha.lastError);
		// UPDATE EXTENSION PARTNER OF THE DATACARD:
		woExtension.clave_ext=woFicha.clave;
		int nr=woExtension.getWebObject(con); 
		woExtension.getForm(request, response, con);
		// this field is lost during getForm-its ok
		woExtension.clave_ext=woFicha.clave;
		if (nr==1)
			woExtension.updateWebObject(con); 
		else	
			woExtension.addWebObject(con); 
		// removes the entry from tips - it will not show real data
		CountryTip.getInstance().remove(countrybean.countrycode);
		}

	if (request.getParameter("addMedia")!=null)
	 	{%>
		<jsp:forward page="mediaLoader.jsp?editmode=modifydatacard"/>
		<%}		

	}
int nClave=woFicha.clave;
%>
<%@ taglib uri="inventag.tld" prefix="inv" %>
<%
{
int nTabActive=6; // 
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


<table width="1000" border="1" class="pageBackground" rules="none" height="500"><tr><td align="center" valign="top">
<form name="desinventar" method="post" action='modifydatacard.jsp'>
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 

<!-- Content goes after this comment -->
<table width="1000" border="0">
<tr><td align="center">
<font color="Blue"><%=countrybean.getTranslation("Region")%></font>
<b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b>
 - [<jsp:getProperty name ="countrybean" property="countrycode"/>]
</td>
<td align="right">
<input type="submit" value=" &lt;&lt; " name="firstcard">
<input type="submit" value=" &lt; " name="previouscard">
<input type="submit" value=" &gt; " name="nextcard">
<input type="submit" value=" &gt;&gt; " name="lastcard">
<input type="submit" value="<%=countrybean.getTranslation("Findserial")%>:" name="searchcard">
<input type="text" value='<%=toSearch%>' name="tosearch" size="15" maxlength="16">
<input type="hidden" name= 'saveCard___' value='<%=countrybean.getTranslation("Save")%>'  onclick=" return chkForm()">
<input type="submit" name= 'addMedia' value='<%=countrybean.getTranslation("Upload media")%>'  onclick=" return chkForm()">
<input type="submit" value="<%=countrybean.getTranslation("Done")%>" name="quit">
&nbsp;&nbsp;&nbsp;<strong><font color="red"><%=countrybean.getTranslation("[AUTO-SAVE mode]")%></font></strong>
</td>
</tr>
</table>


<%
if (bConnectionOK)
	{
	
	
	try{	
	   	if (request.getParameter("nextcard")!=null
	   	|| request.getParameter("previouscard")!=null
	   	|| request.getParameter("firstcard")!=null
	   	|| request.getParameter("lastcard")!=null
	   	|| request.getParameter("searchcard")!=null)
	   	{
		try
			{
	    	pstmt=con.prepareStatement("select fichas.serial, fichas.clave "+countrybean.getWhereSql(countrybean.nApproved,sqlparams)
																		    +user.sGetUserWhereSQL(countrybean.countrycode)
																			+" order by "+countrybean.getSortbySql(),
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
/*	   else
	   		{ // first call to the editdata stuff. comes from the outside with start=? 
	   		if (rset.absolute(start))
				nClave=rset.getInt("clave");
			}		
*/
	      }

		}
	catch (Exception e)
		{
		out.println("AN ERROR OCCURRED...<!-"+e.toString()+"-->");
		}				

	// gets the object from the database
	woFicha.clave=nClave;
	woFicha.getWebObject(con); 
	woExtension.clave_ext=nClave;
	woExtension.getWebObject(con); 
	out.println("<input type='hidden' name='clave' id='clave' value='"+nClave+"'>");	
	out.println("<input type='hidden' name='start' value='"+start+"'>");
	%>
    <%@ include file="validation.jsp" %>
	<%@ include file="i_ficha.jsp" %>
	<%@ include file="addDisaggregation.jsp" %>
	<%
	try	{rset.close(); }catch (Exception e){out.println("<!-- closing r:"+e.toString()+" -->");}	
	try	{pstmt.close();}catch (Exception e){out.println("<!-- closing ps:"+e.toString()+" -->");}	
	dbCon.close();
	}
 %>

<table width="1000" border="0">
<tr><td align="center">
<input type="HIDDEN" name='addCard'><br>
<input type="submit" value="<%=countrybean.getTranslation("Done")%>" name="quit">
<input type='hidden' name='start' value='<%=start%>'>
</td></tr></table>
</form>

<!-- Content goes before this comment -->
</td></tr></table>
</body>
</html>


