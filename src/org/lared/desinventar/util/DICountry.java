package org.lared.desinventar.util;

import javax.servlet.*;
import javax.servlet.http.*;
import java.text.SimpleDateFormat;
import java.util.*;
import java.io.*;
import java.net.URLDecoder;
import java.sql.*;
import java.awt.Color;

import org.lared.desinventar.util.*;
import org.lared.desinventar.map.MapObject;
import org.lared.desinventar.system.*;
import org.lared.desinventar.webobject.*;

public class DICountry extends webObject  implements Serializable 
{

  public String userHash=UUID.randomUUID().toString(); 

  public static final int QUERY=1;
  public static final int VIEWDATA=2;
  public static final int MAPS=3;
  public static final int CHARTS=4;
  public static final int STATISTICS=5;
  public static final int GENERATOR=6;
  public static final int THEMATIC=7;
  public static final int DoGENERATOR=8;
  public static final int DoSTATISTICS=9;
  public static final int DoCHARTS=10;
  public static final int DoTHEMATIC=11;
  public static final int DoCROSSTAB=12;
  public static final int SHOWDATACARD=13;

  
  public static final int MAPLAYERS=12;
  public static final int SELECTED=98;


  public country  country=new country();
  public int nAction = 0; // 0=view data 1=generator  2=stats 3=chart
  public int nStatLevels = 0;
  public String countrycode = "";
  public String countryname = "";
  public int nMaxhits=100;
  private String sLanguage="EN";      //SP->spanish; EN->English, use standard java locale
  private String sDataLanguage="EN";  //SP->local language (historically spanish...:-0); EN->English, use standard java locale

  public String sKeyWord="";
  
  public String logic = "AND";
  public String sortby = "0";

  public String sGlide="";

  public int nApproved=-1;

  public int fromyear = 0;
  public int frommonth = 0;
  public int fromday = 0;
  public int toyear = 0;
  public int tomonth = 0;
  public int today = 0;


  public boolean killed = false;
  public boolean injured = false;
  public boolean destroyedHouses = false;
  public boolean affectedHouses = false;
  public boolean victims = false;
  public boolean evacuated = false;
  public boolean affected = false;
  public boolean relocated = false;
  public boolean missing = false;

  public boolean roads = false;
  public boolean hectares = false;
  public boolean livestock = false;
  public boolean schools = false;
  public boolean hospitals = false;

  public boolean water = false;
  public boolean sewerage = false;
  public boolean education = false;
  public boolean power = false;
  public boolean industries = false;
  public boolean health = false;
  public boolean agriculture = false;
  public boolean transportation = false;
  public boolean communications = false;
  public boolean relief = false;
  public boolean other = false;

  public String asEventos[] = null;
  public String asNivel0[] = null;
  public String asNivel1[] = null;
  public String asNivel2[] = null;
  public String asVariables[] = null;
  public String asLevels[] = null;
  public int anLevelsLen[] = null;
  public String asCausas[] = null;
  public String asStatLevels[] = null;
  
  public String asChartMapVariables[]=null;
  public String asReportVariables[]=null;
  public String asStatisticsVariables[]=null;
  public String asCrosstabVariables[]=null;
  


  public boolean bHayEventos = false;
  public boolean bHayNivel0 = false;
  public boolean bHayNivel1 = false;
  public boolean bHayNivel2 = false;
  public boolean bHayVariables = false;
  public boolean bWereCauses = false;

  private HashMap<String,String> hOrderBy; // definition of sorts
  private HashMap hVariableList; // definition of Extended Datacard variable titles

  // view data
  public boolean bViewStandard=true;
  public boolean bViewExtended=false;
  public boolean bViewRawData=false;
  
  // chart variables
  public int nChartType = 1;    // type of chart: temporal histogram
  public int nChartMode = 1;    // mode of chart (pie, bar, line)  BAR
  public int nChartSubmode = 1; // normal, stacked, cummulative  NORMAL
  public int nPeriodType = 1;   // period for histograms
  public int nSeasonType = 4;   // season for seasonal histograms
  public boolean b3D = true;    // 3d effect on
  public String asChartColors[] = new String[15];  // colors for charts
  public String asChartBWs[] = new String[15];  // colors for charts
  // logartithmic scale
  public boolean bLogarithmicX=false;
  public boolean bLogarithmicY=false;
  public boolean bRegression=false;
  
  public boolean bColorBW=true;        // Color(true) or B/W
  public int xresolution = 800;
  public int yresolution = 600;
  public String sTitle="";
  public String sSubTitle="";
  public double dChartMaxX=0;
  public double dChartMaxY=0;

  public int nChartRanges=50;    // initial default
  
  // mapping variables
  public double asMapRanges[] = new double[15];
  public String asMapColors[] = new String[15];
  public String asMapLegends[] = new String[15];

  
  public int nShowIdType=0;      // 0=don't show id, 1=show names, 2=show codes
  public int nShowAllIdsType=0;  // 0=ALL, 1=only with values, 2=only selected
  public int nShowValueType=0;   // 0=don't show value, 1->show it, 2...?
  public int nMapType=0;         // 0=polyfill, 1=discs, 2=bars?
  public int level_rep=0;
  public int level_map=1;

  public int dissagregate_map=0; // 0=don't artificially disaggregate, 1=simple disaggregation, 2=weighted disaggregation
  public int dissagregate_var=0; // Future: variable for weighted disaggregation

  // Expert variables
  public String sExpertVariable="";
  public String sExpertWhere="";


  // statistical functions
  public boolean bSum=true;
  public boolean bMax=false;
  public boolean bAvg=false;
  public boolean bStd=false;
  public boolean bVar=false;
  public boolean bPer=true;
   
  
  // attribute tables levels 0-2
  public LevelAttributes[] laAttrs=new LevelAttributes[3];
    // External map levels 0-2
  public LevelMaps[] lmMaps=new LevelMaps[3];
    // External map layers
  public InfoMaps[] imLayerMaps;
  
  // Map decorations:
  public DrawingObject[] mapObjects=null;
  // Chart decorations:
  public DrawingObject[] chartObjects=null;
  // ranges for effects
  public String[] sMinEffect=new String[15];
  public String[] sMaxEffect=new String[15];
  public double[] sMinExtension;
  public double[] sMaxExtension;
  
  // transparency of maps/charts
  public float dTransparencyFactor=0.4f;
  
  // Loss Exceedance Curves variables
  public int groupingMethod=0;
  public int statisticsMethod=0;
  
  
  
  public HashMap htData =null;
  public MapObject htEvents =null;
  public transient VariableManager vmVmanager=new VariableManager();

  // Desinventar LANGUAGE MANAGEMENT:   
  // Language bundles:
  private  static HashMap htBundles = new HashMap();
  private  static HashMap englishBundle=null;

  private boolean bBundleLoaderHelper=loadEnglish();
  private HashMap bundle=englishBundle;
   
  // portlet management
  public boolean bPortletMode=false;

  private boolean loadEnglish()
  {
    try
    	{
     	if (englishBundle==null)
       		{
     		englishBundle = ResourceBundleLoader("org.lared.desinventar.DesInventar","EN");
     	   	htBundles.put("EN",englishBundle);
       		}
    	}
    catch (Exception ebundle)
    	{
      	System.out.println("[DI9] Error loading language resource bundle [EN - default]:"+ebundle.toString());    	
    	}
  	return true;
  }

  //-----------------------------------------------------------------------
  // Language Property (SP->spanish, EN->english, etc..)The language argument 
  // is a valid ISO Language Code. These codes are the lower-case, two-letter codes as defined by ISO-639. 
  // You can find a full list of these codes at a number of sites, such as: 
  // http://www.loc.gov/standards/iso639-2/englangn.html 
  //-----------------------------------------------------------------------
  public String getLanguage()
  {
    return sLanguage;
  }

  public String getDataLanguage()
  {
    return sDataLanguage;
  }

   

   /** 
    * Returns the name of the local directory based on the results of a call to getClassName() 
    * 
    * @param none 
    * @return Name of directory that contains the executing class 
    */ 
   public String getLocalDirName() 
   { 

      //Use that name to get a URL to the directory we are executing in 
      String localDirName; 
      //Open a URL to the class file 
      java.net.URL myURL = this.getClass().getResource("DICountry.class"); 

      //Clean up the URL and make a String with absolute path name 
      localDirName = myURL.getPath();  //Strip path to URL object out 
      localDirName = myURL.getPath().replaceAll("%20", " ");  //change %20 chars to spaces 


      //Get the current execution directory 
      localDirName = localDirName.substring(0,localDirName.lastIndexOf("/"));  //clean off the file name 


      return localDirName; 
   } 


   // this method can dynamically reload a bundle  (especially after it has been changed) 
   public HashMap ResourceBundleLoader(String sBundleName, String locale) 
   { 
       
	   String sLocalDirName=  getLocalDirName();
	   // removes the /util part.
	   sLocalDirName=sLocalDirName.substring(0,sLocalDirName.length()-4);
	   sLocalDirName+="DesInventar";
	   if (!locale.equals("EN"))
		   sLocalDirName+="_"+locale.toLowerCase();
	   sLocalDirName+=".properties";

	   HashMap rb=new HashMap();
	   try
	   	{
		   BufferedReader bfr= new BufferedReader(new InputStreamReader(new FileInputStream(sLocalDirName),"UTF-8"));

		   if (bfr!=null)
			   {
			   String sLine=bfr.readLine();
			   while (sLine!=null)
		   			{
				   	sLine=sLine.trim();
				   	if (sLine.length()>3)
					   if(sLine.charAt(0)!='#')
					   {
					   int pos=sLine.indexOf("=");
					   if (pos>0)
						   {
						   String sKey=sLine.substring(0,pos).trim();
						   String sValue=sLine.substring(pos+1).trim();
						   rb.put(sKey,sValue);
						   }
					   }
				    sLine=bfr.readLine();
		   			}
			   bfr.close();
			   }
	   	}
	   catch (Exception e)
	   {
		   System.out.println("error loading resource bundle...");
	   }
	   
       return rb;
   } 


  
   public void setLanguage(String sLang)
   {
       if (sLang.length()>2)
    	   sLang=sLang.substring(0,2);
       sLanguage=sLang;       
       // TODO:  build own UI for this
       //sDataLanguage=sLang;
       try
       	{
       	// looks for a loaded language bundle
       	bundle=(HashMap) htBundles.get(sLang);
       	// not loaded? get it...
       	if (bundle==null)
       		{
       		bundle = ResourceBundleLoader("org.lared.desinventar.DesInventar",sLang);
           	// is this language not implemented? revert to english
       		if (bundle==null)
       			bundle = ResourceBundleLoader("org.lared.desinventar.DesInventar", "EN");
       		htBundles.put(sLang,bundle);
       		}
       	}
      catch (Exception elang)
        {
      	System.out.println("Error loading language resource bundle ["+sLang+"]:"+elang.toString());
       }
   }

