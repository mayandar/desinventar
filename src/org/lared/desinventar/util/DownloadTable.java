package org.lared.desinventar.util;

import java.io.PrintStream;
import java.sql.Clob;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;
import java.sql.Types;
import java.text.SimpleDateFormat;

import javax.servlet.jsp.JspWriter;

public class DownloadTable {
public String not_null(String strParameter)
	{
		int pos;
		String sReturn;

		if (strParameter==null)
			return "";
		else
			return strParameter;
	}

public String get_ClobString(Clob theClob)
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

public void outputTable (String tablename, PrintStream out, Connection con)
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

public void outputTable (String tablename, JspWriter out, Connection con, String whereClause)
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
		ResultSet rset=stmt.executeQuery("Select * from "+tablename+" "+whereClause);
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

public void outputTable (String tablename, String tablename2, JspWriter out, Connection con, String whereClause)
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
		//"Select * from metadata_element e, metadata_element_indicator ei 
		// where e.metadata_country='"+countrybean.countrycode+"' 
//		 	and e.metadata_element_key=ei.metadata_element_key 
//			and  ei.metadata_country=e.metadata_country 
//			and ei.indicator_key="+indicator.indicator_key+"  
//			order by e.metadata_element_key"
		ResultSet rset=stmt.executeQuery("Select "+tablename+".* from "+tablename+", "+tablename2+whereClause);
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
}
