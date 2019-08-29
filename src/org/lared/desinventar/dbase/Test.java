package org.lared.desinventar.dbase;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.sql.*;

import org.lared.desinventar.util.GAR_country_profile_excel;

public class Test
{
	public static void main(String arg[])
	{
		String dbDirectory = "C:\\data02\\riskdataviewer\\data2015\\exposure";
		String table;
		String handler;


		Test t = new Test();
		try {
			table = "pt_5x5";
			handler = DBase.DBASEIII;
		    // loads the DBF of the grid
			t.go(dbDirectory, table, handler);



		} catch (Exception e) {
			e.printStackTrace();
			System.exit(1);
		}
	}

	/**
	 * Perform the each test the same way.
	 */
	private void go(String dir, String table, String handler) throws Exception
	{
		// Using a DBASE IV memo file.
		DBase db = new DBase(dir);
		db.setMemoHandler(handler);

		String sql;

		display(db, table, "Test:");

		/*		
 		sql = "delete from " + table +  " where Id=2";
		db.exec(sql);
		display(db, table, "After deletion");

		sql = "insert into  " + table +  "  (Id, Name, Count, C_omment) values (1, 'Wally', 3, 'I like fish too')";
		db.exec(sql);
		display(db, table, "After insert");

		sql = "update  " + table +  " set Name='Bob', Count=8, C_omment='Fish are fun to pet' where Id=1";
		db.exec(sql);
		display(db, table, "After update");

		// Get rid the last update above.
		sql = "delete from  " + table +  "  where Id=1";
		db.exec(sql);

		sql = "delete from  " + table +  "  where Name='Bob'";
		db.exec(sql);

		display(db, table, "After deletion");

		 */

		db.closeTable();
	}

	void display(DBase db, String table, String title) throws SQLException
	{
		String sql = "select * from  " + table;
		db.exec(sql);


		System.out.println();
		System.out.println(title);
		System.out.println("Columns for :" + table);
		String [] column = db.getColumnNames();
		while (db.next())
		{
			for (int i = 0; i < column.length; i++)
				System.out.print("---- " +column[i] + ": " + db.getString(column[i]) + "  ");
			System.out.println();
		}
		System.out.println();
	}


}