   public void setDataLanguage(String sLang)
   {
	   sDataLanguage=sLang;
       
   }

   public String getTranslation(String skey)
   {
   	String sRet=null;
   	try
   		{
   		sRet=(String) bundle.get(skey);
   		}
   	catch (Exception elang)	
   	   { /* nothing for now */}
   	if (sRet==null)
   	   	try
		{
   		sRet=(String) englishBundle.get(skey);
		}
	catch (Exception elang)	{ /* nothing for now */}
   	if (sRet==null)
   		return skey;
   	return sRet;
   }

//for development purposes only:
  public void reloadBundles()
  {
    htBundles = new HashMap(); 
    englishBundle = ResourceBundleLoader("org.lared.desinventar.DesInventar", "EN");
  	htBundles.put("EN",englishBundle);
  	setLanguage(sLanguage);
  }
  



  public DICountry()
  {
    hOrderBy = new HashMap<String,String>();
    hVariableList = new HashMap();
	
    init();
  }

  public boolean bInArray(String sCode, String[] aArray)
  {
  boolean bRet=false;
  if (aArray!=null)
  	for (int j=0; (j<aArray.length) && !bRet; j++)
     if (aArray[j]!=null && sCode.equals(aArray[j]))
    	bRet=true;
  return bRet;
  }


  //-----------------------------------------------------------------------
  // returns a variable name from an expression parameter that can be
  // of the form {variable}  or {variable as varname}
  //-----------------------------------------------------------------------
  public String sExtractVariable(String sVar)
  {
  int pos = sVar.lastIndexOf(" as ");
  String sRet=sVar;
  if (pos > 0)
    sRet= sVar.substring(0, pos);
  return sRet;
  }

  //-----------------------------------------------------------------------
  // returns the sql variable from an expresion of the form xxx as yyyy
  //-----------------------------------------------------------------------
  public String getVartitle(String xasy)
  {
    String sVartitle="";
    int pos=xasy.lastIndexOf(" as ");
    if (pos<0) 
    	pos=xasy.lastIndexOf(" AS ");
    if (pos>0)
      sVartitle=xasy.substring(pos+4);
    if (sVartitle.startsWith("\""))
        sVartitle=sVartitle.substring(1);
    if (sVartitle.length()>1 && sVartitle.endsWith("\""))
        sVartitle=sVartitle.substring(0,sVartitle.length()-1);
    if (sVartitle.length()==0)
    	{
    	if (vmVmanager==null)  // variable manager is transient. it may disappear on thin air...(on serialization of sessions...)
    		{
    		vmVmanager=new VariableManager();
    		vmVmanager.addCountryVariables(this);
    		} 	 
    	sVartitle=vmVmanager.getVarTitle(xasy);
    	if (sVartitle==null)
    		sVartitle=xasy;
    	}
	sVartitle=getTranslation(sVartitle);
    return sVartitle;
  }


//-----------------------------------------------------------------------
  // builds an Sql expresion to retrieve the user query / basic portion
  //-----------------------------------------------------------------------
  public String getColumnTitle(String sSqlVariable)
  {
	  HashMap<String,String> suffix=new HashMap<String,String>();
	  suffix.put("AVERAGEOF","AverageOf");
	  suffix.put("MAXOF","MaxOf");
	  suffix.put("VARIANCEOF","VarianceOf");
	  suffix.put("STDDEVOF","StdDevOf");

    String sRet="";
    // sSqlVariable=sSqlVariable.toUpperCase(); // postgres returns lowercase, oracle uppercase... unify... 
    if (sSqlVariable.toUpperCase().startsWith("C0L__"))
    	{
    	String sRetNum=sSqlVariable.substring(5);
    	String sPrefix="";
    	int pos=sRetNum.indexOf("_");
    	if (pos>0)
    		{
    		sPrefix=getTranslation(suffix.get(sRetNum.substring(pos+1).toUpperCase()));
    		sRetNum=sRetNum.substring(0,pos);
    		}
    	pos=extendedParseInt(sRetNum);
    	sRet=sPrefix+" "+getVartitle(asVariables[pos]);
    	}
    else
    	{
    	sRet=getVartitle(sSqlVariable);
    	}
    
    return sRet;
  }
  
  
  public String sReplaceFormula(String sVar)
  {
      if (sVar.equals("@formula@"))
      	sVar=sExpertVariable;
      if (sVar.length()==0)
    	  sVar="0";
      return sVar;
  }
  
  //-----------------------------------------------------------------------
  // builds an Sql expresion to retrieve the user query / basic portion
  //-----------------------------------------------------------------------
  public String getVariableList(boolean bDoSum)
  {
    int j, pos;
    String sSql = "";
    String sComma = "";
    String sVar = "";
    String sTit = "";
    
    bHayVariables = (asVariables!=null);

    if (bHayVariables)
      for (j = 0; j < asVariables.length; j++)
      {
        sVar = sExtractVariable(asVariables[j]);
        sVar = sReplaceFormula(sVar);
        sTit = "C0L__"+j;  // getVartitle(asVariables[j]);
        if (bDoSum) // creates something like sum(x) as y
        {
          if (bSum)
          {
           	if (sVar.startsWith("DA_"))  // TODO:  this has to be improved a LOT!!
            	sSql += sComma + "max(" + sVar+ ") as "+sTit;
           	else
           		sSql += sComma + "sum(0.0+" + sVar+ ") as "+sTit;
            sComma = ", ";
          }
          if (bAvg && !sVar.equals("1"))
          {
              // sSql += sComma + "avg(" + sVar+ ") as \"" + getTranslation("") + " "+ sTit+"\"";
         	  sSql += sComma + "avg(" + sVar+ ") as "+ sTit+"_AverageOf";
              sComma = ", ";
          }
          if (bMax && !sVar.equals("1"))
          {
              //sSql += sComma + "max(" + sVar+ ") as \"" + getTranslation("MaxOf") + " "+ sTit+"\"";
              sSql += sComma + "max(" + sVar+ ") as "+ sTit+"_MaxOf";
              sComma = ", ";
          }
          if (bVar && !sVar.equals("1"))
          {
              // sSql += sComma + sqlVariance(country.ndbtype) + sVar+ ") as \"" + getTranslation("VarianceOf") + " "+ sTit+"\"";
              sSql += sComma + sqlVariance() + sVar+ ") as "+ sTit+"_VarianceOf";
              sComma = ", ";
          }
          if (bStd && !sVar.equals("1"))
          {
              // sSql += sComma + sqlStddev(country.ndbtype) + sVar+ ") as \"" + getTranslation("StdDevOf") + " "+ sTit+"\"";
              sSql += sComma + sqlStddev() + sVar+ ") as "+ sTit+"_StdDevOf";
              sComma = ", ";
          }
        }
        else
            // sSql += sComma + asVariables[j];
        	sSql += sComma + sVar+ " as "+ sTit;
        sComma = ", ";
      }
    if (!bDoSum)
        sSql = "fichas.serial, fichas.clave"+ sComma + sSql;

    return sSql;
  }

  //-----------------------------------------------------------------------
  // builds an Sql expresion to retrieve the user query / basic portion
  //-----------------------------------------------------------------------
  public String getSumList()
  {
    int j;
    String sSql = "";
    String sComma = "";
    String sVar = "";
    String sTit = "";
    
    bHayVariables = (asVariables!=null);

    if (bHayVariables)
      for (j = 0; j < asVariables.length; j++)
      {
          sVar = sExtractVariable(asVariables[j]);
          sVar = sReplaceFormula(sVar);
          
          sTit = "C0L__"+j;  // getVartitle(asVariables[j]);
          sSql += sComma + "sum(0.0+" + sVar+ ") as "+sTit;
          sComma = ", ";
      }
    return sSql;
  }

  //-----------------------------------------------------------------------
  // builds an Sql expresion to retrieve the user query / basic portion
  //-----------------------------------------------------------------------
  public String getAggregateList()
  {
    int j;
    String sSql = "";
    String sComma = "";
    String sVar = "";
    
    bHayVariables = (asVariables!=null);

    if (bHayVariables)
      {
    	for (j = 0; j < asVariables.length; j++)
	      {
	          sVar = sExtractVariable(asVariables[j]);
	          sVar = sReplaceFormula(sVar);
	          sSql += sComma + sVar;
	          sComma = "+";
	      }
      }
    else
    	sSql="1";
    return sSql;
  }
 
  
  
  //--------------------------------------------------------------------------
  // returns a standard local Linguistic field  or return the English version
  //--------------------------------------------------------------------------
  public String getLocalOrEnglish(ResultSet rset, String strField, String strFieldEnglish)
  {
		String strParameter="";		
		try{
		    if (sDataLanguage.equals("EN"))
		    {
				strParameter=rset.getString(strFieldEnglish);
				if (strParameter == null)
					strParameter=rset.getString(strField);
			}
		    else 
		    	strParameter=rset.getString(strField);
		}
		catch (Exception e){}
	    return strParameter==null?"":strParameter;	  
  }

  
  public String getLocalOrEnglish(String strField, String strFieldEnglish)
  {
		return getLocalOrEnglish(strField, strFieldEnglish, sDataLanguage);
  }

