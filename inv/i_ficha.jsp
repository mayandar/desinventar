<%!
String sBlankZero(int num)
{
return num==0?"":String.valueOf(num);
}

String sBlankZero(double num)
{
return num==0?"":webObject.formatDouble(num);
}
%>

<%
String sApprovedClass="bodylight"+woFicha.approved;

	// if no position is know, approximates via the regions object
	regiones rPlace=new regiones();
	int nGoogleZoom=5;
	String sLocationTitle=countrybean.getTranslation("APROXIMATE LOCATION");
	if (woFicha.latitude==0.0 && woFicha.longitude==0.0)
		{
		rPlace.codregion=woFicha.level2;
		int nrec=rPlace.getWebObject(con);
		if (nrec<1)
			{
			rPlace.codregion=woFicha.level1;
			nrec=rPlace.getWebObject(con);
			}
		else nGoogleZoom=8;
		if (nrec<1)
			{
			rPlace.codregion=woFicha.level0;
			nrec=rPlace.getWebObject(con);
			if (nrec>=0)
				nGoogleZoom=6;		
			}
		else nGoogleZoom=7;		
		}
	else
		{
		nGoogleZoom=10;
		sLocationTitle=countrybean.getTranslation("EVENT LOCATION");
		rPlace.ytext=woFicha.latitude;
		rPlace.xtext=woFicha.longitude;
		}
	// non GCS-WGS84	
	if (rPlace.ytext>90 || rPlace.ytext<-90 || rPlace.xtext>180 || rPlace.xtext<-180)
			{
			rPlace.ytext=0;
			rPlace.xtext=0;
			}
	

 String sLevelLayers="";
   for (int k=0; k<countrybean.level_map; k++)
   	sLevelLayers+=",level"+k;
   if (countrybean.imLayerMaps!=null)
     for (int k=0; k<countrybean.imLayerMaps.length; k++)
   		sLevelLayers+=",layer"+k;
%>
        <style type="text/css">
            #map {
                width: 100%;
                height: 100%;
                border: 1px solid black;
            }

            #text {
                position: absolute;
                bottom: 0px;
                left:0px;
                width: 512px;
            }
        </style>
<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyByVWfVCeED7LjjNRgxgTluLPGSenzMgAw&sensor=false"></script>
<script type="text/javascript">
// best to declare your map variable outside of the function so that you can access it from other functions
var map;
var geocoder;

function initialize() 
{
	geocoder = new google.maps.Geocoder();    		
    var latlng = new google.maps.LatLng(<%=rPlace.ytext%>,<%=rPlace.xtext%>);    
	var myOptions ={zoom: <%=nGoogleZoom%>,      
					center: latlng,      
					panControl: false,    zoomControl: true,    scaleControl: true,
					mapTypeId: google.maps.MapTypeId.ROADMAP
					};    
	map = new google.maps.Map(document.getElementById("map_canvas"),        myOptions);
}

// AUTO-REFRESH HOOK, EVERY MINUTE!!
setInterval(function(){ autosave(clave); }, 60000);

</script>


<input type='hidden' name='uu_id' id='uu_id' value='<%=htmlServer.htmlEncode(woFicha.uu_id)%>'>
<div class="bs">
  <table border="1" rules="cols" cellpadding="0" cellspacing="0" bordercolor="black" class="bs" width="1000">
       <tr class='<%=sApprovedClass%> bs'>
            <td class="bs"><!-- Header lines in light blue  -->
              <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                  <td class="bs" nowrap><%=countrybean.getTranslation("Serial")%>:
                    <INPUT name="serial" id="serial" onchange='autosave(serial)' value="<%=htmlServer.htmlEncode(woFicha.serial)%>" size="15" maxlength="15"></td>
                  <td class="bs" nowrap><%=countrybean.getTranslation("DateYMD")%>:
                    <INPUT NAME="fechano" id="fechano" onchange='autosave(fechano)'  style="WIDTH: 45px;" value="<%=sBlankZero(woFicha.fechano)%>" size="4" maxlength="4">
                    <INPUT NAME="fechames" id="fechames" onchange='autosave(fechames)' value="<%=sBlankZero(woFicha.fechames)%>" size="2" style="WIDTH: 22px;" maxlength="3">
                    <INPUT NAME="fechadia" id="fechadia" onchange='autosave(fechadia)' value="<%=sBlankZero(woFicha.fechadia)%>" size="2" style="WIDTH: 22px;" maxlength="3"></td>
                  <td class="bs" nowrap><%=countrybean.getTranslation("Duration")%>:
                    <INPUT NAME="duracion" id="duracion" onchange='autosave(duracion)'  style="WIDTH: 40px;" value="<%=sBlankZero(woFicha.duracion)%>" size="4" maxlength="4"></td>
                  <td class="bs" nowrap><%=countrybean.getTranslation("Source")%>:
                    <INPUT type='TEXT' size='40' maxlength='250' name='fuentes' id="fuentes" onchange='autosave(fuentes)' VALUE="<%=htmlServer.htmlEncode(woFicha.fuentes)%>"></td>
                  <td class="bs" nowrap><%=countrybean.getTranslation("Status")%>:
                    <select name='approved' id="approved" onchange='autosave(approved)'>
