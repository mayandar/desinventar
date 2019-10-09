<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<% String sPath=request.getParameter("currentPath");
boolean bIEBrowser = (request.getHeader("User-Agent").indexOf("MSIE")>0);
boolean bIEdge = (request.getHeader("User-Agent").indexOf("Edge")>0);
String sExtension="";
if (request.getParameter("extension")!=null)
   sExtension=request.getParameter("extension");
if(sExtension.length()==0)
  sExtension=".mdb";
%>

<html>
<head>
	<title><%=countrybean.getTranslation("SelectFile")%> (*<%=sExtension%>)</title></head>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class="bodyclass"  bgcolor="#C9C8A9"  onload="resizeDlg()" dir="<%=countrybean.getTranslation("ltr")%>">
<iframe width="600" height="400" id="browserFrame" src="/DesInventar/inv/browsefile.jsp?currentPath=<%=sPath%>&extension=<%=sExtension%>"></iframe>
<script language="JavaScript">
function resizeDlg(){
    var idW=600;
	var idH=400;
	<% if (bIEBrowser) { %>
	idW = document.body.clientWidth; 
	idH = document.body.clientHeight; 
	<% } else { %>
	idH = window.outerHeight-90; 
	idW = window.outerWidth; 
	<% } %>
document.getElementById("browserFrame").height=idH;
document.getElementById("browserFrame").width=idW;
}
window.onresize = resizeDlg;

function cancelPath()
	{
	this.close();	
	//	window.close();
    }

</script>
</body>
</html>
