<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
<%@ page info="DesInventar On-Line" session="true" %> 
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.Arrays"%>
<%@ page import="org.lared.desinventar.util.*" %> 
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
	<title><%=countrybean.getTranslation("SelectFolder")%></title>
</head>
<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>

 <body class="bodylight bss" dir="<%=countrybean.getTranslation("ltr")%>">
<%
boolean bIEBrowser = (request.getHeader("User-Agent").indexOf("MSIE")>0);
boolean bIEdge = (request.getHeader("User-Agent").indexOf("Edge")>0);
String sCurrentPath=htmlServer.not_null(request.getParameter("currentPath")).trim();
// NO empty paths
if (sCurrentPath.length()==0)
   sCurrentPath="/";
// obtain a drive spec if present
boolean bDrives=false;
if (sCurrentPath.length()==2 && sCurrentPath.charAt(1)==':')  /// windows machine, drive letter
	bDrives=true;
File dirlist=new File (sCurrentPath);
if (!(dirlist.exists() && dirlist.isDirectory()) )
	{
	sCurrentPath="/";
	dirlist=new File (sCurrentPath);
	}
if (sCurrentPath.equals("/"))
	sCurrentPath= dirlist.getAbsolutePath();
// only forward slashes
sCurrentPath=sCurrentPath.replace('\\','/');
// object in the file system
// ensure it ends with a slash
if (!sCurrentPath.endsWith(":"))
  if (!sCurrentPath.endsWith("/"))
	sCurrentPath+="/";

String sNewFolder=htmlServer.not_null(request.getParameter("new_Folder")).trim();
if (sNewFolder.length()>0)
	{
	  File newDir=new File (sCurrentPath+sNewFolder);
	  newDir.mkdir();
	}
dirlist=new File (sCurrentPath);
%>
<script language="JavaScript">

//alert("<%=htmlServer.not_null(request.getParameter("currentPath"))%>");
function upToLevel()
{
with (document.desinventar)
   {
   currentPath.value=levels.options[levels.selectedIndex].value;
   submit();
   }
}

function fileup()
{
with (document.desinventar)
   {
   if (levels.selectedIndex>0)
    {
	currentPath.value=levels.options[levels.selectedIndex-1].value;
	submit();
	}
   }

}

function openPath(path)
{
with (document.desinventar)
   {
	currentPath.value=path;
	submit();
	}
}

var sCurrentCell="";

function filePath(path,newcell)
{
with (window.desinventar)
   {
	currentPath.value=path;
	if (sCurrentCell.length>0)
		document.getElementById(sCurrentCell).className="bodylight bss";
	sCurrentCell=newcell;
	document.getElementById(sCurrentCell).className="bodymedlight bss";
	}
}

function selectPath()
	{
	
<% if (!bIEBrowser) { %>
		    parent.opener.setReturnFolder(document.getElementById("currentPath").value);
			this.close();
			parent.close();
	<%}
	else
	{%>	
		window.returnValue = window.desinventar.currentPath.value;
		window.close();
	<%}%>

	}
	
function cancelPath()
	{
	this.close();
    <% if (!bIEBrowser) { %>
			parent.cancelPath();
	<%}%>	
    }

function newfolder()
{
with (document.desinventar)
   {
    new_Folder.value=prompt("<%=countrybean.getTranslation("EnterNewFolderName")%>","");
	if (new_Folder  && new_Folder.value && new_Folder.value.length>0 && new_Folder.value!="null") // IE oddity
		{
		// alert ("entered ["+new_Folder.value+"]");		
		currentPath.value='<%=sCurrentPath%>';
		submit();
		}
	}
}

