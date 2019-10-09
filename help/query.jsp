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

<table width="690" border="0">
<tr><td align="center"><font color="Blue">Region: </font><font class='regionlink'>
<b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font>
 - [<jsp:getProperty name ="countrybean" property="countrycode"/>]
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
 <span class="subTitle">Query Definition</span>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
 <a href='/DesInventar/index.jsp' class='linkText'>Switch to Other Region</a>
</td></tr>
</table>
<table width="690" cellspacing="0" cellpadding="3" border="0">
<tr><td>
<!-- START:    Help content Area -->



<h2><center>Query Management</center></h2> <br>

<a href="#query window"><b><font size="-2" color="#333333">QUERY WINDOW</font></b></a><br>
<a href="#map window"><font size="-2" color="#333333">MAP WINDOW</font></a><br>
<a href="#thematical map"><font size="-2" color="#333333">THEMATICAL MAP</font></a><br>
<a href="#generator"><font size="-2" color="#333333">GENERATOR</font></a><br>
<a href="#expert query"><font size="-2" color="#333333">THE EXPERT'S QUERY</font></a><br>
<a href="#statistics"><font size="-2" color="#333333">STATISTICS</font></a><br>
<a href="#query option"><font size="-2" color="#333333">QUERY OPTION</font></a><br>
<br><br>

<table width="900" height="800" cellspacing="0" cellpadding="5" border="0">
<tr>
	<td colspan="8"><strong>Query Management</strong></td>
</tr>
<tr>
	<td rowspan="7" colspan="1">41</td>
	<td colspan="7"><a name="query window"><strong><font size="+1" color="#333333"><div align="center">QUERY WINDOW</div></font></strong></a></td>
</tr>
<tr>
	<td colspan="7">The query window allows you to to select several criteria to visualize the results.</td>
</tr>
<tr>
	<td colspan="7"><strong><em>SPATIAL LOCATION</em></strong></td>
</tr>
<tr>
	<td colspan="7"><img src="E:\web\webapps\DesInventar\images\event_selection.gif"></td>
</tr>

<tr>
	<td colspan="7">This field has three lists (two, if only two geographical levels have been defined) that are used to select the regions from which you want to obtain information. Like in the events list, 
                    if nothing is selected from one of the lists, what you are saying is that you need all the regions in that level. If there are no selected regions in level 0, records
                    from all the regions will be extracted. If regions from the list of level 0 are selected but leave the level 1 list empty (that is, not selecting anything over it), all the records
                    of disasters that occurred in the selected regions of level 0 will be extracted. Notice that the level 1 and 2 lists appear initially empty. These lists are filled only if there has	
                    been a selection of the previous level. For example, having selected the Guanajuato State, the corresponding municipalities that belong to the mentioned state appeared in level 1 in the displayed screen.</td>
</tr>
<tr>
	<td colspan="7"><strong><em>EVENTS AND CAUSES</em></strong></td>
</tr>
<tr>
	<td colspan="7"><img src="E:\web\webapps\DesInventar\images\events_causes.gif"></td>
</tr>
<tr>
	<td colspan="8">Event</td>
</tr>
<tr>
	<td rowspan="1" colspan="1"></td>
	<td colspan="1">Appears in the query window as a box with a list that has all the defined types
                    of events. If you wish to make a enquiry (or report) with one or more events,
                    they must be selected from this list. If NO type of event is selected, then ALL
                    the types of events will be considered on the enquiry (report). To select an event,
                    CLICK on it. If you want to un-select, click again on the event, or if you want to
                    un-select all the fields, CLICK on New Query.</td>
</tr>
<tr>
	<td colspan="8">Cause</td>
</tr>
<tr>
	<td rowspan="3" colspan="1"></td>
	<td colspan="7">Corresponds to a list of the predefined causes in DesInventar. In order to choose
                    a cause you must CLICK on it. To unselect, click on it again. If you wish to choose
                    all, none has to be selected.</td>
</tr>

<tr>
    <td colspan="7">EFFECTS </td>
</tr>
<tr>		
	<td colspan="7"><img src="E:\web\webapps\DesInventar\images\effects.gif"></td>	
</tr>

<tr>
	<td colspan="8">Events with specific effects</td>
</tr>
<tr>
    <td rowspan="1" colspan="1"></td>
	<td colspan="7">In order to make a more specific query you can choose some event describers,
                    such as: Victims, Injured, etc. Just CLICK on the white box at the left of each of
                    these.</td>
</tr>
<tr>
	<td colspan="8">Events that caused effects</td>
