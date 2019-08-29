package org.lared.desinventar.chart;

/**
 * <p>Title: DesInventar WEB Version 6.1.2</p>
 * <p>Description: On Line Version of DesInventar/DesConsultar 6.</p>
 * <p>Copyright: Copyright (c) 2002  La  Red.</p>
 * <p>Company: La Red -  La Red de Estudios Sociales en Prevenci�n de Desastres en Am�rica Latina</p>
 * @author Julio Serje
 * @version 1.0
 */

public interface chartConstants
{
  // Chart modes
  public final int BARTYPE = 1;         //                  1-bar,
  public final int LINETYPE = 2;        //                  0-line,
  public final int PIETYPE = 3;         //                  2-Pie,
  public final int XYTYPE = 4;          //                  3-X-Y plot,
  public final int SCATTERYPE = 5;      //                  2-Scatter chart,
  // Chart submodes
  public final int NORMAL = 0;          //                  0- NORMAL
  public final int STACKBARTYPE = 1;    //                  1-stacked bar,
  public final int CUMMULATIVE = 2;     //                  2-cummulative

  // Chart types
  public final int HISTOGRAM= 1;        //                  0-line,
  public final int EVENT_HISTOGRAM = 2; //                  1-bar,
  public final int GEO_HISTOGRAM = 3;   //                  2-Pie,
  public final int SEASON_HISTOGRAM=4;  //                  3-seasonal histogram
  public final int EVENT_COMPARISON=5;  
  public final int GEO_COMPARISON=6;    
  public final int CAUSE_COMPARISON=7;  
  public final int CAUSE_HISTOGRAM=8;   
  public final int VARIABLE_HISTOGRAM=9;
  public final int DISTRIBUTION_HISTOGRAM=10;
  public final int LOSS_EXCEEDANCE_CURVE=11;

  // periods
  public final int YEAR=1;
  public final int MONTH=2;
  public final int WEEK=3;
  public final int DAY=4;

  // seasons
  public final int CENTURY=1;
  public final int DECADE=2;
  public final int QUINQUENIAL=3;
  public final int YEAR_S=4;
  public final int MONTH_S=5;

  // Axis Font Size
  public final int AXIS_FONT_SIZE=10;
 
  // max color set size
  public final int MAXCOLORS=10;
	

}