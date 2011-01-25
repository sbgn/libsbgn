package org.sbgn;

import java.awt.Label;
import java.io.File;

import javax.xml.bind.JAXBException;

import org.sbgn.SbgnUtil;
import org.sbgn.bindings.Bbox;
import org.sbgn.bindings.Glyph;
import org.sbgn.bindings.Map;
import org.sbgn.bindings.Sbgn;

public class WriteExample
{	
	public static void main(String[] args) throws JAXBException
	{
		File f = new File ("test-output.sbgn");
		
		Sbgn sbgn = new Sbgn();		
		Map map = new Map();
		sbgn.setMap(map);
		
		// create a glyph with an id and class "macromolecule"
		Glyph g1 = new Glyph();
		g1.setId("glyph1");
		g1.setClazz("macromolecule");

		// add the glyph to the map
		map.getGlyph().add (g1);

		// define the bounding box of the glyph
		Bbox bbox1 = new Bbox();
		bbox1.setX(125);
		bbox1.setY(60);
		bbox1.setW(100);
		bbox1.setH(40);
		g1.setBbox(bbox1);
		
		// define a label for this glyph
		Label label1 = new Label();
		label1.setText("P53");
		
		// now write everything to disk
		SbgnUtil.writeToFile(sbgn, f);
	}
}