<% if (user.iusertype>=20) 
{%>                      <option value='0'<%=countrybean.strSelected(0,woFicha.approved)%>><%=countrybean.getTranslation("Approved")%></option>
<%}%>
                      <option value='1'<%=countrybean.strSelected(1,woFicha.approved)%>><%=countrybean.getTranslation("Draft")%></option>
                      <option value='2'<%=countrybean.strSelected(2,woFicha.approved)%>><%=countrybean.getTranslation("Review")%></option>
                      <option value='3'<%=countrybean.strSelected(3,woFicha.approved)%>><%=countrybean.getTranslation("Rejected")%></option>
                      <option value='4'<%=countrybean.strSelected(4,woFicha.approved)%>><%=countrybean.getTranslation("Support")%></option>
                    </select>
                 </td>
                </tr> 
              </table>
            </td>


            <td rowspan="6" bgcolor="#FFFFFF">
             <table border="0" cellpadding="0" cellspacing="0" width="350" height="400" id="map_canvasTable" bgcolor="#FFFFFF">
             <tr>
                <td  class='<%=sApprovedClass%> bs' id="map_cell" align="left"  valign="bottom" bgcolor="#ffffff" width="100%" height="100%" >
                 <strong><%=countrybean.getTranslation("Please locate aproximately the centroid of the disaster")%></strong><br/>
                 <font class="bss"> <%=countrybean.getTranslation("Right-click to position disaster.")%>&nbsp;<%=countrybean.getTranslation("google_explanation")%></font><br/>
                 <div id="map_canvas" style="width: 350px; height: 380px"></div>
                </td>
             </tr>
             <tr><td class="bss">
                  <%=countrybean.getTranslation("Latitude")%>:
                  <INPUT type="TEXT" size="12" name="latitude" id="latitude" onchange='autosave(latitude)' id="latitude" VALUE="<%=woFicha.latitude==0.0?"":woFicha.formatDouble(woFicha.latitude,-8)%>">
                  &nbsp;&nbsp;&nbsp;<%=countrybean.getTranslation("Longitude")%>:
                  <INPUT type="TEXT" size="12" name="longitude" id="longitude" onchange='autosave(longitude)' id="longitude" VALUE="<%=woFicha.longitude==0.0?"":woFicha.formatDouble(woFicha.longitude,-8)%>">
             </td></tr>
            </table>
             </td>


         </tr>
         <tr  class='<%=sApprovedClass%> bs'>
            <td class="bs">
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                  <td width="30%" class="bs"><%=htmlServer.htmlEncode(countrybean.asLevels[0])%>:
                    <SELECT name="level0"  id="level0" onchange="checkLevel0()">
                      <option value=""></option>
                      <%
						  stmt = con.createStatement ();
						  String sSql="Select lev0_cod,lev0_name,lev0_name_en  from lev0";
						  String sWhere="";
						  String sAnd=" where lev0_cod in (";
						  if (user.aLevel0[0]!=null)
						  	{
						    for (int i=0; i<user.aLevel0[0].size(); i++) 
								{
								String sCo=user.aLevel0[0].get(i).substring(0,user.aLevel0[0].get(i).indexOf(":"));
								if (sCo.equalsIgnoreCase(countrybean.countrycode))
									{
										sWhere+=sAnd+"'"+user.aLevel0[0].get(i).substring(user.aLevel0[0].get(i).indexOf(":")+1,user.aLevel0[0].get(i).length())+"'";
										sAnd=",";
									}															
								}
							if (sWhere.length()>0)
								sWhere+=")";
							}
						  sSql+=sWhere+" order by lev0_name"; 	
						  rset = stmt.executeQuery(sSql);
						  while (rset.next())
						  {
							String sCode = rset.getString("lev0_cod");
							out.print("\t<option value=\"" + htmlServer.htmlEncode(sCode) + "\"");
							if (woFicha.level0.equalsIgnoreCase(sCode))
							  out.print(" selected");
						   out.println(">" + htmlServer.htmlEncode(countrybean.getLocalOrEnglish(rset,"lev0_name","lev0_name_en")));
						  }
					%>
                    </select>
                  </td>
                  <td width="30%" class="bs"><%=htmlServer.htmlEncode(countrybean.asLevels[1])%>:
                    <input type='hidden' name='name0' id="name0" onchange='autosave(name0)' value="<%=htmlServer.htmlEncode(woFicha.name0)%>"/>
                    <SELECT name="level1" id="level1"  onchange="checkLevel1()">
                      <option value=''></option>
                      <% if (woFicha.level0.length()>0)
						   {
							  sSql="Select lev1_cod,lev1_name,lev1_name_en from lev1 where lev1_lev0='"+woFicha.check_quotes(woFicha.level0)+"'";
							  sWhere="";
						      sAnd=" and lev1_cod in (";
							  if (user.aLevel0[1]!=null)
								{
								for (int i=0; i<user.aLevel0[1].size(); i++) 
									{
									String sCo=user.aLevel0[1].get(i).substring(0,user.aLevel0[1].get(i).indexOf(":"));
									if (sCo.equalsIgnoreCase(countrybean.countrycode))
										{
											sWhere+=sAnd+"'"+user.aLevel0[1].get(i).substring(user.aLevel0[1].get(i).indexOf(":")+1,user.aLevel0[1].get(i).length())+"'";
											sAnd=",";
										}															
									}
								if (sWhere.length()>0)
									sWhere+=")";
								}							  
							  sSql+=" order by lev1_name";
							  rset = stmt.executeQuery(sSql);
							  while (rset.next())
							  {
								String sCode = rset.getString("lev1_cod");
								out.print("<option value='" + htmlServer.htmlEncode(sCode) + "'");
								if (woFicha.level1.equalsIgnoreCase(sCode))
								  out.print(" selected");
							   out.println(">" + htmlServer.htmlEncode(countrybean.getLocalOrEnglish(rset,"lev1_name","lev1_name_en")));
							  }
						 }%>
                    </select>
                  </td>
                  <td width="30%" class="bs"><%=htmlServer.htmlEncode(countrybean.asLevels[2])%> :
                    <input type='hidden' name='name1' id="name1" onchange='autosave(name1)' value="<%=htmlServer.htmlEncode(woFicha.name1)%>">
                    <SELECT name="level2" id="level2" onchange="jsGetLevel3()">
                      <option value=''></option>
					  <% if (woFicha.level1.length()>0)
                      {%><inv:selectLevel2 connection="<%= con %>" level1Code="<%=htmlServer.htmlEncode(woFicha.level1)%>"  selected="<%=htmlServer.htmlEncode(woFicha.level2)%>"/>
                      <%}
                    	rset.close();
                    	stmt.close();
                    	%>
                    </select>
                    <input type='hidden' name='name2' id="name2" onchange='autosave(name2)' value="<%=htmlServer.htmlEncode(woFicha.name2)%>"/>
                </td>
                </tr>
              </table> 
             </td> 
          </tr>
          <tr class='<%=sApprovedClass%> bs'>
            <td class="bs">
              <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                  <td class="bs"><%=countrybean.getTranslation("Event")%>:
                    <%
					 String sDisplayField="nombre";
					 if (countrybean.getDataLanguage().equals("EN"))
						sDisplayField="nombre_en";
					 %>
                    <SELECT name="evento" id="evento" onchange='autosave(evento)'>
                    <inv:select tablename='eventos' selected='<%=htmlServer.htmlEncode(woFicha.evento)%>' connection='<%= con %>' fieldname="<%=sDisplayField%>" codename='nombre' ordername='serial'/>
                    </select>
                  </td>
                 <td class="bs"><%=countrybean.getTranslation("Place")%>:
                    <INPUT type="TEXT" size="45" maxlength="60" name="lugar" id="lugar" onchange='autosave(lugar)' VALUE="<%=htmlServer.htmlEncode(woFicha.lugar)%>"/>
                  </td>
                  <td class="bs"><%=countrybean.getTranslation("GLIDEnumber")%>:
                    <INPUT type="TEXT" size="17" maxlength="30" name="glide" id="glide" onchange='autosave(glide)' VALUE="<%=htmlServer.htmlEncode(woFicha.glide)%>"/>
                  </td>
                </tr>
              </table>
            </td>
          </tr> 
          <tr class='<%=sApprovedClass%>'>
            <td class="bs"><!-- causes lines in light red  -->
              <hr/>
              <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                  <td class="bs"><%=countrybean.getTranslation("Cause")%>:
                    <%sDisplayField="causa";
