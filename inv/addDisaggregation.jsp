<%
boolean bIEBrowser = (request.getHeader("User-Agent").indexOf("MSIE")>0);
boolean bIEdge = (request.getHeader("User-Agent").indexOf("Edge")>0);
%>


<script type="text/javascript">

var oArgs;
var oResults;
var sShowDialogReturn;
var oShowDialogOtherArgs;
var dReturn;

function DialogArgs(parentWindow, url, otherArgs)
{
	this.parentWindow = parentWindow;
	this.url = url;
	this.otherArgs = otherArgs;
}

function showDialog(url, sReturnProc)
{
	return showDialogSz(url, sReturnProc, null, 435, 605, "no");
}

function showDialog(url, sReturnProc, otherArgs)
{
	return showDialogSz(url, sReturnProc, otherArgs, 435, 605, "no");
}

function showDialogSz(url, sReturnProc, otherArgs, iHeight, iWidth)
{
	return showDialogSz(url, sReturnProc, otherArgs, iHeight, iWidth, "no")
}

function showDialogSz(url, sReturnProc, otherArgs, iHeight, iWidth, sScrollbars)
{
	if (sReturnProc == "") sReturnProc = null;
	
	<%
	if (bIEBrowser) { %>
			var now = new Date;
			oArgs = new DialogArgs(window, url, otherArgs);
	        oResults = window.showModalDialog(url+"&ts="+now.getTime(), oArgs, "resizable:yes;status:no;help:no;scroll:"+sScrollbars+";dialogHeight:" + iHeight + "px;dialogWidth:" + iWidth + "px");
	        // alert(22222);
			if (sReturnProc != null) 
			    eval(sReturnProc + "(oResults)");
			return oResults;
	<%	} else { %>
			// alert(33333);
			sShowDialogReturn = sReturnProc;
			oShowDialogOtherArgs = otherArgs; // not used in DI for now.
			document.helpwindow=window.open(url,'nonmodalwindow','width=' + iWidth + ',height=' + iHeight + ',left=10,screenX=10,top=50,screenY=50,scrollbars='+sScrollbars+',resizable=yes');
	        document.helpwindow.focus();
			return null;
	<%	} %>
}

function dialogResults(oResults)
{
 		if (sShowDialogReturn != null) eval(sShowDialogReturn + "(oResults)");
}

var selectIndicatorKey = 0;

function addTR(item){
	var div = document.getElementById("FOR_SENDAI_TABLE_"+selectIndicatorKey);
	var table = document.getElementById("SENDAI_TABLE_"+selectIndicatorKey);
	var fieldSet;
	var legend;
	if(table == null){
		// out.println("<fieldset>");
		// out.println("<legend>"+countrybean.getTranslation("Disaggregation:")+"</legend>");

		// out.println("<table name='SENDAI_TABLE_"+indicator_key+"' id='SENDAI_TABLE_"+indicator_key+"' width='100%' border='0' cellpadding='1' cellspacing='0' rules='rows' class='bss'>");
		fieldSet = document.createElement("FIELDSET");
		div.appendChild(fieldSet);
		legend = document.createElement("LEGEND");
		legend.innerHTML = '<%=countrybean.getTranslation("Disaggregation:")%>';
		fieldSet.appendChild(legend);
		table = document.createElement("TABLE");
		table.setAttribute("id", "SENDAI_TABLE_"+selectIndicatorKey);
		table.setAttribute("name", "SENDAI_TABLE_"+selectIndicatorKey);
		table.setAttribute("class", "bss");
		table.style.width = "100%";
		table.style.border = "0";
		table.style.padding = "1";
		table.style.borderSpacing = "0";
		fieldSet.appendChild(table);
	}
	var tr = table.insertRow(-1);
	var key=item["key"]; // just to have something short
	var selector=item["selector"]; // just to have something short
	var measurement=item["measurement"];
	var unit=item["unit"];
	var tdString = "";	
	var fieldName="LOSS_"+key;

    var td1 = tr.insertCell(0);
	// out.println("<td width='25%' valign='middle'>");
	td1.style.width = '25%';
	td1.style.verticalAlign = 'middle';
	td1.innerHTML = selector;

	var td2 = tr.insertCell(1);
	// out.println("</td><td width='25%' valign='bottom'>");
	td2.style.width = '25%';
	td2.style.verticalAlign = 'bottom';
	tdString ="<%=countrybean.getTranslation("Economic loss")%>:<br />"+"<input type='text' name='"+fieldName+"' id='"+fieldName+"' onchange='autosave("+fieldName+")' value='' size='15' placeholder='<%=countrybean.getTranslation("Amount")%>'> ";
	td2.innerHTML = tdString;
	
	var td3 = tr.insertCell(2);
	// out.println("</td><td width='25%' valign='bottom'>");
	td3.style.width = '25%';
	td3.style.verticalAlign = 'bottom';
	fieldName="TOTAL_"+key;
    var sUnits='<%=countrybean.getTranslation("Units") %>';
    if (measurement.toLowerCase() == "ha" || measurement.toUpperCase() == "M")
    	sUnits=measurement;
    tdString ='<%=countrybean.getTranslation("Total Affected")%>'+' ('+unit+') ['+sUnits+']: <br />';
    tdString +="<input type='text' name='"+fieldName+"' id='"+fieldName+"' onchange='autosave("+fieldName+")' value='' size='15' placeholder='<%=countrybean.getTranslation("Number")%>'> ";
    tdString +="<input type='button' NAME='AL__"+fieldName+"' value='&Sigma;' onclick='addLoss(TOTAL_"+key+",DAMAGED_"+key+", DESTRYD_"+key+", null)' />"; 
    td3.innerHTML = tdString;
    
    var td4 = tr.insertCell(3);
    // out.println("</td><td width='25%' valign='bottom'>");
	td4.style.width = '25%';
	td4.style.verticalAlign = 'bottom';
	fieldName="DAMAGED_"+key;
	tdString ='<%=countrybean.getTranslation("Damaged")%> ('+unit+') ['+sUnits+']: <br />';
	tdString +="<input type='text' name='"+fieldName+"' id='"+fieldName+"' onchange='autosave("+fieldName+")' value='' size='15' placeholder='<%=countrybean.getTranslation("Number")%>'> ";
    td4.innerHTML = tdString;
	
	var td5 = tr.insertCell(4);
	// out.println("</td><td valign='bottom'>");
	td5.style.verticalAlign = 'bottom';
	fieldName="DESTRYD_"+key;
	tdString ='<%=countrybean.getTranslation("Destroyed")%>'+' ('+unit+') ['+sUnits+']: <br />';
	tdString +="<input type='text' name='"+fieldName+"' id='"+fieldName+"' onchange='autosave("+fieldName+")' value='' size='15' placeholder='<%=countrybean.getTranslation("Number")%>'> ";
	td5.innerHTML = tdString;
}

function HandlePopupResult(result) 
{
	for (var i = 0, len = result.length; i < len; i++) {
		addTR(result[i]);
	}
}

function add_disaggegation(indicatorKey)
{
	selectIndicatorKey = indicatorKey;
	var sPickerUrl = '/DesInventar/inv/metadataGroupModal.jsp?indicator_key='+indicatorKey;
	dReturn = showDialogSz(sPickerUrl, "", null, 450, 700, "no");
}

function add_disaggegation_cancel(oReturn)
{
if (oReturn){
  if (oReturn==' ') 
  		oReturn='';
  }
}
</script>

