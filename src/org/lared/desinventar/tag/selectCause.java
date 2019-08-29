package org.lared.desinventar.tag;

import java.sql.*;
import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;

import org.lared.desinventar.util.*;
import org.lared.desinventar.system.*;
import org.lared.desinventar.webobject.*;

/** JSP tag that expands a list of options
 * with all the Event elements.
 */

public class selectCause
    extends TagSupport
{
  Connection con;
  String sSelectedCode = "";
  String sLanguage = "";
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

  public void setLanguage(String sLanguage)
  {
    this.sLanguage = sLanguage;
  }

  public int doStartTag()
  {
    Statement stmt;
    ResultSet rset;
    String sCode = "";
    String sCode_en = "";

    try
    {
      JspWriter out = pageContext.getOut();
      stmt = con.createStatement ();
      rset = stmt.executeQuery("Select * from causas");
      while (rset.next())
      {
        sCode = rset.getString("causa");
        sCode_en = rset.getString("causa_en");
        out.print("<option value='" + htmlServer.htmlEncode(sCode) + "'");
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
       out.print(">" + htmlServer.htmlEncode(DICountry.getLocalOrEnglish(sCode, sCode_en,sLanguage)));
      }
      rset.close();
      stmt.close();
    }
    catch (Exception ioe)
    {
      System.out.println("Error in TagLib [select Cause]: " + ioe);
    }
    return (SKIP_BODY);
  }
}