<!-- LOGIN PROCES LOGIC -->
<%
    /******************************************************************
    *  Process the LOGIN request with username & password.
    *  return codes:
    *  1 -> normal login. Let the user in
    *  2 -> access denied
    *  3 -> OK to create the user
    *  4 -> Unable to create user (user name already exists)
    *  5 -> Forgot password processed ok. Password sent
    *  6 -> Unable to find username (forgot password)
    *  7 -> Able to find username, but no e-mail account (forgot password)
    *  8 -> reroute to page with search for e-mail...
    ******************************************************************/
 
int retCode=0;
retCode=login.doLogin(request, out, user);
switch (retCode)
   {
	case 1: // connected.. normal login. Let the user in, NO COUNTRY!!
			countrybean.countrycode="";
			response.sendRedirect(request.getContextPath() + "/inv/index.jsp");
			%>
            <!--jsp:forward page="index.jsp" /--><%
			break;
	case 2: // access denied
	        int nFailures=user.nFailedCount++;
			int nFailuresIp=FailedConnectionsByIP.newFailure(request);
			if (nFailures>3 || nFailuresIp>3)
			  Thread.sleep(Math.max(nFailures,nFailuresIp)*5000);
            htmlServer.outputHtml("/html/users/loginmsg1.html",out);
			out.println("Attempts: "+nFailures+"/"+nFailuresIp+"; penalty delayed after 3 attempts...<br/>");
			break;
	case 3: // ok to create user   NOT ALLOWED IN THIS IMPLEMENTATION OF DI
			%><jsp:forward page="UsersGet.jsp" /><%
			break;
	case 4: // Unable to create user (user name already exists)
            htmlServer.outputHtml("/html/users/loginmsg2.html",out);
			break;
	case 5: // Forgot password processed ok. Password sent
            htmlServer.outputHtml("/html/users/loginmsg4.html",out);
			break;
	case 6: // Unable to find username (forgot password)
            htmlServer.outputHtml("/html/users/loginmsg3.html",out);
  			break;
	case 7: //Able to find username, but no e-mail account (forgot password)
            htmlServer.outputHtml("/html/users/loginmsg5.html",out);
			break;
	case 8: //reroute to page with search for e-mail...
			%><jsp:forward page="/inv/ForgotUserPass.jsp" /><%
			break;
	}
if (request.getParameter("sendMail")!=null) // comes from forgot cretentials
	htmlServer.outputHtml("/html/users/loginmsg4.html",out);
%>
