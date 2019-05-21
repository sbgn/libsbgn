package org.sbgn;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.Reader;
import java.io.StringReader;
import java.io.Writer;
import java.net.URL;
import java.nio.file.StandardCopyOption;

import javax.xml.XMLConstants;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.UnmarshalException;
import javax.xml.bind.Unmarshaller;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;

import org.sbgn.bindings.SBGNBase;
import org.sbgn.bindings.SBGNBase.Extension;
import org.sbgn.bindings.Sbgn;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

public class SbgnUtil {
        /**
         * Read an sbgn file (without validating against the schema)
         * 
         * @param f file to read from
         * @return Sbgn data structure
         * @throws JAXBException if there is an IO error, or the file is not SBGNML.
         */
        public static Sbgn readFromFile(File f) throws JAXBException {
                JAXBContext context = Util.getJAXBContext();
                Unmarshaller unmarshaller = context.createUnmarshaller();

                // Now read from "f" and put the result in "sbgn"
                try {
                        Sbgn result = (Sbgn) unmarshaller.unmarshal(f);
                        return result;
                } catch (JAXBException ex) {
                        try {
                                String docUri = XmlUtil.getDocumentUri(new FileInputStream(f));
                                if (docUri.equals("http://sbgn.org/libsbgn/0.2")) {
                                        File tmp = File.createTempFile("sbgn_m2", "sbgn");
                                        tmp.deleteOnExit();
                                        ConvertMilestone2to3.convert(f, tmp);
                                        return readFromFile(tmp);
                                } else if (docUri.equals("http://sbgn.org/libsbgn/pd/0.1")) {
                                        File tmp = File.createTempFile("sbgn_m1", "sbgn");
                                        tmp.deleteOnExit();
                                        ConvertMilestone1to2.convert(f, tmp);
                                        ConvertMilestone2to3.convert(tmp, tmp);
                                        return readFromFile(tmp);
                                }
                        } catch (Exception e) {
                        }
                        throw ex;
                }
	}


	/**
	 * Read an sbgn file (without validating against the schema)
	 * @param is input stream to read from 
	 * @return Sbgn data structure
	 * @throws JAXBException if there is an IO error, or the file is not SBGNML.
	 */
	public static Sbgn readFrom (InputStream is) throws JAXBException
	{
		JAXBContext context = Util.getJAXBContext();
		Unmarshaller unmarshaller = context.createUnmarshaller();
		
		try {
                        Sbgn result = (Sbgn) unmarshaller.unmarshal(is);
                        return result;
                } catch (JAXBException ex) {
                        try {
                                String docUri = XmlUtil.getDocumentUri(is);
                                if (docUri.equals("http://sbgn.org/libsbgn/0.2")) {
                                        File tmp1 = File.createTempFile("orig_m2", "sbgn");
                                        tmp1.deleteOnExit();
                                        java.nio.file.Files.copy(is, tmp1.toPath(), StandardCopyOption.REPLACE_EXISTING);
                                        
                                        File tmp = File.createTempFile("sbgn_m2", "sbgn");

                                        tmp.deleteOnExit();
                                        ConvertMilestone2to3.convert(tmp1, tmp);
                                        return readFromFile(tmp);
                                } else if (docUri.equals("http://sbgn.org/libsbgn/pd/0.1")) {
                                        File tmp1 = File.createTempFile("orig_m2", "sbgn");
                                        tmp1.deleteOnExit();
                                        java.nio.file.Files.copy(is, tmp1.toPath(), StandardCopyOption.REPLACE_EXISTING);
                                        File tmp = File.createTempFile("sbgn_m1", "sbgn");
                                        tmp.deleteOnExit();
                                        ConvertMilestone1to2.convert(tmp1, tmp);
                                        ConvertMilestone2to3.convert(tmp, tmp);
                                        return readFromFile(tmp);
                                }
                        } catch (Exception e) {                                
                        }
                        throw ex;
                }
	}

	/**
	 * Read an sbgn file (without validating against the schema)
	 * @param r reader to read from 
	 * @return Sbgn data structure
	 * @throws JAXBException if there is an IO error, or the file is not SBGNML.
	 */
	public static Sbgn readFrom (Reader r) throws JAXBException
	{
		JAXBContext context = Util.getJAXBContext();
		Unmarshaller unmarshaller = context.createUnmarshaller();
		
		Sbgn result = (Sbgn)unmarshaller.unmarshal (r);
		return result;
	}