if (countrybean.getDataLanguage().equals("EN"))
	sDisplayField="causa_en";
%>
                    <SELECT name="causa" id="causa" onchange='autosave(causa)'>
                      <option value=''></option>
                      <inv:select tablename='causas' selected='<%=woFicha.causa%>' connection='<%= con %>'    fieldname="<%=sDisplayField%>" codename='causa' ordername='causa'/>
                    </select>
                  </td>
                  <td class="bs"><%=countrybean.getTranslation("DescriptionCause")%>:
                    <INPUT type="TEXT" size="65" maxlength="60" name="descausa" id="descausa" onchange='autosave(descausa)' VALUE="<%=htmlServer.htmlEncode(woFicha.descausa)%>">
                  </td>
                </tr>
              </table>
              <hr/>
            </td>
          </tr>
          
          <tr class='<%=sApprovedClass%>'>
            <td class="bs">
              <b><i><font class='subTitle'><%=countrybean.getTranslation("EFFECTS")%></font></i></b>
            </td>  
          </tr>

          <tr class='<%=sApprovedClass%> bs'  id='basic_datacard'>
            <td class="bs" valign="top">

<%  // CELL WITH A DATA ENTRY TEMPLATE
String sHtmlFolder=getServletConfig().getServletContext().getRealPath("html")+"/";
String[] sTemplate={"datacard_","datacard_","datacard_UN","datacard_UN"};   // tries in order: datacard_ccc_ll, datacard_ccc, datacard_def_ll, datacard_def    
ArrayList alProcessedFields=null;
Dictionary dct = new Dictionary();
dct.nombre_campo="LIVING_DMGD_DWELLINGS"; // very unlikely defined outside sendai
dct.dbType=countrybean.dbType;
int nSendai=dct.getWebObject(con);
 
sTemplate[0]+=countrybean.countrycode.toUpperCase();
sTemplate[1]+=countrybean.countrycode.toUpperCase();
if (!countrybean.getLanguage().toLowerCase().equals("en"))
	{
	sTemplate[0]+="_"+countrybean.getLanguage().toLowerCase();
	sTemplate[2]+="_"+countrybean.getLanguage().toLowerCase();
	}
int iTemplate=0;
File tmpl=new File(sHtmlFolder+sTemplate[0]+".html");
while (iTemplate<3 && !tmpl.exists())
	tmpl=new File(sHtmlFolder+sTemplate[++iTemplate]+".html");