</tr>
<tr>
	<td rowspan="4" colspan="1"></td>
	<td colspan="7">Requests may be restricted according to the interests of the user, to events that
                    might have affected the agricultural and livestock sectors, education, etc.. To do
                    this you must click once over the fields of the box named ?Events that affected?,
                    in the query window.<br>
                    Remember: If no selected none, are selected all.</td>
</tr>					
<tr>
	<td colspan="7"><strong>Options and period</strong></td>
</tr>

<tr>
	<td colspan="7"><img src="E:\web\webapps\DesInventar\images\options_period.gif"></td>
</tr>
<tr>
	<td colspan="7">Ordering (the records). This field refers to the order in which you wish the descriptive
                    fields (geography, event and cause) to appear in the Query Sheet. You just have to
                    CLICK on one of them.</td>
</tr>
<tr>
	<td colspan="8">Type of selection</td>
</tr>
<tr>
	<td rowspan="1" colspan="1"></td>
	<td colspan="7">This is a very useful tool when you want to make a more exhaustive query, for
                    example in cases when you wish to consult the events where there were houses
                    destroyed and public services affected. <br>It is then when you mark both describers
                    and pick the Conjunctive selection. When you want to get all the events that
                    affected the industry or where there were houses destroyed, pick the Disjunctive
                    selection.</td>
</tr>
<tr>
	<td colspan="8">Enquiry period</td>
</tr>
<tr>
	<td rowspan="10" colspan="1"></td>
	<td colspan="7">As a result of using a similar reasoning to the one used for the lists, employing
                    the period limits the records that are to be extracted. If the date From is not used,
                    the dates will not be restricted, except the resulted ones of the date Until. In
                    this way, if only the From date is used, the extracted records will be those with
                    subsequent dates of the one typed. If only the Until date is used, records with
                    previous dates to the one typed will be extracted. If both dates are provided,
                   the extracted records will be those with dates between the specified period. It is
                   important to notice that if the year is provided, the day and month have to be
                   provided too. If it is not done this way , the first day of January will be assumed
                   for day and month. This as it might be seen is particularly important for the
                   Until date. Notice that if only the year is given, records from PAST YEARS will
                  be extracted.</td>
</tr>	
<tr>
    <td colspan="7"><a name="map window"><strong><font size="+1" color="#333333"><div align="center">MAP WINDOW</div></font></strong></a></td>
</tr>	
<tr>
    <td colspan="7"><img src="E:\web\webapps\DesInventar\images\map_window.gif"></td>
</tr>		
<tr>
    <td colspan="7">DesConsultar is equipped with skills to manage very simple maps of the regions
                    under study. These maps have three purposes:</td>
</tr>	
<tr>
    <td colspan="7">• That the user may be illustrated on the shape and placement of the different zones
                      that constitute the division used (usually the political and administrative division).</td>
</tr>
<tr>
    <td colspan="7"> • Serve as a tool for the selection of specific zones from which you wish to obtain
                       information. This application is particularily useful when the user doesn’t have a
                       practical knowledge of the zone under study.</td>
</tr>
<tr>
   <td colspan="7">• Serve as an initial matrix for the production of thematical maps. For more information
                     see the Section called Results: Thematic Maps.</td>
</tr>		
<tr>
    <td colspan="7"><img src="E:\web\webapps\DesInventar\images\map_window2.gif"></td>
</tr>	
<tr>
    <td colspan="7"><strong>Enlarge</strong></td>
</tr>	
<tr>
    <td colspan="7"><img src="E:\web\webapps\DesInventar\images\enlarge.gif">When this option is chosen, the cursor changes its aspect turning into a
                    cross, this has the purpose of easily pointing the area that you want to see in more
                    detail. As soon as it is activated, the cursor turns into a view (cross), indicating that
                    the process of enlarging has begun. There are two methods to enlarge a portion of the
                     map:</td>
</tr>	
				   
<tr>
	<td colspan="8">Simple Method</td>
</tr>
<tr>
	<td rowspan="1" colspan="1"></td>
	<td colspan="7">You must click on the center of the zone you wish to enlarge. The program will
                    make a 25% enlargement around the point where the click was made.</td>
</tr>		
<tr>
	<td colspan="8">Extended Method</td>
</tr>
<tr>
	<td rowspan="19" colspan="1"></td>
	<td colspan="7">With this method the user may specify the rectangular area that is for being
                    enlarged. You should place yourself on one of the corners of the rectangle that
                    you are going to enlarge, press the mouse button and WITHOUT UNPRESSING
                    IT, take it to the other corner of the rectangle. While you take the mouse to the
                    other corner, you will see how the rectangle being defined shows.</td>
