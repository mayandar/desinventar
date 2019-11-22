package org.lared.desinventar.util;

import java.io.*;
import java.util.*;
import java.sql.*;
import java.math.*;
import java.text.*;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;

import org.lared.desinventar.util.*;
import org.lared.desinventar.system.*;
import org.lared.desinventar.webobject.*;

public class login
{

  // global variables

  /***************************************************
   *  Servlet identifier.
   ****************************************************/
  public String getServletInfo()
  {
    return "DesInventar user Login";
  }

  /******************************************************************
   *  Process the LOGIN request with username & password.
   *  return codes:
   *  0 -> normal login. Let the user in
   *  1 -> access denied
   *  2 -> OK to create the user
   *  3 -> Unable to create user (user name already exists)
   *  4 -> Forgot password processed ok. Password sent
   *  5 -> Unable to find username (forgot password)
   *  6 -> Able to find username, but no e-mail account (forgot password)
   *  7 -> reroute to page with search for e-mail...
   ******************************************************************/
  public static int doLogin(HttpServletRequest req, JspWriter out, xuser newUser)
  {

    //Database Connection Objects
    dbConnection dbcDatabase;
    Connection m_connection = null;
    boolean bConnectionMade;
    String strConnectionError;

    String sUserID; // to store user name
    String sPassWord; // to store password
    int nFunction; // function=0 login,  1=>user creation
    String sSql; // string holding SQL statement
    PreparedStatement stmt; // SQL statement object
    ResultSet rset; // SQL resultset
    int retCode = 0; // return code from account object methods
    String sIPAddress; // IP Address of loging user
    PrintWriter mailout;
    EncriptionManager em;

    // gets user name * password from form
    sUserID = req.getParameter("suserid");
    sPassWord = req.getParameter("spassword");

    sIPAddress = req.getRemoteAddr();

    nFunction = htmlServer.getActionNumber(req, "loginButton", "createButton", "forgotButton", "allforgotButton");
    try
    {
      if (nFunction == 0)
        return 0;

      // connection to the default database!
      dbcDatabase = new dbConnection();
      bConnectionMade = dbcDatabase.dbGetConnectionStatus();

      // processes the function
      if (bConnectionMade)
      {
        m_connection = dbcDatabase.dbGetConnection();
        // Query the account name & password
        try
        {
          switch (nFunction)
          {
            case 1: // login
              em = new EncriptionManager();
              sSql = "select * from users where (suserid=?) and (spassword=?) and bactive>0";
              stmt = m_connection.prepareStatement (sSql);
              stmt.setString(1, sUserID);
              stmt.setString(2, em.encript(sPassWord));
              // out.println("<!-- " + sSql + " -->");
              rset = stmt.executeQuery();
              // LOGIN PROCESS FOR AN EXISTING USER:
              // checks if there is a user with both fields (username & password)
              if (rset.next())
              {
                newUser.loadWebObject(rset);
                // and loads user's permissions
                newUser.setCountries(m_connection);
                retCode = 1;
              }
              else
              {
                retCode = 2;
              }

              // releases the resultset
              rset.close();
              // releases the statement
              stmt.close();
              break;

            case 2: // CREATION OF NEW USER   (there should be no other user with the same username/password!)
              // a) checks if there is a user with that user name
              sSql = "select * from users where (suserid=?)";
              stmt = m_connection.prepareStatement (sSql);
              stmt.setString(1, sUserID);
              rset = stmt.executeQuery();
              if (!rset.next())
              {
                // yes, the user DOESN'T  exist, grants access, produces the page for user creation:
                // passes the username and password
                newUser.init();
                newUser.spassword = sPassWord;
                newUser.suserid = sUserID;
                // CLEAN ALL FIELDS!!!
                retCode = 3;
              }
              else
              {
                retCode = 4;
              }

              // releases the resultset
              rset.close();
              // releases the statement
              stmt.close();
              break;

            case 3: // FORGOT PASSWORD:

              // a) checks if there is a user with that user name
              sSql = "select * from users where (suserid=?)";
              stmt = m_connection.prepareStatement (sSql);
              stmt.setString(1, sUserID);
              rset = stmt.executeQuery();
              em = new EncriptionManager();
              if (!rset.next())
              {
                // the user DOESN'T  exist:
                retCode = 6;
              }
              else
              {

                if (htmlServer.not_null(rset.getString("semailaddress")).trim().length() > 0)
                {
                  // HERE:  SEND E_MAIL TO USER !!!
                  try
                  {
                    msgsend mailer = new msgsend();
                    mailer.from = "desinventar@desinventar.net";
                    mailer.subject = "Message from DesInventar";
                    mailer.body = "message from DesInventar";
                    newUser.loadWebObject(rset);
                    mailer.to = newUser.semailaddress;
                    mailer.name = newUser.sfirstname + " " + newUser.slastname;
                    mailer.user = newUser.suserid;
                    mailer.password = newUser.spassword;
                    newUser.init();
                    mailer.send("Dear @name: \r\nAs per your request, we are sending here your DesInventar login credentials.\r\nYour username is @user, your password is @password.\r\nThanks,\r\nDesInventar Server 9");
                  }
                  catch (Exception maile)
                  {
                    out.println("error writing mail: " + maile.toString());
                  }
                  retCode = 5;
                }
                else
                {
                  // user exists but has no e-mail. another template is sent
                  retCode = 7;
                }
              }

              // releases the resultset
              rset.close();
              // releases the statement
              stmt.close();
              break;

            case 4:
              retCode = 8;
              break;
          }
          // closes the connection with the server!!!
          dbcDatabase.close();
        }
        catch (Exception ex)
        { //Trap SQL errors
          out.println("Error processing LOGIN: " + ex.toString());
          // out.println(messages.getMessage(m_connection,107)+ ex.toString());
        }
      }
      else
      {
        // out.println("Error connecting:"+dbcDatabase.dbGetConnectionError());
      }
    }
    catch (Exception e)
    {}
    return retCode;
  }

