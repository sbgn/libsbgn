package org.sbgn;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashSet;
import java.util.Set;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.Namespace;
import org.jdom.input.SAXBuilder;
import org.jdom.output.XMLOutputter;

public class ConvertMilestone2to3
{
	static Namespace M2 = Namespace.getNamespace("http://sbgn.org/libsbgn/0.2");
	static Namespace M3 = Namespace.getNamespace("http://sbgn.org/libsbgn/0.3");
	
	public static void convert(File in, File out) throws JDOMException, IOException
	{
		SAXBuilder builder = new SAXBuilder();
		Document doc = builder.build(in);

		Element elt = doc.getRootElement();
		
		// fix 1: recursively change namespace
		recursivelyChangeNamespace(elt);
		
		
		// fix 2: add id attribute
		ConvertMilestone2to3 converter = new ConvertMilestone2to3();
		converter.buildIdList(elt);
		elt.getChild("map", M3).setAttribute("id", converter.generateId("map"));

		// done, store result.
		XMLOutputter xo = new XMLOutputter();
		xo.output(doc, new FileWriter(out));
	}

	Set<String> existingIds = new HashSet<String>();
	
	private void buildIdList(Element elt)
	{
		String id = elt.getAttributeValue("id");
		if (id != null) 
		{
			existingIds.add(id);
		}
		
		for (Object o : elt.getChildren())
		{
			buildIdList((Element)o);
		}
		
	}

	int nextId = 0;
	
	private String generateId (String prefix)
	{
		String val;
		do
		{
			val = prefix + String.format("%06x", nextId);
			nextId++;
		} while (existingIds.contains(val));
		
		return val;
	}
	
	private static void recursivelyChangeNamespace(Element elt)
	{
		elt.setNamespace(M3);
		for (Object o : elt.getChildren())
		{
			recursivelyChangeNamespace((Element)o);
		}
	}

	/**
	 * Class can be used as utility to convert a single file
	 * @throws IOException 
	 * @throws JDOMException 
	 */
	public static void main(String [] args) throws JDOMException, IOException
	{
		if (args.length != 2)
		{
			System.err.println ("Expected two arguments: in-file and out-file.");
			System.exit(1);
		}
		else
		{
			File fin = new File (args[0]);
			File fout = new File (args[1]);
			convert (fin, fout);
		}
	}
}
