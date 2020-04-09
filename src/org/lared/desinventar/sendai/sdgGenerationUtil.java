package org.lared.desinventar.sendai;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;

import javax.servlet.jsp.JspWriter;

import org.lared.desinventar.system.Sys;
import org.lared.desinventar.util.DICountry;
import org.lared.desinventar.util.DbImplementation;
import org.lared.desinventar.util.dbConnection;
import org.lared.desinventar.util.dbutils;
import org.lared.desinventar.util.pooledConnection;
import org.lared.desinventar.webobject.*;

public class sdgGenerationUtil 
{

	fichas woFicha=new fichas();
	extension woExtension=new extension();
	lev0 level0=new lev0();

	Connection con = null;
	Connection sfmCon = null;
	// on the SFM database
	Statement stmt = null;
	ResultSet rset = null;
	// on the DesInventar SDG database
	Statement di_stmt = null;
	ResultSet di_rset = null;

	public void cleanDatabase(Connection con,  DICountry countrybean)
	{
		Statement stmt=null; 

		try{
			stmt=con.createStatement();

			try{
				stmt.executeUpdate("truncate table wordsdocs");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from wordsdocs");
			}
			try{
				stmt.executeUpdate("truncate table words");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from words");
			}
			try{
				stmt.executeUpdate("truncate table media_file");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from media_file");
			}
			try{
				stmt.executeUpdate("truncate table extension");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from extension");
			}

			try{
				stmt.executeUpdate("truncate table fichas");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from fichas");
			}

			try{
				stmt.executeUpdate("truncate table lev2");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from lev2");
			}
			try{
				stmt.executeUpdate("truncate table lev1");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from lev1");
			}
			try{
				stmt.executeUpdate("truncate table lev0");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from lev0");
			}
			try{
				stmt.executeUpdate("truncate table regiones");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from regiones");
			}
			try {stmt.executeUpdate("delete from event_grouping");}catch (Exception qx){}
			try{
				stmt.executeUpdate("truncate table eventos");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from eventos");
			}
			try{
				stmt.executeUpdate("truncate table causas");
			}
			catch(Exception e){
				stmt.executeUpdate("delete from causas");
			}
		}
		catch (Exception e)
		{
			System.out.println("[DI9] Exception erasing data : "+e.toString());
		}
		finally {
			try {stmt.close();}catch (Exception e2){}
		}

	}


	private void generateMultihazard(JspWriter out) throws IOException
	{
		// Create MULTIHAZARD
		eventos hazard=new eventos();
		hazard.nombre="MULTIHAZARD";
		hazard.nombre_en="MULTIHAZARD";
		hazard.serial=1;
		hazard.descripcion="Represents all possible hazards in an year";
		hazard.addWebObject(con);
		out.println("Generated the MULTIHAZARD hazard<br/>");						
	}






	private void generateLevel0(JspWriter out) throws SQLException, IOException 
	{
		String sSql;
		// first step:   import LEVEL0: RECORDS TO CREATE level0 on SFM dataset
		sSql="SELECT distinct country.cca3, country.official_name as name "+ 
		" FROM indicator_data  id  join indicator i on i.id=id.indicator_id join country on id.country_id=country.id" + 
		" where i.lang_key like 'indicator%' "+
		" order by country.cca3, id.cycle_id ";

		rset=stmt.executeQuery(sSql);
		while (rset.next())
		{
			level0.lev0_cod=rset.getString(1);
			level0.lev0_name=rset.getString(2);
			level0.lev0_name_en=level0.lev0_name;
			level0.addWebObject(con);
			out.println("Country: "+level0.lev0_cod+" - "+level0.lev0_name+"<br/>");						
		}
	}



	private void generateDatacards(JspWriter out) throws SQLException, IOException 
	{
		String sSql;
		// second step: RECORDS TO CREATE THE DATACARDS IN DI
		sSql="SELECT distinct country.cca3, country.official_name as name, id.cycle_id+2004 as year "+
		" FROM indicator_data  id  join indicator i on i.id=id.indicator_id join country on id.country_id=country.id"+ 
		" where i.lang_key like 'indicator%'"+
		" order by country.cca3, id.cycle_id"; 

		rset=stmt.executeQuery(sSql);
		int sequence=1;
		while (rset.next())
		{
			woFicha.level0=rset.getString(1);
			woFicha.name0=rset.getString(2);
			woFicha.fechano=rset.getInt(3);
			woFicha.serial="SFM"+sequence;
			woFicha.fechames=0;
			woFicha.fechadia=0;
			woFicha.evento="MULTIHAZARD";
			woFicha.addWebObject(con);

			woExtension.clave_ext=woFicha.clave;
			woExtension.addWebObject(con);

			out.println("Row: "+sequence+ " : "+woFicha.level0+" - "+woFicha.name0+" - "+woFicha.fechano+"<br/>");	
			sequence++;
		}
	}



