package org.lared.desinventar.webobject;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Types;

import org.lared.desinventar.system.Sys;
import org.lared.desinventar.util.DICountry;
import org.lared.desinventar.util.dbConnection;
import org.lared.desinventar.util.pooledConnection;

public class MetadataNationalWrapper extends MetadataNational {
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
			sSql = "SELECT * FROM metadata_national";
			sSql += " WHERE (metadata_key = ?) AND (metadata_country = ?)";
			pstmt = con.prepareStatement(sSql);
			pstmt.setInt(f++, metadata_key);
			if (metadata_country==null || metadata_country.length() == 0)
				pstmt.setNull(f++, Types.VARCHAR);
			else
				pstmt.setString(f++, metadata_country);
			rset = pstmt.executeQuery();

			if (rset.next()) { 
				// SQL_UPDATE
				f=1;
				sSql = "UPDATE metadata_national SET ";
				sSql += " metadata_default_value_us = ?";
				sSql += " WHERE (metadata_key = ?) AND (metadata_country = ?)";
				pstmt = con.prepareStatement(sSql);
				pstmt.setDouble(f++, metadata_default_value_us);
				pstmt.setInt(f++, metadata_key);

				if (metadata_country==null || metadata_country.length() == 0)
					pstmt.setNull(f++, Types.VARCHAR);
				else
					pstmt.setString(f++, metadata_country);
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

	public static void main (String[] args)
	{
		// generate default entris for GDP, Population, Households and People per household

		Sys.getProperties();
		DICountry countrybean= new DICountry();


		try{

			dbConnection dbDefaultCon=new dbConnection();
			boolean bdConnectionOK = dbDefaultCon.dbGetConnectionStatus();
			Connection pc_connection=null;
			if (bdConnectionOK)
			{
				pc_connection=dbDefaultCon.dbGetConnection();
			}  // opening dB!!
			else
			{
				System.out.println ("Exception DI Import. opening main database..."+dbDefaultCon.dbGetConnectionError());
			}


			// GAR 2013 settings in country bean...
			countrybean.country.scountryid="g17";
			countrybean.country.getWebObject(pc_connection);
			countrybean.countrycode=countrybean.country.scountryid;
			countrybean.countryname=countrybean.country.scountryname;
			countrybean.dbType=countrybean.country.ndbtype;

			pooledConnection univ=new pooledConnection(countrybean.country.sdriver,countrybean.country.sdatabasename , countrybean.country.susername,countrybean.country.spassword);
			univ.getConnection();
			Connection con=univ.connection;

			Statement stat = con.createStatement();
			Statement stmt = con.createStatement();
			// gets one year
			PreparedStatement pstmt = con.prepareStatement("select * from metadata_national_values where metadata_country=? and metadata_key=? and metadata_year=?");
			
			PreparedStatement gstmt = con.prepareStatement("select * from metadata_national_values where metadata_country=? and metadata_key=? and metadata_year>? order by metadata_year");
			
			ResultSet rs = stat.executeQuery("select lev0_cod, lev0_name from lev0");
			String[] sDefaultsNeeded={"Population", "GDP", "Households", "P. per household","Currency"};
			int[] nDefaultsNeeded={1,5,6,11,7};
			while (rs.next())
			{
				String sCode=rs.getString(1);
				System.out.println("Defaults for "+sCode+ " "+rs.getString(2));
				for (int n=0; n<4; n++)
				{
					MetadataNationalValues lastyear=new MetadataNationalValues();
					for (int y=2005; y<2018; y++)
					{
						System.out.println("Defaults for "+sCode+ ", Variable "+sDefaultsNeeded[n]+" year "+y);
						fill_params(pstmt, sCode, nDefaultsNeeded[n], y);
						ResultSet rset = pstmt.executeQuery();
						if (rset.next())  // all ok. just remember the value
						{
							lastyear.loadWebObject(rset);
						}
						else // no value for this year.
						{
							// is there a previous value? if yes, save it with current year
							if (lastyear.metadata_value>0)
							{
								System.out.println("Reusing last known value for "+sCode+ ", Variable "+sDefaultsNeeded[n]+" from year "+lastyear.metadata_year+" for year "+y);										
								lastyear.metadata_year=y;
								lastyear.addWebObject(con);
							}
							else  // no value for previous year, looks for first future value.
							{
								fill_params(gstmt, sCode, nDefaultsNeeded[n], y);								
								rset = gstmt.executeQuery();
								boolean first=true;
								while (rset.next())
								{
									lastyear.loadWebObject(rset);									
									if (first)
									{
										// replicates all the years from now to thers
										int upto=lastyear.metadata_year;
										System.out.println("Expanding for "+sCode+ ", Variable "+sDefaultsNeeded[n]+" from year "+y+" to year "+upto);										
										for (int k=y; k<upto; k++)
										{
											lastyear.metadata_year=k;
											lastyear.addWebObject(con);											
										}
										
									}
								    // increments the year for all of the existing metadata
									y=lastyear.metadata_year;
								}
							}							
						}
					}

				}
			}

		}
		catch (Exception eImp)
		{
			System.out.println("[DI9] Error generating defaults: "+eImp.toString());
		}



	}

	private static void fill_params(PreparedStatement pstmt, String sCode,	int i, int y) 
	{
		try{
		pstmt.setString(1,sCode);
		pstmt.setInt(2,i);
		pstmt.setInt(3,y);
		}
		catch (Exception e){}
		
	}

}
