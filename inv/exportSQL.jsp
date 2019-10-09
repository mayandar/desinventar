<%@ page import="java.io.*" %><%@ page import="java.sql.*" %><%@ page import="java.util.*" %><%@ page import="java.text.*" %><%@ page import="org.lared.desinventar.system.Sys" %><%@ page import="org.lared.desinventar.util.*" %><%@ page import="org.lared.desinventar.webobject.*" %><jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" /><jsp:useBean id="user" class="org.lared.desinventar.webobject.xuser" scope="session" /><%!
String not_null(String strParameter)
  {
    int pos;
    String sReturn;

    if (strParameter==null)
        return "";
     else
        {
		strParameter=strParameter.replace("\n"," ");
		return strParameter;
		}
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

int getDiType(int nType)
	{
	int nCurrentFieldType =0;
		switch (nType)
		 {
		   case Types.CLOB:							   	
		   case 1111: // type reported by Oracle for BLOB types...
		   case -1: // type reported by ACCESS for MEMO types...
		   case Types.BLOB:
			 nCurrentFieldType=5;
		     break;
		   case Types.DATE:
			 nCurrentFieldType=4;
			 break;
		   case Types.DECIMAL:
		   case Types.DOUBLE:
		   case Types.FLOAT:
		   case Types.REAL:
		   case Types.NUMERIC:
			 nCurrentFieldType=2;
			 break;
		   case Types.SMALLINT:
		   case Types.INTEGER:
		   case Types.BIGINT:
		   case Types.TINYINT:
			 nCurrentFieldType=1;
		     break;
		   case Types.VARCHAR:
			 nCurrentFieldType=0;
		     break;
	    }
	return nCurrentFieldType;
	}
	
void outputTable (String tablename, JspWriter out, Connection con, int dbType, int preface)
    {
	ResultSetMetaData meta;     // SQL metadata of the resultset
	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
	String sField="";;
	String sComma="";
    int j;
    String htmlLine;
	lev0 woAny=new lev0();
	woAny.dbType=dbType;
	int nCurrentFieldType=0;
    try
        {
		out.println("-- "+tablename+" -- ");
		Statement stmt=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY); //CONCUR_UPDATABLE
		ResultSet rset=stmt.executeQuery("Select * from "+tablename);
        try
            {
		    // gets the metadata of the resultset
			meta = rset.getMetaData();
			switch (preface)
				{
				case 1:  // add fields to table (except if clave_ext), for extension!!
					for (j=2; j<=meta.getColumnCount(); j++)
						{
						out.print("alter table "+tablename+" add "+meta.getColumnName(j).toLowerCase());
   						int nType=meta.getColumnType(j);
						nCurrentFieldType=getDiType(nType);
						out.print(" "+DbImplementation.typeNames[dbType][nCurrentFieldType]);
						if (nCurrentFieldType==0)
				   			out.print("("+meta.getColumnDisplaySize(j)+")");
						out.println(";");
						}
						break;
				case 2: // create and add fields to table
					sComma="";
					out.println("create table "+tablename+"(");
					for (j=1; j<=meta.getColumnCount(); j++)
						{
						out.print("   "+meta.getColumnName(j));
   						int nType=meta.getColumnType(j);
						nCurrentFieldType=getDiType(nType);
						out.print(" "+DbImplementation.typeNames[dbType][nCurrentFieldType]);
						if (nCurrentFieldType==0)
				   			out.print("("+meta.getColumnDisplaySize(j)+")");
						if (j<=meta.getColumnCount()-1)
							out.println(",");
						}
				     out.println(");");
					 break;
				}
			sField="";
			while (rset.next())
				{
				try {
					out.print("insert into "+tablename+" (");
					sComma="";
					for (j=1; j<=meta.getColumnCount(); j++)
						{
						sField=meta.getColumnName(j);
						if (sField.equalsIgnoreCase("xmin_") ||
						    sField.equalsIgnoreCase("xmin"))
							sField=woAny.sqlXmin();
						if (sField.equalsIgnoreCase("xmax_") ||
						    sField.equalsIgnoreCase("xmax"))
							sField=woAny.sqlXmax();
						out.print(sComma+sField);
						sComma=",";
						}
					sComma="";
					out.print(") values (");
					for (j=1; j<=meta.getColumnCount(); j++)
						{
						out.print(sComma);
						sComma=",";
						try
							{
							switch (meta.getColumnType(j))
								{
								case Types.CLOB:
								case 1111:
								out.print("'"+htmlServer.check_quotes(get_ClobString(rset.getClob(j)))+"'");
								break;
								case Types.DATE:
								    java.sql.Date d=rset.getDate(j);
									if (d==null)
										out.print("null");
									else
										out.print(woAny.sqlCharDate("'"+formatter.format(d)+"'"));
									break;
								case Types.DECIMAL:
								case Types.DOUBLE:
								case Types.FLOAT:
								case Types.REAL:
								case Types.NUMERIC:
								case Types.SMALLINT:
								case Types.INTEGER:
									sField=rset.getString(meta.getColumnName(j));
									if (sField==null)
										out.print("null");
									else
										out.print(sField);
									break;
								default:
									sField=rset.getString(meta.getColumnName(j));
									if (sField==null)
										out.print("null");
									else
										out.print(woAny.sqlStringConstant()+htmlServer.check_quotes(sField)+"'");
									break;
								}
							}
			           catch (Exception e)
			                {
			                    out.println("-- SQL Export ERROR: in record of "+tablename+"..."+e.getMessage()+" *** ");
			                }
						} 
					out.println(");");
					}
	           catch (Exception e)
	                {
	                    out.println("-- SQL Export ERROR: in record of "+tablename+"..."+e.getMessage()+" **** ");
	                }
				}
           }
           catch (Exception e)
                {
                    out.println("-- SQL Export ERROR: reading "+tablename+"..."+e.getMessage()+" ***** ");
                }
		rset.close();
		stmt.close();
        }
        catch (Exception ex)
            {
                System.out.println("-- SQL export WARNING: "+tablename+" not found..."+ex.getMessage()+" ** " );
            }
    }

