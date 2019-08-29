/*
 * Created on 15-Jan-2006
 */
package org.lared.desinventar.util;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.io.*;
import org.lared.desinventar.webobject.*;

/**
 * @author Julio Serje
 *  
 *  Serialises and outputs the countrybean object
 */
public class saveQuery extends HttpServlet{

  public String getServletInfo() {
    return "DesConsultar Save Query page";
  }

  public void service(HttpServletRequest request, HttpServletResponse response)
  throws java.io.IOException, ServletException 
	{
	
	JspFactory _jspxFactory = null;
	PageContext pageContext = null;
	HttpSession session = null;
	ServletContext application = null;
	ServletConfig config = null;
	JspWriter out = null;
	Object page = this;
	JspWriter _jspx_out = null;
	PageContext _jspx_page_context = null;
	
	
	try {
	_jspxFactory = JspFactory.getDefaultFactory();
	response.setContentType("application/x-binary");
	pageContext = _jspxFactory.getPageContext(this, request, response,	null, true, 8192, true);
	_jspx_page_context = pageContext;
	application = pageContext.getServletContext();
	config = pageContext.getServletConfig();
	session = pageContext.getSession();
	out = pageContext.getOut();
	_jspx_out = out;
	
	org.lared.desinventar.util.DICountry countrybean = null;
	synchronized (session) {
	  countrybean = (org.lared.desinventar.util.DICountry) _jspx_page_context.getAttribute("countrybean", PageContext.SESSION_SCOPE);
	  if (countrybean == null){
	    countrybean = new org.lared.desinventar.util.DICountry();
	    _jspx_page_context.setAttribute("countrybean", countrybean, PageContext.SESSION_SCOPE);
	  }
	}

    // sensitive info NOT to be serialized...
	country thisCountry=countrybean.country;
	countrybean.country=null;	
	try
		{
		response.setHeader("Content-disposition", "attachment;filename=DI_Query.qry");
		ObjectOutputStream s = new ObjectOutputStream(response.getOutputStream());		
		s.writeObject(countrybean);
		s.flush();
		//If we've gotten this far, then everything is okay.
		}
	catch (Exception e)
		{
		System.out.println("[DI9]:Error serializing: "+e.toString());
		}
	finally {  // always restore this variables
	    countrybean.country=thisCountry;
	    }
	} catch (Throwable t) {
	if (!(t instanceof SkipPageException)){
	  out = _jspx_out;
	  if (out != null && out.getBufferSize() != 0)
	    out.clearBuffer();
	  if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
	}
	} finally {
	if (_jspxFactory != null) _jspxFactory.releasePageContext(_jspx_page_context);
	}
	}
  
}