  // please note this is a STATIC call.
  public static String getLocalOrEnglish(String strField, String strFieldEnglish, String sLanguage)
  {
		String strParameter="";		
		try{
		    if (sLanguage.equals("EN"))
		    {
				strParameter=strFieldEnglish;
				if (strParameter == null || strParameter.length()==0)
					strParameter=strField;
			}
		    else 
		    	strParameter=strField;
		}
		catch (Exception e){}
	    return strParameter==null?"":strParameter;	  
  }

  
  
  
  //------------------------------------------------------------------------
  // builds an Sql expresion to retrieve the user query / selections portion
  //------------------------------------------------------------------------
  public String getWhereSql(int approval, ArrayList<String> sqlparams)
  {
    String sSql = " (((((fichas left join eventos on eventos.nombre=fichas.evento)"+
			" left join lev0 on lev0.lev0_cod=fichas.level0)"+
			" left join lev1 on lev1.lev1_cod=fichas.level1)"+
			" left join lev2 on lev2.lev2_cod=fichas.level2)"+
			" left join causas on causas.causa=fichas.causa) "+
			" left join extension on fichas.clave = extension.clave_ext ";

    // restarts the list
    sqlparams.clear();
    
    for (int j=0; j<3; j++)
    	if (laAttrs[j]!=null && laAttrs[j].table_level==j && laAttrs[j].table_name.length()>0 && laAttrs[j].table_code.length()>0)
    		sSql="("+sSql+") left join "+laAttrs[j].table_name+ " DA_"+j+
    		               " on DA_"+j+"."+laAttrs[j].table_code+"=lev"+j+".lev"+j+"_cod";
    
    sSql= " from "+sSql+" where ";
    if (approval==0)  // only approved datacards
    	sSql+="fichas.approved=0";
    else if (approval==-1)  // ALL datacards
        sSql+="fichas.clave>0";
    else 
    	sSql+="fichas.approved="+approval;
    // String sSql = " from fichas,extension where fichas.clave = extension.clave_ext ";
    String sWhereAnd = " AND ";
    String sOr = "";
    String sLogic;
    int j;
    int fdesde, fhasta, fmes, fdia, fano;

    // adds EVENTOS to the where clause, if present
    if (bHayEventos)
    {
      sSql += sWhereAnd + "(fichas.Evento in (";
      for (j = 0; j < asEventos.length; j++)
      {
        sSql += (j>0?",?":"?");
        sqlparams.add(asEventos[j]);
      }
      sSql += "))";
    }

    // adds CAUSES to the where clause, if present
    sOr = "";
    if (bWereCauses)
    {
      sSql += sWhereAnd + "(fichas.Causa in (";
      for (j = 0; j < asCausas.length; j++)
      {
        sSql += (j>0?",?":"?");
        sqlparams.add(asCausas[j]);
      }
      sSql += "))";
    }

    // adds geography level 1 to the where clause, if present
    sOr = "";
    if (bHayNivel2)
    {
      sSql += sWhereAnd + "(fichas.level2 in (";
      for (j = 0; j < asNivel2.length; j++)
      {
        sSql += (j>0?",?":"?");
        sqlparams.add(asNivel2[j]);
      }
      sSql += "))";
      sWhereAnd = " AND ";
    }
    else
    {
      if (bHayNivel1)
      {
        sSql += sWhereAnd + "(fichas.level1 in (";
        for (j = 0; j < asNivel1.length; j++)
        {
          sSql += (j>0?",?":"?");
          sqlparams.add(asNivel1[j]);
        }
        sSql += "))";
        sWhereAnd = " AND ";
      }
      else
      {
        // adds geography level 0 to the where clause, if present,
        // and there is no level 1 selections
   	  sOr = "";
      if (bHayNivel0)
        {
          sSql += sWhereAnd + "(fichas.level0 in (";
          for (j = 0; j < asNivel0.length; j++)
          {
            sSql += sOr + "?";
            sqlparams.add(asNivel0[j]);
            sOr = ",";
          }
          sSql += "))";
          sWhereAnd = " AND ";
        }

      }
    }

    // adds the date constraint.  Mimics the exact logic of CS-DesConsultar
    fdesde = fromyear;
    if (fdesde > 0)
    {
      sSql += sWhereAnd + sqlDI_date(fromyear,frommonth,fromday)+"<="+sqlDI_date();
      sWhereAnd = " AND ";
    }

    fhasta = toyear;
    if (fhasta > 0)
    {
      fmes = tomonth;
      if (fmes == 0)
        fmes = 12;
      fdia = today;
      if (fdia == 0)
        fdia = 31;
     
      sSql += sWhereAnd + sqlDI_date(toyear,fmes,fdia)+" >= "+sqlDI_date();
          sWhereAnd = " AND ";
    }

    if (sGlide.length()>0)
    {
      sSql += sWhereAnd +" fichas.glide=?";
      sqlparams.add(sGlide);
      sWhereAnd = " AND ";
    }

    if (killed || injured || missing || destroyedHouses || affectedHouses || victims ||
        evacuated || affected || relocated || roads || hectares || livestock ||
        schools ||  hospitals ||  water || sewerage ||  education ||  power ||
        industries ||  health ||  agriculture ||  transportation ||  communications ||
        relief || other)
    {
      sOr = "";
      sSql += sWhereAnd + "(";
      sWhereAnd = " AND ";
      if (killed)
      {
        sSql += sOr + "((fichas.muertos>0)OR(fichas.hay_muertos<>0))";
        sOr = logic;
      }
      if (injured)
      {
        sSql += sOr + "((fichas.heridos>0)OR(fichas.hay_heridos<>0))";
        sOr = logic;
      }
      if (missing)
      {
        sSql += sOr + "((fichas.desaparece>0)OR(fichas.hay_deasparece<>0))";
        sOr = logic;
      }

      if (destroyedHouses)
      {
        sSql += sOr + "((fichas.vivdest>0)OR(fichas.hay_vivdest<>0))";
        sOr = logic;
      }
      if (affectedHouses)
      {
        sSql += sOr + "((fichas.vivafec>0)OR(fichas.hay_vivafec<>0))";
        sOr = logic;
      }
      if (victims)
      {
        sSql += sOr + "((fichas.damnificados>0)OR(fichas.hay_damnificados<>0))";
        sOr = logic;
      }
      if (evacuated)
      {
        sSql += sOr + "((fichas.evacuados>0)OR(fichas.hay_evacuados<>0))";
        sOr = logic;
      }
      if (affected)
      {
        sSql += sOr + "((fichas.afectados>0)OR(fichas.hay_afectados<>0))";
        sOr = logic;
      }
      if (relocated)
      {
        sSql += sOr + "((fichas.reubicados>0)OR(fichas.hay_reubicados<>0))";
        sOr = logic;
      }
      if (roads)
      {
        sSql += sOr + "(fichas.kmvias>0)";
        sOr = logic;
      }
      if (schools)
      {
        sSql += sOr + "(fichas.nescuelas>0)";
        sOr = logic;
      }
      if (health)
      {
        sSql += sOr + "(fichas.nhospitales>0)";
        sOr = logic;
      }
      if (hectares)
      {
        sSql += sOr + "(fichas.nhectareas>0)";
        sOr = logic;
      }
      if (livestock)
      {
        sSql += sOr + "(fichas.cabezas>0)";
        sOr = logic;
      }

      if (transportation)
      {
        sSql += sOr + "((fichas.kmvias>0)OR(fichas.transporte<>0))";
        sOr = logic;
      }
      if (education)
      {
        sSql += sOr + "((fichas.nescuelas>0)OR(fichas.educacion<>0))";
        sOr = logic;
      }
      if (health)
      {
        sSql += sOr + "((fichas.nhospitales>0)OR(fichas.salud<>0))";
        sOr = logic;
      }
      if (agriculture)
      {
        sSql += sOr + "((fichas.nhectareas>0)OR(fichas.agropecuario<>0)OR(fichas.cabezas>0))";
        sOr = logic;
      }
      if (water)
      {
        sSql += sOr + "(fichas.acueducto<>0)";
        sOr = logic;
      }

      if (sewerage)
      {
        sSql += sOr + "(fichas.alcantarillado<>0)";
        sOr = logic;
      }
      if (power)
      {
        sSql += sOr + "(fichas.energia<>0)";
        sOr = logic;
      }
      if (industries)
      {
        sSql += sOr + "(fichas.industrias<>0)";
        sOr = logic;
      }
      if (relief)
      {
        sSql += sOr + "(fichas.socorro<>0)";
        sOr = logic;
      }
      if (communications)
      {
        sSql += sOr + "(fichas.comunicaciones<>0)";
        sOr = logic;
      }
      if (other)
      {
        sSql += sOr + "(fichas.hay_otros<>0)";
        sOr = logic;
      }
      sSql += ")";
    }
    String sEffects[]={"fichas.muertos","fichas.heridos","fichas.vivdest","fichas.vivafec","fichas.damnificados","fichas.afectados",
            "fichas.evacuados","fichas.reubicados","fichas.nhospitales","fichas.desaparece",
            "fichas.kmvias","fichas.nhectareas","fichas.cabezas","fichas.nescuelas"};
    String sSubSql="";
    sOr = "";
    for (j=0; j<14; j++)
      {
    	  if (not_null(sMinEffect[j]).length()>0 && not_null(sMaxEffect[j]).length()>0)
    	  {
    		  sSubSql += sOr + "("+sEffects[j]+" between "+sMinEffect[j]+" and "+sMaxEffect[j]+")";
    	      sOr = logic;    		  
    	  }
    	  else if (not_null(sMinEffect[j]).length()>0)
    	  {
    		sSubSql += sOr + "("+sEffects[j]+">="+sMinEffect[j]+")";
	        sOr = logic;    		  
    	  }
       	  else if (not_null(sMaxEffect[j]).length()>0)
    	  {
       		sSubSql += sOr + "("+sEffects[j]+"<="+sMaxEffect[j]+")";
    	    sOr = logic;    		  
    	  }
      }

    if (sSubSql.length()>0)
    	sSql+= sWhereAnd +"("+sSubSql+")";
  
    // adds keywordsearch to the where clause, if present
    sKeyWord = sKeyWord.trim();
    if (sKeyWord.length() > 1)
    {
      sOr = "";
      StringTokenizer stTokSource = new StringTokenizer(sKeyWord, " .;:/\\!][{}()*&^$#@!,\"|+-?'~`");
      sSql += sWhereAnd + "(";
      while (stTokSource.hasMoreTokens())
      {
        String sTok = stTokSource.nextToken().toUpperCase();
        String sOper="=";
        String sEqual="=";
        if (sTok.indexOf("%")>=0)
        	{
        	sOper=" like ";
        	sEqual=" in ";
        	}
        sSql += sOr + "  fichas.clave in (select docid from wordsdocs where wordid"+sEqual+"(select wordid from words where word"+sOper+ "?)) ";
        sqlparams.add(sTok);
        sOr = logic;
      }
      sSql += ")";
      sWhereAnd = " AND ";
    }
    
    // adds the user-defined where clause
    if (sExpertWhere.length()>0)
    	sSql+=" AND ("+sExpertWhere+") ";
    return sSql;
  }


  public String getWhereSql(ArrayList<String> sqlparams)
  {
	return  getWhereSql(0, sqlparams);
  }
  

  
  //------------------------------------------------------------------------
  // builds an Sql expresion to retrieve the user query / main
  //------------------------------------------------------------------------
  public String getSql(boolean bReport , ArrayList<String> sqlparams)
  {
    String sSql;
    boolean bNoSum = false;
    // basic SQL
    if (bReport)
      sSql = "Select " + getVariableList(bNoSum);
    else
      sSql = "Select * ";

      // selections made
    sSql += getWhereSql(sqlparams);

    // order of report
    if (sortby != null)
      if (sortby.length() > 0)
        sSql += " order by " + hOrderBy.get(sortby);
    return sSql;
  }

  
  
  
  public String getSql(ArrayList<String> sqlparams)
  {
    return getSql(false, sqlparams);
  }
  
  
    
  public String getSortbySql()
  {
    String sSql="clave desc";
  	// order of report
    if (sortby != null)
      if (sortby.length() > 0)
        sSql = (String) hOrderBy.get(sortby);
    return sSql;

  }
  
