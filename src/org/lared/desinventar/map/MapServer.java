package org.lared.desinventar.map;

/**
 * <p>Title: DesInventar WEB  Version 6.1.2</p>
 * <p>Description: Map server of On Line Version of DesInventar/DesConsultar 6.</p>
 * <p>Copyright: Copyright (c) 2002  La  Red.</p>
 * <p>Company: La Red -  La Red de Estudios Sociales en Prevención de Desastres en América Latina</p>
 * @author Julio Serje
 * @version 1.0
 */

import java.io.*;
import java.sql.*;
import java.util.*;

import javax.servlet.*;
import javax.servlet.jsp.JspWriter;

import java.awt.*;
import java.awt.image.*;

import org.lared.desinventar.util.*;
import org.lared.desinventar.webobject.*;

public class MapServer
{

	public Connection con = null;
	PreparedStatement pstmt=null;


	public static final int nArcLen = 41;
	public static final int nLisLen = 18;
	public static final int nCooLen = 8;

	public Graphics2D g2 = null;
	public MapTransformation mt=new MapTransformation();


	public boolean bHaveMap=false;

	RandomAccessFile f_arc = null;
	RandomAccessFile f_lis = null;
	RandomAccessFile f_coo = null;

	public int MaxBufferSize = 2500;
	public byte[] buffer = new byte[MaxBufferSize];
	public int MaxVectorSize = 310;
	public int[] xcoo = new int[MaxVectorSize];
	public int[] ycoo = new int[MaxVectorSize];
	int nPartSize=50;
	int[] nParts=new int[nPartSize];

	ArrayList[] hashv = null;

	DICountry countrybean = null;
	String sCountryCode = "";

	// C type arc
	int ap_descripcion; /* 21-Apuntador a la descripcion grafica */
	int tamano; /* 25-Tamano de la descripcion  SHORT!!*/
	// C type list
	int ap_arco; /* 0-pointer to an arc that belongs to a multi-polygon area*/
	int ap_sgte; /* 12-pointer to list element*/

	public boolean bShowNames=true;


	public void setTransformation (MapTransformation m)
	{
		mt=m;
	}

	public int getShort(int offset)
	{
		int ix1 = buffer[offset++];
		int ix2 = buffer[offset];
		if (ix1 < 0)
			ix1 += 256;
		if (ix2 < 0)
			ix2 += 256;
		return ix2 <<8  | ix1;
	}

	boolean safe = false;

	public int getInt(int offset)
	{

		int ix1 = buffer[offset++];
		int ix2 = buffer[offset++];
		int ix3 = buffer[offset++];
		int ix4 = buffer[offset];
		if (ix1 < 0)
			ix1 += 256;
		if (ix2 < 0)
			ix2 += 256;
		if (ix3 < 0)
			ix3 += 256;
		if (ix4 < 0)
			ix4 += 256;
		return ( (ix4 * 256 + ix3) * 256 + ix2) * 256 + ix1;

	}

	public int getShortBig(int offset)
	{
		int ix2 = buffer[offset++];
		int ix1 = buffer[offset];
		if (ix1 < 0)
			ix1 += 256;
		if (ix2 < 0)
			ix2 += 256;
		return ix2 * 256 + ix1;
	}

	public int getIntBig(int offset)
	{
		int ix4 = buffer[offset++];
		int ix3 = buffer[offset++];
		int ix2 = buffer[offset++];
		int ix1 = buffer[offset];
		if (ix1 < 0)
			ix1 += 256;
		if (ix2 < 0)
			ix2 += 256;
		if (ix3 < 0)
			ix3 += 256;
		if (ix4 < 0)
			ix4 += 256;
		return ( (ix4 * 256 + ix3) * 256 + ix2) * 256 + ix1;
	}

	public long getLong(int offset)
	{
		long iRet = 0;
		for (int i = offset + 7; i >= offset; i--)
		{
			int ix = buffer[i];
			if (ix < 0)
				ix += 256;
			iRet = (iRet << 8) | ix;
		}
		return iRet;
	}

	public double getDouble(int offset)
	{
		double dRet = 0;
		long iRet = getLong(offset);
		dRet = Double.longBitsToDouble(iRet);
		return dRet;
	}

	public void readArc()
	{
		try
		{
			//int nRead =
				f_arc.readFully(buffer, 0, nArcLen);
			tamano = getShort(25);
			ap_descripcion = getInt(21);
		}
		catch (Exception e)
		{
			tamano = ap_descripcion = 0;

		}
	}

	public void readArc(int nArc)
	{
		try
		{
			f_arc.seek(nArc * nArcLen);
			readArc();
		}
		catch (Exception e)
		{}
	}

	public void readList(int nList)
	{
		try
		{
			f_lis.seek(nList * nLisLen);
			f_lis.readFully(buffer, 0, nLisLen);
			ap_arco = getInt(0);
			ap_sgte = getInt(12);
		}
		catch (Exception e)
		{
			ap_arco =	ap_sgte=0;
		}
	}

	public void readCoord()
	{
		try
		{
			f_coo.seek(ap_descripcion * 8 - 8);
			//int nRead =
				f_coo.readFully(buffer, 0, tamano * 8);
				int nIndex = 0;
				for (int j = 0; j < tamano; j++)
				{
					xcoo[j] = getInt(nIndex);
					nIndex += 4;
					ycoo[j] = getInt(nIndex);
					nIndex += 4;
				}
		}
		catch (Exception e)
		{
			tamano=0;
		}
	}

	public MapServer()
	{
	}


