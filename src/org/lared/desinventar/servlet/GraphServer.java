package org.lared.desinventar.servlet;

/**
 * <p>Title: DesInventar WEB Version 6.1.2 Graph Server</p>
 * <p>Description: Chart generation servlet, for the  On-Line Version of DesInventar/DesConsultar 6.</p>
 * <p>Copyright: Copyright (c) 2002  La  Red.</p>
 * <p>Company: La Red -  La Red de Estudios Sociales en Prevención de Desastres en América Latina</p>
 * @author Julio Serje
 * @version 1.0
 */

import java.awt.*;
import java.io.*;
import java.util.*;
import java.sql.*;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;


import org.lared.desinventar.chart.*;
import org.lared.desinventar.util.*;
import org.lared.desinventar.webobject.*;

public class GraphServer 
				extends GenericServlet
				implements chartConstants
{

	PrintWriter out=null;

	//----------------------------------------------------------------------------
	// allocates space for vectors
	//----------------------------------------------------------------------------
	public void initVectors(chartInfo c, DICountry countrybean, Vector vGroups)
	{
		c.x = new double[c.nPoints + 1]; // x values (c.x[c.nPoints])
		c.y = new double[c.nSets*2][c.nPoints + 1]; // multiple sets of y values c.y[nSet][c.nPoints]+regression set
		c.cSetColor = new Color[MAXCOLORS]; // color of each set  cSetColor[nSet]
		c.sSetLabels = new String[c.nSets]; // label of each set sSetLabel[c.nSets]
		c.sLabels = new String[c.nPoints + 1]; // label of each value sLabel[c.nPoints]



		c.sVariable =  countrybean.getVartitle(countrybean.asVariables[0]);
		for (int k = 1; k < countrybean.asVariables.length; k++)
			c.sVariable += " + " + countrybean.getVartitle(countrybean.asVariables[k]);
		if (c.sVariable.equals("1"))
			c.sVariable = countrybean.getTranslation("DataCards");
		if (c.nSets <= 1)
			c.sSetLabels[0] = c.sVariable;
		else
			for (int j = 0; j < c.nSets; j++)
				c.sSetLabels[j] = ( (String) vGroups.elementAt(j));

		c.cSetColor[0] = Color.blue; // color of each set  cSetColor[nSet]
		c.cSetColor[1] = Color.red;
		c.cSetColor[2] = Color.green;
		c.cSetColor[3] = Color.yellow;
		c.cSetColor[4] = Color.magenta;
		c.cSetColor[5] = Color.orange;
		c.cSetColor[6] = Color.cyan;
		c.cSetColor[7] = Color.pink;
		c.cSetColor[8] = Color.lightGray;
		c.cSetColor[9] = Color.yellow;
		
		if (countrybean.nChartType==DISTRIBUTION_HISTOGRAM)
		{
			for (int j = 0; j < c.nPoints-1; j++)
				c.sLabels[j] = countrybean.formatDouble((int)(c.dMaximumX*j/c.nPoints+0.5));
			c.sLabels[c.nPoints-1]=countrybean.formatDouble(c.dMaximumX);
		}
		else if (countrybean.nPeriodType == MONTH)
		{
			if (c.nPoints <= 24) // anual-mensual
			{
				try
				{
					c.sLabels[0] = countrybean.getTranslation("-");
					c.sLabels[1] = countrybean.getTranslation("Jan");
					c.sLabels[2] = countrybean.getTranslation("Feb");
					c.sLabels[3] = countrybean.getTranslation("Mar");
					c.sLabels[4] = countrybean.getTranslation("Apr");
					c.sLabels[5] = countrybean.getTranslation("May");
					c.sLabels[6] = countrybean.getTranslation("Jun");
					c.sLabels[7] = countrybean.getTranslation("Jul");
					c.sLabels[8] = countrybean.getTranslation("Aug");
					c.sLabels[9] = countrybean.getTranslation("Sep");
					c.sLabels[10] = countrybean.getTranslation("Oct");
					c.sLabels[11] = countrybean.getTranslation("Nov");
					c.sLabels[12] = countrybean.getTranslation("Dec");
				}
				catch (Exception rangeex){}  // do nothing.. not worth it
			}
			else
			{

				for (int j = 0; j < c.nPoints; j++)
					c.sLabels[j] = String.valueOf(j % 12 +1);
				//  c.sLabels[j] = ("xJFMAMJJASOND").substring(j % 13, j % 13 + 1);
			}
		}
	}

	//----------------------------------------------------------------------------
	// Creates the vectors with random data. good for testing
	//----------------------------------------------------------------------------
	private void initRandom(chartInfo c)
	{
		double dmaximum;
		// fills the vectors with random data
		dmaximum=Math.random()*1000;
		for (int k=0; k<c.nSets; k++)
			for (int j=0; j<c.nPoints; j++)
			{
				c.x[j]=j;
				c.y[k][j]=Math.random()*dmaximum;
				c.sSetLabels[k]="Set "+k;
				c.sLabels[j]="Point "+j;
			}
	}

	//----------------------------------------------------------------------------
	// Creates the vectors for a dual variable histogram
	//----------------------------------------------------------------------------
	private Vector getSubGrouperVector(String subgrouper, String[] asVector,
			chartInfo c, DICountry countrybean, Connection con,
			boolean bAggregate)
	{
		Vector retVector=new Vector();
		// query the database to find out how many sets are there...
		String sSql = "";
		// System.out.println("Ready to group vectors.."+sSql);
		ArrayList<String> sqlparams=new ArrayList<String>();
		PreparedStatement pstmt=null;

		c.nSets = 0;
		if (asVector != null)
		{
			c.nSets = asVector.length;
			// System.out.println("using param. vector: "+c.nSets);
		}
		if (c.nSets == 0)
		{

			try
			{
				sSql = "Select count(*) as nrecs,"+subgrouper+" as subgrouper "+ countrybean.getWhereSql(sqlparams)+
				" group by "+ subgrouper;
				pstmt=con.prepareStatement(sSql);
				for (int k=0; k<sqlparams.size(); k++)
							pstmt.setString(k+1, (String)sqlparams.get(k));
				ResultSet rset=pstmt.executeQuery();
				while (rset.next())
				{
					String sSubGrouper=htmlServer.not_null(rset.getString("subgrouper"));
					if (bAggregate)
						retVector.addElement(sSubGrouper+" "+rset.getInt("nrecs"));
					else
						retVector.addElement(sSubGrouper); // +" ("+rset.getInt("nRecs")+")");
					c.nSets++;
					// System.out.println("element "+c.nSets);
				}
				rset.close();
				pstmt.close();
				// System.out.println("Normal end executing vector count ");
			}
			catch (Exception esubgrp)
			{
				System.out.println("Error executing vector count - SQL: " + esubgrp.toString());
			}

		}
		else
		{
			for (int j=0; j<asVector.length; j++)
			{
				if (countrybean.nChartType==VARIABLE_HISTOGRAM)
					retVector.addElement(countrybean.getVartitle(asVector[j].trim()));
				else
					retVector.addElement(asVector[j].trim());
				// System.out.println("Returning clone: "+asVector[j]);
			}
		}
		return  retVector;
	}



	//----------------------------------------------------------------------------
	// Calculates the range of periods in a Histogram
	//----------------------------------------------------------------------------
	private double getMaximum(String sVar, DICountry countrybean, Connection con)
	{
		// System.out.println("Getting maximum range for Distribution Histogram: " + sSql);
		//String sSql = "Select  max(" + sVar + ") as nMax, avg("+ sVar + ") as average, "
		//       +countrybean.sqlStddev() + sVar + ") as standarddev " + countrybean.getWhereSql();

		ArrayList<String> sqlparams=new ArrayList<String>();
		PreparedStatement pstmt=null;
 	    String sSql = "Select  max(" + sVar + ") as nMax " + countrybean.getWhereSql(sqlparams);

 	    double nMax=1000; // arbitrary
		try
		{
			pstmt=con.prepareStatement(sSql);
			for (int k=0; k<sqlparams.size(); k++)
						pstmt.setString(k+1, (String)sqlparams.get(k));
			ResultSet rset=pstmt.executeQuery();
			
			if (rset.next())
			{
				nMax = rset.getDouble("nMax");
				//double nMax2=rset.getDouble("average")+rset.getDouble("standarddev")*3.0;
				//if (nMax2<nMax)
				//	nMax=nMax2;
			}
			try {rset.close();} catch (Exception e){}
			try {pstmt.close();} catch (Exception e){}
			// System.out.println("max/mins from DB: "+iStart+" - "+iEnd+" grouper: "+grouper);
		}
		catch (Exception esubgrp)
		{
			System.out.println("Error executing max range calc - SQL: " + sSql.toString());
		}
		return nMax;
	}

	//----------------------------------------------------------------------------
	// Calculates the range of periods in a Histogram
	//----------------------------------------------------------------------------
	private int getDistinct(String sVar, DICountry countrybean, Connection con)
	{
		// System.out.println("Getting number of ranges for Distribution Histogram: " + sSql);
		ArrayList<String> sqlparams=new ArrayList<String>();
		PreparedStatement pstmt=null;
		String sSql = "Select  count(*) as nmax from ( select distinct " +sVar+countrybean.getWhereSql(sqlparams)+") t";
		int nMax=100; // arbitrary
		try
		{
			pstmt=con.prepareStatement(sSql);
			for (int k=0; k<sqlparams.size(); k++)
						pstmt.setString(k+1, (String)sqlparams.get(k));
			ResultSet rset=pstmt.executeQuery();
			if (rset.next())
				nMax = rset.getInt("nmax");
			rset.close();
			pstmt.close();
			// System.out.println("max/mins from DB: "+iStart+" - "+iEnd+" grouper: "+grouper);
		}
		catch (Exception esubgrp)
		{
			System.out.println("Error executing max distinct calc - SQL: " + sSql.toString());
		}
		return nMax;
	}


	//----------------------------------------------------------------------------
	// Calculates the range of periods in a Histogram
	//----------------------------------------------------------------------------
	private Vector getRange(String grouper, chartInfo c, DICountry countrybean, Connection con)
	{
		Vector retVector=new Vector();
		int iStart=0;
		int iEnd=1;
		ArrayList<String> sqlparams=new ArrayList<String>();
		PreparedStatement pstmt=null;
		
		// there are two scenarios: a) a fixed range of dates b) no date range
		if (countrybean.toyear==0 || countrybean.fromyear==0)
		{
			// scenario b) no date range: query the database to find out how many sets are there...
			String sSql = "Select min(" + grouper + ") as p_from, max(" + grouper + ") as p_to " + countrybean.getWhereSql(sqlparams);
			// System.out.println("Getting range for Histogram: " + sSql);
			try
			{
				pstmt=con.prepareStatement(sSql);
				for (int k=0; k<sqlparams.size(); k++)
							pstmt.setString(k+1, (String)sqlparams.get(k));
				ResultSet rset=pstmt.executeQuery();
				if (rset.next())
				{
					iStart = rset.getInt("p_from");
					iEnd = rset.getInt("p_to");
				}
				rset.close();
				pstmt.close();
				// System.out.println("max/mins from DB: "+iStart+" - "+iEnd+" grouper: "+grouper);
			}
			catch (Exception esubgrp)
			{
				// System.out.println("Error executing range calc - SQL: " + esubgrp.toString());
			}
		}
		// Now, don't forget scenario a). fixed range of dates:
		if (countrybean.toyear>0)
		{
			int nMonth=12;
			int nDay=31;
			if (countrybean.tomonth>0)
				nMonth=countrybean.tomonth;
			if (countrybean.today>0)
				nDay=countrybean.today;

			switch (countrybean.nPeriodType)
			{
			case YEAR:
				iEnd=countrybean.toyear;
				break;
			case MONTH:
				iEnd=countrybean.toyear *12 +nMonth;
				break;
			case WEEK:
				iEnd=countrybean.toyear *52 +(int)(nMonth*4.34+nDay/7);
				break;
			case DAY:
				iEnd=countrybean.toyear *365 +nMonth*30+nDay;
				break;
			}
			// System.out.println("max from screen: "+iEnd);
		}

		if (countrybean.fromyear>0)
		{
			switch (countrybean.nPeriodType)
			{
			case YEAR:
				iStart=countrybean.fromyear;
				break;
			case MONTH:
				iStart=countrybean.fromyear *12 +countrybean.frommonth;
				break;
			case WEEK:
				iStart=countrybean.fromyear *52 +(int)(countrybean.frommonth*4.34+countrybean.fromday/7);
				break;
			case DAY:
				iStart=countrybean.fromyear *365 +countrybean.frommonth*30+countrybean.fromday;
				break;
			}
			// System.out.println("min from screen: "+iStart);
		}
		// finally load the return vector with the start/end
		retVector.addElement(new Integer(iStart));
		retVector.addElement(new Integer(iEnd));
		c.nPoints = iEnd-iStart+1;
		return  retVector;
	}


	//----------------------------------------------------------------------------
	// determine the period aggregator
	//----------------------------------------------------------------------------
	private String getPeriodGrouper(DICountry countrybean)
	{
		String grouper="fechano";
		switch (countrybean.nPeriodType)
		{
		case MONTH:
			grouper = "fechano*12 +" + countrybean.sqlNvl( "fechames","6");
			break;
		case WEEK:
			grouper = "fechano*52 +" + countrybean.sqlTrunc() +
			"(" + countrybean.sqlNvl( "fechames","6")+"-1)*4.34 + " + countrybean.sqlNvl("FECHADIA","15")+"/7+0.5)";
			break;
		case DAY:
			grouper = "fechano*365 + " + countrybean.sqlNvl( "fechames","6")+"*30+ " + countrybean.sqlNvl("FECHADIA","15");
			break;
		}
		return grouper;
	}

	//----------------------------------------------------------------------------
	// determine the season aggregator;
	//----------------------------------------------------------------------------
	private String getSeasonGrouper(chartInfo c, DICountry countrybean)
	{
		String subgrouper = countrybean.sqlNvl( "fechames","0"); // histogram grouper
		switch (countrybean.nSeasonType)
		{
		case CENTURY:  // must be YEAR
			subgrouper = countrybean.sqlMod("fechano",100);
			c.nPoints=100;
			break;
		case DECADE:
			subgrouper = countrybean.sqlMod("fechano",10);
			if (countrybean.nPeriodType==YEAR)
			{
				c.nPoints = 10; // decade-year,
			}
			else
				if (countrybean.nPeriodType==MONTH)
				{
					subgrouper = "("+subgrouper+")*12 +"+countrybean.sqlNvl( "fechames","0");
					c.nPoints = 130; // decade-month, a spot for month=null or 0
				}
				else
				{   // TODO: verify fix here the issues with null days
					subgrouper = "(" + subgrouper + ")*52 +" + countrybean.sqlTrunc() +
					"("+countrybean.sqlNvl( "fechames","0")+"-1)*4.34 + "+countrybean.sqlNvl( "fechadia","0")+"/7+0.5)";
					c.nPoints = 530; // decade - week , a spot for month or day =null or 0
				}
			break;
		case QUINQUENIAL:
			subgrouper = countrybean.sqlMod("fechano",5);
			if (countrybean.nPeriodType==YEAR)
			{
				c.nPoints = 5; // year
			}
			else
				if (countrybean.nPeriodType==MONTH)
				{
					subgrouper = "("+subgrouper+")*12 +"+countrybean.sqlNvl( "fechames","0");
					c.nPoints = 65; // 5yrs-monthly + a spot for month=null or 0
				}
				else
				{
					subgrouper +="*52 +" + countrybean.sqlTrunc() + "("+countrybean.sqlNvl( "fechames","0")+"-1)*4.34+fechadia/7+0.5)";
					c.nPoints = 260; // 5yrs-monthly
				}
			break;
		case YEAR_S:
			if (countrybean.nPeriodType == MONTH)
			{
				subgrouper = countrybean.sqlNvl( "fechames"," 0"); // yes, leave this out of the season if null
				c.nPoints = 13; // anual-mensual
			}
			else
				if (countrybean.nPeriodType == WEEK)
				{
					// TODO: verify  fix here the issues with null days
					subgrouper =countrybean.sqlTrunc() + "("+ countrybean.sqlNvl( "fechames","0")+"-1)*4.34 + "+countrybean.sqlNvl( "fechadia","0")+" /7 +0.5)";
					c.nPoints = 53; // anual -semanal + semana 0.
				}
				else
					if (countrybean.nPeriodType == DAY)
					{
						// TODO:  fix here the issues with null days
						subgrouper=countrybean.sqlNvl( "fechames","0")+"*31 + "+countrybean.sqlNvl( "fechadia","0");  // same here: if null, let it be... for now
						c.nPoints = 375; // anual-diario
					}
			break;
		case MONTH_S:
			subgrouper = countrybean.sqlNvl( "fechadia","0");
			break;
		}
		return subgrouper;
	}


	//----------------------------------------------------------------------------
	// getd the data from the database
	//----------------------------------------------------------------------------
	private void loadDataFromDB(chartInfo c, DICountry countrybean, String sSql, ArrayList<String> sqlparams, Vector vGroups, int iStart, Connection con)
	{
		String subgrouper="";

		try
		{
			PreparedStatement pstmt = null;
			ResultSet rset = null;

			pstmt=con.prepareStatement(sSql);
			for (int k=0; k<sqlparams.size(); k++)
						pstmt.setString(k+1, (String)sqlparams.get(k));
			rset=pstmt.executeQuery();

			// System.out.println("Sql executed OK");
			if (countrybean.dChartMaxX>0)
				c.dMaximumX=countrybean.dChartMaxX;
			double dmax=Math.log(Math.max(c.dMaximumX,1));
			//      if (countrybean.nChartRanges<5
			//      countrybean.nChartRanges=30;
			int iset = 0;
			int ipoint = 0;
			while (rset.next())
			{
				try
				{

					switch (countrybean.nChartType)
					{
					case 0:
					case HISTOGRAM: //                  0-line
					case EVENT_HISTOGRAM: //                  1-bar,
					case CAUSE_HISTOGRAM: //                  1-bar,
					case GEO_HISTOGRAM: //                  2-Pie,
					case VARIABLE_HISTOGRAM: //                  0-line
						ipoint = rset.getInt("grouper");
						if (countrybean.nPeriodType==YEAR)
							c.sLabels[ipoint - iStart] = Integer.toString(ipoint);
						else
							if (countrybean.nPeriodType==MONTH)
								c.sLabels[ipoint - iStart] = ((int)(ipoint/12))+"/" + Integer.toString((ipoint-iStart)%12+1);
							else
								c.sLabels[ipoint - iStart] = Integer.toString(ipoint-iStart);
						ipoint -= iStart;
						switch (countrybean.nChartType)
						{
						case EVENT_HISTOGRAM: //                  1-bar,
						case CAUSE_HISTOGRAM: //                  1-bar,
						case GEO_HISTOGRAM: //                  2-Pie,
							// determines the set number!!
							subgrouper=rset.getString("subgrouper").trim();
							iset = vGroups.indexOf(subgrouper);
							if (iset<0)
							{
								// System.out.println("unknown subgrouper:"+subgrouper);
								iset=0;
							}
						}
						break;
					case SEASON_HISTOGRAM: //                  3-seasonal histogram
						ipoint = Math.max(0,rset.getInt("grouper"));
						if (countrybean.nPeriodType!=MONTH)
							c.sLabels[ipoint] = Integer.toString(ipoint);
						break;
					case EVENT_COMPARISON: //                  4-comparative occasional
					case GEO_COMPARISON: //                  5-comparative geographical
					case CAUSE_COMPARISON: //                  6-comparative occasional
						c.sLabels[ipoint] = rset.getString("grouper");
						break;
					}

					if (countrybean.nChartType!=DISTRIBUTION_HISTOGRAM && countrybean.nChartType!=LOSS_EXCEEDANCE_CURVE)
					{
						c.x[ipoint] = htmlServer.extendedParseInt(c.sLabels[ipoint]);
						if (c.x[ipoint] == 0)
							c.x[ipoint] = ipoint;        	  
					}

					if (countrybean.nChartType==VARIABLE_HISTOGRAM)
					{
						for (iset=0; iset<countrybean.asVariables.length; iset++)
							c.y[iset][ipoint] = rset.getDouble(iset+1);
					}
					else
						if (countrybean.nChartType==DISTRIBUTION_HISTOGRAM)
						{
							double dpoint=rset.getDouble(1);

							//if (dpoint==2 || dpoint==1)
								//		System.out.println("found one:"+dpoint);

							if (dpoint==0)
								ipoint=0;
							else
								if (countrybean.bLogarithmicX)
								{
									dpoint=Math.log(dpoint);
									ipoint=(int)Math.round(dpoint*c.nPoints/dmax);            		
								}
								else
									ipoint=(int)Math.round(dpoint*c.nPoints/Math.max(c.dMaximumX,1));
							if (ipoint>=c.nPoints)
								ipoint=c.nPoints-1;
							c.y[iset][ipoint]+=1;
						}
						else  if (countrybean.nChartType==LOSS_EXCEEDANCE_CURVE)
						{
							double dpoint=rset.getDouble(1);
							ipoint=0;
							double dPow10=1;
							while (dpoint>=dPow10)
							{
								c.y[iset][ipoint]++;
								ipoint++;
								dPow10*=10;
							}
							c.y[iset][ipoint]++;
						}
						else
							c.y[iset][ipoint] = rset.getDouble(1);

				}
				catch (Exception innerloop)
				{
					System.out.println("Error in inner loop, ip="+ipoint+" is="+iset+"  executing data SQL: " + innerloop.toString());
				}
				ipoint++;
			}
			rset.close();
			pstmt.close();
			// POST-main cycle processing
			switch (countrybean.nChartType)
			{
			case 0:
			case HISTOGRAM: //                  0-line
			case EVENT_HISTOGRAM: //                  1-bar,
			case CAUSE_HISTOGRAM: //                  1-bar,
			case GEO_HISTOGRAM: //                  2-Pie,
			case VARIABLE_HISTOGRAM: //                  0-line
				for (int j=0; j<c.nPoints; j++)
				{
					ipoint = j+ iStart;
					if (countrybean.nPeriodType==YEAR)
						c.sLabels[ipoint - iStart] = Integer.toString(ipoint);
					else if (countrybean.nPeriodType==MONTH)
						// fromyear *12 + Month
						c.sLabels[ipoint - iStart] = ((int)(ipoint/12))+"/" + Integer.toString((ipoint)%12+1);
					else if (countrybean.nPeriodType==WEEK)
					{
						//fromyear *52 +(int)(nMonth*4.34)
						int ny=((int)(ipoint/52)); // year
						c.sLabels[ipoint - iStart] = ny +"-" + Integer.toString((ipoint)%52+1);
					}
					else
						c.sLabels[ipoint - iStart] = Integer.toString(ipoint-iStart);
				}
				break;
			case DISTRIBUTION_HISTOGRAM:
				double dNewMax=0;
				for (ipoint=0; ipoint<c.nPoints; ipoint++)
				{
					if (countrybean.bLogarithmicX)
						c.x[ipoint] = Math.exp((ipoint)*dmax/c.nPoints);
					else
						c.x[ipoint] = (int)((ipoint+1)*Math.max(c.dMaximumX,1)/c.nPoints);
					//c.sLabels[ipoint]= String.valueOf((int)c.x[ipoint]);    		  
					c.sLabels[ipoint]=webObject.formatDouble(c.x[ipoint],-1);    		  
					if (c.y[0][ipoint]>dNewMax)  
						dNewMax=c.y[0][ipoint]; 
				}
				c.dMaximumY=dNewMax;
				break;
			case LOSS_EXCEEDANCE_CURVE:
				dNewMax=0;
				for (ipoint=0; ipoint<c.nPoints; ipoint++)
				{
					c.y[iset][ipoint]/=c.nyears;  
					c.x[ipoint] = Math.pow(10,ipoint);
					//c.sLabels[ipoint]= String.valueOf((int)c.x[ipoint]);    		  
					c.sLabels[ipoint]=webObject.formatDouble(c.x[ipoint],-2);    		  
				}
				c.dMaximumY=1000.0;
			}

			// System.out.println("All points read...");

			// now build an a ccumulated chart if specified
			if (countrybean.nChartSubmode==3)      
				for (int k=0; k<c.nSets; k++)
					for (int j=1; j<c.nPoints; j++)
						c.y[k][j]+=c.y[k][j-1];             

		}
		catch (Exception esql2)
		{
			String sError= esql2.toString();
			System.out.println("Error executing data SQL: " + sError);
		}
	}

	//----------------------------------------------------------------------------
	// Gets the data required for the chars from the DB, and
	// creates the vectors and parameters required by the chartServer object
	//----------------------------------------------------------------------------
	private void CreateData(chartInfo c, DICountry countrybean)
	{
		double dmaximum;
		c.nSets = 1;
		c.nPoints = 10;

		String sSql = "";
		String sWhereSql = "";
		String grouper = "fechano"; // histogram grouper
		String subgrouper = "fechano"; // histogram grouper
		String sVariable = "1";
		Vector vGroups=null;
		Vector vRange=null;
		int iStart=0;
		int iEnd=0;
		// Declaration of default Dabatase variables available to the page
		boolean bConnectionOK = false;
		dbConnection dbCon = null;
		Connection con = null;

		ArrayList<String> sqlparams=new ArrayList<String>();
		PreparedStatement pstmt=null;

		// determine the period aggregator
		grouper = getPeriodGrouper(countrybean);
		// determine the season aggregator;
		subgrouper = getSeasonGrouper(c, countrybean);
		// now, get a connection to the database
		dbCon = new dbConnection(countrybean.country.sdriver, countrybean.country.sdatabasename,
				countrybean.country.susername, countrybean.country.spassword);
		bConnectionOK = dbCon.dbGetConnectionStatus();
		// continue if the database is available and ready
		if (bConnectionOK)
		{
			// Conexion OK!!, go and get the data..
			con = dbCon.dbGetConnection();
			countrybean.getLevelsFromDB(con);

			// create the required SQL for the specific graph. Using individual sums as to avoid issues with null numeric fields
			String sVar="sum(0.0+"+countrybean.sReplaceFormula(countrybean.sExtractVariable(countrybean.asVariables[0]));
			for (int k=1; k<countrybean.asVariables.length; k++)
				sVar+=")+sum(0.0+"+countrybean.sReplaceFormula(countrybean.sExtractVariable(countrybean.asVariables[k]));
			sVar+=")";
			String sSuffixLang="";
			if (countrybean.getDataLanguage().equals("EN"))
				sSuffixLang += "_en";
			switch (countrybean.nChartType)
			{
			case 0:
			case HISTOGRAM: //                  0-line
				sSql = "Select " +sVar  + " as n_sum," + grouper + " as grouper ";
				sSql += countrybean.getWhereSql(sqlparams) + " group by " + grouper;
				c.nSets = 1;
				break;
			case EVENT_HISTOGRAM: //                  1-bar,
				subgrouper = "nombre"+sSuffixLang;
				sSql = "Select " + sVar + " as n_sum, " + grouper + " as grouper,"+subgrouper+" as subgrouper ";
				sWhereSql = countrybean.getWhereSql(sqlparams);
				sSql += sWhereSql + " group by " + grouper + ","+subgrouper;
				vGroups = getSubGrouperVector(subgrouper, null /*countrybean.asEventos*/, c, countrybean, con, false);
				c.nSets=vGroups.size();
				break;
			case CAUSE_HISTOGRAM: //                  1-bar,
				subgrouper = "causas.causa"+sSuffixLang;
				sSql = "Select " + sVar + " as n_sum, " + grouper + " as grouper,"+subgrouper+" as subgrouper ";
				sSql += countrybean.getWhereSql(sqlparams) + " group by " + grouper + ","+subgrouper;
				vGroups = getSubGrouperVector(subgrouper,null /* countrybean.asCausas*/, c, countrybean, con, false);
				c.nSets=vGroups.size();
				break;
			case VARIABLE_HISTOGRAM: //                  1-bar,
				sSql = "Select " + countrybean.getSumList() + ", " + grouper + " as grouper ";
				sSql += countrybean.getWhereSql(sqlparams) + " group by " + grouper ;
				vGroups = getSubGrouperVector(subgrouper, countrybean.asVariables, c, countrybean, con, false);
				c.nSets=vGroups.size();
				break;
			case GEO_HISTOGRAM: //                  2-geographic histogram
				if (countrybean.bHayNivel2)
					subgrouper = countrybean.sqlConcat(countrybean.sqlConcat("level2","'-'"),"lev2_name"+sSuffixLang);
				else if (countrybean.bHayNivel1)
					subgrouper = countrybean.sqlConcat(countrybean.sqlConcat("level1","'-'"),"lev1_name"+sSuffixLang);
				else
					subgrouper = countrybean.sqlConcat(countrybean.sqlConcat("level0","'-'"),"lev0_name"+sSuffixLang);
				sSql = "Select " + sVar + " as n_sum, " + grouper + " as grouper," + subgrouper + " as subgrouper ";
				sSql += countrybean.getWhereSql(sqlparams) + " group by " + grouper + "," + subgrouper;
				vGroups = getSubGrouperVector(subgrouper, null , c, countrybean, con, false);
				c.nSets=vGroups.size();
				break;
			case SEASON_HISTOGRAM: //                  3-seasonal histogram
				sSql = "Select " + sVar + " as n_sum, " + subgrouper + " as grouper ";
				sSql += countrybean.getWhereSql(sqlparams) + " group by " + subgrouper+ " order by " + subgrouper;
				c.nSets = 1;
				iEnd=c.nPoints;
				break;
			case EVENT_COMPARISON: //                  4-comparative occasional
				grouper = "eventos.nombre"+sSuffixLang;
				sSql = "select * from (select " + sVar + " as n_sum, " + grouper + " as grouper ";
				sWhereSql = countrybean.getWhereSql(sqlparams);
				sSql += sWhereSql + "  group by " + grouper;
				sSql +=") qry where qry.n_sum>0 order by n_sum desc"; //grouper";
				vGroups = getSubGrouperVector(grouper, null /*countrybean.asEventos*/, c, countrybean, con, true);
				break;
			case GEO_COMPARISON: //                  4-comparative geographical
				if (countrybean.bHayNivel2)
					grouper = countrybean.sqlConcat(countrybean.sqlConcat("level2","'-'"),"lev2_name"+sSuffixLang);
				else if (countrybean.bHayNivel1)
					grouper = countrybean.sqlConcat(countrybean.sqlConcat("level1","'-'"),"lev1_name"+sSuffixLang);
				else
					grouper = countrybean.sqlConcat(countrybean.sqlConcat("level0","'-'"),"lev0_name"+sSuffixLang);
				sSql = "select * from (select " + sVar + " as n_sum, " + grouper + " as grouper ";
				sWhereSql = countrybean.getWhereSql(sqlparams);
				sSql += sWhereSql + " group by " + grouper;
				sSql +=") qry where qry.n_sum>0 order by n_sum desc"; //grouper";
				vGroups = getSubGrouperVector(grouper,null, c, countrybean, con, true);
				break;
			case CAUSE_COMPARISON: //                  4-comparative occasional
				grouper = "causas.causa"+sSuffixLang;
				sSql = "select * from (select " + sVar + " as n_sum, " + grouper + " as grouper ";
				sWhereSql = countrybean.getWhereSql(sqlparams);
				sSql += sWhereSql + "  group by " + grouper;
				sSql +=") qry where qry.n_sum>0 order by n_sum desc"; //grouper";
				vGroups = getSubGrouperVector(grouper, null /*countrybean.asCausas*/, c, countrybean, con, true);
				break;
			case DISTRIBUTION_HISTOGRAM:
				// create the required SQL for the specific graph.  
				sVar=countrybean.sReplaceFormula(countrybean.sExtractVariable(countrybean.asVariables[0]));
				for (int k=1; k<countrybean.asVariables.length; k++)
					sVar+="+"+countrybean.sReplaceFormula(countrybean.sExtractVariable(countrybean.asVariables[k]));
				sSql = "Select " +sVar  + " as n_sum " ;
				// TODO: THIS FAILED ON OSSO DATABASES WITH NULL IN NUMERIC FIELDS. Replaced with NVL(!!!, QC on all platforms needed
				sSql += countrybean.getWhereSql(sqlparams) + " and ("+countrybean.sqlNvl(sVar,0)+ ">0) order by "+sVar+" desc";
				c.nSets = 1;
				break;
			case LOSS_EXCEEDANCE_CURVE:
				// create the required SQL for the specific graph.  
				sVar=countrybean.sReplaceFormula(countrybean.sExtractVariable(countrybean.asVariables[0]));
				for (int k=1; k<countrybean.asVariables.length; k++)
					sVar+="+"+countrybean.sReplaceFormula(countrybean.sExtractVariable(countrybean.asVariables[k]));
				sSql = "Select sum(0.0+" +sVar  + ") as n_sum " ;
				// TODO: THIS FAILED ON OSSO DATABASES WITH NULL IN NUMERIC FIELDS. Replaced with NVL(!!!, QC on all platforms needed
				sSql += countrybean.getWhereSql(sqlparams) + " and ("+countrybean.sqlNvl(sVar,0)+ ">0) group by eventos.nombre_en,(fechano*10000+fechames*100+fechadia)";
				sSql="select * from ("+sSql+") xq order by n_sum desc";
				c.nSets = 1;
				break;
			}

			// System.out.println("Phase 1  completed.");
			// it must do some calculations to determine the precise # of points of histograms
			switch (countrybean.nChartType)
			{
			case 0:
			case HISTOGRAM: //                  0-line
			case EVENT_HISTOGRAM: //                  1-bar,
			case CAUSE_HISTOGRAM: //                  1-bar,
			case GEO_HISTOGRAM: //                  2-Pie,
			case VARIABLE_HISTOGRAM: //                  2-Pie,
				vRange=getRange(grouper, c, countrybean, con);
				iStart=((Integer) (vRange.elementAt(0))).intValue();
				iEnd=((Integer) (vRange.elementAt(1))).intValue();
				c.nPoints=iEnd-iStart+1;
				break;
			case SEASON_HISTOGRAM: //                  3-seasonal histogram
				break;
			case EVENT_COMPARISON: //                  4-comparative occasional
			case GEO_COMPARISON: //                  4-comparative geographical
			case CAUSE_COMPARISON: //                  4-comparative occasional
				c.nPoints=c.nSets;
				c.nSets = 1;
				break;
			case DISTRIBUTION_HISTOGRAM: //          
				c.dMaximumX=getMaximum(sVar, countrybean, con);
				c.nPoints=countrybean.nChartRanges;
				if (countrybean.nChartRanges>c.dMaximumX)
					c.nPoints=(int)c.dMaximumX+1;            // the +1 is for the zero values
				break;

			case LOSS_EXCEEDANCE_CURVE: //                  2-Pie,
				vRange=getRange("fechano", c, countrybean, con);
				c.nyears=((Integer) (vRange.elementAt(1))).intValue()-((Integer) (vRange.elementAt(0))).intValue();
				c.dMaximumX=getMaximum(sVar, countrybean, con);
				String sMax=String.valueOf((long)c.dMaximumX);
				c.dMaximumX=Math.pow(10,sMax.length()+1);
				c.nPoints=sMax.length()+1;
				break;
			}

			// debug:
			// System.out.println("SQL=" + sSql);
			// System.out.println("Total sets=" + c.nSets + " points=" + c.nPoints);

			// Got total number of points and sets, create empty vectors
			initVectors(c, countrybean, vGroups);
			int k=0;
			for (int j=iStart; j<iEnd; j++)
				c.x[k++]=j;
			// and finally, get the data from the database
			loadDataFromDB(c, countrybean, sSql, sqlparams, vGroups, iStart, con);
			dbCon.close();
		}
		else
		{
			c.nPoints = 10;
			// check total number of points and sets, and create empty vectors
			initVectors(c, countrybean, vGroups);
			// System.out.println("All points randomly initialized...");

		}

	}


	public void service(ServletRequest request, ServletResponse response) throws IOException
	{
		// Graphics context objects
		Graphics2D g2;
		Graphics g;

		ServletOutputStream out_stream = response.getOutputStream();

		// response.setContentType("image/jpg");
		response.setContentType("image/png");
		DICountry countrybean = null;
		chartInfo c = new chartInfo();

		// JSP/Servlet environment variables (required to get the beans...)
		JspFactory jspxFactory = null;
		PageContext pageContext = null;
		HttpSession session = null;
		ServletContext application = null;
		ServletConfig config = null;
		JspWriter out = null;
		Object page = this;
		String sError = null;

		jspxFactory = JspFactory.getDefaultFactory();
		pageContext = jspxFactory.getPageContext(this, request, response, "", true, 8192, true);
		application = pageContext.getServletContext();
		config = pageContext.getServletConfig();
		session = pageContext.getSession();
		synchronized (session)
		{
			countrybean = (DICountry) pageContext.getAttribute("countrybean", PageContext.SESSION_SCOPE);
			if (countrybean == null)
			{
				try
				{
					countrybean = new DICountry(); //(DICountry) java.beans.Beans.instantiate(this.getClass().getClassLoader(), "desinventar.DICountry");
				}
				catch (Exception exc)
				{
					sError = "throw new ServletException (Cannot create bean of class desinventar.DICountry)";
				}
				pageContext.setAttribute("countrybean", countrybean, PageContext.SESSION_SCOPE);
			}
		}


		if (request.getParameter("countrycode")!=null) // this is a standalone chart, wont mess with session bean.
		{
			// retain the interface and data language from the bean as default
			String sLng=countrybean.getLanguage();
			String sDLng=countrybean.getDataLanguage();
			countrybean = new DICountry();
			countrybean.countrycode=request.getParameter("countrycode");
			countrybean.setLanguage(sLng);
			countrybean.setDataLanguage(sDLng);
			// Load the country object from the DesInventar (default) database
			dbConnection dbDefaultCon; 
			Connection dcon; 
			boolean bdConnectionOK=false; 
			// opens the Default database 
			dbDefaultCon=new dbConnection();
			bdConnectionOK = dbDefaultCon.dbGetConnectionStatus();
			if (bdConnectionOK)
			{
				dcon=dbDefaultCon.dbGetConnection();
			}  // opening dB!!
			else
				return;

			countrybean.country.scountryid=countrybean.countrycode;
			countrybean.country.getWebObject(dcon);
			countrybean.countryname=countrybean.country.scountryname;
			countrybean.dbType=countrybean.country.ndbtype;
			// MUST return this connection!
			dbDefaultCon.close();
		}

		if (request.getParameter("bookmark")!=null)
			countrybean.processParams((HttpServletRequest) request,new parser(), null);

		boolean bCummulative= countrybean.nChartSubmode==2;
		countrybean.dbType=countrybean.country.ndbtype;
		CreateData(c, countrybean);

		// System.out.println("DI9: Starting chart generation...");
		try{
			ChartServer cs = new ChartServer(out_stream);
			cs.setDevice(countrybean.xresolution,countrybean.yresolution);

			c.dMaximumY=countrybean.dChartMaxX;
			c.dMaximumX=countrybean.dChartMaxX;
			cs.setVectors(c);
			// run a simple linear regression...
			for (int k=0; k<c.nSets; k++)
				cs.doRegression(k,k+c.nSets);     
			cs.setChartType(countrybean.nChartMode);
			cs.setTitle(" " + countrybean.sTitle);
			cs.setSubTitle(" " + countrybean.sSubTitle);
			cs.set3D(countrybean.b3D);
			cs.setBWColor(countrybean.bColorBW);
			cs.setCum(bCummulative);
			cs.paint(countrybean);
			//System.out.println("DI9: finished OK chart generation ...");    	
		}
		catch (Exception eChart)
		{
			System.out.println("DI9: exception during chart generation ..."+eChart.toString());    		
		}
		// ??? out_stream.flush();
		out_stream.close();
	}

}