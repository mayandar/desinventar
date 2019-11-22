<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8");%>
<%@ page info="DesInventar On-Line add data page" session="true" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<jsp:useBean id="woFicha" class="org.lared.desinventar.webobject.fichas" scope="session" />
<jsp:useBean id="woExtension" class="org.lared.desinventar.webobject.extension" scope="session" />
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
// checks for a session alive variable, or we have a new valid countrycode
if (false && !countrybean.userHash.equals(request.getParameter("usrtkn")))
	 	{%><jsp:forward page="noaccess.jsp"/><%}		
if (countrybean.countrycode.length()==0)
	{%><jsp:forward page="/inv/index.jsp"/>
	<%}%>
<%@ include file="checkUserIsLoggedIn.jsp" %>
<%if (user.iusertype<1) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}%>
<%@ include file="/util/opendatabase.jspf" %>
<% 
// expire this page so no back buton will create duplicates...
	response.setHeader("Pragma", "no-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
%>
<html>
<head>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="cache-control" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="01-01-1999">
<title><%=countrybean.countryname%><%=countrybean.getTranslation("DataEntry")%> </title>
</head>
 
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/iheader",countrybean.getLanguage(),out);%>
<%@ taglib uri="inventag.tld" prefix="inv" %>
<%
{
int nTabActive=7; // 
String[] sTabNames={countrybean.getTranslation("Region"),countrybean.getTranslation("Geography"),countrybean.getTranslation("Events"),
           countrybean.getTranslation("Causes"),countrybean.getTranslation("Extension"),countrybean.getTranslation("Query"),
           countrybean.getTranslation("EditData"),countrybean.getTranslation("DataEntry"),countrybean.getTranslation("Admin"),
		   countrybean.getTranslation("Sendai"),countrybean.getTranslation("Security")};
String[] sTabIcons={"","","","","","","","","","","",""};
String[] sTabLinks={"index.jsp","geographytab.jsp","eventab.jsp",
				"causetab.jsp","extendedtab.jsp","querytab.jsp",
				"resultstab.jsp","datacardtab.jsp","admintab.jsp",
				"sendaitab.jsp","securitytab.jsp"};
%>
<%@ include file="/util/tabs.jspf" %>
<%}%>
<table width="100%" border="1" class="pageBackground" rules="none">
<tr><td align="left" valign="top">
<!-- Content goes after this comment -->
	<table width="1000" border="0">
	<tr><td align="center">
	<font color="Blue"><%=countrybean.getTranslation("Region")%></font>
	<b><i><jsp:getProperty name ="countrybean" property="countryname"/></i></b></font>
	- [<jsp:getProperty name ="countrybean" property="countrycode"/>]
	</td></tr>
	</table>
<!-- Content goes before this comment -->
</td></tr>
</table><br/>
<%	
countrybean.bViewStandard=request.getParameter("viewStandard")!=null;
if (request.getParameter("addCard")!=null)
	{
	// gets the object from the database
	woFicha.clave=0;
	woFicha.getForm(request, response, con);
	woExtension.getForm(request, response, con);
	woFicha.dbType=dbType;
	woExtension.dbType=dbType;
	// send it thru its template
	woFicha.addWebObject(con);
	woExtension.clave_ext=woFicha.clave;
	woExtension.addWebObject(con); 
	dbCon.close();
    //out.println("<!-- FICHA ["+woFicha.clave+"] -->"+woFicha.lastError);
    //out.println("<!-- EXTENSION -->"+woExtension.lastError);
    // removes the entry from tips - it will not show real data
	CountryTip.getInstance().remove(countrybean.countrycode);   
   %><jsp:forward page="editDataCard.jsp" /><%
	}
else
  if (request.getParameter("cancelCard")!=null)
	{
	dbCon.close();
   %><jsp:forward page="datacardtab.jsp" /><%
	}
	
// loads the datacard extension
woExtension.dbType=dbType;
woExtension.loadExtension(con,countrybean);
%>
<%@ taglib uri="inventag.tld" prefix="inv" %>
<FORM NAME="desinventar" action="addDataCard.jsp" method="post">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 

<%
woFicha.clave=0;
woFicha.init();
woExtension.init();
woFicha.serial=String.valueOf(woFicha.getSequence("fichas_seq", con));
woFicha.approved=1;
String sApprovedClass="bodylight"+woFicha.approved;
// show datacard template
%>
<%@ include file="validation.jsp" %>
<input type='hidden' name='uu_id' value='<%=woFicha.uu_id%>'>
<div class="bs">
<h2><%=countrybean.getTranslation("New")%> <%=countrybean.getTranslation("DataCard")%></h2>
  <table border="1" rules="cols" cellpadding="0" cellspacing="0" bordercolor="black" class="bs" width="1000">
       <tr class='<%=sApprovedClass%> bs'>
       
            <td class="bs"><!-- Header lines in light blue  -->
              <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                  <td class="bs" nowrap><%=countrybean.getTranslation("Serial")%>:
                    <INPUT name="serial" value="<%=woFicha.serial%>" size="15" maxlength="15"></td>
                  <td class="bs" nowrap><%=countrybean.getTranslation("DateYMD")%>:
                    <INPUT NAME="fechano"  style="WIDTH: 45px;" value="<%=sBlankZero(woFicha.fechano)%>" size="4" maxlength="4">
                    <INPUT NAME="fechames" value="<%=sBlankZero(woFicha.fechames)%>" size="2" style="WIDTH: 22px;" maxlength="3">
                    <INPUT NAME="fechadia" value="<%=sBlankZero(woFicha.fechadia)%>" size="2" style="WIDTH: 22px;" maxlength="3"></td>
                  <td class="bs" nowrap><%=countrybean.getTranslation("Duration")%>:
                    <INPUT NAME="duracion"  style="WIDTH: 40px;" value="<%=sBlankZero(woFicha.duracion)%>" size="4" maxlength="4"></td>
                  <td class="bs" nowrap><%=countrybean.getTranslation("Source")%>:
                    <INPUT type='TEXT' size='40' maxlength='250' name='fuentes' VALUE="<%=woFicha.fuentes%>"></td>
                  <td class="bs" nowrap><%=countrybean.getTranslation("Status")%>:
                    <select name='approved'>
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
		  </tr>
         <tr  class='<%=sApprovedClass%> bs'>
            <td class="bs">
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                  <td width="30%" class="bs"><%=countrybean.asLevels[0]%>:
                    <SELECT name="level0"  id="level0" onchange="checkLevel0();build_locations();">
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
							out.print("\t<option value=\"" + sCode + "\"");
							if (woFicha.level0.equalsIgnoreCase(sCode))
							  out.print(" selected");
						   out.println(">" + countrybean.getLocalOrEnglish(rset,"lev0_name","lev0_name_en"));
						  }
					%>
                    </select>
                  </td>
                  <td width="30%" class="bs"><%=countrybean.asLevels[1]%>:
                    <input type='hidden' name='name0' id='name0' value="<%=woFicha.name0%>"/>
                    <SELECT name="level1" id="level1"  onchange=" checkLevel1();build_locations();">
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
							  sSql+=sWhere+" order by lev1_name";
							  rset = stmt.executeQuery(sSql);
							  while (rset.next())
							  {
								String sCode = rset.getString("lev1_cod");
								out.print("<option value='" + htmlServer.not_null(sCode) + "'");
								if (woFicha.level1.equalsIgnoreCase(sCode))
								  out.print(" selected");
							   out.println(">" + htmlServer.not_null(countrybean.getLocalOrEnglish(rset,"lev1_name","lev1_name_en")));
							  }
						 }%>
                    </select>
                  </td>
                  <td width="30%" class="bs"><%=htmlServer.not_null(countrybean.asLevels[2])%> :
                    <input type='hidden' name='name1' id='name1' value="<%=woFicha.name1%>">
                    <SELECT name="level2" id="level2" onchange=" jsGetLevel3();build_locations();">
                      <option value=''></option>
					  <% if (woFicha.level1.length()>0)
                      {%><inv:selectLevel2 connection="<%= con %>" level1Code="<%=woFicha.level1%>"  selected="<%=woFicha.level2%>"/>
                      <%}
                    	rset.close();
                    	stmt.close();
                    	%>
                    </select>
                    <input type='hidden' name='name2' value="<%=woFicha.name2%>"/>
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
                    <SELECT name="evento">
                    <inv:select tablename='eventos' selected='<%=woFicha.evento%>' connection='<%= con %>' fieldname="<%=sDisplayField%>" codename='nombre' ordername='serial'/>
                    </select>
                  </td>
                 <td class="bs"><%=countrybean.getTranslation("Place")%>:
                    <INPUT type="TEXT" size="45" maxlength="60" name="lugar" VALUE="<%=woFicha.lugar%>"/>
                  </td>
                  <td class="bs"><%=countrybean.getTranslation("GLIDEnumber")%>:
                    <INPUT type="TEXT" size="17" maxlength="30" name="glide" VALUE="<%=woFicha.glide%>"/>
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
                    <SELECT name="causa">
                      <option value=''></option>
                      <inv:select tablename='causas' selected='<%=woFicha.causa%>' connection='<%= con %>'    fieldname="<%=sDisplayField%>" codename='causa' ordername='causa'/>
                    </select>
                  </td>
                  <td class="bs"><%=countrybean.getTranslation("DescriptionCause")%>:
                    <INPUT type="TEXT" size="65" maxlength="60" name="descausa" VALUE="<%=woFicha.descausa%>">
                  </td>
                </tr>
              </table>
              <hr/>
            </td>
          </tr>
       </table>
   </div>    

<%
dbCon.close();
%>
<table width="580" border="0">
<tr><td align="center">
<input type="submit" name= 'addCard' value='<%=countrybean.getTranslation("Save")%>' onClick=" return chkForm()">

<input type="submit" name= 'cancelCard' value='<%=countrybean.getTranslation("Cancel")%>'><br/><br/><br/>
<div class="bss"><%=countrybean.getTranslation("Please click on Save to proceed to enter data about this disaster")%></div>
<br>
<div class="warning"><%=countrybean.getTranslation("ALL OTHER FIELDS WILL BE SHOWN AFTER SAVING THIS SCREEN")%></div>
<br>
<div class="warning"><%=countrybean.getTranslation("note1")%></div>
</td></tr></table>
</form>

<script language="javascript">
<!--
var hoy = new Date(); 
with (document.desinventar)
  {
  if (fechano.value==0)
  	fechano.value=hoy.getYear();  
  if (fechames.value==0)
  	fechames.value=hoy.getMonth()+1;  
  if (fechadia.value==0)
  	fechadia.value=hoy.getDay();  
  if (level1.selectedIndex==-1)
    jsGetLevel1();
  }

// -->
</script>



</body>
</html>
