package org.lared.desinventar.chart;

import java.awt.*;
import java.awt.image.*;
import java.io.*;
import java.text.DecimalFormat;

import org.lared.desinventar.map.BufferedImageFactory;
import org.lared.desinventar.util.DICountry;
import org.lared.desinventar.util.PngEncoder;
import org.lared.desinventar.util.PngEncoderB;
import org.lared.desinventar.webobject.webObject;


import org.jfree.chart.*;
import org.jfree.chart.axis.CategoryAxis;
import org.jfree.chart.axis.CategoryLabelPositions;
import org.jfree.chart.axis.LogAxis;
import org.jfree.chart.axis.LogarithmicAxis;
import org.jfree.chart.axis.NumberAxis;
import org.jfree.chart.axis.ValueAxis;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.plot.PiePlot;
import org.jfree.chart.plot.PiePlot3D;
import org.jfree.chart.plot.Plot;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.plot.XYPlot;
import org.jfree.chart.renderer.category.BarRenderer;
import org.jfree.chart.renderer.category.GroupedStackedBarRenderer;
import org.jfree.chart.renderer.category.LineAndShapeRenderer;
import org.jfree.chart.renderer.xy.XYLineAndShapeRenderer;
import org.jfree.chart.util.LogFormat;
import org.jfree.data.*;
import org.jfree.data.category.DefaultCategoryDataset;
import org.jfree.data.general.*;
import org.jfree.data.xy.XYSeries;
import org.jfree.data.xy.XYSeriesCollection;
import org.jfree.ui.GradientPaintTransformType;
import org.jfree.ui.StandardGradientPaintTransformer;
import org.jfree.util.Rotation;


import java.text.FieldPosition;



public class ChartServer implements chartConstants
{

	int maxCharHeight = 15;
	int minFontSize = 6;
	

	Color bg = Color.white;
	Color fg = Color.black;
	Color red = Color.red;
	Color white = Color.white;

	String sDefaultFont="SansSerif";
	String unicodeFont=null;

	Dimension totalSize;

	OutputStream out;

	//----------------------------------------------------------------------------
	// interface variables
	//----------------------------------------------------------------------------

	// Graphics context objects
	Graphics2D g2;
	Graphics g;


	//  values to be plotted
	double[] x;                     // x values (x[nPoints])
	double[][] y;                   // multiple sets of y values y[nSet][nPoints]
	Color[]  cSetColor;             // color of each set  cSetColor[nSet]
	String[] sSetLabels;            // label of each set sSetLabel[nSets]
	String[] sLabels;               // label of each value sLabel[nPoints]
	int nPoints=10;                 // number of points
	int nSets=1;                    // number of sets
	String sVariable="";
	String sHorizontalAxisLabel="";

	boolean b3dEffect=true;         // 3d effect on
	boolean bCummulative=false;     // cummulative (stack)
	boolean bBWColor=true;          // colors on on
	boolean bLogarithmicY=false;
	boolean bLogarithmicX=false;
	// custom values of the chart
	Color cLabelColor;              // color for labels
	int nLabelColorType;            // type of coloring method for labels

	double  xMin=0,
	xMax=10,
	yMin=0,
	yMax=500;                 // World boundaries

	double  xcMin=0,
	xcMax=10,
	ycMin=0,
	ycMax=500;              // Chart boundaries

	int     dyMax=500,
	dxMax=800;              // Device boundaries

	double xScale, yScale;
	double xTrans, yTrans;

	// space around the charts
	double dLeftOffset=10.0;        //  left of x=0, to put Y axis coordinates
	double dRightOffset=20.0;       //  right of x=xcMax, tu put set names
	double dLowerOffset=15.0;       //  below y=0, to put X axis legend
	double dUpperOffset=5.0;        //  above y=ycMax, tu put Titles


	int nChartType=1;               // type of chart:
	String sTitle="";
	String sSubTitle="";


	//----------------------------------------------------------------------------
	// number of points in each set
	//----------------------------------------------------------------------------
	public void setNpoints(int nP)
	{
		nPoints=nP;
	}

	//----------------------------------------------------------------------------
	// number of sets
	//----------------------------------------------------------------------------
	public void setNsets(int nS)
	{
		nSets=nS;
	}


	public void setChartType(int nType)
	{
		nChartType=nType;
	}

	public void setTitle(String sTit)
	{
		sTitle=sTit;
	}

