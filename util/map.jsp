<html>
<%@ page info="DesConsultar simple results page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.util.DICountry" %>
<%@ page import="org.lared.desinventar.util.htmlServer" %>
<%@ page import="org.lared.desinventar.webobject.fichas" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:setProperty name="countrybean" property="*" />
<%@ include file="/spanish/html/header.html" %>

<table width="580" border="0">
<tr><td align="center">
<IMG height=6 src="/DesInventar/images/r.jpg" width=580><br>
<font color="Blue">Región: </font><font class='regionlink'>
<b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font>
 - [<jsp:getProperty name ="countrybean" property="countrycode"/>]
</td></tr>
<tr><td><font color="red" size="3">Generated Map:</font></td></tr>
</table>

<%
String pname="";
String[] pval;
String imgparams="?";
String comma="";
java.util.Enumeration e= request.getParameterNames();
for ( ; e.hasMoreElements() ;)
	 {
         pname=(String) e.nextElement();
         pval=request.getParameterValues(pname);
		 for (int j=0; j<pval.length; j++)
		 	{
			imgparams+=comma+pname+"="+pval[j];
			comma="&";
			}
     }
//	countrybean.loadVectors(request);
%>


<img src='/DesInventar/MapServer<%=imgparams %>' border=0><br>




<!-- <br>Total Memory=<%=Runtime.getRuntime().totalMemory()%>
Free Memory=<%=Runtime.getRuntime().freeMemory()  %><br> -->


<%@ include file="/spanish/html/footer.html" %>
</body>
</html>
