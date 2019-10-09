<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>DesConsultar on-line Download Menu</title>
</head>
<%@ page info="front page of DesConsultar On-Line" session="true" %> 
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.lared.desinventar.util.DICountry" %> 
<%@ page import="org.lared.desinventar.util.htmlServer" %>
<%@ page import="org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%-- open the default database to get basic data about the country --%>
<%@ include file="/util/opendefaultdatabase.jspf" %>
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/header",countrybean.getLanguage(),out);%>


<div class="welcomeheadder">
  <div class="navbase">
          <h4 style="margin-bottom:0; padding-top:5px;">&nbsp;Download free, open source DesInventar software and documentation</h4>
  </div>
</div>
<%
org.lared.desinventar.system.Sys.getProperties();
countrybean.init();
%>



<table width="900" cellspacing="0" cellpadding="3" border="1"  bordercolor="white" class="pageBackground">
<tr>
<td colspan=4>
<br/>
This Software has been developed by the <i><font face="" color="Red">DesInventar Project</font></i> team.<br>
<br/>
The DesInventar Server software is open-source and is free of charge for commercial and non-commercial use.
It is distributed under an "Apache-2-like" license, which is even less restrictive than  GNU and FreeBSD licenses.<br><br>
Please use it well, this software has been built and is distributed this way thinking that it can help a bit making
this planet a better place.<br>
<br>The databases posted in this site are also contributions of their own organizations; we are grateful to those governments and institutions for allowing
the public sharing of this information.<br>
<br>

Please note that we make our best effort to publish in this server the most recent data collected 
by partners and stakeholders listed in the home page.<br>
<br>
<strong>Those institutions are the rightful owners of the respective information, including all copyrights. 
It is requested that proper citation be made when quoting or reproducing this data.</strong><br>
<br> 
 Especial thanks to UNDP and the Regional Center in Bangkok, and to the Governments of Indonesia, 
the Islamic Republic of Iran, the Maldives, Jordan, Guyana, Yemen, Morocco, the states of Orissa, Tamil Nadu and NSET in Nepal, and many other stakeholders.<br>
<br>
<a href="https://www.desinventar.net/DesInventar/licenses/LICENSE.txt" alt="" border="0">Click here to view the license</a>
<br>
<br>
</td>
</tr>

<tr>
<td colspan=4>
You can choose any of the following downloads available in this page:.
<br>
<br>
</td>
</tr>

<tr class="bodydarklight">
<td><strong>Item</strong></td>
<td><strong>Description</strong></td>
<td><strong>Size MB (aprox)</strong></td>
<td><strong>&nbsp;</strong></td>
</tr>

<tr>
<td>Binaries</td>
<td>DesInventar Server 9.2.11 Windows Installer</td>
<td>60MB (aprox)</td>
<td><a href="https://www.desinventar.net/DesInventar/download/setup.exe">Download</a></td>
</tr>

<tr class="bodymedlight">
<td>Binaries</td>
<td>DesInventar Server 9.2.11 Windows Update Installer</td>
<td>20MB (aprox)</td>
<td><a href="https://www.desinventar.net/DesInventar/download/update.exe">Download</a></td>
</tr>

<tr>
<td>Source</td>
<td>DesInventar Server web application (compressed), including required libraries</td>
<td>17Mb (aprox)</td>
<td><a href="https://www.desinventar.net/DesInventar/download/DesInventar.zip">Download</a></td>
</tr>

<tr class="bodymedlight">
<td>Documentation</td>
<td>DesConsultar Server User Manual - Query/Analysis module (English)</td>
<td>3.6Mb (aprox)</td>
<td><a href="https://www.desinventar.net/DesInventar/DesConsultar-UserManual.doc">Download</a></td>
</tr>

<tr class="bodymedlight">
<td>Documentation</td>
<td>DesConsultar Server User Manual - Query/Analysis module (French)</td>
<td>3.6Mb (aprox)</td>
<td><a href="https://www.desinventar.net/DesInventar/DesConsultar-UserManual_FR.doc">Download</a></td>
</tr>


<tr>
<td>Documentation</td>
<td>DesConsultar Server User Manual - Query/Analysis module (Portuguese)</td>
<td>3.6Mb (aprox)</td>
<td><a href="https://www.desinventar.net/DesInventar/DesConsultar-UserManual-Portuguese.doc">Download</a></td>
</tr>

<tr class="bodymedlight">
<td>Documentation</td>
<td>DesConsultar Server User Manual - Query/Analysis module (Arabic)</td>
<td>3.6Mb (aprox)</td>
<td><a href="https://www.desinventar.net/DesInventar/DesConsultar-UserManual-AR.doc">Download</a></td>
</tr>

