<%@ page info="DesConsultar generator results page" session="true" %><%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import="org.lared.desinventar.util.*" %><%@ page import="org.lared.desinventar.webobject.*" %><jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" /><%@ include file="/util/opendatabase.jspf" %><%@ include file="/paramprocessor.jspf" %>
<%@page pageEncoding="UTF-8"%><%! 
String fieldFormatter(String sField, int nColumn, int nFormat, String sExtra)
{
String sRet=sField;
switch (nFormat)
	{
	case 0:sRet=sField+"\t";
		break;
	case 1:sRet="<"+sExtra+nColumn+">"+EncodeUtil.xmlEncode(sField)+"</"+sExtra+nColumn+">";
		break;
	case 2:sRet=sField+"\t";
		break;
	}
return sRet;
}

String rightAdjust(String sField, int lon)
{
if (sField.length()>=lon)
	return sField;
return "                              ".substring(0,lon-sField.length())+sField;
}
%><%
String sFormat=countrybean.not_null(request.getParameter("format"));
int nFormat=0; // CSV
if ("XML".equalsIgnoreCase(sFormat))
   nFormat=1;
else if ("TXT".equalsIgnoreCase(sFormat))
   nFormat=2;
String sTime=String.valueOf(Calendar.getInstance().get(Calendar.MINUTE)*100+Calendar.getInstance().get(Calendar.SECOND)+Calendar.getInstance().get(Calendar.HOUR)*10000);
  
switch (nFormat)
	{
	case 0:	response.setContentType("application/vnd.ms-excel");
			response.addHeader("Content-Disposition", "attachment;filename=\"DI_report"+sTime+".xls\"");
		break;
	case 1:	response.setContentType("text/xml");
			response.addHeader("Content-Disposition", "attachment;filename=\"DI_export"+sTime+".xml\"");
		out.println("<?xml version=\"1.0\"?>");
		out.println("<DESINVENTAR_XML_REPORT>");
		out.println("<FIELDS>");
		break;
	case 2:	response.setContentType("text/plain");
		break;
	}
extension woExtension=new extension();
woExtension.dbType=countrybean.dbType;
woExtension.loadExtension(con,countrybean);

ArrayList sqlparams=new ArrayList();
PreparedStatement pstmt=null;
String sSql, sSqlCopy;
int j=0;
sSql=countrybean.getSql(true,sqlparams);
out.print(fieldFormatter(countrybean.getTranslation("Serial"),0,nFormat,"NAME"));

try
	{
	pstmt=con.prepareStatement(sSql);
	for (int k=0; k<sqlparams.size(); k++)
				pstmt.setString(k+1, (String)sqlparams.get(k));
	rset=pstmt.executeQuery();
	}
catch (Exception e)
	{
	System.out.println("[DI9]"+e.toString());
	}	

for (j=0; j< countrybean.asVariables.length; j++)
 		{
		sSql=countrybean.sExtractVariable(countrybean.asVariables[j]);
		// output here header of date column.!!! 
		if (sSql.equals("fichas.fechano,fichas.fechames,fichas.fechadia"))
		   out.print(fieldFormatter(countrybean.getTranslation("Date"),j+1,nFormat,"NAME"));
		else out.print(fieldFormatter(countrybean.getVartitle(countrybean.asVariables[j]),j+1,nFormat,"NAME"));
	}
out.println("");
if (nFormat==1)
	{
	out.println("</FIELDS>");
	out.println("<RECORDS>");
	}
// ALL ROWS!!!
while (rset.next())
  try
	{
	if (nFormat==1)
		out.print("<ROW>");
	String sSerial="";
	try{sSerial=htmlServer.not_null(rset.getString("fichas.serial"));}
		catch (Exception nser)
		  {
			try{sSerial=htmlServer.not_null(rset.getString("serial"));}
			catch (Exception nser2){} 
		  } 

	if (nFormat==0)
		out.print(fieldFormatter("\""+sSerial+"\"",0,nFormat,"F"));  // forces to alpha
	else
		out.print(fieldFormatter(sSerial,0,nFormat,"F"));

	for (j=0; j<countrybean.asVariables.length; j++)
	  try
		{
		String sRealVar="C0L__"+j;
		sSql=countrybean.sExtractVariable(countrybean.asVariables[j]);
		if (sSql.equals("fichas.fechano,fichas.fechames,fichas.fechadia"))
			   out.print(fieldFormatter(countrybean.sFormatDate(rset.getString("fechano"),
			       											  rset.getString("fechames"),
                   											  rset.getString(sRealVar)),j+1,nFormat,"F"));
		else					
		 if (sSql.startsWith("extension."))
			 	{
				   out.print(fieldFormatter(woExtension.getValue(sSql.substring(10),htmlServer.not_null(rset.getString(sRealVar))),j+1,nFormat,"F"));
				}
            else{
			 out.print(fieldFormatter(htmlServer.not_null(rset.getString(sRealVar)),j+1,nFormat,"F"));
			 }
		}
	 catch (Exception colnotfound)
	    {
			   out.println("!-- Not found:"+sSql+" --");
		}	
	if (nFormat==1)
		out.print("</ROW>");
   	out.println("");
	}
 catch (Exception ex)
    {
   	out.println("!-- Exception found:"+ex.toString()+" --");
	}	
if (nFormat==1)
	{
	out.println("</RECORDS>");
	out.println("</DESINVENTAR_XML_REPORT>");
	}
try	{rset.close(); }catch (Exception e){out.println("<!-- closing r:"+e.toString()+" -->");}	
try	{pstmt.close();}catch (Exception e){out.println("<!-- closing ps:"+e.toString()+" -->");}	
dbCon.close();
%>
