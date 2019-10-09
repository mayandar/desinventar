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



<h2><center>Regions</center></h2> <br>
<p>A region in DesInventar is characterized by the database and optionally characterized
by cartography. The archives related to a same region have to be located in the
same directory. Its name indicates the database with which the user is going to work.
The operations to perform are that of openning and creating databases. To eliminate
a region inWindows environment, just eliminate the corresponding directory, only if
you are sure to do so.</p>
<p><b>Select a Region</b><br>
<center><img src="E:\web\webapps\DesInventar\images\region.gif"></center><br><br>
It allows to pick a region (database). You have to look for the directory that has the
database and the cartography of the selected region.</p>

<img src="E:\web\webapps\DesInventar\images\attention.gif">IMPORTANT : Regions are not recorded in a list anymore, only use this
option to open one region.<br><br>

<i>Example</i><br>
<p>Peru Database:<br>
The user has to create a directory for his/her region, in this case, its name could be “Peru”
. It is recommendable to have the databases organized in only one directory. On the purpose
of organizing the disaster databases, the system selects as default directory “My
Documents” and then places "DesInventar6 DB" in it. Next, you have to copy the following
archives:</p>
<p>for the database:<br>
- inventpe.mdb.<br>
If it has cartography:<br>
- pecoor.dat<br>
- pelist.dat<br>
- pearco.dat<br>
- pevent.txt<br>
- pepmap.mdb.</p>
<p>Finally you can open DesInventar or DesConsultar and select the directory “Peru” to
access its information.</p>






<br><br><br><br>
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

