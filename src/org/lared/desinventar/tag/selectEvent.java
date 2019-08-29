package org.lared.desinventar.tag;

import java.sql.*;

import javax.servlet.http.HttpSession;
import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;

import org.lared.desinventar.util.*;
import org.lared.desinventar.system.*;
import org.lared.desinventar.webobject.*;

/** JSP tag that expands a list of options
 * with all the Event elements.
 */

public class selectEvent
    extends TagSupport
{
  Connection con;
  String sSelectedCode = "";
  String sLanguage = "EN";
  String[] vSelectedCodes = null;
  int nMaxApproval=99;
  

  public void setConnection(Connection con)
  {
    this.con = con;
  }

  public void setSelected(String sSelectedCode)
  {
    this.sSelectedCode = sSelectedCode.trim();
  }

  public void setSelected(String[] vSelectedCode)
  {
    this.vSelectedCodes = vSelectedCode;
  }

  public void setApproved(int nApproved)
  {
	  nMaxApproval=nApproved;
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
    
    try
    {
      JspWriter out = pageContext.getOut();
      stmt = con.createStatement ();
      //rset = stmt.executeQuery("Select * from eventos order by serial");
      rset = stmt.executeQuery("Select nombre, nombre_en, ndatacards from (select evento, count(*) as ndatacards from fichas where (approved<="+nMaxApproval+" or (approved is null)) group by evento) d, eventos e where d.evento=e.nombre  order by ndatacards desc");
      while (rset.next())
      {
        sCode = rset.getString("nombre").trim();
        String sEnglish=rset.getString("nombre_en");
        out.print("<option value='" + htmlServer.htmlEncode(sCode) + "'");
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
       out.print(">" + htmlServer.htmlEncode(DICountry.getLocalOrEnglish(sCode, sEnglish, sLanguage)));
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