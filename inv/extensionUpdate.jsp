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
<%@ taglib uri="inventag.tld" prefix="inv" %>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%if (user.iusertype<20) 
 {%>
 <jsp:forward page="noaccess.jsp"/>
<%}%> 

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
  %><jsp:forward page='/inv/extensionManager.jsp'/><%
}

String sSql="";
String sErrorMessage="";
int action=Dictionary.extendedParseInt(request.getParameter("action"));
String sFieldid=request.getParameter("newname");
if (sFieldid==null)
   sFieldid=Dictionary.nombre_campo;
// force uppercase version of name
sFieldid=sFieldid.toUpperCase();
int nFieldType=Dictionary.extendedParseInt(request.getParameter("fieldtype"));
int nFieldSize=Dictionary.extendedParseInt(request.getParameter("field_size"));

int nCurrentFieldType=Dictionary.fieldtype;
int nCurrentFieldSize=nFieldSize;
if (action>0 && Dictionary.fieldtype==0)  // check against the database type for older data model revisions
	{
	stmt=con.createStatement ();
	try{
		rset=stmt.executeQuery("select "+Dictionary.nombre_campo.toLowerCase()+" from extension");
		/// gets the metadata of the resultset - this is here to catch external modifications to table structure
		//  and old datamodel versions of DesInventar where fieldtype wasn't present.
		ResultSetMetaData meta = rset.getMetaData();
		switch (meta.getColumnType(1))
			 {
			   case Types.CLOB:
			   case 1111: // type reported by Oracle for BLOB types...
			   case Types.BLOB:
				 nCurrentFieldType=5;
				 nCurrentFieldSize=16;			  
			     break;
			   case Types.DATE:
				 nCurrentFieldType=4;
				 nCurrentFieldSize=16;			  
				 break;
			   case Types.DECIMAL:
			   case Types.DOUBLE:
			   case Types.FLOAT:
			   case Types.REAL:
			     nCurrentFieldType=2;
				 nCurrentFieldSize=8;
				 if (meta.isCurrency(1)||(Dictionary.fieldtype==extension.CURRENCY))
				 	nCurrentFieldType=3;
				 break;
			   case Types.NUMERIC:
				 nCurrentFieldType=1;
				 nCurrentFieldSize=4;
				 int scale=meta.getScale(1);
				 int presicion=meta.getPrecision(1);
				 if (scale==2) // 2 dec digits-> is currency
				 	nCurrentFieldType=3;
				 else if (scale>2) // 3+ dec digits-> is decimal
				 	nCurrentFieldType=2;
				 break;
			   case Types.SMALLINT:
			   case Types.INTEGER:
			   case Types.BIGINT:
			   case Types.TINYINT:
				 if (Dictionary.fieldtype>=extension.YESNO)
				 	nCurrentFieldType=Dictionary.fieldtype;
				else
				 	nCurrentFieldType=1;
				 nCurrentFieldSize=4;			  
			     break;
			   case Types.VARCHAR:
				 nCurrentFieldType=0;
				 nCurrentFieldSize=meta.getColumnDisplaySize(1);			  
			     break;
		    }
		rset.close();
		stmt.close();
		}
	catch (Exception e)
		{
		// ?? what should we do here?
		}	
	}