</tr>	
<tr>
    <td colspan="7"><strong>Un-Enlarge</strong></td>
</tr>	
<tr>
    <td colspan="7"><img src="E:\web\webapps\DesInventar\images\un_enlarge.gif">This option returns 
	                the map to its original view.</td>
</tr>	
<tr>
    <td colspan="7"><strong>See_Names</strong></td>
</tr
<tr>
    <td colspan="7"><img src="E:\web\webapps\DesInventar\images\see_names.gif">Displays the names of the geographical areas instead of their centroids or
                    their codes. Depending on the density of the geographical units (or political and administrative),
                    an unreadable map could be produced due to superposition of names,
                    in these cases it is possible to make an enlargement.</td>
</tr>
<tr>
    <td colspan="7"><strong>See_Codes</strong></td>
</tr
<tr>
    <td colspan="7"><img src="E:\web\webapps\DesInventar\images\see_codes.gif">Displays the codes of each one of the geographical units, instead of their
                    centroids or their names. Depending on the density of the geographical units (or
                    political and administrative). An unreadable map could be produced , due to code
                    superposition, in this cases it is preferable to make a previous enlargement.		</td>
</tr>
<tr>
    <td colspan="7"><strong>See centroids	</strong></td>
</tr>
<tr>
    <td colspan="7"><img src="E:\web\webapps\DesInventar\images\see_centroids.gif">Displays the centroids of the geographical areas, instead of their names or
                    codes. It is ideal for cases in which the geographical units (or political and administrative)
                    form a very dense pattern.</td>
</tr>	
<tr>
    <td colspan="7"><strong>Go to Queries	</strong></td>
</tr>
<tr>
    <td colspan="7"><img src="E:\web\webapps\DesInventar\images\go_queries.gif">This option allows to deactivate the query map and go back to the main
                    screen of Desconsultar. See the Section called Query Management.	</td>
</tr>	
<tr>
    <td colspan="7"><strong>Save</strong></td>
</tr>	
<tr>
    <td colspan="7"><img src="E:\web\webapps\DesInventar\images\save.gif">Allows to save the map as a BMP image archive. </td>
</tr>	
<tr>
    <td colspan="7"><strong>Copy	</strong></td>
</tr>
<tr>
    <td colspan="7"><img src="E:\web\webapps\DesInventar\images\copy.gif">When this option is called, whether it is from the Main Menu, or from the
                    tool bar, a copy of the content of the MapWindow is taken to the clipboard.</td>
</tr>
<tr>
    <td colspan="7"><strong>Print</strong></td>
</tr>
<tr>
    <td colspan="7">This option allows to send the currently-on-the-screen map to be printed.	</td>
</tr>	
<tr>
    <td colspan="7"><a name="thematical map"><strong><font size="+1" color="#333333"><div align="center">THEMATICAL MAP</div></font></strong></a></td>
</tr>
<tr>
    <td colspan="7"><img src="E:\web\webapps\DesInventar\images\thematical_map.gif"></td>
</tr>
<tr>
	<td colspan="8">Display Level</td>
</tr>
    <tr>
	<td rowspan="1" colspan="1"></td>
	<td colspan="7">: Draws the contour of the selected level..</td>
</tr>
<tr>
	<td colspan="8">Representation Level:</td>
</tr>	
<tr>
    <tr>
	<td rowspan="33" colspan="1"></td>
    <td colspan="7">Paints the selected level with the color that corresponds to the contained information.</td>
</tr>	
<tr>
    <td colspan="7"><img src="E:\web\webapps\DesInventar\images\map_generation.gif"></td>
</tr>
<tr>
    <td colspan="7">If you want to personalize the query options look for the Section called The Expert’s</td>
</tr>

<tr>
	<td colspan="7"><a name="generator"><b><font size="+1" color="#333333"><div align="center">GENERATOR</div></font></b></a></td>
</tr>
<tr>
    <td colspan="7"><img src="E:\web\webapps\DesInventar\images\generator2.gif"></td>
</tr>
<tr>
	<td colspan="7">It allows to choose and order the fields that you want to visualize in the report.</td>
</tr>
<tr>
    <td colspan="7"><img src="E:\web\webapps\DesInventar\images\report_generator.gif"></td>
</tr>
<tr>
    <td colspan="7">Query results are found in the Section called See data</td>
</tr>
<tr>
    <td colspan="7"><a name="expert query"><strong><font size="+1" color="#333333"><div align="center">EXPERT QUERY</div></font></strong></a></td>
