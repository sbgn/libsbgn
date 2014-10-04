package org.sbgn;

import java.io.File;

import javax.xml.bind.JAXBException;

import org.sbgn.SbgnUtil;
import org.sbgn.bindings.Arc;
import org.sbgn.bindings.Glyph;
import org.sbgn.bindings.Map;
import org.sbgn.bindings.Sbgn;

public class ReadExample
{
	public static void main(String[] args) throws JAXBException
	{
		// our sbgnml file goes in "f"
		File f = new File ("../test-files/PD/adh.sbgn");
				
		// Now read from "f" and put the result in "sbgn"
		Sbgn sbgn = SbgnUtil.readFromFile(f);

		// map is a container for the glyphs and arcs 
		Map map = sbgn.getMap();
		
		// we can get a list of glyphs (nodes) in this map with getGlyph()
		for (Glyph g : map.getGlyph())
		{
			// print the sbgn class of this glyph
			System.out.print (" Glyph with class " + g.getId());
			
			// if there is a label, print it as well
			if (g.getLabel() != null)
				System.out.println (", and label " + g.getLabel().getText());
			else
				System.out.println (", without label");
		}

		// we can get a list of arcs (edges) in this map with getArc()
		for (Arc a : map.getArc())
		{
			// print the class of this arc
			System.out.println (" Arc with class " + a.getClazz());
		}
	
	}
}
