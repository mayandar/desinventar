<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<title>DesInventar on-line - Create/Update Field</title>
</head>
<%@ page import = "org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.map.*" %>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import = "java.sql.*" %>
<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id = "Dictionary" class="org.lared.desinventar.webobject.diccionario" scope="session" />
<%
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
%>

<%@ taglib uri="inventag.tld" prefix="inv" %>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%
if (user.iusertype<20) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}%>
<%@ include file="/util/opendatabase.jspf" %>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<body  marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class='bodylight' dir="<%=countrybean.getTranslation("ltr")%>"> 
<script type="text/javascript" src="/DesInventar/html/iheader.js"></script> 

 
<% 
  

/******************************************************************
*  Process the Register request.
******************************************************************/
if (request.getParameter("cancelField")!=null)
{
  dbCon.close();
  %><jsp:forward page='/inv/lev0Manager.jsp'/><%
}
String sSql="";
String sErrorMessage="";

/*
	public 	int      map_level;
	public 	String   filename;
	public 	String   lev_code;
	public 	String   lev_name;
	public 	String   filetype;
	public 	int      color_red;
	public 	int      color_green;
	public 	int      color_blue;
	public 	int      line_thickness;
	public 	int      line_type;

*/			
int MAXCODES=3;
LevelMaps imlayer=new LevelMaps();

if (request.getParameter("saveField")!=null)
	{
	PreparedStatement pstmt=null;
  		try{
			// remove all codes firste!!!
        	sSql="delete from level_maps";
			pstmt=con.prepareStatement(sSql);
			pstmt.executeUpdate();
			// and all new ones
			pstmt=con.prepareStatement (sSql);
			String[] filetype = new String[MAXCODES];
			for (int j=0; j<MAXCODES; j++)
			   filetype[j]=request.getParameter("filetype"+j);
			String[] filename = new String[MAXCODES];
			for (int j=0; j<MAXCODES; j++)
			   filename[j]=request.getParameter("filename"+j);
			String[] lev_name =new String[MAXCODES];
			for (int j=0; j<MAXCODES; j++)
			   lev_name[j]=request.getParameter("lev_name"+j);
			String[] lev_code =new String[MAXCODES];
			for (int j=0; j<MAXCODES; j++)
			   lev_code[j]=request.getParameter("lev_code"+j);
			// all SHP for now... String[] filetype =request.getParameterValues("filetype");
			String[] colors =new String[MAXCODES];
			for (int j=0; j<MAXCODES; j++)
			   colors[j]=request.getParameter("colors"+j);
			String[] line_thickness =new String[MAXCODES];
			for (int j=0; j<MAXCODES; j++)
			   line_thickness[j]=request.getParameter("line_thickness"+j);

			for (int k=0; k<MAXCODES; k++)
			   {
			   boolean ok=filetype[k]!=null;
			   if (ok)
			   		{
					imlayer.init();
					imlayer.map_level=k;
					imlayer.filename=filename[k];			  
					imlayer.filetype=filetype[k];			  
					imlayer.lev_code=lev_code[k];			  
					imlayer.lev_name=lev_name[k];					
					int r = 0, g = 0, b = 0;
					String strColor=webObject.not_null(colors[k]);
				    if (strColor.length() == 0)
				      strColor = "#";
				    strColor += "000000";
					
				    try
				    {
				      r = Math.min(255,Integer.parseInt(strColor.substring(1, 3), 16));
				    }
				    catch (Exception er)
				    {}
				    try
				    {
				      g = Math.min(255,Integer.parseInt(strColor.substring(3, 5), 16));
				    }
				    catch (Exception eg)
				    {}
				    try
				    {
				      b = Math.min(255,Integer.parseInt(strColor.substring(5, 7), 16));
				    }
				    catch (Exception eg)
				    {}
					imlayer.color_red=r;
					imlayer.color_green=g;
					imlayer.color_blue=b;
					imlayer.line_thickness=webObject.extendedParseInt(line_thickness[k]);	
					imlayer.addWebObject(con);
					}
				}			
			}
		catch (Exception e3){
			sErrorMessage="SORRY: Field code cannot be added...("+e3.toString()+" <!--"+sSql+"--> )";
		}	
		finally{
			pstmt.close();
		}	
		if ("Y".equals(countrybean.not_null(request.getParameter("integrate"))))
			{
			ServletContext sc = getServletConfig().getServletContext();
			MapUtil map = new MapUtil();
	    	map.regenerateRegions(con, sc.getRealPath("/"), countrybean);
			}
		if (sErrorMessage.length()==0){
			dbCon.close();
			%><jsp:forward page='/inv/lev0Manager.jsp'/><%
		}
	}	

