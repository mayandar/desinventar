package org.lared.desinventar.servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.net.*;
import java.util.Properties;
import java.util.HashMap;
import org.lared.desinventar.system.*;
import org.lared.desinventar.util.*;
// make it accept a query as a parameter
// make errors come out in a pane at the bottom instead of at the top
public class webobj extends HttpServlet 
{
    final int Types_Oracle_Date = 93; // this is what oracle returns instead of
                                      // Types.Date

    final int Types_Oracle_CLOB = 1111; // this is what oracle returns instead
                                        // of Types.CLOB?

  Sys s = new Sys();
  
  String htmlPrefix = Sys.strFilePrefix + "/";
  String sTemplateDir = Sys.strFilePrefix + "/generator/";

  String sDownloadDir = "/DesInventar/generator/";
  String sTemplateFile = "WOtemplate.java";

    String tableName;

    String packageName;
    
    boolean generateAudit;

    String javaLine;

    String repeatableSufix = "lang_cd";

    Connection con; // SQL stardard connection

    boolean bConnectionMade = false; // to test the connection

    Statement stmt; // SQL statement object

    ResultSet rset; // SQL resultset

    ResultSet auxset; // auxiliary SQL resultset

    DatabaseMetaData dbMeta; // Metadata of the database

    ResultSetMetaData meta; // SQL metadata of the resultset
    
    String schema = "DESINVENTAR"; // schemma of the tables

    int databaseType=0; // 0-> Oracle thin, 1-> access, 2-> SQL Server, etc (same as Sys)

    int result = 0; // get result from int methods

    BufferedReader in; // template file

    PrintWriter out_file; // output subclass !!!

    PrintWriter out; // the HTML output. note this makes this class

    // NOT usable in a multiuser environment..

    public String getServletInfo()
    {
    return "Web-based Version of  webObject generator";
    }

    private void getPrimaryKeys() {
		// reimplement this databaseMetaData method here because of the
		// differences in how
		// Oracle and SQL Server work
		try {
			if (Sys.iDatabaseType==0)
				auxset = dbMeta.getPrimaryKeys("", schema, tableName.toUpperCase());
			else
				auxset = dbMeta.getPrimaryKeys(null, null, tableName.toUpperCase());
		} catch (SQLException e) {
			out.println("Error determining primary key for table " + tableName + " ("
					+ e.toString() + ")");
		}
	}

    private void getTables(String[] tableTypes) {
		// reimplement this databaseMetaData method here because of the
		// differences in how
		// Oracle and SQL Server work

		try {
			String schema = "";
			if (Sys.iDatabaseType==0)
				schema = Sys.sDbUserName.toUpperCase();
			else
				schema = null;

			rset = dbMeta.getTables(null, schema, "%", tableTypes);
		} catch (SQLException e) {
			out.println("Error determining tables" + e.toString());
		}
	}
    
    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException
    {

    	Sys.iDatabaseType=Sys.iMsSqlDb;
    	Sys.sDbDriverName="com.microsoft.jdbc.sqlserver.SQLServerDriver";
    	Sys.sDataBaseName="jdbc:microsoft:sqlserver://localhost:1433;databaseName=iran";//desinventar";
    	Sys.sDbUserName="sa";
    	Sys.sDbPassword="magician";
    	
    	
      //Database Connection Objects
      String[] tableTypes =
          {
          "TABLE"
          };

        // start the html output
        resp.setContentType("text/html");
        out = new PrintWriter(resp.getOutputStream());

        out.println("<HTML>");
        out.println("<HEAD><TITLE>Persistent Object Generator</TITLE></HEAD>");
        out.println("<BODY>");
        // add Javascript to check that at least one item is selected
        out.println("<script language='javascript'>");
        out.println("function bSomethingSelected()");
        out.println("{");
		out.println("if (document.generator.tablename.selectedIndex==-1)");
		out.println("	{");
		out.println("	alert ('Please select at least one table from the list');");
		out.println("	return false;");
		out.println("	} ");
		out.println("return true;");
		out.println("}");
		out.println("</script>");

        out.println("<H1>Persistent Object Generator</H2>");
        ServletConfig scg = getServletConfig(); 
        ServletContext _servletContext = scg.getServletContext(); 
        out.println("Current path is "+_servletContext.getRealPath("/"));
        out.println("<B>Select table to generate persistentObject:</b><br>");
        out.println("<form name='generator' action='webobj' method='post'>");
        out.println("<select name='tablename' size=20 multiple>");


        dbConnection dbConn = null;
        try
        {
          dbConn = new dbConnection();
          con = dbConn.dbGetConnection();
        }
        catch (Exception ex)
        {
          System.err.println("Error: " + ex.toString());
        }


      // processes the function if connected
      if (con != null)
      {
        try
        {
          // get the list of tables from the database metadata 
          dbMeta = con.getMetaData();
          getTables(tableTypes); // this method will set the value of rset
          
          while (rset.next())
          {
            out.println("<option value='" + rset.getString("TABLE_NAME") + "'>" + rset.getString("TABLE_NAME") + "</option>");
          }
        }
        catch (Exception ex2)
        {
        }
        finally {
            dbConn.close();
        }
      }
      else
      {
        out.println("Unable to connect to database...<br>");
      }
      out.println("</select><br>");
      out.println("<BR><img src='/DesInventar/images/package.jpg' width=75 height=75 align=left><BR>Which package do you want this class to belong to?<BR><input type=text size = 50 name=packageName value='org.lared.desinventar.webobject'>");
      out.println("<BR><BR><BR><input name=generateImage type=image border=0  width=75 height=75 src='/DesInventar/images/green-arrow.gif' onClick='return bSomethingSelected()'>");
      out.println("<BR>Generate audit information for this object?<BR><input type=checkbox name=generateAudit value='N'>");
      out.println("</form>");
      out.println("</BODY>");
      out.println("</HTML>");
      out.close();
    }