	void devVector()
	{

		int j,k=0;
		int x,y;
		if (tamano<4) 
			for (j = 0; j < tamano; j++)
			{
				xcoo[j] = mt.xdev(xcoo[j]);
				ycoo[j] = mt.ydev(ycoo[j]);

			}
		else
		{
			xcoo[0] = mt.xdev(xcoo[0]);
			ycoo[0] = mt.ydev(ycoo[0]);
			for (j = 1; j < tamano-1; j++)
			{
				x = mt.xdev(xcoo[j]);
				y = mt.ydev(ycoo[j]);
				if (x!=xcoo[k] || y!=ycoo[k])
				{
					k++;
					xcoo[k] = x;
					ycoo[k] = y;
				}
			}
			k++;
			xcoo[k] = mt.xdev(xcoo[j]);
			ycoo[k] = mt.ydev(ycoo[j]);
			tamano=k+1;
		}
	}

	void plotVector()
	{
		int currentX = xcoo[0];
		int currentY = ycoo[0];
		for (int j = 1; j < tamano; j++)
		{
			int x = xcoo[j];
			int y = ycoo[j];
			g2.drawLine(currentX, currentY, x, y);
			currentX = x;
			currentY = y;
		}

	}

	void scan_convert(int xm, int xx)
	{
		int i, j, k;
		int xr, yr, xs, ys, x_act, xxx;
		double pend, y_act;

		//* para cada lado [i -> i+1], tamano puntos ,tamano-1 lados
		j = 0;
		for (i = 0; i < tamano - 1; i++)
		{
			j = 0;
			xr = xcoo[i];
			xs = xcoo[i + 1];
			yr = ycoo[i];
			ys = ycoo[i + 1];
			//* LADOS NO VERTICALES (O NULOS!!!)
			if (xr != xs)
			{
				//* los ordena de izq a derecha
				if (xr > xs)
				{
					xxx = xr;
					xr = xs;
					xs = xxx;
					xxx = yr;
					yr = ys;
					ys = xxx;
				}

				if (xs >= xm && xr <= xx)
				{
					if (xr <= xm)
					{
						x_act = xm;
						j = 0;
					}
					else
					{
						//* calcula interseccion menor o igual
						j = xr - xm;
						x_act = xr;
					}
					//* calcula pendiente, primer Y, paso en y
					pend = (double) (ys - yr) / (xs - xr);
					while (x_act < xs)
					{
						y_act = yr + (x_act - xr) * pend;
						hash_insert(j, (int) (y_act + 0.5));
						j++;
						y_act += pend;
						x_act++;
					}
				} //* no verts
			}
		}
		//* for
	}

	void hash_insert(int nWhere, int y)
	{
		try
		{
			if (nWhere<=mt.xresolution && nWhere>=0)
			{
				if (hashv[nWhere] == null)
				{
					hashv[nWhere] = new ArrayList();
					hashv[nWhere].add(new Integer(y));
				}
				else
				{
					int k = 0;
					while (k < hashv[nWhere].size() && (y > ( (Integer) (hashv[nWhere].get(k))).intValue()))
						k++;
					hashv[nWhere].add(k,new Integer(y));
				}

			}

		}
		catch (Exception e)
		{
			System.out.println("Exception hash-inserting "+nWhere);
		}
	}

	void scan_plot(int xm, int xx)
	{
		int i, k, iy1, iy2;
		//* recorre las listas de intersecciones
		for (i = 0; i < mt.xresolution; i++)
		{
			if (hashv[i] != null)
			{
				k = 0;
				while (k < hashv[i].size() - 1)
				{
					iy1 = ( (Integer) (hashv[i].get(k++))).intValue();
					iy2 = ( (Integer) (hashv[i].get(k++))).intValue();
					g2.drawLine(i, iy1, i, iy2);
				}
			}
		}
		// libera espacio de interseccs
		for (i = 0; i <= mt.xresolution; i++)
			hashv[i] = null;
	}

	public void fillRegion(Color col)
	{
		while (ap_sgte > 0)
		{
			readList(ap_sgte);
			readArc(ap_arco);
			readCoord();
			devVector();
			scan_convert(0, (int) mt.xresolution);
		}
		g2.setColor(col);
		//    g2.setStroke(new BasicStroke(1.0f));
		scan_plot(0, (int) mt.xresolution);
	}

	public void plotRegion(Color col)
	{

		if (bHaveMap)
			while (ap_sgte > 0)
			{
				readList(ap_sgte);
				if (ap_arco>0)
				{
					readArc(ap_arco);
					readCoord();
					devVector();
					g2.setColor(col);
					plotVector();
				}
			}
	}



	public boolean inArray(String[] saArray, String sValue)
	{
		if (saArray == null)
			return false;

		boolean bRet = false;
		for (int j = 0; j < saArray.length && !bRet; j++)
			if (saArray[j] != null && saArray[j].equals(sValue))
				bRet = true;
		return bRet;
	}

	/**
	 * gets a suitable xdev position for a name
	 * 
	 */

	public int xdevName(double xcenter, String sName)
	{
		FontMetrics fmt= g2.getFontMetrics(g2.getFont());
		int lon=fmt.stringWidth(sName);   // fmt.getHeight() gives the height 
		int x=mt.xdev(xcenter)-lon/2;
		//  if (x<0)
		//  	x=0;
		return x;
	}





	/**
	 * Expands & plots an area in certain level. If level=0, normally all areas are plotted. 
	 * @param level level to be drawn
	 * @request http Request object with user params
	 */
	public void plotLevel(int level, String code, ServletRequest request)
	{
		MapUtil.getExtents(level, code, mt, con, countrybean);
		mt.setTransformation();
		plotWMSLevel(level, code, false);
	}


