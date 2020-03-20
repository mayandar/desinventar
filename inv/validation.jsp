<script src="/DesInventar/xmlHttp.js"></script>
<script language="javascript">


function  callbackSaver(request)
{

var responseTXT = request.responseText;
//alert(responseTXT);
var sCode=responseTXT.substring(0,6);
if (sCode=="%%OK%%")
	{
	responseTXT=responseTXT.substring(7);
	sCode="";
	j=1;
	while (responseTXT.length>3)
		{
		pos=responseTXT.indexOf("=");
		sField=responseTXT.substring(0,pos);
		responseTXT=responseTXT.substring(pos+1);
		pos=responseTXT.indexOf("\n");
		sValue=responseTXT.substring(0,pos);
		responseTXT=responseTXT.substring(pos+1);
		vVariable=document.getElementById(sField);
		var justthese=0;
		if (vVariable!=null && !(vVariable == document.activeElement))
			{		
			// if (++justthese>20 && justthese<25) alert("set: "+ sField+"  value="+sValue+ " type="+vVariable.type);
			if (vVariable.type=="checkbox")
				{
				if (vVariable.value==sValue) vVariable.checked=true;
				}
			// verify select and radio cases
			else if (vVariable.type=="radio")
				{
				if (vVariable.value==sValue) vVariable.checked=true;
				}
			else if (vVariable.type=="select-one")
				{						
				for (j=0; j<vVariable.length; j++)
				 if (vVariable.options[j].value==sValue)
					{
					vVariable.options[j].selected=true;				   
					vVariable.selectedIndex=j;
					}
				}
			else // default
				{
					pos=sValue.indexOf(".");
					if (pos>0 && (sValue.length-pos>5)) // must be posgres introducing lots of decimals ob float4 numbers
						{
							var numPostgres=parseFloat(sValue);
							sValue=numPostgres.toFixed(2);
						}
					vVariable.value=sValue;
				}
			}
		// for testing purposes:	
		// else if (vVariable==null)
		//   	alert("Error:  undefined variable! "+sField);
		// else if (vVariable == document.activeElement)
		//   	alert("Not updated, active: "+sField);
		}
	}
else
  {
	  alert ('<%=countrybean.getTranslation("Session expired.. Redirected to home page")%>');
	  window.location="/";
  }
	
document.getElementById("saving").style.visibility='hidden';
}



function autosave()
{
var sThisHref=window.location.href;
if (sThisHref.indexOf("/inv/")>0)
	{
	document.getElementById("saving").style.visibility='visible';
	with (document.desinventar)
	  {
		sKey=clave.value;		
		SaveServerUrl="/DesInventar/inv/SaveServer.jsp?key="+sKey;
		var nvalid=0;
		for (j=0; j< arguments.length; j++)
			{  
			fieldname=arguments[j];
			if (fieldname!=null)
				{
				sName=fieldname.name;
				nvalid++;
				if (fieldname.type=="select-one")
					{
					if (fieldname.selectedIndex>=0)	
						sValue=fieldname.options[fieldname.selectedIndex].value;
					else
						sValue='';
					}
				else if (fieldname.type=="checkbox")
					{
					if (fieldname.checked)
						sValue=fieldname.value;
					else	
						sValue=""
					}
				else
					sValue=fieldname.value;
				SaveServerUrl+="&field="+sName+"&value="+encodeURIComponent(sValue);
				}
			}
		// all arguments in one blow...
		if (nvalid>0)
			sendHttpRequest("GET", SaveServerUrl, callbackSaver);
	  }
	}
}


function doAlert(field)
{
	alert("Totals of "+field+" are inconsistent, please review");
	return false;
}

