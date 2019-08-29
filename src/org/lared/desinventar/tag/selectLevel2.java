package org.lared.desinventar.tag;

import java.sql.*;

import javax.servlet.http.HttpSession;
import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;

import org.lared.desinventar.util.htmlServer;

/** JSP tag that expands a list of options
 * with all the geography level 0 elements.
 */

public class selectLevel2
    extends TagSupport
{
  private Connection con;
  private String sLevel1Code = "";
  String[] vLevel1Codes = null;
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

  public void setLevel1Code(String sSelectedCode)
  {
    this.sLevel1Code = sSelectedCode;
  }

  public void setLevel1Code(String[] sSelectedCode)
  {
    this.vLevel1Codes = sSelectedCode;
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
      sSql = "Select * from lev2";
      // if there is a level1 selected, bring just its children
      if (sLevel1Code.length() > 0)
        sSql += " where lev2_lev1='" + sLevel1Code + "'";
      else if (vLevel1Codes!=null)
      {
        String sSet="";
        for (int j=0; j<vLevel1Codes.length; j++)
        {
          if (j>0)
            sSet+=",";
          sSet+="'"+vLevel1Codes[j]+"'";
        }
        sSql += " Where lev2_lev1 in (" + sSet + ")";
      }


      sSql += " order by lev2_lev1, lev2_name";
      // debug: out.print(sSql);
      // throws the sql
      rset = stmt.executeQuery(sSql);
      while (rset.next())
      {
        sCode = rset.getString("lev2_cod");
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
        out.println(">" + htmlServer.htmlEncode(countrybean.getLocalOrEnglish(rset,"lev2_name","lev2_name_en")));
      }
      rset.close();
      stmt.close();
    }
    catch (Exception ioe)
    {
      System.out.println("Error in TagLib [setLevel2Code]: " + ioe);
    }
    return (SKIP_BODY);
  }
}