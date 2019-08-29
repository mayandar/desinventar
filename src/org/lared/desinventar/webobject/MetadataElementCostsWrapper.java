package org.lared.desinventar.webobject;

import java.sql.Connection;
import java.sql.Types;

public class MetadataElementCostsWrapper extends MetadataElementCosts {
	/**
	* adds a new object to the database
	*
	*/
	public int addWebObject(Connection con)
    {
		int nrows = 0;
		try {
			// SQL_SELECT
			int f=1;
			sSql = "SELECT * FROM metadata_element_costs";
			sSql += " WHERE (metadata_element_key = ?) AND (metadata_country = ?) AND (metadata_element_year = ?)";
			pstmt = con.prepareStatement(sSql);
			pstmt.setInt(f++, metadata_element_key);
			if (metadata_country==null || metadata_country.length() == 0)
				pstmt.setNull(f++, Types.VARCHAR);
			else
				pstmt.setString(f++, metadata_country);
			pstmt.setInt(f++, metadata_element_year);
			rset = pstmt.executeQuery();
			if (rset.next()) {
				rset.close();
				
				// SQL_UPDATE
				f=1;
				sSql = "UPDATE metadata_element_costs SET ";
//				sSql += "metadata_element_unit_cost = ?";
				sSql += " metadata_element_unit_cost_us = ?";
				sSql += " WHERE (metadata_element_key = ?) AND (metadata_country = ?) AND (metadata_element_year = ?)";
				pstmt = con.prepareStatement(sSql);
				pstmt.setDouble(f++, metadata_element_unit_cost_us);
				pstmt.setInt(f++, metadata_element_key);
				if (metadata_country==null || metadata_country.length() == 0)
					pstmt.setNull(f++, Types.VARCHAR);
				else
					pstmt.setString(f++, metadata_country);
				pstmt.setInt(f++, metadata_element_year);
				nrows = pstmt.executeUpdate();
				lastError = ""; // "NO ERROR. sql="+sSql;
			} else {
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
