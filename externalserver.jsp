<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "https://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="https://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>External Server Query</title>
</head>
<%
String sParameters="http://online.desinventar.org/desinventar/";
Enumeration e;
String sRequestParams ="";
String sSep="?";
for (e = request.getParameterNames(); e.hasMoreElements(); )
    {
      String param = (String) e.nextElement();
	  String value=request.getParameter(param);
	  if (null==value)
	    value="";
      sParameters+=sSep+param+"="+value;
	  sSep="&";
    }
%>
<frameset rows="70,100%">
  <frame src="/DesInventar/html/header_external.html" />
  <frame src="<%=sParameters%>" />
</frameset><noframes></noframes>


<body>
</body>
</html>
