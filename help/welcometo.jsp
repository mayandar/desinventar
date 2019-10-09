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


<h2><center>Welcome to DesInventar</center></h2> <br>
<p>
<center><img src="E:\web\webapps\DesInventar\images\lared.gif"></center><br>

<a href="#Background"><b>BACKGROUND</b></a><br>
<a href="#Objectives">OBJECTIVES</a><br>
<a href="#Promotion Groups">PROMOTION GROUPS</a><br>
<a href="#Acknowledgements">ACKNOWLEDGEMENTS</a><br>
<a href="#About DesInventar">ABOUT DESINVETAR</a><br><br><br>



 The LatinAmerican Network of Social Studies on Disaster Prevention
(LARED) is pleased to present the 32 bits - 6.2 version of DesInventar. This being
product of the experience and effort of multiple researchers, users and of its software
development team. This version enhances the utilities and provisions of former
versions, guaranteeing the integrity and management of the available databases.</p>
<p>A diversity of users have an interest on DesInventar due to the posibility of having
and managing a homogeneous and organized record of the existing information
about disasters. It is a product that also helps to visualize the recorded phenomena
in space and time.</p>
<p>LA RED has developed this instrument to provide the diverse roleplayers in
risk management activities (researchers, research institutes, governments and
emergency and disaster attention national planning systems, regional and local
prevention bodies, aid organisms, international and bilateral agencies, so as to
organized communitites and the media) with a product for the storage, processing,
homogeneous analisis and representation of disasters, these being the adverse
effects over populations, property and infrastructure that are vulnerable to natural
and socionatural phenomena. The design and structure of DesInventar were
conceived as flexible and adaptable, which makes it applicable to diverse units
of a territorial, political-administrative, planning, environmental, management,
institutional operations character, with resolution levels that range from national to
detailed views (provinces, cities).</p>
<p>DesInventar is nowadays a methodology and an instrument used systematically in
Latin American and Caribbean countries and recently (Dec 2002) its implementation
started in India (Orissa State). DesInventar is used by research and academic
groups, cities, provinces and institutes of environmental management. More than 20
DesInventar’s databases are already in public domain in the Section called WebSite
DesInventar2.</p>

<div align="center"><a name="Background"><b><font size="+2">BACKGROUND</b></a></font></div><br>
<p>The LatinAmerican Network of Social Studies on Disaster Prevention, constituted
in 1992, formulated in its Agenda of Research and Organic Constitution (LA RED,
COMECSO/ITDG, Lima, January 1993) that:</p>
<i>The population growth and urbanizing processes, the territorial ocupation tendencies, the growing
impoverishment of important sectors of population, the use of inadequate technological systems in
the construction of houses and the providal of basic infrastructure, the inadequate organizational
systems, among others, have caused a continuous increase in the vulnerability of population to a
wide diversity of physico-natural events.</i>
<p>However, due to the absence of systematic, homogeneous and disaster type comparable
records, as well as to the absence of effects of the occurrence of threteaning events
in the frame of the vulnerability conditions in each region, country or city, on the one
hand and on the other hand, conceptions such as considering that disasters are only
the effects of those events of great extent and of big impacts, have made invisible
the thousands of small and middle disasters that annually occur in the countries of
regions like Latin America, Caribe, Asia and Africa.</p>
<p>From another point of view, there are many institutions and researchers around the
world that are interested in the subject. They use diverse tools to systematize the
information about disasters. This information being generally databases or physical
archives designed with specific criteria and very concrete or sectorial interests in unequal
formats. Additionally there is a great volume of information ready to be stored
and systematized , mainly from newspaper sources. This scattered information has
to be compiled, homogeinized and analized. It also has to be referenced geography-
cally because disasters are regionalized variables, (vulnerated communities and infrastructure)
due to the effects produced by each type of event (threat).</p>

