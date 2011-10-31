package org.sbgn.schematron;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.net.URL;
import java.util.List;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.sbgn.Language;
import org.sbgn.SbgnUtil;
import org.sbgn.SbgnVersionFinder;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

public class SchematronValidator 
{
	private SchematronValidator() {} // private to prevent external instantiation
	
	public static List<Issue> validate(File exportedPwFile) 
		throws IOException, ParserConfigurationException, TransformerException, SAXException
	{				
		SchematronValidator stf = new SchematronValidator();
		stf.doValidation(exportedPwFile);
		
		List<Issue> result = stf.getIssues();
		return result;
	}
	
	/**
	 * An ArrayList to store (String) message of successful report found.
	 */
	private List<Issue> issues;

	/**
	 * this does the XSL Transformations on the ruleset and the exported Pathway Object
	 * and then invokes the SAX parser through "parseSVRL" method on the transformation's result.
	 */
	private void doValidation(File inputFile) throws 
			ParserConfigurationException, TransformerException, IOException, SAXException {
		
		System.setProperty("javax.xml.transform.TransformerFactory",
		"net.sf.saxon.TransformerFactoryImpl");
		TransformerFactory factory = new net.sf.saxon.TransformerFactoryImpl();
		
		String res = SbgnUtil.getResource("/iso_svrl_for_xslt2.xsl");
		Transformer transformer1 = factory.newTransformer(new StreamSource(res));
		
		Language lang = SbgnVersionFinder.getLanguage(inputFile);
		String schema = SbgnUtil.getResource("/sbgn_" + lang.name().toLowerCase() + ".sch");
		Source schemaSource = new StreamSource(schema);
		Source inputSource = new StreamSource(inputFile);

		StringWriter sw1 = new StringWriter();
		Result result1 = new StreamResult(sw1);

		transformer1.transform(schemaSource, result1);

		Transformer transformer2 = factory.newTransformer(new StreamSource(
				new StringReader(sw1.toString())));
		StringWriter sw2 = new StringWriter();
		Result result2 = new StreamResult(sw2);
		transformer2.transform(inputSource, result2);
		parseSVRL(removeXMLheader(sw2.toString()));
	}

	/**
	 * removes the first line in the SVRL if it contains XML header i.e
	 * strips the input string of its XML header
	 * @param svrl the SVRL string for which the XML header is to be removed
	 * @return String without the XML header 
	 */
	private String removeXMLheader(String svrl) {

		int firstLineEnd = svrl.indexOf("\n");
		if (svrl.startsWith("<?xml ") || svrl.startsWith("<?xml ", 1)
				|| svrl.startsWith("<?xml ", 2) // Handle Unicode BOM
				|| svrl.startsWith("<?xml ", 3)) {
			return svrl.substring(firstLineEnd + 1);
		} else
			return svrl;
	}

	/**
	 * parses the input SVRL String using the SVRLHandler, results are put into 
	 *  diagnosticReference
	 * @param svrl resultant SVRL String from the XSL Transformations
	 * @throws IOException
	 * @throws SAXException
	 * @throws ParserConfigurationException
	 */
	private void parseSVRL(String svrl) throws IOException, SAXException,
			ParserConfigurationException {

		SVRLHandler handler = new SVRLHandler();
		InputSource is = new InputSource(
				new StringReader(svrl));
		is.setEncoding("UTF-16");
		
		SAXParser saxParser = SAXParserFactory.newInstance().newSAXParser();
		saxParser.parse(is, handler);
		
		issues = handler.getIssues();
	}

	private List<Issue> getIssues()
	{
		return issues;
	}

}