	public void plotWMSLevel(int level, String code, boolean checkbounds) 
	{
		int nTransf=0;
		Color cColor=Color.darkGray;

		if (countrybean.lmMaps[level]!=null)
		{
			nTransf=countrybean.extendedParseInt(countrybean.lmMaps[level].filetype);
			cColor=new Color(countrybean.lmMaps[level].color_red,countrybean.lmMaps[level].color_green,countrybean.lmMaps[level].color_blue);	  
		}
		MapObject moShape=null;
		if (nTransf==1)
		{
			WebMapService wms=WebMapService.getInstance();
			wms.addLayer(countrybean.lmMaps[level].filename);
			wms.setlayerCode(countrybean.lmMaps[level].filename,   countrybean.lmMaps[level].lev_code, countrybean.lmMaps[level].lev_name, countrybean.lmMaps[level].lev_name );
			wms.setlayerLevel(countrybean.lmMaps[level].filename,   level );
			wms.setConnection(countrybean.lmMaps[level].filename,   con );
			moShape=wms.getlayerMapObject(countrybean.lmMaps[level].filename);
			// map has never been used, force load!!
			if (moShape.lArcs.size()==0)
			{   		 	
				BufferedImage buffImage= new BufferedImage(10, 10, BufferedImage.TYPE_INT_ARGB); //TYPE_INT_BGR); // TYPE_3BYTE_BGR); //TYPE_INT_RGB);
				// Create a graphics object from the image
				Graphics2D graphics = (Graphics2D) buffImage.getGraphics();
				wms.renderLayer(countrybean.lmMaps[level].filename, new MapTransformation(), graphics, 10, 10, cColor, countrybean, null);
			}

		}
		Statement stmt = null;
		ResultSet rset=null;
		try
		{
			stmt = con.createStatement();

			String sSql = "";
			switch (level)
			{
			case 0:
				// max("+countrybean.sqlXmax(countrybean.country.ndbtype)+") as x_max, max(ymax) as y_max, min("+countrybean.sqlXmin(countrybean.country.ndbtype)+") as x_min, min(ymin) as y_min 
				sSql="select r.*, l.lev0_name as DiName, l.lev0_name_en as DiName_en from regiones r,lev0 l where r.codregion=l.lev0_cod ";
				break;
			case 1:
				sSql="select r.*, l.lev1_name as DiName, l.lev1_name_en as DiName_en from regiones r,lev1 l where r.codregion=l.lev1_cod  ";
				break;
			case 2:
				sSql="select r.*, l.lev2_name as DiName, l.lev2_name_en as DiName_en from regiones r,lev2 l where r.codregion=l.lev2_cod  ";
				break;
			}
			if (checkbounds)
				sSql+=" and not ("+countrybean.sqlXmax()+"<"+mt.xminif+
				" or "+countrybean.sqlXmin()+">"+mt.xmaxif+
				" or ymax<"+mt.yminif+" or ymin>" +mt.ymaxif+")"                 ;

			sSql+=" and nivel=" + level;

			if (code.length() > 0)
				sSql += " and r.lev0_cod='" + code + "'";

			rset = stmt.executeQuery("select count(*) as nrecs from ("+sSql+") q");
			int nRecs=0;
			if (rset.next())
				nRecs=rset.getInt("nrecs");
			rset = stmt.executeQuery(sSql);

			Rectangle[] allNames=new Rectangle[nRecs];
			Rectangle notInImage=new Rectangle(0,0,0,0);
			FontMetrics fmt= g2.getFontMetrics(g2.getFont());
			int iRec=0;
			while (rset.next())
			{
				int pointer = ap_sgte = rset.getInt("ap_lista");
				String sName = countrybean.getLocalOrEnglish(rset,"DiName","DiName_en");
				String sCode = rset.getString("codregion");
				if (!bShowNames)
					sName = sCode;   
				Color currColor=g2.getColor();
				//	REVIEW THIS        
				// if (countrybean.nShowIdType>0 || ((level==0 || level<countrybean.level_map) && nRecs<50))  // avoid clutter	
				if (countrybean.nShowIdType>0)
				{
					double xcenter = rset.getDouble("x");
					double ycenter = rset.getDouble("y");

					int lon=fmt.stringWidth(sName)*9/10;   
					int x=mt.xdev(xcenter)-lon/2;
					int y=mt.ydev(ycenter);
					int h=fmt.getHeight()*6/10;
					Rectangle rInImage=new Rectangle(x,y,lon,h);
					// g2.drawRect(x,y,lon,h);
					int i=0;

					boolean bClear=true;
					for (i=0; i<iRec && bClear; i++)
						if (allNames[i].intersects(rInImage))
							bClear=false;

					if (!bClear)
					{
						// tries above
						rInImage.y-=h;
						bClear=true;
						for (i=0; i<iRec && bClear; i++)
							if (allNames[i].intersects(rInImage))
								bClear=false;
						if (!bClear)
						{
							// still intersecting; tries below
							rInImage.y+=h*2;
							bClear=true;
							for (i=0; i<iRec && bClear; i++)
								if (allNames[i].intersects(rInImage))
									bClear=false;
						}
					}					        	
					if (bClear)  // avoid clutter	
					{
						g2.setColor(Color.darkGray);
						g2.drawString(sName, rInImage.x, rInImage.y);
						allNames[iRec]=rInImage;
					}
					else
					{
						g2.setColor(Color.blue);
						g2.drawRect(mt.xdev(xcenter)-2, y-5, 4, 4);
						allNames[iRec]=notInImage;
					}
				}
				iRec++;    
				ap_sgte = pointer;
				if (nTransf==0)
					this.plotRegion(cColor);
				else
				{
					try{
						if (pointer>0){
							ArcObject arco=(ArcObject)moShape.lArcs.get(pointer-1);
							moShape.renderMapObject(g2, cColor, null, countrybean, null, mt, arco, 0);  // SHOW NAMES!
						}
					}
					catch (Exception edraw)
					{
						System.out.println("Error WMS_plot:"+edraw.toString());
					}
				}
				g2.setColor(currColor);

			}
		}
		catch (Exception e)
		{
			System.out.println("Exception plotting: " + e.toString());
		}
		finally
		{
			try{
				if (rset!=null) rset.close();
				if (stmt!=null) stmt.close();
			}
			catch (Exception e)
			{

			}
		}

	}


