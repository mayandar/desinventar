<?xml version="1.0"  encoding="UTF-8" ?>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="org.lared.desinventar.system.Sys" %>
<%@ page import="org.lared.desinventar.util.*" %>
<%@ page import="org.lared.desinventar.webobject.*" %>

<jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" />
<jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" />


<%!

String not_null(String strParameter)
  {
    //int pos;
    //String sReturn;

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
            }
    return sRet;
    }

void outputTable (String sQuery, String tablename, JspWriter out, Connection con)
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
		ResultSet rset=stmt.executeQuery(sQuery);
		
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
response.setHeader("Content-disposition", "attachment;filename=LEC_DI_EXPORT.xml");
response.setHeader("Content-Type", "application/xml; charset=utf-8");

try	{
	
	String sQuery = "SELECT i.*, f.heridos, f.muertos, f.vivafec, f.vivdest "
					+ "FROM LEC_IdSuceso i LEFT JOIN fichas f ON f.clave = i.claveFichas "
					+ "WHERE i.OldCat IS NOT NULL AND i.status = 0 ";
	String sName = "Afectación";
	
	if (request.getParameter("acc")!=null && request.getParameter("acc").equals("si")) {
		sQuery = "SELECT "
					+ "FIRST(i.fecha) as fecha, FIRST(i.NewCat) as Categoria, i.IdSuceso, "
					+ "SUM(f.heridos) as SumHeridos, SUM(f.muertos) as SumMuertos, "
					+ "SUM(f.vivafec) as SumVivAf, SUM(f.vivdest) as SumVivDest, "
					+ "COUNT(i.claveFichas) as NRegistros, SUM(i.PEconomica) as PEconomica "
				+ "FROM "
					+ "(LEC_IdSuceso i "
					+ "LEFT JOIN fichas f ON f.clave = i.claveFichas) "
				+ "WHERE i.NewCat IS NOT NULL AND i.status = 0 "
				+ "GROUP BY i.IdSuceso "
				+ "ORDER BY i.fecha ";
		sName += " ACC";
	}
	
	outputTable(sQuery,sName,out,con);
	
	}
catch(Exception e)
	{
	out.println("<!-- Error in XML export: "+e.toString()+" -->");
	}	
dbCon.close();

%></DESINVENTAR>