	public void setSubTitle(String sTit)
	{
		sSubTitle=sTit;
	}

	public void set3D(boolean b3d)
	{
		b3dEffect=b3d;         // 3d effect on/off
	}

	public void setBWColor(boolean bwc)
	{
		bBWColor=bwc;         // 3d effect on/off
	}

	public void setCum(boolean bCum)
	{
		bCummulative=bCum;         // 3d effect on/off
	}

	
	public void setLogX(boolean bLog)
	{
		bLogarithmicX=bLog;	
	}
	
	public void setLogY(boolean bLog)
	{
		bLogarithmicY=bLog;			
	}
	
	//----------------------------------------------------------------------------
	// get external  vector maximum and minimums to establish Chart boundaries
	//----------------------------------------------------------------------------
	public void getMaxsMins()
	{
		xcMin=x[0];
		xcMax=x[0];
		ycMin=y[0][0];
		ycMax=y[0][0];
		for (int i=0; i<nPoints; i++)
		{
			if (x[i]<xcMin)
				xcMin=x[i];
			if (x[i]>xcMax)
				xcMax=x[i];
			for (int j=0; j<nSets; j++)
			{
				if (y[j][i] < ycMin)
					ycMin = y[j][i];
				if (y[j][i] > ycMax)
					ycMax = y[j][i];
			}

		}
	}



	//----------------------------------------------------------------------------
	// get external  vectors
	//----------------------------------------------------------------------------
	public void setVectors(chartInfo c)
	{

		this.x=c.x;         // x values (x[nPoints])
		this.y=c.y;  // multiple sets of y values y[nSet][nPoints]
		this.cSetColor=c.cSetColor;    // color of each set  cSetColor[nSet]
		this.sSetLabels=c.sSetLabels;  // label of each set sSetLabel[nSets]
		this.sLabels=c.sLabels;   // label of each value sLabel[nPoints]
		this.nSets=c.nSets;
		this.nPoints=c.nPoints;
		this.sVariable=c.sVariable;
		this.sHorizontalAxisLabel=c.sHorizontalAxisLabel;
		
		getMaxsMins();
		if (c.dMaximumY>ycMax)
			ycMax=c.dMaximumY;
		setChartWorld(xcMin, ycMin, xcMax, ycMax);
		setTransformation();
	}


	//----------------------------------------------------------------------------
	// allocates space for vectors
	//----------------------------------------------------------------------------
	public void initVectors()
	{
		x=new double[nPoints+2];         // x values (x[nPoints])
		y=new double[nSets][nPoints+2];  // multiple sets of y values y[nSet][nPoints]
		cSetColor=new Color[MAXCOLORS];    // color of each set  cSetColor[nSet]
		sSetLabels=new String[nSets];  // label of each set sSetLabel[nSets]
		sLabels=new String[nPoints+2];   // label of each value sLabel[nPoints]
	}

	//----------------------------------------------------------------------------
	// calculates the world-to-device transformation matrix
	//----------------------------------------------------------------------------
	public void setTransformation()
	{

		// scaling factor
		xScale=dxMax/(xMax-xMin);
		yScale=dyMax/(yMax-yMin);

		// translation
		xTrans=-xMin * xScale;
		yTrans=dyMax + yMin*yScale;

		// AffineTransform Tx;
		// inverts the axis and translate the origin NOT WORKING AS EXPECTED!!!
		// double m00, double m10, double m01, double m11, double m02, double m12
		// Tx=new AffineTransform(1.0, 0.0, 0.0, -1.0, 0.0, dyMax);
		// g2.setTransform(Tx);

	}

	//----------------------------------------------------------------------------
	// sets the size of the device coordinates
	//----------------------------------------------------------------------------
	public void setDevice(int dxMax, int dyMax)
	{
		this.dxMax=dxMax;
		this.dyMax=dyMax;
		setTransformation();
	}

	//----------------------------------------------------------------------------
	// sets the window of world coordinates
	//----------------------------------------------------------------------------
	public void setWorld(double xMin, double yMin, double xMax, double yMax)
	{
		this.xMax=xMax;
		this.yMax=yMax;
		this.xMin=xMin;
		this.yMin=yMin;
		setTransformation();
	}

