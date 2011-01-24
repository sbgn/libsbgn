package org.sbgn;

import java.io.File;

import javax.xml.bind.JAXBException;

import org.sbgn.bindings.Sbgn;
import org.xml.sax.SAXException;

public class ValidationExample
{

	public static void main (String[] args) throws SAXException, JAXBException
	{
		File xsd = new File ("../resources/SBGN.xsd");
		File f = new File ("../test-files/adh.sbgn");
		
		boolean isValid = SbgnUtil.isValid(f, xsd);
		
		if (isValid)
			System.out.println ("Validation succeeded");
		else
			System.out.println ("Validation failed");
	}
		
}