	/**
	 * Read an sbgn file (without validating against the schema)
	 * @param url url to read from 
	 * @return Sbgn data structure
	 * @throws JAXBException if there is an IO error, or the file is not SBGNML.
	 */
	public static Sbgn readFrom (URL url) throws JAXBException
	{
		JAXBContext context = Util.getJAXBContext();
		Unmarshaller unmarshaller = context.createUnmarshaller();
		
		Sbgn result = (Sbgn)unmarshaller.unmarshal (url);
		return result;
	}

	/**
	 * Read an sbgn file (without validating against the schema)
	 * @param source source to read from 
	 * @return Sbgn data structure
	 * @throws JAXBException if there is an IO error, or the file is not SBGNML.
	 */
	public static Sbgn readFrom (InputSource source) throws JAXBException
	{
		JAXBContext context = Util.getJAXBContext();
		Unmarshaller unmarshaller = context.createUnmarshaller();
		
		Sbgn result = (Sbgn)unmarshaller.unmarshal (source);
		return result;
	}

	/**
	 * Read an sbgn file (without validating against the schema)
	 * @param node node to read from 
	 * @return Sbgn data structure
	 * @throws JAXBException if there is an IO error, or the file is not SBGNML.
	 */
	public static Sbgn readFrom (Node node) throws JAXBException
	{
		JAXBContext context = Util.getJAXBContext();
		Unmarshaller unmarshaller = context.createUnmarshaller();
		
		Sbgn result = (Sbgn)unmarshaller.unmarshal (node);
		return result;
	}

	public static String getResource(String res) throws IOException
	{
		URL url = SbgnUtil.class.getResource(res);
		if (url == null) throw new IOException("Could not find resource '" + res + "' in classpath");
		return url.toString();
	}

	/**
	 * Check if a given file validates against the given xsd. If validation fails,
	 * an error message is printed to System.err.
	 * @return true if the file is valid
	 * @param f the file to validate
	 * @throws SAXException if there are problems reading xsd
	 * @throws JAXBException if there are problems reading f that are not due 
	 *  to validation problems (for example, disk error or file not found) 
	 * @throws IOException when the resource SBGN.xsd could not be loaded
	 */
	public static boolean isValid (File f) throws JAXBException, SAXException, IOException
	{
		boolean result = true;
		try
		{
			
			// create a JAXB context and unmarshaller like usual
			JAXBContext context = Util.getJAXBContext();
			Unmarshaller unmarshaller = context.createUnmarshaller();
		
			// parse the schema.
			// If you call validate many times, 
			// it would be more efficient to do this step once of course.
			Schema schema;
			SchemaFactory schemaFactory = SchemaFactory.newInstance( XMLConstants.W3C_XML_SCHEMA_NS_URI );
			schema = schemaFactory.newSchema(new StreamSource(getResource("/SBGN.xsd")));

			// add the schema to the unmarshaller
			unmarshaller.setSchema(schema);
			
			// read the file. If there are problems, an UnmarshalException will be thrown here
			unmarshaller.unmarshal (f);
		}
		catch (UnmarshalException e)
		{
			result = false;
			System.err.println (e.getCause().getMessage());
		}
		return result;
	}
	
	/**
	 * Write sbgn to a file 
	 * @param sbgn Sbgn data structure to write
	 * @param f output file
	 * @throws JAXBException if there is an IO error
	 */
	public static void writeToFile (Sbgn sbgn, File f) throws JAXBException
	{
		JAXBContext context = Util.getJAXBContext();
		Marshaller marshaller = context.createMarshaller();
		marshaller.setProperty( Marshaller.JAXB_FORMATTED_OUTPUT, Boolean.TRUE );

		// now write everything to disk
		marshaller.marshal(sbgn, f);
	}

	/**
	 * Write sbgn to a file 
	 * @param sbgn Sbgn data structure to write
	 * @param os output stream
	 * @throws JAXBException if there is an IO error
	 */
	public static void writeTo (Sbgn sbgn, OutputStream os) throws JAXBException
	{
		JAXBContext context = Util.getJAXBContext();
		Marshaller marshaller = context.createMarshaller();
		marshaller.setProperty( Marshaller.JAXB_FORMATTED_OUTPUT, Boolean.TRUE );

		marshaller.marshal(sbgn, os);
	}
	
	/**
	 * Write sbgn to a file 
	 * @param sbgn Sbgn data structure to write
	 * @param w output writer
	 * @throws JAXBException if there is an IO error
	 */
	public static void writeTo (Sbgn sbgn, Writer w) throws JAXBException
	{
		JAXBContext context = Util.getJAXBContext();
		Marshaller marshaller = context.createMarshaller();
		marshaller.setProperty( Marshaller.JAXB_FORMATTED_OUTPUT, Boolean.TRUE );

		marshaller.marshal(sbgn, w);
	}