	//----------------------------------------------------------------------------
	// sets the window of chart coordinates
	//----------------------------------------------------------------------------
	public void setChartWorld(double xMin, double yMin, double xMax, double yMax)
	{
		double dLeft, dRight, dBelow, dAbove;

		xcMax=xMax;
		ycMax=yMax;
		xcMin=xMin;
		ycMin=yMin;
		// space for Axis, Leyends, etc.
		dLeft=(xcMax-xcMin)/dLeftOffset;            // -> before x=0
		dRight=(xcMax-xcMin)/dRightOffset;          // -> right of x=xcMax
		dBelow=(ycMax-ycMin)/dLowerOffset;         // under Y=0;
		dAbove=(ycMax-ycMin)/dUpperOffset;          // above Y=ycMax

		// sets the final world coordinates
		setWorld(xcMin-dLeft, ycMin-dBelow, xcMax+dRight, ycMax+dAbove);
	}


	//----------------------------------------------------------------------------
	// gets the X device coordinate of user coordinates (world)
	//----------------------------------------------------------------------------
	public int gxdev(double xCoo)
	{
		return (int)((xCoo-xMin)*xScale);
	}

	//----------------------------------------------------------------------------
	// gets the Y device coordinate of user coordinates (world)
	//----------------------------------------------------------------------------
	public int gydev(double yCoo)
	{
		return (int) (dyMax -(yCoo-yMin)*yScale);
	}

	//----------------------------------------------------------------------------
	// specifies the graphics context (object) to draw to
	//----------------------------------------------------------------------------
	public void setContext(Graphics gGraphics)
	{
		// save the graphic context;
		g=gGraphics;
		g2 = (Graphics2D) g;
		g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
	}


	//  regression variables
	double sumxx=0;
	double sumyy=0;
	double sumx = 0;
	double sumy =0 ;
	double Sxx;
	//	regression coefficients
	double a, b;    	

	public void doRegression(int nset, int nresultset)
	{
		sumxx=0;
		sumyy=0;
		sumx = 0;
		sumy =0 ;
		//	regression coefficients
		double a, b;    	
		// get means
		for (int j=0; j<nPoints; j++)
		{
			sumx += x[j];
			sumy += y[nset][j];
		}
		double n = (double)nPoints;
		sumx=sumx/n;
		sumy=sumy/n;
		for (int j=0; j<nPoints; j++)
		{
			Sxx= (x[j]-sumx);
			sumxx += Sxx*(y[nset][j]-sumy);
			sumyy += Sxx*Sxx;
		}

		b =sumxx/sumyy;
		a = sumy-b*sumx;

		//System.out.println("Regression:  a="+a+" , b="+b);
		// yi = a + b*xi
		for (int j=0; j<nPoints; j++)
		{
			y[nresultset][j]= a+ b*x[j];
		}
	}