if (tmpl.exists() && nSendai>0)
{
//System.out.println("[DI9] using template: "+	sHtmlFolder+sTemplate[iTemplate]+".html");
woFicha.addExtensionHashMap(woExtension);
alProcessedFields=woFicha.processTemplate(sHtmlFolder+sTemplate[iTemplate]+".html",out, countrybean, con);	
}
else
{
alProcessedFields=new ArrayList();
%>
            
            <table cellspacing="0" cellpadding="0" border="0" width="100%" bordercolor="#FF0000">
                <tr>
                  <!-- Effects -->
                  <td class="bs"><!-- vars with checks -->
                    <table cellspacing="0" cellpadding="0" border="0" width="100%">
                      <tr>
                        <td class="bs" align="right" nowrap><%=countrybean.getTranslation("Deaths")%>:</td>
                        <td class="bs"><INPUT type="TEXT" size="6" maxlength="12" name="muertos" id="muertos" VALUE="<%=sBlankZero(woFicha.muertos)%>" onChange="chkMuertos();autosave(muertos,hay_muertos);"></td>
                        <td class="bs" align="left"><INPUT type="CHECKBOX" name="hay_muertos" id="hay_muertos" onchange='autosave(hay_muertos)' VALUE="-1" <%=woFicha.strChecked(woFicha.hay_muertos)%>></td>
                        <td class="bs" align="right" nowrap>&nbsp;<%=countrybean.getTranslation("Missing")%>: </td>
                        <td class="bs"><INPUT type="TEXT" size="6" maxlength="12" name="desaparece" id="desaparece"  VALUE="<%=sBlankZero(woFicha.desaparece)%>"  onChange="chkDesaparece();autosave(desaparece,hay_deasparece);"></td>
                        <td class="bs" align="left"><INPUT type="CHECKBOX" name="hay_deasparece" id="hay_deasparece" onchange='autosave(hay_deasparece)' VALUE="-1" <%=woFicha.strChecked(woFicha.hay_deasparece)%>></td>
                        <td class="bs" align="right" nowrap>&nbsp;<%=countrybean.getTranslation("Injured")%>: </td>
                        <td class="bs"><INPUT type="TEXT" size="6" maxlength="12" name="heridos" id="heridos" VALUE="<%=sBlankZero(woFicha.heridos)%>"  onChange=" chkHeridos();autosave(heridos,hay_heridos);"></td>
                        <td class="bs" align="left"><INPUT type="CHECKBOX" name="hay_heridos" id="hay_heridos" onchange='autosave(hay_heridos)' VALUE="-1" <%=woFicha.strChecked(woFicha.hay_heridos)%>></td>
                      </tr>
                      <tr>
                        <td class="bs" align="right"><%=countrybean.getTranslation("Affected")%>:</td>
                        <td class="bs"><INPUT type="TEXT" size="6" maxlength="12" name="afectados" id="afectados" onchange='autosave(afectados,hay_afectados)' id="afectados" VALUE="<%=sBlankZero(woFicha.afectados)%>"  onChange=" chkAfectados();autosave(afectados,hay_afectados);"></td>
                        <td class="bs" align="left"><INPUT type="CHECKBOX" name="hay_afectados" id="hay_afectados" onchange='autosave(hay_afectados)' VALUE="-1" <%=woFicha.strChecked(woFicha.hay_afectados)%>></td>
                        <td class="bs" align="right">&nbsp;<%=countrybean.getTranslation("Relocated")%>:</td>
                        <td class="bs"><INPUT type="TEXT" size="6" maxlength="12" name="reubicados" id="reubicados" VALUE="<%=sBlankZero(woFicha.reubicados)%>"  onChange="chkReubicados();autosave(reubicados,hay_reubicados);"></td>
                        <td class="bs" align="left"><INPUT type="checkbox" name="hay_reubicados" id="hay_reubicados" onchange='autosave(hay_reubicados)' VALUE="-1" <%=woFicha.strChecked(woFicha.hay_reubicados)%>></td>
                        <td class="bs" align="right" nowrap>&nbsp;<%=countrybean.getTranslation("AffectedHouses")%>.:</td>
                        <td class="bs"><INPUT type="TEXT" size="6" maxlength="12" name="vivafec" id="vivafec" VALUE="<%=sBlankZero(woFicha.vivafec)%>"  onChange="chkVivafec();autosave(vivafec,hay_vivafec);"></td>
                        <td class="bs" align="left"><INPUT type="CHECKBOX" name="hay_vivafec" id="hay_vivafec" onchange='autosave(hay_vivafec)' VALUE="-1" <%=woFicha.strChecked(woFicha.hay_vivafec)%>></td>
                      </tr>
                      <tr>
                        <td class="bs" align="right"><%=countrybean.getTranslation("Evacuated")%>:</td>
                        <td class="bs"><INPUT type="TEXT" size="6" maxlength="12" name="evacuados" id="evacuados" VALUE="<%=sBlankZero(woFicha.evacuados)%>"  onChange="chkEvacuados();autosave(evacuados,hay_evacuados);"></td>
                        <td class="bs" align="left"><INPUT type="CHECKBOX" name="hay_evacuados" VALUE="-1" <%=woFicha.strChecked(woFicha.hay_evacuados)%>></td>
                        <td class="bs" align="right">&nbsp;<%=countrybean.getTranslation("Victims")%>:</td>
                        <td class="bs"><INPUT type="TEXT" size="6" maxlength="12" name="damnificados" id="damnificados" VALUE="<%=sBlankZero(woFicha.damnificados)%>"  onChange="chkDamnificados();autosave(damnificados,hay_damnificados);"></td>
                        <td class="bs" align="left"><INPUT type="CHECKBOX" name="hay_damnificados" id="hay_damnificados" onchange='autosave(hay_damnificados)' VALUE="-1" <%=woFicha.strChecked(woFicha.hay_damnificados)%>></td>
                        <td class="bs" align="right" nowrap>&nbsp;<%=countrybean.getTranslation("DestroyedHouses")%>:</td>
                        <td class="bs"><INPUT type="TEXT" size="6" maxlength="12" name="vivdest" id="vivdest" VALUE="<%=sBlankZero(woFicha.vivdest)%>"  onChange="chkVivdest();autosave(vivdest,hay_vivdest);"></td>
                        <td class="bs" align="left"><INPUT type="CHECKBOX" name="hay_vivdest" id="hay_vivdest" onchange='autosave(hay_vivdest)' VALUE="-1" <%=woFicha.strChecked(woFicha.hay_vivdest)%>></td>
                      </tr>
                      <tr>
                        <td colspan=9><span class="subtitle"><%=countrybean.getTranslation("AffectedSectors")%></span></td>
                      </tr>
                    </table></td>
                  <td rowspan="2"><!-- with no checks -->
                    <table cellspacing="0" cellpadding="0" border="0" width="100%">
                      <tr>
                        <td class="bs" align="right" nowrap>&nbsp;<%=countrybean.getTranslation("Magnitude")%>:</td>
                        <td class="bs"><INPUT type="TEXT" size="26" maxlength="22" name="magnitud2" id="magnitud2" onchange='autosave(magnitud2)' VALUE="<%=htmlServer.htmlEncode(woFicha.magnitud2)%>"></td>
                      </tr>
                      <tr>
                        <td class="bs" align="right" nowrap>&nbsp;<%=countrybean.getTranslation("LossesLocal")%>:</td>
                        <td class="bs"><INPUT type="TEXT" size="11" maxlength="40" name="valorloc" id="valorloc" onchange='autosave(valorloc)' VALUE="<%=sBlankZero(woFicha.valorloc)%>"></td>
                      </tr>
                      <tr>
                        <td class="bs" align="right" nowrap>&nbsp;<%=countrybean.getTranslation("LossesUSD")%>:</td>
                        <td class="bs"><INPUT type="TEXT" size="11" maxlength="40" name="valorus" id="valorus" onchange='autosave(valorus)' VALUE="<%=sBlankZero(woFicha.valorus)%>"></td>
                      </tr>
                      <tr>
                        <td class="bs" align="right"><%=countrybean.getTranslation("Damagesinroads")%>: </td>
                        <td class="bs"><INPUT type="TEXT" size="8" maxlength="40" name="kmvias" id="kmvias"  VALUE="<%=sBlankZero(woFicha.kmvias)%>"  onChange="chkKmVias();autosave(kmvias,transporte)"></td>
                      </tr>
                      <tr>
                        <td class="bs" align="right" nowrap>&nbsp;<%=countrybean.getTranslation("Damagesincrops")%>:</td>
                        <td class="bs"><INPUT type="TEXT" size="8" maxlength="40" name="nhectareas" id="nhectareas" VALUE="<%=sBlankZero(woFicha.nhectareas)%>"  onChange="chkNhectareas();autosave(nhectareas,agropecuario);"></td>
                      </tr>
                      <tr>
                        <td class="bs" align="right">&nbsp;<%=countrybean.getTranslation("Catle")%>:</td>
                        <td class="bs"><INPUT type="TEXT" size="6" maxlength="12" name="cabezas" id="cabezas" VALUE="<%=sBlankZero(woFicha.cabezas)%>"  onChange="chkCabezas();autosave(cabezas,agropecuario);"></td>
                      </tr>
                      <tr>
                        <td class="bs" align="right">&nbsp;<%=countrybean.getTranslation("Educationcenters")%>:</td>
                        <td class="bs"><INPUT type="TEXT" size="6" maxlength="12" name="nescuelas" id="nescuelas" VALUE="<%=sBlankZero(woFicha.nescuelas)%>"  onChange="chkNescuelas();autosave(nescuelas,educacion);"></td>
                      </tr>
                      <tr>
                        <td class="bs" align="right">&nbsp;<%=countrybean.getTranslation("Hospitals")%>:</td>
                        <td class="bs"><INPUT type="TEXT" size="6" maxlength="12" name="nhospitales" id="nhospitales" VALUE="<%=sBlankZero(woFicha.nhospitales)%>"  onChange="chknHospitales();autosave(nhospitales,salud);"></td>
                      </tr>
                    </table>
                    </td>
                </tr>
                <tr>
                  <!-- Sectors -->
                  <td class="bs"><!-- vars with checks -->
                    <table witdh=100% cellspacing="0" cellpadding="0" border="0">
                      <tr>
                        <td class="bs" align="right"><INPUT  type="CHECKBOX" name="transporte" id="transporte" onchange='autosave(transporte)' VALUE="-1" <%=woFicha.strChecked(woFicha.transporte)%>></td>
                        <td class="bs"><%=countrybean.getTranslation("Transportation")%>&nbsp;</td>
                        <td class="bs" align="right"><INPUT type="CHECKBOX" name="comunicaciones" id="comunicaciones" onchange='autosave(comunicaciones)' VALUE="-1" <%=woFicha.strChecked(woFicha.comunicaciones)%>></td>
                        <td class="bs"><%=countrybean.getTranslation("Communications")%>&nbsp;</td>
                        <td class="bs" align="right"><INPUT  type="CHECKBOX" name="socorro" id="socorro" onchange='autosave(socorro)' VALUE="-1" <%=woFicha.strChecked(woFicha.socorro)%>></td>
                        <td class="bs"><%=countrybean.getTranslation("Relief")%>&nbsp;</td>
                      </tr>
                      <tr>
                        <td class="bs" align="right"><INPUT  type="CHECKBOX" name="agropecuario" id="agropecuario" onchange='autosave(agropecuario)' VALUE="-1" <%=woFicha.strChecked(woFicha.agropecuario)%>></td>
                        <td class="bs"><%=countrybean.getTranslation("Agriculture")%>&nbsp;</td>
                        <td class="bs" align="right"><INPUT  type="CHECKBOX" name="acueducto" id="acueducto" onchange='autosave(acueducto)' VALUE="-1" <%=woFicha.strChecked(woFicha.acueducto)%>></td>
                        <td class="bs"><%=countrybean.getTranslation("Water")%>&nbsp;&nbsp;</td>
                        <td class="bs" align="right"><INPUT  type="CHECKBOX" name="alcantarillado" id="alcantarillado" onchange='autosave(alcantarillado)' VALUE="-1" <%=woFicha.strChecked(woFicha.alcantarillado)%>></td>
                        <td class="bs"><%=countrybean.getTranslation("Sewerage")%>&nbsp;&nbsp;</td>
                      </tr>
                      <tr>
                        <td class="bs" align="right"><INPUT  type="CHECKBOX" name="energia" id="energia" onchange='autosave(energia)' VALUE="-1" <%=woFicha.strChecked(woFicha.energia)%>></td>
                        <td class="bs"><%=countrybean.getTranslation("Power")%>&nbsp;&nbsp;</td>
                        <td class="bs" align="right"><INPUT  type="CHECKBOX" name="industrias" id="industrias" onchange='autosave(industrias)' VALUE="-1" <%=woFicha.strChecked(woFicha.industrias)%>></td>
                        <td class="bs"><%=countrybean.getTranslation("Industrial")%>&nbsp;</td>
                        <td class="bs" align="right"><INPUT  type="CHECKBOX" name="educacion" id="educacion" onchange='autosave(educacion)' VALUE="-1" <%=woFicha.strChecked(woFicha.educacion)%>></td>
                        <td class="bs"><%=countrybean.getTranslation("Education")%>&nbsp;</td>
                      </tr>
                      <tr>
                        <td class="bs" align="right"><INPUT  type="CHECKBOX" name="hay_otros" id="hay_otros" onchange='autosave(hay_otros)' VALUE="-1" <%=woFicha.strChecked(woFicha.hay_otros)%>></td>
                        <td class="bs"><%=countrybean.getTranslation("Othersectors")%>&nbsp;&nbsp;</td>
                        <td class="bs" align="right"></td>
                        <td class="bs"></td>
                        <td class="bs" align="right"><INPUT  type="CHECKBOX" name="salud" id="salud" onchange='autosave(salud)' VALUE="-1" <%=woFicha.strChecked(woFicha.salud)%>></td>
                        <td class="bs"><%=countrybean.getTranslation("Health")%></td>
                      </tr>
                    </table>
                  </td>
             </tr>
             <tr class='<%=sApprovedClass%> bs' id='basic_datacard1'>
                <td class="bs" colspan='2'><%=countrybean.getTranslation("OtherLosses")%>:
                  <INPUT type="TEXT" size="60" maxlength="60" name="otros" id="otros" onchange='autosave(otros)' VALUE="<%=htmlServer.htmlEncode(woFicha.otros)%>">
                  <br>
                  <hr/>
                </td>
             </tr>
              <tr class='<%=sApprovedClass%>' id='basic_datacard2'>
                <td class="bs" colspan='2'><!-- Comments lines in light blue  -->
                  <strong><%=countrybean.getTranslation("Comments")%></strong>:<br>
                  <TEXTAREA rows="4" name="di_comments" id="di_comments" onchange='autosave(di_comments)' cols="100"><%=htmlServer.htmlEncode(woFicha.di_comments)%></textarea>
                </td>
              </tr>
              <tr class='<%=sApprovedClass%>'>
                <td align="center"><table border="0" cellpadding="0" cellspacing="0" width="40%">
                    <tr>
                      <td class="bs"><%=countrybean.getTranslation("By")%>:
                        <INPUT type="TEXT" size="13" maxlength="12" name="fechapor" id="fechapor" onchange='autosave(fechapor)' VALUE="<%=htmlServer.htmlEncode(woFicha.fechapor.length()>0?woFicha.fechapor:user.suserid)%>"></td>
                      <td class="bs"><%=countrybean.getTranslation("Date")%>:
                        <INPUT type="TEXT" size="10" maxlength="10" name="fechafec" id="fechafec" onchange='autosave(fechafec)' VALUE="<%=htmlServer.htmlEncode(woFicha.fechafec)%>"></td>
                    </tr>
                  </table>
                 </td>
              </tr>
        </table>
		</td>
        <%}%>
		<!-- END OF CELL WITH EFFECTS/TEMPLATE -->            
    </tr>
    <tr>
      <td class="bs" colspan=2>
