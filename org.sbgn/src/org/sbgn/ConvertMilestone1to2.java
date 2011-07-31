package org.sbgn;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.Namespace;
import org.jdom.input.SAXBuilder;
import org.jdom.output.XMLOutputter;

public class ConvertMilestone1to2
{
	static Namespace M1 = Namespace.getNamespace("http://sbgn.org/libsbgn/pd/0.1");
	static Namespace M2 = Namespace.getNamespace("http://sbgn.org/libsbgn/0.2");
	
	public static void convert(File in, File out) throws JDOMException, IOException
	{
		SAXBuilder builder = new SAXBuilder();
		Document doc = builder.build(in);

		Element elt = doc.getRootElement();
		
		// fix 1: recursively change namespace
		recursivelyChangeNamespace(elt);
		
		// fix 2: add language attribute
		elt.getChild("map", M2).setAttribute("language", "process description");
		
		// done, store result.
		XMLOutputter xo = new XMLOutputter();
		xo.output(doc, new FileWriter(out));
	}

	private static void recursivelyChangeNamespace(Element elt)
	{
		elt.setNamespace(M2);
		for (Object o : elt.getChildren())
		{
			recursivelyChangeNamespace((Element)o);
		}
	}
}