	//----------------------------------------------------------------------------
	// paints the chart!!!
	//----------------------------------------------------------------------------
	@SuppressWarnings("static-access")
	public void paint(DICountry dicountrybean)
	{
		try
		{
			// The BufferedImage object dimension has to be equal to the Graph object dimension.
			// BufferedImage bi=new BufferedImage(dxMax,dyMax,BufferedImage.TYPE_INT_RGB);

			BufferedImage bi=BufferedImageFactory.getFactoryInstance().getBufferedImage(dxMax, dyMax);
			JFreeChart jChartObject=null;

			if (bi==null)
				System.out.println("CV1: error allocating chart bitmap");

			// Create a graphics object from the image
			Graphics2D ChartGraphics = (Graphics2D) bi.getGraphics();
			// Graphics2D ChartGraphics=bi.createGraphics();
			unicodeFont=BufferedImageFactory.setBasicGraphicProperties(ChartGraphics,dicountrybean.getLanguage());

			getMaxsMins();
			int i=0;


			if(dicountrybean.nChartMode > 0){
				nChartType=dicountrybean.nChartMode;
			} else {
				nChartType=XYTYPE;

			}
			switch (nChartType)
			{
			case LINETYPE:
			case BARTYPE:
				DefaultCategoryDataset line_bar_dataset = new DefaultCategoryDataset();
				int j = 0;
				Color cNo=new Color(0,0,0,0); 
				for (i=0; i<nSets; i++)
					for (j = 0; j < nPoints; j++)
						if(this.sSetLabels[i] != null && this.sLabels[j] != null )
						{
						line_bar_dataset.addValue(y[i][j], this.sSetLabels[i], this.sLabels[j]);
						}
				
				// add regression lines...
				/*  */
				//if (nChartType==LINETYPE && dicountrybean.bRegression){
				if (dicountrybean.bRegression){
					for (i=0; i<nSets; i++)
					{
						for (j = 0; j < nPoints; j++)
							if(this.sSetLabels[i] != null && this.sLabels[j] != null )
							{
								line_bar_dataset.addValue(y[i+nSets][j], this.sSetLabels[i]+"-REGR", this.sLabels[j]);
							}
					}				
				}
								
				if (nChartType==LINETYPE)
					jChartObject = createLineChart(line_bar_dataset, dicountrybean);
				else if(this.bCummulative){
					jChartObject = createStackedBarChart(line_bar_dataset, dicountrybean);             	            	  
				} else
					jChartObject = createBarChart(line_bar_dataset, dicountrybean);             	            	  
				break;

			case XYTYPE:
				jChartObject = createXyChart(dicountrybean);
				
				break;
			case PIETYPE:
				jChartObject = createPieChart(dicountrybean);
				break;

			}

			jChartObject.setBackgroundPaint( Color.white ); 
			bi=jChartObject.createBufferedImage(dxMax,dyMax);


			//  For JAVA2D, a PNG encoder:
			byte[] pngbytes;
			PngEncoderB png =  new PngEncoderB( bi, PngEncoder.ENCODE_ALPHA,	0,2);
			try
			{
				pngbytes = png.pngEncode();
				if (pngbytes == null) {
					System.out.println("MAP: Null image");
				}
				out.write(pngbytes);

			}
			catch (Exception e)
			{
				e.printStackTrace();
			}
			out.close();

		}
		catch (Exception erare)
		{
			System.out.println("Error painting: "+erare.toString()+" ");
			erare.printStackTrace();
		}


	}

	
	
	/**
	 * @return
	 */
	private JFreeChart createXyChart(DICountry dicountrybean) 
	{
		JFreeChart jChartObject;
		int i;
		XYSeriesCollection xy_dataset = new XYSeriesCollection();
		for (i=0; i<nSets; i++)
			{
			XYSeries series = new XYSeries(this.sSetLabels[i]);
			for (int j = 0; j < nPoints; j++)
				series.add(x[j],y[i][j]);
			xy_dataset.addSeries(series);
			}
		jChartObject = ChartFactory.createXYLineChart(
				sTitle, // chart title
				this.sHorizontalAxisLabel, // x axis label
				this.sVariable, // y axis label
				xy_dataset, // data
				PlotOrientation.VERTICAL,
				true, // include legend
				false, // tooltips
				false // urls
				);
		XYPlot plot = (XYPlot) jChartObject.getPlot();
		plot.setBackgroundPaint(Color.white);
		// major grids
		plot.setRangeGridlinePaint(Color.darkGray);
		plot.setRangeGridlinesVisible(true);

		plot.setDomainGridlinePaint(Color.darkGray);
		plot.setDomainGridlinesVisible(true);

		plot.setDomainMinorGridlinePaint(Color.lightGray);
		plot.setDomainMinorGridlinesVisible(true);
		plot.setRangeMinorGridlinePaint(Color.lightGray);
		plot.setRangeMinorGridlinesVisible(true);

		XYLineAndShapeRenderer renderer = (XYLineAndShapeRenderer)plot.getRenderer();
		for (i=0; i<nSets; i++)
			renderer.setSeriesPaint(i, cSetColor[i % MAXCOLORS]);

		if (this.bLogarithmicY)
			plot.setRangeAxis(setLogarithmicAxisY(plot));			
		
		if (this.bLogarithmicX)
		{
			LogAxis logAxis = new LogAxis(null);
			logAxis.setBase(10.0);
			LogFormat format = new LogFormat(logAxis.getBase(), "", "", true);
			logAxis.setNumberFormatOverride(format);		
			logAxis.setMinorTickMarksVisible(true);
			logAxis.setAutoRange(true);
			logAxis.setTickLabelsVisible(true);
			logAxis.setNumberFormatOverride(
					new DecimalFormat() 
						{
						public StringBuffer format(double number, StringBuffer toAppendTo, FieldPosition pos) 
							{
							
							String sRet=webObject.formatDouble(number,2);
							return toAppendTo.append(sRet);
							}
						});			
			//logAxis.setVerticalTickLabels(true);	
			plot.setDomainAxis(logAxis);			
		}
		else
		{
			NumberAxis axis =(NumberAxis) plot.getDomainAxis();
			axis.setTickLabelsVisible(true);
			axis.setVerticalTickLabels(true);			

		}

		
		
		//axis.setCategoryLabelPositions(CategoryLabelPositions.DOWN_90);
		return jChartObject;
	}

