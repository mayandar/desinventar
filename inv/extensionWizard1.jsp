<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<%@ page info="Reindex page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<%
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
%>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%@ include file="/util/opendatabase.jspf" %>
<% 
  

/******************************************************************
*  Process the request.
******************************************************************/
String sErrorMessage="";
String sQuestions=countrybean.not_null(request.getParameter("questions"));
String sQuestions_en=countrybean.not_null(request.getParameter("questions_en"));
if (request.getParameter("continue")!=null)
	{
		ExcelLoader elLoader=new ExcelLoader();
		// not needed in the unit test: 
		elLoader.initProtoMap(con, countrybean);
		elLoader.setOut(out);
		// upload all column parameter mappings to ExcelLoader instance: 
		for (Enumeration e = request.getParameterNames(); e.hasMoreElements(); )
	      {
	      String param = (String) e.nextElement();
	      if (request.getParameter(param)!=null)
		     {
			 int iVariable=countrybean.extendedParseInt(request.getParameter(param));
		     elLoader.sLoadMap.put(param, new Integer(iVariable));
			 }
	      }
		elLoader.createExtension(request, con, countrybean);
		dbCon.close();
		%><jsp:forward page='/inv/extensionManager.jsp'/><%
	}	
%>

<head>
<title>DesInventar on-line - <%=countrybean.getTranslation("Extension Wizard")%></title>
 </head>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>">
<script type="text/javascript" src="/DesInventar/html/iheader.js"></script> 


<form method="post" action="extensionWizard1.jsp" name="desinventar">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 

<table width="100%" border="1" cellpadding="1" cellspacing="0">
<tr>
<td colspan=5  valign="top" nowrap><div class="subtitle"><%=countrybean.getTranslation("Extension Wizard")%></div></td>
</tr>
<tr>
    <td height="20" <%=countrybean.getTranslation("Question")%></td>
	<td height="20" <%=countrybean.getTranslation("English")%></td>
	<td height="20" <%=countrybean.getTranslation("Variable")%></td>
	<td width='10%'><%=countrybean.getTranslation("FieldType")%></td>
	<td width='10%'><%=countrybean.getTranslation("Length")%></td>
</tr>	
<%
int kCol=0;
try{

	StringTokenizer inp = new StringTokenizer(sQuestions,"\n");
	StringTokenizer inp2 = new StringTokenizer(sQuestions_en,"\n");
	while (inp.hasMoreTokens())
 		{
		String sQuestion=inp.nextToken().trim();
		String sQuestion_en="";
		if (inp2.hasMoreTokens())
			sQuestion_en=inp2.nextToken().trim();
		if (sQuestion_en.length()==0)
			sQuestion_en=sQuestion;

		String sFieldName="";
		String sVarName=sQuestion_en.toUpperCase();

		if (sQuestion.length()>60)
			sQuestion=sQuestion.substring(0,28)+"..."+sQuestion.substring(sQuestion.length()-28,sQuestion.length());
		if (sQuestion_en.length()>60)
			sQuestion_en=sQuestion_en.substring(0,28)+"..."+sQuestion_en.substring(sQuestion_en.length()-28,sQuestion_en.length());


	    if (sQuestion.length()>2)
		{		
%>	   <tr>
            <td>
            <input type='text' size='60' maxlength='60' name='namecol<%=kCol%>' value='<%=EncodeUtil.htmlEncode(sQuestion)%>'>
		    <input type='hidden' name='chkcol<%=kCol%>' value="Y">
			</td> 
            <td>
			<input type='text' size='60' maxlength='60' name='namecol_en<%=kCol%>' value='<%=EncodeUtil.htmlEncode(sQuestion_en)%>'>
			</td> 
            <td>
<%
		String sAlpha="ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_";

		for (int i=0; i<sVarName.length();  i++)
		{
			if ( sAlpha.indexOf(sVarName.charAt(i))>=0)
				sFieldName+=sVarName.charAt(i);
			else 
				if (!sFieldName.endsWith("_"))
					sFieldName+="_";								
		}
		if (sFieldName.length()>30)
		{
			String[] sWords=sFieldName.split("_");
			int k=sWords.length-1;
			String sTail="";
			sFieldName="";
			for (int i=0; (sFieldName+sTail).length()<30 && i<k; i++, k--)
			{
				sFieldName+=(sFieldName.length()>0?"_":"");
				sFieldName+=sWords[i];
				
				sTail=(sTail.length()>0?"_":"")+sTail;
				sTail=sWords[k]+sTail;			
			}
			if ((sFieldName+sTail).length()<30)
				sFieldName+="_"+sTail;
			else 
			 sFieldName=sFieldName.substring(0,29-sTail.length())+"_"+sTail;
		}

		 

%>            
			<input type='text' size='40' maxlength='30' name='fieldname<%=kCol%>' value='<%=sFieldName%>'>
			</td> 
			<td>									     
			  <select name='field_type<%=kCol%>'  class="bss">
				 <option value=0>Text
				 <option value=1 SELECTED>Integer
				 <option value=2>Floating point
				 <option value=4>Date
				 <option value=5>Memo
				 <option value=6>Yes/No
				 <option value=7>Drop-down List
				 <option value=8>Choice
			 </select>
			 </td>
			 <td>
			 <input name='col_width<%=kCol%>' value='50' size='5' maxlength='5' class="bss">
			 </td>
	    </tr>
		    		  <%
		    kCol++;
			}
		}
	}
catch (Exception ex2)
	{
	out.println("ERROR: exception loading..="+ex2.toString());
	}
%>
<input type='hidden' name='maxcols' value='<%=kCol%>'>

<tr>
  <td colspan=2 align="center">
  	<input type="button" value='<%=countrybean.getTranslation("Back")%>' onClick="history.back()">
    &nbsp; &nbsp; &nbsp; &nbsp;
	<INPUT type='submit' size='50' maxlength='50' name='continue'  VALUE='<%=countrybean.getTranslation("Continue")%>'> 
  	&nbsp; &nbsp; &nbsp; &nbsp;
	<input name="cancelField" type=button value='<%=countrybean.getTranslation("Cancel")%>' onClick="postTo('extendedManager.jsp')">
  </td>
  <td colspan=2 align="right" class='bss'><%=countrybean.getTranslation("Length")%>: <%=countrybean.getTranslation("AppliedonlytoTEXT")%></td>
</tr>
</form>
</table>
</body>
</html>
<% dbCon.close(); %>

