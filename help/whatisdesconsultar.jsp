<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>DesConsultar on-line Help</title>
</head>
<%@ page info="DesConsultar On-Line help page: index" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/header",countrybean.getLanguage(),out);%>
<script language="javascript">
<!--// put here javascript needed 


// -->
</script>

<!-- TABS TOP -->

<table width="690" cellspacing="0" cellpadding="3" border="0">
<tr><td>
<!-- START:    Help content Area -->



<h2><center>What is DesInventar?</center></h2> <br>
<P>
DesConsultar is a analysis instrument, a tool of time/space analysis of disaster inventory
homogenically joined with DesInventar. It was designed as a supporting tool for
the understanding of the disasters, as an insert recurring in everyday relations between
the dynamics of the society and their technological advances and those of nature.
DesConsultar allows to make exhaustive and specific consultations permiting
to reveal the characteristics and effects of disasters.</p>
<p>The easyness of statistic analysis and the spacial representation of the consultations
are oriented to suggest the users some answers, and hopefully many questions, about
the dimensions of one of the most well know modern conflicts: the disasters produced
by relations SOCIETY, DEVELOPEMENT and ENVIRONMENT.</p>
<p>The following are the main uses, with which DesConsultar has been designed to
ease the observation the analysis and the understanding of the disasters be done in a
competent way:</p>
• Consultation window <br>
• Calculus sheet and production of graphics <br>
• Preparation of statistics<br>
• Expert in information (Structured Question Languaje)<br>
• Preparation of thematic maps Regions<br>
<br><br>
	
<!-- END:    Help content Area -->
</td></tr>
</table>
<form name="desinventar" method="post">
<INPUT type='hidden'  name="action"  value="">
<INPUT type='hidden'  name="frompage" value="<%=request.getServletPath()%>">
</form>
<%@ include file="/html/footer.html" %>
</body>
</html>

