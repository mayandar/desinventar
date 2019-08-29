package org.lared.desinventar.tag;

/**
 * <p>Title: DesInventar WEB Version 6.1.2</p>
 * <p>Description: On Line Version of DesInventar/DesConsultar 6.</p>
 * <p>Copyright: Copyright (c) 2002  La  Red.</p>
 * <p>Company: La Red -  La Red de Estudios Sociales en Prevención de Desastres en América Latina</p>
 * @author Julio Serje
 * @version 1.0
 */

import java.sql.*;
import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;

import org.lared.desinventar.util.htmlServer;

/** JSP tag that creates a Javascript vector with the relation continent/country
 * with all the geography level 1 elements.
 */

public class vectorLevel1  extends TagSupport
{
  private Connection con;
  private String sLevel0Code = "";
  private String sSelectedCode = "";

  public void setConnection(Connection con)
  {
    this.con = con;
  }

  public int doStartTag()
  {
    Statement stmt=null;
    ResultSet rset=null;
    String sCode = "";
    String sSql = "";
    String sComma="";
    try
    {
      JspWriter out = pageContext.getOut();
      stmt = con.createStatement ();
      // basic select, all level 1
      sSql = "Select * from lev1 ";
      // restricted to a parent
      if (sLevel0Code.length() > 0)
        sSql += " AND lev1_lev0=" + sLevel0Code;
      sSql += "order by lev1_lev0, ";
      rset = stmt.executeQuery(sSql);
      out.print("aLevel1 = new Array(");
      int i=0;
      while (rset.next())
      {
        out.print(sComma+ htmlServer.jsEncode(rset.getString("lev1_lev0")));
        sComma=",";
        i++;
      }
      rset.close();
      stmt.close();
      out.println(");");
      out.println("var nLevel1="+i+";");
    }
    catch (Exception ioe)
    {
      System.out.println("Error in TagLib  [selectLevel1]: " + ioe.toString()+" Sql="+sSql);
    }

    return (SKIP_BODY);
  }
}
