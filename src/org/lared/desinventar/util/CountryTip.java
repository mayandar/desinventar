/**
 * 
 */
package org.lared.desinventar.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.*;
import org.lared.desinventar.webobject.*;

/**
 * @author Julio Serje
 *
 */
public final class CountryTip 
extends HashMap<String,String> 
{

	/**
	 * Singleton with an Hash map of country tips, calculated just once!
	 */

	public static String getCountryTipHTMLfromDB(country cCountry, DICountry countrybean)
	{
		String sDescription=countrybean.getLocalOrEnglish(cCountry.sdescriptiones,cCountry.sdescriptionen);
		dbConnection dbConAux = null;
		Connection conAux = null;
		Statement st=null;
		ResultSet rs=null;
		cCountry.dbType=cCountry.ndbtype; // dbType is the webObject variable, ndbtype is the persistent filed in the database!
		try {
			dbConAux = new dbConnection(cCountry.sdriver, cCountry.sdatabasename, cCountry.susername, cCountry.spassword);
			conAux=dbConAux.dbGetConnection();
			if (conAux!=null)
			{
				st=conAux.createStatement();
				String sSql= "SELECT count(*) as nrecs, min(fechano) as datefrom, max(fechano) as dateto FROM fichas where "+ cCountry.sqlNvl("fichas.approved",0)+"=0";
				rs=st.executeQuery(sSql);
				if (rs.next())
				{
					sDescription+="<br><strong>"+countrybean.getTranslation("Summary")+":</strong>";
					sDescription+="<br>"+countrybean.getTranslation("DataCards")+": "+rs.getInt("nrecs");
					int nFrom=rs.getInt("datefrom");
					int nTo=rs.getInt("dateto");
					if (nFrom>0)
						cCountry.speriod=String.valueOf(nFrom);
					if (nTo>nFrom)
						cCountry.speriod+=" - "+nTo;
					sDescription+="<br>"+countrybean.getTranslation("Period")+":<dataperiod/>"+cCountry.speriod+"<br>";
					rs=st.executeQuery("select * from (SELECT evento, count(*) as nrecs, sum(0.0+muertos) as killed, max(muertos) as largest FROM fichas where "+ cCountry.sqlNvl("fichas.approved",0)+"=0 group by evento) t, eventos where t.evento=eventos.nombre order by killed desc");
					int j=0;
					while (j<3 && rs.next())
					{
						if (j==0)
							sDescription+="<br><strong>"+countrybean.getTranslation("HighestMortality")+":</strong> ";
						sDescription+="<br>"+rs.getString("nombre_en")+":  "+rs.getInt("killed")+" "+countrybean.getTranslation("Deaths")+"; "+rs.getInt("nrecs")+" "+countrybean.getTranslation("DataCards");
						j++;
					} 
					rs=st.executeQuery("select * from (SELECT evento, count(*) as nrecs, sum(0.0+vivdest+vivafec) as housing FROM fichas where "+ cCountry.sqlNvl("fichas.approved",0)+"=0 group by evento) t, eventos where t.evento=eventos.nombre order by housing desc");
					j=0;
					while (j<3 && rs.next())
					{
						if (j==0)
							sDescription+="<br><strong>"+countrybean.getTranslation("HighestHousingDamages")+":</strong> ";
						sDescription+="<br>"+rs.getString("nombre_en")+":  "+rs.getInt("housing")+" "+countrybean.getTranslation("Houses")+"; "+rs.getInt("nrecs")+" "+countrybean.getTranslation("DataCards");
						j++;
					} 
				}
				
			}
		}
		catch (Exception exd)
		{
			System.out.println("DI9: Error generating HTML tip: "+ exd.toString());
		}
		finally
		{
			try {rs.close();} catch (Exception x){} 	
			try {st.close();} catch (Exception x){}
			dbConAux.close();		 

		}
		return "<table width=450 border=\"0\"><tr><td class=\"DI_TableHeader\"><strong>"+cCountry.scountryname+"</strong></td></tr><tr><td class='bss' >"+sDescription+"</td></tr></table>";
	}


	public static String getCountryTip(country cCountry, DICountry countrybean)
	{
		String sTip=CountryTip.getCountryTipHTML(cCountry, countrybean);
		sTip="sTip"+cCountry.scountryid+"= '"+EncodeUtil.jsEncode(sTip)+"';\n";
		return sTip;
	}

	public static String getCountryTipHTML(country cCountry, DICountry countrybean)
	{
		String sTip=theInstance.get(cCountry.scountryid);
		if (sTip==null)
		{
			sTip=CountryTip.getCountryTipHTMLfromDB(cCountry, countrybean);
			theInstance.put(cCountry.scountryid, sTip);
		}
		else
		{
			cCountry.speriod=sTip.substring(sTip.indexOf("<dataperiod/>")+13);
			cCountry.speriod=cCountry.speriod.substring(0,Math.min(12,cCountry.speriod.indexOf("<br>")));
		}
		return sTip;
	}

	private static CountryTip theInstance=new CountryTip();

	public static CountryTip getInstance()
	{
		return theInstance;
	}

	private CountryTip()
	{
		// empty private constructor  to enforce singleton	
	}

}