  //------------------------------------------------------------------------
  // builds an Sql expresion to evaluate the user statistics
  //------------------------------------------------------------------------
  public String getStatSql(ArrayList<String> sqlparams)
  {
    String sSql = "SELECT ";
    String sSqlGroup = "";
    boolean bDoSum = true;
    String sComma = "";
    int j;

    // basic SQL
    sSqlGroup = "";
    sComma = "";
    for (j = 0; j < nStatLevels; j++)
    {
      sSqlGroup += sComma + sReplaceFormula(asStatLevels[j]);
      sComma = ", ";
    }

    sSql += sSqlGroup + "," + getVariableList(bDoSum);

    // selections made
    sSql += getWhereSql(sqlparams);

    // order of report. Here we want the only the variables, not the AS xxxx   part.
    sSqlGroup = "";
    sComma = "";
    for (j = 0; j < nStatLevels; j++)
    {
      sSqlGroup += sComma + sReplaceFormula(sExtractVariable(asStatLevels[j]));
      sComma = ",";
    }
    sSql += " group by " + sSqlGroup + " order by " + sSqlGroup;

    return sSql;
  }

  //------------------------------------------------------------------------
  // builds an Sql expresion to evaluate the user statistics
  //------------------------------------------------------------------------
  public String getCrosstabSql(ArrayList<String> sqlparams)
  {
    String sSql = "SELECT ";
    String sSqlGroup = "";
    boolean bDoSum = true;
    String sComma = "";
    int j;

    // basic SQL
    for (j = 0; j < nStatLevels; j++)
    {
      sSqlGroup += sComma + sReplaceFormula(asStatLevels[j]);
      sComma = ", ";
    }
    sSql += sSqlGroup + "," + getVariableList(bDoSum);

    // selections made
    sSql += getWhereSql(sqlparams);

    sSqlGroup = "";
    sComma = "";
    for (j = 0; j < nStatLevels; j++)
    {
      sSqlGroup += sComma + sReplaceFormula(sExtractVariable(asStatLevels[j]));
      sComma = ",";
    }
    // order of report
    sSql += " group by " + sSqlGroup + " order by " + sSqlGroup;

    return sSql;
  }

  //-----------------------------------------------------------------------
  // loads the names of the geographic levels into a vector
  //-----------------------------------------------------------------------
  public void getLevelsFromDB(Connection con)
  {
    Statement stmt=null;
    ResultSet rset=null;
    int i = 0;

    try
    {
      stmt = con.createStatement ();
      // load level names
      rset = stmt.executeQuery("Select descripcion,descripcion_en, longitud from niveles order by nivel");
      while ( (i < 3) && rset.next())
      {
        asLevels[i] = getLocalOrEnglish(rset,"descripcion","descripcion_en");
        anLevelsLen[i] =rset.getInt("longitud");
        if (asLevels[i].length()==0)
        	asLevels[i]=getTranslation("Level")+" "+i;
        i++;
      }
    }
    catch (Exception e)
    {
    	String err=e.toString();
    	System.out.println("Err loading levels, country "+this.countrycode+": "+err);
    }

    try {
    	
      // load (if they exist) the map associated to each level
      rset = stmt.executeQuery("Select * from level_maps order by map_level");
      while ( rset.next())
      {
    	  LevelMaps lmLevMap=new LevelMaps();
    	  lmLevMap.loadWebObject(rset);
    	  i=lmLevMap.map_level;
    	  lmMaps[i]=lmLevMap;
    	  lmMaps[i].projection_system=1; // visible
      }
      
    }
    catch (Exception e)
    {
    	String err=e.toString();
    	System.out.println("Err loading level maps, country "+this.countrycode+": "+err);
    }
    try {
      // load (if they exist) the attribute table associated to each level
      rset = stmt.executeQuery("Select * from level_attributes order by table_level");
      while ( rset.next())
      {
    	  LevelAttributes lmLevAttr=new LevelAttributes();
    	  lmLevAttr.loadWebObject(rset);
    	  i=lmLevAttr.table_level;
    	  laAttrs[i]=lmLevAttr;
      }
    }
    catch (Exception e)
    {
    	String err=e.toString();
    	System.out.println("Err loading level attributes, country "+this.countrycode+": "+err);
    }
    try {

      // load (if they exist) map layers NOT associated to levels- informational layers
      rset = stmt.executeQuery("Select count(*) as nmaps from info_maps");
      int nMaps=0;
      if ( rset.next())
        nMaps=rset.getInt(1);
      if (nMaps>0){
    	  imLayerMaps=new InfoMaps[nMaps+1];
    	  rset = stmt.executeQuery("Select * from info_maps order by layer");
          i=0;
          while ( rset.next())
          {
        	  InfoMaps lmLevMap=new InfoMaps();
        	  lmLevMap.loadWebObject(rset);
        	  imLayerMaps[i]=lmLevMap;
        	  i++;
          }  
      }

      stmt.close();
      // rset.close();
    }
    catch (Exception e)
    {
    	String err=e.toString();
    	System.out.println("Err loading level info maps, country "+this.countrycode+": "+err);
    }
  }

  //-----------------------------------------------------------------------
  // loads the names of the geographic levels into a vector
  //-----------------------------------------------------------------------
  public void getExtendedDefinition(Connection con)
  {
    int i = 0;
    try
    {
      hVariableList = new HashMap();
      String sDescription;
      stmt = con.createStatement ();
      rset = stmt.executeQuery("Select orden,nombre_campo,descripcion_campo,label_campo,label_campo_en,pos_x,pos_y,lon_x,lon_y,color  from diccionario"); // definici�n de la ficha extendida
      while (rset.next())
      {
        diccionario dExtended = new diccionario();
        dExtended.loadWebObject(rset);
        if (dExtended.descripcion_campo.length() == 0)
          dExtended.descripcion_campo = dExtended.nombre_campo;
        if (dExtended.nombre_campo.length() > 0)
        {
          hVariableList.put(dExtended.nombre_campo, dExtended);
        }
      }
      rset.close();
      stmt.close();
    }
    catch (Exception e)
    {
    }
  }



  //-----------------------------------------------------------------------
  // loads the variables selection box into saVariables vector
  //-----------------------------------------------------------------------
  public void loadVariables(ServletRequest req, String sVarName)
	  {
      asVariables = loadArrayParameter((HttpServletRequest)req, sVarName);
      bHayVariables = (asVariables!=null);
     }

  public void loadVariables(ServletRequest req)
  {
	  loadVariables(req, "variables");
  }
  
  public void loadVariables(HttpServletRequest req)
  {
    loadVariables((ServletRequest) req);
  }

  public void loadVariables(String[] sourceArray)
  {
	  if (sourceArray==null)
		  asVariables = null;
	  else{
		  int nvars=sourceArray.length;
		  asVariables=new String[nvars];
		  for (int j=0; j<nvars; j++)
			  asVariables[j]=new String(sourceArray[j]);
	  }
    bHayVariables = (asVariables != null);
  }

  public void loadStatVariables(String[] sourceArray)
  {
	  if (sourceArray==null)
		  asStatisticsVariables = null;
	  else{
		  int nvars=sourceArray.length;
		  asStatisticsVariables=new String[nvars];
		  for (int j=0; j<nvars; j++)
			  asStatisticsVariables[j]=new String(sourceArray[j]);
	  }
  }

  public void loadReportVariables(String[] sourceArray)
  {
	  if (sourceArray==null)
		  asReportVariables = null;
	  else{
		  int nvars=sourceArray.length;
		  asReportVariables=new String[nvars];
		  for (int j=0; j<nvars; j++)
			  asReportVariables[j]=new String(sourceArray[j]);
	  }
  }

  public void loadChartMapVariables(String[] sourceArray)
  {
	  if (sourceArray==null)
		  asChartMapVariables = null;
	  else{
		  int nvars=sourceArray.length;
		  asChartMapVariables=new String[nvars];
		  for (int j=0; j<nvars; j++)
			  asChartMapVariables[j]=new String(sourceArray[j]);
	  }
  }

  
  //-----------------------------------------------------------------------
  // loads the Statistics selections
  //-----------------------------------------------------------------------
  public void loadStatLevels(HttpServletRequest req)
  {

  	
  	nStatLevels = 0;
    // Stat levels vector
    if (asStatLevels==null)
    	asStatLevels = new String[3];
	asStatLevels[0] = "evento";
	asStatLevels[1] = "";
	asStatLevels[2] = "";
	nStatLevels = 1;
 
    if (req.getParameter("stat0") != null)
    {
      asStatLevels[0] = not_null_safe(req.getParameter("stat0"));
      nStatLevels = 1;
      if (req.getParameter("stat1") != null)
      {
        asStatLevels[1] = not_null_safe(req.getParameter("stat1"));
        nStatLevels = 2;
        if (req.getParameter("stat2") != null)
        {
          asStatLevels[2] = not_null_safe(req.getParameter("stat2"));
          nStatLevels = 3;
        }
      }
    }
    else if (req.getParameter("_stat") != null) // from bookmark
    	{
    	asStatLevels=loadArrayParameter(req, "stat");
    	nStatLevels = extendedParseInt(req.getParameter("nlevels"));
    	}
    
    bSum=strToBool(req.getParameter("bSum"));
    bMax=strToBool(req.getParameter("bMax"));
    bAvg=strToBool(req.getParameter("bAvg"));
    bStd=strToBool(req.getParameter("bStd"));
    bVar=strToBool(req.getParameter("bVar"));
    // at least one column
    if (!bSum && !bMax && !bAvg && !bStd && !bVar)
    	bSum=true;
   
  }
  
  public String[] parseList1(String sList)
  {
  	String[] sRet=null;
  	if (sList!=null)
  	{
  		sList=sList.replace("@", "%");
  		try{
  			sList=URLDecoder.decode(sList, "UTF-8");
  		}
  		catch (Exception e)
  		{
  			// do nothing for now...
  		}
  		StringTokenizer st=new StringTokenizer(sList,"," , true);
  		ArrayList<String> al = new ArrayList<String>();
  		String sLast="";
  		while (st.hasMoreTokens())
  		{
  			String stk=st.nextToken();
  			if (",".equals(stk))
  			{
				if (sLast.equals(","))
						al.add("");					 				
  			}
  			else {
  					al.add(stk);
  		  		}
  			sLast=stk;
  		}
		if (sLast.equals(","))
			al.add("");					 				
  		sRet=new String[al.size()];
  		for (int j=0; j<al.size(); j++)
  			sRet[j]=(String)al.get(j);
  	} 	
  	return sRet;
  }

  
  public String[] parseList(String sList)
  {
  	String[] sRet=null;
  	if (sList!=null)
  	{
  		sList=sList.replace("@", "%");
  		try{
  			sList=URLDecoder.decode(sList, "UTF-8");
  		}
  		catch (Exception e)
  		{
  			// do nothing for now...
  		}
  		StringTokenizer st=new StringTokenizer(sList,",()", true);
  		ArrayList al = new ArrayList();
  		int nLev=0;
  		String sCompound="";
  		String sLast="";
  		while (st.hasMoreTokens())
  		{
  			String stk=st.nextToken();
  			if("(".equals(stk))
  			{
  				if (nLev==0)
  					sCompound="";
  				sCompound+=stk;
  				nLev++;
  			}
  			else if(")".equals(stk))
  			{
  				sCompound+=stk;
  				nLev--;
  			}
  			else if (",".equals(stk))
  			{
				if (nLev>0)
  		  				sCompound+=stk;
				else 
					if (sLast.equals(","))
						al.add("");
					 				
  			}
  			else {
  					if (nLev>0)
  		  				sCompound+=stk;
  					else
  						{
  						al.add(sCompound+stk);
  	  					sCompound="";
  						}
  		  		}
  			sLast=stk;
  		}
		if (sLast.equals(","))
			al.add("");
  		sRet=new String[al.size()];
  		for (int j=0; j<al.size(); j++)
  			sRet[j]=(String)al.get(j);
  	}
  	
  	return sRet;
  }


