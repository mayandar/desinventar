<%@ page import="org.lared.desinventar.system.Sys" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
if (request.getParameter("lang")!=null)
	{
		String sLang=countrybean.not_null_safe(request.getParameter("lang"));
		if (sLang.length()>2) 
		 	sLang=sLang.substring(0,2);
		countrybean.setLanguage(sLang);
	}
// load DATA language code (if available)
if (request.getParameter("datalng")!=null)
	{
		String sLang=countrybean.not_null_safe(request.getParameter("datalng"));
		if (sLang.length()>2) 
		 	sLang=sLang.substring(0,2);
		countrybean.setDataLanguage(sLang);
	}
if (!Sys.bRequireLogin)
	{
	if (user.suserid.length()==0)
	    user.suserid="Anonymous";
	user.iusertype=99;
	}
else{  

// on authenticated systems, prevent the use of back button to avoid session hijacking
//*	Re-enable for production
	response.setHeader("Pragma", "no-cache");
	//response.setHeader("Cache-Control", "no-cache, private, max-age=0, no-store, must-revalidate, pre-check=0, post-check=0");
	response.setHeader("Cache-Control", "");
	// response.setDateHeader("Expires", -1);
	response.setDateHeader("Expires", 1000000);
	request.setCharacterEncoding("UTF-8");
//*/

	}	
if (user.suserid.length()==0)
	{ // expired session OR non-logged user!
	%><jsp:forward page="/inv/login.jsp"/><%
	}


//if (request.getServletPath().indexOf("/inv/")>=0)
//		System.out.println("CSRF: "+request.getParameter("usrtkn")+"="+countrybean.userHash+"["+request.getServletPath());	
// the user is logged in, and has a minimum privilege level. 
// Checks for permissions for this country
// (note a user could switch countries in DesConsultar and come back..)
if (countrybean.countrycode.length()!=0)
  if (!user.bHasAccess(countrybean.countrycode))
	{
	 // user with not enough permissions! 
	countrybean.countrycode="";
	countrybean.init();
	if (request.getServletPath().indexOf("index.jsp")<=0)
	  {	
  	%><jsp:forward page="index.jsp"/><%
	  }
	}
%>