function checkHumanLoss(main_var, male_var, female_var, loss_label, checked_var)
{
main_var.value=Number(main_var.value);
male_var.value=Number(male_var.value);
female_var.value=Number(female_var.value);
with (document.desinventar)
	{
	if (checked_var!=mull)
		if (main_var.value+
			female_var.value+
			male_var.value!=0) 
			{
			checked_var.checked=true;
			autosave(checked_var);	
			}
	if (main_var.value==0 &&
		(female_var.value!=0 ||  male_var.value!=0 )  )
			addLoss(main_var,female_var,male_var);	
	if (Number(male_var.value)+Number(female_var.value)>Number(main_var.value) && Number(main_var.value)>0)
		doAlert(loss_label);
	}
}

function addLoss(main_var, male_var, female_var, checked_var)
{
with (document.desinventar)
	{
    if (Number(female_var.value)+ Number(male_var.value)!=0)
    	main_var.value=Number(female_var.value)+ Number(male_var.value);
	if (Number(main_var.value)!=0 && checked_var!=null) 
			checked_var.checked=true;
	if (checked_var!=null) 
			autosave(main_var,checked_var);	
		else
			autosave(main_var);	
	}
}

function addLoss_3(main_var, children_var, adult_var, elder_var)
{
with (document.desinventar)
	{
    if (Number(children_var.value)+ Number(adult_var.value)+ Number(elder_var.value)!=0)
    	{
		main_var.value=Number(children_var.value)+ Number(adult_var.value)+ Number(elder_var.value);
		autosave(main_var);
		}
	}
}

function chkLoss(main_var, checked_var)
{
with (document.desinventar)
	{
	if (Number(main_var.value)!=0) 
    	checked_var.checked=true;
	autosave(main_var,checked_var);	
	}
}



function jsGetLevel3()
{
with (document.desinventar)
	{
	name2.value=level2.options[level2.selectedIndex].text;
	autosave(level2,name2);	
	setTimeout(function()
		{
		// relocate marker now.
		build_locations();
		}, 300);	
	}

return false;
}


function  callbackL1(request)
{
loadList(request,document.desinventar.level1);
}

function  callbackL2(request)
{
loadList(request,document.desinventar.level2);
}

function  loadList(request,list)
{
	var responseTXT = request.responseText;
	var sCode=responseTXT.substring(0,6);
	if (sCode=="%%OK%%")
		{
		responseTXT=responseTXT.substring(7);
		sCode="";
		var sOption="";
	    list.options[0]=new Option;
	    list.options[0].value=sCode;
	    list.options[0].text=sOption;
		j=1;
		while (responseTXT.length>3)
			{
			if (sCode.length>0)
			   {
			   list.options[j]=new Option;
			   list.options[j].value=sCode;
			   list.options[j].text=sOption;
			   j++;
			   }
			pos=responseTXT.indexOf("\n");
			sCode=responseTXT.substring(0,pos);
			responseTXT=responseTXT.substring(pos+1);
			pos=responseTXT.indexOf("\n");
			sOption=responseTXT.substring(0,pos);
			responseTXT=responseTXT.substring(pos+1);
			}
		}
}

function checkLevel0()
{
with (document.desinventar)
  {
	GeoServerUrl="/DesInventar/util/geoserver.jsp?level=1";
	for (j=0; j<level0.options.length; j++)
		if (level0.options[j].selected)
			GeoServerUrl+="&code="+level0.options[j].value;
	document.getElementById("level1").innerHTML="";		
	document.getElementById("level2").innerHTML="";
	sendHttpRequest("GET", GeoServerUrl, callbackL1);
	name0.value=level0.options[level0.selectedIndex].text;
	name2.value='';
	name1.value='';
	autosave(level0,name0,level1,name1,level2,name2);	

	setTimeout(function()
		{
		// relocate marker now.
		build_locations();
		}, 300);	

	}
}

function checkLevel1()
{
with (document.desinventar)
  {
	GeoServerUrl="/DesInventar/util/geoserver.jsp?level=2";
	for (j=0; j<level1.options.length; j++)
		if (level1.options[j].selected)
			GeoServerUrl+="&code="+level1.options[j].value;
	document.getElementById("level2").innerHTML="";		
	sendHttpRequest("GET", GeoServerUrl, callbackL2)   
    name1.value=level1.options[level1.selectedIndex].text;
	name2.value='';
	autosave(level1,name1,level2,name2);	
	setTimeout(function()
		{
		// relocate marker now.
		build_locations();
		}, 300);	
  }
}