	/**
	 * Expands & plots an area in certain level. If level=0, normally all areas are plotted. 
	 * @param level level to be drawn
	 * @param code  parent code of areas to be drawn
	 */
	public BufferedImage  plotSelected(String code, int level, double xm, double ym, double xx, double yy, BufferedImage buffImage)
	{

		Statement stmt=null;
		ResultSet rset=null;
		try
		{

			//  Get map extents 
			mt.xminif = xm;
			mt.yminif = ym;
			mt.xmaxif = xx;
			mt.ymaxif = yy;
			mt.setTransformation();

			int nTransf=0;
			Color cColor=Color.darkGray;
			if (countrybean.lmMaps[level]!=null)
			{
				nTransf=countrybean.extendedParseInt(countrybean.lmMaps[level].filetype);
				cColor=new Color(countrybean.lmMaps[level].color_red,countrybean.lmMaps[level].color_green,countrybean.lmMaps[level].color_blue);	  
			}

			MapObject moShape=null;
			if (nTransf==1)
			{
				WebMapService wms=WebMapService.getInstance();
				moShape=wms.getlayerMapObject(countrybean.lmMaps[level].filename);
			}
			//System.out.println("Plotting level " + level + " code (" + code + ")");
			String sSql = "select * from regiones where codregion=?";
			pstmt = con.prepareStatement(sSql);
			pstmt.setString(1,code);

			// System.out.println("Getting all elements. sql= select * " + sSql);
			rset = pstmt.executeQuery();
			while (rset.next())
			{
				int pointer = ap_sgte = rset.getInt("ap_lista");
				xm = rset.getDouble(countrybean.sqlXmin());
				ym = rset.getDouble("ymin");
				xx = rset.getDouble(countrybean.sqlXmax());
				yy = rset.getDouble("ymax");
				//double xcenter = (xm+xx)/2;
				//double ycenter = (ym+yy)/2;

				if (nTransf==0)
				{
					fillRegion(Color.yellow); 
					ap_sgte = pointer;
					plotRegion(cColor);
				}
				else
				{
					ArcObject arco=(ArcObject)moShape.lArcs.get(pointer-1);
					moShape.renderMapObject(g2, cColor, Color.yellow, countrybean, null, mt, arco, 0);  // SHOW NAMES!
				}
			}
			rset.close();
			pstmt.close();
			// base x
			int ixm=Math.max(0,mt.xdev(xm));
			// maximum width
			int iw=Math.min(mt.xdev(xx)-ixm,(int)mt.xresolution);
			// base y
			int iym=mt.ydev(yy);
			// maximum height
			int ih=Math.min(Math.abs(iym-mt.ydev(ym)),(int) mt.yresolution);
			iym=Math.max(0,iym);
			BufferedImage retBuffImage=buffImage.getSubimage(ixm,iym,iw,ih);
			return retBuffImage;
		}
		catch (Exception e)
		{
			System.out.println("Exception plotting Selected: " + e.toString());
		}
		finally
		{
			try
			{
				rset.close();
				stmt.close();
			}
			catch (Exception ex)
			{
			}
		}
		return buffImage;
	}




	public void plotAll()
	{
		try
		{
			long fSize = f_arc.length();
			int nRecs = (int) fSize / 41;

			f_arc.seek(0);
			readArc();
			g2.setColor(Color.blue);
			for (int j = 0; j < nRecs; j++)
			{
				readArc();
				// System.out.println("type=" + tipo + " pointer=" + ap_descripcion + " tamaño=" + tamano + " pointer2=" + apuntador);
				readCoord();
				devVector();
				plotVector();
			}
		}
		catch (Exception e)
		{
			System.out.println("Exception plotting(All): " + e.toString());
		}
	}

	/**
	 * searches for a suitable file name. resolves the issues with upper and lower cases in 
	 * windows/unix filenames and is fault-tolerant with the code: if no file with the specific
	 * code is found, it will return a file which ends with the suffix
	 * 
	 * @param sBasePath  folder to seaarch
	 * @param sCode   country code
	 * @param suffix  suffix (file type - arco.dat, etc...)
	 * @return the file found
	 */
	private String getMapFileName(String sBasePath, String sCode, String suffix)
	{
		File fDir=new File(sBasePath);
		String[] filename= fDir.list();
		String sName="";
		sCode=sCode.toLowerCase();
		String sIdealName=sCode+suffix;
		for (int j=0; j<filename.length && sName.length()==0; j++)
		{
			if (filename[j].toLowerCase().equals(sIdealName))
				sName=filename[j];
		}			
		for (int j=0; j<filename.length && sName.length()==0; j++)
		{
			if (filename[j].toLowerCase().endsWith(suffix))
				sName=filename[j];
		}
		return sBasePath+ (sName.length()==0?sIdealName:sName);
	}

