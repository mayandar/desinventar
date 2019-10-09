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



<h2><center><font color="#333333">Basic Records</font></center></h2> <br>



<a href="#description"><b><font size="-2" color="#333333">DESCRIPTION</font></b></a><br>
<a href="#record search"><font size="-2" color="#333333">RECORD SEARCH</font></a><br>
<a href="#printing the record"><font size="-2" color="#333333">PRINTING THE RECORD</font></a><br>
<br><br>






The basic record is a format for the entering and querying of information on a disaster.
Look for the Section called Methodological Guide to DesInventar for more information.</p>

<p><div align="center"><a name="description"><b><font size="+1" color="#333333">Description</b></a></font></div><br>
Event selection and localization in space and time.</b><br><br>
<center><img src="E:\web\webapps\DesInventar\images\event_selection.gif"></center><br>




<table width="900" height="800" cellspacing="0" cellpadding="5" border="0">
<tr>
	<td colspan="8">serial record number</td>
</tr>
<tr>
	<td rowspan="1" colspan="1"></td>
	<td colspan="6">This field identifies a number, an acronym or code for the record, so that it can be identified.
                    To enter the information, it is recomended to assign numbers in a sequential way,
                    although it is not compulsory. This field may also include letters, hyphens and other typefaces.
                    It is recommended that the number you assign corresponds to a characteristic of the
                   original record (for example, in paper), or that you may transcribe on it, to facilitate future
                   references or inspections. Observe that it is possible to have more than one record with
                   the same serial number, meaning that the serial numbers are NOT unique.</td>
</tr>
<tr>
	<td colspan="8">Disaster date</td>
</tr>
<tr>
    <td rowspan="1" colspan="1"></td>
	<td colspan="7">It is composed of three fields and indicates the date of occurrence of the disaster, in arabic
                    numbers. First the year, then the month and finally the day. The year must be written
                    completely, for example: 1995, 1845, etc. The letters YMD (Year,Month,Day) remind you
                    of the order in which to type the numbers. IMPORTANT: DesInventar doesn’t require
                    initial zeros for one digit months and days. If these are entered DesInventar avoids them
                   without affecting the consistency of the information in the database. For example, if you
                   type month 06, DesInventar will register only the 6.	</td>
</tr>
<tr>
	<td colspan="8">information source</td>
</tr>
<tr>
    <td rowspan="1" colspan="1"></td>
	<td colspan="7">Indicates the source(s) of information: the means of information, the preexisting
                    database(s) and the entity or entities from which the information was obtained.	</td>
</tr>
<tr>
	<td colspan="8">geography level 0</td>
</tr>
<tr>
	<td rowspan="5" colspan="1"></td>
	<td colspan="7">Its title varies depending on the names of the levels. It may be an administrative district,
                    state, etc..., depending on the nomenclature for each country. This is A COMPULSORY
                    FIELD for the entering of information to the record, because it is the minimum posible
                    level of georeferentiation.
	</td>
</tr>
<tr>
	
	<td colspan="7"><i>Mode of use:</i> This is a multiple freechoice list. It can be used in several ways:
	</td>
</tr>
<tr>
		<td colspan="7">-With the up-key down-key arrows: you can vary the selection;
	</td>
</tr>
<tr>
	
	<td colspan="7">-With the first letter of each option: If there is more than one option for the same initial
                     letter, this has to be pressed repeatedly until the one under search appears;
	</td>
</tr>
<tr>
	
	<td colspan="7">-With the cursor: The list opens by CLICKING on the down-key arrow at the right of the
                     list. If it contains more elements than the ones displayed, a scroll bar appears so that all
                     the options may be seen. You can select or un-select an option by just CLICKING on it.
	</td>
</tr>

<tr>
	<td colspan="8">Geography Level 1</td>
</tr>

<tr>
	<td rowspan="4" colspan="1"></td>
	<td colspan="7">Its title varies depending on the names of the levels. It may be a municipality, canton,
                    etc..., and it corresponds to the second clasification level or political and administrative
                    zonification. This field is NOT strictly compulsory but it MUST be typed when the disaster
                    affects only one municipality. For example, in Mexico, if this level is not typed in , the
                    program will asume that all the municipalities of the selected State were affected.
	</td>
					
                    Mode of use: This is a multiple freechoice list. It can be used in several ways:
		</td>