	private HashMap<String,String[]> mapIndicators()
	{
		HashMap<String,String[]> sdgMap=new HashMap<String,String[]>();

		String[] a1={"A_1","","","",""};	sdgMap.put("a1",a1 );
		String[] a2={"A_2","","","",""};	sdgMap.put("a2",a2 );
		String[] a2a={"muertos","","","",""};	sdgMap.put("a2a",a2a );
		String[] a3={"A_3","","","",""};	sdgMap.put("a3",a3 );
		String[] a3a={"desaparece","","","",""};	sdgMap.put("a3a",a3a );
		String[] b1={"B_1","","","",""};	sdgMap.put("b1",b1 );
		String[] b2={"heridos","","","",""};	sdgMap.put("b2",b2 );
		String[] b3={"LIVING_DMGD_DWELLINGS","","","",""};	sdgMap.put("b3",b3 );
		String[] b3a={"vivafec","","","",""};	sdgMap.put("b3a",b3a );
		String[] b4={"LIVING_DSTR_DWELLINGS","","","",""};	sdgMap.put("b4",b4 );
		String[] b4a={"vivdest","","","",""};	sdgMap.put("b4a",b4a );
		String[] b5={"LIVELIHOOD_AFCTD","","","",""};	sdgMap.put("b5",b5 );
		String[] c1={"C_1","","","",""};	sdgMap.put("c1",c1 );
		String[] c2={"","","","","LOSS_AGRI"};	sdgMap.put("c2",c2 );
		String[] c2a={"","HA_AQUACULTURE_DMGD","HA_AQUACULTURE_DSTR","HA_AQUACULTURE_TOTAL","LOSS_AQUACULTURE_TOTAL"};	sdgMap.put("c2a",c2a );
		String[] c2c={"","HA_DMGD","HA_DSTR","nhectareas","LOSS_CROPS"};	sdgMap.put("c2c",c2c );
		String[] c2l={"","LIVESTOCK_DMGD","cabezas","LIVESTOCK_TOTAL","LOSS_LIVESTOCK_TOTAL"};	sdgMap.put("c2l",c2l );
		String[] c2fo={"","HA_FOREST_DMGD","HA_FOREST_DSTR","HA_FOREST_TOTAL","LOSS_FOREST_TOTAL"};	sdgMap.put("c2fo",c2fo );
		String[] c2fi={"","VESSELS_DMGD","VESSELS_DSTR","VESSELS_TOTAL","LOSS_VESSELS_TOTAL"};	sdgMap.put("c2fi",c2fi );
		String[] c2lb={"","STOCK_FACILITIES_DMGD","STOCK_FACILITIES_DSTR","STOCK_FACILITIES_AFCTD","STOCK_LOSS_AFCTD"};	sdgMap.put("c2lb",c2lb );
		String[] c2la={"","AGRI_ASSETS_DMGD","AGRI_ASSETS_DSTR","AGRI_ASSETS_AFCTD","AGRI_ASSETS_LOSS_AFCTD"};	sdgMap.put("c2la",c2la );
		String[] c3={"C_3","PRODUCTIVE_ASSETS_DMGD","PRODUCTIVE_ASSETS_DSTR","PRODUCTIVE_ASSETS_AFCTD","PRODUCTIVE_ASSETS_LOSS_AFCTD"};	sdgMap.put("c3",c3 );
		String[] c4={"C_4","LOSS_DWELLINGS_DMGD","LOSS__DWELLINGSDSTR","LOSS_DWELLINGS",""};	sdgMap.put("c4",c4 );
		String[] c5={"","C5_INFRASTRUCTURES_DMGD","C5_INFRASTRUCTURES_DSTR","C5_INFRASTRUCTURES","C5_INFRASTRUCTURES_LOSS"};	sdgMap.put("c5",c5 );
		String[] c5a={"","HEALTH_FACILITIES_DMGD","HEALTH_FACILITIES_DSTR","nhospitales","LOSS_HEALTH_FACILITIES"};	sdgMap.put("c5a",c5a );
		String[] c5b={"","EDUCATION_DMGD","EDUCATION_DSTR","nescuelas","LOSS_EDUCATION"};	sdgMap.put("c5b",c5b );
		String[] c5c={"","NUMBER_DMGD_INFRASTRUCTURES","NUMBER_DSTR_INFRASTRUCTURES","NUMBER_INFRASTRUCTURES","LOSS_INFRASTRUCTURES"};	sdgMap.put("c5c",c5c );
		String[] c6={"","","","","C6_LOSS_CULTURAL"};	sdgMap.put("c6",c6 );
		String[] c6a={"CULTURAL_FIXED_DMGD","","","",""};	sdgMap.put("c6a",c6a );
		String[] c6b={"CULTURAL_MOBILE_DMGD","","","",""};	sdgMap.put("c6b",c6b );
		String[] c6c={"CULTURAL_MOBILE_DSTR","","","",""};	sdgMap.put("c6c",c6c );
		String[] c6d={"","","","","LOSS_CULTURAL_FIXED"};	sdgMap.put("c6d",c6d );
		String[] c6e={"","","","","LOSS_CULTURAL_MOBILE_DMGD"};	sdgMap.put("c6e",c6e );
		String[] c6f={"","","","","LOSS_CULTURAL_MOBILE_DSTR"};	sdgMap.put("c6f",c6f );			
		String[] d6={"educacion","","","",""};	sdgMap.put("d6",d6 );
		String[] d7={"salud","","","",""};	sdgMap.put("d7",d7 );



		return sdgMap;
	}


