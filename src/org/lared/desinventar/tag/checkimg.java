package org.lared.desinventar.tag;

import java.io.*;
import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;

/**
 * Very simple JSP tag that just inserts a string
 * with the a checkmark image if the parameter is not zero (numeric boolean).
 */
public class checkimg   extends TagSupport
{
  int bValue = 0;

  public void setValue(int nSelected)
  {
    this.bValue = nSelected;
  }

  public int doStartTag()
  {
    try
    {
      JspWriter out = pageContext.getOut();
      if (bValue!=0)
        out.print("<img src='/DesInventar/images/check.gif' border=0>");
    }
    catch (IOException ioe)
    {
      System.out.println("Error in CheckIMG Tag: " + ioe);
    }
    return (SKIP_BODY);
  }
}