var currentRow=-1;
function toggle(nRow, path)
{
if (currentRow>=0)
	document.getElementById("fcell"+currentRow).className='bodylight bss';
document.getElementById("fcell"+nRow).className='bodymedlight bss';
currentRow=nRow;
document.getElementById("currentPath").value=path;
}
</script>
<table width="100%" height="100%" cellpadding="0" cellspacing="0" class="bss">
<form name="desinventar" id="desinventar" method="get" action="browsedir.jsp">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<tr><td height="3"></td></tr>
<tr> <!-- Toolbar current tree -->
	<td  valign="top" nowrap>&nbsp;
	<select name="levels" style="WIDTH: 250px;" onChange="upToLevel()">
	<%
	int start=0;
	if (sCurrentPath.length()>=2)
      if (sCurrentPath.charAt(1)==':')  /// windows machine, drive letter
			{
    		out.print("<option value=\""+sCurrentPath.substring(0,2)+"\""+(bDrives?" selected":"")+">"+sCurrentPath.substring(0,2)+"</option>");
			start=2;
			}
	if (!bDrives)
		{
		String sIndent="&nbsp;&nbsp;";
		out.println("<option value=\"/\""+(start+1==sCurrentPath.length()?" selected":"") +">/</option>");
		int end=start+1;
	    while (end<sCurrentPath.length())
			{
			start=end;
			while (end<sCurrentPath.length() && sCurrentPath.charAt(end)!='/')
			   end++;
			String sThisLevel="";
			sThisLevel=sCurrentPath.substring(start,end);
			if (sThisLevel.length()>0)
				{
				out.print("<option value=\""+sCurrentPath.substring(0,end)+"\"");
				if (end+1>=sCurrentPath.length())
					out.print(" selected");
				out.println(">"+sIndent+sThisLevel+"</option>");
				}
			sIndent+="&nbsp;&nbsp;";
			end++;
			}
		 }
	%>
	</select> <input type="Image" src='/DesInventar/images/file_up.gif' onClick="fileup()"> &nbsp;<input type="Image" src='/DesInventar/images/folder_new.gif' onClick="newfolder()">
	</td>
</tr>
<tr><td  height="3"></td></tr>
<tr><td height="3"></td></tr>
<tr> <!-- list of folders/files --><!-- <%=sCurrentPath%> -->
	<td height="100%" valign="top" width="100%">
	 <table width="100%" cellpadding="0" cellspacing="0" class="bodylight bss">
<%File fThisFile=null;
if (bDrives) 
		{
		// all drives here...
		int nRow=0;
		for (char drv='C'; drv<='Z'; drv++)
			{
			fThisFile=new File(drv+":/");
			if (fThisFile.isDirectory())
				{
				if (nRow%3==0)
					{
					if (nRow>0)
						out.println("</tr>");
					out.println("<tr>");
					}
				// change this icon!!!
				out.print("<td width='33%' nowrap ondblclick=\"openPath('"+drv+":/')\">&nbsp;<img src='/DesInventar/images/folder.gif'>&nbsp;<div id='fcell"+nRow+"'>"+drv+":</div></td>");
				nRow++;
				}
			}
		}
	else if (dirlist.isDirectory())
	   		{
			String[] filename= dirlist.list();
			Arrays.sort(filename, String.CASE_INSENSITIVE_ORDER);
			int nRow=0;
			for (int j=0; j<filename.length; j++)
				{
				fThisFile=new File(sCurrentPath+"/"+filename[j]);
				if (fThisFile.isDirectory())
					{
					if (nRow%3==0)
						{
						if (nRow>0)
							out.println("</tr>");
						out.println("<tr>");
						}
					String sFullPath=sCurrentPath;
					if (!sCurrentPath.endsWith("/"))
					   sFullPath+="/";
					sFullPath+=filename[j]; 
					out.print("<td width='33%' onclick=\"toggle("+nRow+",'"+sFullPath+"')\" ondblclick=\"openPath('"+sFullPath+"')\" nowrap><div id='fcell"+nRow+"' >&nbsp;<img src='/DesInventar/images/folder.gif'>&nbsp;"+filename[j]+"</div></td>");
					nRow++;
					}
				}				   
			}
		else
			{
			%><tr><td  valign="top"><%=sCurrentPath%></td></tr>
		  <%}%>
		</table>
	</td>
</tr>
<tr><td height="3"></td></tr>
<tr><td height="1"></td></tr>
<tr><td width="100%"><%=countrybean.getTranslation("Selected")%>:  <input type='text' class='bs' maxlength="128" size="40" name='currentPath'  id='currentPath' value='<%=sCurrentPath%>'> &nbsp;&nbsp;&nbsp;
<input type='hidden' name='new_Folder'>
<input type="button" name="okbtn" value="Ok" onClick="selectPath()">&nbsp;&nbsp;<input type="button" name="okbtn" value="Cancel" onClick="cancelPath()">
 </td></tr>
 </form>
</table>
</body>
</html>
