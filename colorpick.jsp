<%@ page contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<%@ page import="org.lared.desinventar.util.*" %>
<%	
String strTitle =  countrybean.not_null_safe(request.getParameter("title"));
String sColorSelection= countrybean.not_null_safe(request.getParameter("color"));
String sReturnAction= request.getParameter("gradient")!=null?"gradient":"";
String sCallback= countrybean.not_null_safe(request.getParameter("callback"));
if (sCallback.length()==0)
	sCallback="colorDone";
	
if (sColorSelection==null)
 sColorSelection="#000000";
else
 sColorSelection="#"+sColorSelection;

boolean bIEdge = (request.getHeader("User-Agent").indexOf("Edge")>0);
boolean bIEBrowser = (request.getHeader("User-Agent").indexOf("MSIE")>0) || bIEdge;
%>
<html>
<head>
<title><%=strTitle%></title>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
 <script language="JavaScript">

var colorSelection="<%=sColorSelection%>";
var sShowDialogReturn="<%=sReturnAction%>";
function doDiagOK()
	{
	window.returnValue = colorSelection;
	window.close();
    if (sShowDialogReturn=="gradient")
				window.opener.<%=EncodeUtil.jsEncode(sCallback)%>(colorSelection);
			else	
				opener.colorDone(colorSelection);
	}

	
function cancelAction()
	{
		window.close();
    }

