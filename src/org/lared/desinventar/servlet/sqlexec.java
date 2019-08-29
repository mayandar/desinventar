package org.lared.desinventar.servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;
import org.lared.desinventar.util.*;
import org.lared.desinventar.system.*;

import java.security.MessageDigest;

// make it accept a query as a parameter
// make errors come out in a pane at the bottom instead of at the top
public class sqlexec
    extends HttpServlet
{

  public String getServletInfo()
  {
    return "Remote sql executer";
  }

  public void doGet(HttpServletRequest req, HttpServletResponse resp) throws
      ServletException, IOException
  {
	 resp.setContentType("text/html; charset=UTF-8");
	 req.setCharacterEncoding("UTF-8"); 
	 PrintWriter out = new PrintWriter(resp.getOutputStream());

    // make sure Sys has loaded the properties...
    Sys.getProperties();

    // gets parameters.
    ServletContext sc = getServletConfig().getServletContext();
    String htmlPrefix =  sc.getRealPath("/");

    out.println("<HTML>");
    out.println("<HEAD><TITLE>sqlexec Output</TITLE></HEAD>");
    out.println("<BODY>");

    outputHTML(htmlPrefix + "sqlexec.html", out, new Hashtable());

    // close
    out.println("</BODY>");
    out.println("</HTML>");
    out.close();
  }

  public void outputText(String filename, PrintWriter out)
  {
    int c;
    String htmlLine;
    try
    {

      BufferedReader in = new BufferedReader(new FileReader(filename));
      try
      {
        while ( (htmlLine = in.readLine()) != null)
        {
          out.println("<br>" + htmlLine);
        }
        in.close();
      }
      catch (IOException e)
      {
        out.println("SYSTEM ERROR: reading " + filename + "...");
      }
    }
    catch (FileNotFoundException ex)
    {
      out.println("SYSTEM ERROR: " + filename + " not found..." + ex.getMessage());
    }

  }

  public void outputHTML(String filename, PrintWriter out, Hashtable htProps)
  {
    int c;
    String htmlLine;
    try
    {

      BufferedReader in = new BufferedReader(new FileReader(filename));
      try
      {
        while ( (htmlLine = in.readLine()) != null)
        {
          // locates INPUT
          String htmlULine = htmlLine.toUpperCase();
          if (htmlULine.indexOf("<INPUT") >= 0)
          {
            int pos = htmlULine.indexOf("NAME");
            String fieldName = htmlLine.substring(pos + 6);
            pos = fieldName.indexOf("\"");
            if (pos == -1)
              pos = fieldName.indexOf("'");
            if (pos == -1)
              pos = fieldName.indexOf(" ");
            fieldName = fieldName.substring(0, pos);
            // gets the value of the field with the original name
            String fieldValue = (String) htProps.get(fieldName);
            if (fieldValue != null)
            {
              // isolates the value of the field
              pos = htmlULine.indexOf("VALUE");
              if (pos > 0)
              {
                pos = pos + 5;
                while ( (htmlLine.charAt(pos) != '\'') &&
                       (htmlLine.charAt(pos) != '"'))
                  pos++;
                int posend = pos + 1;
                while ( (htmlLine.charAt(posend) != '\'') &&
                       (htmlLine.charAt(posend) != '"'))
                  posend++;
                htmlLine = htmlLine.substring(0, pos + 1) + fieldValue +
                    htmlLine.substring(posend);
              }
              else
              { // this fix was really needed. some HTML editors remove the Value tag if it's empty...
                pos = htmlULine.indexOf("NAME");
                htmlLine = htmlLine.substring(0, pos) + " VALUE='" + fieldValue +
                    "' " + htmlLine.substring(pos);
              }

            }
          }
          out.println(htmlLine);
        }
        in.close();
      }
      catch (IOException e)
      {
        out.println("SYSTEM ERROR: reading " + filename + "...");
      }
    }
    catch (FileNotFoundException ex)
    {
      out.println("SYSTEM ERROR: " + filename + " not found..." + ex.getMessage());
    }

  }

  private static final char[] HEX_CHARS = {'0', '1', '2', '3',
      '4', '5', '6', '7',
      '8', '9', 'a', 'b',
      'c', 'd', 'e', 'f',};

/**
* Turns array of bytes into string representing each byte as
* unsigned hex number.
* 
* @param hash Array of bytes to convert to hex-string
* @return Generated hex string
*/
public static String asHex (byte hash[]) 
	{
	char buf[] = new char[hash.length * 2];
	for (int i = 0, x = 0; i < hash.length; i++) 
		{
		buf[x++] = HEX_CHARS[(hash[i] >>> 4) & 0xf];
		buf[x++] = HEX_CHARS[hash[i] & 0xf];
		}
	return new String(buf);
	}

  String getMD5Hash(String sPassword)
  {
	  String sHash="";
	  
	  try{
		  MessageDigest digest = MessageDigest.getInstance("MD5");
		  byte[] bDigestInput=sPassword.getBytes();
		  digest.update(bDigestInput);
		  byte[] hash = digest.digest();
		  sHash=asHex(hash);
	  }
	  catch (Exception e)
	  {
		  
	  }
	  
	  return sHash;
  }
  
  String not_null(String strParameter)
  {
    int pos;
    String sReturn;

    if (strParameter == null)
      return "";
    else
      return strParameter;
  }

  public int doCommand(Connection m_connection, PrintWriter out)
  {
    int j, nErrors = 0;
    Statement stmt; // SQL statement object
    ResultSet rset; // SQL resultset

    return nErrors;
  }

  public String get_ClobString(Clob theClob)
  {
    String sRet = "";
    if (theClob != null)
      try
      {
        int nClobLen = (int) theClob.length();
        sRet = theClob.getSubString(1, nClobLen);
      }
      catch (Exception eclob)
      {
      }
    return sRet;
  }

  public void doPost(HttpServletRequest req, HttpServletResponse resp) throws
      ServletException, IOException
  {

    // start the html output
    resp.setContentType("text/html; charset=UTF-8");
    req.setCharacterEncoding("UTF-8"); 
    PrintWriter out = new PrintWriter(resp.getOutputStream());
    resp.setContentType("text/html; charset=UTF-8");

    //Database Connection Objects
    Connection m_connection = null;
    boolean bConnectionMade;
    String strConnectionError;

    String sUserName; // to store user name
    int nCompanyId; // to store company_id
    String sCompanyName; // to store company name
    int nSqlRet = 0; // return from update SQL
    String sSql; // string holding SQL statement
    Statement stmt; // SQL statement object
    ResultSet rset = null; // SQL resultset
    int retCode, j, iFirst; // return code from account object methods
    String strErrors; // validation errors

    ResultSetMetaData meta; // SQL metadata of the resultset
    String[] tableTypes =
        {
        "TABLE", "VIEW"};
    DatabaseMetaData dbMeta;
    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
    String sQueryTitle = "";
    String sScript = "";
    dbConnection dbConn = null;

    int i = 0;
    int nStart = 0;
    int nResults = 0;
    int nResultsOK = 100;

    Sys.getProperties();
    ServletContext sc = getServletConfig().getServletContext();
    String htmlPrefix =  sc.getRealPath("/");
    String apachePrefix = "c:/program files/apache group/apache/logs/";
    String jservPrefix = "d:/tomcat4/logs/";
    String sSchema = Sys.sDbUserName; //.toUpperCase();
    String sPassword = "";
    String sDriver = "";
    String sDatasource = "";

    Hashtable htProps = new Hashtable();

    sSql = req.getParameter("sql");

    if (req.getParameter("htmlPrefix") != null)
      htmlPrefix = req.getParameter("htmlPrefix");
    if (req.getParameter("apachePrefix") != null)
      apachePrefix = req.getParameter("apachePrefix");
    if (req.getParameter("jservPrefix") != null)
      jservPrefix = req.getParameter("jservPrefix");
    if (req.getParameter("schema") != null)
      sSchema = req.getParameter("schema"); //.toUpperCase();
    if (req.getParameter("driver") != null)
      sDriver = req.getParameter("driver");
    if (req.getParameter("connstring") != null)
      sDatasource = req.getParameter("connstring");
    if (req.getParameter("password") != null)
      sPassword = req.getParameter("password");
//    if ( (sSchema == null) || (sSchema.length() == 0))
//      sSchema = Sys.sDbUserName.toUpperCase();
    try
    {
      nResults = Integer.parseInt(req.getParameter("nResults"));
    }
    catch (Exception e1)
    {
      nResults = 500;
    }
    nResultsOK = nResults;
    try
    {
      nStart = Integer.parseInt(req.getParameter("nStart"));
    }
    catch (Exception e2)
    {
      nStart = 0;
    }

    htProps.put("htmlPrefix", htmlPrefix);
    htProps.put("apachePrefix", apachePrefix);
    htProps.put("jservPrefix", jservPrefix);
    htProps.put("schema", sSchema);
    htProps.put("password", sPassword);
    htProps.put("driver", sDriver);
    htProps.put("connstring", sDatasource);
    htProps.put("nResults", Integer.toString(nResults));
    htProps.put("nStart", Integer.toString(nStart));
    outputHTML(htmlPrefix + "sqlexec.html", out, htProps);

    if (sDriver.length() == 0) // this means the default database
    {
      sDriver = Sys.sDbDriverName;
      sDatasource = Sys.sDataBaseName;
      if (sSchema.length() == 0)
        sSchema = Sys.sDbUserName; //.toUpperCase();
      if (sPassword.length() == 0)
        sPassword = Sys.sDbPassword;
    }

    if (sSql.startsWith("md5hash"))
    {
      String sPass=sSql.substring(7).trim();	
      out.println("<br><br>MD5 Hash for: "+sPass+"=<b>["+getMD5Hash(sPass)+"]</b><br>");
    }
    else
        if (sSql.equalsIgnoreCase("listerror"))
        {
          outputText(jservPrefix + "/stdout.log", out);
          out.println("<br><br><b>Stderr.log</b><br>");
          outputText(jservPrefix + "/stderr.log", out);
          out.println("<br><br><b>MOD_JK.log</b><br>");
          outputText(jservPrefix + "/mod_jk.log", out);
        }
        else
    if (sSql.equalsIgnoreCase("servererror"))
    {
      out.println("<br><br><b>ERROR.log</b><br>");
      outputText(apachePrefix + "/error.log", out);
    }
    else
    {
      try
      {
        dbConn = new dbConnection(sDriver, sDatasource, sSchema, sPassword);
        m_connection = dbConn.dbGetConnection();
      }
      catch (Exception ex)
      {
        System.err.println("Error: " + ex.toString());
      }

      bConnectionMade = dbConn.dbGetConnectionStatus();
      // processes the function if connected
      if (bConnectionMade)
      {
        try
        {
          stmt = m_connection.createStatement ();
          if (sSql.equalsIgnoreCase("doCommand"))
          {
            doCommand(m_connection, out);
          }
          else
          {
            sScript = sSql.trim();
            while (sScript.length() > 0)
            {
              iFirst = 1;
              nResults = nResultsOK;
              // j=sScript.indexOf(";");
              boolean found = false;
              boolean lit = false;
              char clit = '\'';
              j = 0;
              while (j < sScript.length() && !found)
              {
                if (lit)
                {
                  if (sScript.charAt(j) == clit)
                    lit = false;
                  j++;
                }
                else
                if (sScript.charAt(j) == ';')
                  found = true;
                else
                {
                  if (sScript.charAt(j) == '\'')
                  {
                    lit = true;
                    clit = sScript.charAt(j);
                  }
                  if (sScript.charAt(j) == '"')
                  {
                    lit = true;
                    clit = sScript.charAt(j);
                  }
                  j++;
                }
              }
              if (!found)
                j = 0;
              if (j > 0)
              {
                sSql = sScript.substring(0, j).trim();
                while ( (sSql.charAt(0) == '\n') ||
                       (sSql.charAt(0) == '\t') ||
                       (sSql.charAt(0) == '\r') ||
                       (sSql.charAt(0) == ' '))
                  sSql = sSql.substring(1);
                sScript = sScript.substring(j + 1);
              }
              else
              {
                sSql = sScript;
                sScript = "";
              }

              if (sSql.equalsIgnoreCase("listables") ||
                  sSql.substring(0, 7).equalsIgnoreCase("select ") ||
                  sSql.substring(0, 5).equalsIgnoreCase("desc "))
              {
                // generates a resultset with the info required:
                if (sSql.equalsIgnoreCase("listables"))
                {
                  // gets the metadata of the database
                  dbMeta = m_connection.getMetaData();
                  // gets the tables set
                  //out.println("<font size='1' color='blue'>using sSchema "+sSchema+"</font>");
                  rset = dbMeta.getTables(null, sSchema, null, tableTypes);
                  sQueryTitle = "TABLES IN THE SYSTEM:";
                  nStart = 0;
                  iFirst = 2;
                  nResults = 50000;
                }
                else
                if (sSql.trim().substring(0, 6).equalsIgnoreCase("select"))
                {
                  // executes a query
                  long lBefore = (new java.util.Date()).getTime();
                  rset = stmt.executeQuery(sSql);
                  long lAfter = (new java.util.Date()).getTime();
                  sQueryTitle = "RESULTS FROM QUERY: &nbsp;&nbsp;&nbsp;&nbsp;";
                  lAfter -= lBefore;
                  sQueryTitle += "(" + lAfter + " msecs)";
                }
                else
                if (sSql.substring(0, 5).equalsIgnoreCase("desc "))
                {
                  // gets the metadata of the database
                  dbMeta = m_connection.getMetaData();
                  String table = sSql.substring(5).trim().toUpperCase();
                  j = table.indexOf(".");
                  if (j > 0)
                  {
                    sSchema = table.substring(0, j);
                    table = table.substring(j + 1);
                  }
                  rset = dbMeta.getColumns(null, sSchema, table, null);
                  nStart = 0;
                  iFirst = 4;
                  nResults = 50000;
                  sQueryTitle = "DESCRIPTION OF TABLE " +
                      sSql.substring(5).trim() + ":";
                }

                // gets the metadata of the resultset
                meta = rset.getMetaData();
                out.println("<h3>" + sQueryTitle +
                            "</H3><BR><TABLE border='1'>");
                out.println("<tr><TD>" + sSql +
                            "<br></TD></TR></TABLE><TABLE border='1'>");
                out.println("<TR>");
                for (j = iFirst; j <= meta.getColumnCount(); j++)
                {
                  out.println("<td><b>" + meta.getColumnName(j) + "</b></td>");
                }
                out.println("</TR>");
                int nreg = 0;
                if (nStart > 0)
                {
                  while (rset.next() && (nreg < nStart))
                    nreg++;
                }
                nreg = 0;
                while (rset.next() && (nreg++ < nResults))
                {
                  out.print("<TR>");
                  for (j = iFirst; j <= meta.getColumnCount(); j++)
                  {
                    try
                    {
                      out.print("<td>");
                      switch (meta.getColumnType(j))
                      {
                        case Types.CLOB:
                        case 1111: // type reported by Oracle for BLOB types...
                          out.println(get_ClobString(rset.getClob(j)));
                          // out.println("<td>"+rset.getClob(j).getSubString(1,(int) rset.getClob(j).length())+"</td>");
                          //out.println("<td>"+rset.getClob(j).getSubString(1,45)+"</td>");
                          //out.println("<td>"+ rset.getClob(j).length()+"</td>");
                          break;
                        case Types.BLOB:
                          break;
                        case Types.DATE:
                          out.println(formatter.format(rset.getDate(j)));
                          break;
                        case Types.DECIMAL:
                        case Types.DOUBLE:
                        case Types.FLOAT:
                        case Types.REAL:
                              out.println(Double.toString(rset.getDouble(j)));
                          break;
                        case Types.NUMERIC:
                        case Types.SMALLINT:
                        case Types.INTEGER:
                        case Types.BIGINT:
                        case Types.TINYINT:
                            out.print(rset.getInt(j));
                          break;
                        case Types.VARCHAR:
                          out.print(not_null(rset.getString(j)));
                          break;
                        default:
                          out.print(rset.getString(j));
                          break;
                      }
                    }
                    catch (Exception fielde)
                    {
                      out.print("*ERR*"+meta.getColumnType(j)); //"error:"+fielde.toString());
                    }
                    out.println("</td>");
                  }
                  out.println("</TR>");
                }
                out.println("</table>");
              }
              /* disabled until more security is added */
              else
              {
                long lBefore = (new java.util.Date()).getTime();
                nSqlRet = stmt.executeUpdate(sSql);
                long lAfter = (new java.util.Date()).getTime();
                lAfter -= lBefore;
                out.println("<br>SQL:" + sSql + " RETURNED: " + nSqlRet + "  (" +
                            lAfter + " msecs)");
              }
              //*/
            }
          }
          out.println("<br>");
          // releases the statement
          stmt.close();
        }
        catch (Exception ex)
        { //Trap SQL errors
          out.println("Error: " + ex.toString());
        }
        // closes the connection with the server!!!
        dbConn.close();
      }
      else
        out.println("Error connecting...:" + dbConn.dbGetConnectionError());
    }

    out.close();
  }

}