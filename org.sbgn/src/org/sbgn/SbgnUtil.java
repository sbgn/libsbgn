package org.sbgn;

import java.io.File;

import javax.xml.XMLConstants;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Schema;

import org.sbgn.bindings.Sbgn;
import org.xml.sax.SAXException;

public class SbgnUtil
{

	public static Sbgn readFromFile (File f) throws JAXBException
	{
		JAXBContext context = JAXBContext.newInstance("org.sbgn.bindings");
		Unmarshaller unmarshaller = context.createUnmarshaller();
		
		// Now read from "f" and put the result in "sbgn"
		Sbgn result = (Sbgn)unmarshaller.unmarshal (f);
		return result;
	}
	
	public static boolean isValid (File f, File xsd)
	{
		boolean result = true;
		try
		{
			Schema schema;
			SchemaFactory schemaFactory = SchemaFactory.newInstance( XMLConstants.W3C_XML_SCHEMA_NS_URI );
			schema = schemaFactory.newSchema(xsd);
			JAXBContext context = JAXBContext.newInstance("org.sbgn.bindings");
			Unmarshaller unmarshaller = context.createUnmarshaller();
			
			unmarshaller.setSchema(schema);
			
			unmarshaller.unmarshal (f);
		}
		catch (SAXException e)
		{
			result = false;
		}
		catch (JAXBException e)
		{
			result = false;
		}
		return result;
	}
	
	public static void writeToFile (Sbgn sbgn, File f) throws JAXBException
	{
		JAXBContext context = JAXBContext.newInstance("org.sbgn.bindings");
		Marshaller marshaller = context.createMarshaller();
		marshaller.setProperty( Marshaller.JAXB_FORMATTED_OUTPUT, Boolean.TRUE );

		// now write everything to disk
		marshaller.marshal(sbgn, f);
	}

}