  public String[] loadArrayParameter(HttpServletRequest req, String sName)
  {
	    String [] asArray = null;
	    if (req.getParameterValues(sName) != null)
	    	asArray = req.getParameterValues(sName);
	    else
	    	if (req.getParameter("_"+sName) != null)
	    		      asArray = parseList(req.getParameter("_"+sName));
	    // html encode all parameters
	    if (asArray!=null)
	    	for (int j=0; j<asArray.length; j++)
	    		if (asArray[j].indexOf(") as DateYMD")<0)     // this variable cannot be htmlEncoded. 
	    			asArray[j]=not_null_safe(asArray[j]);
	    return asArray;
	  
  }
/**
 * 
 * loads main page's multiple selection boxes into vectors
 */
  public void loadVectors(HttpServletRequest req)
  {
    asEventos = loadArrayParameter(req, "eventos");
    bHayEventos = (asEventos!=null);

    asNivel0 = loadArrayParameter(req, "level0");
    bHayNivel0 = (asNivel0!=null);

    asNivel1 = loadArrayParameter(req, "level1");
    bHayNivel1 = (asNivel1!=null);

    asNivel2 = loadArrayParameter(req, "level2");
    bHayNivel2 = (asNivel2!=null);

    asCausas = loadArrayParameter(req, "causas");
    bWereCauses = (asCausas!=null);

    // guarantees a numeric value here, or ""
    String [] sMins= loadArrayParameter(req, "sMinEffect");
    if (sMins!=null)
     for (int j=0; j< sMinEffect.length; j++)
    	{
    	 sMinEffect[j]="";
    	 if (sMins.length>j)
     		{
    		 if (not_null(sMins[j]).length()>0)
    			 sMinEffect[j]=String.valueOf(extendedParseDouble(sMins[j]));
     		}
    	}

    sMins= loadArrayParameter(req, "sMaxEffect");
    if (sMins!=null)
     for (int j=0; j< sMaxEffect.length; j++)
    	{
    	 sMaxEffect[j]="";
    	 if (sMins.length>j)
    		 if (not_null(sMins[j]).length()>0)
    			 sMaxEffect[j]=String.valueOf(extendedParseDouble(sMins[j]));
    	}

    
    nMaxhits=Math.max(10,extendedParseInt(req.getParameter("maxhits")));
    sKeyWord=not_null_safe(req.getParameter("sKeyWord"));
    fromyear = extendedParseInt(req.getParameter("fromyear"));
    frommonth = extendedParseInt(req.getParameter("frommonth"));
    fromday = extendedParseInt(req.getParameter("fromday"));
    toyear = extendedParseInt(req.getParameter("toyear"));
    tomonth = extendedParseInt(req.getParameter("tomonth"));
    today = extendedParseInt(req.getParameter("today"));
    killed=strToBool(req.getParameter("muertos"));
    injured=strToBool(req.getParameter("heridos"));
    missing=strToBool(req.getParameter("desaparece"));
    destroyedHouses=strToBool(req.getParameter("vivdestruidas"));
    affectedHouses=strToBool(req.getParameter("vivafectadas"));
    victims=strToBool(req.getParameter("damnificados"));
    evacuated=strToBool(req.getParameter("evacuados"));
    affected=strToBool(req.getParameter("afectados"));
    relocated=strToBool(req.getParameter("reubicados"));
    sGlide = webObject.not_null_safe(req.getParameter("glide"));
    roads=strToBool(req.getParameter("roads"));
    hectares=strToBool(req.getParameter("hectares"));
    livestock=strToBool(req.getParameter("livestock"));
    schools=strToBool(req.getParameter("schools"));
    hospitals=strToBool(req.getParameter("hospitals"));
    water=strToBool(req.getParameter("water"));
    sewerage=strToBool(req.getParameter("sewerage"));
    education=strToBool(req.getParameter("education"));
    power=strToBool(req.getParameter("power"));
    industries=strToBool(req.getParameter("industries"));
    health=strToBool(req.getParameter("health"));
    agriculture=strToBool(req.getParameter("agriculture"));
    transportation=strToBool(req.getParameter("transportation"));
    communications=strToBool(req.getParameter("communications"));
    relief=strToBool(req.getParameter("relief"));
    other=strToBool(req.getParameter("other"));
    //sExpertWhere=not_null_safe(req.getParameter("sExpertWhere"));
    logic = not_null(req.getParameter("logic")).toUpperCase()+" ";   
    if (logic.charAt(0)=='O')
      logic="OR";
    else
      logic="AND";	
    sortby = not_null_safe(req.getParameter("sortby"));
    if (sortby.length()==0)
        sortby="0";
    if (sortby.length()>32)  // it must be a hacker..
        sortby="0";

    nApproved=extendedParseInt(req.getParameter("nApproved"));


    /* FUTURE, When keywords/full text search are enabled
    sFtoption=webObject.not_null_safe(req.getParameter("ftoption"));
    if (sFtoption.length()==0)
      sFtoption="&";
   */
  }


  /** loads map parameters from the request
   *
   */
  public void getMapParameters(ServletRequest request)
  {
     // mapping variables
     loadVariables(request);
     if (request.getParameter("bookmark")==null)
	     for (int j=0; j<9; j++)
	       {
	         asMapRanges[j] = extendedParseDouble(request.getParameter("range_"+j));
	         asMapColors[j] = not_null_safe(request.getParameter("color_"+j));
	         asMapLegends[j] =not_null_safe(request.getParameter("legend_"+j));;
	       }
     else
     {
         String asRanges[] = loadArrayParameter((HttpServletRequest)request,"range");
         for (int j=0; j<9; j++)
        	 asMapRanges[j]=extendedParseDouble(asRanges[j]);
         asMapColors = loadArrayParameter((HttpServletRequest)request,"color");
         asMapLegends= loadArrayParameter((HttpServletRequest)request,"legend");
       }
    	 
     nShowIdType=extendedParseInt(request.getParameter("idType"));      // 0=don't show id, 1=show names, 2=show codes
     nShowAllIdsType=extendedParseInt(request.getParameter("idType"));  // 0=ALL, 1=only with values, 2=only selected
     nShowValueType=extendedParseInt(request.getParameter("showValues"));   // 0=don't show value, 1->show it, 2...?
     nMapType=extendedParseInt(request.getParameter("legendType"));    // 0=polyfill, 1=discs, 2=bars?
     bColorBW= not_null_safe(request.getParameter("chartColor")).equals("1");
     sTitle=not_null_safe(request.getParameter("chartTitle"));
     sSubTitle=not_null_safe(request.getParameter("chartSubTitle"));
     level_rep=extendedParseInt(request.getParameter("level_rep"));
     level_map=extendedParseInt(request.getParameter("level_map")); 
	 dissagregate_map=extendedParseInt(request.getParameter("dissagregate_map")); 
     xresolution=Math.min(3000,Math.max(80,htmlServer.extendedParseInt(request.getParameter("chartX"))));
	 yresolution=Math.min(3000,Math.max(80,htmlServer.extendedParseInt(request.getParameter("chartY"))));
	 String sTransparencyFactor=not_null_safe(request.getParameter("transparencyf"));
	 float dTransp=(float)extendedParseDouble(sTransparencyFactor);
	    if (dTransp>0.05f)
	    	dTransparencyFactor=dTransp;
	    

  }



  //-----------------------------------------------------------------------
  // loads the multiple selection boxes into vectors
  //-----------------------------------------------------------------------
  public String sFormatDate(String y, String m, String d)
  {
    if (m == null)
      m = "--";
    else
    if (m.equals("0"))
      m = "--";
    if (m.length() == 1)
      m = "0" + m;
    if (y == null)
      y = "----";
    else
    if (y.equals("0"))
      y = "--";

    if (d == null)
      d = "--";
    else
    if (d.equals("0"))
      d = "--";
    if (d.length() == 1)
      d = "0" + d;
    return y + "/" + m + "/" + d;
  }


  //-----------------------------------------------------------------------
  // Sortby Property (year of starting date)
  //-----------------------------------------------------------------------
  public String getSortby()
  {
    return sortby;
  }

  public void setSortby(String sSortBy)
  {
    sortby = sSortBy;
  }

  //-----------------------------------------------------------------------
  // maxhits Property (year of starting date)
  //-----------------------------------------------------------------------
  public String getMaxhits()
  {
    return Integer.toString(nMaxhits);
  }

  public void setMaxhits(String strMaxhits)
  {
    nMaxhits = htmlServer.extendedParseInt(strMaxhits);
  }


  //-----------------------------------------------------------------------
  // From Year Property (year of starting date)
  //-----------------------------------------------------------------------
  public String getFromyear()
  {
    Integer iWork;
    iWork = new Integer(fromyear);
    return iWork.toString();
  }

  public void setFromyear(String strFromyear)
  {
    fromyear = htmlServer.extendedParseInt(strFromyear);
  }
  //-----------------------------------------------------------------------
  // From month Property (month of starting date)
  //-----------------------------------------------------------------------
  public String getFrommonth()
  {
    Integer iWork;
    iWork = new Integer(frommonth);
    return iWork.toString();
  }

  public void setFrommonth(String strFrommonth)
  {
    frommonth = htmlServer.extendedParseInt(strFrommonth);
  }

  //-----------------------------------------------------------------------
  // From day Property (day of starting date)
  //-----------------------------------------------------------------------
  public String getFromday()
  {
    Integer iWork;
    iWork = new Integer(fromday);
    return iWork.toString();
  }

  public void setFromday(String strFromday)
  {
    fromday = htmlServer.extendedParseInt(strFromday);
  }

  //-----------------------------------------------------------------------
  // To Year Property (year of starting date)
  //-----------------------------------------------------------------------
  public String getToyear()
  {
    Integer iWork;
    iWork = new Integer(toyear);
    return iWork.toString();
  }

  public void setToyear(String strToyear)
  {
    toyear = htmlServer.extendedParseInt(strToyear);
  }

  //-----------------------------------------------------------------------
  // To month Property (month of starting date)
  //-----------------------------------------------------------------------
  public String getTomonth()
  {
    Integer iWork;
    iWork = new Integer(tomonth);
    return iWork.toString();
  }

  public void setTomonth(String strTomonth)
  {
    tomonth = htmlServer.extendedParseInt(strTomonth);
  }

