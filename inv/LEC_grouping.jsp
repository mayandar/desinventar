<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<title>DesInventar on-line - Economic Valuation Utility</title>
</head>
<%@ page import = "org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.webobject.users" %>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.io.*" %>

<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id = "Dictionary" class="org.lared.desinventar.webobject.diccionario" scope="session" />
<jsp:useBean id="woFicha" class="org.lared.desinventar.webobject.fichas" scope="session" />
<jsp:useBean id="woExtension" class="org.lared.desinventar.webobject.extension" scope="session" />

<%@ taglib uri="inventag.tld" prefix="inv" %>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%if (user.iusertype<20) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}%> 
<%@ include file="/util/opendatabase.jspf" %>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
 
 <script language="JavaScript">
<!--
function bSomethingSelected()
{
with (document.desinventar)
	{
	// alert ("Total value="+dVarValues);	 
	}	
return true;
}

// -->
</script>


<% 
int nSqlResult =0;
String sErrorMessage="";

// CAPRA Categories are fixed and hard coded in this iteration. In a future version this module should be expanded to
// allow users to define their own categories or to use the (also future) event hierarchy
// the advantage of fixed categories is the possibility of pre-suggesting categories given most databases have
// more or less standard English event names

// first: set literature defaults...
int Earthquake=2; 
int EQ_Landslide=1;  
int Hydromet=5;  
int HM_Landslide=5;  
int Landslide=5;  
int Volcanic=2;  
int Other=1;

int nGroupingMode=0;  		//default see select below
int nGroupingByDuration=1;  // default, groups taking into account the duration

// second:  if there is a set of values saved for this country, load them
String sGroupingFileName=countrybean.country.sjetfilename+"/event_grouping_"+countrybean.countrycode+".txt";
BufferedReader in=null; 
String sLine="";
try {
	File f=new File(sGroupingFileName);
	if (f.exists() && f.isFile() && f.canRead())
		{
		// open input file
		in = new BufferedReader(new FileReader(sGroupingFileName));
		//System.out.println("Loading LEC parameter file "+sInputFileName);
		sLine = in.readLine(); // This should be the Version (V.1.0), ignored for now
		sLine = in.readLine(); // Grouping mode
		nGroupingMode=webObject.extendedParseInt(sLine.substring(sLine.indexOf("=")+1));		
		sLine = in.readLine(); // Grouping by duration too
		nGroupingByDuration=webObject.extendedParseInt(sLine.substring(sLine.indexOf("=")+1));		

		sLine = in.readLine(); // optional parameter (future use)
		sLine = in.readLine(); // optional parameter (future use)


		sLine = in.readLine(); // Category Variable
		Earthquake=webObject.extendedParseInt(sLine.substring(sLine.indexOf("=")+1));		
		sLine = in.readLine(); // Category Variable
		EQ_Landslide=webObject.extendedParseInt(sLine.substring(sLine.indexOf("=")+1));		
		sLine = in.readLine(); // Category Variable
		Hydromet=webObject.extendedParseInt(sLine.substring(sLine.indexOf("=")+1));		
		sLine = in.readLine(); // Category Variable
		HM_Landslide=webObject.extendedParseInt(sLine.substring(sLine.indexOf("=")+1));		
		sLine = in.readLine(); // Category Variable
		Landslide=webObject.extendedParseInt(sLine.substring(sLine.indexOf("=")+1));		
		sLine = in.readLine(); // Category Variable
		Volcanic=webObject.extendedParseInt(sLine.substring(sLine.indexOf("=")+1));		
		sLine = in.readLine(); // Category Variable
		Other=webObject.extendedParseInt(sLine.substring(sLine.indexOf("=")+1));
		}
	}
	catch (Exception ioe)
	{
		System.out.println("[DI9]: Error loading LEC unit loss parameter file " + sGroupingFileName);
		
	}
	finally{
		try {in.close();} catch (Exception ioe2){};
	}
	        
// Third: get from the page User defined values that override previous 
if (request.getParameter("nGroupingMode")!=null) nGroupingMode=webObject.extendedParseInt(request.getParameter("nGroupingMode"));
if (request.getParameter("nGroupingByDuration")!=null) nGroupingByDuration=webObject.extendedParseInt(request.getParameter("nGroupingByDuration"));

