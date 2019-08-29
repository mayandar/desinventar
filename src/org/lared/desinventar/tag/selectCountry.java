package org.lared.desinventar.tag;

import java.sql.*;
import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;

import org.lared.desinventar.util.*;
import org.lared.desinventar.system.*;
import org.lared.desinventar.webobject.*;

/** JSP tag that expands a list of options
 * with all the geography level 0 elements.
 */

public class selectCountry
    extends TagSupport
{
  Connection con;
  String sSelectedCode = "";
  String[] vSelectedCodes = null;
  boolean bPublic=true;


  public void setConnection(Connection con)
  {
    this.con = con;
  }

  public void setSelected(String sSelectedCode)
  {
    this.sSelectedCode = sSelectedCode;
  }

  public void setPublic(String sSelectedCode)
    {
      this.bPublic = sSelectedCode.equals("true");
    }



  public void setSelected(String[] vSelectedCode)
  {
    this.vSelectedCodes = vSelectedCode;
  }


  public int doStartTag()
  {
    Statement stmt;
    ResultSet rset;
    String sCode = "";

    try
    {
      JspWriter out = pageContext.getOut();
      stmt = con.createStatement ();
      if (bPublic)
        rset = stmt.executeQuery("Select * from country  where bpublic<>0 order by scountryname");
      else
        rset = stmt.executeQuery("Select * from country order by scountryname");
      while (rset.next())
      {
        sCode = rset.getString("scountryid");
        out.print("<option value=" + htmlServer.htmlEncode(sCode));
        if (sCode.equalsIgnoreCase(sSelectedCode))
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
        out.println(">" + htmlServer.htmlEncode(rset.getString("scountryname")));
      }
      rset.close();
      stmt.close();
    }
    catch (Exception ioe)
    {
      System.out.println("Error in TagLib [select country]: " + ioe);
    }
    return (SKIP_BODY);
  }
}