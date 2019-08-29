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

public class selectBase
    extends TagSupport
{
  Connection con;
  users user=null;
  String sSelectedCode = "";

  public void setConnection(Connection con)
  {
    this.con = con;
  }

  public void setUser(users user)
  {
    this.user = user;
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
    String sSet = "'@@'";

    JspWriter out = null;
    try
    {
      out=pageContext.getOut();
      stmt = con.createStatement ();
      // not using a nested query due to MySql limitations...
      sSql="Select * from user_permissions";
      if (user!=null)
      	    sSql+=" where userid='"+user.suserid+"'";
      // out.println("<!--base:"+sSql+"-->");
      rset = stmt.executeQuery(sSql);
      while (rset.next())
      {
        sSet+=",'"+rset.getString("country")+"'";
      }
      sSql="Select * from country";
      if (user!=null)
      	if (user.iusertype<99)
      		sSql+=" where scountryid in ("+sSet+")";
      sSql+=" order by scountryname";
      //out.println("<!--base:"+sSql+"-->");
      rset = stmt.executeQuery(sSql);
      while (rset.next())
      {
        sCode = rset.getString("scountryid");
        out.print("<option value=" + htmlServer.htmlEncode(sCode));
        if (sCode.equalsIgnoreCase(sSelectedCode))
          out.print(" selected");
        out.println(">" + htmlServer.htmlEncode(rset.getString("scountryname")));
      }
      rset.close();
      stmt.close();
    }
    catch (Exception ioe)
    {
      System.out.println("<!--Error in TagLib [select base: " + ioe+"-->");
    }
    return (SKIP_BODY);
  }
}