</tr>
<tr>
    <td colspan="7">With the up-key down-key arrows: you can vary the selection;</td>
</tr>
<tr>
    <td colspan="4">-With the first letter of each option: If there is more than one option for the same initial
                     letter, this has to be pressed repeatedly until the one under search appears;</td>
</tr>
<tr>
    <td colspan="4">-With the cursor: By making a CLICK on the down-key arrow at the right of the list, this
                     one opens. If the list contains more elements than the ones displayed, a scroll bar appears
                     so that all the options may be seen. You can select or un-select an option by just making a
                     CLICK on it.
	 </td>
</tr>

	
	
<tr>
	<td colspan="8">Geography Level 2</td>
</tr>
<tr>
	<td rowspan="5" colspan="1"></td>
	<td colspan="7"> Its title varies depending on the names of the levels in its country or region. It may be a
                     municipality, canton, etc..., and it corresponds to the third clasification level or political
                     and administrative zonification. This field is NOT stricly compulsory but it MUST be
                     typed when the disaster affects only one municipality.IF THIS FIELD IS NOT FILLED IN, DESINVENTAR WILL ASSUME THAT THE DISASTER
                     AFFECTED ALL THE ELEMENTS IN THIS LEVEL WHICH BELONG TO THE PREVIOUS LEVEL. For example: Costa Rica, (Levels: Province, Canton, District), if this
                     level is not typed in (district), the program will assume that all the districts in the canton
                     chosen where affected.
	</td>
</tr>
<tr>
	<td colspan="7">Mode of use: This is a multiple freechoice list. It can be used in several ways:</td>
</tr>
<tr>
	<td colspan="7">-With the up-key down-key arrows: you can vary the selection;</td>
</tr>
<tr>
	<td colspan="7">-With the first letter of each option: If there is more than one option for the same initial
                    letter, this has to be pressed repeatedly until the one under search appears;</td>
</tr>
<tr>
	<td colspan="7">-With the cursor: By making a CLICK on the down-key arrow at the right of the list, this
                    one opens. If the list contains more elements than the ones displayed, a scroll bar appears
                    so that all the options may be seen. You can select or un-select an option by just making a
                    CLICK on it.</td>
</tr>

<tr>
	<td colspan="8">Event</td>
</tr>
<tr>
	<td rowspan="5" colspan="1"></td>
	<td colspan="7">Select the type of event, as indicated on what follows, that refers to the disaster that you
                    are inventorying.</td>
</tr>
<tr>
	<td colspan="7">Mode of use: This is a multiple freechoice list. It can be used in several ways:</td>
</tr>

<tr>
    	<td colspan="7">-With the up-key down-key arrows: you can vary the selection;</td>
</tr>
<tr>
	<td colspan="7">-With the first letter of each option: If there is more than one option for the same initial
                    letter, this has to be pressed repeatedly until the one under search appears;</td>
</tr>
<tr>
	<td colspan="7">-With the cursor: By making a CLICK on the down-key arrow at the right of the list, this
                    one opens. If the list contains more elements than the ones displayed, a scroll bar appears
                    so that all the options may be seen. You can select or un-select an option by just making a
                    CLICK on it.</td>
</tr>


<tr>
	<td colspan="8">Site</td>
</tr>

<tr>
	<td rowspan="5" colspan="1"></td>
	<td colspan="7">If the information of the site is available, it indicates where the event happened. If the site
                    corresponds exactly to the last geographical level of the ones reported, it is not necessary
                    to enter it again. Normally, in this category, the exact location where the event happened
                    is specified, in the municipality or geographical unit defined. It may be a town, a small
                    town, a police post, farm or country estate, a spot, a place, a small village, a geographical
                    feature, a river, etc.
                    </td>
</tr>
<tr>
	<td colspan="7"></td>
</tr>
<tr>
	<td colspan="7"><strong>Selection of the cause and its description</strong></td>
</tr>
<tr>
	<td colspan="7"><img src="E:\web\webapps\DesInventar\images\selection_cause.gif"></td>
</tr>
<tr>
	<td colspan="7">Many times, in the process of development and generation of an event that ends
                    in a disaster, it is difficult to distinguish between the cause and effect of the same
                    phenomena. As a solution, each inventorying team is able to include notes about the
                    causality relationships of an event under the field (Observation).
    </td>
</tr>

<tr>
	<td colspan="8">Cause</td>