	private void loadDatacardExtension(String sCountry, int nYear) 
	{
		woFicha.init();
		woExtension.init();

		try {
			di_stmt=con.createStatement();
			di_rset=di_stmt.executeQuery("select clave from fichas where evento='MULTIHAZARD' and fechano="+nYear+" and level0='"+sCountry+"'");
			if (di_rset.next())
			{
				woFicha.clave=di_rset.getInt(1);
				woExtension.clave_ext=woFicha.clave;
				woFicha.getWebObject(con);
				woExtension.getWebObject(con);
			}			
		}
		catch (Exception  e){
			System.out.println("[DI9] Exception reading datacard: "+e.toString());

		}

	}

	private void importIndicators(JspWriter out) throws SQLException, IOException
	{
		// third step:  Imports the actual indicator record
		out.println("Starting import of SFM indicator data: <br>/");

		// generates the mapping from SFM to DI Sendai
		HashMap<String,String[]> sdgMap=mapIndicators();


		// obtain ALL DATA, NUMERIC INDICATORS:
		String sSql="SELECT country.cca3, id.country_id, country.official_name as name, id.cycle_id+2004 as year, id.damaged,"
			+" id.destroyed, id.total, id.amount, id.input_option, id.number,i.meta_name as Ind_metaname," 
			+" i.name, i.lang_key, id.source, id.indicator_status,"
			+" electricity_power, ict_system, sewage_service, solid_waste_service, water_supply,"
			+ "public_admin_service, relief_and_emergency_service, transportation_service"
			+" FROM indicator_data  id join indicator i on i.id=id.indicator_id join country on id.country_id=country.id" 
			+" where i.lang_key like 'indicator%'"
			+" order by cca3, year, Ind_metaname"; 

		rset=stmt.executeQuery(sSql);
		int sequence=0;
		String sPrevCountry="";
		int nPrevYear=0;
		int nrecs=0;
		MetadataNationalValues mData= new MetadataNationalValues();

		while (rset.next())
		{
			try {
				String sCountry=rset.getString("cca3");
				int nYear=rset.getInt("year");
				if (sequence==0)
				{
					sPrevCountry=sCountry;
					nPrevYear=nYear;
					loadDatacardExtension(sCountry,nYear);
				}

				if (nPrevYear!=nYear || !sPrevCountry.equals(sCountry))
				{  // we have read all the indicators of one datacard. update fields and save
					woFicha.updateMembersFromHashTable();
					woExtension.updateMembersFromHashTable();
					woFicha.updateWebObject(con);
					woExtension.updateWebObject(con);

					out.println("Indicators for Row: "+sequence+ " : "+woFicha.level0+" - "+woFicha.name0+" - "+woFicha.fechano+"<br/>");	
					// and starts a new cycle
					sPrevCountry=sCountry;
					nPrevYear=nYear;
					loadDatacardExtension(sCountry,nYear);
				}

				double[] dValues=new double[5];

				dValues[0]=rset.getDouble("number");
				dValues[1]=rset.getDouble("damaged");
				dValues[2]=rset.getDouble("destroyed");
				dValues[3]=rset.getDouble("total");
				dValues[4]=rset.getDouble("amount");

				// we need to convert the amount to USD dollars here!!!
				if (dValues[4]!=0.0 && mData.metadata_year!=nYear && !mData.metadata_country.equals(sCountry) )
				{
					mData.metadata_key=8;
					mData.metadata_country=sCountry;
					mData.metadata_year=nYear;
					nrecs=mData.getWebObject(con);
					if (nrecs<=0)
						mData.metadata_value=1;
					// converts value to USD $ !!
					dValues[4]*=mData.metadata_value;						
				}

				String sIndicator=rset.getString("Ind_metaname"); 
				String sFields[]=sdgMap.get(sIndicator);
				if (sFields!=null)
				{
					for (int j=0; j<5; j++)
					{
						if (sFields[j].length()>0)
						{	  // compare if name is lower case to see where does it belong, fichas or extension
							if (sFields[j].toUpperCase().equals(sFields[j]))
								woExtension.asFieldNames.put(sFields[j], String.valueOf(dValues[j]));
							else
								woFicha.asFieldNames.put(sFields[j], String.valueOf(dValues[j]));
						}

					}

				}

				if (sIndicator.equals("d8"))
				{
					woFicha.asFieldNames.put("acueducto", webObject.not_null(rset.getString("water_supply")));
					woFicha.asFieldNames.put("alcantarillado", webObject.not_null(rset.getString("sewage_service")));
					woFicha.asFieldNames.put("energia", webObject.not_null(rset.getString("electricity_power")));
					woFicha.asFieldNames.put("comunicaciones", webObject.not_null(rset.getString("ict_system")));
					woFicha.asFieldNames.put("socorro", webObject.not_null(rset.getString("relief_and_emergency_service")));
					woFicha.asFieldNames.put("transporte", webObject.not_null(rset.getString("transportation_service")));

					// THESE FIELDS WERE ADDED TO SENDAI FORMAT in DATAMODEL 16				
					woExtension.asFieldNames.put("PUBLIC_ADMIN_SERVICE", webObject.not_null(rset.getString("public_admin_service")));
					woExtension.asFieldNames.put("SOLID_WASTE_SERVICE", webObject.not_null(rset.getString("solid_waste_service")));

				}

			}
			catch(Exception e)
			{
				out.println ("Exception SFM Import: processing SFM record..."+e.toString()+"<br/>");				
			}


			sequence++;
		}
		// last datacard is still pending - save it
		woFicha.updateMembersFromHashTable();
		woExtension.updateMembersFromHashTable();
		woFicha.updateWebObject(con);
		woExtension.updateWebObject(con);

	}