if (request.getParameter("Earthquake")!=null) Earthquake=webObject.extendedParseInt(request.getParameter("Earthquake"));
if (request.getParameter("EQ_Landslide")!=null) EQ_Landslide=webObject.extendedParseInt(request.getParameter("EQ_Landslide"));
if (request.getParameter("Hydromet")!=null) Hydromet=webObject.extendedParseInt(request.getParameter("Hydromet"));
if (request.getParameter("HM_Landslide")!=null) HM_Landslide=webObject.extendedParseInt(request.getParameter("HM_Landslide"));
if (request.getParameter("Landslide")!=null) Landslide=webObject.extendedParseInt(request.getParameter("Landslide"));
if (request.getParameter("Volcanic")!=null) Volcanic=webObject.extendedParseInt(request.getParameter("Volcanic" ));
if (request.getParameter("Other")!=null) Other=webObject.extendedParseInt(request.getParameter("Other"));

// always save the parameters
if (request.getParameter("save_LEC_Grouping")!=null || 
	request.getParameter("execute_LEC_Grouping")!=null ||
	request.getParameter("remove_LEC_Grouping")!=null)
   {	
        // System.out.println("Generating parameter file " + outputFilename);
		PrintWriter out_file = null;
		try{
			out_file = new PrintWriter(new FileOutputStream(sGroupingFileName));
			out_file.println("V.1.0");
			out_file.println("GroupingMode="+	nGroupingMode  );
			out_file.println("GroupingByDuration="+	nGroupingByDuration);
			out_file.println("OptionalParam="+0);
			out_file.println("OptionalParam="+0);
			out_file.println("Earthquake="+	Earthquake  );
			out_file.println("EQ_Landslide="+	EQ_Landslide);
			out_file.println("Hydromet="+	Hydromet);
			out_file.println("HM_Landslide="+	HM_Landslide);
			out_file.println("Landslide="+	Landslide);
			out_file.println("Volcanic="+	Volcanic);
			out_file.println("Other="+Other);
		}
        catch (Exception ioe)
        {
    		System.out.println("[DI9]: Error generating LEC unit loss parameter file " + sGroupingFileName);
        	
        }
        finally{
        	try {out_file.close();} catch (Exception ioe2){};
        }	
	   // saving event by event grouping criteria...
	   String[] asEvents=request.getParameterValues("events");
	   String[] asCats=request.getParameterValues("category");
	   String[] asIntervals=request.getParameterValues("interval");
	   event_grouping egGroup=new event_grouping();
	   for (int j=0; j<asEvents.length; j++)
	   	{
			egGroup.nombre=asEvents[j];
			egGroup.lec_grouping_days=egGroup.extendedParseInt(asIntervals[j]);
			egGroup.category=asCats[j];
			int nr=egGroup.updateWebObject(con);  // will always work...
			if (nr<1)
				egGroup.addWebObject(con);     // will fail if it exists...
		}
	   
   if (request.getParameter("execute_LEC_Grouping")!=null)
		   {
		   LEC_util_aglutination grouper=new LEC_util_aglutination();
		   grouper.setParameters(nGroupingMode,  nGroupingByDuration);
		   grouper.generate_aglutination(countrybean,  con);
		   }
   if (request.getParameter("remove_LEC_Grouping")!=null)
		   {
		   }
   }
 else
   {
   }  
%>
   

