<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8" %><%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
	<title>SQL Console</title>
	<link href="/DesInventar/html/desinventar.css" rel="stylesheet" type="text/css"/>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@ page import="org.lared.desinventar.system.Sys" %>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
<%@ page contentType="text/html; charset=UTF-8" %>

<%!
String not_null(String strParameter)
  {
    int pos;
    String sReturn;

    if (strParameter==null)
        return "";
     else
        return strParameter;
  }

int doCommand(Connection con, JspWriter out, String sExecutablePath)
        {
        int nErrors=0;
		
		try{
/*
			Runtime rt=Runtime.getRuntime();
			System.out.println("EXECUTING:"+sExecutablePath+"<br>");
			Process command=rt.exec(sExecutablePath);			
			InputStream inputStream = command.getInputStream();
	        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
	        byte[] buf = new byte[8096];
	        int c = inputStream.read(buf);
	        while (c != -1) {
	            byteArrayOutputStream.write(buf, 0, c);
	            c = inputStream.read(buf);
	        }
	        out.println(byteArrayOutputStream.toString());
*/
		}
		catch (Exception eImp)
		{
			//out.println("Error executing command: "+eImp.toString());
		}
		
		
        return nErrors;
        }


String get_ClobString(Clob theClob)
    {
    String sRet="";
    if (theClob!=null)
        try
            {
            int nClobLen=(int)theClob.length();
            sRet = theClob.getSubString(1,nClobLen);
            }
        catch (Exception eclob)
            {
            }
    return sRet;
    }


  void outputText (String filename, JspWriter out)
    {
    int c;
    String htmlLine;
        try
        {

        BufferedReader in = new BufferedReader(new FileReader(filename));
        try
            {
            while ((htmlLine = in.readLine()) != null)
                {
                out.println("<br>"+htmlLine);
                }
            in.close();
            }
            catch (IOException e)
                {
                    System.out.println("SYSTEM ERROR: reading "+filename+"...");
                }
        }
        catch (FileNotFoundException ex)
            {
                System.out.println("SYSTEM ERROR: "+filename+" not found..."+ex.getMessage() );
            }


    }
%>
<style>
.IE_Table {  
   <%if (request.getHeader("User-Agent").indexOf("MSIE") == -1) {%>
   border-collapse: collapse; border-style:solid; border-width: 1px;	border-color: LightGrey; <%}%>
 }
</style>
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%@ include file="/util/opendatabase.jspf" %>
<%
//Database Connection Objects
String sUserName;           // to store user name
int nCompanyId;             // to store company_id
String sCompanyName;        // to store company name
int nSqlRet=0;              // return from update SQL
String sSql;                // string holding SQL statement
int retCode,j, iFirst;      // return code from account object methods
String strErrors;           // validation errors

ResultSetMetaData meta;     // SQL metadata of the resultset
String[] tableTypes={"TABLE","VIEW"};
DatabaseMetaData dbMeta;
SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
String sQueryTitle="";
String sScript="";

int i=0;
int nStart=0;
int nResults=500;

//Sys.getProperties();
ServletContext sc = getServletConfig().getServletContext();
String htmlPrefix = sc.getRealPath("/");
String apachePrefix = htmlPrefix+"/../../logs/";
String schemma="CYBERMUSE";
if (request.getParameter("htmlPrefix")!=null)
    htmlPrefix = request.getParameter("htmlPrefix");
if (request.getParameter("apachePrefix")!=null)
    apachePrefix = request.getParameter("apachePrefix");
if (request.getParameter("schemma")!=null)
    schemma = request.getParameter("schemma").toUpperCase();
if ((schemma==null) || (schemma.length()==0))
    schemma=Sys.sDbUserName.toUpperCase();
	
try {nResults = Integer.parseInt(request.getParameter("nResults"));} catch (Exception e1){nResults=500;}
try {nStart = htmlServer.extendedParseInt(request.getParameter("nStart"));} catch (Exception e2){nStart=0;}
sSql = not_null(request.getParameter("sql"));
sSql = dbutils.removeComments(sSql);
// start the html output
%>
</head>
<body>
<br/>
<form  name="sqlexec" action="sqlexec.jsp" method="post">
<input type="hidden" name="usrtkn" id="usrtkn" value="<%=countrybean.userHash%>"> 
<FONT size=4><%=countrybean.getTranslation("EnterScript")%></FONT>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[<%=countrybean.countryname%>]<br>
<TEXTAREA cols=95 name=sql rows=15><%=sSql%></TEXTAREA><br>
<!--INSERT values in input tags. one per line-->
Max. rows: <input type=text name='nResults' size='6' maxlength="5" value='<%=nResults%>'>
<input  type=hidden size='6' name='nStart'  value='<%=nStart%>'>
<INPUT name='submit' type='submit' value='<%=countrybean.getTranslation("SubmitScript")%>'>
<INPUT type='hidden' name='schemma' value='<%=schemma%>'>
<INPUT type='button' name='clear' value='Clear' onClick='document.sqlexec.sql.value=""'>
</form><%
if (sSql.equalsIgnoreCase("servererror"))
	{
	out.println("<br><br><b>error.log</b><br>");
	outputText(apachePrefix+"/stdout.log", out);
	}
else if (sSql.equalsIgnoreCase("doConsolidate"))
	{
	dbutils.main(null);
	}