	// opens all map files and database
	public boolean openMap(DICountry countrybean, Graphics2D g2d, Connection con, int xresolution, int yresolution)
	{
		bHaveMap=true;

		this.g2 = g2d;
		mt.xresolution = xresolution;
		mt.yresolution = yresolution;
		this.con = con;
		this.countrybean = countrybean;
		String sFolder = countrybean.country.sjetfilename;
		sCountryCode = countrybean.getCountrycode();

		hashv = new ArrayList[ (int) xresolution + 4];
		for (int i = 0; i <= xresolution; i++)
			hashv[i] = null;

		mt.xminif = -180;
		mt.yminif = -85;
		mt.xmaxif = 180;
		mt.ymaxif = 85;

		try
		{
			int nTransf=0;
			if (countrybean.lmMaps[0]!=null) // default DI map with scaling by 10000 transformation... TODO: check transf type
				nTransf=countrybean.extendedParseInt(countrybean.lmMaps[0].filetype);
			if (nTransf==0)
			{
				if (!sFolder.endsWith("/"))
					sFolder += "/";
				// opens the window textfile
				String sFileName = getMapFileName(sFolder, sCountryCode, "vent.txt");
				BufferedReader f_win=null;
				try{
					f_win = new BufferedReader(new FileReader(sFileName));
					String sVent = f_win.readLine();
					int pos = sVent.indexOf(",");
					mt.xminif = Double.parseDouble(sVent.substring(0, pos));
					sVent = sVent.substring(pos + 1);
					pos = sVent.indexOf(",");
					mt.yminif = Double.parseDouble(sVent.substring(0, pos));
					sVent = sVent.substring(pos + 1);
					pos = sVent.indexOf(",");
					mt.xmaxif = Double.parseDouble(sVent.substring(0, pos));
					sVent = sVent.substring(pos + 1);
					mt.ymaxif = Double.parseDouble(sVent);
				}
				catch (Exception e)
				{

				}
				finally
				{
					try {f_win.close();} catch (Exception e2){}
				}
				try
				{
					sFileName = getMapFileName(sFolder , sCountryCode , "arco.dat");
					f_arc = new RandomAccessFile(sFileName, "r");
					sFileName = getMapFileName(sFolder , sCountryCode , "coor.dat");
					f_coo = new RandomAccessFile(sFileName, "r");
					sFileName = getMapFileName(sFolder , sCountryCode , "list.dat");
					f_lis = new RandomAccessFile(sFileName, "r");     	  
				}
				catch (Exception e)
				{

				}
			}
			mt.setTransformation(mt.xminif,mt.yminif,mt.xmaxif,mt.ymaxif);

		}
		catch (Exception e)
		{
			bHaveMap=false;
			System.out.println("Exception opening: " + e.toString());
		}

		return bHaveMap;
	}

	public void close()
	{
		try
		{
			f_arc.close();
			f_lis.close();
			f_coo.close();
		}
		catch (Exception e)
		{
			// Ignore, this is the usual case.... after implementing WebMapService System.out.println("Exception CLOSING: " + e.toString());
		}

	}

	// generates a boundary map
	// fills a region with a color
	// closes a map database and files, release all objects
	// TEST & RESEARCH STUBS:

	/**----------------------------------------------------------------------------
  // Gets the data required for the chars from the DB, and
  // creates the vectors and parameters required by the chartServer object
  //----------------------------------------------------------------------------*/
	public HashMap<String, Double> CreateData(DICountry countrybean)
	{
		String sSql = "";
		String grouper = "level1"; // histogram grouper

		HashMap<String, Double> htReturn = new HashMap<String, Double>();
		ArrayList<String> sqlparams=new ArrayList<String>();

		// create the required SQL for the specific graph.
		String sVar="";
		String sV=countrybean.sExtractVariable(countrybean.asVariables[0]);
		String sPlus="";
		for (int k = 0; k < countrybean.asVariables.length; k++)
		{
			sV=countrybean.sExtractVariable(countrybean.asVariables[k]);
			if (sV.startsWith("DA_"))  // level attribute..
				sVar += sPlus+"max(" + countrybean.sReplaceFormula(sV)+ ")";
			else
				sVar += sPlus+"sum(0.0+" + countrybean.sReplaceFormula(sV)+ ")";
			sPlus="+";
		}


		grouper = "level"+countrybean.level_map;
		sSql = "Select " + sVar + " as n_sum," + grouper + " as grouper " +countrybean.getWhereSql(sqlparams) + " group by " + grouper; 
		//System.out.println("SQL=" + sSql);
		addToHashMap(sSql, sqlparams, htReturn);

		if (countrybean.dissagregate_map>0)
			if (countrybean.level_map == 2)
			{
				// artificially disaggregates upper level0
				String sChild="select lev1_lev0 as lev0_cod, sum(1) as nChild from lev2, lev1 where lev2_lev1=lev1_cod  group by lev1_lev0";
				sSql = "Select " + sVar + " as n_sum0, level0 " +countrybean.getWhereSql(sqlparams) + " and (level1 is null or level1='')  and (level2 is null or level2='')  group by level0";      
				sSql= "Select n_sum0*1.0/nChild as n_sum, lev2_cod as grouper from lev2, lev1,("+sChild+") c, ("+sSql+") s where lev0_cod=lev1_lev0 and lev1_cod=lev2_lev1 and level0=lev1_lev0 and nChild>0";
				//System.out.println("SQL=" + sSql);
				addToHashMap(sSql, sqlparams, htReturn);

				// artificially disaggregates upper level1
				sChild="select lev2_lev1 as lev1_cod, sum(1) as nChild from lev2  group by lev2_lev1";
				sSql = "Select " + sVar + " as n_sum0, level1 " +countrybean.getWhereSql(sqlparams) + " and (level2 is null or level2='') and (level1 is not null)  group by level1";      
				sSql= "Select n_sum0*1.0/nChild as n_sum, lev2_cod as grouper from lev2,("+sChild+") c, ("+sSql+") s where lev1_cod=lev2_lev1 and level1=lev2_lev1 and nChild>0";
				//System.out.println("SQL=" + sSql);
				addToHashMap(sSql, sqlparams, htReturn);

			}
			else if (countrybean.level_map == 1)
			{
				String sChild="select lev1_lev0 as lev0_cod, sum(1) as nChild from lev1  group by lev1_lev0";
				sSql = "Select " + sVar + " as n_sum0, level0 " +countrybean.getWhereSql(sqlparams) + " and (level1 is null or level1='')  group by level0";      
				sSql= "Select n_sum0*1.0/nChild as n_sum, lev1_cod as grouper from lev1,("+sChild+") c, ("+sSql+") s where lev0_cod=lev1_lev0 and level0=lev1_lev0 and nChild>0";
				//System.out.println("SQL=" + sSql);
				addToHashMap(sSql, sqlparams, htReturn);  	  
			}



		return htReturn;
	}

