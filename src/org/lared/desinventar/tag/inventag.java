package org.lared.desinventar.tag;
import java.io.*;
import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;


/** Very simple JSP tag that just inserts a string
* with the signature of the author into the output.
*/
import org.lared.desinventar.util.*;
import org.lared.desinventar.system.*;
import org.lared.desinventar.webobject.*;

public class inventag extends TagSupport
{
    public int doStartTag()
    {
    try {
        JspWriter out = pageContext.getOut();
        out.print("<b><font size=1>&copy; 2002,2003 La Red</font></b>");
        }
    catch(IOException ioe)
        {
        System.out.println("Error in ExampleTag: " + ioe);
        }
    return(SKIP_BODY);
    }
}