%>

<script language="JavaScript">
<!--
function giveFocus() 
{
  	document.desinventar.filename0.focus()
  	
}



function validateFields()
{
var ok=true;
return ok;
}

// color defaults for 
function cellColor(j,colvalue)
{
htmlContent='<table  bgcolor="'+colvalue+'" cellpadding="1" cellspacing="0" border="1"><tr><td width=80 bgcolor="'+colvalue+'" style="cursor:pointer">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></tr></table>';  //'+colvalue+'
document.getElementById("cell_"+j).innerHTML=htmlContent;
}

var currentCell=0;

function colorDone(dReturn)
{
if (dReturn)
	{
	document.getElementById(sname).value=dReturn;
	cellColor(currentCell,dReturn);
	}
}


function setColor(j)
{
currentCell=j;
sname="color_"+j;
scolor=document.getElementById(sname).value.substring(1,7);
var sPickerUrl = '../colorpick.jsp?color='+scolor+'&title=<%=countrybean.getTranslation("Select+Color")%>';
dReturn = showDialogSz(sPickerUrl, 'colorDone', '', 500, 500, "no");
}

function Hex2(col)
{
hexcol=col.toString(16);
if (hexcol.length<2)
   hexcol='0'+hexcol;
return hexcol;
}

function RGB(red,green,blue)
{
red=Math.min(255,Math.round(red));
green=Math.min(255,Math.round(green));
blue=Math.min(255,Math.round(blue));
return '#'+Hex2(red)+Hex2(green)+Hex2(blue);
}

var sPath="filename1";
function setReturnFolder(newFolder)
{
if (newFolder)
	document.getElementById(sPath).value=newFolder;
}

var currFile=0;
function browse(k)
{
currFile=k;
sPath="filename"+k;
var sPathVal=document.getElementById(sPath).value;
if (sPathVal=="")
   sPathVal="<%=countrybean.country.sjetfilename%>";
showDialog("/DesInventar/inv/browsefilefrm.jsp?extension=.shp&currentPath="+sPathVal, 'setReturnFolder');
}

var currField;
function processFieldRequest(newField)
{
if (newField)
	document.getElementById(currField).value=newField;
}

function setField(fieldName,k)
{
currField=fieldName;
showDialogSz("/DesInventar/util/dbaseFieldServer.jsp?selected="+document.getElementById(fieldName).value+"&filename="+document.getElementById("filename"+k).value, 'processFieldRequest',null, 500, 800, "yes")
}

// -->
</script>
<%@ include file="/util/showDialog.jspf" %> 


<table cellspacing="0" cellpadding="2" border="0" width="100%">
<tr>
<td>
<table cellspacing="0" cellpadding="1" border="1" width="100%" rules="none" class="bodylight">
<form name="desinventar" action="levelMapManager.jsp" method="post"><!--  onSubmit="return validateFields()"> -->
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<tr class='bodydarklight'>
    <td  height="25" colspan="12"><span class="titleText"><%=countrybean.getTranslation("MapLayers")%></span></td>
	</td>
