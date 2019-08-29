/*
 * Class that comprises utility methods related to the GLIDE
 *
 */
package org.lared.desinventar.util;

import javax.servlet.*;
import javax.servlet.http.*;
import java.text.SimpleDateFormat;
import java.util.*;
import java.sql.*;

import org.lared.desinventar.util.*;
import org.lared.desinventar.system.*;
import org.lared.desinventar.webobject.*;

/**
 * @author Julio
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class Glide {

public static void checkGlideField(Connection con)
 {
	// check for GLIDE field. It's on-line version specific, would fail only on MS Access..
	Statement stmt=null; 
	ResultSet rset=null; 
	try
	{
	stmt=con.createStatement();
	try
		{
		rset=stmt.executeQuery("select glide from fichas where clave=-999");
		rset.close();
		} 
	catch (Exception e1)
		{
		try
			{
			stmt.executeUpdate("alter table fichas add glide text(30)");
			}
		catch (Exception e2)
			{
			}
		}
    // this is not GLIDE related but...
	try
		{
		rset=stmt.executeQuery("select observa2 from fichas where clave=-999");
		rset.close();
		} 
	catch (Exception e1)
		{
		try
			{
			stmt.executeUpdate("alter table fichas add observa2 text(255)");
			stmt.executeUpdate("alter table fichas add observa3 text(255)");
			}
		catch (Exception e2)
			{
			}
		}

	stmt.close();
	}
	catch (Exception e3)
	{
	}

 }

}