    private void checkClassName()
    {
      try
      {
        if (javaLine.indexOf("//CLASS NAME") >= 0)
        {
          out_file.println("// generated by persistentObjectGenerator...");
          javaLine = "public class " + tableName + " extends webObject";
          out_file.println(javaLine);
          javaLine = in.readLine(); // reads the class declaration
          javaLine = in.readLine(); // reads the {
          out_file.println("{");
        }
      }
      catch (Exception ex)
      {
      }

    }

    private void checkPackageName()
    {
      try
      {
        if (javaLine.indexOf("//PACKAGE NAME") >= 0)
        {
          javaLine = "package " + packageName +";";
          out_file.println(javaLine);
        }
      }
      catch (Exception ex)
      {
      }

    }

    private void checkDataMembers()
    {
      int j;
      try
      {
        if (javaLine.indexOf("// DATA MEMBERS") >= 0)
        {
          for (j = 1; j <= meta.getColumnCount(); j++)
          {
            switch (meta.getColumnType(j))
            {
              case Types.DATE:
              case Types_Oracle_Date:
                javaLine = "  String   ";
                break;
              case Types.DECIMAL:
                javaLine = "  int   ";
                break;
              case Types.DOUBLE:
                javaLine = "  double   ";
                break;
              case Types.FLOAT:
                javaLine = "  double   ";
                break;
              case Types.NUMERIC:
                javaLine = "  int    ";
                break;
              case Types.REAL:
                javaLine = "  double   ";
                break;
              case Types.SMALLINT:
              case Types.INTEGER:
                javaLine = "  int      ";
                break;
              default:
                javaLine = "  String ";
                break;
            }
            javaLine = "     public " + javaLine + meta.getColumnName(j).toLowerCase() + ";";
            out_file.println(javaLine);

            // out.println("MEMBER:  "+javaLine+" ["+meta.getColumnType(j)+"]");

          }

          // checks for linguistic field (ilanguageid) and generates the
          // repeating fieldname...
          for (j = 1; j <= meta.getColumnCount(); j++)
          {
            if (meta.getColumnName(j).equalsIgnoreCase(repeatableSufix))
            {
              out_file.println("\n");
              out_file.println("//--------------------------------------------------------------------------------");
              out_file.println("// returns a unique HTML fieldname. required for repeating persistentObjects in a form,");
              out_file.println("// based on the language..  ");
              out_file.println("//--------------------------------------------------------------------------------");
              out_file.println("public String assignName(String fieldName)");
              out_file.println("    {");
              out_file.println("    return fieldName+"+repeatableSufix+";");
              out_file.println("    }");
              out_file.println("\n");
              out.println("<br>linguistic/repeatable member: " + meta.getColumnName(j) + ", assignName() generated<br>");
            }
          }

        }
      }
      catch (Exception ex)
      {

      }

    }