<div align="center"><a name="objectives"><b><font size="+2">OBJECTIVES</b></a></font></div><br>
<p>A common objective in the regions and countries of Latin America and the Caribe,
Asia and Africa is that of generating abilities to analize and represent in space and
time, all the threats, vulnerabilities and risks in a retrospective and prospective way.
So that they can be used in aplications on risk management, in tasks that go from
disaster mitigation to attention and post-event recovery. The qualitative and quantitative
evaluation of vulnerability and risk growth, requires the availability of a solid
documental base and of a record of the occurred disasters as well as of the ones that
are happening daily, and of the ones that will happen.</p>
<p>As a contribution to the accomplishment of these common goals for diverse regions,
LA RED started at the end of 1993 with the project, Disaster Inventory in Latin America,
which in its pilot project stage consisted on:</p>
<p>a) Discussing and meeting conceptual and methodological criteria over the analitical
treatment of the small, middle and big disasters;</p>
<p>b) Store the information about disasters that happened in the period 1990-1994, from
available sources like Latin American countries (México, Guatemala, El Salvador,
Costa Rica, Colombia, Ecuador, Perú y Argentina) and</p>
<p>c) Develop a computer system tool for such purpose. DesInventar is a synthesis of
the process by which the research groups committed to LA RED suggest a conceptual
and methodological unified frame about disasters and the tool to achieve the
development of the proposed objectives. The basic criteria that guides DesInventar
are:</p>
<p>- All the inventories have the same variables for measuring effects, with a homogeneous
basic clasification of events.</p>
<p>- The stored and processed information is entered into the timescale and into a georeferenced
spatial level.</p>
<p>- The inventories may be treated analitically, through computer system tools, as a
basic requirement to produce comparative researches and to support the decision
taking over actions on mitigation and in general, over actions taken on risk management.
<p>DesInventar is also an instrument that helps to visualize, in space and time, the registrated
phenomena, by means of its complementary tool, the Query Module or DesConsultar.</p>

<div align="center"><font size="+2"><a name="Promotion Groups"><b>PROMOTION GROUPS</b></a></font></div><br>       
<p>DesInventar has been the result of national research groups around LA RED
in Colombia that are in charge of the coordination and software development
(OSSO-Universidad del Valle, CompuArte-PROMAP). These groups (besides
those already mentioned) are: in Peru (ITDG), in Mexico (CIESAS), Guatemala
(FLACSO-General Secretariat), El Salvador (PRISMA), Costa Rica (FLACSO,
National Emergency Commission), Ecuador (EPN) and Argentina (CENTRO).</p>

<div align="center"><font size="+2"><a name="Acknowledgements"><b>ACKNOWLEDGEMENTS</b></a></font></div><br>       
<i><p>The institutions and researchers comitted to the development of DesInventar are grateful for
the economic support from ODA- Overseas Development Administration, today DFID - Department
for International Development (United kingdom), which funds allowed to perform
diverse international workshops so as to support the efforts of each group in the adquisition
and processing of the information and in the production of the computer systems instrument
(software) and its extension to other countries. Acknowledgements also for CEPREDENAC
in Central America and the GTZ (Germany), that have made possible to extend the project
to other countries of this region and to the Caribe. To the National Emergency Commission
in Panama, that has become a user and has cooperated in the development of DesInventar,
including creative aplications in the field of emergency and disaster attention.
For the development of version 6.2 (32 bits), there has been the support of the united Nations
Program for Development PNUD and of the IAI-(inter American Institution for Global
Change Research)-LA RED project which is “Disaster risk Management in Latin America
ENSO”.</i></p>

<div align="center"><font size="+2"><a name="About DesInventar"><b>ABOUT DESINVENTAR</b></a></font></div><br>       
<p>DesInventar 6 .x. is a software development at 32 bits, based on the 5.4.1 16 bits version.
The development team is integrated by computer system engineers and development
assistants from LA RED and from OSSO, with contributions from the United
Nations Program for Development-PNUD and from the project?Disaster Risk Management
ENSO in Latin America?,having the sponsorship of the Interamerican Institution
for Global Change Research-IAI.</p>

<p><i><b>Development Team:</b></i><br>
Javier Andrés Mena<br>
Julio Cesar Serje de la Ossa<br>
Jhon Henry Caicedo<br>
Mario Andrés Yandar<br></p>

<p><i><b>Advisors:</b></i><br>
Fernando Ramírez<br>
Cristina Rosales<br>
Andrés Velásquez<br></p>

<p><i><b>Betausers:</b></i><br>
Cristina Rosales<br>
Nayibe Jiménez<br>
Claudia Yolima Quintero<br>
Wilman Rodríguez<br></p>
<br><br>
 
<img src="E:\web\webapps\DesInventar\images\up30.gif"><br><br><br>

	
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