	/**
	 * @param plot
	 */
	private LogAxis setLogarithmicAxisY(Plot plot) 
	{
		LogAxis logAxis = new LogAxis(null);
		logAxis.setBase(10.0);
//		logAxis.setAutoRange(true);
		logAxis.setMinorTickMarksVisible(true);
		logAxis.setTickLabelsVisible(true);
		logAxis.setNumberFormatOverride(
				new DecimalFormat() 
					{
					public StringBuffer format(double number, StringBuffer toAppendTo, FieldPosition pos) 
						{
						String sRet=webObject.formatDouble(number,6);
						return toAppendTo.append(sRet);
						}
					});
		return logAxis;
	}

	/**
	 * @param dicountrybean
	 * @param nMaxLegendWidth
	 * @return
	 */
	private JFreeChart createPieChart(DICountry dicountrybean) 
	{
		JFreeChart jChartObject;
		int nMaxAxisWidth;
		// sets left space to 0:
		nMaxAxisWidth=30;

		// data
		double dTotal=0;
		// first pass, get total
		for (int j = 0; j < nPoints; j++)
		{
			if (y[0][j]>0)
				dTotal+=y[0][j];
		}	
		// second pass, reduces number of values to those up to 2%, creates 'Other' bucket
		int kpie=0;
		double dOtherTotal=0;
		double dThreshold=0.01;
		for (int j = 0; j < nPoints; j++)
		{
			if (y[0][j]>0)
			{
				if (y[0][j]/dTotal>dThreshold)
					kpie++;
				else
					dOtherTotal+=y[0][j];
			}

		}
		if (dOtherTotal>0)
			kpie++;
		kpie=0;

		DefaultPieDataset result = new DefaultPieDataset();

		for (int j = 0; j < nPoints; j++)
			if (y[0][j]/dTotal>dThreshold)
			{
				String sTxt=String.valueOf((int)(y[0][j]*100/dTotal));// dicountrybean.formatDouble(values[kpie]*100/dTotal,-2);
				sTxt=sLabels[j]+"- "+webObject.formatDouble(y[0][j],0)+" ("+sTxt+" %)";
				result.setValue(sTxt,  y[0][j]);
				kpie++;           		
			}
		if (dOtherTotal>0)
		{
			String sTxt=String.valueOf((int)(dOtherTotal*100/dTotal));// dicountrybean.formatDouble(values[kpie]*100/dTotal,-2);
			sTxt=dicountrybean.getTranslation("Other (<1%)")+"- "+String.valueOf((int)dOtherTotal)+" ("+sTxt+" %)";
			result.setValue(sTxt,  dOtherTotal);
			kpie++;           		
		}

		if (b3dEffect){
			jChartObject = ChartFactory.createPieChart3D(
					sTitle,          // chart title
					result,          // data
					false, //true,            // include legend
					false,		   // tooltips
					false);		   // URLs
			PiePlot3D plot = (PiePlot3D) jChartObject.getPlot();
			plot.setBackgroundPaint(Color.white);
			
			if(dicountrybean.bColorBW)
				for (int i=0; i<result.getKeys().size(); i++)
					//renderer.setSeriesPaint(i, cSetColor[i % MAXCOLORS]);
					plot.setSectionPaint(result.getKey(i), new Color(Integer.parseInt(dicountrybean.asChartColors[i % MAXCOLORS].substring(1), 16)));
			else
				for (int i=0; i<result.getKeys().size(); i++)
					//renderer.setSeriesPaint(i, cSetColor[i % MAXCOLORS]);
					plot.setSectionPaint(result.getKey(i), new Color(Integer.parseInt(dicountrybean.asChartBWs[i % MAXCOLORS].substring(1), 16)));

			plot.setStartAngle(270);
			plot.setDirection(Rotation.ANTICLOCKWISE);
			plot.setForegroundAlpha(0.9f);
			plot.setLabelFont(new Font("year",Font.PLAIN, AXIS_FONT_SIZE - 1));
		}
		else {
			jChartObject = ChartFactory.createPieChart(
					sTitle,          // chart title
					result,          // data
					false, //true,            // include legend
					false,		   // tooltips
					false);		   // URLs

			PiePlot plot = (PiePlot) jChartObject.getPlot();
			plot.setBackgroundPaint(Color.white);
			
			if(dicountrybean.bColorBW)
				for (int i=0; i<result.getKeys().size(); i++)
					//renderer.setSeriesPaint(i, cSetColor[i % MAXCOLORS]);
					plot.setSectionPaint(result.getKey(i), new Color(Integer.parseInt(dicountrybean.asChartColors[i % MAXCOLORS].substring(1), 16)));
			else
				for (int i=0; i<result.getKeys().size(); i++)
					//renderer.setSeriesPaint(i, cSetColor[i % MAXCOLORS]);
					plot.setSectionPaint(result.getKey(i), new Color(Integer.parseInt(dicountrybean.asChartBWs[i % MAXCOLORS].substring(1), 16)));

			plot.setStartAngle(270);
			plot.setDirection(Rotation.ANTICLOCKWISE);
			plot.setForegroundAlpha(0.9f);
			plot.setLabelFont(new Font("year",Font.PLAIN, AXIS_FONT_SIZE - 1));
		}
		return jChartObject;
	}