    private void checkAssignValues()
    {
      int j;
      try
      {
        if (javaLine.indexOf("// ASSIGN FIELDS") >= 0)
        {
          for (j = 1; j <= meta.getColumnCount(); j++)
          {
            out_file.println("                case " + (j - 1) + ":     // " + meta.getColumnName(j).toLowerCase());
            javaLine = "                     value=";
            switch (meta.getColumnType(j))
            {
              case Types.DECIMAL:
              case Types.DOUBLE:
              case Types.FLOAT:
              case Types.REAL:
                  javaLine += "Double.toString(" + meta.getColumnName(j).toLowerCase() + ");";
                  break;
              case Types.NUMERIC:
              case Types.SMALLINT:
              case Types.INTEGER:
                javaLine += "Integer.toString(" + meta.getColumnName(j).toLowerCase() + ");";
                break;
              case Types.DATE:
              case Types_Oracle_Date:
              default:
                javaLine += meta.getColumnName(j).toLowerCase() + ";";
                break;
            }
            out_file.println(javaLine);
            out_file.println("                     break;");
          }
        }
      }
      catch (Exception ex)
      {

      }

    }

    private void checkGetForm()
    {
      int j;
      try
      {
        if (javaLine.indexOf("GET_FORM()") >= 0)
        {
          for (j = 1; j <= meta.getColumnCount(); j++)
          {
            javaLine = "\t\t" + meta.getColumnName(j).toLowerCase() + " = ";
            switch (meta.getColumnType(j))
            {
              case Types.DATE:
              case Types_Oracle_Date:
                javaLine += "strDate(not_null(req.getParameter(assignName(\"" + meta.getColumnName(j).toLowerCase() + "\"))));";
                break;
              case Types.DECIMAL:
              case Types.DOUBLE:
              case Types.FLOAT:
              case Types.REAL:
                  javaLine += "extendedParseDouble(req.getParameter(assignName(\"" + meta.getColumnName(j).toLowerCase() + "\")));";
                  break;
              case Types.NUMERIC:
              case Types.SMALLINT:
              case Types.INTEGER:
                javaLine += "extendedParseInt(req.getParameter(assignName(\"" + meta.getColumnName(j).toLowerCase() + "\")));";
                break;
              default:
                javaLine += "not_null(req.getParameter(assignName(\"" + meta.getColumnName(j).toLowerCase() + "\")));";
                break;
            }
            out_file.println(javaLine);
          }
        }
      }
      catch (Exception ex)
      {
      }
    }

    private void checkInsert() {
		int j;
		String colName="";
		try {
			if (javaLine.indexOf("// SQL_INSERT") >= 0) {
				out_file.println("\t\t\tint f=1;");
				out_file.println("\t\t\tsSql = \"insert into " + tableName.toUpperCase() + " (\";");
				javaLine = "";
				for (j = 1; j <= meta.getColumnCount(); j++) {
					if (j == 1)
						javaLine = "\t\t\tsSql += \"";
					else
						javaLine += ", ";

					javaLine += meta.getColumnName(j).toLowerCase();
					if ((javaLine.length() > 70) && (j < meta.getColumnCount())) {
						out_file.println(javaLine + "\";");
						out_file.print("\t\t\tsSql += \"");
						javaLine = "";
					}
				}
				out_file.println(javaLine + ")\";");

				String bindStatements = "";
				for (j = 1; j <= meta.getColumnCount(); j++) {
					if (j > 1)
						javaLine = ", ?";
					else
						javaLine = "\t\t\tsSql += \"VALUES (?";
					colName=meta.getColumnName(j).toLowerCase();
					//System.out.println("column "+meta.getColumnName(j)+" is
					// of type "+meta.getColumnType(j));
					switch (meta.getColumnType(j)) {
					case Types.DATE:
					case Types_Oracle_Date:
						bindStatements += "\t\t\tif ("+colName+".length() > 0)\r\n";
						bindStatements += "\t\t\t\tpstmt.setDate(f++, new java.sql.Date(largeFormatter.parse("
								+ meta.getColumnName(j).toLowerCase() + ").getTime()));\r\n";
						bindStatements += "\t\t\telse\r\n";
						bindStatements += "\t\t\t\tpstmt.setNull(f++, Types.DATE);\r\n";
						break;
					case Types.DECIMAL:
					case Types.DOUBLE:
					case Types.FLOAT:
					case Types.REAL:
						bindStatements += "\t\t\tpstmt.setDouble(f++, "+ colName + ");\r\n";
						break;
					case Types.NUMERIC:
					case Types.SMALLINT:
					case Types.INTEGER:
						bindStatements += "\t\t\tpstmt.setInt(f++, " + colName + ");\r\n";
						break;
					default:
						bindStatements += "\n\t\t\tif ("+colName+" == null || "+colName+".length() == 0)\n\t\t\t\tpstmt.setNull(f++, Types.VARCHAR);\n\t\t\telse\n";
						bindStatements += "\t\t\t\tpstmt.setString(f++, "+ colName + ");\r\n";
						break;
					}
					out_file.print(javaLine);
				}
				javaLine = ")\";";
				out_file.println(javaLine);
				out_file.println("\t\t\tpstmt = con.prepareStatement(sSql);");
				out_file.println("\r\n" + bindStatements);
			}
		} catch (Exception ex) {
		}
	}

