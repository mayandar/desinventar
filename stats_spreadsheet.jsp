<%@ page info="DesConsultar generator results page" session="true" %><%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import="java.text.*"%><%@ page import="org.lared.desinventar.util.*" %><%@ page import="org.lared.desinventar.webobject.*" %><jsp:useBean id="countrybean" class="org.lared.desinventar.util.DICountry" scope="session" /><%@ include file="/util/opendatabase.jspf" %><%@ include file="/paramprocessor.jspf" %><%@ page import="java.util.ArrayList"%><%	
String sTime=String.valueOf(Calendar.getInstance().get(Calendar.MINUTE)+Calendar.getInstance().get(Calendar.HOUR)*100);
response.setContentType("application/vnd.ms-excel");
response.setHeader("Content-disposition", "attachment;filename=DI_Report"+sTime+".xls");
response.setHeader("Content-Type", "application/vnd.ms-excel; charset=utf-8");
boolean bReportFormat=false;   // (request.getParameter("reportFormat")!=null);
String sSql=""; 
int j=0;  
ArrayList sqlparams=new ArrayList();
PreparedStatement pstmt=null;

sSql=countrybean.getStatSql(sqlparams);
extension woExtension=new extension();
woExtension.dbType=countrybean.dbType;
woExtension.loadExtension(con,countrybean);
int col=countrybean.nStatLevels+1; 
try 
	{
	String ants[]= new String[countrybean.nStatLevels];
	String sFechanoFechames="(fechano*100+fechames) as year_month";
	String sFecha="(fechano*10000+fechames*100+fechadia) as DateYMD";
	for (j=0; j< countrybean.nStatLevels; j++)
  		{
		ants[j]="";
		if (countrybean.asStatLevels[j].startsWith("lev0_name"))
		   		{
		   		out.print(countrybean.asLevels[0]+"\t"+countrybean.getTranslation("Code")+"\t");
				col++;
				}
			else	
		   		if (countrybean.asStatLevels[j].startsWith("lev1_name"))
		   		{
		   		out.print(countrybean.asLevels[1]+"\t"+countrybean.getTranslation("Code")+"\t");
				col++;
				}
			else	
	   			if (countrybean.asStatLevels[j].startsWith("lev2_name"))
		   		{
		   		out.print(countrybean.asLevels[2]+"\t"+countrybean.getTranslation("Code")+"\t");
				col++;
				}
			else
				if (countrybean.asStatLevels[j].equals(sFechanoFechames))
   	   				out.print(countrybean.getTranslation("Year")+" - "+countrybean.getTranslation("Month")+"\t");
  		    else
	   			out.print(countrybean.getColumnTitle(countrybean.asStatLevels[j])+"\t");
		}
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
	
	try
		{
		pstmt=con.prepareStatement(sSql);
		for (int k=0; k<sqlparams.size(); k++)
					pstmt.setString(k+1, (String)sqlparams.get(k));
		rset=pstmt.executeQuery();
		}
	catch (Exception e)
		{
		System.out.println(e.toString());
		}	
	/// gets the metadata of the resultset
	ResultSetMetaData meta = rset.getMetaData();
	int nCols=meta.getColumnCount();
	double totals[]= new double[nCols+2];
	
	totals[0]=0;
	for (j=col; j<=nCols; j++)
  		{
		totals[j+1]=0;
		sSql=meta.getColumnName(j);
		out.print(countrybean.getColumnTitle(sSql)+"\t");
		}

out.println("");

	NumberFormat f = NumberFormat.getInstance();
	f.setMaximumFractionDigits(2);
	f.setGroupingUsed(bReportFormat);
	while (rset.next())
		{
		col=1;
		for (j=0; j< countrybean.nStatLevels; j++)
  			{
			String sCell=htmlServer.not_null(rset.getString(col)).trim();
			sSql=countrybean.sExtractVariable(countrybean.asStatLevels[j]);
			if (countrybean.asStatLevels[j].equals(sFechanoFechames))
		           {
				   sCell+="000000";
				   sCell= sCell.substring(0,4)+"/"+sCell.substring(4,6);
				   }
			else if (countrybean.asStatLevels[j].equals(sFecha))
		           {
				   sCell+="00000000";
				   sCell= sCell.substring(0,4)+"/"+sCell.substring(4,6)+"/"+sCell.substring(6,8);
				   }

			if (sSql.startsWith("extension."))
					sCell=woExtension.getValue(sSql.substring(10),htmlServer.not_null(sCell));
			if (!sCell.equals(ants[j]))
				{
				ants[j]=sCell;
				}
			else
				if (bReportFormat)
					sCell="";
			out.print(sCell+"\t");
			if (sSql.startsWith("lev0_name") || 
				sSql.startsWith("lev1_name") ||
				sSql.startsWith("lev2_name"))
				{
				col++;
				sCell=htmlServer.not_null(rset.getString(col));
				out.print(sCell+"\t");
				}
			col++;
			}
	    for (j=col; j<=nCols; j++)
			{
            double nVal=rset.getDouble(j);
			String sNumber=countrybean.formatDouble(nVal,-4); //f.format(nVal);
			if (sNumber.endsWith(".0"))
	  		    sNumber=sNumber.substring(0,sNumber.length()-2);
			out.print(sNumber+"\t");
			}
		out.println("");
		}
out.print(countrybean.getTranslation("TOTAL")+"\t");
for (j=1; j<col-1; j++)
	out.print("\t");

sSql="SELECT " + countrybean.getVariableList(true)+ countrybean.getWhereSql(sqlparams);
//sSql=sSql.substring(0,sSql.indexOf("group by"));
	try
		{
		pstmt=con.prepareStatement(sSql);
		for (int k=0; k<sqlparams.size(); k++)
					pstmt.setString(k+1, (String)sqlparams.get(k));
		rset=pstmt.executeQuery();
		}
	catch (Exception e)
		{
		System.out.println(e.toString());
		}	
//col=countrybean.nStatLevels; 
meta = rset.getMetaData();
nCols=meta.getColumnCount();
if (rset.next())
	{
    for (j=1; j<=nCols; j++)
		{
        double nVal=rset.getDouble(j);
		String sNumber=nVal==0.0?"":f.format(nVal);
		if (sNumber.endsWith(".0"))
  		    sNumber=sNumber.substring(0,sNumber.length()-2);
		out.print(sNumber+"\t");
		}
	}


out.println("");
try	{rset.close(); }catch (Exception e){out.println("<!-- closing r:"+e.toString()+" -->");}	
try	{pstmt.close();}catch (Exception e){out.println("<!-- closing ps:"+e.toString()+" -->");}	
}
catch (Exception exst)
{
%><!-- <%=exst.toString()%> --><%
}
out.println("");
 dbCon.close();
 %>