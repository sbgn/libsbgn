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
		
		assertEquals (1, sbgn.getMap().size());
		
		Map firstMap = sbgn.getMap().get(0);
		
		assertEquals (7, firstMap.getGlyph().size());
		assertEquals (6, firstMap.getArc().size());
	}
}
