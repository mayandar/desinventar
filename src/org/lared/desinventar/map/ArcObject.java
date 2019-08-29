package org.lared.desinventar.map;

public class ArcObject {

	public String sCode="";
	public String sName="";
	public String sName_en="";
	public String sParent="";
	public int nLevel=0;
	public double xmin, ymin, xmax, ymax;
	
	public long lArcPointer;
	public int numpoints;
	public int numparts;
	public int rec_num;
	public int rec_len;
	public int shape_type=0;
	public int parts[];
	public double xcoo[];
	public double ycoo[];
	// for synthetic point layers
	public double zcoo[];
	// for coded/named point layers
	public String aCode[];
	public String aName[];
	public String aName_en[];
	
	public ArcObject aNextArc=null;
	
	
	public ArcObject()
	{
		
	}
	
	public ArcObject(ArcObject arc1, ArcObject arc2)
	{
		numparts=arc1.numparts+arc2.numparts;
		parts=new int[numparts+1];
		for (int j=0; j<arc1.numparts; j++)
			parts[j]=arc1.parts[j];
		int i=arc1.numparts;
		for (int j=0; j<arc2.numparts; j++)
			parts[i++]=arc2.parts[j]+arc1.numpoints;
		numpoints=arc1.numpoints+arc2.numpoints;
 	    parts[numparts]=numpoints;
		xcoo=new double [numpoints];
		ycoo=new double [numpoints];
		for (int j=0; j<arc1.numpoints; j++)
			{
			xcoo[j]=arc1.xcoo[j];
			ycoo[j]=arc1.ycoo[j];				
			}
		i=arc1.numpoints;
		for (int j=0; j<arc2.numpoints; j++)
			{
			xcoo[i]=arc2.xcoo[j];
			ycoo[i++]=arc2.ycoo[j];				
			}
		rec_num=arc1.rec_num;
		rec_len=arc1.rec_len;
		shape_type=arc1.shape_type;
			

		sCode=arc1.sCode;
		sName=arc1.sName;
		sName_en=arc1.sName_en;
		sParent=arc1.sParent;
		nLevel=arc1.nLevel;
		xmin=Math.min(arc1.xmin,arc2.xmin);
		ymin=Math.min(arc1.ymin,arc2.ymin);
		xmax=Math.max(arc1.xmax,arc2.xmax);
		ymax=Math.max(arc1.ymax,arc2.ymax);
	
	}
	
}
