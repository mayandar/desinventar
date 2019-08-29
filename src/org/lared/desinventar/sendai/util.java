package org.lared.desinventar.sendai;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class util {

    static void closeConnection(Connection con) {
        try {
            if (con != null)
                con.close();
        } catch (Exception e) {
            System.out.println("Exception closing connection");
            System.out.println(e.getMessage());
        }
    }
    static void closeStatement(Statement stmt) {
        try {
            if (stmt!=null)
                stmt.close();
        } catch (Exception e) {
            System.out.println("Exception closing statement");
            System.out.println(e.getMessage());
        }
    }
    static void closeResultSet(ResultSet rset) {
        try {
            if (rset!=null)
                rset.close();
        } catch (Exception e) {
            System.out.println("Exception closing resultset");
            System.out.println(e.getMessage());
        }
    }

    public static boolean isNullOrEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

}