if (request.getParameter("saveField")!=null)
{
 // release all connections closing them physically
 dbCon.closeAllConnections();
 // and now refresh the con object pointing to the old (closed now) connection
 con=dbCon.dbGetConnection();
 switch (action)
  { 
  case 0:  // add field, check for a NEW  name
	int nr=0;
	stmt=con.createStatement ();
	rset=stmt.executeQuery("select count(*) as nr from diccionario where nombre_campo='"+Dictionary.check_quotes(sFieldid)+"'");
	if (rset.next())
		nr=rset.getInt("nr");
	rset.close();
	stmt.close();
	// the new or different name exists...
	if (nr>0)
		{
		sErrorMessage=countrybean.getTranslation("SORRY")+": "+countrybean.getTranslation("field")+" "+sFieldid+" "+countrybean.getTranslation("alreadyexists.Pleasechooseanothername");
		}
	else
		{
		Dictionary.getForm(request,response,con);
		Dictionary.nombre_campo=sFieldid;
		Dictionary.fieldtype=nFieldType;
		stmt=con.createStatement ();
		// add the variable in the database!!!
		  sSql="alter table extension add "+Dictionary.nombre_campo+" "+DbImplementation.typeNames[countrybean.country.ndbtype][nFieldType];
		if (nFieldSize==0)
		   nFieldSize=40;
		Dictionary.lon_x=nFieldSize;   
		if (nFieldType==0)
		   sSql+="("+nFieldSize+")";
		try
			{
			stmt.executeUpdate(sSql);		   	
			Dictionary.addWebObject(con);
			}
		catch (Exception e1)
			{
			sErrorMessage="SORRY: Field cannot be ADDED.(other users may be using the table)...:["+e1.toString()+"]";
			}
		finally
			{
			stmt.close();
			}
		out.write("<!-- ADDED RECORD: -->");
		out.print(Dictionary.lastError);
		}
	break;
  case 1:  // update field
  	    Dictionary.getForm(request,response,con);
		if (nFieldSize==0)
		   nFieldSize=40;
		Dictionary.lon_x=nFieldSize;   
		//*  TODOJS implement here the changes in type/length, etc.
		stmt=con.createStatement ();
		try
			{
			// changes in length:
			if (nCurrentFieldSize!=nFieldSize && nCurrentFieldType==0)
			 {
			 switch (countrybean.dbType)
				{
		        case Sys.iOracleDb: //  oracle provides sequences
				  sSql="ALTER TABLE extension MODIFY ("+Dictionary.nombre_campo+" "+DbImplementation.typeNames[countrybean.country.ndbtype][nFieldType]
				          +"("+nFieldSize+"))";
		          break;
		        case Sys.iAccessDb:
				  sSql="ALTER TABLE extension ALTER COLUMN "+Dictionary.nombre_campo+" "+DbImplementation.typeNames[countrybean.country.ndbtype][nFieldType]
				          +"("+nFieldSize+")"; 
		          break;
		        case Sys.iMsSqlDb:
				  sSql="ALTER TABLE extension ALTER COLUMN "+Dictionary.nombre_campo+" "+DbImplementation.typeNames[countrybean.country.ndbtype][nFieldType]
				          +"("+nFieldSize+")"; 
		          break;
		        case Sys.iPostgress:
				  sSql="ALTER TABLE extension rename COLUMN "+Dictionary.nombre_campo+"  to "+Dictionary.nombre_campo+"_99999989"; 
				  stmt.executeUpdate(sSql);
				  sSql="ALTER TABLE extension add "+Dictionary.nombre_campo+" "+DbImplementation.typeNames[countrybean.country.ndbtype][nFieldType]
				          +"("+nFieldSize+")"; 
				  stmt.executeUpdate(sSql);
				  sSql="update extension set "+Dictionary.nombre_campo+"="+Dictionary.nombre_campo+"_99999989"; 
				  stmt.executeUpdate(sSql);
				  sSql="ALTER TABLE extension drop COLUMN "+Dictionary.nombre_campo+"_99999989"; 
		          break;
		        case Sys.iMySqlDb:
				  sSql="ALTER TABLE extension MODIFY "+Dictionary.nombre_campo+" "+DbImplementation.typeNames[countrybean.country.ndbtype][nFieldType]
				          +"("+nFieldSize+")"; 
		          break;
		        case Sys.iDerbyDb:
				  sSql="alter table extension alter "+Dictionary.nombre_campo+" set data type  "+DbImplementation.typeNames[countrybean.country.ndbtype][nFieldType]
				          +"("+nFieldSize+")"; 
		          break;
			    }
			 stmt.executeUpdate(sSql);			 
			 }
			 // if everything went well, update the dictionary record
  		     Dictionary.updateWebObject(con);
			}
		catch (Exception e2)
			{
			sErrorMessage="[DI9] SORRY: Field cannot be changed....<!--"+e2.toString()+" -->";
			System.out.println(sErrorMessage);
			}	
		finally
			{
			stmt.close();
			}
//*/
		break;
  case 2:  // delete field
		Dictionary.getForm(request,response,con);
		stmt=con.createStatement ();
  		try	{
			// remove variable from the database!!!
        	sSql="alter table extension drop column "+Dictionary.nombre_campo;
			stmt.executeUpdate(sSql);	
			try	{
				sSql="delete from extensioncodes where field_name='"+Dictionary.nombre_campo+"'";
				stmt.executeUpdate(sSql);
				Dictionary.deleteWebObject(con);
				}
			catch (Exception e3)
				{
				sErrorMessage+="Warning: problem deleting codes (cannot be deleted)...("+e3.toString()+" <!--"+sSql+"--> )";
				}	
			}
		catch (Exception e3)
			{
			sErrorMessage="WARNING: Field could not be deleted from database, please remove manually...("+e3.toString()+" <!--"+sSql+"--> )";
			}	
			
		finally
			{
			stmt.close();
			}
	}	
	if (sErrorMessage.length()==0)
		{
		dbCon.close();
		%><jsp:forward page='/inv/extensionManager.jsp'/><%
		}
  }
%>