</tr>
<tr>
    <td colspan="7"><img src="E:\web\webapps\DesInventar\images\query_expert.gif"</td>
</tr>
<tr>
    <td colspan="7">The expert buttons are really gates towards the universal language of databases
                   queries. The SQL is an acronym (English) meaning ?Structured Query Language?.
                   This area has to be manipulated by people with some experience in databases and
                   familiarized with these concepts. The variables appear in the lower part; to use
                   them, locate the variable and double click on it; for operators, just click once to
                   assemble the query. By clicking on OK there has to appear on screen something
                   similar to what is supposed to be the result of the query. In case of any error,
                   read carefully to find out the error it refers to. Keep in mind the parenthesis that
                   correspond and make sure the proper instructions of the SQL are correct (where,
                    order by) so as the spaces to be correctly separating the sentences.</td>
</tr>
<tr>
    <td colspan="7"><img src="E:\web\webapps\DesInventar\images\advanced_statistics.gif"</td>
</tr>
<tr>
    <td colspan="7">The results of the expert query are accessible in the Section called See data.The results of the expert query are accessible in the Section called See data.</td>
</tr>
<tr>
    <td colspan="7"><strong>List of Variables</strong></td>
</tr>
<tr>
    <td colspan="7">List of variables of the basic record and the extended record.</td>
</tr>
<tr>
    <td colspan="7"><strong>Operators</strong></td>
</tr>
<tr>
    <td colspan="7">Selection of the operators for each selected variable. You may choose the operator
                     depending on the type of information of the field to be used.</td>
</tr>
<tr>
    <td colspan="7"><a name="statistics"><strong><font size="+1" color="#333333"><div align="center">STATISTICS</div></font></strong></a></td>
</tr>
<tr>
    <td colspan="7"><img src="E:\web\webapps\DesInventar\images\statistics2.gif"</td>
</tr>
<tr>
    <td colspan="7"><strong>Totalizing levels</strong></td>
</tr>

<tr>
    <td colspan="7">They correspond to three lists with the characteristics of the query previously
                   performed, including the fields Date, Cause, Event, Geographic Level, etc. The
                   fields of each level are self excluding, for example by choosing MUNICIPALITY
                   in the first one and YEAR in the second, these will remain excluded from the
                   third level of totalization. CLICK on continue to visualize the statistic results in
                   the Section called Statistical Results.</td>
</tr>
<tr>
    <td colspan="7"><img src="E:\web\webapps\DesInventar\images\generation_statistics.gif"</td>
</tr>
<tr>
    <td colspan="7">From this section you can go to the Section called The Expert’s Query to indicate other
                   selection criteria.</td>
</tr>
<tr>
    <td colspan="7"><a name="query option"><strong><font size="+1" color="#333333"><div align="center">QUERY OPTION</DIV></font></strong></a></td>
</tr>
<tr>
    <td colspan="7"><img src="E:\web\webapps\DesInventar\images\query_options.gif"</td>
</tr>
<tr>
    <td colspan="7">The query options allow to save and retrieve the specific fields of a query made over
                    a particular database. These queries are only valid for the database from which they
                     have been generated.</td>
</tr>

<tr>
    <td colspan="7"><strong>New</strong></td>
</tr>
<tr>
    <td colspan="7">Erases the selected query options to make a new query.
     </td>
</tr>
<tr>
    <td colspan="7"><strong>Save</strong></td>
</tr>
<tr>
    <td colspan="7">
The query window<br>
• The selected events<br>
• The selected geographical zones (in its three levels)<br>
• The selected causes<br>
• The specified dates<br>
• The required effects<br>
• The affected sectors<br>
• The order<br>
• The type of logical union (Conjunction-Disjunction)<br>
             </td>
</tr>
<tr>
    <td colspan="7">The Thematical Map Generator<br>
• The texts and titles<br>
• The selected variable<br>
• The range, limits and short texts used in the thematical maps section.<br>
• The type of convention and other options.<br>
</td>
</tr>
<tr>
    <td colspan="7">Load </td>
</tr>
<tr>
    <td colspan="7">Asks the user for the path of the origin of the archive(extension.con). Shows the delimited
                     fields according to the query being viewed.<br>
                     With this button the user is able to do the inverse of the last operation exposed. Will
                     be able to recuperate the status of his/her selections in the query window, and the
                     titles, variables and ranges and short text used in the section of thematical maps that
                     existed before the query was saved.</td>
</tr>

					
							
</table>






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