</tr>

<tr>
	<td rowspan="4" colspan="1"></td>
	<td colspan="7">As indicated on what follows, it refers to the type of cause of the disaster being inventored.
                    Mode of use: This is a multiple freechoice list. It can be used in several ways:
	</td>
</tr>
<tr>
	<td colspan="7">-With the up-key down-key arrows: you can vary the selection;
	</td>
</tr>				
<tr>
	<td colspan="7">-With the first letter of each option: If there is more than one option for the same initial
                     letter, this has to be pressed repeatedly until the one under search appears;
	</td>
</tr>
<tr>
	<td colspan="7">-With the cursor: By making a CLICK on the down-key arrow at the right of the list, this
                    one opens. If the list contains more elements than the ones displayed, a scroll bar appears
                    so that all the options may be seen. You may select or un-select an option by just making
                    a CLICK on it.
    </td>
</tr>

<tr>
	<td colspan="8">Description of the cause</td>
</tr>
<tr>
	<td rowspan="5" colspan="1"></td>
	<td colspan="7">This is a field where you can indicate if you wish, more information about the selected cause.
    </td>
</tr>
<tr>
	<td colspan="7"></td>
</tr>
<tr>
	<td colspan="7"><strong>Disaster_effects</strong></td>
</tr>
<tr>
	<td colspan="7"><img src="E:\web\webapps\DesInventar\images\disaster_effects.gif"></td>
</tr>
<tr>
	<td colspan="7">For more information on the effects defined in Desinventar, look for the Section called
                    Methodological Guide to DesInventar.
</td>
</tr>

<tr>
	<td colspan="8">Effects over people</td>
</tr>
<tr>
	<td rowspan="10" colspan="1"></td>
	<td colspan="7">This is a group of variables that correspond to the effects over people. For each variable
                    enlisted it follows a text field, where the number or value for each variable has to be
                   indicated. In front of this frame, there is a selection box which shall be marked only when
                   there is knowledge of the existence of cases but their value unknown.
	</td>			   
<tr>
	<td colspan="7"></td>
</tr>
<tr>
	<td colspan="7">• Dead : Number of dead people - there are dead people 
	</td>
</tr>				   
<tr>
	<td colspan="7">• Missing People: Number of missing people- there are missing people 
	</td>
</tr>				   
<tr>
	<td colspan="7">• Injured/Sick: Number of injured people- there are injured people.
	</td>
</tr>				   
<tr>
	<td colspan="7">• Affected People: Number of affected people- there are affected people.
	</td>
</tr>				   
<tr>
	<td colspan="7">• Destroyed Houses: Number of destroyed houses-there are destroyed houses.</td>
</tr>				   
	<td colspan="7">• Affected Houses: Number of affected houses- there are number of affected houses.
	</td>
</tr>				   
<tr>
	<td colspan="7">• Evacuated: Number of evacuated people- there are evacuated people.
	</td>
</tr>				   
<tr>
	<td colspan="7">• Relocated: Number of relocated people-there are relocated people.
	</td>
</tr>				   
<tr>
	<td colspan="7"></td>
</tr>
<tr>
	<td colspan="8">Effects over infrastructure</td>
</tr>
<tr>
	<td rowspan="15" colspan="1"></td>
	<td colspan="7"></td>
</tr>
<tr>
	<td colspan="7">Effects over civil and services infrastructure. The selection box is marked if there were
                    effects in any of these items.</td>
</tr>
<tr>
	<td colspan="7"></td>
</tr>

<tr>
	<td colspan="7">• Transportation</td>
</tr>

<tr>
	<td colspan="7">• Farming and livestock sector</td>
</tr>

<tr>
	<td colspan="7">• Communications</td>
</tr>

<tr>
	<td colspan="7">• Energy</td>
</tr>

<tr>
	<td colspan="7">• Education<br></td>
</tr>

<tr>
	<td colspan="7">• Hospital Centers: indicates the number of hospital centers affected.</td>
</tr>

<tr>
	<td colspan="7">• Aid</td>
</tr>

<tr>
	<td colspan="7">• Aqueduct</td>
</tr>

<tr>
	<td colspan="7">• Sewers</td>
</tr>

<tr>
	<td colspan="7">• Industry</td>
</tr>

<tr>
	<td colspan="7">• Health</td>
</tr>

<tr>
	<td colspan="7">• Others</td>