    private int findColumnByName(String sColName)
    {
    	int nRet=0;
    	try
    	{
    	 for (int j=1; j<=meta.getColumnCount() && nRet==0; j++)
    		 if (meta.getColumnName(j).equalsIgnoreCase(sColName))
    			 nRet=j;
    	}
    	catch (Exception e)
    	{}
    	return nRet;
    }
    
    private String generateWhere()
    {
        String colName = "";
        String bindStatements = "";
		// table
        getPrimaryKeys();  // this method will set the auxset variable        
        javaLine = "\t\t\tsSql += \" WHERE ";
        int j=1;
        try
        {
        while (auxset.next())
        {
		  colName = auxset.getString("COLUMN_NAME").toLowerCase();
          if (j > 1)
            javaLine += ") AND (";
          else
            javaLine += "(";
          javaLine +=  colName+ " = ?";

			switch (meta.getColumnType(findColumnByName(colName))) {
			case Types.DATE:
			case Types_Oracle_Date:
				bindStatements += "\n\t\t\tif ("+colName+" == null || "+colName+".length() == 0)\n\t\t\t\tpstmt.setNull(f++, Types.DATE);\n\t\t\telse\n";
				bindStatements += "\t\t\t\tpstmt.setDate(f++, new java.sql.Date(largeFormatter.parse("+ colName + ").getTime()));\r\n";
				break;

			case Types.DECIMAL:
			case Types.DOUBLE:
			case Types.FLOAT:
			case Types.REAL:
				bindStatements += "\t\t\tpstmt.setDouble(f++, "+ colName + ");\r\n";
				break;
			case Types.NUMERIC:
			case Types.SMALLINT:
			case Types.INTEGER:
				bindStatements += "\t\t\tpstmt.setInt(f++, "+ colName + ");\r\n";
				break;
			default:
				bindStatements += "\n\t\t\tif ("+colName+" == null || "+colName+".length() == 0)\n\t\t\t\tpstmt.setNull(f++, Types.VARCHAR);\n\t\t\telse\n";
				bindStatements += "\t\t\t\tpstmt.setString(f++, "+ colName + ");\r\n";
				break;
			}

          j++;
        }
  		out_file.println(javaLine + ")\";");
        }
        catch (Exception ex)
        {
          out_file.println("// err:" + ex.toString() + " line = " + javaLine);
        }

        return bindStatements;
        
    }

    private void checkUpdate() {
		int j;
		int nField=1;
		String colName = "";
		HashMap dontUpdate =new HashMap();
        
		getPrimaryKeys();  // this method will set the auxset variable
		// now it will collect all variables that SHOULD NOT be updated as they are part of the PK
        try
        {
        	while (auxset.next())
        	{
        		colName = new String(auxset.getString("COLUMN_NAME"));
        		dontUpdate.put(colName,colName);
        	}
        }
        catch (Exception exhm)
        {}
        
		
		try {
			if (javaLine.indexOf("// SQL_UPDATE") >= 0) {
				out_file.println("\t\t\tint f=1;");
				out_file.println("\t\t\tsSql = \"UPDATE " + tableName.toUpperCase() + " SET \";");
				javaLine = "";

				String bindStatements = "";
				String whereBindStatements = "";
				
				for (j = 1; j <= meta.getColumnCount(); j++) 
				  if (dontUpdate.get(meta.getColumnName(j))==null) 
					  {
						if (nField > 1)
							javaLine = ", ";
						else
							javaLine = "";
	
						colName = meta.getColumnName(j).toLowerCase();
						javaLine = "\t\t\tsSql += \"" + javaLine + colName + " = ?\";";
						
						switch (meta.getColumnType(j))	{
							case Types.DATE:
							case Types_Oracle_Date:
								bindStatements += "\n\t\t\tif ("+colName+" == null || "+colName+".length() == 0)\n\t\t\t\tpstmt.setNull(f++, Types.DATE);\n\t\t\telse\n";
								bindStatements += "\t\t\t\tpstmt.setDate(f++, new java.sql.Date(largeFormatter.parse("
								+ colName + ").getTime()));\r\n";
								break;
							case Types.DECIMAL:
							case Types.DOUBLE:
							case Types.FLOAT:
							case Types.REAL:
								bindStatements += "\t\t\tpstmt.setDouble(f++, "	+ colName + ");\r\n";
								break;
							case Types.NUMERIC:
							case Types.SMALLINT:
							case Types.INTEGER:
							case Types.TINYINT:
								bindStatements += "\t\t\tpstmt.setInt(f++, "	+ colName + ");\r\n";
								break;
							default:
								bindStatements += "\n\t\t\tif ("+colName+" == null || "+colName+".length() == 0)\n\t\t\t\tpstmt.setNull(f++, Types.VARCHAR);\n\t\t\telse\n";
								bindStatements += "\t\t\t\tpstmt.setString(f++, "+ colName + ");\r\n";
								break;
							}
						out_file.println(javaLine);
						nField++;
					}
				whereBindStatements = generateWhere();
				out_file.println("\t\t\tpstmt = con.prepareStatement(sSql);");
				out_file.println("\r\n" + bindStatements);
				out_file.println("\r\n" + whereBindStatements);
			}
		} catch (Exception ex) {
			out_file.println("// err:" + ex.toString() + " line = " + javaLine);
		}

	}

    
    