	private void tempCode()  throws SQLException, IOException
	{
		int sequence=0;
		String sPrevCountry="";
		int nPrevYear=0;

		String sCountry=rset.getString("cca3");
		int nYear=rset.getInt("year");



	}

	public void importSFM(DICountry countrybean, JspWriter out) 
	{

		try{
			pooledConnection univ=new pooledConnection(countrybean.country.sdriver,countrybean.country.sdatabasename , countrybean.country.susername,countrybean.country.spassword);
			univ.getConnection();
			con=univ.connection;


			cleanDatabase(con,  countrybean);


			pooledConnection cnt=new pooledConnection("com.mysql.jdbc.Driver", "jdbc:mysql://localhost:3306/sendai_prod","root","c0l0mbia98");

			boolean bOK=cnt.getConnection();
			if (bOK){
				sfmCon=cnt.connection;				
				stmt=sfmCon.createStatement();

				// Create MULTIHAZARD  hazard for all SFM records
				generateMultihazard(out);

				// first step:   import LEVEL0: RECORDS TO CREATE level0 on SFM dataset
				generateLevel0(out);

				// second step: RECORDS TO CREATE THE DATACARDS IN DI
				generateDatacards(out);

				// loads the datacard extension object with all variables
				woExtension.loadExtension(con,countrybean);
				// third step:  Imports the actual indicator record
				importIndicators(out);

				// return connections to pool
				univ.close();
				cnt.close();

			}
			else
				out.println("Error importing DesInventar [NO DB CONN]: "+countrybean.countrycode+" - "+countrybean.countryname +
						" Err="+cnt.strConnectionError+"<br/>");
		}
		catch (Exception eImp)
		{
			System.out.println("[DI9] Error importing SFM data: "+eImp.toString());
		}
	}

