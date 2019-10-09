<%@ page info="DesConsultar geocode server" session="true" %><%@ page import="java.sql.*"%><%@ page import="org.lared.desinventar.util.*" %><jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" /><jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" /><%
response.setHeader("Pragma", "no-cache");
response.setHeader("Cache-Control", "no-cache");
response.setDateHeader("Expires", 0);	
%><%@ include file="/util/opendatabase.jspf" %><%
int retCode = 0; // return code from account object methods
int nLevel = 0;
int nCodes = 0;
// sends start of sequence
// gets parameters from URL
nLevel = countrybean.extendedParseInt(request.getParameter("level"));
boolean bEmpyOption=request.getParameter("emptyoption")!=null;

// assembles the names:
String sTable = "lev" + nLevel;
String sName = sTable + "_name";
String sName_en = sTable + "_name_en";
String sCode = sTable + "_cod";
String sParent = sTable + "_lev" + (nLevel - 1);
String sArray="";
// Query the account name & password
String[] sSelected=request.getParameterValues("code");
String sGeoCode = ""; // just to initialize the list with something...
if (sSelected!=null)
  {
  for (int j=0; j<sSelected.length; j++)
	 {
	 if (j>0)
	   sGeoCode+=",?";
	 else
	   sGeoCode+="?";
	 }
  } 
else
  sGeoCode="'@@@@@@@'";
  
String sSql = "select * from " + sTable + " where " + sParent + " in (" + sGeoCode + ") ";

String sWhere="";
String sAnd=" and "+sCode+" in (";
if (user.aLevel0[nLevel]!=null)
{
for (int i=0; i<user.aLevel0[nLevel].size(); i++) 
	{
	String sCo=user.aLevel0[nLevel].get(i).substring(0,user.aLevel0[nLevel].get(i).indexOf(":"));
	if (sCo.equalsIgnoreCase(countrybean.countrycode))
		{
			sWhere+=sAnd+"'"+user.aLevel0[nLevel].get(i).substring(user.aLevel0[nLevel].get(i).indexOf(":")+1,user.aLevel0[nLevel].get(i).length())+"'";
			sAnd=",";
		}															
	}
if (sWhere.length()>0)
	sWhere+=")";
}

sSql+=sWhere+" order by "+sCode+","+sName;

		
PreparedStatement pstmt = con.prepareStatement(sSql);
if (sSelected!=null)
  for (int j=0; j<sSelected.length; j++)
      pstmt.setString(j+1,sSelected[j]);
rset = pstmt.executeQuery();
out.print("%%OK%%\n");
while (rset.next())
    {
	out.print(rset.getString(sCode)+"\n");
	out.print(countrybean.getLocalOrEnglish(rset,sName,sName_en)+"\n");
	}	
out.print("@@@\n");
out.print("@@@\n");
// releases the resultset
rset.close();
// releases the statement
pstmt.close();
 // returns the connection to the pool
 dbCon.close();
%>