	/**
	 * @param line_bar_dataset
	 * @return
	 */
	private JFreeChart createBarChart(DefaultCategoryDataset line_bar_dataset, DICountry dicountrybean) {
		JFreeChart jChartObject;
		// PlotOrientation.HORIZONTAL
		if (b3dEffect)
			jChartObject = ChartFactory.createBarChart3D(
					sTitle, 
					null,      // domain axis label
					null,    // range axis label
					line_bar_dataset, 
					PlotOrientation.VERTICAL,
					true, false, false ); 	
		else
			jChartObject = ChartFactory.createBarChart(
					sTitle, 
					null,      // domain axis label
					null,    // range axis label
					line_bar_dataset, 
					PlotOrientation.VERTICAL,
					true, false, false ); 	
	
		
		// legend, tooltips, URLs
		CategoryPlot plot = jChartObject.getCategoryPlot();
		BarRenderer renderer = (BarRenderer)plot.getRenderer();
		renderer.setDrawBarOutline(false);
//		renderer.setSeriesPaint(0, new GradientPaint( 0.0f, 0.0f, Color.green, 0.0f, 0.0f, Color.lightGray ));            	         	 
		plot.setBackgroundPaint(Color.white);
		plot.setRangeGridlinePaint(Color.darkGray);
		renderer.setItemMargin(0); // bars with 0 gap
		
		if(dicountrybean.bColorBW)
			for (int i=0; i<nSets; i++)
				//renderer.setSeriesPaint(i, cSetColor[i % MAXCOLORS]);
				renderer.setSeriesPaint(i, new Color(Integer.parseInt(dicountrybean.asChartColors[i % MAXCOLORS].substring(1), 16)));
		else
			for (int i=0; i<nSets; i++)
				//renderer.setSeriesPaint(i, cSetColor[i % MAXCOLORS]);
				renderer.setSeriesPaint(i, new Color(Integer.parseInt(dicountrybean.asChartBWs[i % MAXCOLORS].substring(1), 16)));

		renderer.setDrawBarOutline(false);
		CategoryAxis axis = plot.getDomainAxis();
		/*  */
		Font font = new Font("year",Font.PLAIN, AXIS_FONT_SIZE); //10); //25); //15);
		axis.setTickLabelFont(font);

		axis.setTickLabelsVisible(true);
		axis.setCategoryLabelPositions(CategoryLabelPositions.DOWN_90);

		setTickNiceVisibility(axis);

		if(dicountrybean.bLogarithmicY){
			LogAxis rangeAxis = new LogAxis("");
			rangeAxis.setStandardTickUnits(NumberAxis.createIntegerTickUnits());
			rangeAxis.setBase(10);
			rangeAxis.setSmallestValue(1.0);
			plot.setRangeAxis(rangeAxis);
		}
		return jChartObject;
	}