	/**
	 * @param sSql
	 * @param htReturn
	 */
	private void addToHashMap(String sSql, ArrayList<String> sqlparams, HashMap<String, Double> htReturn) 
	{
		String sPlus;
		PreparedStatement pstmt=null;
		ResultSet rset=null;
		try
		{
			pstmt=con.prepareStatement(sSql);
			for (int k=0; k<sqlparams.size(); k++)
						pstmt.setString(k+1, (String)sqlparams.get(k));
			rset=pstmt.executeQuery();
			double d=0;
			while (rset.next())
			{
				d=rset.getDouble("n_sum");
				sPlus=rset.getString("grouper");
				if (d!=0 && sPlus!=null)
				{
					Double dD=null;
					if ((dD=htReturn.get(sPlus))==null)
						htReturn.put(sPlus, d);
					else
						htReturn.put(sPlus, d+dD.doubleValue());
				}
			}
		}
		catch (Exception e2)
		{
			System.out.println("DI9: Exception loading thematic data: " + e2.toString());
		}
		finally
		{
			try{rset.close();} catch (Exception e)	{}
			try{pstmt.close();} catch (Exception e)	{}
		}
	}


	/**----------------------------------------------------------------------------
// Gets the data required for the chars from the DB, and
// creates the vectors and parameters required by the chartServer object
//----------------------------------------------------------------------------*/
	public MapObject CreateEvents(DICountry countrybean, Connection con)
	{
		MapObject moSyntheticShape=new MapObject("MAP@"+countrybean.countrycode);
		ArrayList<String> sqlparams=new ArrayList<String>();
		PreparedStatement pstmt=null;
		String sSql="select  latitude,longitude, count(*) as nlocs "+countrybean.getWhereSql(sqlparams)+" and (latitude is not null) and (longitude is not null) group by latitude,longitude";

		ResultSet rset=null;  

		moSyntheticShape.shape_type=moSyntheticShape.AV_Point;
		ArcObject arco=new ArcObject();


		try
		{
			pstmt=con.prepareStatement("select count(*) as npoints from ("+sSql+") q");
			for (int k=0; k<sqlparams.size(); k++)
						pstmt.setString(k+1, (String)sqlparams.get(k));
			rset=pstmt.executeQuery();

			if (rset.next())
			{
				arco.numpoints=rset.getInt(1);
			}
			// WARNING!  this could kill the system 
			int MAXPOINTS=36000;
			arco.numpoints=Math.min(arco.numpoints,MAXPOINTS);
			
			arco.numparts=1;
			arco.parts=new int[2];
			arco.parts[0]=0;
			arco.parts[1]=arco.numpoints;
			arco.xcoo = new double[arco.numpoints];
			arco.ycoo = new double[arco.numpoints];	  	  
			arco.zcoo = new double[arco.numpoints];
			
			// sSql+="order by latitude, longitude";
			pstmt=con.prepareStatement(sSql);
			for (int k=0; k<sqlparams.size(); k++)
						pstmt.setString(k+1, (String)sqlparams.get(k));
			rset=pstmt.executeQuery();
			int i=0;
			while (rset.next() && i<MAXPOINTS)
			{
				arco.xcoo[i]=rset.getDouble("longitude");
				arco.ycoo[i]=rset.getDouble("latitude");
				arco.zcoo[i]=rset.getDouble("nlocs");
				i++;
			}
		}
		catch (Exception e2)
		{
			System.out.println("DI9: Exception loading thematic data: " + e2.toString());
		}
		finally
		{
			try{rset.close();} catch (Exception e)	{}
			try{pstmt.close();} catch (Exception e)	{}
		}

		moSyntheticShape.lArcs.add(arco);
		moSyntheticShape.bLoaded=true;
		moSyntheticShape.bInMemory=true;
		return moSyntheticShape;
	}


	/** java.awt.Color from an HTML color  string #RRGGBB */
	public Color gColorFromString(String strColor)
	{
		int r = 0, g = 0, b = 0;

		if (strColor == null || strColor.length() == 0)
			strColor = "#";
		strColor += "000000";
		try
		{
			r = Integer.parseInt(strColor.substring(1, 3), 16);
		}
		catch (Exception er)
		{}
		try
		{
			g = Integer.parseInt(strColor.substring(3, 5), 16);
		}
		catch (Exception eg)
		{}
		try
		{
			b = Integer.parseInt(strColor.substring(5, 7), 16);
		}
		catch (Exception eb)
		{}
		if (!countrybean.bColorBW)
		{
			r=(r+g+b)/3;
			return new Color(r, r, r);
		}

		return new Color(r, g, b);
	}

