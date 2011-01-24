package org.sbgn;

import java.io.File;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;

import org.sbgn.bindings.Sbgn;

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
	
	public static void writeToFile (Sbgn sbgn, File f) throws JAXBException
	{
		JAXBContext context = JAXBContext.newInstance("org.sbgn.bindings");
		Marshaller marshaller = context.createMarshaller();
		marshaller.setProperty( Marshaller.JAXB_FORMATTED_OUTPUT, Boolean.TRUE );

		// now write everything to disk
		marshaller.marshal(sbgn, f);
	}

}
