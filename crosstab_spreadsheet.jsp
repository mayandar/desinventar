<%@ page info="DesConsultar generator results page" session="true" %><%@ page import="java.io.*"%><%@ page import="java.sql.*"%><%@ page import="java.text.*"%><%@ page import="org.lared.desinventar.util.*" %><jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" /><%@ include file="/util/opendatabase.jspf" %><%@ include file="/paramprocessor.jspf" %><%	
response.setContentType("application/vnd.ms-excel");
boolean bReportFormat=false;   // (request.getParameter("reportFormat")!=null);
String sSql=""; 
int j=0;  
stmt=con.createStatement ();
ArrayList vHorizontal=new ArrayList();
String sTemp=countrybean.asStatLevels[0];
String sTemp2=countrybean.asStatLevels[1];
countrybean.asStatLevels[0]=countrybean.asStatLevels[1];
//countrybean.asStatLevels[1]="";
sSql=countrybean.getStatSql();
try	{
	rset=stmt.executeQuery(sSql);
	while (rset.next())
		vHorizontal.add(htmlServer.not_null(rset.getString(1).trim()));			
	}
catch (Exception exst)
	{
	%><!-- <%=exst.toString()%> -->
	<%
	}
int nHorizontal=vHorizontal.size();
countrybean.asStatLevels[0]=sTemp;
countrybean.asStatLevels[1]=sTemp2;
sSql=countrybean.getStatSql();
try
	{
	String ants[]= new String[countrybean.nStatLevels];
	String sFechanoFechames="(fichas.fechano*13+fichas.fechames) as year_month";
	j=0;
	if (countrybean.asStatLevels[j].startsWith("lev0_name"))
		   		out.print(countrybean.asLevels[0]+"\t");
			else	
		   		if (countrybean.asStatLevels[j].startsWith("lev1_name"))
		   			out.print(countrybean.asLevels[1]+"\t");
			else	
	   			if (countrybean.asStatLevels[j].startsWith("lev2_name"))
		   			out.print(countrybean.asLevels[2]+"\t");
			else
				if (countrybean.asStatLevels[j].startsWith("eventos.nombre"))
	   			out.print(countrybean.getTranslation("Event")+"\t");
			else
				if (countrybean.asStatLevels[j].equals("fichas.fechano"))
	   			out.print(countrybean.getTranslation("Year")+"\t");
			else
				if (countrybean.asStatLevels[j].equals(sFechanoFechames))
	   			out.print(countrybean.getTranslation("Year")+" - "+countrybean.getTranslation("Month")+"\t");
			else
				if (countrybean.asStatLevels[j].equals("fichas.fechames"))
	   			out.print(countrybean.getTranslation("Month")+"\t");
			else
				if (countrybean.asStatLevels[j].startsWith("causas.causa"))
	   			out.print(countrybean.getTranslation("Cause")+"\t");
			  else
	   			out.print(countrybean.getColumnTitle(countrybean.asStatLevels[j])+"\t");
				
	int col=3; 
	if  (  (countrybean.asStatLevels[0].startsWith("lev0_name"))
		 ||(countrybean.asStatLevels[0].startsWith("lev1_name"))
		 ||(countrybean.asStatLevels[0].startsWith("lev2_name")) )
		col=4;
	int nColsPerVar=0;
	if (countrybean.bSum)
		nColsPerVar++;
	if (countrybean.bAvg)
		nColsPerVar++;
	if (countrybean.bMax)
		nColsPerVar++;
	if (countrybean.bVar)
		nColsPerVar++;
	if (countrybean.bStd)
		nColsPerVar++;
	
	rset=stmt.executeQuery(sSql); 
	/// gets the metadata of the resultset
	ResultSetMetaData meta = rset.getMetaData();
	int nCols=meta.getColumnCount();
	double totals[]= new double[nHorizontal*(nCols-col+1)+3];
	totals[0]=0;
	String sCell="";
	for (int k=0; k<nHorizontal; k++)
	  for (j=col; j<=nCols; j++)
  		{
		totals[k+j-col+1]=0;
		sSql=meta.getColumnName(j);
		sCell=(String)vHorizontal.get(k);
		out.print(sCell+" - "+countrybean.getColumnTitle(sSql)+"\t");
		}
    out.print("\n");
	NumberFormat f = NumberFormat.getInstance();
	f.setMaximumFractionDigits(2);
	f.setGroupingUsed(bReportFormat);
	String sLastRowId="";
	int iRowIndex=0;
	int iColIndex=1;
	while (rset.next())
		{
		sCell=htmlServer.not_null(rset.getString(1).trim());
		if (countrybean.asStatLevels[0].equals(sFechanoFechames))
		           {
				   int nYearMonth=htmlServer.extendedParseInt(sCell);		   
				   sCell= String.valueOf((int)(nYearMonth/13))+((nYearMonth%13>0)?("/"+(nYearMonth%13)):"");
				   }
		if (!sLastRowId.equals(sCell))
			{
			if (sLastRowId.length()>0)
				{
				for (int k=iRowIndex; k<nHorizontal; k++)
				     for (j=col; j<=nCols; j++)
						out.print("\t");
				out.print("\n");
				}
			out.print(sCell+"\t");
		  	sLastRowId=sCell;
			iRowIndex=0;
			iColIndex=0;
			}
		// fills empty columns !!
		sCell=htmlServer.not_null(rset.getString(2)).trim();
		while (iRowIndex<nHorizontal && !sCell.equals((String)vHorizontal.get(iRowIndex)))
		     {
	    	 for (j=col; j<=nCols; j++)
				{
				out.print("\t");
				iColIndex++;
				}
			 iRowIndex++;
			 }
	    for (j=col; j<=nCols; j++)
			{
            double nVal=rset.getDouble(j);
			totals[iColIndex]+=nVal;
			iColIndex++;
			String sNumber=f.format(nVal);
			if (sNumber.endsWith(".0"))
	  		    sNumber=sNumber.substring(0,sNumber.length()-2);
			out.print(sNumber+"\t");
			}
		iRowIndex++;
		}
	for (int k=iRowIndex; k<nHorizontal; k++)
	     for (j=col; j<=nCols; j++)
			out.print("\t");
	out.print("\n");
	out.print(countrybean.getTranslation("TOTAL")+"\t");
	for (j=0; j<nHorizontal*(nCols-col+1); j++)
		{
		boolean bOutput=true;
/*		sSql=meta.getColumnName(j);
		for (int k=0; k<countrybean.asVariables.length; k++)
			{
			String sTitSql=countrybean.getVartitle(countrybean.asVariables[k]);
			// only sum columns are rolled up - they make sense
			if (!sSql.equals(sTitSql)) // this must be divided by #datacards, not always available: || sSql.equals(countrybean.getTranslation("AverageOf")+" "+sTitSql))
			   bOutput=false;
			}
*/
		if (bOutput)
			{
			String sNumber=f.format(totals[j]);
			if (sNumber.endsWith(".0"))
			  sNumber=sNumber.substring(0,sNumber.length()-2);
			out.print(sNumber+"\t");
			}
		else
			out.print("\t");
		}
	rset.close();
	stmt.close();
	}
	catch (Exception exst)
	{
	%><!-- <%=exst.toString()%> --><%
	}
 out.print("\n");
 dbCon.close();
 %>
