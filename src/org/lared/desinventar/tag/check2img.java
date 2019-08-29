package org.lared.desinventar.tag;

/**
 * <p>Title: DesInventar WEB Version 6.1.2</p>
 * <p>Description: On Line Version of DesInventar/DesConsultar 6.</p>
 * <p>Copyright: Copyright (c) 2002  La  Red.</p>
 * <p>Company: La Red -  La Red de Estudios Sociales en Prevención de Desastres en América Latina</p>
 * @author Julio Serje
 * @version 1.0
 */

import java.io.*;
import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;

import org.lared.desinventar.webobject.webObject;

/**
 * Very simple JSP tag that just inserts a string
 * with the a checkmark image if the parameter is not zero (numeric boolean).
 */
public class check2img   extends TagSupport
{
  int bValue = 0;
  double nNumber = 0;

  public void setValue(int nSelected)
  {
    this.bValue = nSelected;
  }

  
  public void setNumber(double nNumber)
  {
    this.nNumber = nNumber;
  }


  public int doStartTag()
  {
    try
    {
      JspWriter out = pageContext.getOut();
      if (nNumber!=0.0)
        {
    	  if (nNumber== ((int)nNumber) )
    		  out.print((int)nNumber);
    	  else
    		  out.print(webObject.formatDouble(nNumber));
        }
      else
      if (bValue!=0)
          out.print("<img src='/DesInventar/images/check.gif' border=0>");
        else
          out.print("&nbsp;");
    }
    catch (IOException ioe)
    {
      System.out.println("Error in CheckIMG Tag: " + ioe);
    }
    return (SKIP_BODY);
  }
}