    private void checkDelete()
    {
      int j;

      String colName = "";
      String bindStatements = "";
      if (javaLine.indexOf("// SQL_DELETE") >= 0)
        {
		out_file.println("\t\t\tint f=1;");
		out_file.println("\t\t\tsSql = \"DELETE FROM " + tableName.toLowerCase() + "\";");
		// now generates the where clause, getting the primary keys of the
		bindStatements = generateWhere();
		out_file.println("\t\t\tpstmt = con.prepareStatement(sSql);");
		out_file.println("\r\n" + bindStatements);
        }

    }


    private void checkSelect()
    {
      int j;
      String bindStatements = "";
     try
      {
        if (javaLine.indexOf("// SQL_GET") >= 0)
        {
          // FORCE ORDER OF SELECTED FIELDS:
        String sFieldList="";
        String sComma="";
        for (j = 1; j <= meta.getColumnCount(); j++)
            {
        	sFieldList+= sComma+ meta.getColumnName(j).toLowerCase(); 
        	sComma=",";
            }
 		  out_file.println("\t\t\tint f=1;");
          out_file.println("\t\t\tsSql = \"SELECT "+sFieldList+" FROM " + tableName.toLowerCase() + "\";");
          // now generates the where clause, getting the primary keys of the table
  		// now generates the where clause, getting the primary keys of the
  		bindStatements = generateWhere();
  		out_file.println("\t\t\tpstmt = con.prepareStatement(sSql);");
  		out_file.println("\r\n" + bindStatements);
        }
      }
      catch (Exception ex)
      {
        out_file.println("// err:" + ex.toString() + " line = " + javaLine);
      }

    }

    private void checkLoad()
    {
      int j;

      try
      {
        if (javaLine.indexOf("// SQL_LOAD") >= 0)
        {
          for (j = 1; j <= meta.getColumnCount(); j++)
          {
        	  out_file.println("\n\t\t\ttry {");
        	  javaLine = "\t\t\t\t" + meta.getColumnName(j).toLowerCase() + " = ";
            switch (meta.getColumnType(j))
            {
              case Types.CLOB:
              case Types_Oracle_CLOB:
                javaLine += "getClobString(rset.getClob(\"" + meta.getColumnName(j).toLowerCase() + "\"));";
                break;
              case Types.DATE:
              case Types_Oracle_Date:
                javaLine += "strDate(rset.getDate(\"" + meta.getColumnName(j).toLowerCase() + "\"));";
                break;

              case Types.DECIMAL:
              case Types.DOUBLE:
              case Types.FLOAT:
              case Types.REAL:
                  javaLine += "rset.getDouble(\"" + meta.getColumnName(j).toLowerCase() + "\");";
                  break;
              case Types.NUMERIC:
              case Types.SMALLINT:
              case Types.INTEGER:
                javaLine += "rset.getInt(\"" + meta.getColumnName(j).toLowerCase() + "\");";
                break;
              default:
                javaLine += "not_null(rset.getString(\"" + meta.getColumnName(j).toLowerCase() + "\"));";
                break;
            }
            out_file.println(javaLine);
            out_file.println("\t\t\t} catch (Exception ex) {");
            out_file.println("\t\t\t\tlastError = \"<-- error attempting to access field "+meta.getColumnName(j).toLowerCase()+" -->\";");
            out_file.println("\t\t\t\tSystem.out.println(ex.toString());");
            out_file.println("\t\t\t}");
          }
        }
      }
      catch (Exception ex)
      {

        }

    }

