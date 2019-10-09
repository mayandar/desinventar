// to test whether a page is running on a frame or not  DO NOT REMOVE when changing look&feel
var bNotInFrame=true;

function home()
{
var thisPage=window.location.href;
if (thisPage.indexOf("/inv/")>0)
  window.location="/DesInventar/inv/index.jsp"
else if (this.query!=null)
  query();
else
  window.location="/DesInventar/index.jsp";
}

function switchLanguage()
{
var newLanguage=document.lang.langselect.options[document.lang.langselect.selectedIndex].value;
var thisPage=window.location.href;
var pos=thisPage.lastIndexOf("lang=");
if (pos>0)  
  { // already set, just replace the language
	thisPage=thisPage.substring(0,pos+5)+newLanguage+thisPage.substring(pos+7);
	postTo(thisPage)
  }
  else
  {  //  not set, add it
	pos2=thisPage.indexOf("?");
	var connector='&';
	if (pos2<=0)
	  connector='?';
	thisPage=thisPage+connector+"lang="+newLanguage;
	postTo(thisPage)
  }
 }


function dataLanguage()
{
var newLanguage="LL";
if (document.datalang.datalanguage.checked)
 newLanguage="EN";
var thisPage=window.location.href;
var pos=thisPage.lastIndexOf("datalng=");
if (pos>0)  
  { // already set, just replace the language
	thisPage=thisPage.substring(0,pos+8)+newLanguage+thisPage.substring(pos+10);
	postTo(thisPage)
  }
  else
  {  //  not set, add it
	pos2=thisPage.indexOf("?");
	var connector='&';
	if (pos2<=0)
	  connector='?';
	thisPage=thisPage+connector+"datalng="+newLanguage;
	postTo(thisPage)
  }
 }



function postTo(path) 
{
    method = "post"; // Set method to post by default if not specified.
    // The rest of this code assumes you are not using a library.
    // It can be made less wordy if you use one.
    var form = document.createElement("form");
    form.setAttribute("method", method);
    form.setAttribute("action", path);
    var hiddenField = document.createElement("input");
    hiddenField.setAttribute("type", "hidden");
    hiddenField.setAttribute("name", "usrtkn");
	param="";
	if (document.getElementById("usrtkn"))
      param=document.getElementById("usrtkn").value;	  
    hiddenField.setAttribute("value", param);
    form.appendChild(hiddenField);
    document.body.appendChild(form);
    form.submit();
}

function routeTo(newPage, sExtraAction)
{
if (document.getElementById("actiontab"))
  {
  document.desinventar.actiontab.value=newPage;
  if (sExtraAction!=null)
   if (sExtraAction.length>0)
     eval(sExtraAction);
  document.desinventar.action=newPage;
  document.desinventar.submit();
  }
else
  {
  window.location=newPage;
  }
return true;
}



function doHelp()
{

var thisPage=window.location.href;
window.location="/DesInventar/help/invmain.jsp";
/*if (thisPage.indexOf("/main.jsp")>0)
  window.location="/DesInventar/help/main.jsp"
else if (thisPage.indexOf("/results.jsp")>0)
  window.location="/DesInventar/help/results.jsp"
else 
    window.location="/DesInventar/help/helpIndex.jsp";
*/
}


