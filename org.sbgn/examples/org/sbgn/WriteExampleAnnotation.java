package org.sbgn;

import org.sbgn.bindings.*;
import org.sbgn.bindings.Glyph.Callout;

import javax.xml.bind.JAXBException;
import java.io.File;

public class WriteExampleAnnotation
{
	public static void main(String[] args) throws JAXBException
	{
		File f = new File ("test-output.sbgn");

		Sbgn sbgn = new Sbgn();

		Map map = new Map();
        map.setLanguage("process description");

		sbgn.setMap(map);

		// create a glyph with an id and class "macromolecule"
        Glyph g1 = new Glyph();
        g1.setId("g1");
        g1.setClazz("macromolecule");

        // create a glyph with an id and class "annotation"
		Glyph g2 = new Glyph();
		g2.setId("g2");
        g2.setClazz("annotation");

        Callout callout = new Callout();
        callout.setTarget(g1);

        Point point = new Point();

        point.setX(160);
        point.setY(200);

        callout.setPoint(point);

        g2.setCallout(callout);

		// add the glyph to the map
		map.getGlyph().add(g1);
        map.getGlyph().add(g2);

		// define the bounding box of the glyph
		Bbox bbox1 = new Bbox();
		bbox1.setX(90);
		bbox1.setY(160);
		bbox1.setW(380);
		bbox1.setH(210);
		g1.setBbox(bbox1);

        // define the bounding box of the annotation
        Bbox bbox2 = new Bbox();
        bbox2.setX(5);
        bbox2.setY(5);
        bbox2.setW(220);
        bbox2.setH(125);
        g2.setBbox(bbox2);

        // define a label for this glyph
		org.sbgn.bindings.Label label1 = new org.sbgn.bindings.Label();
		label1.setText("LABEL");
        g1.setLabel(label1);

        // define a label for this annotation
        org.sbgn.bindings.Label label2 = new org.sbgn.bindings.Label();
        label2.setText("INFO");
        g2.setLabel(label2);

		// now write everything to disk
		SbgnUtil.writeToFile(sbgn, f);
	}
}
