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
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css" />
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/iheader",countrybean.getLanguage(),out);%>
<script language="javascript">
<!--// put here javascript needed 


// -->
</script>

<!-- TABS TOP -->
<div class="welcomeheadder">
  <div class="navbase">
      <h4 style="margin-bottom:0; padding-top:5px;">&nbsp;DesInventar Server Help - Admin Module</h4>
  </div>
 </div>
 
<table width="900"  border="0" class="pageBackground" rules="none" > 
	<tr>
		<td width="100%" valign="top" >
			<table valign="top" width="100%" align="center" border="1" bgcolor="#ffffff"  bordercolor="#6699cc" cellpadding="8" cellspacing="0" > 
				<tr>
					<td align="center" height="40"><font class="title1">Quick Instructions to access DesInventar Administration Module</font>
			
					</td>
				</tr>
				<tr>
					<td align="center" bgcolor="#6699cc" height="40"><font class="boxheader1">This section of DesInventar 
                    the database is the management instrument to  administer the entire DesInventar website. This will allow you to perform tasks that go from the general parameters of the site to entering data into one of the databases of the system. Once you enter the Admin module you will find the tabbed interface as follows;</font>
			
					</td>
				</tr>
					<tr>
					<td align="center" height="40" width="100%"><img src="/DesInventar/images/tab_inv.png">
			
					</td>
				</tr>
				<tr>
					<td align="left" ><font class="bss2">You can jump from any tab of the system to any other tab at any given time. That gives you, the user, a lot of freedom in the way you want to do your work. For example, you can specify in what database (region or country) you want in the Region tab, and then jump immediately to the Data Entry tab in order to actually enter disaster records. The tabs that compose the interface are: 
  </font>
			
					</td>
				</tr>
				
				<tr>
					<td width="100%" valign="top" bgcolor="#6699cc">
						<table width="100%" align="center" border="1" bgcolor="#ffffff"  bordercolor="#6699cc" cellpadding="5" cellspacing="0" > 
                        
   							<tr>
								<td align="center" width="20%"> <font class="title2">Region </font> </td>
								<td align="left" width="70%" ><font class="bss2">The Region window, used to determine what database is to be managed in the rest of the tabs (except Security). Always start here selecting the database you want to work. </font></td>
							</tr>
							<tr>
								<td align="center" width="20%"> <font class="title2">Geography </font> </td>
								<td align="left" width="70%" ><font class="bss2">The Geography tab will allow you to manage all geographic realted data in a given region. You will be able to define the names of your administrative levels, to manage the codes and names of each level, to associate maps to each one and other related actions.</font></td>
							</tr>
							<tr>
								<td align="center" width="20%"> <font class="title2">Events </font> </td>
								<td align="left" width="70%" ><font class="bss2">Management of the catalog of event types of each database.</font></td>
							</tr>
							<tr>
								<td align="center" width="20%"> <font class="title2">Causes </font> </td>
								<td align="left" width="70%" ><font class="bss2">Management of the catalog of Causes of each database.</font></td>
							</tr>

							<tr>
								<td align="center" width="20%"> <font class="title2">Query </font> </td>
								<td align="left" width="70%" ><font class="bss2">The Query window, used to determine what data is to be retrieved is displayed. In this screen you will be able to tell the system what is the information you want to see in terms of the dimensions described. </font></td>
							</tr>
							
							<tr>
								<td align="center" width="20%"> <font class="title2">Edit Data 
</font> </td>
								<td align="left" width="70%" ><font class="bss2">This tab will always contain the simple tabular form of the results of your query. You will be able to see here the data records that comply with the specifications given in the Query tab.  </font></td>
							</tr>
							
							<tr>
								<td align="center" width="20%"> <font class="title2">Data Entry
</font> </td>
								<td align="left" width="70%" ><font class="bss2">As it name suggest you will be able to add new disaster records, edit existing ones and delete non desired data.
                             </font></td>
							</tr>
							
							<tr>
								<td align="center" width="20%"> <font class="title2">Admin </font> </td>
								<td align="left" width="70%" ><font class="bss2">This tab provides a large number of functions to allow Administrators to add new regions or modify existing ones, as well as Importing/Exporting functions. Onwer of the system will be able to change here the global parameters of the system.</font></td>
							</tr>
							<tr>
								<td align="center" width="20%"> <font class="title2">Security </font> </td>
								<td align="left" width="70%" ><font class="bss2">This tab contains the functionality required to manage the users that can access the system, giving them priviledge levels and authorizations to specific databases.
                                </font></td>
							</tr>
							
						
						</table>
					
					</td>
				</tr>
 
				<tr>
					<td ><font class='instruction'>Note: please note that selections made from the query window apply when moving to or accessing any other tab. Also, you have to keep in mind that selection in each tab are remembered by the system. For example you may select a type of Chart (in the charts tab), jump to the query tab to modify another setting, and jump back to Charts and still find your setting there.</font> 
					</td>
				</tr>
								
			</table>
	</td>
	</tr>
    </table>
 



