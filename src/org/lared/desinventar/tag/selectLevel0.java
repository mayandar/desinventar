package org.lared.desinventar.tag;

import java.sql.*;

import javax.servlet.http.HttpSession;
import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;

import org.lared.desinventar.util.htmlServer;

/** JSP tag that expands a list of options
 * with all the geography level 0 elements.
 */

public class selectLevel0    extends TagSupport
{
  private Connection con;
  private String sSelectedCode = "";
  String[] vSelectedCodes = null;

  public void setSelected(String[] vSelectedCode)
  {
    this.vSelectedCodes = vSelectedCode;
  }

  public void setConnection(Connection con)
  {
    this.con = con;
  }

  public void setSelected(String sSelectedCode)
  {
    this.sSelectedCode = sSelectedCode;
  }

  public int doStartTag()
  {
    Statement stmt;
    ResultSet rset;
    String sCode = "";

    try
    {
      JspWriter out = pageContext.getOut();
      HttpSession session =  pageContext.getSession();
      org.lared.desinventar.util.DICountry countrybean = null;
      synchronized (session) {
        countrybean = (org.lared.desinventar.util.DICountry) pageContext.getAttribute("countrybean", PageContext.SESSION_SCOPE);
        if (countrybean == null){
          countrybean = new org.lared.desinventar.util.DICountry();
        }
      }

      stmt = con.createStatement ();
      rset = stmt.executeQuery("Select * from lev0 order by lev0_name");
      while (rset.next())
      {
        sCode = rset.getString("lev0_cod");
        out.print("<option value='" + sCode + "'");
        if (sSelectedCode.equalsIgnoreCase(sCode))
          out.print(" selected");
        else
       if (vSelectedCodes != null)
       {
         int j=0;
         while (j<vSelectedCodes.length)
         {
           if (vSelectedCodes[j++].equalsIgnoreCase(sCode))
           {
             out.print(" selected");
             j=vSelectedCodes.length;
           }
         }
       }
       out.println(">" +countrybean.getLocalOrEnglish(rset,"lev0_name","lev0_name_en"));
      }
      rset.close();
      stmt.close();
    }
    catch (Exception ioe)
    {
      System.out.println("Error in TagLib  [setLevel0Code]: " + ioe);
    }
    return (SKIP_BODY);
  }
}