    private void checkConstructor()
    {
      int j;
      try
      {
        if (javaLine.indexOf("// CONSTRUCTOR") >= 0)
        {
          out_file.println("\tpublic void init()");
          out_file.println("\t{");
          out_file.println("\t\tlastError=\"No errors detected\";");
          for (j = 1; j <= meta.getColumnCount(); j++)
          {
            javaLine = "\t\t" + meta.getColumnName(j).toLowerCase() + " = ";
            switch (meta.getColumnType(j))
            {
                    case Types.DECIMAL:
                    case Types.DOUBLE:
                    case Types.FLOAT:
                    case Types.NUMERIC:
                    case Types.REAL:
                    case Types.SMALLINT:
                    case Types.INTEGER:
                        javaLine += "0;";
                        break;
                    case Types_Oracle_Date:
                    case Types.DATE:
                    default:
                        javaLine += "\"\";";
                        break;
                    }
                    out_file.println(javaLine);
                }
                out_file.println("\t\tupdateHashTable();");
                out_file.println("\t}");
                out_file.println("");
                out_file.println("\tpublic " + tableName + "()");
                out_file.println("\t{");
                out_file.println("\t\tsuper(\"" + tableName + " object\");");
                out_file.println("\t\tinit();");
                out_file.println("\t}");

                // creates the bean getter and setter methods...
                generateGetSet();
            }
      }
      catch (Exception ex)
      {
      }
    }

    private void generateGetSet()
    {
      int j;
      String sMember;
      try
      {
        out_file.println("//--------------------------------------------------------------------------------");
        out_file.println("// getter and setter methods of the elements of the class");
        out_file.println("//--------------------------------------------------------------------------------\n");
        for (j = 1; j <= meta.getColumnCount(); j++)
        {
          javaLine = meta.getColumnName(j).toLowerCase();
          out_file.println("//--------------------------------------------------------------------------------");
          out_file.println("// METHODS FOR: " + javaLine);
          sMember = javaLine;
          javaLine = javaLine.substring(0, 1).toUpperCase() + javaLine.substring(1);
          out_file.println("\tpublic String get" + javaLine + "()");
          out_file.println("\t{");
          switch (meta.getColumnType(j))
          {
            case Types.DATE:
            case Types_Oracle_Date:
              out_file.println("\t\treturn " + sMember + ";");
              out_file.println("\t}\r\n");
              out_file.println("\tpublic void set" + javaLine + "(String sParameter)");
              out_file.println("\t{");
              out_file.println("\t\t" + sMember + " = strDate(sParameter);");
              out_file.println("\t}");
              break;
            case Types.DOUBLE:
            case Types.FLOAT:
            case Types.REAL:
              out_file.println("\t\treturn Double.toString(" + sMember + ");");
              out_file.println("\t}\r\n");
              out_file.println("\tpublic void set" + javaLine + "(String sParameter)");
              out_file.println("\t{");
              out_file.println("\t\t" + sMember + " = extendedParseDouble(sParameter);");
              out_file.println("\t}");
              break;
            case Types.DECIMAL:
            case Types.NUMERIC:
            case Types.SMALLINT:
            case Types.INTEGER:
              out_file.println("\t\treturn Integer.toString(" + sMember + ");");
              out_file.println("\t}\r\n");
              out_file.println("\tpublic void set" + javaLine + "(String sParameter)");
              out_file.println("\t{");
              out_file.println("\t\t" + sMember + " = extendedParseInt(sParameter);");
              out_file.println("\t}");
              break;
            default:
              out_file.println("\t\treturn " + sMember + ";");
              out_file.println("\t}\r\n");
              out_file.println("\tpublic void set" + javaLine + "(String sParameter)");
              out_file.println("\t{");
              out_file.println("\t\t" + sMember + " = sParameter;");
              out_file.println("\t}");
              break;
          }
          out_file.println("// end of methods for " + javaLine);
        }

      }
      catch (Exception ex)
      {

      }

    }