	/** java.awt.Color from an HTML color  string #RRGGBB */
	private String BWfromColorString(String strColor)
	{
		int r = 0, g = 0, b = 0;
		String sRet="#000000";

		if (strColor == null || strColor.length() == 0)
			strColor = "#";
		strColor += "000000";
		try
		{
			r = Integer.parseInt(strColor.substring(1, 3), 16);
		}
		catch (Exception er)
		{}
		try
		{
			g = Integer.parseInt(strColor.substring(3, 5), 16);
		}
		catch (Exception eg)
		{}
		try
		{
			b = Integer.parseInt(strColor.substring(5, 7), 16);
		}
		catch (Exception eb)
		{}

		r=(r+g+b)/3;
		if (r<16)
			sRet="#0"+Integer.toHexString(r)+"0"+Integer.toHexString(r)+"0"+Integer.toHexString(r);
		else
		{
			sRet="#"+Integer.toHexString(r)+Integer.toHexString(r)+Integer.toHexString(r);
		}

		return sRet;
	}


	private String getThematicSQL(int level_rep, int level, String[] asSelected)
	{
		String code = "";
		if (asSelected != null)
		{
			String sComma = "(";
			int j = 0;
			for (j = 0; j < asSelected.length; j++)
			{
				code += sComma + "'" + asSelected[j] + "'";
				sComma = ",";
			}
			if (j > 0)
				code += ")";
		}

		String sSql="";      
		switch (level)
		{
		case 0:
			sSql="select r.*, lev0_name as DiName, lev0_name_en as DiName_en from regiones r, lev0 where r.codregion=lev0.lev0_cod  ";
			break;
		case 1:
			sSql="select r.*, lev1_name as DiName, lev1_name_en as DiName_en from regiones r, lev1, lev0  where r.codregion=lev1_cod and lev1_lev0=lev0.lev0_cod  ";
			break;
		case 2:
			sSql="select r.*, lev2_name as DiName, lev2_name_en as DiName_en  from regiones r, lev2, lev1, lev0  where r.codregion=lev2_cod and lev2_lev1=lev1.lev1_cod and lev1_lev0=lev0.lev0_cod ";
			break;
		}

		sSql+=" and r.nivel=" + level;

		if (code.length()>0)
		{
			if (level_rep ==0)
				sSql += " and lev0.lev0_cod in " + code;
			else
				if (level_rep == 1)
					sSql += " and lev1_cod in " + code;
		}


		sSql+=" and not (r."+countrybean.sqlXmax()+"<"+mt.xminif+
		" or r."+countrybean.sqlXmin()+">"+mt.xmaxif+
		" or r.ymax<"+mt.yminif+" or r.ymin>" +mt.ymaxif+")"                 ;

		return sSql;
	}

	/**
	 * Expands & plots an area in certain level. If level=0, normally all areas are plotted.
	 * @param level
	 * @param code
	 */
	void thematic(int level_rep, int level, String[] asSelected, HashMap htData)
	{

		int k = 0;
		Statement stmt = null;
		ResultSet rset=null;
		try
		{

			if (mt.xmaxif==0 && mt.xminif==0)
			{ 
				if (level_rep==0)
					MapUtil.getExtents(level_rep, countrybean.asNivel0, mt, con, countrybean);
				else if (level_rep==1)
					MapUtil.getExtents(level_rep, countrybean.asNivel1, mt, con, countrybean);
			}
			mt.setTransformation();

			int nTransf=0;
			Color cColor=Color.darkGray;
			if (countrybean.lmMaps[level]!=null)
			{
				nTransf=countrybean.extendedParseInt(countrybean.lmMaps[level].filetype);
				cColor=new Color(countrybean.lmMaps[level].color_red,countrybean.lmMaps[level].color_green,countrybean.lmMaps[level].color_blue);	  
			}


			String sSql=getThematicSQL( level_rep, level, asSelected);
			stmt = con.createStatement();
			// System.out.println("Geting Elements, sql=  select * " + sSql);
			rset = stmt.executeQuery(sSql);
			while (rset.next())
			{
				try {
					double dVal = 0;
					int pointer = ap_sgte = rset.getInt("ap_lista");
					String sCode = rset.getString("codregion");
					double xcenter = rset.getDouble("x");
					double ycenter = rset.getDouble("y");
					Double sVal = null;
					if ( (sVal = (Double) htData.get(sCode)) != null)
					{
						dVal = sVal.doubleValue();
						try{
							k=0;
							while ( (k < 10) && (countrybean.asMapRanges[k] < dVal) && (countrybean.asMapRanges[k] > 0))
								k++;                	
						}
						catch (Exception e)
						{
							System.out.println("Exception Thematic-plotting[loop1.1]: " + e.toString());    		  
						}

						// depending on the type of legend, draws a circle, bar or fills the poligon

						try{
							if (countrybean.nMapType == 0)
								fillRegion(gColorFromString(countrybean.asMapColors[k]));
							else if (countrybean.nMapType == 1)
							{
								g2.setColor(gColorFromString(countrybean.asMapColors[k]));
								k++;
								g2.fillOval(mt.xdev(xcenter)-k*2, mt.ydev(ycenter)-k*4,k*8,k*8);
							}
							else if (countrybean.nMapType == 2)
							{
								g2.setColor(gColorFromString(countrybean.asMapColors[k]));
								k++;
								g2.fillRect(mt.xdev(xcenter), mt.ydev(ycenter),10,k*8);
								g2.setColor(Color.black);
								g2.drawRect(mt.xdev(xcenter), mt.ydev(ycenter),10,k*8);
							}       	
						}
						catch (Exception e)
						{
							System.out.println("Exception Thematic-plotting[loop1.2]: " + e.toString());    
							//e.printStackTrace();
						}

					}

				}
				catch (Exception e)
				{
					System.out.println("Exception Thematic-plotting[loop1]: " + e.toString());    		  
				}
			}
			rset = stmt.executeQuery(sSql);
			while (rset.next())
			{
				try{
					double dVal = 0;
					int pointer = ap_sgte = rset.getInt("ap_lista");
					String sName = countrybean.getLocalOrEnglish(rset,"DiName","DiName_en");
					String sCode = rset.getString("codregion");
					double xcenter = rset.getDouble("x");
					double ycenter = rset.getDouble("y");
					ycenter = (rset.getDouble("ymin")+rset.getDouble("ymax"))/2;
					Double sVal = null;
					if ( (sVal = (Double) htData.get(sCode)) != null)
					{
						k = 0;
						dVal = sVal.doubleValue();
						while ( (k < 10) && (countrybean.asMapRanges[k] < dVal) && (countrybean.asMapRanges[k] > 0))
							k++;
						if (countrybean.nShowValueType == 1)
						{
							g2.setColor(Color.black);
							String sValue=countrybean.formatDouble(dVal);
							g2.drawString(sValue , xdevName(xcenter,sName), mt.ydev(ycenter)+(countrybean.nShowIdType>0?12:0));
						}

					}
					if (countrybean.nShowIdType == 2)
					{
						g2.setColor(Color.black);
						int x=xdevName(xcenter,sName);
						int y=mt.ydev(ycenter);
						g2.drawString(sName, x, y);
					}
					else
						if (countrybean.nShowIdType == 1)
						{
							g2.setColor(Color.black);
							g2.drawString(sCode, xdevName(xcenter,sCode), mt.ydev(ycenter));
						}
					ap_sgte = pointer;
					if (ap_sgte>0)
						this.plotRegion(cColor);

				}
				catch (Exception e)
				{
					System.out.println("Exception Thematic-plotting[loop2]: " + e.toString());    		  
				}
			}

		}
		catch (Exception e)
		{
			System.out.println("Exception Thematic-plotting: " + e.toString());
		}
		finally
		{
			try{
				if (rset!=null) rset.close();
				if (stmt!=null) stmt.close();
			}
			catch (Exception e)
			{

			}
		}
	}