	/**
	 * Write sbgn to a file 
	 * @param sbgn Sbgn data structure to write
	 * @param node output node
	 * @throws JAXBException if there is an IO error
	 */
	public static void writeTo (Sbgn sbgn, Node node) throws JAXBException
	{
		JAXBContext context = Util.getJAXBContext();
		Marshaller marshaller = context.createMarshaller();
		marshaller.setProperty( Marshaller.JAXB_FORMATTED_OUTPUT, Boolean.TRUE );

		marshaller.marshal(sbgn, node);
	}

	
        /**
         * Adds an annotation as provided by the input source to the given SBGN element
         * @param sbgnElement the element to add the annotation to
         * @param is the input source containing the annotation string
         * @throws ParserConfigurationException 
         * @throws SAXException
         * @throws IOException
         */
        public static void addAnnotation(SBGNBase sbgnElement, InputSource is)
                        throws ParserConfigurationException, SAXException, IOException {
                Extension ext = sbgnElement.getExtension();
                if (ext == null) {
                        ext = new Extension();
                }

                DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
                DocumentBuilder db = dbf.newDocumentBuilder();
                Document doc = db.parse(is);

                ext.getAny().add(doc.getDocumentElement());

                sbgnElement.setExtension(ext);
        }

        /**
         * Adds an annotation as provided by the input stream to the given SBGN element
         * @param sbgnElement the element to add the annotation to
         * @param is the input stream containing the annotation string
         * @throws ParserConfigurationException 
         * @throws SAXException
         * @throws IOException
         */
        public static void addAnnotation(SBGNBase sbgnElement, InputStream is)
                        throws ParserConfigurationException, SAXException, IOException {

                addAnnotation(sbgnElement, new InputSource(is));
        }

        /**
         * Adds an annotation as provided by the reader to the given SBGN element
         * @param sbgnElement the element to add the annotation to
         * @param r the reader containing the annotation string
         * @throws ParserConfigurationException 
         * @throws SAXException
         * @throws IOException
         */
        public static void addAnnotation(SBGNBase sbgnElement, Reader r)
                        throws ParserConfigurationException, SAXException, IOException {

                addAnnotation(sbgnElement, new InputSource(r));
        }

        /**
         * Adds an annotation as provided by the input source to the given SBGN element
         * @param sbgnElement the element to add the annotation to
         * @param annotation the xml string representing the annotation to add
         * @throws ParserConfigurationException 
         * @throws SAXException
         * @throws IOException
         */
        public static void addAnnotation(SBGNBase sbgnElement, String annotation)
                        throws ParserConfigurationException, SAXException, IOException {
                addAnnotation(sbgnElement, new StringReader(annotation));
        }

        /**
         * Returns the annotation serialized to string of the given SBGN element and provided namespace. 
         * 
         * @param sbgnElement the sbgn element
         * @param namespaceURI the namespace uri of the annotation to return. 
         * @return the annotation serialized as xml string if present, null otherwise
         * @throws TransformerException
         */
        public static String getAnnotationString(SBGNBase sbgnElement, String namespaceURI)
                        throws TransformerException
        {
                Element elt = getAnnotation(sbgnElement, namespaceURI);
                if (elt == null)
                        return null;
                return XmlUtil.toString(elt);
        }

        /**
         * Return the annotation (as w3c element) of the provided SBGN element and namespace
         * @param sbgnElement the sbgn element 
         * @param namespaceURI the namespace uri of the annotation to find
         * @return the element with given namespace uri if found, null otherwise. 
         */
        public static Element getAnnotation(SBGNBase sbgnElement, String namespaceURI)
        {
                if (sbgnElement == null)
                        return null;

                Extension ext = sbgnElement.getExtension();
                if (ext == null)
                        return null;

                for (Element elt : ext.getAny())
                {
                        String elNs = elt.getNamespaceURI();

                        if (elNs != null && elt.getNamespaceURI().equals(namespaceURI))
                                return elt;

                        if (elNs == null)
                        {
                                String prefix = elt.getPrefix();
                                if (prefix == null)
                                {
                                        prefix = elt.getNodeName();
                                        int index = prefix.indexOf(':');
                                        if (index != -1)
                                        {
                                                prefix = prefix.substring(0, index);
                                        }
                                }
                                NamedNodeMap map = elt.getAttributes();
                                for (int i = 0; i < map.getLength(); ++i)
                                {
                                        Node current = map.item(i);
                                        String name = current.getNodeName();

                                        if (name.equals("xmlns") || name.equals("xmlns:" + prefix))
                                        {
                                                if (current.getNodeValue().equals(namespaceURI))
                                                        return elt;
                                        }

                                }
                                
                        }
                }

                return null;
        }

