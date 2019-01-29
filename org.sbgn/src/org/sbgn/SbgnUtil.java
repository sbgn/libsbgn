package org.sbgn;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.Reader;
import java.io.Writer;
import java.net.URL;

import javax.xml.XMLConstants;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.UnmarshalException;
import javax.xml.bind.Unmarshaller;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Schema;

import org.sbgn.bindings.Sbgn;
import org.w3c.dom.Node;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

public class SbgnUtil
{
	/**
	 * Read an sbgn file (without validating against the schema)
	 * @param f file to read from 
	 * @returns Sbgn data structure
	 * @throws JAXBException if there is an IO error, or the file is not SBGNML.
	 */
	public static Sbgn readFromFile (File f) throws JAXBException
	{
		JAXBContext context = JAXBContext.newInstance("org.sbgn.bindings");
		Unmarshaller unmarshaller = context.createUnmarshaller();
		
		// Now read from "f" and put the result in "sbgn"
		Sbgn result = (Sbgn)unmarshaller.unmarshal (f);
		return result;
	}


	/**
	 * Read an sbgn file (without validating against the schema)
	 * @param is input stream to read from 
	 * @returns Sbgn data structure
	 * @throws JAXBException if there is an IO error, or the file is not SBGNML.
	 */
	public static Sbgn readFrom (InputStream is) throws JAXBException
	{
		JAXBContext context = JAXBContext.newInstance("org.sbgn.bindings");
		Unmarshaller unmarshaller = context.createUnmarshaller();
		
		Sbgn result = (Sbgn)unmarshaller.unmarshal (is);
		return result;
	}

	/**
	 * Read an sbgn file (without validating against the schema)
	 * @param r reader to read from 
	 * @returns Sbgn data structure
	 * @throws JAXBException if there is an IO error, or the file is not SBGNML.
	 */
	public static Sbgn readFrom (Reader r) throws JAXBException
	{
		JAXBContext context = JAXBContext.newInstance("org.sbgn.bindings");
		Unmarshaller unmarshaller = context.createUnmarshaller();
		
		Sbgn result = (Sbgn)unmarshaller.unmarshal (r);
		return result;
	}

	/**
	 * Read an sbgn file (without validating against the schema)
	 * @param url url to read from 
	 * @returns Sbgn data structure
	 * @throws JAXBException if there is an IO error, or the file is not SBGNML.
	 */
	public static Sbgn readFrom (URL url) throws JAXBException
	{
		JAXBContext context = JAXBContext.newInstance("org.sbgn.bindings");
		Unmarshaller unmarshaller = context.createUnmarshaller();
		
		Sbgn result = (Sbgn)unmarshaller.unmarshal (url);
		return result;
	}

	/**
	 * Read an sbgn file (without validating against the schema)
	 * @param source source to read from 
	 * @returns Sbgn data structure
	 * @throws JAXBException if there is an IO error, or the file is not SBGNML.
	 */
	public static Sbgn readFrom (InputSource source) throws JAXBException
	{
		JAXBContext context = JAXBContext.newInstance("org.sbgn.bindings");
		Unmarshaller unmarshaller = context.createUnmarshaller();
		
		Sbgn result = (Sbgn)unmarshaller.unmarshal (source);
		return result;
	}

	/**
	 * Read an sbgn file (without validating against the schema)
	 * @param node node to read from 
	 * @returns Sbgn data structure
	 * @throws JAXBException if there is an IO error, or the file is not SBGNML.
	 */
	public static Sbgn readFrom (Node node) throws JAXBException
	{
		JAXBContext context = JAXBContext.newInstance("org.sbgn.bindings");
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
	 * @returns true if the file is valid
	 * @param f the file to validate
	 * @param xsd the file containing the schema to validate against
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
			JAXBContext context = JAXBContext.newInstance("org.sbgn.bindings");
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
		JAXBContext context = JAXBContext.newInstance("org.sbgn.bindings");
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
		JAXBContext context = JAXBContext.newInstance("org.sbgn.bindings");
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
		JAXBContext context = JAXBContext.newInstance("org.sbgn.bindings");
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
		JAXBContext context = JAXBContext.newInstance("org.sbgn.bindings");
		Marshaller marshaller = context.createMarshaller();
		marshaller.setProperty( Marshaller.JAXB_FORMATTED_OUTPUT, Boolean.TRUE );

		marshaller.marshal(sbgn, node);
	}

}