	public boolean getRates(DICountry countrybean, JspWriter out, String[] arrRateStrings)
	{
		try{
			pooledConnection univ=new pooledConnection(countrybean.country.sdriver,countrybean.country.sdatabasename , countrybean.country.susername,countrybean.country.spassword);
			boolean bOK=univ.getConnection();


			if (bOK){
				con=univ.connection;

				arrRateStrings[0]=""; //"Code";
				arrRateStrings[1]=""; //"Year";
				arrRateStrings[2]=""; //"Rate";
				arrRateStrings[3]=""; //"Country";

				stmt=con.createStatement();
				rset=stmt.executeQuery("select * from metadata_national_values left join lev0 on METADATA_COUNTRY=lev0_cod where METADATA_KEY=8");
				while (rset.next())
				{
					arrRateStrings[0]+=rset.getString("METADATA_COUNTRY")+"\n";	
					arrRateStrings[1]+=rset.getString("METADATA_YEAR")+"\n";	
					arrRateStrings[2]+=rset.getString("METADATA_VALUE")+"\n";	
					arrRateStrings[3]+=webObject.not_null(rset.getString("lev0_name"))+"\n";	
				}

				univ.close();					
			}
			else
				out.println("Error importing DesInventar [NO DB CONN]: "+countrybean.countrycode+" - "+countrybean.countryname +
						" Err="+univ.strConnectionError+"<br/>");
		}
		catch (Exception eImp)
		{
			System.out.println("[DI9] Error importing SFM data: "+eImp.toString());
		}

		return true;

	}

	public static boolean isNumeric(String strNum) 
	{
	    if (strNum == null) {
	        return false;
	    }
	    try {
	        double d = Double.parseDouble(strNum);
	    } catch (NumberFormatException nfe) {
	        return false;
	    }
	    return true;
	}
	
	public boolean uploadRates(DICountry countrybean, JspWriter out, String sCodes, String sYears, String sRates) throws IOException
	{

		int nrec=0;
		
		try{
			pooledConnection univ=new pooledConnection(countrybean.country.sdriver,countrybean.country.sdatabasename , countrybean.country.susername,countrybean.country.spassword);
			boolean bOK=univ.getConnection();


			if (bOK)
			{
				con=univ.connection;

				String[] aCodes = sCodes.split("\n");
				String[] aYears = sYears.split("\n");
				String[] aRates = sRates.split("\n");
				if (aCodes.length!=aYears.length ||  aCodes.length!=aRates.length)
					out.println("<strong>WARNING: columns have different size!</strong> Please review<br/>");
				
				MetadataNational mNational= new MetadataNational();
				MetadataNationalValues mData= new MetadataNationalValues();
				lev0 country=new lev0();
				for (int j=0;  j<Math.min(aCodes.length, Math.min(aYears.length, aRates.length)); j++)
				{
					mData.metadata_key=8;  // CURRENCY EXCHANGE RATE!
					mData.metadata_country=country.lev0_cod=aCodes[j].trim();
					
					nrec=country.getWebObject(con);
						
					if ((nrec>0 || mData.metadata_country.length()==3) && this.isNumeric(aYears[j].trim()) && this.isNumeric(aRates[j].trim()))
					{
						// Checks foreign key exists on metadata national 
						mNational.metadata_key=8;  // CURRENCY EXCHANGE RATE!
						mNational.metadata_country=country.lev0_cod;
						mNational.metadata_description="Exchange rate (average or end of year)";
						mNational.metadata_source="National Government / World Bank";
						mNational.metadata_variable="exrate";
						mNational.metadata_default_value=1;
						mNational.metadata_default_value_us=1;						
						nrec=mNational.updateWebObject(con);
						if (nrec==0)
							nrec=mNational.addWebObject(con);

						// Adds/updates metadata national values 						
						mData.metadata_year=webObject.extendedParseInt(aYears[j]);
						mData.metadata_value_us=mData.metadata_value=webObject.extendedParseDouble(aRates[j]);
						nrec=mData.updateWebObject(con);
						if (nrec==0)
							nrec=mData.addWebObject(con);
					}
				}

				univ.close();					
			}
			else
				out.println("Error importing DesInventar [NO DB CONN]: "+countrybean.countrycode+" - "+countrybean.countryname
						    +" Err="+univ.strConnectionError+"<br/>");
		}
		catch (Exception eImp)
		{
			System.out.println("[DI9] Error importing SFM data: "+eImp.toString());
		}

		return true;


	}

}
