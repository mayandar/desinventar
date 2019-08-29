package org.lared.desinventar.tag;

import java.sql.*;

import javax.servlet.http.HttpSession;
import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;

import org.lared.desinventar.util.htmlServer;

/** JSP tag that expands a list of options
 * with all the geography level 0 elements.
 */

public class selectLevel1
    extends TagSupport
{
  private Connection con;

  private String sLevel0Code = "";
  String[] vLevel0Codes = null;

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

  public void setLevel0Code(String sSelectedCode)
  {
    this.sLevel0Code = sSelectedCode;
  }

  public void setLevel0Code(String[] sSelectedCode)
  {
    this.vLevel0Codes = sSelectedCode;
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
    String sSql = "";

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
      // basic select, all level 1
      sSql = "Select * from lev0,lev1 where lev1_lev0=lev0_cod ";
      // if there is a level0 selected, bring just its children
      if (sLevel0Code.length() > 0)
        sSql += " and lev1_lev0='" + sLevel0Code + "'";
      else if (vLevel0Codes!=null)
      {
        String sSet="";
        for (int j=0; j<vLevel0Codes.length; j++)
        {
          if (j>0)
            sSet+=",";
          sSet+="'"+vLevel0Codes[j]+"'";
        }
        sSql += " and lev1_lev0 in (" + sSet + ")";
      }
      sSql += " order by lev0_name,lev1_name";
      // throws the sql
      rset = stmt.executeQuery(sSql);
      while (rset.next())
      {
        sCode = rset.getString("lev1_cod");
        out.print("<option value='" + htmlServer.htmlEncode(sCode) + "'");
        if (sSelectedCode.equalsIgnoreCase(sCode))
          out.print(" selected");
        else
        if (vSelectedCodes != null)
        {
          int j = 0;
          while (j < vSelectedCodes.length)
          {
            if (vSelectedCodes[j++].equalsIgnoreCase(sCode))
            {
              out.print(" selected");
              j = vSelectedCodes.length;
            }
          }
        }
         // if there is a level0 selected, just put the name
          out.println(">" + htmlServer.htmlEncode(countrybean.getLocalOrEnglish(rset,"lev1_name","lev1_name_en")));
      }
      rset.close();
      stmt.close();
    }
    catch (Exception ioe)
    {
      System.out.println("Error in TagLib  [setLevel1Code]: " + ioe);
    }
    return (SKIP_BODY);
  }
}