<link href="../html/desinventar.css" rel="stylesheet" type="text/css" />
<div class="bs">
  <table border="1" cellpadding="1" cellspacing="1" bordercolor="black" class="bs" width="950">
          <tr class="bodymedlight">
            <td class="bs">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
             <b><i><font class='subTitle'><%=countrybean.getTranslation("Target Variable: ")%></font></i></b>
             <select name="target_var" id="target_var">
             <option value=""></option>
             <option value="valorus"<%=dct.strSelected("valorus",sTargetVariable)%>><%=countrybean.getTranslation("LossesUSD")%></option>
             <option value="valorloc"<%=dct.strSelected("valorloc",sTargetVariable)%>><%=countrybean.getTranslation("LossesLocal")%></option>

<%     for (int k = 0; k < woExtension.vFields.size(); k++)
     {
	 dct = (Dictionary) woExtension.vFields.get(k);
	 if (dct.fieldtype==extension.INTEGER  ||
		 dct.fieldtype==extension.FLOATINGPOINT  ||
		 dct.fieldtype==extension.CURRENCY)		 
			{%>
             <option value="<%=dct.nombre_campo%>"<%=dct.strSelected(dct.nombre_campo,sTargetVariable)%>><%=htmlServer.htmlEncode(countrybean.getLocalOrEnglish(dct.label_campo,dct.label_campo_en))%></option>
			<%}
     }%>
             </select>
            </td>
          </tr>  
          <tr class='bodymedlight'>
            <td class="bs">
            </td>
          </tr>
          <tr class='bodymedlight'>
            <td class="bs"><!-- Effects lines in light yellow  --> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              <b><i><font class='subTitle'><%=countrybean.getTranslation("Enter $ UNIT VALUE factor for each type of impact")%></font></i></b>
            </td>
          </tr>
          <tr class='bodymedlight bs'  id='basic_datacard' align="left">
            <td class="bs">
              <table cellspacing="0" cellpadding="0" border="0" width="100%">
                <tr>
                  <!-- Effects -->
                  <td class="bs"><!-- vars with checks -->
                    <table cellspacing="0" cellpadding="0" border="0" width="100%">
                      <tr>
                        <td class="bs" align="right" nowrap><%=countrybean.getTranslation("Deaths")%>:</td>
                        <td class="bs"><INPUT type="TEXT" size="6" maxlength="8"name="muertos" VALUE="<%=woFicha.muertos%>" onChange=" chkMuertos()"></td>
                        <td class="bs" align="right" nowrap>&nbsp;<%=countrybean.getTranslation("Missing")%>: </td>
                        <td class="bs"><INPUT type="TEXT" size="6" maxlength="8" name="desaparece" VALUE="<%=woFicha.desaparece%>"  onChange=" chkDesaparece()"></td>
                        <td class="bs" align="right" nowrap>&nbsp;<%=countrybean.getTranslation("Injured")%>: </td>
                        <td class="bs"><INPUT type="TEXT" size="6" maxlength="8" name="heridos" VALUE="<%=woFicha.heridos%>"  onChange=" chkHeridos()"></td>
                      </tr>
                      <tr>
                        <td class="bs" align="right"><%=countrybean.getTranslation("Affected")%>:</td>
                        <td class="bs"><INPUT type="TEXT" size="6" maxlength="8" name="afectados" VALUE="<%=woFicha.afectados%>"  onChange=" chkAfectados()"></td>
                        <td class="bs" align="right">&nbsp;<%=countrybean.getTranslation("Relocated")%>:</td>
                        <td class="bs"><INPUT type="TEXT" size="6" maxlength="8" name="reubicados" VALUE="<%=woFicha.reubicados%>"  onChange=" chkReubicados()"></td>
                        <td class="bs" align="right" nowrap>&nbsp;<%=countrybean.getTranslation("AffectedHouses")%>.:</td>
                        <td class="bs"><INPUT type="TEXT" size="6" maxlength="8" name="vivafec" VALUE="<%=woFicha.vivafec%>"  onChange=" chkVivafec()"></td>
                      </tr>
                      <tr>
                        <td class="bs" align="right"><%=countrybean.getTranslation("Evacuated")%>:</td>
                        <td class="bs"><INPUT type="TEXT" size="6" maxlength="8" name="evacuados" VALUE="<%=woFicha.evacuados%>"  onChange=" chkEvacuados()"></td>
                        <td class="bs" align="right">&nbsp;<%=countrybean.getTranslation("Victims")%>:</td>
                        <td class="bs"><INPUT type="TEXT" size="6" maxlength="8" name="damnificados" VALUE="<%=woFicha.damnificados%>"  onChange=" chkDamnificados()"></td>
                        <td class="bs" align="right" nowrap>&nbsp;<%=countrybean.getTranslation("DestroyedHouses")%>:</td>
                        <td class="bs"><INPUT type="TEXT" size="6" maxlength="8" name="vivdest" VALUE="<%=woFicha.vivdest%>"  onChange=" chkVivdest()"></td>
                      </tr>
                      <tr>
                        <td colspan=6>&nbsp;</td>
                      </tr>
                      <tr>
                        <td class="bs" align="right"><%=countrybean.getTranslation("Transportation")%>:</td>
                        <td class="bs"><INPUT  type="TEXT" size="6" maxlength="12" name="transporte" VALUE="<%=woFicha.transporte%>"></td>
                        <td class="bs" align="right"><%=countrybean.getTranslation("Communications")%>:</td>
                        <td class="bs"><INPUT type="TEXT" size="6" maxlength="12" name="comunicaciones" VALUE="<%=woFicha.comunicaciones%>"></td>
                        <td class="bs" align="right"><%=countrybean.getTranslation("Relief")%>:</td>
                        <td class="bs"><INPUT  type="TEXT" size="6" maxlength="12" name="socorro" VALUE="<%=woFicha.socorro%>"></td>
                      </tr>
                      <tr>
                        <td class="bs" align="right"><%=countrybean.getTranslation("Power")%>:</td>
                        <td class="bs"><INPUT  type="TEXT" size="6" maxlength="12" name="energia" VALUE="<%=woFicha.energia%>"></td>
                        <td class="bs" align="right"><%=countrybean.getTranslation("Water")%>:</td>
                        <td class="bs"><INPUT  type="TEXT" size="6" maxlength="12" name="acueducto" VALUE="<%=woFicha.acueducto%>"></td>
                        <td class="bs" align="right"><%=countrybean.getTranslation("Sewerage")%>:</td>
                        <td class="bs"><INPUT  type="TEXT" size="6" maxlength="12" name="alcantarillado" VALUE="<%=woFicha.alcantarillado%>"></td>
                      </tr>
                      <tr>
                        <td class="bs"></td>
                        <td class="bs"></td>
                        <td class="bs" align="right"><%=countrybean.getTranslation("Industrial")%>:</td>
                        <td class="bs"><INPUT  type="TEXT" size="6" maxlength="12" name="industrias" VALUE="<%=woFicha.industrias%>"></td>
                        <td class="bs" align="right"><%=countrybean.getTranslation("Othersectors")%>:</td>
                        <td class="bs"><INPUT  type="TEXT" size="6" maxlength="12" name="hay_otros" VALUE="<%=woFicha.hay_otros%>"></td>
                      </tr>
                    </table>
                    </td>
                  <td rowspan="2"><!-- with no checks -->
                    <table cellspacing="0" cellpadding="0" border="0" width="100%">
                      <tr>
                        <td class="bs" align="right" nowrap>&nbsp;<%=countrybean.getTranslation("LossesLocal")%>:</td>
                        <td class="bs"><INPUT type="TEXT" size="11" maxlength="40" name="valorloc" VALUE="<%=webObject.formatDouble(woFicha.valorloc)%>"></td>
                      </tr>
                      <tr>
                        <td class="bs" align="right" nowrap>&nbsp;<%=countrybean.getTranslation("LossesUSD")%>:</td>
                        <td class="bs"><INPUT type="TEXT" size="11" maxlength="40" name="valorus" VALUE="<%=webObject.formatDouble(woFicha.valorus)%>"></td>
                      </tr>
                      <tr>
                        <td class="bs" align="right"><%=countrybean.getTranslation("Damagesinroads")%>: </td>
                        <td class="bs"><INPUT type="TEXT" size="8" maxlength="40" name="kmvias" VALUE="<%=woFicha.kmvias%>"  onChange=" chkKmVias()"></td>
                      </tr>
                      <tr>
                        <td class="bs" align="right" nowrap>&nbsp;<%=countrybean.getTranslation("Damagesincrops")%>:</td>
                        <td class="bs"><INPUT type="TEXT" size="8" maxlength="40" name="nhectareas" VALUE="<%=webObject.formatDouble(woFicha.nhectareas)%>"  onChange=" chkNhectareas()"></td>
                      </tr>
                      <tr>
                        <td class="bs" align="right">&nbsp;<%=countrybean.getTranslation("Catle")%>:</td>
                        <td class="bs"><INPUT type="TEXT" size="6" maxlength="8" name="cabezas" VALUE="<%=woFicha.cabezas%>"  onChange=" chkCabezas()"></td>
                      </tr>
                      <tr>
                        <td class="bs" align="right">&nbsp;<%=countrybean.getTranslation("Educationcenters")%>:</td>
                        <td class="bs"><INPUT type="TEXT" size="6" maxlength="8" name="nescuelas" VALUE="<%=woFicha.nescuelas%>"  onChange=" chkNescuelas()"></td>
                      </tr>
                      <tr>
                        <td class="bs" align="right">&nbsp;<%=countrybean.getTranslation("Hospitals")%>:</td>
                        <td class="bs"><INPUT type="TEXT" size="6" maxlength="8" name="nhospitales" VALUE="<%=woFicha.nhospitales%>"  onChange=" chknHospitales()"></td>
                      </tr>
                    </table>
                   </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
       </td>
    </tr>
  </table>  
  <table border="1" cellpadding="1" cellspacing="1" bordercolor="black" class="bs" width="950">
    <tr>
      <td class="bs"><%
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
  for (int k = 0; k < woExtension.vFields.size(); k++)
     {
	 boolean bFound=false;
	 boolean bSelected=false;
	 dct = (Dictionary) woExtension.vFields.get(k);
	 if (dct.fieldtype==extension.YESNO  ||
	     dct.fieldtype==extension.INTEGER  ||
		 dct.fieldtype==extension.FLOATINGPOINT  ||
		 dct.fieldtype==extension.CURRENCY)		 
	   if ((dct.tabnumber==ktab+1) || (dct.tabnumber==0 && ktab==woExtension.vTabs.size()-1))   
	    {%>
            <tr>
              <td align="right" class=bgLight width='300'><%=htmlServer.htmlEncode(countrybean.getLocalOrEnglish(dct.label_campo,dct.label_campo_en))%>:&nbsp;</td>
              <td align="left" class=bgLightLight><%switch (dct.fieldtype)
				  	{
					case extension.YESNO:
						%>
                &nbsp;
                <input name='<%=dct.nombre_campo%>' type='checkbox' value="1" <%=dct.strChecked((int)dct.dNumericValue)%>>
                <%
						break;
					case extension.LIST:
						%>
                &nbsp;
                <select name='<%=dct.nombre_campo%>'>
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
                <input name='<%=dct.nombre_campo%>' type='radio' value="<%=ecList.code_value%>"<%=dct.strChecked(bSelected)%>>
                <%=htmlServer.htmlEncode(countrybean.getLocalOrEnglish(ecList.svalue,ecList.svalue_en))%>
                <%
						}
						if (!bFound && dct.sValue.length()>0 && !dct.sValue.equals("0")){
						%>
                &nbsp;
                <input name='<%=dct.nombre_campo%>' type='radio' value="<%=dct.sValue%>" checked>
                <%=dct.sValue%>
                <%
						}
						break;
					case extension.INTEGER:
				  		%>
                &nbsp;
                <input name='<%=dct.nombre_campo%>' type='text' value="<%=(int)dct.dNumericValue%>" size='10' maxlength='10'>
                <%
						break;
					case extension.FLOATINGPOINT:
  			           %>
                &nbsp;
                <input name='<%=dct.nombre_campo%>' type='text' value="<%=woExtension.formatDouble(dct.dNumericValue,-4)%>" size='<%=Math.min(dct.lon_x + 1, 15)%>' maxlength='20'>
                <%
		               break;
					case extension.CURRENCY:
  			           %>
                &nbsp;
                <input name='<%=dct.nombre_campo%>' type='text' value="<%=woExtension.formatDouble(dct.dNumericValue)%>" size='<%=Math.min(dct.lon_x + 1, 15)%>' maxlength='20'>
                <%
		               break;
					case extension.DATETIME:
				        %>
                &nbsp;
                <input name='<%=dct.nombre_campo%>' type='text' value="<%=woExtension.strDate(dct.sValue)%>" size='12' maxlength='12'>
                <%
					   break;
					case extension.MEMO:
						%>
                &nbsp;
                <textarea name='<%=dct.nombre_campo%>' cols=60 rows=3><%=htmlServer.htmlEncode(dct.sValue)%></textarea>
                <%
						break;
				    default:  
				       	%>
                &nbsp;
                <input name='<%=dct.nombre_campo%>' type='text' value="<%=htmlServer.htmlEncode(dct.sValue)%>" size='<%=Math.min(dct.lon_x + 1, 50)%>' maxlength='<%=dct.lon_x%>'>
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
  </table>
</div>
<iframe id="geoserver" name="geoserver" height="0" width="0" frameborder="0" src=""></iframe>
<script language="JavaScript">
var nCurrentTab=0;
function openTab(ntab){
document.getElementById("tab_"+nCurrentTab).style.display='none';
document.getElementById("td_"+nCurrentTab).className='<%=sTabInactiveColor%>';
document.getElementById("link_"+nCurrentTab).className='<%=sTabTextInactiveColor%>';
nCurrentTab=ntab;
document.getElementById("tab_"+nCurrentTab).style.display='block';
document.getElementById("td_"+nCurrentTab).className='<%=sTabActiveColor%>';
document.getElementById("link_"+nCurrentTab).className='<%=sTabTextActiveColor%>';
}
openTab(0);
</script>
