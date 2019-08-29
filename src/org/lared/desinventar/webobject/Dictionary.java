package org.lared.desinventar.webobject;

import java.sql.Types;
import java.util.*;
import org.lared.desinventar.util.*;
import org.lared.desinventar.webobject.*;


/**
 * <p>Title: A  subclass of the original DI extended datacard data dictionary class,
 * providing the real datatype in the database and a placeholder for the actual value
 * entered by the user
 * DesInventar WEB Version 6.1.2</p>
 * <p>Description: On Line Version of DesInventar/DesConsultar 6.</p>
 * <p>Copyright: Copyright (c) 2002  La  Red.</p>
 * <p>La Red de Estudios Sociales en Prevenci�n de Desastres en Am�rica Latina</p>
 * @author Julio Serje
 * @version 1.0
 */

public class Dictionary extends diccionario
{

  public int nDataType=0;
  public double dNumericValue=0;
  public String sValue="";
  public DICountry countrybean=null;
  
  // extension codes
  public ArrayList codes=new ArrayList();
  private extensioncodes ec = new extensioncodes();

  public String getCodeValue(String sCode, DICountry countrybean)
  {
	for (int index=0; index<codes.size(); index++)
	{
		ec=((extensioncodes)(codes.get(index)));
		if (ec.code_value.equals(sCode))
			{
			if (countrybean!=null)
				sCode=countrybean.getLocalOrEnglish(ec.svalue,ec.svalue_en);
			else
				sCode=ec.svalue_en;
			}
	}
	  if (sCode.equals("0"))
		  sCode="";
	  return sCode; 
  }

  public String getValueCode(String sCode, DICountry countrybean)
  {
	for (int index=0; index<codes.size(); index++)
	{
		ec=((extensioncodes)(codes.get(index)));
		if (ec.svalue_en.equals(sCode)|| ec.svalue.equals(sCode))
			{
			sCode=ec.code_value;
			}
	}
   return sCode; 
  }


  
  /* 
   * returns a pure (but formatted numeric) value.
   */
  public String getValue()
  {
		String sCode="";
		    switch (this.fieldtype)
 		      {    		    
				case extension.YESNO:
                    sCode=sValue;
					break;
				case extension.LIST:
				case extension.CHOICE:
						sCode=getCodeValue(sValue,countrybean);
					break;
				case extension.INTEGER:
     			    int index=(int)dNumericValue;
						sCode=index==0?"":String.valueOf(index);
					break;
				case extension.FLOATINGPOINT:
					 sCode=dNumericValue==0.0?"":formatDouble(dNumericValue,-4); // ok, up to 4 relevant decs...
	               break;
				case extension.CURRENCY:
		        	 sCode=dNumericValue==0.0?"":formatDouble(dNumericValue);
	               break;
				case extension.DATETIME:
 		        	sCode=strDate(sValue);
				   break;
				case extension.MEMO:
	     			sCode=sValue;
				   break;
			    default:  
 					sCode=sValue;
 		      }
  return sCode; 
	  
  }
  
  /**
   *  gets a value suitable for showing it in HTML pages; 
   *  note it truncates memos to 500 chars, and formats y/n as checkboxes
   */
  public String getFieldValue()  
    {
	  		String sCode="";
   		    if (this.fieldtype==extension.YESNO)
                        sCode="&nbsp;<input name='"+nombre_campo+"' type='checkbox' value=\"Y\" "+strChecked(sValue)+">";
   		    else
   		    	if (this.fieldtype==extension.MEMO)
   		    		sCode=EncodeUtil.htmlEncode(sValue.length()>500?sValue.substring(0,500):sValue);
   		    	else
   		    		sCode=EncodeUtil.htmlEncode(getValue());
	        return sCode; 
      }

  public void setCountrybean(DICountry cnt)
  {
	countrybean=cnt;  
  }
  
  public Dictionary()
  {
  }

}