  //-----------------------------------------------------------------------
  // To day Property (day of starting date)
  //-----------------------------------------------------------------------
  public String getToday()
  {
    Integer iWork;
    iWork = new Integer(today);
    return iWork.toString();
  }

  public void setToday(String strToday)
  {
    today = htmlServer.extendedParseInt(strToday);
  }

  //-----------------------------------------------------------------------
  // Selection logic Property
  //-----------------------------------------------------------------------
  public void setLogic(String logic)
  {
    this.logic = logic;
  }

  public String getLogic()
  {
    return logic;
  }

  //-----------------------------------------------------------------------
  // Country Code Property
  //-----------------------------------------------------------------------
  public void setCountrycode(String countrycode)
  {
    this.countrycode = countrycode;
  }

  public String getCountrycode()
  {
    return countrycode;
  }

  //-----------------------------------------------------------------------
  // Country Name Property
  //-----------------------------------------------------------------------
  public void setCountryname(String countryname)
  {
    this.countryname = countryname;
  }

  public String getCountryname()
  {
    return this.countryname;
  }

  //-----------------------------------------------------------------------
  //  BOOLEAN variables for the query
  //-----------------------------------------------------------------------

  private String sBoolToStr(boolean bVar)
  {
    if (bVar)
      return "Y";
    else
      return "N";
  }

  public void setMuertos(String muertos)
  {
    this.killed = muertos.length() > 0;
  }

  public String getMuertos()
  {
    return sBoolToStr(killed);
  }

  public void setHeridos(String heridos)
  {
    this.injured = heridos.length() > 0;
  }

  public String getHeridos()
  {
    return sBoolToStr(injured);
  }

  public void setDesaparece(String smissing)
  {
    this.missing = smissing.length() > 0;
  }

  public String getDesaparece()
  {
    return sBoolToStr(missing);
  }

  public void setVivdestruidas(String vivdestruidas)
  {
    this.destroyedHouses = vivdestruidas.length() > 0;
  }

  public String getVivdestruidas()
  {
    return sBoolToStr(destroyedHouses);
  }

  public void setVivafectadas(String vivafectadas)
  {
    this.affectedHouses = vivafectadas.length() > 0;
  }

  public String getVivafectadas()
  {
    return sBoolToStr(affectedHouses);
  }

  public void setAfectados(String afectados)
  {
    this.affected = afectados.length() > 0;
  }

  public String getAfectados()
  {
    return sBoolToStr(affected);
  }

  public void setReubicados(String reubicados)
  {
    this.relocated = reubicados.length() > 0;
  }

  public String getReubicados()
  {
    return sBoolToStr(relocated);
  }

  public void setDamnificados(String damnificados)
  {
    this.victims = damnificados.length() > 0;
  }

  public String getDamnificados()
  {
    return sBoolToStr(victims);
  }

  public void setEvacuados(String evacuados)
  {
    this.evacuated = evacuados.length() > 0;
  }

  public String getEvacuados()
  {
    return sBoolToStr(evacuated);
  }


    public void setRoads (String roads )
    {
    this.roads = roads.length()>0;
    }

    public String getRoads ()
    {
    return sBoolToStr(roads);
    }

    public void setHectares (String hectares )
    {
    this.hectares =hectares.length()>0;
    }

    public String getHectares ()
    {
    return sBoolToStr(hectares);
    }

    public void setLivestock (String livestock  )
    {
    this.livestock  =livestock.length()>0;
    }

    public String getLivestock ()
    {
    return sBoolToStr(livestock);
    }

    public void setSchools (String schools  )
    {
    this.schools  =schools.length()>0;
    }

    public String getSchools ()
    {
    return sBoolToStr(schools);
    }

    public void setHospitals (String hospitals  )
    {
    this.hospitals  =hospitals.length()>0;
    }

    public String getHospitals ()
    {
    return sBoolToStr(hospitals);
    }

    public void setWater (String water  )
    {
    this.water  =water.length()>0;
    }

    public String getWater ()
    {
    return sBoolToStr(water);
    }

    public void setSewerage (String sewerage)
    {
    this.sewerage  =sewerage.length()>0;
    }

    public String getSewerage ()
    {
    return sBoolToStr(sewerage);
    }

    public void setEducation (String education  )
    {
    this.education  =education.length()>0;
    }

    public String getEducation ()
    {
    return sBoolToStr(education);
    }

    public void setPower (String power  )
    {
    this.power  =power.length()>0;
    }

    public String getPower ()
    {
    return sBoolToStr(power);
    }

    public void setIndustries (String industries)
    {
    this.industries=industries.length()>0;
    }

    public String getIndustries ()
    {
    return sBoolToStr(industries);
    }

    public void setHealth (String health  )
    {
    this.health  =health.length()>0;
    }

    public String getHealth ()
    {
    return sBoolToStr(health);
    }

    public void setAgriculture (String agriculture  )
    {
    this.agriculture  =agriculture.length()>0;
    }

    public String getAgriculture ()
    {
    return sBoolToStr(agriculture);
    }

    public void setTransportation (String transportation  )
    {
    this.transportation  =transportation.length()>0;
    }

    public String getTransportation ()
    {
    return sBoolToStr(transportation);
    }

    public void setCommunications (String communications  )
    {
    this.communications  =communications.length()>0;
    }

    public String getCommunications ()
    {
    return sBoolToStr(communications);
    }

    public void setRelief (String relief  )
    {
    this.relief  =relief.length()>0;
    }

    public String getRelief ()
    {
    return sBoolToStr(relief);
    }

    public void setOther (String other )
    {
     this.other =other.length()>0;
    }

   public String geOther ()
    {
    return sBoolToStr(other);
    }

  public boolean bVariableIsSelected(String sVariableName)
  {
    boolean bRet=false;

    if (asVariables!=null)
    {
      for (int j=0; j<asVariables.length && !bRet; j++)
        if (asVariables[j]!=null && sExtractVariable(asVariables[j]).equals(sVariableName))
          bRet=true;

    }

    return bRet;
  }

  public void processParams(HttpServletRequest request,  parser Parser)
  {
	  processParams(request,  Parser, null);
  }