<FORM name="desinventar" method="post" action="LEC_grouping.jsp">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<table cellspacing="0" cellpadding="0" border="0" width="100%">
<tr>
  <td width=50>&nbsp;</td>
  <td>
	<table cellspacing="0" cellpadding="5" border="0" width="100%" rules="none">
	<tr>
        <td><font color="Blue"><%=countrybean.getTranslation("Region")%> </font><b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font> - [<jsp:getProperty name ="countrybean" property="countrycode"/>]
		</td>
	    <td height="25" class='bgDark' align="left"><br/>
        <span class="title"><%=countrybean.getTranslation("L.E.C. Event Grouping Utility")%></span>
        </td>
	</tr>
	<tr><td colspan="2" height="5"></td></tr>
	<TR>
	<TD colspan=2 align="center"><span class="warning"><%=sErrorMessage%></span></TD>
	</TR>
	<tr><td colspan="2" height="5"></td></tr>
	<tr><td colspan="2" align="center">
	<input type="submit" name="save_LEC_Grouping" value="<%=countrybean.getTranslation("Save Parameters")%>">
	<input type="submit" name="execute_LEC_Grouping" value="<%=countrybean.getTranslation("Generate Grouping id's")%>" onClick="return bSomethingSelected()">
	<input type="submit" name="remove_LEC_Grouping" value="<%=countrybean.getTranslation("Remove Grouping id's")%>" onClick="return bSomethingSelected()">   
    <input name="doneButton" type=button value='<%=countrybean.getTranslation("Done")%>' onClick="window.location='adminManager.jsp'">
	</td></tr>
	<tr><td colspan="2" height="15"></td></tr>
	<tr><td colspan="2" align="center" nowrap>
	<%=countrybean.getTranslation("Grouping method:")%> <select name="nGroupingMode">
       <option value="0"<%=webObject.strSelected(0,nGroupingMode)%>><%=countrybean.getTranslation("By Category")%></option>
       <option value="1"<%=webObject.strSelected(1,nGroupingMode)%>><%=countrybean.getTranslation("By Event")%></option>
       </select>
    &nbsp;&nbsp;&nbsp;&nbsp;
    <%=countrybean.getTranslation("Take into account event duration:")%>&nbsp;<input type="checkbox" name="nGroupingByDuration" value="1"<%=webObject.strChecked(1,nGroupingByDuration)%>>    
	</td></tr>


	<tr><td colspan="2" height="25"></td></tr>
    	<table width="90%" border="1" cellspacing="0" cellpadding="0" class="bs">
          <tr bgcolor="#CCCCCC">
            <th>Cause</th>
            <th>Category of the Event</th>
            <th align="center">Interval of time [days]</th>
          </tr>
          <tr>
            <td>Earthquake</td>
            <td>Earthquake</td>
            <td align="center"><input type="text" size="3" maxlength="3" name="Earthquake" value="<%=Earthquake%>"></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>EQ/Landslide</td>
            <td align="center"><input type="text" size="3" maxlength="3" name="EQ_Landslide" value="<%=EQ_Landslide  %>"></td>
          </tr>
          <tr>
            <td>Hydro-meteorological</td>
            <td>Hydro-meteorological</td>
            <td align="center"><input type="text" size="3" maxlength="3" name="Hydromet" value="<%=Hydromet%>"></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>HM/Landslide</td>
            <td align="center"><input type="text" size="3" maxlength="3" name="HM_Landslide" value="<%=HM_Landslide%>"></td>
          </tr>
          <tr>
            <td>[no trigger specified]</td>
            <td>Landslide</td>
            <td align="center"><input type="text" size="3" maxlength="3" name="Landslide" value="<%=Landslide%>"></td>
          </tr>
          <tr>
            <td>Volcanic</td>
            <td>Volcanic</td>
            <td align="center"><input type="text" size="3" maxlength="3" name="Volcanic" value="<%=Volcanic%>"></td>
          </tr>
          <tr>
            <td>Other events</td>
            <td>Other events</td>
            <td align="center"><input type="text" size="3" maxlength="3" name="Other" value="<%=Other%>"></td>
          </tr>
        </table>
     
	<tr><td colspan="2" height="5"></td></tr>
	<tr><td colspan="2" align="center">
	<input type="button" name="apply_LEC_Grouping" value="<%=countrybean.getTranslation("Apply intervals to events below")%>" onClick="applyIntervals()">
	</td></tr>
	<tr><td colspan="2" height="25"></td></tr>
   	<tr><td colspan="2" align="center">
    	<table width="90%" border="1" cellspacing="0" cellpadding="0" class="bs">
          <tr bgcolor="#CCCCCC">
            <th>Event</th>
            <th>Event(English)</th>
            <th>Category of the Event</th>
            <th>Interval</th>
          </tr>