    private void checkFieldVector()
    {
      int j;

      try
      {
        if (javaLine.indexOf("// FIELD NAMES VECTOR") >= 0)
        {
          //out_file.println("\t\tint nMaxFields = " + meta.getColumnCount() + ";");
          for (j = 1; j <= meta.getColumnCount(); j++)
          {
            javaLine = "\t\tasFieldNames.put(\"" + meta.getColumnName(j).toLowerCase();

            switch (meta.getColumnType(j))
            {
              case Types.DECIMAL:
              case Types.DOUBLE:
              case Types.FLOAT:
              case Types.NUMERIC:
              case Types.REAL:
              case Types.SMALLINT:
              case Types.INTEGER:
                javaLine += "\", String.valueOf(" + meta.getColumnName(j).toLowerCase() + "));";
                break;
              case Types.DATE:
              case Types_Oracle_Date:
              default:
                javaLine += "\", " + meta.getColumnName(j).toLowerCase() + ");";
                break;
            }

            out_file.println(javaLine);
          }
        }
      }
      catch (Exception ex)
      {
      }
    }

    private void generateHTML()
    {
      int j;
      try
      {
        out_file.println("/*    HTML TEMPLATE");
        out_file.println("<table border=0 cellspacing=0 cellpadding=0>");
        for (j = 1; j <= meta.getColumnCount(); j++)
        {
          switch (meta.getColumnType(j))
          {
            case Types_Oracle_Date:
            case Types.DATE:
              javaLine = "<tr><td>" + meta.getColumnLabel(j).toLowerCase() + ":</td><td> <INPUT type='TEXT' size='10' maxlength='10'";
              break;
            case Types.DECIMAL:
            case Types.DOUBLE:
            case Types.FLOAT:
            case Types.NUMERIC:
            case Types.REAL: //USE getPrecision(int column)+ getScale(int column)+2/3??
              javaLine = "<tr><td>" + meta.getColumnLabel(j).toLowerCase() + ":</td><td>  <INPUT type='TEXT' size='"
                  + Math.min(meta.getColumnDisplaySize(j) + 1, 15)
                  + "' maxlength='" + meta.getColumnDisplaySize(j) + "'";
              break;
            case Types.SMALLINT:
            case Types.INTEGER: //USE getPrecision(int column)???
              javaLine = "<tr><td>" + meta.getColumnLabel(j).toLowerCase() + ":</td><td>  <INPUT type='TEXT' size='"
                  + Math.min(meta.getColumnDisplaySize(j) + 1, 5)
                  + "' maxlength='" + meta.getColumnDisplaySize(j) + "'";
              break;
            default:
              javaLine = "<tr><td>" + meta.getColumnLabel(j).toLowerCase() + ":</td><td>  <INPUT type='TEXT' size='"
                  + Math.min(meta.getColumnDisplaySize(j) + 1, 50)
                  + "' maxlength='" + meta.getColumnDisplaySize(j) + "'";
              break;
          }
          javaLine += " name='" + meta.getColumnName(j).toLowerCase() +
              "' VALUE=\"<%=beanName." + meta.getColumnName(j).toLowerCase() + "%>\"></td></tr>";
          out_file.println(javaLine);
        }
        out_file.println("</table>");
        out_file.println("END HTML TEMPLATE */");
      }
      catch (Exception ex)
      {

      }

    }