<%
int nTabActive=0;
String[] sTabNames=new String[woExtension.vTabs.size()];
String[] sTabIcons=new String[woExtension.vTabs.size()];
String[] sTabLinks=new String[woExtension.vTabs.size()];
for (int k = 0; k < woExtension.vTabs.size(); k++)
    {
    extensiontabs tab = (extensiontabs) woExtension.vTabs.get(k);
	sTabNames[k]=countrybean.getLocalOrEnglish(tab.svalue,tab.svalue_en);
	sTabIcons[k]="";
	sTabLinks[k]="javascript:openTab("+k+")";
	}
 
%>
        <%@ include file="/util/tabs_ext.jspf" %>
        <% 
for (int ktab = 0; ktab < woExtension.vTabs.size(); ktab++)
{%>
        <div id="tab_<%=ktab%>" style="display:none;">
          <table cellpadding="1" cellspacing="0" border="0" rules="none" width="100%" class="<%=sTabActiveColor%>">
            <%  // allocates a dictionary object to read each record
  dct = new Dictionary();
  for (int k = 0; k < woExtension.vFields.size(); k++)
     {
	 boolean bFound=false;
	 boolean bSelected=false;
	 dct = (Dictionary) woExtension.vFields.get(k);
	 if (!alProcessedFields.contains(dct.nombre_campo))
	   if ((dct.tabnumber==ktab+1) || (dct.tabnumber==0 && ktab==woExtension.vTabs.size()-1))   
	    {%>
            <tr  class='<%=sApprovedClass%>'>
              <td align="right" class=bgLight width='300'><%=htmlServer.htmlEncode(countrybean.getLocalOrEnglish(dct.label_campo,dct.label_campo_en))%>:&nbsp;</td>
              <td align="left" class=bgLightLight><%switch (dct.fieldtype)
				  	{
					case extension.YESNO:
						%>
                &nbsp;
                <input name='<%=dct.nombre_campo%>' type='checkbox' value="1" <%=dct.strChecked((int)dct.dNumericValue)%>  id='<%=dct.nombre_campo%>' onchange="autosave(<%=dct.nombre_campo%>)">
                <%
						break;
					case extension.LIST:
						%>
                &nbsp;
                <select name='<%=dct.nombre_campo%>' id='<%=dct.nombre_campo%>' onchange="autosave(<%=dct.nombre_campo%>)">
					<option value='0'></option>
                  <%
						for (int ilist=0; ilist<dct.codes.size(); ilist++)
						{
							bSelected=false;
							extensioncodes ecList=(extensioncodes)(dct.codes.get(ilist));			
							if (ecList.code_value.equals(dct.sValue))
								{
								bFound=true;
								bSelected=true;
								}
							out.print("<option value='"+ecList.code_value+"'"+dct.strSelected(bSelected)+">"+htmlServer.htmlEncode(countrybean.getLocalOrEnglish(ecList.svalue,ecList.svalue_en))+"</option>");
						}
						if (!bFound && dct.sValue.length()>0 && !dct.sValue.equals("0")) // safeguard for extraneous values existing prior to codes
						   out.print("<option value='"+dct.sValue+"' selected>"+dct.sValue+"</option>");						
						%>
                </select>
                <%
						break;
					case extension.CHOICE:
						for (int ilist=0; ilist<dct.codes.size(); ilist++)
						{
							bSelected=false;
							extensioncodes ecList=(extensioncodes)(dct.codes.get(ilist));			
							if (ecList.code_value.equals(dct.sValue))
								{
								bFound=true;
								bSelected=true;
								}
						%>
                &nbsp;
                <input name='<%=dct.nombre_campo%>' type='radio' value="<%=ecList.code_value%>" id='<%=dct.nombre_campo%>' onchange="autosave(<%=dct.nombre_campo%>)"<%=dct.strChecked(bSelected)%>>
                <%=htmlServer.htmlEncode(countrybean.getLocalOrEnglish(ecList.svalue,ecList.svalue_en))%>
                <%
						}
						if (!bFound && dct.sValue.length()>0 && !dct.sValue.equals("0")){
						%>
                &nbsp;
                <input name='<%=dct.nombre_campo%>' type='radio' value="<%=dct.sValue%>" id='<%=dct.nombre_campo%>' onchange="autosave(<%=dct.nombre_campo%>)" checked>
                <%=dct.sValue%>
                <%
						}
						break;
					case extension.INTEGER:
				  		%>
                &nbsp;
                <input name='<%=dct.nombre_campo%>' id='<%=dct.nombre_campo%>' onchange="autosave(<%=dct.nombre_campo%>)" type='text' value="<%=sBlankZero((int)dct.dNumericValue)%>" size='10' maxlength='10'>
                <%
						break;
					case extension.FLOATINGPOINT:
  			           %>
                &nbsp;
                <input name='<%=dct.nombre_campo%>' id='<%=dct.nombre_campo%>' onchange="autosave(<%=dct.nombre_campo%>)" type='text' value="<%=dct.dNumericValue==0.0?"":woExtension.formatDouble(dct.dNumericValue,-4)%>" size='<%=Math.min(dct.lon_x + 1, 15)%>' maxlength='20'>
                <%
		               break;
					case extension.CURRENCY:
  			           %>
                &nbsp;
                <input name='<%=dct.nombre_campo%>' id='<%=dct.nombre_campo%>' onchange="autosave(<%=dct.nombre_campo%>)" type='text' value="<%=sBlankZero(dct.dNumericValue)%>" size='<%=Math.min(dct.lon_x + 1, 15)%>' maxlength='20'>
                <%
		               break;
					case extension.DATETIME:
				        %>
                &nbsp;
                <input name='<%=dct.nombre_campo%>' id='<%=dct.nombre_campo%>' onchange="autosave(<%=dct.nombre_campo%>)" type='text' value="<%=woExtension.strDate(dct.sValue)%>" size='12' maxlength='12'>
                <%
					   break;
					case extension.MEMO:
						%>
                &nbsp;
                <textarea name='<%=dct.nombre_campo%>' id='<%=dct.nombre_campo%>' onchange="autosave(<%=dct.nombre_campo%>)" cols=60 rows=3><%=htmlServer.htmlEncode(dct.sValue)%></textarea>
                <%
						break;
				    default:  
				       	%>
                &nbsp;
                <input name='<%=dct.nombre_campo%>' id='<%=dct.nombre_campo%>' onchange="autosave(<%=dct.nombre_campo%>)" type='text' value="<%=htmlServer.htmlEncode(dct.sValue)%>" size='<%=Math.min(dct.lon_x + 1, 50)%>' maxlength='<%=dct.lon_x%>'>
                <%
		            }%>
              </td>
            </tr>
            <%} /* if in this tab*/ 
	} /* for each field */%>
            <tr>
              <td class="bs"></td>
              <td class="bs"></td>
            </tr>
          </table>
        </div>
        <%} // for each tab