<% 
		HashMap hmEventCats=new HashMap();		
		hmEventCats.put("FLOOD","Hydromet");
		hmEventCats.put("FLOODS","Hydromet");
		hmEventCats.put("LANDSLIDE","HM_Landslide");
		hmEventCats.put("ALLUVION","HM_Landslide");
		hmEventCats.put("FLASH FLOOD","Hydromet");
		hmEventCats.put("FLASHFLOOD","Hydromet");
		hmEventCats.put("RAINS","Hydromet");
		hmEventCats.put("WINDSTORM","Hydromet");
		hmEventCats.put("WIND STORM","Hydromet");
		hmEventCats.put("SNOWSTORM","Hydromet");
		hmEventCats.put("SNOW STORM","Hydromet");
		hmEventCats.put("STRONG WIND","Hydromet");
		hmEventCats.put("STORM","Hydromet");
		hmEventCats.put("SURGE","Hydromet");
		hmEventCats.put("HIGH TIDE","Hydromet");
		hmEventCats.put("COASTAL","Hydromet");
		hmEventCats.put("COASTAL FLOOD","Hydromet");
		hmEventCats.put("EARTHQUAKE","Earthquake");
		hmEventCats.put("CYCLONE","Hydromet");
		hmEventCats.put("HURRICANE","Hydromet");
		hmEventCats.put("TYPHOON","Hydromet");
		hmEventCats.put("SEDIMENTATION","HM_Landslide");
		hmEventCats.put("FROST","Hydromet");
		hmEventCats.put("HAILSTORM","Hydromet");
		hmEventCats.put("HAIL STORM","Hydromet");
		hmEventCats.put("DROUGHT","Hydromet");
		hmEventCats.put("COASTLINE","Other");
		hmEventCats.put("COASTAL EROSION","Other");
		hmEventCats.put("MUDSLIDE","HM_Landslide");
		hmEventCats.put("AVALANCHE","HM_Landslide");
		hmEventCats.put("TSUNAMI","Earthquake");
		hmEventCats.put("LIQUEFACTION","Earthquake");
		hmEventCats.put("SUBSIDENCE","Earthquake");
		hmEventCats.put("FIRE","Other");
		hmEventCats.put("FOREST FIRE","Other");
		hmEventCats.put("EXPLOSION","Other");
		hmEventCats.put("LEAK","Other");
		hmEventCats.put("STRUCTURE","Other");
		hmEventCats.put("STRUCTURAL COLLAPSE","Other");
		hmEventCats.put("PANIC","Other");
		hmEventCats.put("EPIDEMIC","Other");
		hmEventCats.put("PLAGUE","Other");
		hmEventCats.put("POLLUTION","Other");
		hmEventCats.put("ACCIDENT","Other");
		hmEventCats.put("OTHER","Other");
		hmEventCats.put("BIOLOGICAL","Other");
		hmEventCats.put("ERUPTION","Volcanic");
		hmEventCats.put("VOLCANO","Volcanic");
		hmEventCats.put("CONTAMINATION","Other");
		hmEventCats.put("THUNDER STORM","Hydromet");
		hmEventCats.put("LIGHTNING","Hydromet");
		hmEventCats.put("ELECTRIC STORM","Hydromet");
		hmEventCats.put("THUNDERSTORM","Hydromet");
		hmEventCats.put("SANDSTORM","Hydromet");
		hmEventCats.put("SNOWSTORM","Hydromet");
		hmEventCats.put("HEAT WAVE","Hydromet");
		hmEventCats.put("TORNADO","Hydromet");
		hmEventCats.put("FOG","Hydromet");
		hmEventCats.put("COLD WAVE","Hydromet");
		hmEventCats.put("COLDWAVE","Hydromet");
		hmEventCats.put("INTOXICATION","Other");
		hmEventCats.put("BOAT CAPSIZE","Other");
		hmEventCats.put("BOATCAPSIZE","Other");
		hmEventCats.put("ANIMAL ATTACK","Other");
		hmEventCats.put("INTOXICATION","Other");
		
		HashMap hmIntervals=new HashMap();		
		//HashMap hmIntervals=new HashMap();		
		hmIntervals.put("Earthquake",String.valueOf(Earthquake));
		hmIntervals.put("EQ_Landslide",String.valueOf(EQ_Landslide));
		hmIntervals.put("Hydromet",String.valueOf(Hydromet));
		hmIntervals.put("HM_Landslide",String.valueOf(HM_Landslide));
		hmIntervals.put("Landslide",String.valueOf(Landslide));
		hmIntervals.put("Volcanic",String.valueOf(Volcanic));
		hmIntervals.put("Other",String.valueOf(Other));

   	    // creates a very light rset with events
        stmt = con.createStatement();
        // rset will be scrollable, will not show changes made by others, and read only
	    rset=stmt.executeQuery("select eventos.nombre, eventos.nombre_en, category, lec_grouping_days from eventos left join event_grouping on eventos.nombre=event_grouping.nombre order by nombre_en");
		while (rset.next())
		{
		String sName=rset.getString("nombre");
		String sName_en=rset.getString("nombre_en");
		if (sName_en.length()==0)
		   sName_en=sName;
		String sCat= rset.getString("category");
		String sInterval=String.valueOf(rset.getInt("lec_grouping_days"));  	
		boolean bFound=true;
		if (sCat==null)
			{
		    sCat=(String)(hmEventCats.get(sName_en.trim().toUpperCase()));
			if (sCat==null)
			  {
			  sCat="Other";
			  bFound=false;
			  }
			sInterval=(String)(hmIntervals.get(sCat));
			}  	
		%>           
          <tr>
            <td><%=sName%><input type='hidden' name='events' value='<%=sName%>'>
            </td>
            <td><%=sName_en%></td>
            <td align="center">&nbsp;&nbsp;
                <select name='category'>
                <option value='Earthquake'<%=webObject.strSelected("Earthquake",sCat)%>>Earthquake</option>
                <option value='EQ_Landslide'<%=webObject.strSelected("EQ_Landslide",sCat)%>>EQ/Landslide</option>
                <option value='Hydromet'<%=webObject.strSelected("Hydromet",sCat)%>>Hydro-meteorological</option>
                <option value='HM_Landslide'<%=webObject.strSelected("HM_Landslide",sCat)%>>HM/Landslide</option>
                <option value='Landslide'<%=webObject.strSelected("Landslide",sCat)%>>Landslide</option>
                <option value='Volcanic'<%=webObject.strSelected("Volcanic",sCat)%>>Volcanic</option>
                <option value='Other'<%=webObject.strSelected("Other",sCat)%>>Other events</option>
                </select>
             </td>
             <td align="left"><input size="4" maxlength="2" name="interval" value='<%=sInterval%>'>
                             <%=!bFound?"<font color='red'>**Verify**</font>":""%>
			</td>
          </tr>
       <%}%>  
        </table>
	
   	<tr><td colspan="2" align="center">

	</td></tr>
	
     </table>
	</td></tr>
	</table>
  </td>
 </tr>
</table>
</form>
<script language="javascript">
function applyIntervals()
{
var j;
j=document.desinventar.category[0].selectedIndex;
for (j=0; j<document.desinventar.events.length; j++)
   {
   if (document.desinventar.category[j].selectedIndex==0)
   		document.desinventar.interval[j].value=document.desinventar.Earthquake.value;
   if (document.desinventar.category[j].selectedIndex==1)
   		document.desinventar.interval[j].value=document.desinventar.EQ_Landslide.value;
   if (document.desinventar.category[j].selectedIndex==2)
   		document.desinventar.interval[j].value=document.desinventar.Hydromet.value;
   if (document.desinventar.category[j].selectedIndex==3)
   		document.desinventar.interval[j].value=document.desinventar.HM_Landslide.value;
   if (document.desinventar.category[j].selectedIndex==4)
   		document.desinventar.interval[j].value=document.desinventar.Landslide.value;
   if (document.desinventar.category[j].selectedIndex==5)
   		document.desinventar.interval[j].value=document.desinventar.Volcanic.value;
   if (document.desinventar.category[j].selectedIndex==6)
   		document.desinventar.interval[j].value=document.desinventar.Other.value;
   }
}
</script>
</body>
</html>
<% dbCon.close(); %>

