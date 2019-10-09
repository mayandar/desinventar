<?xml version="1.0"  encoding="UTF-8" ?>
<%@ page import="java.io.*" %><%@ page import="java.sql.*" %><%@ page import="java.util.*" %><%@ page import="java.text.*" %><%@ page import="org.lared.desinventar.system.Sys" %><%@ page import="org.lared.desinventar.util.*" %><%@ page import="org.lared.desinventar.webobject.*" %><jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" /><jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />
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
            sRet = theClob.getSubString(1,nClobLen);
            }
        catch (Exception eclob)
            {
				sRet+"Exception getting CLOB :";
            }
    return sRet;
    }

void outputTable (String tablename, JspWriter out, Connection con)
    {
	ResultSetMetaData meta;     // SQL metadata of the resultset
	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
	String sTag;
    int j;
    String sStr;
    try
        {
							                  //createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
		Statement stmt=con.createStatement(); //resultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY); //CONCUR_UPDATABLE
		ResultSet rset=stmt.executeQuery("Select * from "+tablename);
        try
            {
		    // gets the metadata of the resultset
			meta = rset.getMetaData();
			out.println("<"+tablename+">");
			while (rset.next())
				{
				out.print("<TR>");
				try {
					for (j=1; j<=meta.getColumnCount(); j++)
						{
						out.print("<"+meta.getColumnName(j)+">");
						try
							{
								switch (meta.getColumnType(j))
								{
								case Types.CLOB:
								case 1111:
								out.print(EncodeUtil.xmlEncode(get_ClobString(rset.getClob(j))));
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
<%@ include file="/inv/checkUserIsLoggedIn.jsp" %>
<%@ include file="/util/opendatabase.jspf" %>
<DESINVENTAR>
<%
response.setContentType("application/xml");
response.setHeader("Content-disposition", "attachment;filename=DI_EXPORT.xml");
response.setHeader("Content-Type", "application/xml; charset=utf-8");
try	{
	dbutils.checkDiccionary(con);
	outputTable ("datamodel", out, con);
	outputTable ("eventos", out, con);
	outputTable ("causas", out, con);
	outputTable ("niveles", out, con);
	outputTable ("lev0", out, con);
	outputTable ("lev1", out, con);
	outputTable ("lev2", out, con);
	outputTable ("regiones", out, con);
	outputTable ("extensiontabs", out, con);
	outputTable ("diccionario", out, con);	
	outputTable ("extensioncodes", out, con);
	outputTable ("fichas", out, con);
	outputTable ("extension", out, con);
	outputTable ("level_maps", out, con);
	outputTable ("info_maps", out, con);
	outputTable ("level_attributes", out, con);
	outputTable ("attribute_metadata", out, con);
	
	outputTable ("metadata_national", out, con);
	outputTable ("metadata_national_values", out, con);
	outputTable ("metadata_national_lang", out, con);

	outputTable ("metadata_indicator", out, con);
	outputTable ("metadata_indicator_lang", out, con);
	
	outputTable ("metadata_element", out, con);
	outputTable ("metadata_element_costs", out, con); 
	outputTable ("metadata_element_lang", out, con);
	
	outputTable ("metadata_element_indicator", out, con);

	stmt = con.createStatement ();
	// we assume all levels are always there, or none
	rset = stmt.executeQuery("Select table_level,table_name,table_code from level_attributes order by table_level");
	while (rset.next())
	 	{
		String sTable=htmlServer.not_null(rset.getString("table_name")).trim();
		// TODO: not clear how this will happen!!!  outputTable (sTable, out, con);
		}
    rset.close();
	stmt.close();	
	}
catch(Exception ex1)
	{
	out.println("<!-- Error in XML export: "+ex1.toString()+" -->");
	}	
dbCon.close();
%></DESINVENTAR>