  /******************************************************************
   *  Process the SEARCH E-MAIL ADDRESS REQUEST.
   *  return codes:
   *  0 -> Forgot USERNAME&password processed ok. Password sent
   *  1 -> Unable to find username (NO matching E-MAIL)
   ******************************************************************/
  public static int doSearchEmail(HttpServletRequest req, JspWriter out, users newUser)
  {

    //Database Connection Objects
    dbConnection dbcDatabase;
    Connection m_connection = null;
    boolean bConnectionMade;
    String strConnectionError;

    String sPassWord; // to store password
    int nFunction; // function=0 login,  1=>user creation
    String sSql; // string holding SQL statement
    PreparedStatement stmt; // SQL statement object
    ResultSet rset; // SQL resultset
    int retCode = 0; // return code from account object methods
    String sIPAddress; // IP Address of loging user
    PrintWriter mailout;
    EncriptionManager em;

    // gets user name * password from form
    if (req.getParameter("sendEmail") == null)
    {
      retCode = 0;
    }
    else
      try
      {
        // connection per request!!!
        dbcDatabase = new dbConnection();
        bConnectionMade = dbcDatabase.dbGetConnectionStatus();

        // processes the function
        if (bConnectionMade)
        {
          m_connection = dbcDatabase.dbGetConnection();
          // Query the account name & password
          try
          {
            // FORGOT user/name and PASSWORD:
            // a) checks if there is a user with that user name
            String email = htmlServer.not_null_safe(req.getParameter("email")).trim();
            sSql = "select * from users where semailaddress=?";
            stmt = m_connection.prepareStatement (sSql);
            stmt.setString(1, email);
            rset = stmt.executeQuery();
            em = new EncriptionManager();
            if (rset.next())
            {
              // HERE:  SEND E_MAIL TO USER !!!
              try
              {
                do
                {
                  msgsend mailer = new msgsend();
                  mailer.from = "desinventar@desinventar.net";
                  mailer.subject = "Message from DesInventar";
                  mailer.body = "";
                  newUser.loadWebObject(rset);
                  mailer.to = newUser.semailaddress;
                  mailer.name = newUser.sfirstname + " " + newUser.slastname;
                  mailer.user = newUser.suserid;
                  mailer.password = em.decript(newUser.spassword);
                  newUser.init();
                  mailer.send("Dear @name: \r\nAs per your request, we are sending here your DesInventar login credentials.\r\nYour username is @user, your password is @password.\r\nThanks,\r\nDesInventar Server 9.2.11");
                }
                while (rset.next());
                retCode = 1;
              }
              catch (Exception maile)
              {
                out.println("<br>Error writing mail: " + maile.toString());
              }
            }
            else
            {
             // the user e-mail DOESN'T  exist
             retCode = 2;
            }

            // releases the resultset
            rset.close();
            // releases the statement
            stmt.close();
            // releases the connection
            dbcDatabase.close();
          }
          catch (Exception ex)
          { //Trap SQL errors
            out.println("Error processing LOGIN: " + ex.toString());
            // out.println(messages.getMessage(m_connection,107)+ ex.toString());
          }
        }
        else
        {
          // out.println("Error connecting:"+dbcDatabase.dbGetConnectionError());
        }
      }
      catch (Exception e)
      {}
    return retCode;
  }

}