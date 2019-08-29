package org.lared.desinventar.chart;

import java.awt.*;


/**
 * <p>Title: DesInventar WEB Version 6.1.2</p>
 * <p>Description: On Line Version of DesInventar/DesConsultar 6.</p>
 * <p>Copyright: Copyright (c) 2002  La  Red.</p>
 * <p>Company: La Red -  La Red de Estudios Sociales en Prevenci�n de Desastres en Am�rica Latina</p>
 * @author Julio Serje
 * @version 1.0
 */

public class chartInfo
{

//  values to be plotted
public double[] x = null; // x values (x[nPoints])
public double[][] y = null; // multiple sets of y values y[nSet][nPoints]
public Color[] cSetColor = null; // color of each set  cSetColor[nSet]
public String[] sSetLabels = null; // label of each set sSetLabel[nSets]
public String[] sLabels = null; // label of each value sLabel[nPoints]
public int[] nSets_nPoints;
public String sVariable="";
public String sHorizontalAxisLabel="";

public int nPoints = 10; // number of points
public int nSets = 1; // number of sets
public double dMaximumY=1;
public double dMaximumX=1;
public double dMinimum=0;
public int nyears=30; // for lec's

  public chartInfo()
  {
  }

}