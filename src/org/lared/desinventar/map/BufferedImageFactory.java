/**
 * 
 */
package org.lared.desinventar.map;

import java.util.*;
import java.awt.*;
import java.awt.image.*;


import org.lared.desinventar.util.DICountry;



/**
 * @author julio serje
 *
 */
public class BufferedImageFactory extends Thread
 {
    private static final int poolsize=64; // lots of small images ready
    private static final int resolution=256;
	private static Stack<BufferedImage>  vPreMadeImages=new Stack<BufferedImage>();

	private static BufferedImageFactory bifInstance=new BufferedImageFactory();
	private static final String aDILocales[]=    {"EN",      "ES",     "PT",     "FR",     "ID",     "IR",     "LA",     "TH"};
	private static final String aSampleStrings[]={"\u0E5B",  "\u0E5B", "\u0E5B", "\u0E5B", "\u0E5B",  "\u0E5B", "\u0ED0","\u0E5B"};
    private static HashMap<String,String> hSampleStrings=new HashMap<String,String>();
    
	private static final String sDefaultFont="SansSerif"; //"Lucida Sans"; //"Tahoma";
    
	// every 60 seconds..
	int nDelayBetweenProcess = 60000;
	static boolean bRunning=false;
	
		
	private BufferedImageFactory()
	{
		// will start the factory
	}

    public static void initiate()
    {
    	if (!bRunning)
    	{
    		for (int j=0; j<aDILocales.length; j++)
    			hSampleStrings.put(aDILocales[j], aSampleStrings[j]);
    		bRunning=true;
    		bifInstance.start();
    	}
    }
	
	public void run() 
	{
		while (bRunning) {
			//       else
			try {
				// waits a bit  before looking again...
				sleep(nDelayBetweenProcess);
				while (vPreMadeImages.size()<poolsize)
				{
					BufferedImage buf=buildOneMore(resolution, resolution);	
					vPreMadeImages.push(buf);
					//System.out.println("Adding  image to pool");
				}
				
			} catch (Exception interrupted) {
			}
		}
	}

	public static BufferedImageFactory getFactoryInstance()
	{
		return bifInstance;
	}

	public void returnImageToFactory(BufferedImage buf)
	{
		// just makes sure is of the right size to put it back in the stack
		if (buf.getHeight()==resolution && buf.getWidth()==resolution)
			{
			vPreMadeImages.add(buf);
			//System.out.println("Returning  image to pool");
			}
	}
	
	public static String setGraphicsEnvironment(Graphics2D environment, String unicodeFont)
	{
		return setGraphicsEnvironment(environment, unicodeFont, "th");
	}
	public static String setGraphicsEnvironment(Graphics2D environment, String unicodeFont, String sLang)
	{
	// now always 
	unicodeFont=null;
	
	for (int j=0; j<aDILocales.length; j++)
		hSampleStrings.put(aDILocales[j], aSampleStrings[j]);

	String thai_sample = hSampleStrings.get(sLang);
	if (thai_sample==null)
		thai_sample="\u0E5B"; // thai support.  "\u0ED0"; // LAO support. Later: "\uFA0B";  // this is a pretty high unicode char...
			
	// as the process of finding a Font with intl chars is slow, most of it is concentrated here
	if (unicodeFont==null)
		{
		GraphicsEnvironment ge= GraphicsEnvironment.getLocalGraphicsEnvironment(); 
		try
			{
			// verifies the Default font exists. If not, then just puts Arial or Tahoma.
			String[] arrFonts=ge.getAvailableFontFamilyNames();
			// first looks for an installed Default Font.
			int j=0;
			while (j<arrFonts.length && unicodeFont==null){
				if (arrFonts[j].equalsIgnoreCase(sDefaultFont))
					unicodeFont=arrFonts[j];
				j++;
				}
			if (unicodeFont==null)
				unicodeFont="Arial";
			boolean bCannotDisplayAllChars=false;
			Font fFont=new Font(unicodeFont,Font.PLAIN ,12);
			for (int k=0; k<thai_sample.length(); k++)
				if (!fFont.canDisplay(thai_sample.charAt(k))) 
					bCannotDisplayAllChars=true;
			if (bCannotDisplayAllChars)
				unicodeFont=null;
			// if DefaultFont is not installed looks for whatever is suitable...
			if (unicodeFont==null){
					Font[] allfonts = ge.getAllFonts();
					// for (j = 0; j < allfonts.length && unicodeFont==null; j++) {
					for (j = 0; j < allfonts.length; j++) {
					    if (allfonts[j].canDisplay(thai_sample.charAt(0))) { 
					    	unicodeFont=allfonts[j].getFontName();
					    }
				  	}
				}
			}
		catch (Exception ex){/*do nothing*/}
		// System.out.println("Unicode font detected:"+unicodeFont);

		}
    // lets the operating system decide which would be the closer font to default...
	if (unicodeFont==null)
		unicodeFont=sDefaultFont;
	return unicodeFont;
	}

    public  static String setBasicGraphicProperties(Graphics2D graphics, String sLang)
    {
	    // Set basic properties
		HashMap<Object,Object> mHints=new HashMap<Object,Object>();
	    mHints.put(RenderingHints.KEY_ANTIALIASING,RenderingHints.VALUE_ANTIALIAS_ON);
	    mHints.put(RenderingHints.KEY_RENDERING ,RenderingHints.VALUE_RENDER_QUALITY);
	    graphics.setRenderingHints(mHints);
	    String unicodeFont=setGraphicsEnvironment(graphics, null, sLang);	  	
		// Enable by default the Unicode font
		Font fFont=new Font(unicodeFont,Font.PLAIN ,10);
		graphics.setFont(fFont);
		return unicodeFont;
    }
	private BufferedImage buildOneMore(int xresolution, int yresolution)
	{
	    // Create the in-memory image
	    BufferedImage buffImage=new BufferedImage(xresolution, yresolution, BufferedImage.TYPE_INT_ARGB); 
	    // Create a graphics object from the image
	    Graphics2D graphics = (Graphics2D) buffImage.getGraphics();

	    // this component is designed to produce transparent thematic map images for the WMS
    	graphics.setComposite(AlphaComposite.getInstance(AlphaComposite.CLEAR, 1.0f));
    	// this will be the transparent color
	    graphics.setColor(Color.white);
	    graphics.fillRect(0,0,xresolution,yresolution);

	    graphics.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, 0.4f));

	    
		return buffImage;

	}

	
	public BufferedImage getBufferedImage(int xresolution, int yresolution)
	{
		BufferedImage buf=null;
		
		if (xresolution!=resolution || yresolution!=resolution)
			buf=buildOneMore(xresolution, yresolution);
		else
			if (vPreMadeImages.size()>0)
			{
				buf=vPreMadeImages.pop();
			    Graphics2D graphics = (Graphics2D) buf.getGraphics();
			    // this component is designed to produce transparent thematic map images for the WMS
		    	graphics.setComposite(AlphaComposite.getInstance(AlphaComposite.CLEAR, 1.0f));
		    	// white will be the transparent color
			    graphics.setColor(Color.white);
			    graphics.fillRect(0,0,resolution,resolution);
			}
			else buf=buildOneMore(xresolution, yresolution);
		
		if (!bRunning)
			initiate();

		return buf;
	}
	
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// main method stub

	}

}