        /**
         * wraps the provided content into the rdf namespace as used by the COMBINE network. The 
         * RDF namespace will be xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'. 
         * 
         * @param content the xml content to be wrapped
         * 
         * @return the input content wrapped into the rdf tags
         */
        public static String wrapRdf(String content)
        {
                return wrapRdf(content, false);
        }

        /**
         * wraps the provided content into the rdf namespace as used by the COMBINE network. The 
         * RDF namespace will be xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'. 
         * Using this method the model qualifier, Vcard and dublin core namespaces will be left out.
         * 
         * @param content the xml content to be wrapped
         * @param includeBiol flag indicating whether to include the xmlns:bqbiol='http://biomodels.net/biology-qualifiers/ namespace.
         * 
         * @return the input content wrapped into the rdf tags with the additional namespaces if selected
         */
        public static String wrapRdf(String content, boolean includeBiol)
        {
                return wrapRdf(content, includeBiol, false);
        }

        /**
         * wraps the provided content into the rdf namespace as used by the COMBINE network. The 
         * RDF namespace will be xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'. 
         * Using this method the Vcard and dublin core namespaces will be left out.
         * 
         * @param content the xml content to be wrapped
         * @param includeBiol flag indicating whether to include the xmlns:bqbiol='http://biomodels.net/biology-qualifiers/ namespace.
         * @param includeModel flag whether to include the xmlns:bqmodel='http://biomodels.net/model-qualifiers/ namespace
         * 
         * @return the input content wrapped into the rdf tags with the additional namespaces if selected
         */
        public static String wrapRdf(String content, boolean includeBiol,  boolean includeModel)
        {
                return wrapRdf(content, includeBiol, includeModel, false);
        }

        /**
         * wraps the provided content into the rdf namespace as used by the COMBINE network. The 
         * RDF namespace will be xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'. 
         * Using this method the Vcard namespace will be left out.
         * 
         * @param content the xml content to be wrapped
         * @param includeBiol flag indicating whether to include the xmlns:bqbiol='http://biomodels.net/biology-qualifiers/ namespace.
         * @param includeModel flag whether to include the xmlns:bqmodel='http://biomodels.net/model-qualifiers/ namespace
         * @param includeDc flag whether to include the dublin core namespaces xmlns:dc='http://purl.org/dc/elements/1.1/' and xmlns:dcterms='http://purl.org/dc/terms/'
         * 
         * @return the input content wrapped into the rdf tags with the additional namespaces if selected
         */
        public static String wrapRdf(String content, boolean includeBiol,  boolean includeModel, boolean includeDc)
        {
                return wrapRdf(content, includeBiol, includeModel, includeDc, false);
        }

        /**
         * wraps the provided content into the rdf namespace as used by the COMBINE network. The 
         * RDF namespace will be xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'
         * 
         * @param content the xml content to be wrapped
         * @param includeBiol flag indicating whether to include the xmlns:bqbiol='http://biomodels.net/biology-qualifiers/ namespace.
         * @param includeModel flag whether to include the xmlns:bqmodel='http://biomodels.net/model-qualifiers/ namespace
         * @param includeDc flag whether to include the dublin core namespaces xmlns:dc='http://purl.org/dc/elements/1.1/' and xmlns:dcterms='http://purl.org/dc/terms/'
         * @param includeVcard flag whether to include the VCard namespace xmlns:vCard='http://www.w3.org/2001/vcard-rdf/3.0#'
         * 
         * @return the input content wrapped into the rdf tags with the additional namespaces if selected
         */
        public static String wrapRdf(String content, boolean includeBiol, boolean includeModel, boolean includeDc, boolean includeVcard)
        {
                StringBuilder sb = new StringBuilder("<rdf:RDF xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#' ");
                if (includeBiol)
                {
                        sb.append("xmlns:bqbiol='http://biomodels.net/biology-qualifiers/' ");
                }

                if (includeModel)
                {
                        sb.append("xmlns:bqmodel='http://biomodels.net/model-qualifiers/'> ");
                }
                if (includeDc)
                {
                        sb.append("xmlns:dc='http://purl.org/dc/elements/1.1/' xmlns:dcterms='http://purl.org/dc/terms/' ");
                }

                if (includeVcard)
                {
                        sb.append("xmlns:vCard='http://www.w3.org/2001/vcard-rdf/3.0#' ");
                }

                sb.append(">");
                sb.append(content);
                sb.append("</rdf:RDF>");
                return sb.toString();
        }

}
