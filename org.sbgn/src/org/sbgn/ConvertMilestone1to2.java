package org.sbgn;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashSet;
import java.util.Set;

import org.jdom2.Document;
import org.jdom2.Element;
import org.jdom2.JDOMException;
import org.jdom2.Namespace;
import org.jdom2.input.SAXBuilder;
import org.jdom2.output.XMLOutputter;

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
		XmlUtil.replaceNamespace(elt, M1, M2, false);
		
		// fix 2: add language attribute
		elt.getChild("map", M2).setAttribute("language", "process description");
		
		// fix 3: add id to arcs.
		ConvertMilestone1to2 converter = new ConvertMilestone1to2();
		converter.buildIdList(elt);
		converter.addArcIds(elt);
		
		// fix 4: convert class stoichiometry to cardinality
		recursivelyChangeStoichiometry(elt);

		// done, store result.
		XMLOutputter xo = new XMLOutputter();
		FileOutputStream outputStream = new FileOutputStream(out);
		xo.output(doc, outputStream);
		outputStream.close();
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
	
	private void addArcIds(Element elt)
	{
		if ("arc".equals (elt.getName()))
		{
			if (elt.getAttributeValue("id") == null)
			{
				String newId = generateId("arc");
				existingIds.add(newId);
				elt.setAttribute("id", newId);
			}
		}
		else
		{
			for (Object o : elt.getChildren())
			{
				addArcIds((Element)o);
			}
		}
	}
	
	private static void recursivelyChangeStoichiometry(Element elt)
	{
		if ("stoichiometry".equals (elt.getAttributeValue("class")))
			elt.setAttribute("class", "cardinality");

		for (Object o : elt.getChildren())
		{
			recursivelyChangeStoichiometry((Element)o);
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