function doDelete()
{
colorSelection=' ';
document.getElementById("selectedColor").style.backgroundColor ='#000000';
document.getElementById("selColor").value=' '; 
// doDiagOK();
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

var hexPrefix="0x";
function createSlider(colorSel)
{
red=parseInt(hexPrefix+colorSel.substring(1,3),16);
green=parseInt(hexPrefix+colorSel.substring(3,5),16);
blue=parseInt(hexPrefix+colorSel.substring(5,7),16);
// heuristic to locate the color in the slider: darker colors to the left, lighter colors to the right
colorindex=red+green+blue;
if (colorindex>765) colorindex=765;
colorindex=Math.floor(colorindex/32)+1;

sliderDiv='';

// colors BEFORE
for (j=colorindex-1;j>=0; j--)
  {
  red2=red*j/colorindex;
  green2=green*j/colorindex;
  blue2=blue*j/colorindex;
  sliderDiv='<td width="10" height="10" bgcolor="'+RGB(red2,green2,blue2)+'" onclick="setFinalColor(\''+RGB(red2,green2,blue2)+'\')"></td>'+sliderDiv;
  }
// colors AFTER
for (j=colorindex+1;j<32; j++)
  {
  red2=red+(255-red)*(j-colorindex)/(32-colorindex);
  green2=green+(255-green)*(j-colorindex)/(32-colorindex);
  blue2=blue+(255-blue)*(j-colorindex)/(32-colorindex);
  sliderDiv+='<td width="10" height="10" bgcolor="'+RGB(red2,green2,blue2)+'" onclick="setFinalColor(\''+RGB(red2,green2,blue2)+'\')"></td>';
  }
sliderDiv+='<td width="10" height="10" bgcolor="#ffffff" onclick="setFinalColor(\'#ffffff\')"></td>';
sliderDiv='<table cellpadding="0" cellspacing="1" border="0"><tr>'+sliderDiv+'</tr></table>';
document.getElementById("slider").innerHTML=sliderDiv;
}
// CMYK - RGB conversion
function cmyk2rgb(C,M,Y,K)
{
  // CMYK must be 0 .. 100!!   
  C = C*255/100;
  M = M*255/100;
  Y = Y*255/100;
  K = K*255/100;
  
  var R = ( (255-C)*(255-K) ) / 255;
  var G = ( (255-M)*(255-K) ) / 255;
  var B = ( (255-Y)*(255-K) ) / 255;
 return [R,G,B];
}

function cutHex(h) {return (h.charAt(0)=="#") ? h.substring(1,7):h}
function HexToR(h) {return parseInt((cutHex(h)).substring(0,2),16)}
function HexToG(h) {return parseInt((cutHex(h)).substring(2,4),16)}
function HexToB(h) {return parseInt((cutHex(h)).substring(4,6),16)}
function hex2rgb(h)
{
R = HexToR(h);
G = HexToG(h);
B = HexToB(h);
return [R,G,B];
}

function RGBtoHex(R,G,B) 
{
return toHex(R)+toHex(G)+toHex(B)
}

function toHex(N) 
{
 if (N==null) return "00";
 N=parseInt(N); if (N==0 || isNaN(N)) return "00";
 N=Math.max(0,N); N=Math.min(N,255); N=Math.round(N);
 return "0123456789abcdef".charAt((N-N%16)/16)
      + "0123456789abcdef".charAt(N%16);
}

function rgb2cmyk (r,g,b) 
{
 computedC = 0;
 computedM = 0;
 computedY = 0;
 computedK = 0;

 if (r<0 || g<0 || b<0 || r>255 || g>255 || b>255) 
 	{
   	alert ('RGB values must be in the range 0 to 255.');
   	return;
 	}

 // BLACK
 if (r==0 && g==0 && b==0) 
 	{
  	computedK = 1;
  	return [0,0,0,1];
 	}

 computedC = 1 - (r/255);
 computedM = 1 - (g/255);
 computedY = 1 - (b/255);

 var minCMY = Math.min(computedC,Math.min(computedM,computedY));

 computedC = (computedC - minCMY) / (1 - minCMY) ;
 computedM = (computedM - minCMY) / (1 - minCMY) ;
 computedY = (computedY - minCMY) / (1 - minCMY) ;
 computedK = minCMY;

 return [computedC*100,computedM*100,computedY*100,computedK*100];
}




</script>

</head>
<body marginheight="0" topmargin="0" leftmargin="0"  marginwidth="0" class="bodyclass">

<form name="palette"  method="POST">
<span class="bodylight bss">
<table cellpadding="0" cellspacing="1" border="0">
<%
 String sHexa[]={"00","11","22","33","44","55","66","77","88","99","aa","bb","cc","dd","ee","ff"};
//   String sHexa[]={"00","22","44","66","88","aa","b3","bb","c4","cc","d6","de","e8","f3","fd","ff"};
int red=0,green=0,blue=0;
try
{
red=0;
for (red=0; red<16; red++)
{	
%><tr>
<%
	green=0;
	blue=0;
    for (green=0; green<16; green++)
	    {
	    %><td width="10" height="10" bgcolor='#<%=sHexa[red]%><%=sHexa[green]%><%=sHexa[blue]%>' onClick="setColor('#<%=sHexa[red]%><%=sHexa[green]%><%=sHexa[blue]%>')"></td>
<%	    green++;
		}
    green=15;
	for (blue=0; blue<16; blue++)
		{
	    %><td width="10" height="10" bgcolor='#<%=sHexa[red]%><%=sHexa[green]%><%=sHexa[blue]%>' onClick="setColor('#<%=sHexa[red]%><%=sHexa[green]%><%=sHexa[blue]%>')"></td>
<%		blue++;
		}
	for (blue=15; blue>=0; blue--)
		{
	    %><td width="10" height="10" bgcolor='#<%=sHexa[red]%><%=sHexa[green]%><%=sHexa[blue]%>' onClick="setColor('#<%=sHexa[red]%><%=sHexa[green]%><%=sHexa[blue]%>')"></td>
<%		green-=2; blue--;
		}
	green=0;
	for (blue=0; blue<16; blue++)
		{
	    %><td width="10" height="10" bgcolor='#<%=sHexa[red]%><%=sHexa[green]%><%=sHexa[blue]%>' onClick="setColor('#<%=sHexa[red]%><%=sHexa[green]%><%=sHexa[blue]%>')"></td>
<%		blue++;
		}
%></tr>
<%}
%><tr>
<%
	String sHex[]={"0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"};
    for (green=0; green<16; green++)
     {	
      for (blue=0; blue<16; blue++)
	    {
	    %><td width="8" height="10" bgcolor='#<%=sHex[green]+sHex[blue]+sHex[green]+sHex[blue]+sHex[green]+sHex[blue]%>' onClick="setColor('#<%=sHex[green]+sHex[blue]+sHex[green]+sHex[blue]+sHex[green]+sHex[blue]%>')"></td>
<%	    blue+=3;
		}
    green++;
	}
%></tr>
<tr><td height='12' colspan="32"><div id="slider"></div></td></tr>
<% }
catch (Exception e)
{
//e.printStackTrace();
}
%>
</table>

<table class="bss">
    <tr><td align="right" class='tableText'><%=countrybean.getTranslation("Color")%>:</td><td>	
	<td  width="20" height="20" id='selectedColor' bgcolor="<%=sColorSelection%>"></td>
	<td class="tableText" align="right">
	<%=countrybean.getTranslation("Hex")%>:<input type='text' size=7 class=bss maxlength="7" id='selColor' name='selColor' value='<%=sColorSelection%>'>
	<input type='button' class="bss" name='hexapply' onClick="javascript:applyHex()" value="<%=countrybean.getTranslation("Apply")%>">
</td>
</table>
<table class="bss">
    <tr class="bss">
	 <td valign="top" class="bss">
	 C:<input type='text' name='C' value='' maxlength="5" size="7" class="bss">&nbsp;
	 </td><td valign="top">
	 M:<input type='text' name='M' value='' maxlength="5" size="7" class="bss">&nbsp;
	 </td><td valign="top">
	 Y:<input type='text' name='Y' value='' maxlength="5" size="7" class="bss">&nbsp;
	 </td><td valign="top">
	 K:<input type='text' name='K' value='' maxlength="5" size="7" class="bss">&nbsp;
	 </td><td valign="top">
	 &nbsp;
	 <input type='button' class="bss" name='cmckapply' onClick="javascript:applyCMYK()" value="<%=countrybean.getTranslation("Apply")%>">
	 </td>
	</tr>
    <tr class="bss">
	 <td valign="top" >
	 R:<input type='text' name='R' value='' maxlength="4" size="3" class="bss">&nbsp;
	 </td><td valign="top">
	 G:<input type='text' name='G' value='' maxlength="4" size="3" class="bss">&nbsp;
	 </td><td valign="top">
	 B:<input type='text' name='B' value='' maxlength="4" size="3" class="bss">&nbsp;
	 </td><td valign="top">
	 </td><td valign="top">
	 &nbsp;
	 <input type='button' class="bss" name='cmckapply' onClick="javascript:applyRGB()" value="<%=countrybean.getTranslation("Apply")%>">
	 </td>
	</tr>
</table>
<table width="100%"  class="bss">
    <tr>
	 <td>
	 <input type='button' name='okbut' onClick="javascript:doDelete()" value="<%=countrybean.getTranslation("Delete")%>">
	 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	 <input type='button' name='okbut' onClick="javascript:doDiagOK()" value="<%=countrybean.getTranslation("Save")%>">
	 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	 <input type='button' name='cancbut' onClick="javascript:cancelAction()" value="<%=countrybean.getTranslation("Cancel")%>">
	 </td>
	</tr>
</table>

<script language="JavaScript">
document.body.scroll='no';
function setFinalColor(colorSel)
{
	colorSelection = colorSel;
	if (colorSel.length>1)
		{
		document.getElementById("selectedColor").style.backgroundColor =colorSelection;
		// hex value
		document.getElementById("selColor").value=colorSelection;
		// RGB value
		arr=hex2rgb(colorSelection);
		document.palette.R.value=arr[0];
		document.palette.G.value=arr[1];
		document.palette.B.value=arr[2];
		// CMYK value
		c_arr=rgb2cmyk (arr[0],arr[1],arr[2]); 
		document.palette.C.value=c_arr[0];
		document.palette.M.value=c_arr[1];
		document.palette.Y.value=c_arr[2];
		document.palette.K.value=c_arr[3];
		}
	else	
		doDelete();
}

function setColor(colorSel)
{
setFinalColor(colorSel);
createSlider(colorSel);
}

function applyRGB()
{
var h='#'+RGBtoHex(document.palette.R.value,document.palette.G.value,document.palette.B.value);
setColor(h);
}

function applyHex()
{
var h=document.palette.selColor.value;
if (h.charAt(0)!="#")
   h="#"+h;
setColor(h);
}

function applyCMYK()
{
var C=document.palette.C.value;
var M=document.palette.M.value;
var Y=document.palette.Y.value;
var K=document.palette.K.value;
var arr=cmyk2rgb(document.palette.C.value,document.palette.M.value,document.palette.Y.value,document.palette.K.value);
var h='#'+RGBtoHex(arr[0],arr[1],arr[2]);
setColor(h);
// preserve the original values fed. a function from 4 -> 3 and back to 4 may change these.
document.palette.C.value=C;
document.palette.M.value=M;
document.palette.Y.value=Y;
document.palette.K.value=K;
}

setColor(colorSelection);
</script>

<br>
</span>

</form>
</body>
</html>

