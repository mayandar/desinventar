function switchLanguage()
{
var newLanguage=document.lang.langselect.options[document.lang.langselect.selectedIndex].value;
var thisPage=window.location.href;
var pos=thisPage.lastIndexOf("lang=");
if (pos>0)  
  { // already set, just replace the language
	thisPage=thisPage.substring(0,pos+5)+newLanguage+thisPage.substring(pos+7);
	routeTo(thisPage)
  }
  else
  {  //  not set, add it
	pos2=thisPage.indexOf("?");
	var connector='&';
	if (pos2<=0)
	  connector='?';
	thisPage=thisPage+connector+"lang="+newLanguage;
	routeTo(thisPage)
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
	routeTo(thisPage)
  }
  else
  {  //  not set, add it
	pos2=thisPage.indexOf("?");
	var connector='&';
	if (pos2<=0)
	  connector='?';
	thisPage=thisPage+connector+"datalng="+newLanguage;
	routeTo(thisPage)
  }
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

function postTo(path) 
{
    method = "post"; // Set method to post by default if not specified.
    // The rest of this code assumes you are not using a library.
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


function doHelp()
{
var thisPage=window.location.href;
window.location="/DesInventar/help/main.jsp";
}

function getBookmark()
{
	// do nothing. To be overrided where available
}


