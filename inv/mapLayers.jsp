<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<title>DesInventar on-line - Create/Update Field</title>
</head>
<%@ page import = "org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import = "java.sql.*" %>
<jsp:useBean id = "user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id = "Dictionary" class="org.lared.desinventar.webobject.diccionario" scope="session" />
<%
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
%>
<%@ taglib uri="/inventag.tld" prefix="inv" %>
<%if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
%>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
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

int MAXCODES=12;

if (request.getParameter("saveField")!=null)
	{
	PreparedStatement pstmt=null;
  		try{
			// remove all codes firste!!!
        	sSql="delete from info_maps";
			pstmt=con.prepareStatement(sSql);
			pstmt.executeUpdate();
			// and all new ones
/*
	filename nvarchar (255)  NOT NULL ,
	layer_name nvarchar (50)  NULL ,
	layer_name_en nvarchar (50)  NULL ,
	layer smallint NULL ,
	visible smallint NULL ,
	filetype nvarchar (50)  NULL ,
	color_red smallint NULL ,
	color_green smallint NULL ,
	color_blue smallint NULL ,
	line_thickness smallint NULL ,

*/			
			sSql="insert into info_maps (filename, layer_name, layer_name_en,layer,visible,filetype,color_red,color_green,color_blue,line_thickness) values (?,?,?,?,?,?,?,?,?,?)";
			pstmt=con.prepareStatement (sSql);
			String[] filename = new String[MAXCODES];
			for (int j=0; j<MAXCODES; j++)
			   filename[j]=request.getParameter("filename"+j);
			String[] layer_name =new String[MAXCODES];
			for (int j=0; j<MAXCODES; j++)
			   layer_name[j]=request.getParameter("layer_name"+j);
			String[] layer_name_en =new String[MAXCODES];
			for (int j=0; j<MAXCODES; j++)
			   layer_name_en[j]=request.getParameter("layer_name_en"+j);
			// layer in order...
			String[] visible =new String[MAXCODES];
			for (int j=0; j<MAXCODES; j++)
			   visible[j]=request.getParameter("visible"+j);
			// all SHP for now... String[] filetype =request.getParameterValues("filetype");
			String[] colors =new String[MAXCODES];
			for (int j=0; j<MAXCODES; j++)
			   colors[j]=request.getParameter("colors"+j);
			String[] line_thickness =new String[MAXCODES];
			for (int j=0; j<MAXCODES; j++)
			   line_thickness[j]=request.getParameter("line_thickness"+j);

			for (int k=0; k<MAXCODES; k++)
			   {
			   boolean ok=(filename[k]!=null && layer_name[k]!=null && filename[k].length()!=0 && layer_name[k].length()!=0);
			   if (ok)
			   		{
					pstmt.setString(1, filename[k]);			  
					pstmt.setString(2, layer_name[k]);			  
					pstmt.setString(3, layer_name_en[k]);			  
					pstmt.setInt(4,k);
					pstmt.setInt(5,webObject.extendedParseInt(visible[k]));
					pstmt.setString(6, "shp"); // filetype[k]);
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
					pstmt.setInt(7,r);
					pstmt.setInt(8,g);
					pstmt.setInt(9,b);
					pstmt.setInt(10,webObject.extendedParseInt(line_thickness[k]));
					pstmt.executeUpdate();			
					}
				}			
			}
		catch (Exception e3){
			sErrorMessage="SORRY: Field code cannot be added...("+e3.toString()+" <!--"+sSql+"--> )";
		}	
		finally{
			pstmt.close();
		}	
		if (sErrorMessage.length()==0){
			dbCon.close();
			%><jsp:forward page='/inv/lev0Manager.jsp'/><%
		}
	}	

stmt=con.createStatement ();
rset=stmt.executeQuery("select * from info_maps order by layer");		   	

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
showDialog("/DesInventar/inv/browsefilefrm.jsp?extension=.shp&currentPath="+document.getElementById(sPath).value, 'setReturnFolder');
}

// -->
</script>

<%@ include file="/util/showDialog.jspf" %> 


<table cellspacing="0" cellpadding="2" border="0" width="100%">
<tr>
<td>
<table cellspacing="0" cellpadding="5" border="1" width="100%" rules="none">
<form name="desinventar" action="mapLayers.jsp" method="post"><!--  onSubmit="return validateFields()"> -->
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<tr>
    <td class='bgDark' height="25" td colspan="3"><span class="titleText"><%=countrybean.getTranslation("MapLayers")%></span></td>
</tr>
<% if (sErrorMessage.length()>0){%>
<TR>
<TD colspan=2 align="center"><span class="warning"><%=sErrorMessage%></span></TD>
</TR>
<%}%>
<tr>
  <td colspan=2> <%=countrybean.getTranslation("File")%></td>
  <td> <%=countrybean.getTranslation("Name")%></td>
  <td> <%=countrybean.getTranslation("English")%></td>
  <td> <%=countrybean.getTranslation("Visible")%></td>
  <td> <%=countrybean.getTranslation("LineWidth")%>(%)</td>
  <td> <%=countrybean.getTranslation("Color")%></td>
</tr>
<% 
// MAXCODES is an arbitrary number, for now 
InfoMaps imlayer=new InfoMaps();
String sColorScript="";

for (int k=0; k<MAXCODES; k++)
{
if (rset.next())
	{
	imlayer.loadWebObject(rset);
	} 
else 
	{
	imlayer.init();
	}
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

<td>  <INPUT type='TEXT' size='50' maxlength='255' name='filename<%=k%>' id='filename<%=k%>' VALUE="<%=htmlServer.htmlEncode(imlayer.filename)%>">
</td>
<td>      <INPUT type='button' name='browsebtn<%=k%>'  VALUE="<%=countrybean.getTranslation("Browse")%>" onClick="browse(<%=k%>)">
</td>
<td>  <INPUT type='TEXT' size='20' maxlength='50' name='layer_name<%=k%>' id='layer_name<%=k%>' VALUE="<%=htmlServer.htmlEncode(imlayer.layer_name)%>"></td>
<td>  <INPUT type='TEXT' size='20' maxlength='50' name='layer_name_en<%=k%>' id='layer_name_en<%=k%>' VALUE="<%=htmlServer.htmlEncode(imlayer.layer_name_en)%>"></td>
<INPUT type='hidden' size='5' maxlength='22' name='layer<%=k%>' VALUE="<%=k%>">
<td>  <INPUT type='checkbox' name='visible<%=k%>' VALUE="1" <%=imlayer.strChecked(imlayer.visible)%>></td>
 <INPUT type='hidden' name='filetype<%=k%>'  id='filetype<%=k%>' VALUE="<%=imlayer.filetype%>"></td>
<td>  <INPUT type='TEXT' size='2' maxlength='4' name='line_thickness<%=k%>' VALUE="<%=imlayer.line_thickness<50?100:imlayer.line_thickness%>"></td>
 <td onClick="setColor(<%=k%>)">
			  <div id="cell_<%=k%>"></div>
			  </td>
			  <td><input type=hidden name="colors<%=k%>" id="color_<%=k%>" value="<%=sColor%>">
</tr>
<%}%>
	<TR>
	<TD colspan=3 height="20"></TD>
	</TR><td colspan=3 align="center">
	<input name="saveField" type=submit value='<%=countrybean.getTranslation("Save")%>'> 
	&nbsp; &nbsp; &nbsp; &nbsp;
	<input name="cancelField" type=button value='<%=countrybean.getTranslation("Cancel")%>' onClick="postTo('lev0Manager.jsp')">
	</TD>
	</Tr>
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












