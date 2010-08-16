package org.sbgn.bindings;

import java.io.File;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

import junit.framework.TestCase;

public class Test extends TestCase
{
	static File file1 = new File ("test-files/adh.sbgn");
	
	public static void test1() throws JAXBException
	{
		assertTrue (file1.exists());
		
		JAXBContext context = JAXBContext.newInstance("org.sbgn.bindings");
		Unmarshaller unmarshaller = context.createUnmarshaller() ;
		Sbgn sbgn = (Sbgn)unmarshaller.unmarshal (file1);
		
		assertEquals (7, sbgn.getGlyph().size());
		assertEquals (6, sbgn.getArc().size());
	}
}