function chkMuertos()
{
with (document.desinventar)
	{
	if (muertos.value!=0) hay_muertos.checked=true;
	}
}
function chkDesaparece()
{
with (document.desinventar)
	{
	if (desaparece.value!=0) hay_deasparece.checked=true;
	}
}
function chkHeridos()
{
with (document.desinventar)
	{
	if (heridos.value!=0) hay_heridos.checked=true;
	}
}
function chkDamnificados()
{
with (document.desinventar)
	{
	if (damnificados.value!=0) hay_damnificados.checked=true;
	}
}
function chkAfectados()
{
with (document.desinventar)
	{
	if (afectados.value!=0) hay_afectados.checked=true;
	}
}
function chkVivdest()
{
with (document.desinventar)
	{
	if (vivdest.value!=0) hay_vivdest.checked=true;
	}
}
function chkVivafec()
{
with (document.desinventar)
	{
	if (vivafec.value!=0) hay_vivafec.checked=true;
	}
}
function chkEvacuados()
{
with (document.desinventar)
	{
	if (evacuados.value!=0) hay_evacuados.checked=true;
	}
}
function chkNhectareas()
{
with (document.desinventar)
	{
	if (nhectareas.value!=0) agropecuario.checked=true;
	}
}
function chkCabezas()
{
with (document.desinventar)
	{
	if (cabezas.value!=0) agropecuario.checked=true;
	}
}
function chkNescuelas()
{
with (document.desinventar)
	{
	if (nescuelas.value!=0) educacion.checked=true;
	}
}
function chkReubicados()
{
with (document.desinventar)
	{
	if (reubicados.value!=0) hay_reubicados.checked=true;
	}
}
function chknHospitales()
{
with (document.desinventar)
	{
	if (nhospitales.value!=0) salud.checked=true;
	}
}

function chkKmVias()
{
with (document.desinventar)
	{
	if (kmvias.value!=0) transporte.checked=true;
	}
}

// to be used with add and update forms
function chkForm()
{
chkMuertos();
chkDesaparece();
chkHeridos();
chkDamnificados();
chkAfectados();
chkVivdest();
chkVivafec();
chkEvacuados();
chkNhectareas();
chkCabezas();
chkNescuelas();
chkReubicados();
chknHospitales();
chkKmVias();
with (document.desinventar)
	{
	if (level0.selectedIndex<=0)
		{
		alert (" <%=countrybean.getTranslation("Mustselectgeographiccode")%>...")
		return false;
		}	
	if (serial.value.length==0)
		{
		alert (" <%=countrybean.getTranslation("InvalidSerial")%>...")
		return false;
		}
	a=fechano.value;
	if (a<1)
		{
		alert ("<%=countrybean.getTranslation("Invalidyear")%>...")
		return false;
		}
	m=fechames.value;
	if (m>12)
		{
		alert ("<%=countrybean.getTranslation("Invalidmonth")%>...")
		return false;
		}
	d=fechadia.value;
	if (d>31)
		{
		alert ("<%=countrybean.getTranslation("Invalidday")%>...")
		return false;
		}
	if (di_comments.value.length>32750)
		{
		alert ("<%=countrybean.getTranslation("Comments_Too_Long")%> "+di_comments.value.length+" (max=32750)...")
		return false;
		}
	name0.value=level0.options[level0.selectedIndex].text;
	if (level1.selectedIndex>0)
		name1.value=level1.options[level1.selectedIndex].text;
	  else
		name1.value="";
	if (level2.selectedIndex>0)
		name2.value=level2.options[level2.selectedIndex].text;
	  else	
		name2.value="";
	}

return true;
}

// to be used with delete forms
function submitForm()
{
with (document.desinventar)
	{
    okDelCard.value="NOT_NULL";
	submit();	
	}
}

// -->
</script>

