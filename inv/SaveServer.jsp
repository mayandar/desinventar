<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8");%><%@ page import="java.io.*" %><%@ page import="java.sql.*" %><%@ page import="java.util.*" %><%@ page import="java.net.*" %><%@ page import="java.text.*" %><%@ page import="org.lared.desinventar.system.Sys" %><%@ page import="org.lared.desinventar.util.*" %><%@ page import="org.lared.desinventar.webobject.*" %><jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" /><jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" /><jsp:useBean id="woExtension" class="org.lared.desinventar.webobject.extension" scope="session" /><%@ include file="/util/opendatabase.jspf" %><%

// expire this page so it will always retrieve data, especially when saving clave...
response.setHeader("Pragma", "no-cache");
response.setHeader("Cache-Control", "no-cache");
response.setDateHeader("Expires", 0);

int nClave=htmlServer.extendedParseInt(request.getParameter("key"));	

String sName=request.getParameter("field");
String sValue=request.getParameter("value");
String sQuery=request.getQueryString();
int posF=0;

try	{
		
	// using a brand new object to have only datacard fields.
	fichas woFicha=new fichas();
	woFicha.clave=nClave;
	woFicha.getWebObject(con);
	woExtension.clave_ext=nClave;
	woExtension.getWebObject(con);
	
	while (sQuery.length()>0)
		{
		// key=41134&field=muertos&value=3&field=hay_muertos&value=-1	
		// get next fieldname
		sQuery=sQuery.substring(sQuery.indexOf("&field=")+7);
		sName=sQuery.substring(0,sQuery.indexOf("&value="));
		
		// get next value
		sQuery=sQuery.substring(sQuery.indexOf("&value=")+7);
		// see if this is the last value or there are more...
		posF=sQuery.indexOf("&field=");
		if (posF==-1)
			{
			sValue=sQuery;
			sQuery="";
			}
		else
			{
			sValue=sQuery.substring(0,posF);
			sQuery=sQuery.substring(posF);
			}
		if (sValue.length()>0)
		  sValue=URLDecoder.decode(sValue, "UTF-8");
		
		// HTML encodes both strings							
		sName=woFicha.not_null_safe(sName);
		sValue=woFicha.not_null_safe(sValue);
									
		// tries putting the pair in  both fichas and extension - as we don't know where it belongs to...
		if (woFicha.asFieldNames.get(sName)!=null)
			{
			woFicha.asFieldNames.put(sName,sValue);
			}
		
		// using the bean to avoid loading the dictionary, which could be slow. 	
		woExtension.clave_ext=nClave;
		if (woExtension.asFieldNames.get(sName)!=null)
			{
			// puts the pair in  both fichas and extension - as we don't know where it belongs to...
			woExtension.asFieldNames.put(sName,sValue);
			}
		//		System.out.println("[DI10] pair: "+sName+"="+sValue); //+" query:"+sQuery);	
		//*/
		}
		
	// reverse lookup of members
	woFicha.updateMembersFromHashTable();	
	woFicha.updateWebObject(con);
	woExtension.updateMembersFromHashTable();	
	woExtension.updateWebObject(con);
		
	// now produce the output for the client, with updated fields.
	out.print("%%OK%%\n");
	Object[] kSet=woFicha.asFieldNames.keySet().toArray();
	for (int j=0; j<kSet.length; j++)
		{
		sValue=(String)(woFicha.assignValue((String)kSet[j]));
		out.print(((String)kSet[j])+"="+sValue+"\n");
		}

	org.lared.desinventar.webobject.Dictionary dct= new org.lared.desinventar.webobject.Dictionary();
    for (int j = 0; j < woExtension.vFields.size(); j++)
	    {
		dct=(org.lared.desinventar.webobject.Dictionary) (woExtension.vFields.get(j));
		sValue=(String )woExtension.assignValue(dct.nombre_campo);
		out.print(dct.nombre_campo+"="+sValue+"\n");
		}
	}
catch(Exception ex1)
	{
	System.out.println("[DI-10] ERROR auto-saving : "+ex1.toString());
	}
dbCon.close();
%>
