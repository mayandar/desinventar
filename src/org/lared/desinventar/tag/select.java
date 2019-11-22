package org.lared.desinventar.tag;

import java.io.*;
import java.util.*;
import java.sql.*;
import java.math.*;
import java.text.*;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;
import org.lared.desinventar.util.*;

/** JSP tag that expands the list of options
 *  of a select with all the records of a given table.
 */

public class select extends TagSupport
{
	Connection con;
	String sSelectedCode="0";
	String sTableName="";
	String sFieldName="";
	String sCodeName="";
	String sOrderName="";
	String sWhereClause="";
	String sLanguage="";
	String sLanguageField="metadata_lang";
	boolean bUseLanguage=false;

	String[] vSelectedCodes = null;

	public void setConnection (Connection con)
	{
		this.con=con;
	}

	public void setSelected (int nSelectedCode)
	{
		this.sSelectedCode=String.valueOf(nSelectedCode);
	}

	public void setSelected (String sCode)
	{
		this.sSelectedCode=new String(sCode);
	}

	public void setSelected(String[] vSelectedCode)
	{
		this.vSelectedCodes = vSelectedCode;
	}

	public void setTablename (String sTable)
	{
		this.sTableName=sTable;
	}

	public void setFieldname (String sField)
	{
		this.sFieldName=sField;
	}

	public void setCodename (String sField)
	{
		this.sCodeName=sField;
	}

	public void setOrdername (String sField)
	{
		this.sOrderName=sField;
	}

	public void setWhereclause (String sField)
	{
		this.sWhereClause=sField;
	}

	public void setLanguage (String sLang)
	{
		this.sLanguage=sLang;
		bUseLanguage=true;
	}

	public void setLanguagefield (String sLangField)
	{
		this.sLanguageField=sLangField;
	}

	private String getSelectSQL(String sLanguage)
	{
		String sWhere=" where ";
		String sSql="Select "+sFieldName+" as fieldn,"+sCodeName+" as code from "+sTableName.toLowerCase();
		if (sWhereClause.length()>0)
		{
			sSql+=sWhere+"("+ sWhereClause + ")";
			sWhere=" and ";
		}
		if (this.bUseLanguage && sLanguage.length()>0)   	   
			sSql+=sWhere+sLanguageField+"='"+sLanguage+"'";

		if (sOrderName.length()>0)
			sSql+=" order by "+sOrderName;

		return sSql;
	}

	public int doStartTag()
	{
		Statement stmt;
		ResultSet rset;
		String sSql="";
		String sCode="0";

		JspWriter out = pageContext.getOut();
		try {
			stmt=con.createStatement ();
			sSql=getSelectSQL(sLanguage);
			// test existence of specific language in the database
			if (this.bUseLanguage)
				{
				rset=stmt.executeQuery(sSql);
				if (!rset.next())
					sSql=getSelectSQL("en");	
				}
			rset=stmt.executeQuery(sSql);
			while (rset.next())
			{
				// fields are referenced positionally to allow expressions!!
				sCode=rset.getString(2);
				out.print("<option value=\""+sCode+"\"");
				if (sCode.equals(sSelectedCode))
					out.print(" selected");
				else
					if (vSelectedCodes != null)
					{
						int j=0;
						while (j<vSelectedCodes.length)
						{
							if (vSelectedCodes[j++].equalsIgnoreCase(sCode))
							{
								out.print(" selected");
								j=vSelectedCodes.length;
							}
						}
					}
				// out.println(">"+ EncodeUtil.htmlDecode(htmlServer.not_null(rset.getString(1))));
				out.println(">"+ htmlServer.not_null(rset.getString(1)));
			}
			rset.close();
			stmt.close();
		}
		catch(Exception ioe)
		{
			System.out.println("Error in TagLib [select]: " + ioe);
			try
			{
				out.println("<!--Error in TagLib [select]: " + ioe.toString()+" sql: "+sSql+"-->");
			}
			catch (Exception xxe)
			{
			}
		}
		return(SKIP_BODY);
	}
}