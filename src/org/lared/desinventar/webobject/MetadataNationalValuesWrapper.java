package org.lared.desinventar.webobject;

import java.sql.Connection;
import java.sql.Types;

public class MetadataNationalValuesWrapper extends MetadataNationalValues {
	/**
	* adds a new object to the database
	*
	*/
	public int addWebObject(Connection con)
    {
		int nrows = 0;
		try {
			int f=1;
			
			// SQL_SELECT
			sSql = "SELECT * FROM metadata_national_values";
			sSql += " WHERE (metadata_key = ?) AND (metadata_country = ?) AND (metadata_year = ?)";
			pstmt = con.prepareStatement(sSql);
			pstmt.setInt(f++, metadata_key);
			if (metadata_country==null || metadata_country.length() == 0)
				pstmt.setNull(f++, Types.VARCHAR);
			else
				pstmt.setString(f++, metadata_country);
				pstmt.setInt(f++, metadata_year);
			rset = pstmt.executeQuery();
			if (rset.next()) {
				f=1;
				
				// SQL_UPDATE
				sSql = "UPDATE metadata_national_values SET ";
				// sSql += "metadata_value = ?";
				sSql += " metadata_value_us = ?";
				sSql += " WHERE (metadata_key = ?) AND (metadata_country = ?) AND (metadata_year = ?)";
				pstmt = con.prepareStatement(sSql);

				// pstmt.setDouble(f++, metadata_value);
				pstmt.setDouble(f++, metadata_value_us);
				pstmt.setInt(f++, metadata_key);

				if (metadata_country==null || metadata_country.length() == 0)
					pstmt.setNull(f++, Types.VARCHAR);
				else
					pstmt.setString(f++, metadata_country);
				
					pstmt.setInt(f++, metadata_year);

				nrows = pstmt.executeUpdate();
				lastError = ""; // "NO ERROR. sql="+sSql;
			}
			else {
				super.addWebObject(con);
			}
		} catch (Exception ex) {
			//Trap and report SQL errors
			System.out.println("ERROR (adding web object): "+ex.toString());
			lastError = "<!-- Error adding webObject: " + ex.toString() + " : " + sSql + " -->";
			nrows=-1;
		}
		finally {
			// releases the statement object
			try { pstmt.close(); } catch (Exception ignrd) {}
		}
		return nrows;		
	}

}