else
	{
	// processes the function if connected
	if (bConnectionOK)
		{
		try
			{
			// ?? stmt=con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
			stmt=con.createStatement();
			if (sSql.equalsIgnoreCase("doCommand"))
				{
				doCommand(con,out, sSql.substring(10));
				}
			else
				{
				sScript=sSql.trim();
				while(sScript.length()>0)
					{
					iFirst=1;
					// j=sScript.indexOf(";");
					boolean found=false;
					boolean lit=false;
					char clit='\'';
					j=0;
					while (j< sScript.length()&& !found)
						{
						if (lit)
							{
							if (sScript.charAt(j)==clit) lit=false;
							j++;
							}
						else
						if (sScript.charAt(j)==';')
							found=true;
						else
							{
							if (sScript.charAt(j)=='\'')
								{
								lit=true;
								clit=sScript.charAt(j);
								}
							if (sScript.charAt(j)=='"')
								{
								lit=true;
								clit=sScript.charAt(j);
								}
							j++;
							}
						}
					if (!found) j=0;
					if (j>0)
						{
						sSql=sScript.substring(0,j).trim();
						while((sSql.charAt(0)=='\n') ||
						(sSql.charAt(0)=='\t') ||
						(sSql.charAt(0)=='\r') ||
						(sSql.charAt(0)==' '))
						sSql=sSql.substring(1);
						sScript=sScript.substring(j+1);
						}
					else
						{
						sSql=sScript;
						sScript="";
						}
					
					if ( sSql.equalsIgnoreCase("listables") ||
					sSql.substring(0, 7).equalsIgnoreCase("select ") ||
					sSql.substring(0, 5).equalsIgnoreCase("desc "))
						{
						// generates a resultset with the info required:
						if (sSql.equalsIgnoreCase("listables"))
							{
							// gets the metadata of the database
							dbMeta = con.getMetaData();
							// gets the tables set
							rset = dbMeta.getTables(null, schemma, null, tableTypes);
							sQueryTitle="TABLES IN THE SYSTEM:";
							nStart=0;
							iFirst=2;
							nResults=50000;
							}
						else
						if (sSql.trim().substring(0, 6).equalsIgnoreCase("select"))
							{
							// executes a query
							long lBefore= (new java.util.Date()).getTime();
							rset = stmt.executeQuery (sSql);
							long lAfter= (new java.util.Date()).getTime();
							sQueryTitle="RESULTS FROM QUERY: &nbsp;&nbsp;&nbsp;&nbsp;";
							lAfter-=lBefore;
							sQueryTitle+="("+lAfter+" msecs)";
							}
						else
						if (sSql.substring(0, 5).equalsIgnoreCase("desc "))
							{
							// gets the metadata of the database
							dbMeta = con.getMetaData();
							String table=sSql.substring(5).trim().toUpperCase();
							j=table.indexOf(".");
							if (j>0)
								{
								schemma=table.substring(0,j);
								table=table.substring(j+1);
								}
							rset = dbMeta.getColumns(null, schemma,table,null);
							nStart=0;
							iFirst=4;
							nResults=50000;
							sQueryTitle="DESCRIPTION OF TABLE "+sSql.substring(5).trim()+":";
							}
						
						// gets the metadata of the resultset
						meta = rset.getMetaData();
						out.println("<h3>"+sQueryTitle+"</H3><BR><TABLE border='1' >");
						out.println("<tr><TD>"+sSql+"<br></TD></TR></TABLE><TABLE border='1' class='bss IE_Table'>");
						out.println("<TR>");
						for (j=iFirst; j<=meta.getColumnCount(); j++)
							{
							out.println("<td><b>"+meta.getColumnName(j)+"</b></td>");
							}
						out.println("</TR>");
						int nreg=0;
						if (nStart>0)
							{
							while (rset.next() && (nreg<nStart)) nreg++;
							}
						nreg=0;
						while (rset.next() && (nreg++<nResults))
							{
							out.print("<TR>");
							for (j=iFirst; j<=meta.getColumnCount(); j++)
								{
								out.print("<td>");
								try {
									switch (meta.getColumnType(j))
										{
										case Types.CLOB:
										case 1111:
										out.print(get_ClobString(rset.getClob(j)));
										// out.println("<td>"+rset.getClob(j).getSubString(1,(int) rset.getClob(j).length())+"</td>");
										//out.println("<td>"+rset.getClob(j).getSubString(1,45)+"</td>");
										//out.println("<td>"+ rset.getClob(j).length()+"</td>");
										break;
										case Types.DATE:
											out.println(formatter.format(rset.getDate(j)));
											break;
										case Types.DECIMAL:
										case Types.DOUBLE:
										case Types.FLOAT:
										case Types.REAL:
										case Types.NUMERIC:
											out.println(webObject.formatDouble(rset.getDouble(j),-8));
											break;
										case Types.SMALLINT:
										case Types.INTEGER:
											String sInt=rset.getString(meta.getColumnName(j));
											if (sInt==null)
												out.print("&nbsp;");
											else
												out.print(sInt);
											break;
										default:
											out.print(not_null(rset.getString(j)));
											break;
										}
									}
								catch (Exception e)
									{
									out.print("*ERR*");
									}
								out.print("</td>");
								}
							out.println("</TR>");
							}
						out.println("</table>");
						}
					else
						{
						long lBefore= (new java.util.Date()).getTime();
						stmt.close();
						stmt=con.createStatement();
						nSqlRet = stmt.executeUpdate (sSql);
						long lAfter= (new java.util.Date()).getTime();
						lAfter-=lBefore;
						out.println("<br>SQL:"+sSql+" RETURNED: "+nSqlRet+"  ("+lAfter+" msecs)");
						}
					}
				}
			out.println("<br>");
			// releases the statement
			stmt.close();
			}
		catch(Exception ex)
			{ //Trap SQL errors
			out.println("Error: "+ ex.toString()+ " in SQL:"+sSql);
			}
		}
	else
	out.println("Error connecting...");
	}

// closes the connection with the server!!!
dbCon.close();
%>