  public void processParams(HttpServletRequest request,  parser Parser, Connection con)
	  {
	  
	  boolean bBookmark=(request.getParameter("bookmark")!=null);
	  int level_act=0;
	  //	   load the translations needed for the query parser BEFORE changing the language...
	  String sExpertTranslation="";
	  if (request.getParameter("sExpertWhere")!=null || request.getParameter("sExpertVariable")!=null)
	  	{
	  	// this has to be done BEFORE the language changes
	  	Parser.buildTranslations(this, true);
	  	}
	  //	   load language code (if available)
	  if (request.getParameter("lang")!=null)
		{
			String sLang=not_null_safe(request.getParameter("lang"));
			if (sLang.length()>2)
				sLang=sLang.substring(0,2);
			setLanguage(sLang);
		}
	  // depending where it is comming from, loads different parameters...
	  String strFromPage=not_null_safe(request.getParameter("frompage"));
	  boolean bValid=
			  		   strFromPage.equals("/profiletab.jsp") 
			  		|| strFromPage.equals("/main.jsp") 
			  		|| strFromPage.equals("/maps.jsp")
			  		|| strFromPage.equals("/results.jsp")  
			  		|| strFromPage.equals("/report.jsp") 			  		
			  		|| strFromPage.equals("/inv/querytab.jsp")
			  		|| strFromPage.equals("/inv/resultstab.jsp")
			  		|| strFromPage.equals("/graphics.jsp")
			  	    || strFromPage.equals("/definestats.jsp") 
			  	    || strFromPage.equals("/definextab.jsp")
			  	    || strFromPage.equals("/generator.jsp")
			  	    || strFromPage.equals("/thematic_def.jsp");
	  if (!bValid && strFromPage.length()>0)
		  {
		  System.out.println("[DI9] Invalid fromPage parameter: "+strFromPage);
		  // strFromPage="/main.jsp"; 
		  }
	  
	  // EXPLORE THIS: strFromPage= request.getRequestURL();		  
	  if (bBookmark || strFromPage.equals("/main.jsp") || strFromPage.equals("/inv/querytab.jsp"))
	    {
	  	this.loadVectors(request);
	  	// the expert:
	  	if (request.getParameter("sExpertWhere")!=null)
	  	   {
	  	   sExpertTranslation=request.getParameter("sExpertWhere").trim();
	  	   this.sExpertWhere=Parser.translateExpertExpression(sExpertTranslation, Parser.hmVarUntrans);
	  	   }
	  	else
	  	    this.sExpertWhere=""; 
	    }
	  if (strFromPage.equals("/profiletab.jsp"))
	      {
		    asEventos=null;
		    String sEv=not_null_safe(request.getParameter("eventos"));
		    if (sEv.length()>0)
		    	{
		    	asEventos = new String[1];
		    	asEventos[0]=sEv;
		    	}
		    bHayEventos = (asEventos!=null);
		    sEv=not_null_safe(request.getParameter("level0"));
		    asNivel0 = null;
		    asNivel1 = null;
		    asNivel2 = null;
		    if (sEv.length()>0)
		    	{
		    	asNivel0 = new String[1];
		    	asNivel0[0]=sEv;
		    	}
		    bHayNivel0 = (asNivel0!=null);
		    bHayNivel1=bHayNivel2=false;

	  	 }
	  if (strFromPage.equals("/report.jsp") || strFromPage.equals("/results.jsp")  || strFromPage.equals("/inv/resultstab.jsp"))
    	{
		  if (!strFromPage.equals("/report.jsp"))
	    	{
			  bViewStandard=request.getParameter("viewStandard")!=null;
			  bViewExtended=request.getParameter("viewExtended")!=null;
	    	}
		  String sLocalSort=not_null_safe(request.getParameter("localsort"));
		  // TODO: validate if is a real variable. Use FICHAS and EXTENSION objects to ensure they are valid
		  // 
		  if (sLocalSort.length()>0)
		   {
			  hOrderBy.put("8",sLocalSort);
		      sortby="8";
		   }
    	}
	 if (strFromPage.equals("/maps.jsp"))
	      {
	  	// level of the displayed map
	  	level_act=this.extendedParseInt(request.getParameter("level_act"));
	  	if (level_act==0)
	  		  {
  			  asNivel0 = loadArrayParameter(request, "codes");
	  		  bHayNivel0 = (asNivel0!=null);
	  		  }
	  		else if (level_act==1)
	  		  {
	  		  bHayNivel0 = true;
			  asNivel1 = loadArrayParameter(request, "codes");
			  bHayNivel1 = (asNivel1!=null);
	  		  }
	  		else if (level_act==2)
	  		  {
    		  bHayNivel0 = true;
    		  bHayNivel1 = true;
	  		  asNivel2 = loadArrayParameter(request, "codes");
			  bHayNivel2 = (asNivel2!=null);
	  		  }
	  	if (request.getParameter("xresolution")!=null)
	  	   this.xresolution=Math.min(3000,Math.max(80,this.extendedParseInt(request.getParameter("xresolution"))));
	  	if (request.getParameter("yresolution")!=null)
	  	   this.yresolution=Math.min(3000,Math.max(80,this.extendedParseInt(request.getParameter("yresolution"))));
	  	}
	  if (strFromPage.equals("/graphics.jsp"))
	  	{
	      this.nChartType = this.extendedParseInt(request.getParameter("chartType"));
	      this.nChartMode = this.extendedParseInt(request.getParameter("chartMode"));
	      this.nPeriodType = this.extendedParseInt(request.getParameter("periodType"));
	      this.nSeasonType = this.extendedParseInt(request.getParameter("seasonType"));
	      this.nChartSubmode =this.extendedParseInt(request.getParameter("chartSubMode"));
	      this.sTitle =not_null_safe(request.getParameter("chartTitle"));
	  	  this.sSubTitle =not_null_safe(request.getParameter("chartSubTitle"));
	      this.b3D= "1".equals(request.getParameter("chart3D"));
	      this.bColorBW= "1".equals(request.getParameter("chartColor"));
	      this.xresolution=Math.min(3000,Math.max(80,this.extendedParseInt(request.getParameter("chartX"))));
	  	  this.yresolution=Math.min(3000,Math.max(80,this.extendedParseInt(request.getParameter("chartY"))));
	  	  this.dChartMaxX=Math.max(0,this.extendedParseDouble(request.getParameter("chartMaxX")));
	      this.dChartMaxY=Math.max(0,this.extendedParseDouble(request.getParameter("chartMaxY")));
	      this.bLogarithmicX= not_null(request.getParameter("logarithmicX")).equals("Y");
	      this.bLogarithmicY= not_null(request.getParameter("logarithmicY")).equals("Y");
	      this.bRegression= this.not_null(request.getParameter("bRegression")).equals("Y");
	      this.loadVariables(request);
	  	  if (this.asVariables==null)
	      	{
	          this.asVariables=new String[1];
	      	  this.asVariables[0] = "";
	      	}
	      if (this.asVariables[0].length() == 0)
	          this.asVariables[0] = "1 as \""+this.getTranslation("DataCards")+"\"";
	  	this.loadChartMapVariables(this.asVariables);
	  	if (bBookmark)
 	         this.asChartColors = loadArrayParameter((HttpServletRequest)request,"color");
	  	else	
	  	    for (int j=0; j<8; j++)
	  	         this.asChartColors[j] = this.not_null_safe(request.getParameter("color_"+j));
	  	if (request.getParameter("sExpertVariable")==null)
	  	    this.sExpertVariable=""; 
	     	}
	  if (strFromPage.equals("/definestats.jsp") || strFromPage.equals("/definextab.jsp"))
	      {
	  	// load vector with chosen variables
	  	this.loadVariables(request);
	  	// save variables in private area
	  	this.loadStatVariables(this.asVariables);
	  	// load vector with stats levels
	  	this.loadStatLevels(request);
	  	if (request.getParameter("sExpertVariable")==null)
	  	    this.sExpertVariable=""; 
	  	}
	 if (strFromPage.equals("/generator.jsp"))
	  	    {
	  		// load vector with chosen variables
	  		this.loadVariables(request);
	  		// save variables in private area
	  		this.loadReportVariables(this.asVariables);
	  		if (request.getParameter("sExpertVariable")==null)
	  			    this.sExpertVariable=""; 
		    String sLocalSort=not_null(request.getParameter("localsort"));
			if (sLocalSort.length()>0)
			   {
				  hOrderBy.put("8",sLocalSort);
			      sortby="8";
			   }
	  		}
	 if (strFromPage.equals("/thematic_def.jsp"))
	  	    {
	  		// load all page parameters
	  		this.getMapParameters((ServletRequest) request);
	  	    if (this.asVariables==null)
	  	    	{
	  	        this.asVariables=new String[1];
	  	    	this.asVariables[0] = "";
	  	    	}
	  	    if (this.asVariables[0].length() == 0)
	  	        this.asVariables[0] = "1 as \""+this.getTranslation("DataCards")+"\"";
	  		this.loadChartMapVariables(this.asVariables);
	  		if (request.getParameter("sExpertVariable")==null)
	  			    this.sExpertVariable=""; 
	  		}
	  if (request.getParameter("sExpertVariable")!=null)
	  	   {
	  	   sExpertTranslation=request.getParameter("sExpertVariable").trim();
	  	   this.sExpertVariable=Parser.translateExpertExpression(sExpertTranslation, Parser.hmVarUntrans);
	  	   }
//	   done again AFTER language changes...
	  if (this.sExpertWhere.length()>0 || this.sExpertVariable.length()>0)
	     Parser.buildTranslations(this, true);
	  
	  // SQL Injection validation:   (check all parameters are what they are supposed to be.
	  checkParameterArray(asEventos,30);
	  checkParameterArray(asNivel0,16);
	  checkParameterArray(asNivel1,16);
	  checkParameterArray(asNivel2,16);
	  checkParameterArray(asCausas,32);
	  checkParameterArray(asMapColors,10);
	  checkParameterArray(asMapLegends,50);
		  
  }

  public static void checkParameterArray(String[] sArray, int maxlength)
  {
  if (sArray!=null)
	  {
	  for (int j=0; j<sArray.length; j++)
		  if (sArray[j]!=null)
			  if (sArray[j].length()>maxlength)
				  sArray[j]=sArray[j].substring(0,maxlength);		  
	  }
  }


/*
 * generates a parseable URL parameter for a vector
 */
public String getVectorBookmark(String sVectorName, String[] sVector)
{
	String sBook="";
	
	if (sVector!=null)
	{
		StringBuffer sbBook=new StringBuffer();
		sbBook.append("&");
		sbBook.append(sVectorName);
		sbBook.append("=");
		for (int j=0; j<sVector.length; j++)
	     {
				try
				{
					if (j>0)
						sbBook.append(",");
					if (sVector[j]!=null)
						sbBook.append(java.net.URLEncoder.encode(sVector[j],"UTF8"));
				}
				catch (Exception e)
				{}
	     }
	sBook=sbBook.toString().replace('%', '@');	
	}
   return sBook;	
}


public String getBookmark(HttpServletRequest request)
{
// Mandatory elements of a boomark: query parameters
String sBookMark="?bookmark=1&countrycode="+countrycode;

String sForPage=request.getServletPath();

if ("/ajax_paramprocessor.jsp".equals(sForPage))
	{
	sForPage=not_null_safe(request.getParameter("frompage"));	
	}

sBookMark+="&maxhits="+nMaxhits;
sBookMark+="&lang="+sLanguage;   // default is English
if (sKeyWord.length()>0)
	sBookMark+="&sKeyWord="+sKeyWord;
sBookMark+="&logic="+logic;
sBookMark+="&sortby="+sortby;

// ALL parameters of the query page must be present
sBookMark+=getVectorBookmark("_eventos",asEventos);
sBookMark+=getVectorBookmark("_level0",asNivel0);
sBookMark+=getVectorBookmark("_level1",asNivel1);
sBookMark+=getVectorBookmark("_level2",asNivel2);
sBookMark+=getVectorBookmark("_causas",asCausas);

if (fromyear>0)	
	sBookMark+="&fromyear="+fromyear;
if (frommonth>0)	
	sBookMark+="&frommonth="+frommonth;
if (fromday>0)	
	sBookMark+="&fromday="+fromday;
if (toyear>0)
	sBookMark+="&toyear="+toyear;
if (tomonth>0)	
	sBookMark+="&tomonth="+tomonth;
if (today>0)	
	sBookMark+="&today="+today;
if (killed) 
	sBookMark+="&muertos=Y";
if (injured)
	sBookMark+="&heridos=Y";
if (missing)
	sBookMark+="&desaparece=Y";
if (destroyedHouses)
	sBookMark+="&vivdestruidas=Y";
if (affectedHouses)
	sBookMark+="&vivafectadas=Y";
if (victims)
	sBookMark+="&damnificados=Y";
if (evacuated)
	sBookMark+="&evacuados=Y";
if (affected)
	sBookMark+="&afectados=Y";
if (relocated)
	sBookMark+="&reubicados=Y";
if (roads)
	sBookMark+="&roads=Y";
if (hectares)
	sBookMark+="&hectares=Y";
if (livestock)
	sBookMark+="&livestock=Y";
if (schools)
	sBookMark+="&schools=Y";
if (hospitals)
	sBookMark+="&hospitals=Y";
if (water)
	sBookMark+="&water=Y";
if (sewerage)
	sBookMark+="&sewerage=Y";
if (education)
	sBookMark+="&education=Y";
if (power)
	sBookMark+="&power=Y";
if (industries)
	sBookMark+="&industries=Y";
if (health)
	sBookMark+="&health=Y";
if (agriculture)
	sBookMark+="&agriculture=Y";
if (transportation)
	sBookMark+="&transportation=Y";
if (communications)
	sBookMark+="&communications=Y";
if (relief)
	sBookMark+="&relief=Y";
if (other)
	sBookMark+="&other=Y";
if (sGlide.length()>0)
	sBookMark+="&glide="+sGlide;

//Expert variables
if (sExpertWhere.length()>0)
	sBookMark+="&sExpertWhere="	+sExpertWhere;
if (sExpertVariable.length()>0)
	sBookMark+="&sExpertVariable="+sExpertVariable;

//FUTURE: ranges for effects
//sMinEffect=new double[15];
//sMaxEffect=new double[15];
//dMinExtension=null;
//dMaxExtension=null;  

if ("/maps.jsp".equals(sForPage))
{
	sBookMark+="&level_act="+not_null_safe(request.getParameter("level_act"));
	sBookMark+="&new_level="+not_null_safe(request.getParameter("new_level"));
	sBookMark+="&level0_code="+not_null_safe(request.getParameter("level0_code"));
	sBookMark+="&level1_code="+not_null_safe(request.getParameter("level1_code"));

}
if ("/results.jsp".equals(sForPage))
{
//	 Results page variables
	sBookMark+="&frompage=/results.jsp";
	if (bViewStandard)
		sBookMark+="&viewStandard=Y";
	if (bViewExtended)
	    sBookMark+="&viewExtended=Y";
	if (bViewRawData)
		sBookMark+="&viewRaw=Y";
	//FUTURE: bDetailed=true;	
}


if ("/chart.jsp".equals(sForPage) || "/graphics.jsp".equals(sForPage))
{
//	chart variables
	sBookMark+="&frompage=/graphics.jsp";
	sBookMark+="&chartType="+nChartType;    // type of chart: temporal histogram
	sBookMark+="&chartMode="+nChartMode;    // mode of chart (pie, bar, line)  BAR
	sBookMark+="&chartSubMode="+nChartSubmode; // normal, stacked, cummulative  NORMAL
	sBookMark+="&periodType="+nPeriodType;   // period for histograms
	sBookMark+="&seasonType="+nSeasonType;   // season for seasonal histograms
	sBookMark+="&chart3D="+(b3D?"1":"2");           // 3d effect on
	sBookMark+="&chartColor="+(bColorBW?"1":"2");        // Color(true) or B/W
	sBookMark+="&chartX="+xresolution;
	sBookMark+="&chartY="+yresolution;
	sBookMark+="&chartTitle="+sTitle;
	sBookMark+="&chartSubTitle="+sSubTitle;
	if (bLogarithmicX) sBookMark+="&logarithmicX=Y";
	if (bLogarithmicY) sBookMark+="&logarithmicY=Y";
	if (bRegression) sBookMark+="&bRegression=Y";
	sBookMark+="&chartMaxY="+dChartMaxX;
	sBookMark+="&chartMaxY="+dChartMaxY;
	sBookMark+="&chartRanges="+nChartRanges;    // initial default
	sBookMark+=getVectorBookmark("_color",asChartColors);

//	Future: Chart decorations:
//	chartObjects=null;
	
}



if ("/report.jsp".equals(sForPage)||"/generator.jsp".equals(sForPage))
{
//	this are dependent of the page!! TODO : fix size of URL generated
	sBookMark+="&frompage=/generator.jsp";
}

if ("/thematic_def.jsp".equals(sForPage) || 
	"/thematic.jsp".equals(sForPage) || 
	"/thematic_OL.jsp".equals(sForPage) || 
	"/thematic_google.jsp".equals(sForPage) || 
	"/export_kml.jsp".equals(sForPage) || 
	"/thematic_kml.jsp".equals(sForPage))
{
	sBookMark+="&frompage=/thematic_def.jsp&_range=";
	for (int j=0; j<asMapRanges.length; j++)
		sBookMark+=","+asMapRanges[j];
	sBookMark+=getVectorBookmark("_color",asMapColors);
	sBookMark+=getVectorBookmark("_legend",asMapLegends);
	sBookMark+="&chartColor="+(bColorBW?"1":"2");        // Color(true) or B/W
	sBookMark+="&chartX="+xresolution;
	sBookMark+="&chartY="+yresolution;
	sBookMark+="&chartTitle="+sTitle;
	sBookMark+="&chartSubTitle="+sSubTitle;
//	sBookMark+="&idAllType="+nShowAllIdsType;  // 0=ALL, 1=only with values, 2=only selected
	sBookMark+="&showValues="+nShowValueType;   // 0=don't show value, 1->show it, 2...?
	sBookMark+="&legendType="+nMapType;    // 0=polyfill, 1=discs, 2=bars?
	sBookMark+="&level_rep="+level_rep;
	sBookMark+="&level_map="+level_map; 
	sBookMark+="&dissagregate_map="+dissagregate_map; 
	
//	 FUTURE: mapObjects=null;
	
}


if ("/definestats.jsp".equals(sForPage)||"/definestats.jsp".equals(sForPage)||"/definextab.jsp".equals(sForPage)||"/statistics.jsp".equals(sForPage) || "/crosstab.jsp".equals(sForPage))
{
	sBookMark+="&frompage=/definestats.jsp";
	//	statistical functions
	if (bSum)
		sBookMark+="&bSum=Y";
	if (bMax)
		sBookMark+="&bMax=Y";
	if (bAvg)
		sBookMark+="&bAvg=Y";
	if (bStd)
		sBookMark+="&bStd=Y";
	if (bVar)
		sBookMark+="&bVar=Y";
//	Stat levels vector
	sBookMark+=getVectorBookmark("_stat",asStatLevels);
	sBookMark+="&nlevels="+nStatLevels;
}

//current variables
sBookMark+=getVectorBookmark("_variables",asVariables);

return EncodeUtil.jsEncode(sBookMark);
}

