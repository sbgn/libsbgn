package org.sbgn;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;

public class Util {
	
	/**
	 * Get JAXB context
	 * 
	 * @return JAXBContext
	 * @throws JAXBException
	 */
	@SuppressWarnings("nls")
	public static JAXBContext getJAXBContext() throws JAXBException {
		
		try {
			return JAXBContext.newInstance("org.sbgn.bindings");
		} catch (JAXBException ex) {
			// possible exception [javax.xml.bind.JAXBException: "org.sbgn.bindings" doesn't contain ObjectFactory.class or jaxb.index]
			ClassLoader classLoader = org.sbgn.bindings.ObjectFactory.class.getClassLoader();
			return JAXBContext.newInstance("org.sbgn.bindings", classLoader);
		}
		
	}
	
}
