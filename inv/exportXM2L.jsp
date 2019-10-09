<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>DesConsultar on-line Download XML</title>
</head>
<%@ page info="front page of DesConsultar On-Line" session="true" %> 
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ page import="org.lared.desinventar.util.DICountry" %> 
<%@ page import="org.lared.desinventar.util.htmlServer" %>
<%@ page import="org.lared.desinventar.util.dbConnection" %>
<%@ page import="org.lared.desinventar.webobject.*" %>
<%@ page import="org.lared.desinventar.util.*" %>
<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
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

String get_ClobString(Clob theClob)
    {
    String sRet="";
    if (theClob!=null)
        try
            {
            int nClobLen=(int)theClob.length();
			if (nClobLen>5000)
				nClobLen=5000;
            sRet = theClob.getSubString(1,nClobLen);
            }
        catch (Exception eclob)
            {
            }
    return sRet;
    }

void outputTable (String tablename, PrintStream out, Connection con, int ndbType)
    {
	ResultSetMetaData meta;     // SQL metadata of the resultset
	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
	String sTag;
    int j;
    String sStr;
    try
        {
	  // Statement stmt=con.createStatement(); 
	  //createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	  //resultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY); 
		
		Statement stmt = con.createStatement(java.sql.ResultSet.TYPE_FORWARD_ONLY, java.sql.ResultSet.CONCUR_READ_ONLY);
		
		// Horrible implementation in MySQL that if this setFetchSize is not issued it will attempt to retrieve the full resultset in MEMORY!!!
		if (ndbType==Sys.iMySqlDb)
			stmt.setFetchSize(Integer.MIN_VALUE);
		
		ResultSet rset=stmt.executeQuery("Select * from "+tablename);
        try
            {
		    // gets the metadata of the resultset
			meta = rset.getMetaData();
			out.println("<"+tablename+">");
			while (rset.next())
				{
				try {
					out.print("<TR>");
					for (j=1; j<=meta.getColumnCount(); j++)
						{
						out.print("<"+meta.getColumnName(j)+">");
						try
							{
								switch (meta.getColumnType(j))
								{
									

								case Types.CLOB:
								case 1111:
									Clob theClob=rset.getClob(j);
									int nClobLen=(int)theClob.length();
									if (nClobLen>0)
										out.print(EncodeUtil.xmlEncode(theClob.getSubString(1,nClobLen)));
										// out.print(EncodeUtil.xmlEncode(theClob.getSubString(1,Math.min(nClobLen,2000))));
									break;

			
	
								case Types.DATE:
									out.print(formatter.format(rset.getDate(j)));
									break;
								case Types.DECIMAL:
								case Types.DOUBLE:
								case Types.FLOAT:
								case Types.REAL:
								case Types.NUMERIC:
								case Types.SMALLINT:
								case Types.INTEGER:
									out.print(not_null(rset.getString(j)));
									break;
								default:
									out.print(EncodeUtil.xmlEncode(not_null(rset.getString(j))));
									break;
								}
							}
			           catch (Exception e)
			                {
			                    out.println("<!-- XML Export ERROR: in record of "+tablename+"..."+e.getMessage()+" -->");
			                }
						out.println("</"+meta.getColumnName(j)+">");
						} 
					out.println("</TR>");
					}
	           catch (Exception e)
	                {
	                    out.println("<!-- XML Export ERROR: in record of "+tablename+"..."+e.getMessage()+" -->");
	                }
				}
			out.println("</"+tablename+">");
           }
           catch (Exception e)
                {
                    out.println("<!-- XML Export ERROR: reading "+tablename+"..."+e.getMessage()+" -->");
                }
		rset.close();
		stmt.close();
        }
        catch (Exception ex)
            {
                System.out.println("<!-- WARNING: "+tablename+" not found..."+ex.getMessage()+" -->" );
            }
    }
