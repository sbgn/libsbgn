package org.sbgn;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.io.StringWriter;
import java.io.Writer;

import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.Namespace;
import org.jdom.input.DOMBuilder;
import org.jdom.input.SAXBuilder;
import org.jdom.output.DOMOutputter;
import org.jdom.output.XMLOutputter;
import org.xml.sax.Attributes;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.helpers.XMLReaderFactory;

public class XmlUtil {

	public static void replaceNamespace(Reader in, Writer out, Namespace n1, Namespace n2, boolean includeAttributes)
			throws JDOMException, IOException {
		replaceNamespace(new InputSource(in), out, n1, n2, includeAttributes);
	}

	public static void replaceNamespace(InputStream in, OutputStream out, Namespace n1, Namespace n2,
			boolean includeAttributes) throws JDOMException, IOException {
		replaceNamespace(new InputSource(in), new OutputStreamWriter(out), n1, n2, includeAttributes);
	}

	public static String getDocumentUri(InputStream is) {
		try {
			return getDocumentUri(new InputSource(InputStreamToReader.inputStreamToReader(is)));
		} catch (IOException e) {
			return null;
		}
	}

	public static String getDocumentUri(InputSource in) {
		in.setEncoding("UTF-8");
		try {
			XMLReader xr = XMLReaderFactory.createXMLReader();
			DefaultHandler handler = new DefaultHandler() {
				@Override
				public void startElement (String uri, String localName, String qName, Attributes attributes) throws SAXException
				{
					throw new SAXException(uri);
				}
			};
			xr.setErrorHandler(handler);
			xr.setContentHandler(handler);
			xr.parse(in);
		
		}
		catch (SAXException e) {			
				if (e.getMessage().startsWith("http"))return e.getMessage();
				return null;
			}
		catch (Exception e) {
			return null;
		}
		return null;
	}

	public static void replaceNamespace(InputSource in, Writer out, Namespace n1, Namespace n2,
			boolean includeAttributes) throws JDOMException, IOException {
		SAXBuilder builder = new SAXBuilder();
		Document doc = builder.build(in);

		Element elt = doc.getRootElement();

		// recursively change namespace
		replaceNamespace(elt, n1, n2, includeAttributes);

		// done, store result.
		XMLOutputter xo = new XMLOutputter();
		xo.output(doc, out);
	}

	public static org.w3c.dom.Element replaceNamespace(org.w3c.dom.Element elt, Namespace n1, Namespace n2,
			boolean includeAttributes) {
		DOMBuilder builder = new DOMBuilder();
		Element doc = builder.build(elt);
		replaceNamespace(doc, n1, n2, includeAttributes);
		DOMOutputter outputter = new DOMOutputter();
		try {
			elt = outputter.output(doc.getDocument()).getDocumentElement();
		} catch (JDOMException e) {
			elt = null;
			e.printStackTrace();
		}
		return elt;
	}

	public static void transformElement(Element elt, IElementTransformer transformer,
			IAttributeTransformer attrTransformer) {
		if (elt == null)
			return;
		if (attrTransformer != null) {
			for (Object attr : elt.getAttributes())
				attrTransformer.transform((org.jdom.Attribute) attr);
		}

		if (transformer != null) {
			transformer.transform(elt);

			for (Object o : elt.getChildren())
				transformElement((Element) o, transformer, attrTransformer);
		}
	}

	public static void replaceNamespace(Element elt, Namespace n1, Namespace n2, boolean includeAttributes) {
		Namespace namespace = elt.getNamespace();
		if (namespace == null || namespace.getURI().isEmpty() || namespace.equals(n1))
			elt.setNamespace(n2);

		for (Object o : elt.getChildren()) {
			replaceNamespace((Element) o, n1, n2, includeAttributes);
		}

		if (!includeAttributes)
			return;

		for (Object o : elt.getAttributes()) {
			org.jdom.Attribute attr = (org.jdom.Attribute) o;
			namespace = attr.getNamespace();

			if (namespace == null || namespace.getURI().isEmpty() || namespace.equals(n1))
				attr.setNamespace(n2);

			if (attr.getName().equals("idlist"))
			attr.setName("idList");
		}

	}

	public static String toString(org.w3c.dom.Element elt) {
		if (elt == null) return null;
		TransformerFactory transFactory = TransformerFactory.newInstance();
		Transformer transformer;
		try {
			transformer = transFactory.newTransformer();
			StringWriter buffer = new StringWriter();
			transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
			transformer.transform(new DOMSource(elt), new StreamResult(buffer));
			return buffer.toString();
		} catch (TransformerConfigurationException e) {
			return null;
		} catch (TransformerException e) {
			return null;
		}
	}

	public static boolean usesDefaultNamespace(org.w3c.dom.Element elt) {		
		return elt.getNodeName().equals(elt.getLocalName());
	}

}