<table width="690" cellspacing="0" cellpadding="3" border="0">
<tr><td>
<!-- START:    Help content Area -->
<br><br>
<H3>Basic record</H3><br>
All DesInventar databases are composed of a collection of records, called "DataCards". The basic record 
contains a standard set of indicators and information about the effects of a disaster on a geographic unit.
Please refer to the Methodological Guide of DesInventar for more information.</p>
<strong>Serial record number</strong><br>
<p>This field identifies a number, an acronym or code for the record, so that it can be identified.
To enter the information, it is recomended to assign numbers in a sequential way,
although it is not compulsory. This field may also include letters, hyphens and other typefaces.
It is recommended that the number you assign corresponds to a characteristic of the
original record (for example, in paper), or that you may transcribe on it, to facilitate future
references or inspections. Observe that it is possible to have more than one record with
the same serial number, meaning that the serial numbers are NOT unique.</p>

<strong>Disaster date</strong><br>
<p>It is composed of three fields and indicates the date of occurrence of the disaster, in arabic
numbers. First the year, then the month and finally the day. The year must be written
completely, for example: 1995, 1845, etc. The letters YMD (Year,Month,Day) remind you
of the order in which to type the numbers. IMPORTANT: DesInventar doesn’t require
initial zeros for one digit months and days. If these are entered DesInventar avoids them
without affecting the consistency of the information in the database. For example, if you
type month 06, DesInventar will register only the 6.</p>

<strong>Information sources</strong><br>
<p>Indicates the source(s) of information: the means of information, the preexisting
database(s) and the entity or entities from which the information was obtained.</p>

<strong>Geography Level 0</strong><br>
<p>Its title varies depending on the names of the levels. It may be an administrative district,
state, etc..., depending on the nomenclature for each country. This is A COMPULSORY
FIELD for the entering of information to the record, because it is the minimum posible
level of georeferentiation.</p>

<strong>Geography Level 1</strong><br>
<p>Its title varies depending on the names of the levels. It may be a municipality, canton,
etc..., and it corresponds to the second clasification level or political and administrative
zonification. This field is NOT strictly compulsory but it MUST be typed when the disaster
affects only one municipality. For example, in Mexico, if this level is not typed in , the
program will asume that all the municipalities of the selected State were affected.
</p>

<strong>Geography Level 2</strong><br>
<p>Its title varies depending on the names of the levels in its country or region. It may be a
municipality, canton, etc..., and it corresponds to the third clasification level or political
and administrative zonification. This field is NOT stricly compulsory but it exists when the 
disaster affects only one  of these geographical units.</p>
<p>IF THIS FIELD IS NOT FILLED IN, DESINVENTAR WILL ASSUME THAT THE DISASTER
AFFECTED ALL THE ELEMENTS IN THIS LEVEL WHICH BELONG TO THE
PREVIOUS LEVEL. For example: Costa Rica, (Levels: Province, Canton, District), if this
level is not typed in (district), the program will assume that all the districts in the canton
chosen where affected.</p>
<strong>Event</strong><br>
<p>The type of event refers to the hazard associated with the disasters in the inventory. 
Please refer to the Methodological Guide and the User Manuals for precise definitions of these.</p>

</p>
Site<br>
<p>If the information of the site is available, it indicates where the event happened. If the site
corresponds exactly to the last geographical level of the ones reported, it is not necessary
to enter it again. Normally, in this category, the exact location where the event happened
is specified, in the municipality or geographical unit defined. It may be a town, a small
town, a police post, farm or country estate, a spot, a place, a small village, a geographical
feature, a river, etc.</p>
Cause and its description<br>
<p>Many times, in the process of development and generation of an event that ends
in a disaster, it is difficult to distinguish between the cause and effect of the same
phenomena. As a solution, each inventorying team is able to include notes about the
causality relationships of an event under the field (Observation).</p>