%>
<%-- open country database--%>
<%@ include file="/util/opendatabase.jspf" %>
<%htmlServer.outputLanguageHtml(getServletConfig().getServletContext().getRealPath("html"),"/header",countrybean.getLanguage(),out);%>
<%
ServletContext sc = getServletConfig().getServletContext();
String sSourcePath= sc.getRealPath("/download");
if (!sSourcePath.endsWith("/"))
	sSourcePath+="/";

String sXML="DI_export_"+countrybean.country.scountryid+".xml";

PrintStream xmlout = new PrintStream(sSourcePath+sXML,"UTF-8");


xmlout.println("<?xml version=\"1.0\"  encoding=\"UTF-8\" ?>");
xmlout.println("<DESINVENTAR>");
try	{
	outputTable ("datamodel", xmlout, con, countrybean.dbType);
	outputTable ("eventos", xmlout, con, countrybean.dbType);
	outputTable ("causas", xmlout, con, countrybean.dbType);
	outputTable ("niveles", xmlout, con, countrybean.dbType);
	outputTable ("lev0", xmlout, con, countrybean.dbType);
	outputTable ("lev1", xmlout, con, countrybean.dbType);
	outputTable ("lev2", xmlout, con, countrybean.dbType);
	outputTable ("regiones", xmlout, con, countrybean.dbType);
	outputTable ("extensiontabs", xmlout, con, countrybean.dbType);
	outputTable ("diccionario", xmlout, con, countrybean.dbType);	
	outputTable ("extensioncodes", xmlout, con, countrybean.dbType);
	outputTable ("fichas", xmlout, con, countrybean.dbType);
	outputTable ("extension", xmlout, con, countrybean.dbType);
	outputTable ("level_maps", xmlout, con, countrybean.dbType);
	outputTable ("info_maps", xmlout, con, countrybean.dbType);
	outputTable ("level_attributes", xmlout, con, countrybean.dbType);
	outputTable ("attribute_metadata", xmlout, con, countrybean.dbType);
	
	outputTable ("metadata_national", xmlout, con, countrybean.dbType);
	outputTable ("metadata_national_values", xmlout, con, countrybean.dbType);
	outputTable ("metadata_national_lang", xmlout, con, countrybean.dbType);
	outputTable ("metadata_indicator", xmlout, con, countrybean.dbType);
	outputTable ("metadata_indicator_lang", xmlout, con, countrybean.dbType);
	outputTable ("metadata_element", xmlout, con, countrybean.dbType);
	outputTable ("metadata_element_costs", xmlout, con, countrybean.dbType); 
	outputTable ("metadata_element_lang", xmlout, con, countrybean.dbType);
	outputTable ("metadata_element_indicator", xmlout, con, countrybean.dbType);
	
	stmt = con.createStatement ();
	// we assume all levels are always there, or none
	rset = stmt.executeQuery("Select table_level,table_name,table_code from level_attributes order by table_level");
	while (rset.next())
	 	{
		String sTable=htmlServer.not_null(rset.getString("table_name")).trim();
		// TODO: not clear how this will happen!!!  outputTable (sTable, xmlout, con, countrybean.dbType);
		}
    rset.close();
	stmt.close();	
	}
catch(Exception ex1)
	{
	out.println("<!-- Error in XML export: "+ex1.toString()+" -->");
	}	
dbCon.close();

xmlout.println("</DESINVENTAR>");
xmlout.close();

File f= new File(sSourcePath+sXML);
String sSizeKb="n/a";
if (f.exists())
		sSizeKb=countrybean.formatDouble(f.length()/(1024.0*1024),-2)+" Mb";

%>

<table width="900" cellspacing="0" cellpadding="3" border="1"  bordercolor="white" class="pageBackground">
<tr>
<td colspan=4 class='bodymedlight'>
<br/>
<br>
<br>
<a href="/DesInventar/download/<%=sXML%>" alt="" border="0">Right-Click here and select Save As to download the database XML export (<%=sSizeKb%>)</a>
<br>
<br>



</td>
</tr>


</table>

<br>
</body>
</html>
