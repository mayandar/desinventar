<!-- LOGIN PROCES LOGIC -->
<%
    /******************************************************************
    *  Process the LOGIN request with username & password.
    *  return codes:
 	*  0 -> Initial pass, nothing
    *  1 -> Address find OK.
    *  2 -> Address NOT find
    ******************************************************************/

int retCode=0;
retCode=login.doSearchEmail(request, out, user);
switch (retCode)
    {
	case 1: // found..
			%><jsp:forward page="login.jsp" /><%
			break;
	case 2:
            htmlServer.outputHtml("/html/users/loginmsg9.html",out);
			break;
	}

%>