<script language="JavaScript">
<!--
function giveFocus() 
{
  if (<%=action==0?"true":"false"%>)
  	document.desinventar.newname.focus()
  else
  	document.desinventar.label_campo.focus()
  	
}

function submitForm() 
{
  document.desinventar.submit()
}

function resetForm() 
{
  document.desinventar.reset()
  document.desinventar.nombre_campo.focus()
}

var notValidChars = " '\/<>";
var ValidChars = "0123456789_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

function validate_alpha(entered,alertbox)
{
validateFlag=true;
entered.value=trim(entered.value);
toCheck=entered.value.charAt(0);
if (ValidChars.indexOf(toCheck)<10)
	validateFlag=false;
for (j=1; j<entered.value.length; j++)
	{
    toCheck=entered.value.charAt(j);
	if (ValidChars.indexOf(toCheck)<0)
		validateFlag=false;
	} 
if (!validateFlag)
	alert(alertbox);
return validateFlag;
}

function trim(strVariable)
{
if (strVariable==null)
	return "";
var len=strVariable.length;
if (len==0)
	return "";
// first part:  trims blanks to the right
var index=len-1;
while ((index>0) && (strVariable.charAt(index)==" ")) index--;
strVariable=strVariable.substring(0,index+1);
// second part:  trims leading blanks
len=strVariable.length;
index=0;
while ((index<len) && (strVariable.charAt(index)==" ")) index++;
strVariable=strVariable.substring(index,len);
return strVariable;
}

function emptyvalidation(entered, alertbox)
{
with (entered)
	{
    value=trim(value);
	if (value==null || value=="")
		{	
		if (alertbox!="") 
			alert(alertbox);
		return false;
		}
	else 
		return true;
	}
}


function validateFields()
{
var ok=true;
if (<%=action==0?"true":"false"%>)
{
ok= emptyvalidation(document.desinventar.newname,'<%=countrybean.getTranslation("name")%> <%=countrybean.getTranslation("ismandatory")%>!..')
if (ok) ok= validate_alpha(document.desinventar.newname,'<%=countrybean.getTranslation("Invalidfieldname")%>')
if (ok) ok= emptyvalidation(document.desinventar.field_size,'<%=countrybean.getTranslation("Fieldsize")%> <%=countrybean.getTranslation("ismandatory")%>!..')
}
if (ok) ok= emptyvalidation(document.desinventar.label_campo,'<%=countrybean.getTranslation("Labelforfield")%> <%=countrybean.getTranslation("ismandatory")%>!..')
return ok;
}
// -->
</script>



<form name="desinventar" action="extensionUpdate.jsp" method="post" onSubmit="return validateFields()">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<table cellspacing="0" cellpadding="2" border="0" width="850">
<tr>
<td>
<table cellspacing="0" cellpadding="5" border="1" width="850" rules="none" class='bs'>
<tr>
    <td class='bgDark' height="25" td colspan="2"><span class="titleText"><%=countrybean.getTranslation("FieldDefinition")%></span></td>
	</td>