	public void plotThematic(int level_rep, int level_map, HashMap htData )
	{
		if (htData==null)
			htData = CreateData(countrybean);

		int nTransf=0;
		if (countrybean.lmMaps[0]!=null) // default DI map with scaling by 10000 transformation... TODO: check transf type
			nTransf=countrybean.extendedParseInt(countrybean.lmMaps[0].filetype);
		if (nTransf==0)
		{
			if (level_rep == 0)
				thematic(level_rep, level_map, countrybean.asNivel0, htData);
			else
				thematic(level_rep, level_map, countrybean.asNivel1, htData);

		}
		else
		{
			if (level_rep==0)
				MapUtil.getExtents(level_rep, countrybean.asNivel0, mt, con, countrybean);
			else if (level_rep==1)
				MapUtil.getExtents(level_rep, countrybean.asNivel1, mt, con, countrybean);
			mt.setTransformation();
			WebMapService wms=WebMapService.getInstance();
			boolean bExists=false;
			wms.addLayer(countrybean.lmMaps[countrybean.level_map].filename);
			wms.setlayerCode(countrybean.lmMaps[countrybean.level_map].filename,   countrybean.lmMaps[countrybean.level_map].lev_code, countrybean.lmMaps[countrybean.level_map].lev_name, countrybean.lmMaps[countrybean.level_map].lev_name );
			wms.setlayerLevel(countrybean.lmMaps[countrybean.level_map].filename,   countrybean.level_map );
			wms.setConnection(countrybean.lmMaps[countrybean.level_map].filename,   con );
			Color cColor=new Color(countrybean.lmMaps[countrybean.level_map].color_red,countrybean.lmMaps[countrybean.level_map].color_green,countrybean.lmMaps[countrybean.level_map].color_blue);
			g2.setStroke(new BasicStroke(Math.max(0.8f,countrybean.lmMaps[countrybean.level_map].line_thickness/100.0f)));
			wms.renderLayer(countrybean.lmMaps[countrybean.level_map].filename, mt, g2, countrybean.xresolution, countrybean.yresolution, cColor, countrybean, countrybean.htData);

		}

	}

	public void getParameters(ServletRequest request)
	{
		countrybean.getMapParameters(request);
	}

	static void main(String args[])
	{
		MapServer ms = new MapServer();
		DICountry countrybean = new DICountry();
		countrybean.country = new country();
		countrybean.countrycode = "CO";
		countrybean.country.sjetfilename = "d:/cd_bases";
		BufferedImage buffImage = new BufferedImage(600, 600, BufferedImage.TYPE_INT_RGB);
		// Create a graphics object from the image
		Graphics2D graphics = (Graphics2D) buffImage.getGraphics();
		graphics.setColor(Color.white);
		graphics.fillRect(0, 0, 600, 600);

		// Declaration of default Dabatase variables available to the page
		boolean bConnectionOK = false;
		dbConnection dbCon = null;
		Connection con = null;
		// now, get a connection to the database
		dbCon = new dbConnection("sun.jdbc.odbc.JdbcOdbcDriver", "jdbc:odbc:inventco", "", "");
		bConnectionOK = dbCon.dbGetConnectionStatus();
		// continue if the database is available and ready
		if (bConnectionOK)
		{
			// Conexion OK!!, go and get the data..
			con = dbCon.dbGetConnection();

			ms.openMap(countrybean, graphics, con, 600, 600);
			ms.plotLevel(0, "", null);
			ms.close();
			dbCon.close();
		}

	}

}
/*
class TextRect{
double xm=0;
double ym=0;
double xx=0;
double yy=0;
}
 */