package org.lared.desinventar.system;


public interface login_constants
{
    // global constants for login and related functionality return codes

    static final int LOGIN_OK =  1;          // -> normal login. Let the user in
    static final int LOGIN_DENIED =  2;      // -> access denied
    static final int LOGIN_REGISTER =  3;    // -> OK to create the user
    static final int LOGIN_EXISTS =  4;      // -> Unable to create user (user name already exists)
    static final int LOGIN_FORGOT_OK =  5;   // -> Forgot password processed ok. Password sent
    static final int LOGIN_NOUSER =  6;      // -> Unable to find username (forgot password)
    static final int LOGIN_NOMAIL =  7;      // -> Able to find username, but no e-mail account (forgot password)
    static final int LOGIN_EMAIL_OK =  8;    // -> search for e-mail OK, passwd sent...
    static final int LOGIN_ERROR =  9;       // -> Error in login process
    static final int LOGIN_NOTAPPROVED = 10; // -> User not approved - Consent form in CFOL

String not_null(String strpar);
}