</tr>
<tr><td colspan="2" height="5"></td></tr>
<TR>
<TD colspan=2 align="center"><span class="warning"><%=sErrorMessage%></span></TD>
</TR>
<input type="hidden" name="action" value="<%=action %>">
<input type="hidden" name="nombre_campo" maxlength="10" size="10" value="<%=Dictionary.nombre_campo %>">
<INPUT type='hidden' name='orden' VALUE="<%=Dictionary.orden%>">
<tr><td width=180 class=bgLight align='right'><%=countrybean.getTranslation("FieldNameforDB")%>:</td><td>  
<% if (action==0)
   {%>
<INPUT type='TEXT' size='31' maxlength='30' name='newname' VALUE="<%=Dictionary.nombre_campo%>">
<% }
   else
   {%>
<%=Dictionary.nombre_campo%>
<INPUT type='hidden' name='newname' VALUE="<%=Dictionary.nombre_campo%>">
<% }%>
</td></tr>
<tr><td width=180 class='bgLight' align='right'><%=countrybean.getTranslation("Labelforfield")%>:</td><td>  <INPUT type='TEXT' size='50' maxlength='60' name='label_campo' VALUE="<%=Dictionary.label_campo%>"></td></tr>
<tr><td width=180 class='bgLight' align='right'><%=countrybean.getTranslation("Labelforfield")%>(English):</td><td>  <INPUT type='TEXT' size='50' maxlength='60' name='label_campo_en' VALUE="<%=Dictionary.label_campo_en%>"></td></tr>
<tr><td width=180 class=bgLight align='right'><%=countrybean.getTranslation("FieldDescription")%>:</td><td>  <INPUT type='TEXT' size='50' maxlength='180' name='descripcion_campo' VALUE="<%=Dictionary.descripcion_campo%>"></td></tr>
<% if (action>0)
   {%>
<tr><td width=180 class=bgLight align='right'><%=countrybean.getTranslation("FieldType")%>:</td><td> 
<%if (nCurrentFieldType==extension.INTEGER || 
	  nCurrentFieldType==extension.LIST || 
	  nCurrentFieldType==extension.YESNO || 
	  nCurrentFieldType==extension.CHOICE)
{ // all integer types are interchangeable - user responsibility%>
 <select name='fieldtype'>
 <option value=1<%=Dictionary.strSelected(nCurrentFieldType,1)%>>Integer
 <option value=6<%=Dictionary.strSelected(nCurrentFieldType,6)%>>Yes/No
 <option value=7<%=Dictionary.strSelected(nCurrentFieldType,7)%>>Drop-down List
 <option value=8<%=Dictionary.strSelected(nCurrentFieldType,8)%>>Choice
 </select>
<%}
else{%>
<%=extension.UserTypeNames[nCurrentFieldType]%>
<input type='hidden' name='fieldtype' value='<%=nCurrentFieldType%>'>
<%}%>
 </td></tr>
	<% if (nCurrentFieldType==0)
	   {%>
	<tr><td width=180 class=bgLight align='right'><%=countrybean.getTranslation("Fieldsize")%>:</td><td>  
    <INPUT type='TEXT' size='5' maxlength='5' name='field_size' VALUE="<%=nCurrentFieldSize%>"> [<%=nCurrentFieldSize%>] 
	&nbsp;&nbsp;&nbsp;&nbsp;(<%=countrybean.getTranslation("AppliedonlytoTEXT")%>)
	</td></tr>
	<% }
	 }
   else
   {%>
<tr><td width=180 class=bgLight align='right'><%=countrybean.getTranslation("FieldType")%>:</td><td> 
 <select name='fieldtype'>
 <option value=0<%=Dictionary.strSelected(nCurrentFieldType,0)%>>Text
 <option value=1<%=Dictionary.strSelected(nCurrentFieldType,1)%>>Integer
 <option value=2<%=Dictionary.strSelected(nCurrentFieldType,2)%>>Floating point
 <option value=3<%=Dictionary.strSelected(nCurrentFieldType,3)%>>Currency
 <option value=4<%=Dictionary.strSelected(nCurrentFieldType,4)%>>Date
 <option value=5<%=Dictionary.strSelected(nCurrentFieldType,5)%>>Memo
 <option value=6<%=Dictionary.strSelected(nCurrentFieldType,6)%>>Yes/No
 <option value=7<%=Dictionary.strSelected(nCurrentFieldType,7)%>>Drop-down List
 <option value=8<%=Dictionary.strSelected(nCurrentFieldType,8)%>>Choice
 </select>
 </td></tr>
<tr><td width=180 class=bgLight align='right'><%=countrybean.getTranslation("Fieldsize")%>:</td><td>  
<INPUT type='TEXT' size='5' maxlength='5' name='field_size' VALUE="<%=nCurrentFieldSize%>"> 
&nbsp;&nbsp;(<%=countrybean.getTranslation("AppliedonlytoTEXT")%>)
</td></tr>
   
<% }%>

	<tr><td width=180 class=bgLight align='right'><%=countrybean.getTranslation("ShowInTab")%></td><td>
	<SELECT name="tabnumber" style="WIDTH: 250px;">
	<option value=""></option>
	<inv:select tablename='extensiontabs' selected='<%=Dictionary.tabnumber%>' connection='<%= con %>'
    fieldname="svalue" codename='ntab' ordername='nsort'/>
    </SELECT>
	</td></tr>

	<TR>
	<TD colspan=3 height="20"></TD>
	</TR>
	<TR>
	<TD  valign="bottom"  align=right>
	</TD>
	<TD valign="bottom">
<% if (action==2)
   {%>
	<input name="saveField" type=submit value='<%=countrybean.getTranslation("Delete")%> <%=countrybean.getTranslation("Field")%>'> 
<% }
   else
   {%>
	<input name="saveField" type=submit value='<%=countrybean.getTranslation("Save")%> <%=countrybean.getTranslation("Field")%>'> 
<% }%>
	&nbsp; &nbsp; &nbsp; &nbsp;
	<input name="cancelField" type=button value='<%=countrybean.getTranslation("Cancel")%>' onClick="postTo('extensionManager.jsp')">
	</TD>
	</Tr>

	<TR>
	<TD colspan=3 height="10"></TD>
	</TR>
	<TR>
</table>
</td>
</tr>
</table>
</form>


<script language="JavaScript">
<!-- 
giveFocus();
// -->
</script>
</BODY>
</html>
<%dbCon.close();%>