</tr>
<tr><td colspan="12" height="5"></td></tr>
<TR>
<TD colspan=12 align="center"><span class="warning"><%=sErrorMessage%></span></TD>
</TR>
<tr class="bodymedlight">
  <td><%=countrybean.getTranslation("Level")%></td>
  <td><%=countrybean.getTranslation("Type")%></td>
  <td nowrap><%=countrybean.getTranslation("LineWidth")%> (%)</td>
  <td width="30" align="right"><%=countrybean.getTranslation("Color")%></td>
  <td colspan=2 align="center"><%=countrybean.getTranslation("File")%></td>
  <td colspan=2> <%=countrybean.getTranslation("Code")%></td>
  <td colspan=2> <%=countrybean.getTranslation("Name")%></td>
</tr>
<% 
// MAXCODES is an arbitrary number, for now 
String sColorScript="";

for (int k=0; k<MAXCODES; k++)
{
	imlayer.init();
	imlayer.map_level=k;
	imlayer.getWebObject(con);
	String sColor="#";
	if (imlayer.color_red<16)
	   sColor+="0";
	sColor+=Integer.toHexString(imlayer.color_red);
	if (imlayer.color_green<16)
	   sColor+="0";
	sColor+=Integer.toHexString(imlayer.color_green);
	if (imlayer.color_blue<16)
	   sColor+="0";
	sColor+=Integer.toHexString(imlayer.color_blue);
	sColorScript+="cellColor("+k+",'"+sColor+"');\n";
%>
<tr>
<td><%=k%>
<INPUT type='hidden' size='5' maxlength='22' name='map_level<%=k%>' VALUE="<%=k%>">
</td>
<td><SELECT name='filetype<%=k%>'>
<option value='0'<%=countrybean.strSelected(imlayer.filetype.equals("0"))%>>DesInventar format</option>
<option value='1'<%=countrybean.strSelected(imlayer.filetype.equals("1"))%>>Shapefile format</option>
</select> </td>
<td>  <INPUT type='TEXT' size='4' maxlength='4' name='line_thickness<%=k%>' VALUE="<%=imlayer.line_thickness<50?100:imlayer.line_thickness%>"></td>
 <td onClick="setColor(<%=k%>)">
			  <div id="cell_<%=k%>"></div>
			  <input type=hidden name="colors<%=k%>" id="color_<%=k%>" value="<%=sColor%>">
			  </td>
<td><INPUT type='TEXT' size='50' maxlength='255' name='filename<%=k%>' id='filename<%=k%>' VALUE="<%=htmlServer.htmlEncode(imlayer.filename)%>"></span>
</td>
<td> <INPUT type='button' name='browsebtn<%=k%>'  VALUE="..." onClick="browse(<%=k%>)">
</td>
<td><INPUT type='TEXT' size='15' maxlength='15' name='lev_code<%=k%>' id='lev_code<%=k%>' VALUE="<%=htmlServer.htmlEncode(imlayer.lev_code)%>"></td>
<td><input type='button' name='buttCodeField' onClick="setField('lev_code<%=k%>',<%=k%>);" value="..."></td>
<td><INPUT type='TEXT' size='15' maxlength='15' name='lev_name<%=k%>' id='lev_name<%=k%>' VALUE="<%=htmlServer.htmlEncode(imlayer.lev_name)%>"></td>
<td><input type='button' name='buttCodeField' onClick="setField('lev_name<%=k%>',<%=k%>);" value="...">
</td>
</tr>
<%}%>
	<TR>
	<TD colspan=3 height="20"></TD>
	</TR>
	<tr><td colspan=8 align="center">
	<input name="saveField" type=submit value='<%=countrybean.getTranslation("Save")%>'>  &nbsp;<input type="Checkbox" name="integrate" value="Y"><%=countrybean.getTranslation("ImportMap")%>
	&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;
	<input name="cancelField" type=button value='<%=countrybean.getTranslation("Cancel")%>' onClick="postTo('lev0Manager.jsp')">
	&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;
	</TD>
</form>
</table>
</td>
</tr>
</table>


<script language="JavaScript">
<!-- 
<%=sColorScript%>
giveFocus();
// -->
</script>
</BODY>
</html>
<%dbCon.close();%>












