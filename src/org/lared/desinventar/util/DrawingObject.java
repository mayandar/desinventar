package org.lared.desinventar.util;

import java.io.Serializable;

public class DrawingObject implements Serializable {
	
public final int DI_TEXT=0;
public final int DI_LINE=1;
public final int DI_CIRCLE=2;
public final int DI_LEGEND=3;
public final int DI_IMAGE=4;
public final int DI_ARROW=4;

public final int DI_CONTINOUS=0;
public final int DI_DOTTED=1;
public final int DI_DASHED=2;
public final int DI_DOTDASHED=4;

public int nObjectType=0;
public float x1_object=0;
public float y1_object=0;
public float x2_object=0;
public float y2_object=0;
public float x3_object=0;
public float y3_object=0;
public String sText="";
public String sFont="Arial";
public String sColor="#000000";
public int nLineType=0;
public String sFillColor="";
public int nStroke=1;
public int nSize=12;
}
