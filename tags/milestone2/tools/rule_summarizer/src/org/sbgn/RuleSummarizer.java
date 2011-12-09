package org.sbgn;

import org.apache.velocity.app.Velocity;
import org.apache.velocity.VelocityContext;

import java.io.IOException;
import org.xml.sax.SAXException;

import org.w3c.dom.*;
import javax.xml.parsers.*;
import javax.xml.xpath.*;
import javax.xml.namespace.*;

import java.util.*;
import java.io.*;
import org.xml.sax.InputSource;

/**
 * Summarizes rules into either a HTML or MediaWiki format
 * 
 * @author Augustin Luna
 * 
 */
public class RuleSummarizer {

	/**
	 * @param filePath
	 *            the name of the file to open. Not sure if it can accept URLs
	 *            or just filenames. Path handling could be better, and buffer
	 *            sizes are hardcoded
	 * @return file content as string
	 */
	private static String readFileAsString(String filePath)
			throws java.io.IOException {
		StringBuffer fileData = new StringBuffer(1000);
		BufferedReader reader = new BufferedReader(new FileReader(filePath));
		char[] buf = new char[1024];
		int numRead = 0;
		while ((numRead = reader.read(buf)) != -1) {
			String readData = String.valueOf(buf, 0, numRead);
			fileData.append(readData);
			buf = new char[1024];
		}
		reader.close();
		return fileData.toString();
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) throws ParserConfigurationException,
			SAXException, IOException, XPathExpressionException, Exception {

		String ruleFileName = args[0];
		//Three templates provided: MediaWiki, Trac Wiki, and HTML
		//String templateFileName = "resources/templates/trac_wiki_template.vm";
		//String templateFileName = "resources/templates/media_wiki_template.vm";
		//String templateFileName = "resources/templates/html_template.vm";
		String templateFileName = args[1];
		String outputFileName = args[2];
		
		DocumentBuilderFactory domFactory = DocumentBuilderFactory
				.newInstance();

		// Very important
		domFactory.setNamespaceAware(true);

		DocumentBuilder builder = domFactory.newDocumentBuilder();

		//System.out.println("File" + readFileAsString(file));

		Document doc = builder.parse(new InputSource(ruleFileName));

		//System.out.println("Text" + doc.getTextContent());

		//String currentDir = new File(".").getAbsolutePath();
		//System.out.println("Dir" + currentDir);

		//boolean exists = (new File(file)).exists();
		//System.out.println("Exists" + exists);

		XPathFactory factory = XPathFactory.newInstance();
		XPath xpath = factory.newXPath();

		xpath.setNamespaceContext(new NamespaceContext() {
			public String getNamespaceURI(String prefix) {
				if (prefix.equals("iso")) {
					return "http://purl.oclc.org/dsdl/schematron";
				}

				return null;
			}

			public String getPrefix(String namespaceURI) {
				if (namespaceURI.equals("http://purl.oclc.org/dsdl/schematron")) {
					return "iso";
				}

				return null;
			}

			public Iterator getPrefixes(String namespaceURI) {
				ArrayList<String> list = new ArrayList<String>();

				if (namespaceURI.equals("http://purl.oclc.org/dsdl/schematron")) {
					list.add("iso");
				}

				return list.iterator();
			}
		});

		XPathExpression expr = xpath.compile("//iso:assert");

		Object result = expr.evaluate(doc, XPathConstants.NODESET);
		NodeList nodes = (NodeList) result;
		ArrayList<Element> elementList = new ArrayList<Element>();
		for (int i = 0; i < nodes.getLength(); i++) {
			Element x = (Element) nodes.item(i);
			
			//DEBUG
			//System.out.println("Test: " + x.getAttribute("test"));
			//System.out.println("Value: " + nodes.item(i).getNodeValue());
			//System.out.println("Text: " + nodes.item(i).getTextContent());
			//System.out.println("Name: " + nodes.item(i).getNodeName());
			//System.out.println("Parent Parent Name: "
			//		+ nodes.item(i).getParentNode().getParentNode()
			//				.getNodeName());

			elementList.add(x);
		}
		
		/* Initiate the runtime engine. Defaults are fine. */
		Velocity.init();

		/* Create a Context and the orderedClasses into it */
		VelocityContext context = new VelocityContext();

		context.put("elementList", elementList);

		/* Render a template */
		StringWriter w = new StringWriter();

		Velocity.mergeTemplate(templateFileName, "ISO-8859-1", context, w);
		//System.out.println(w);
		
		BufferedWriter out = new BufferedWriter(new FileWriter(outputFileName));
		out.write(w.toString());
		out.close();
	}
}