%>
      </td>
    </tr>
<%
						  stmt = con.createStatement ();
						  sSql="Select * from media_file where iclave="+woFicha.clave+" order by imedia";
						  rset=stmt.executeQuery(sSql);
  						  MediaFile  woMedia=new MediaFile();
						  String sLengthControl="";
						  while (rset.next())
						  {
							woMedia.loadWebObject(rset);
						    String sFile_extension=woMedia.media_file.substring(woMedia.media_file.lastIndexOf(".")+1).toLowerCase();
							String sFilename=countrybean.countrycode+"_"+woMedia.imedia+"."+sFile_extension;

							%>	  
    <tr id='<%="Row_"+woMedia.imedia%>'>
      <td class="bs" colspan=2><br/>
<%							
							String[] sIconShown={"link.jpg","msword.png","msexcel.png","mspowerpoint.png","pdf.jpg","blank.jpg"
							                               ,"video_logo__normal.jpg","link.jpg","text.png","zip.png","link.jpg","link.jpg","link.jpg"};
							switch (woMedia.media_type)
								{
									case 1:
									case 2:
									case 3:
									case 4:
									case 6:
									case 7:
									case 8:
									case 9:
										out.println("<br/><a href='/DesInventar/MediaServer?media="+sFilename+"' target='_blank'><img src='/DesInventar/images/"+sIconShown[woMedia.media_type]+"' border=0 width='30'>&nbsp;&nbsp;"
										            +countrybean.getLocalOrEnglish(woMedia.media_title,woMedia.media_title_en)+"</a>"
										            +"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:deleteImage("+woMedia.imedia+")'>[DELETE]</a>");
										break;
									case 5:
										out.println("<br/><a href='/DesInventar/media/"+sFilename+"' target='_blank'><img id='img"+woMedia.imedia+"' src='/DesInventar/media/"+sFilename+"'/ border='0' ></a><br/>"+countrybean.getLocalOrEnglish(woMedia.media_title,woMedia.media_title_en)
													+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:deleteImage("+woMedia.imedia+")'>[DELETE]</a>");
										sLengthControl+="if (document.getElementById('img"+woMedia.imedia+"').height>500) document.getElementById('img"+woMedia.imedia+"').height=500;\n";										
										break;
								}
							if ((woMedia.media_description+woMedia.media_description_en).length()>0)
								out.println("<br/>"+countrybean.getLocalOrEnglish(woMedia.media_description,woMedia.media_description_en));
							if (woMedia.media_link.length()>0)
								out.println("<br/>"+"<a href='"+woMedia.media_link+"' target='_blank'>"+woMedia.media_link+"</a>");										
%>								
      </td>
    </tr>
<%						  }
%>
  </table>
  
</div>

<div  name="saving" id="saving" style="position:absolute; left:550px; top:50px; display:block; visibility:hidden; border:medium; background-color:#999"><h2>&nbsp;Saving...&nbsp;</h2></div>

<script language="JavaScript">
var bConnected2Internet=true;
var marker;
<%= sLengthControl %>

var nCurrentTab=0;
function openTab(ntab)
{
document.getElementById("tab_"+nCurrentTab).style.display='none';
document.getElementById("td_"+nCurrentTab).className='<%=sTabInactiveColor%>';
document.getElementById("link_"+nCurrentTab).className='<%=sTabTextInactiveColor%>';
nCurrentTab=ntab;
document.getElementById("tab_"+nCurrentTab).style.display='block';
document.getElementById("td_"+nCurrentTab).className='<%=sTabActiveColor%>';
document.getElementById("link_"+nCurrentTab).className='<%=sTabTextActiveColor%>';
}
openTab(0);


var iLev=-1;  // ready for next
var sLocation="";
var apAddresses=new Array(12);
var sCountry="<%=countrybean.countryname%>";



apAddresses[++iLev]="";

apAddresses[++iLev]="<%=EncodeUtil.jsEncode(woFicha.name0)%>";

<%int iLev=0;
  if (woFicha.name1.length()>0){%>
   apAddresses[++iLev]="<%=EncodeUtil.jsEncode(woFicha.name1)%>, <%=EncodeUtil.jsEncode(woFicha.name0)%>";
<%}
  if (woFicha.name2.length()>0){%>
  apAddresses[++iLev]="<%=EncodeUtil.jsEncode(woFicha.name2)%>, <%=EncodeUtil.jsEncode(woFicha.name0)%>";
  apAddresses[++iLev]="<%=EncodeUtil.jsEncode(woFicha.name2)%>, <%=EncodeUtil.jsEncode(woFicha.name1)%>, <%=EncodeUtil.jsEncode(woFicha.name0)%>";
<%}
  if (woFicha.lugar.length()>0){%>
  apAddresses[++iLev]="<%=EncodeUtil.jsEncode(woFicha.lugar)%>, <%=EncodeUtil.jsEncode(woFicha.name0)%>";   
<%	if (woFicha.name1.length()>0){%>
  apAddresses[++iLev]="<%=EncodeUtil.jsEncode(woFicha.lugar)%>, <%=EncodeUtil.jsEncode(woFicha.name0)%>";	
  apAddresses[++iLev]="<%=EncodeUtil.jsEncode(woFicha.lugar)%>, <%=EncodeUtil.jsEncode(woFicha.name1)%>, <%=EncodeUtil.jsEncode(woFicha.name0)%>";
	<%}
	if (woFicha.name2.length()>0){%>
  apAddresses[++iLev]="<%=EncodeUtil.jsEncode(woFicha.lugar)%>, <%=EncodeUtil.jsEncode(woFicha.name2)%>, <%=EncodeUtil.jsEncode(woFicha.name0)%>";
  apAddresses[++iLev]="<%=EncodeUtil.jsEncode(woFicha.lugar)%>, <%=EncodeUtil.jsEncode(woFicha.name2)%>, <%=EncodeUtil.jsEncode(woFicha.name1)%>, <%=EncodeUtil.jsEncode(woFicha.name0)%>";
	 <%}
  }%>



function build_locations()
{
iLev=-1;  // ready for next

apAddresses[++iLev]="";

with (document.desinventar)
	{

//	apAddresses[++iLev]=sCountry;
	
	apAddresses[++iLev]=level0.options[level0.selectedIndex].text;
	
	if (level1.selectedIndex>=0)
		{
		apAddresses[++iLev]=level1.options[level1.selectedIndex].text+", "+level0.options[level0.selectedIndex].text;
		if (level2.selectedIndex>=0)
			{
			apAddresses[++iLev]=level2.options[level2.selectedIndex].text+", "+level0.options[level0.selectedIndex].text;
			apAddresses[++iLev]=level2.options[level2.selectedIndex].text+", "+level1.options[level1.selectedIndex].text+", "+level0.options[level0.selectedIndex].text;
			}
		}
	}
nextsLocation();
}


var request;
function checkResults()
{
if (request.readyState==4)
  {// 4 = "loaded"
  if (request.status==200)
    {// 200 = OK
	// do nothing
    }
  else
    {
    // alert("Problem updating coords.. data");
    }
  // continues geocoding.. alert ("continues geocoding..");
  nextsLocation();
  } 
}
 
 
var not_found="";

function nextsLocation()
{
 // move to next (either next location or higher level in same location)
 sLocation="";
 if (iLev>=0)
 	{
	 sLocation=apAddresses[iLev];
	 iLev--;
 	 if (sCountry.indexOf("World")<0 && sCountry.indexOf("Universe")<0 && sCountry.indexOf("Global")<0)
	 	{
		 if (sLocation.length>0)
			sLocation+=", "
		 sLocation+=sCountry;
		}
	 // alert ("starts new geocoding.."+sLocation+" l="+iLev);
     geocoder.geocode({ 'address': sLocation}, geocodePlace );
	}	
}

function drag(event)
{
with (document.desinventar)
	{
	latitude.value=event.latLng.lat();
	longitude.value=event.latLng.lng();
	}
}

function drag_drop(event)
{
with (document.desinventar)
	{
	latitude.value=event.latLng.lat();
	longitude.value=event.latLng.lng();
	autosave(latitude,longitude);
	}

}

function marker_click(event)
{
with (document.desinventar)
	{
	latitude.value=event.latLng.lat();
	longitude.value=event.latLng.lng();
	autosave(latitude,longitude);
	}
if (marker)
   marker.setMap(null);
marker = new google.maps.Marker({map:map, position: event.latLng, title:sLocation, draggable: true});
google.maps.event.addListener(marker, 'drag', drag);
google.maps.event.addListener(marker, 'dragend', drag_drop); 
}


function geocodePlace(results, status) 
{  

 //alert ("receives geocoding..");

 if (status == google.maps.GeocoderStatus.OK) // process did start, check the result.
     {
 	 // alert ("found:["+iLev+"] "+sLocation);
   	 // not_found+= "<br>OK: "+iLev+"] "+sLocation;
 	 with (document.desinventar)
		{
	 	latitude.value=results[0].geometry.location.lat();
		longitude.value=results[0].geometry.location.lng();
		autosave(latitude,longitude);
		}
     if (marker)
	   marker.setMap(null);
     marker = new google.maps.Marker({map:map, position: results[0].geometry.location, title:sLocation, draggable: true});
	 google.maps.event.addListener(marker, 'drag', drag);
	 google.maps.event.addListener(marker, 'dragend', drag_drop);
	 if (!map.getBounds().contains(marker.getPosition())) 
		{
        map.panTo(marker.getPosition());
        if (!map.getBounds().contains(marker.getPosition()))
		    {
            map.zoomOut();
            } 
        }
	 // move to next location
	 iLev=0;
	 }	  
 else if (status == 'OVER_QUERY_LIMIT') // wait half second, retry...
     {
	 setTimeout(function(){ geocoder.geocode({ 'address': sLocation}, geocodePlace );}); 
	 }	  
 else 
   {
   // alert ("not found: "+sLocation+"  stat="+status);
   if (iLev==0)
   		{
     	not_found+= "<br>NF: ["+iLev+"] "+sLocation;
   	    //alert (not_found);
		}
	nextsLocation();
	}
		   
}

// checks if there is Internet, and if so, it tries google geo-location
function doConnectFunction() 
{
// Internet is available, display map
bConnected2Internet=true;
initialize();
google.maps.event.addListener(map, 'rightclick', marker_click);
<% if (rPlace.ytext!=0.0 || rPlace.xtext!=0.0){%>
   var FinalLoc=new google.maps.LatLng(<%=rPlace.ytext%>,<%=rPlace.xtext%>);
   //map.removeOverlay(marker);
   marker = new google.maps.Marker({map:map, position: FinalLoc , title:"<%=sLocationTitle%>", draggable: true});
   google.maps.event.addListener(marker, 'drag', drag);
   google.maps.event.addListener(marker, 'dragend', drag_drop); 
<%}%>
// starts geocoding, only if the record doesnt come with a location which must be respected
<% if (woFicha.latitude==0.0 && woFicha.latitude==0.0){%>
nextsLocation();
<%}%>
}
function doNoConnectFunction() {
// no connection to Internet 
bConnected2Internet=false;
}



function imageErased(ev)
{
	alert('<%=countrybean.getTranslation("Media removed..")%>');
}


function deleteImage(imedia)
{
with (document.desinventar)
  {
	EraseServerUrl="/DesInventar/inv/mediaeraser.jsp?imedia="+imedia;
	sendHttpRequest("GET", EraseServerUrl, imageErased);   
    document.getElementById("Row_"+imedia).style.display='none';
	}
}


var i = new Image();
i.onload = doConnectFunction;
i.onerror = doNoConnectFunction;
// CHANGE IMAGE URL TO IMAGE WE KNOW IS LIVE. Append random() to override possibility of image coming from cache
i.src = 'https://www.desinventar.net/images/at.png?d=' + Math.random();



</script>