	/**
	 * @param line_bar_dataset
	 * @return
	 */
	private JFreeChart createStackedBarChart(DefaultCategoryDataset line_bar_dataset, DICountry dicountrybean) {
		JFreeChart jChartObject;
		// PlotOrientation.HORIZONTAL
		if (b3dEffect)
			jChartObject = ChartFactory.createBarChart3D(
					sTitle, 
					null,      // domain axis label
					null,    // range axis label
					line_bar_dataset, 
					PlotOrientation.VERTICAL,
					true, false, false ); 	
		else
			jChartObject = ChartFactory.createBarChart(
					sTitle, 
					null,      // domain axis label
					null,    // range axis label
					line_bar_dataset, 
					PlotOrientation.VERTICAL,
					true, false, false ); 	
        GroupedStackedBarRenderer renderer = new GroupedStackedBarRenderer();
        int gKey = 0;
        KeyToGroupMap map = new KeyToGroupMap("G"+gKey);
        	for(int j = 0; j < nSets; j++){
                map.mapKeyToGroup(""+line_bar_dataset.getRowKey(j), "G"+gKey);
                //map.mapKeyToGroup(""+line_bar_dataset.getColumnKey(i), "G"+j);
        	}
        renderer.setSeriesToGroupMap(map); 
		renderer.setItemMargin(0); // bars with 0 gap
		
		if(dicountrybean.bColorBW)
			for (int i=0; i<nSets; i++)
				//renderer.setSeriesPaint(i, cSetColor[i % MAXCOLORS]);
				renderer.setSeriesPaint(i, new Color(Integer.parseInt(dicountrybean.asChartColors[i % MAXCOLORS].substring(1), 16)));
		else
			for (int i=0; i<nSets; i++)
				//renderer.setSeriesPaint(i, cSetColor[i % MAXCOLORS]);
				renderer.setSeriesPaint(i, new Color(Integer.parseInt(dicountrybean.asChartBWs[i % MAXCOLORS].substring(1), 16)));
		renderer.setDrawBarOutline(false);
		
		CategoryPlot plot = jChartObject.getCategoryPlot();
		plot.setRenderer(renderer);		
		plot.setBackgroundPaint(Color.white);
		plot.setRangeGridlinePaint(Color.darkGray);

		CategoryAxis axis = plot.getDomainAxis();
		/*  */
		Font font = new Font("year",Font.PLAIN, AXIS_FONT_SIZE); //10); //25); //15);
		axis.setTickLabelFont(font);

		axis.setTickLabelsVisible(true);
		axis.setCategoryLabelPositions(CategoryLabelPositions.DOWN_90);
		setTickNiceVisibility(axis);

		if(dicountrybean.bLogarithmicY){
			LogAxis rangeAxis = new LogAxis("");
			rangeAxis.setStandardTickUnits(NumberAxis.createIntegerTickUnits());
			rangeAxis.setBase(10);
			rangeAxis.setSmallestValue(1.0);
			
			plot.setRangeAxis(rangeAxis);
			plot.setRenderer(renderer);		
			plot.setBackgroundPaint(Color.white);
			plot.setRangeGridlinePaint(Color.darkGray);
		}
		
		return jChartObject;
	}

	/**
	 * @param line_bar_dataset
	 * @return
	 */
	private JFreeChart createLineChart(DefaultCategoryDataset line_bar_dataset, DICountry dicountrybean) {
		JFreeChart jChartObject;
			jChartObject=ChartFactory.createLineChart(
					sTitle,
					null,
					null,  //nSets==1?sVariable:null,
					line_bar_dataset,
					PlotOrientation.VERTICAL,true, false, false);
			CategoryPlot plot = (CategoryPlot) jChartObject.getPlot();
			plot.setBackgroundPaint(Color.white);
			plot.setRangeGridlinePaint(Color.darkGray);
			LineAndShapeRenderer renderer = (LineAndShapeRenderer)plot.getRenderer();
			if(dicountrybean.bColorBW)
				for (int i=0; i<nSets; i++)
					//renderer.setSeriesPaint(i, cSetColor[i % MAXCOLORS]);
					renderer.setSeriesPaint(i, new Color(Integer.parseInt(dicountrybean.asChartColors[i % MAXCOLORS].substring(1), 16)));
			else
				for (int i=0; i<nSets; i++)
					//renderer.setSeriesPaint(i, cSetColor[i % MAXCOLORS]);
					renderer.setSeriesPaint(i, new Color(Integer.parseInt(dicountrybean.asChartBWs[i % MAXCOLORS].substring(1), 16)));

			CategoryAxis axis = plot.getDomainAxis();		
			Font font = new Font("year",Font.PLAIN, AXIS_FONT_SIZE); //10); //25); //15);
			axis.setTickLabelFont(font);
			
			setTickNiceVisibility(axis);
			axis.setTickLabelsVisible(true);
			axis.setCategoryLabelPositions(CategoryLabelPositions.DOWN_90);
			if(dicountrybean.bLogarithmicY){
				LogAxis rangeAxis = new LogAxis("");
				rangeAxis.setStandardTickUnits(NumberAxis.createIntegerTickUnits());
				rangeAxis.setBase(10);
				rangeAxis.setSmallestValue(1.0);
				plot.setRangeAxis(rangeAxis);
			}
			
		return jChartObject;
	}