<b>Disaster effects</b><br>
<br>
For more information on the effects defined in Desinventar, refer to the 
Methodological Guide of DesInventar.<br>
<strong>Effects over people</strong><br>
<p>This is a group of variables that correspond to the effects over people. For each variable
enlisted it follows a text field, where the number or value for each variable has to be
indicated. In front of this frame, there is a selection box which shall be marked only when
there is knowledge of the existence of cases but their value unknown.</p>
• Dead : Number of dead people<br>
• Missing People: Number of missing people (unconfirmed deaths). <br>
• Injured/Sick: Number of people who required medical attention.<br>
• Affected People: Number of directly and indirectlyaffected people. <br>
• Destroyed Houses: Number of destroyed houses (non habitable dwellings). <br>
• Affected Houses: Number of affected houses (still habitable). <br>
• Evacuated: Number of temporarily evacuated people.<br>
• Relocated: Number of permanently relocated people.<br>
<br>
<strong>Effects over infrastructure</strong><br>
<br>
Effects over civil and services infrastructure. The selection box is marked if there were
effects in any of these items.<br>
• Transportation<br>
• Farming and livestock sector<br>
• Communications<br>
• Energy<br>
• Education<br>
• Hospital Centers: indicates the number of hospital centers affected.<br>
• Aid<br>
• Aqueduct<br>
• Sewers<br>
• Industry<br>
• Health<br>
• Others<br>
<br>
<strong>Value of Losses:</strong><br>
Value of the economic losses caused by the disaster.<br>
• Value of Losses in $: Estimated value of losses in local currency.<br>
• Value of Losses in U$: Estimated value of losses in American dolars.<br>
<br>
<strong>Magnitude</strong><br>
This is an indicative of the magnitude of the event. For more information on the scales
and conventions on magnitudes look for the Section called Methodological Guide to DesInventar.<br>
<br>
<strong>Other Losses</strong><br>
Short description of other losses caused by the disaster.<br>
<br>
<strong>Comments and Observations</strong><br>
This is a field that has a capacity of 750 characters, about 200 words.<br>
<br>
<strong>Other fields: </strong><br>
Date of record creation (which is the date when the record was created) and the identification
of the person who creates the record.<br>

<a name="#querymanagement"></a><h3>Usage of the Query Screen</h3>

<b>Events and Causes</b><br><br>
<strong>Event list</strong><br>
Appears in the query window as a box with a list that has all the defined types
of events. If you wish to make a query (or report) with one or more events,
they must be selected from this list. If NO type of event is selected, then ALL
the types of events will be considered on the enquiry (report). To select an event,
CLICK on it. If you want to un-select, click again on the event, or if you want to
un-select all the fields, CLICK on New Query. You may select and unselect multiple events with the Control Key<br><br>
<strong>Cause list</strong><br>
Corresponds to a list of the predefined causes in DesInventar. In order to choose
a cause you must CLICK on it. To unselect, click on it again. If you wish to choose
all, none has to be selected.<br><br>
<strong>EFFECTS</strong><br>
<strong>Events with specific effects</strong><br>
In order to make a more specific query you can choose some event describers,
such as: Victims, Injured, etc. Just CLICK on the white box at the left of each of
these. You may also select events which have these effects within a specific range of 
values using the two text boxes beside each effect.<br>
<br>
<strong>Events that caused effects</strong><br>
Requests may be restricted according to the interests of the user, to events that
might have affected the agricultural and livestock sectors, education, etc.. To do
this you must click once over the fields of the box named ?Events that affected?,
in the query window.<br>
<br>
Remember: If none is selected,  then all will be retrieved.<br><br>
<strong>Options and period</strong><br>
<strong>Sort order</strong>: This field refers to the order in which you wish the descriptive
fields (geography, event and cause) to appear in the Results Sheet.<br><br>
<strong>Logic of selection</strong><br><br>
This is a very useful tool when you want to make combinations of options in different ways. 
Options can be combined so that the records retrieved respond to ALL criteria (AND) or to ANY criteria (OR). 
For example in cases when you wish to consult the events where there were houses
destroyed and public services affected, you mark both describers
and pick the Conjunctive (AND) selection. When you want to get all the events that
affected the industry or where there were houses destroyed, pick the Disjunctive
selection (OR).<br><br>
<strong>Query Period</strong><br><br>
As a result of using a similar reasoning to the one used for the lists, employing
the period restricts the records that are to be extracted to a range of dates.<br>
<br>
If the Date From is not used, the dates will not be restricted, except the resulted ones of the Date To. In
this way, if only the From date is used, the extracted records will be those with
subsequent dates of the one typed. If only the Until date is used, records with
previous dates to the one typed will be extracted. If both dates are provided,
the extracted records will be those with dates between the specified period. It is
important to notice that if only the year is provided, DesInventar will assume day and month as 
the first day of the year or month (for Date From) or the last day of the year or month for Date To<br>




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