</tr>
<tr>
	<td colspan="8">Value of LossesMonetary</td>
</tr>
<tr>
	<td rowspan="4" colspan="1"></td>
	<td colspan="7">Value of the losses caused by the disaster.</td>
</tr>
<tr>
	<td colspan="7"></td>
</tr>
<tr>
	<td colspan="7">• Value of Losses in $: Estimated value of losses in local currency.</td>
</tr>
<tr>
	<td colspan="7">• Value of Losses in U$: Estimated value of losses in American dolars.</td>
</tr>	
<tr>
	<td colspan="8">Magnitude</td>
</tr>
<tr>
	<td rowspan="2" colspan="1"></td>
	<td colspan="7"></td>
</tr>	
<tr>
	<td colspan="7">This is an indicative of the magnitude of the event. For more information on the scales
                    and conventions on magnitudes look for the Section called Methodological Guide to DesInventar.
	</td>
</tr>					
<tr>
	<td colspan="8">Other Losses</td>
</tr>
<tr>
	<td rowspan="2" colspan="1"></td>
	<td colspan="7">Short description of other losses caused by the disaster.</td>
</tr>	
<tr>
	<td colspan="7">Short description of other losses caused by the disaster.</td>
</tr>
	
<tr>
	<td colspan="8"><strong>Information Menu</strong></td>
</tr>
<tr>
	<td rowspan="6" colspan="1"></td>
	<td colspan="7"></td>
</tr>	

<tr>
	<td colspan="7"><img src="E:\web\webapps\DesInventar\images\information_menu.gif"></td>
</tr>	
<tr>
	<td colspan="7">Date of record creation (which is the date when the record was created) and the identification
                    of the person who creates the record.
    </td>
</tr>
<tr>
	<td colspan="7">Scroll bar for records. For more information on this option go to the Section called
                    Record Search.
    </td>
</tr>	
<tr>
	<td colspan="7">Access to extended record.
	</td>
</tr>

<tr>
	<td colspan="7"><div align="center"><a name="Record Search"><h2><font color="#333333">Record Search </font></h2></A> </div>.
	</td>
</tr>
<tr>
	<td rowspan="10" colspan="1"></td>
	<td colspan="7">There are several ways of making the query:</td>
</tr>
<tr>
	<td colspan="7">• Using the SEARCH option and entering the record Number or Serial</td>
</tr>
<tr>
	<td colspan="7"><img src="E:\web\webapps\DesInventar\images\record_search.gif"></td>
</tr>
<tr>
	<td colspan="7">• By means of the location and retrieval of records, in the lower right part of the
                    format. If you want to mark a particular record press the ’tack’&nbsp;<img src="E:\web\webapps\DesInventar\images\tack.gif"> o that you may
                    continue searching. If you want to go back to the marked record press the ’arrow’&nbsp;<img src="E:\web\webapps\DesInventar\images\arrow.gif">
	</td>
</tr>
<tr>
	<td colspan="7"><img src="E:\web\webapps\DesInventar\images\extention.gif"></td>
</tr>
<tr>
	<td colspan="7">• With this option records are passed over sequentially according to the order in
                    which they were entered. You can go to the first record or to the last one or go
                    through them forwards or backwards in groups of 20 records .&nbsp;<img src="E:\web\webapps\DesInventar\images\records.gif">
    </td>
</tr>
<tr>
<td colspan="7"></td>
</tr>
<tr>
<td colspan="7">.</td>
</tr>

<tr>
	<td colspan="7"><div align="center"><a name="printing the record"><b><font size="+1" color="#333333">PRINTING THE RECORD</b></a></font></div><br>
	</td>
</tr>
<tr>
	<td rowspan="3" colspan="1"></td>
	<td colspan="7"></td>
</tr>
<tr>
	<td colspan="7"><img src="E:\web\webapps\DesInventar\images\printing_record.gif" width="436" height="319"></td>
</tr>
<tr>
	<td colspan="7">• This option allows to print the content of a record. By pressing it the system will
                      display the print dialog of your operative system. You can select the printer to use
                      and the amount of pages to be printed.Printing the record
                     This option allows to print the content of a record. By pressing it the system will
                     display the print dialog of your operative system. You can select the printer to use
                     and the amount of pages to be printed.
	</td>
</tr>
</table>



</table>


<br><br><br><br><br>
	
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

