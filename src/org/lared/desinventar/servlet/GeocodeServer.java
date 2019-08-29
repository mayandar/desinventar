package org.lared.desinventar.servlet;

import java.sql.*;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;

import org.lared.desinventar.util.*;
import org.lared.desinventar.system.*;
import org.lared.desinventar.webobject.*;

public class GeocodeServer
    extends HttpServlet
{

  public String getServletInfo()
  {
    return "Geographic codes Server ";
  }

  public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException
  {

    //Database Connection Objects
    dbConnection dbcDatabase;
    Connection m_connection = null;
    boolean bConnectionMade;
    String strConnectionError;

    String sSql; // string holding SQL statement
    Statement stmt; // SQL statement object
    ResultSet rset; // SQL resultset
    int retCode = 0; // return code from account object methods
    String sCountryCode = "";
    String sGeoCode = "";
    int nLevel = 0;
    int nCodes = 0;
    String sTable, sName, sCode, sParent;

    resp.setContentType("text/plain");
    PrintWriter out = new PrintWriter(resp.getOutputStream());

    // sends start of sequence
    out.println("<codes>");

    // gets parameters from URL
    sCountryCode = req.getParameter("country");
    sGeoCode = req.getParameter("code");
    nLevel = Integer.parseInt(req.getParameter("level"));

    // assembles the names:
    sTable = "lev" + nLevel;
    sName = sTable + "_name";
    sCode = sTable + "_cod";
    sParent = sTable + "_lev" + (nLevel - 1);

    // gets a connection from the pool!!!
    dbcDatabase = new dbConnection();
    bConnectionMade = dbcDatabase.dbGetConnectionStatus();
    // Gets the country parameters in order to open its database;

   // out.println("connected to default-db");

    if (bConnectionMade)
    {
      m_connection = dbcDatabase.dbGetConnection();
      // Query the account name & password
      country pais=new country();
      pais.scountryid=sCountryCode;
      pais.getWebObject(m_connection);
      dbcDatabase.close();

      // Now, gets a connection for the country from the pool!!!
      dbcDatabase = new dbConnection(pais.sdriver,pais.sdatabasename,
                                    pais.susername,pais.spassword);
      bConnectionMade = dbcDatabase.dbGetConnectionStatus();

      // processes the function
      if (bConnectionMade)
      {
        m_connection = dbcDatabase.dbGetConnection();
        // Query the account name & password
        try
        {
          stmt = m_connection.createStatement ();
          sSql = "select sum(1) as nCodes from " + sTable + " where " + sParent + "='" + sGeoCode + "'";

// out.println("SQL1="+sSql);

          rset = stmt.executeQuery(sSql);
          if (rset.next())
          {
            nCodes = rset.getInt("nCodes");
          }
          out.println(nCodes);
          sSql = "select * from " + sTable + " where " + sParent + "='" + sGeoCode + "'";

// out.println("SQL2= "+sSql);

          rset = stmt.executeQuery(sSql);
          // checks if there is a user with both fields (username & password)
          while (rset.next())
          {
            out.println(rset.getString(sCode) + "@" + rset.getString(sName));
          }
          // releases the resultset
          rset.close();
          // releases the statement
          stmt.close();
          // releases the connection
          dbcDatabase.close();
        }
        catch (Exception e)
        {
          out.println("Exception[1]: " + e.toString());
        }
      }
    }
    out.println("</codes>");

    out.close();

  }
}