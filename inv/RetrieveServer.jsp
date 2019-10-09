<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8");%><%@ page import="java.io.*" %><%@ page import="java.sql.*" %><%@ page import="java.util.*" %><%@ page import="java.net.*" %><%@ page import="java.text.*" %><%@ page import="org.lared.desinventar.system.Sys" %><%@ page import="org.lared.desinventar.util.*" %><%@ page import="org.lared.desinventar.webobject.*" %><jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" /><jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" /><jsp:useBean id="woExtension" class="org.lared.desinventar.webobject.extension" scope="session" /><%@ include file="/util/opendatabase.jspf" %><%
int nClave=htmlServer.extendedParseInt(request.getParameter("key"));	
String sName=request.getParameter("field");
String sValue=request.getParameter("value");
int nClave=htmlServer.extendedParseInt(request.getParameter("key"));	
try	{
		
	// using a brand new object to have only datacard fields.
	fichas woFicha=new fichas();
	woFicha.clave=nClave;
	woFicha.getWebObject(con);
	woExtension.clave_ext=nClave;
	woExtension.getWebObject(con);
	// now produce the output for the client, with updated fields.
	out.print("%%OK%%\n");
	Object[] kSet=woFicha.asFieldNames.keySet().toArray();
	for (int j=0; j<kSet.length; j++)
		{
			sValue=(String)(woFicha.assignValue((String)kSet[j])).replace("\n","\\n");
			out.print(((String)kSet[j])+"="+sValue+"\n");
		}

	org.lared.desinventar.webobject.Dictionary dct= new org.lared.desinventar.webobject.Dictionary();
    for (int j = 0; j < woExtension.vFields.size(); j++)
	    {
	    	dct=(org.lared.desinventar.webobject.Dictionary) (woExtension.vFields.get(j));
	        sValue=(String )woExtension.assignValue(dct.nombre_campo).replace("\n","\\n");
			out.print(dct.nombre_campo+"="+sValue+"\n");
		}
	}
catch(Exception ex1)
	{
	System.out.println("[DI-10] ERROR auto-saving : "+ex1.toString());
	}
dbCon.close();
%>