// 

%><%@ include file="/inv/checkUserIsLoggedIn.jsp" %><%@ include file="/util/opendatabase.jspf" %><%
// int dbType=...  ; declared in opendatabase.jspf

response.setHeader("Content-disposition", "attachment;filename=SQLExport.sql");
response.setHeader("Content-Type", "text/plain; charset=UTF-8");

if (request.getParameter("dbType")!=null)
   dbType=countrybean.extendedParseInt(request.getParameter("dbType"));
try	{
	dbutils.checkDiccionary(con);
	if (request.getParameter("table")!=null)
		outputTable (request.getParameter("table"), out, con, dbType,2);
	else
		{		
		outputTable ("datamodel", out, con, dbType,0);
		outputTable ("eventos", out, con, dbType,0);
		outputTable ("causas", out, con, dbType,0);
		outputTable ("niveles", out, con, dbType,0);
		outputTable ("lev0", out, con, dbType,0);
		outputTable ("lev1", out, con, dbType,0);
		outputTable ("lev2", out, con, dbType,0);
		outputTable ("regiones", out, con, dbType,0);
		outputTable ("extensiontabs", out, con, dbType,0);
		outputTable ("diccionario", out, con, dbType,0);
		outputTable ("extensioncodes", out, con, dbType,0);
		outputTable ("fichas", out, con, dbType,0);
		outputTable ("extension", out, con, dbType,1);
		outputTable ("level_maps", out, con, dbType,0);
		outputTable ("info_maps", out, con, dbType,0);
		outputTable ("level_attributes", out, con, dbType,0);
		outputTable ("attribute_metadata", out, con, dbType,0);
		
		stmt = con.createStatement ();
		// we assume all levels are always there, or none
		rset = stmt.executeQuery("Select table_level,table_name,table_code from level_attributes order by table_level");
		while (rset.next())
		 	{
			String sTable=htmlServer.not_null(rset.getString("table_name")).trim();
			// TODO: not clear how creating this tables  will happen!!!  
			outputTable (sTable, out, con, dbType,2);
			}
	    rset.close();
		stmt.close();	
		}
	}
catch(Exception ex1)
	{
	out.println("-- Error in SQL export: "+ex1.toString()+" -->");
	}	
dbCon.close();
%>