<tr>
<td>Documentation</td>
<td>DesInventar Methodology Guide (English)</td>
<td>150kb (aprox)</td>
<td><a href="https://www.desinventar.net/DesInventar/DesInventar%20Methodology.doc">Download</a></td>
</tr>


<tr class="bodymedlight">
<td>Documentation</td>
<td>DesInventar Methodology Guide (Arabic)</td>
<td>150kb (aprox)</td>
<td><a href="https://www.desinventar.net/DesInventar/DesInventar%20Methodology_AR.doc">Download</a></td>
</tr>

<tr>
<td>Documentation</td>
<td>Preliminary Analysis Methodology</td>
<td>3.57Mb (aprox)</td>
<td><a href="https://www.desinventar.net/DesInventar/DesInventar-Preliminary-Analysis.pdf">Download</a></td>
</tr>

<tr class="bodymedlight">
<td>Documentation</td>
<td>Preliminary Analysis Methodology (Arabic)</td>
<td>3.57Mb (aprox)</td>
<td><a href="https://www.desinventar.net/DesInventar/DesInventar-Preliminary-Analysis_AR.pdf">Download</a></td>
</tr>

<tr>
<td>Documentation</td>
<td>DesInventar Server User Manual (Data Entry/Admin)</td>
<td>5.3Mb (aprox)</td>
<td><a href="https://www.desinventar.net/DesInventar/DesInventar-UserManual.doc">Download</a></td>
</tr>


<tr class="bodymedlight">
<td>Documentation</td>
<td>DesInventar Server Installation Manual</td>
<td>1.03Mb (aprox)</td>
<td><a href="https://www.desinventar.net/DesInventar/DesInventar-Web-Installation.pdf">Download</a></td>
</tr>

<tr>
<td>Documentation</td>
<td>DesInventar Server User Tutorial</td>
<td>1.81Mb (aprox)</td>
<td><a href="https://www.desinventar.net/DesInventar/DesInventar-Tutorial.doc">Download</a></td>
</tr>

<tr class="bodymedlight">
<td>Documentation</td>
<td>DesInventar Server User Tutorial (Arabic)</td>
<td>1.81Mb (aprox)</td>
<td><a href="https://www.desinventar.net/DesInventar/DesInventar-Tutorial_AR.doc">Download</a></td>
</tr>

<tr>
<td>Documentation</td>
<td>DesInventar Server flyer brochure</td>
<td>4.7Mb (aprox)</td>
<td><a href="https://www.desinventar.net/DesInventar/DesInventar%20Flyer.doc">Download</a></td>
</tr>

<tr class="bodymedlight">
<td>Documentation</td>
<td>DesInventar Server flyer brochure (Arabic)</td>
<td>4.7Mb (aprox)</td>
<td><a href="https://www.desinventar.net/DesInventar/DesInventar%20Flyer_AR.doc">Download</a></td>
</tr>

</table>
<br/><br/>
<table width="400" cellspacing="1" cellpadding="2" border="1" rules="none">
		<tr class="bodydarklight">
			<th width=30>&nbsp;</td>
			<th nowrap><strong><%=countrybean.getTranslation("Download database and maps")%></strong>&nbsp;</th>
		</tr>
<%
		Statement stmt=con.createStatement();
		ResultSet rset=stmt.executeQuery("SELECT * FROM Country order by scountryname");
		String sSetDescriptors="";
		String sCountryId="";
		String sCountryName="";
		country cCountry=new country();
		boolean bLight=false;
		String sBgClass="";
		while (rset.next())
		 {
		 // same order as in query...
		 cCountry.loadWebObject(rset);
		 sCountryId=cCountry.scountryid;
		 sCountryName=cCountry.scountryname;
		 // debug: System.out.println("country:" + sCountryId+"-"+sCountryName);
	  	 boolean bPublic=cCountry.bpublic!=0;
		 // not indian or indian state databases
		 if (bPublic && !(sCountryId.equalsIgnoreCase("IND") || "012".indexOf(sCountryId.charAt(0))==0))  // OR USER HAS ACCESS!!!
			{
			 if (bLight)
				  sBgClass=" class='bodymedlight'";
				else
				  sBgClass=" class='bodylight'";
				bLight=!bLight;
			   %><tr<%=sBgClass%>>
				<td width=30>&nbsp;</td>
				<td nowrap>
				<a class="blackLinks" href="/DesInventar/download_base.jsp?countrycode=<%=sCountryId%>">
				<%=sCountryName%></a></td>
				</tr><%
			}
		 }
%>


</table>


<br>
</body>
</html>
