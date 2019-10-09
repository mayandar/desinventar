<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>DesConsultar on-line Main Menu</title>
</head>
<%@ page info="front page of DesConsultar On-Line" session="true" %> 
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.lared.desinventar.util.DICountry" %> 
<%@ page import="org.lared.desinventar.util.htmlServer" %>
<%@ page import="org.lared.desinventar.util.dbConnection" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%@ page contentType="text/html; charset=UTF-8" %><%@ page import="org.lared.desinventar.system.*" %><%
request.setCharacterEncoding("UTF-8"); 
// if this runs in an IFRAME under IE, this will allow cookies to stay...just magic!
((HttpServletResponse)response).addHeader("P3P", "CP=\"CAO PSA OUR\"");
((HttpServletResponse)response).addHeader("X-Frame-Options", "SAMEORIGIN");
%>
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/header",countrybean.getLanguage(),out);%>
<div class="welcomeheadder">
  <div class="navbase">
      <h4 style="margin-bottom:0; padding-top:5px;">&nbsp;About DesInventar [Version 9.12.8 - 2011]</h4>
  </div>
 </div>
<a href='javascript:alert(document.cookie)'>Alert cookie</a><br/>


<table width="700" cellspacing="2" cellpadding="2" border="1"  bordercolor="white" class="pageBackground bss" rules="none">
<tr>
 <td>
     <div class="maincont_rc" style="padding:14px;">	
      DesInventar is a conceptual and methodological tool for the generation of National Disaster Inventories and the construction of databases of damage, losses and in general the effects of disasters.<br />
      <br />
	  These methodologies and software has been developed by the <i><font face="" color="Red">DesInventar Project</font></i> team with support from the 
      following <font class='subtitle'> Institutions and Partners:</FONT><br />
      <br />
      <table width = '100%' border="0" cellpadding="5"  class="pageBackground bss">
        <tr>
          <td><div><a href="http://www.unisdr.org/"><IMG alt="UNDRR" border=0 height=50 src="/DesInventar/images/logo-isdr.png"></a></div></td>
          <td> UNDRR, the UNITED NATIONS OFFICE FOR DISASTER RISK REDUCTION is the host and main sponsor of the development and world-wide dissemination of DesInventar, especially in Asia, Africa and Oceania. </td>
        </tr>
        <tr>
          <td align="center"><div> <a href="http://www.undp.org/"> <img src="/DesInventar/images/undp.gif" border="0" alt="UNDP"></a> </div></td>
          <td> UNDP, the  UNITED NATIONS DEVELOPMENT PROGRAMME supports, uses in many countries and has generously funded in part the effort of DesInventar-web. UNDP has also provided its continous support spreading the ideas, methodology and tools around the world. </td>
        </tr>
        <tr>
          <td><div><a href="http://www.la-red.org/"><IMG alt="La Red" border=0  width="150" height="45" src="/DesInventar/images/lared.gif" width=50></a></div></td>
          <td> DesInventar project was initiated by LA RED, The Network of Social Studies on Disaster Prevention in Latin America. LA RED is a non-profit NGO with over 17 years of activities mainly in Latin America, the Caribbean and now Asia and Africa. </td>
        </tr>
        <tr>
          <td align="center"><div><a href="http://www.osso.org.co"><IMG alt=OSSO border=0 height=86 src="/DesInventar/images/osso.gif"></a></div></td>
          <td>Special thanks to OSSO (Corporacion Observatorio Sismol&oacute;gico del Sur Occidente), where the inception of the project took place. OSSO support has been crucial for over 12 years to let DesInventar Project reach its maturity. </td>
        </tr>
        <tr>
          <td><div> <a href="http://www.robotsearch.com/"> <img src="/DesInventar/images/robotsearch.jpg" border="0" width="140" height="35" alt="Internet Robots and Enterprise Applications"></a> </div></td>
          <td><br />
            RobotSearch Software has provided countless man-hour of development to the project as a contribution to make this planet a better place. 
            It also provides free hosting to www.desinventar.net<br />
            <br />
          </td>
        </tr>
        <tr>
          <td align="center"><a href="http://www.apache.org/"> <img src="/DesInventar/images/apache.gif" width=130 height=16 border=0 alt="Powered by Apache Web Server"><br />
            <img src="/DesInventar/images/tomcat_y.gif" width=50 height=36 border=0 alt="powered by Apache Tomcat JSP server"></a> </td>
          <td> DesInventar on-line is powered by wonderful and freely available Apache Software Foundation open source products: Apache HTTP server and Apache Tomcat (JSP/Servlet container). </td>
        </tr>
      </table>
      <br />
      <br />
	 </div>     
   </td>
 </tr>
</table>
<br>
<inv:example/>
</body>
</html>