	private void setTickNiceVisibility(CategoryAxis axis) {
		int nMaxClicks=this.dxMax/20;
		int nClicks=nPoints;
		double dSpace=1.0;
		double dCurrent=0;
		int dLast=-1;
		
		if (nClicks>nMaxClicks)
		{
			nClicks=nMaxClicks;
			dSpace=nClicks/(double)nPoints;
		}

		Color cNo= new Color(255,255,255,0);
		Color cYes=Color.black;
		//for (int i=0; i<nSets; i++)
		int i=0;
		for (int j = 0; j < nPoints; j++)
			{
				if(this.sSetLabels[i] != null && this.sLabels[j] != null )
				{
					dCurrent=j*dSpace;
					if (((int)Math.floor(dCurrent))>dLast)
						{
						axis.setTickLabelPaint(this.sLabels[j], cYes);
						dLast=(int)Math.rint(dCurrent);
						}
					else
						axis.setTickLabelPaint(this.sLabels[j], cNo);
					
				}
				
			}
	}


	//----------------------------------------------------------------------------
	// Constructor of the chartServer object
	//----------------------------------------------------------------------------
	public ChartServer(OutputStream outStream)
	{

		nPoints=10;
		nSets=1;
		cSetColor=new Color[MAXCOLORS];
		cSetColor[0] = Color.blue; // color of each set  cSetColor[nSet]
		cSetColor[1] = Color.red;
		cSetColor[2] = Color.green;
		cSetColor[3] = Color.yellow;
		cSetColor[4] = Color.magenta;
		cSetColor[5] = Color.orange;
		cSetColor[6] = Color.cyan;
		cSetColor[7] = Color.pink;
		cSetColor[8] = Color.lightGray;
		cSetColor[9] = Color.yellow;

		out=outStream;
	}



	public static double getNiceMaximum(double dmax)
	{
		double dThreshold=0.1;
		long lmax=(long) dmax;
		dmax=lmax;
		long lnew=lmax;
		String strRep=String.valueOf(lmax);
		int ndigits=strRep.length()-1;
		while ( ndigits>0 && (double)(lnew-lmax)/lmax<dThreshold) // 10% is the threshold..
		{
			if (strRep.charAt(ndigits)!='0')
			{
				if (ndigits==strRep.length()-1)
					lnew=Long.parseLong(strRep.substring(0,ndigits)+"9");
				else
					lnew=Long.parseLong(strRep.substring(0,ndigits)+"9"+strRep.substring(ndigits+1));
				lnew+=Long.parseLong("10000000000000000000".substring(0,strRep.length()-ndigits));
				strRep=String.valueOf(lnew);    				
				if ((double)(lnew-lmax)/lmax<dThreshold) 
					dmax=lnew;
			}
			ndigits--;
			if (dThreshold>0.02)
				dThreshold-=0.02;
		}      	
		return dmax;
	}
	// unit test :  getNiceMaximum
	public static void main (String[] args)
	{
		double[] dmax={347,444,550,8190,9268};
		for (int j=0; j<dmax.length; j++)
			System.out.println(j+" "+dmax[j]+" ->"+getNiceMaximum(dmax[j]));


		for (int k=3; k<10; k++)
			for (int j=0; j<20; j++)
			{
				double scale=Integer.parseInt("10000000000000000000".substring(0,k));
				double rnd=Math.random()*scale;
				System.out.println(j+" "+(long)rnd+" ->"+(long)getNiceMaximum(rnd));
			}
	}
}