  public void init()
  {
	// levels vector
    asLevels = new String[3];
	asLevels[0] = "";
	asLevels[1] = "";
	asLevels[2] = "";
	anLevelsLen = new int[3];
	anLevelsLen[0] = 2;
	anLevelsLen[1] = 5;
	anLevelsLen[2] = 8;
	
	// Stat levels vector
	asStatLevels = new String[3];
	asStatLevels[0] = "eventos.nombre"+(this.sLanguage.equals("EN")?"_en":"");
	asStatLevels[1] = "";
	asStatLevels[2] = "";
	nStatLevels = 1;
	
	// posible sortings
	hOrderBy.put("0", "fichas.clave desc");
	hOrderBy.put("1", "fichas.serial");
	hOrderBy.put("2", "name0,name1,name2,evento,fechano desc,fechames desc,fechadia desc");
	hOrderBy.put("3", "name0,name1,name2,fechano desc,fechames desc,fechadia desc,evento");
	hOrderBy.put("4", "evento,name0,name1,name2,fechano desc,fechames desc,fechadia desc");
	hOrderBy.put("5", "evento,fechano desc,fechames desc,fechadia desc,name0,name1,name2");
	hOrderBy.put("6", "fechano desc,fechames desc,fechadia desc,name0,name1,name2,evento");
	hOrderBy.put("7", "fechano desc,fechames desc,fechadia desc,evento,name0,name1,name2");


    asMapRanges = new double[15];
    asMapColors=new String[15];
    asMapLegends=new String[15];
  	
  nStatLevels = 0;
  nMaxhits=100;
  setLanguage(sLanguage);   // default is English
  sKeyWord="";
  logic = "AND";
  sortby = "0";

  nApproved=-1;

  fromyear = 0;
  frommonth = 0;
  fromday = 0;
  toyear = 0;
  tomonth = 0;
  today = 0;

  killed = false;
  injured = false;
  missing = false;
  destroyedHouses = false;
  affectedHouses = false;
  victims = false;
  evacuated = false;
  affected = false;
  relocated = false;
  roads = false;
  hectares = false;
  livestock = false;
  schools = false;
  hospitals = false;


  water = false;
  sewerage = false;
  education = false;
  power = false;
  industries = false;
  health = false;
  agriculture = false;
  transportation = false;
  communications = false;
  relief = false;
  other = false;

  asEventos = null;
  asNivel0 = null;
  asNivel1 = null;
  asNivel2 = null;
  asVariables = null;
  asCausas = null;
  
  asChartMapVariables=null;
  asReportVariables=null;
  asStatisticsVariables=null;
  asCrosstabVariables=null;
    
  bHayEventos = false;
  bHayNivel0 = false;
  bHayNivel1 = false;
  bHayNivel2 = false;
  bHayVariables = false;
  bWereCauses = false;
  
  // Expert variables
  sExpertVariable="";
  sExpertWhere="";

  // statistical functions
  bSum=true;
  bMax=false;
  bAvg=false;
  bStd=false;
  bVar=false;

 
// chart variables
  nChartType = 1;    // type of chart: temporal histogram
  nChartMode = 1;    // mode of chart (pie, bar, line)  BAR
  nChartSubmode = 1; // normal, stacked, cummulative  NORMAL
  nPeriodType = 1;   // period for histograms
  nSeasonType = 4;   // season for seasonal histograms
  b3D = true;           // 3d effect on
  bColorBW=true;        // Color(true) or B/W
  xresolution=1000;
  yresolution=600;
  hVariableList = new HashMap();
  sTitle="";
  sSubTitle="";

   asMapRanges = new double[15];
   asMapColors = new String[15];
   asMapLegends = new String[15];

  for (int j=0; j<10; j++)
  {
    asMapRanges[j]=0;
    asMapColors[j]="";
    asMapLegends[j]="";
  }
  asMapRanges[0]=1;
  asMapRanges[1]=10;
  asMapRanges[2]=100;
  asMapRanges[3]=1000;
  asMapRanges[4]=10000;

  asMapColors[0]="#ffff88";
  asMapColors[1]="#ffcc00";
  asMapColors[2]="#ff8800";
  asMapColors[3]="#ff0000";
  asMapColors[4]="#bb0000";
  asMapColors[5]="#770000";

  int i=0;
  asChartColors = new String[15];
  /*
  asChartColors[i++]="#00BFFF";
  asChartColors[i++]="#FF8C00";
  asChartColors[i++]="#006400";
  asChartColors[i++]="#800000";
  asChartColors[i++]="#FF1493";
  asChartColors[i++]="#00FFFF";
  asChartColors[i++]="#CD5C5C";
  asChartColors[i++]="#FFA07A";
  asChartColors[i++]="#00FF7A";
  asChartColors[i++]="#A07AFF";
  */
  asChartColors[i++]="#0000FF"; // Color.blue
  asChartColors[i++]="#FF0000"; // Color.red
  asChartColors[i++]="#008000"; // Color.green
  asChartColors[i++]="#FFFF00"; // Color.yellow
  asChartColors[i++]="#FF00FF"; // Color.magenta
  asChartColors[i++]="#FFA500"; // Color.orange
  asChartColors[i++]="#00FFFF"; // Color.cyan
  asChartColors[i++]="#FFC0CB"; // Color.pink
  asChartColors[i++]="#D3D3D3"; // Color.lightGray
  asChartColors[i++]="#FFFF00"; // Color.yellow

  i=0;
  asChartBWs = new String[15];

  asChartBWs[i++]="#404040"; 
  asChartBWs[i++]="#4D4D4D"; 
  asChartBWs[i++]="#595959"; 
  asChartBWs[i++]="#666666"; 
  asChartBWs[i++]="#737373"; 
  asChartBWs[i++]="#808080"; 
  asChartBWs[i++]="#8C8C8C"; 
  asChartBWs[i++]="#999999"; 
  asChartBWs[i++]="#A6A6A6"; 
  asChartBWs[i++]="#B2B2B2"; 

  mapObjects=null;
  // Chart decorations:
  chartObjects=null;
  // ranges for effects
  sMinEffect=new String[15];
  sMaxEffect=new String[15];
  for (int j=0; j<15; j++)
  {
    sMinEffect[j]="";
    sMaxEffect[j]="";
  }

  sMinExtension=null;
  sMaxExtension=null;  
  
  // restarts the ver 7.9 data structures
  laAttrs=new LevelAttributes[3];
  // External map levels 0-2
  lmMaps=new LevelMaps[3];
  // External map layers
  imLayerMaps=null;

  bLogarithmicX=false;
  bLogarithmicY=false;
  bRegression=false;
  
  dChartMaxX=0;
  dChartMaxY=0;
  nChartRanges=50;    // initial default
  
  bViewStandard=true;
  bViewExtended=false;
  bViewRawData=false;

  nShowIdType=0;      // 0=don't show id, 1=show names, 2=show codes
  nShowAllIdsType=0;  // 0=ALL, 1=only with values, 2=only selected
  nShowValueType=0;   // 0=don't show value, 1->show it, 2...?
  nMapType=0;    // 0=polyfill, 1=discs, 2=bars?
  level_rep=0;
  level_map=1; 

  htData =null;
  
  sGlide="";
  
  vmVmanager=new VariableManager();
  dTransparencyFactor=0.4f;

  groupingMethod=0;
  

  }
   
  
  
  
}