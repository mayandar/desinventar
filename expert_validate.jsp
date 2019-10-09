<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<%@ page info="DesConsultar Expert validator" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%@ include file="/util/opendatabase.jspf" %>
<%@ include file="/paramprocessor.jspf" %>
</head>
<body>
<script language="JavaScript">
function main_submit()
{
  document.desinventar.submit();
}
</script>

SQL Validation page<br>
<%	
	response.setHeader("Pragma", "no-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);

String sSql, sSqlCopy;
int j=0;
// blanks the expert where in the bean
String sExpertTranslation=request.getParameter("sExpertWhere");
if (sExpertTranslation!=null)
	{
	stmt=con.createStatement();
	String sExpertWhere=Parser.translateExpertExpression(sExpertTranslation, Parser.hmVarUntrans);
	boolean bFormula=countrybean.not_null(request.getParameter("formula")).length()>0;
	if (bFormula)
		sSql="select "+sExpertWhere+" "+countrybean.getWhereSql()+" AND (clave=-1) ";
	else
		sSql="select * "+countrybean.getWhereSql()+" AND (clave=-1) and("+sExpertWhere+")";
	try
		{
		rset=stmt.executeQuery(sSql); 
		rset.close();
		%>
		<script language="JavaScript">
		parent.document.desinventar.valid.value=true;
		
		alert('<%=countrybean.getTranslation("SQL OK")%>');
		</script>
	<%	}
	catch (Exception err)
		{%>
		<script language="JavaScript">
		parent.document.desinventar.valid.value=false;
		alert("ERROR: <%=err.toString()%> ");
		alert("formula: <%=request.getParameter("formula")%> ");
		alert("<%=sSql%>");
		</script>
	<%	}
	stmt.close();
	}
dbCon.close();
%>
<form name="desinventar" action="expert_validate.jsp" method="post">
<input type="text" name="sExpertWhere" size="60" value=""/>	 
<input type="text" name="formula" size="60" value="<%=request.getParameter("formula")%>"/>	 
<input type="submit" name="submitter" value="submit"/>	 
<input type="button" name="tst" value="submit test" onClick="main_submit()"/>	 
</form>
</body>
</html>