    public int processTemplate(PrintWriter out) {
		int retCode;
		String filename;

		retCode = 0; // assumes no error
		try {
			// open both input and output files
			filename = sTemplateDir + sTemplateFile;
			in = new BufferedReader(new FileReader(filename));
			try {
				out.println("<HR>Generating target file " + sTemplateDir + tableName + ".java<br>");
				filename = sTemplateDir + tableName.toLowerCase() + ".java";
				out_file = new PrintWriter(new FileOutputStream(filename));

				while ((javaLine = in.readLine()) != null) {
					out_file.println(javaLine);
					checkPackageName();
					checkClassName();
					checkDataMembers();
					checkFieldVector();
					checkAssignValues();
					checkConstructor();
					checkGetForm();
					checkInsert();
					checkUpdate();
					checkDelete();
					checkSelect();
					checkLoad();
				}

				generateHTML();

				in.close();
				out_file.close();
			} catch (IOException e) {
				retCode = -1;
			}
		} catch (Exception ex) {
			retCode = -2;
		}

		return retCode;
	}

    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException,
			IOException {

    	Sys.iDatabaseType=Sys.iMsSqlDb;
    	Sys.sDbDriverName="com.microsoft.jdbc.sqlserver.SQLServerDriver";
    	Sys.sDataBaseName="jdbc:microsoft:sqlserver://localhost:1433;databaseName=iran";  ///desinventar";
    	Sys.sDbUserName="sa";
    	Sys.sDbPassword="magician";
    	htmlPrefix = "c:/osso/web/webapps/DesInventar/";  // Sys.strFilePrefix + "/";
    	sTemplateDir = htmlPrefix + "generator/";

    	//Database Connection Objects
		String sSql; // string holding SQL statement
		String[] tableList;

		// start the html output
		resp.setContentType("text/html");
		out = new PrintWriter(resp.getOutputStream());
		try {
			// initialize some variables
	        dbConnection dbConn = null;
	        try
	        {
	          dbConn = new dbConnection();
	          con = dbConn.dbGetConnection();
	        }
	        catch (Exception ex)
	        {
	          System.err.println("Error: " + ex.toString());
	        }


			// processes the function if connected
			if (con != null) {
				// gets the metadata of the database
				dbMeta = con.getMetaData();
				// gets the table name;
				tableList = req.getParameterValues("tablename");
				packageName = req.getParameter("packageName");
				generateAudit = req.getParameter("generateAudit") != null;
				
				out.println("Using template file " + sTemplateDir + sTemplateFile + "<br>");
				out.println("Starting template processor:<br><BR><BR>");
				for (int numTables = 0; numTables < tableList.length; numTables++) {
					// if it's not empty, proceed..
					tableName = tableList[numTables];
					if (tableName != null) {
						try {
							// creates a statement with a select of that table
							stmt = con.createStatement();
							// assures the right case here
							tableName = tableName.toLowerCase();
							// AND here...
							sSql = "select * from " + tableName.toLowerCase();
							rset = stmt.executeQuery(sSql);
							// gets the metadata of the resultset
							meta = rset.getMetaData();
	
							result = processTemplate(out);
							// announces the result
							out.println("<h3>persistentObject class <A href='" + sDownloadDir + tableName
									+ ".java'>" + tableName+".java</a> generated successfully</h3><br>");
						} catch (Exception e) {
							// displays err msg
							out.println("ERROR: " + e.toString());
						}
					}
				}
				// closes the connection with the server!!!
				dbConn.close();
			} else
				out.println("Error connecting...");
		} catch (Exception ex) {
			out.println("<BR>doPost Error: " + ex.toString()+"<BR>");
			ex.printStackTrace(out);
		}

		out.close();
	}

    // UNIT TEST STUB
    public static void main(String[] args) {
        //Database Connection Objects
        String sSql; // string holding SQL statement
        webobj uTest = new webobj();
        dbConnection dbConn = null;
        
        try {
            // new code necessary to spoof the connection pool class into
			// thinking the webapp is running
        	Sys.iDatabaseType=Sys.iMsSqlDb;
        	Sys.sDbDriverName="com.microsoft.jdbc.sqlserver.SQLServerDriver";
        	Sys.sDataBaseName="jdbc:microsoft:sqlserver://blackbird:1433;databaseName=gosocs";
        	Sys.sDbUserName="sa";
        	Sys.sDbPassword="magician";
            try
            {
              dbConn = new dbConnection();
              uTest.con = dbConn.dbGetConnection();
            }
            catch (Exception ex)
            {
              System.err.println("Error: " + ex.toString());
            }
        	

            // processes the function if connected
            if (uTest.con != null) {
                // gets the metadata of the database
                uTest.dbMeta = uTest.con.getMetaData();
                // gets the table name;
                uTest.tableName = args[0];
                // if it's not empty, proceed..
                if (uTest.tableName != null) {
                    try {
                        // creates a statement with a select of that table
                        uTest.stmt = uTest.con.createStatement();
                        // assures the right case here
                        uTest.tableName = uTest.tableName.toLowerCase();
                        // AND here...
                        sSql = "select * from " + uTest.tableName.toLowerCase();
                        uTest.rset = uTest.stmt.executeQuery(sSql);
                        // gets the metadata of the resultset
                        uTest.meta = uTest.rset.getMetaData();

                        // process the template
                        System.out.println("Starting template processor:<br>");

                        // set the debug environment right directory:
                        uTest.sTemplateDir = "/webapps/magician/generator/";

            uTest.result = uTest.processTemplate(new PrintWriter(System.out));
            // announces the result
            System.out.println("<h3>persistentObject class " + uTest.tableName + ".java generated successfully</h3><br>");
            // download link
            System.out.println("Get the <A href='" + uTest.sDownloadDir + uTest.tableName + ".java'>generated file!</a><br>");
          }
          catch (Exception e)
          {
            // displays err msg
            System.out.println("ERROR: " + e.toString());
          }
        }
      }
      else
        System.out.println("Error connecting...");
    }
    catch (Exception ex)
    {
      System.err.println("Error: " + ex.toString());
    }
    finally {
        // closes the connection with the server!!!
    	dbConn.close();
    }

    }

}

