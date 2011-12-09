package org.sbgn;

import java.io.File;
import java.io.IOException;

import javax.xml.bind.JAXBException;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.sbgn.SbgnUtil;
import org.sbgn.bindings.Bbox;
import org.sbgn.bindings.Glyph;
import org.sbgn.bindings.Label;
import org.sbgn.bindings.Map;
import org.sbgn.bindings.SBGNBase.Extension;
import org.sbgn.bindings.Sbgn;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.SAXException;

/**
 * A simple demo to demonstrate the use of the LibSBGN extension capabilities
 */
public class ExtensionDemo
{
	public static void main(String[] args) throws JAXBException, IOException, SAXException, ParserConfigurationException
	{
		ExtensionDemo demo = new ExtensionDemo();
		File f = File.createTempFile("extension-demo", ".sbgn");
		demo.testWrite(f);
		System.out.println (f);
		System.out.println ("Demo file " + (SbgnUtil.isValid(f) ? "validates" : "does not validate"));
		demo.testRead(f);
	}

	private static final String NAMESPACE = "http://www.pathvisio.org/";
	private static final String PREFIX = "pv";
	private static final String LOCALNAME = "xref";
	
	/** 
	 * generate a sample SBGN document with extension data and write it to file
	 */
	private void testWrite(File f) throws ParserConfigurationException, JAXBException
	{
		// set up sample document
		Sbgn sbgn = new Sbgn();
		Map map = new Map();
		map.setLanguage("process description");
		sbgn.setMap(map);
		
		// set up one glyph in this sample document
		Glyph g = new Glyph();
		map.getGlyph().add(g);
		g.setClazz("macromolecule");
		g.setId("g1");
		Label lab = new Label();
		lab.setText("INSR");
		Bbox bbox = new Bbox();
		bbox.setX(100.0f);
		bbox.setY(100.0f);
		bbox.setW(80.0f);
		bbox.setH(40.0f);
		g.setBbox(bbox);
		
		// add extension data
		Extension ext = new Extension();
		
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		DocumentBuilder db = dbf.newDocumentBuilder();
		Document doc = db.newDocument();
		
		Element elt = doc.createElementNS(NAMESPACE, LOCALNAME);
		elt.setPrefix(PREFIX);
		elt.setAttribute("id", "urn:miriam:entrez.gene:3643");
		
		ext.getAny().add(elt);
		
		g.setExtension(ext);
		
		// write document to file
		SbgnUtil.writeToFile(sbgn, f);
	}

	/** 
	 * read sample SBGN document and fetch extension data from it
	 */
	private void testRead(File f) throws JAXBException
	{
		// read the document from file
		Sbgn sbgn = SbgnUtil.readFromFile(f);

		// get the first glyph in the document
		Glyph g = sbgn.getMap().getGlyph().get(0);
		System.out.println("Found glyph with id " + g.getId());
			
		// check that there is an extension
		if (g.getExtension() == null)
		{
			System.err.println ("Could not find extension element");
			return;
		}
		System.out.println (" Found extension");
		
		// get the first element below the extension point.
		//NOTE: there can be more than one, and it's not wise to make assumptions about the ordering of them.
		Element elt = g.getExtension().getAny().get(0);
		System.out.println ("  Found tag " + elt.getNodeName()); 
		if (elt.getNamespaceURI().equals(NAMESPACE) && elt.getLocalName().equals (LOCALNAME))
		{
			System.out.println("Extension contains URI: " + elt.getAttribute("id"));
		}
	}
}
