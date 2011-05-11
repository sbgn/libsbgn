package org.sbgn.bindings;

import java.io.File;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

import junit.framework.TestCase;

public class Test extends TestCase
{
	static File file1 = new File ("test-files/PD/adh.sbgn");
	
	public static void test1() throws JAXBException
	{
		assertTrue (file1.exists());
		
		JAXBContext context = JAXBContext.newInstance("org.sbgn.bindings");
		Unmarshaller unmarshaller = context.createUnmarshaller() ;
		Sbgn sbgn = (Sbgn)unmarshaller.unmarshal (file1);
		
		Map map = sbgn.getMap();
		
		assertEquals (7, map.getGlyph().size());
		assertEquals (6, map.getArc().size());
	}
}
