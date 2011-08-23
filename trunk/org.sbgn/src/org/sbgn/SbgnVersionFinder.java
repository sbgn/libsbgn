package org.sbgn;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

import org.xml.sax.Attributes;
import org.xml.sax.EntityResolver;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.helpers.XMLReaderFactory;

//TODO: this version finder is rather inefficient, because there is no
// way to stop parsing the document, even though the version is known almost from
// the start.
public class SbgnVersionFinder
{
	private static class VersionHandler extends DefaultHandler
	{
		private int version = -1;
		
		@Override
		public void startElement (String uri, String localName, String qName, Attributes attributes) throws SAXException
		{
			if ("sbgn".equals (qName))
			{
				System.out.println (uri);
				if ("http://sbgn.org/libsbgn/0.2".equals(uri))
				{
					version = 2;
				} 
				else if ("http://sbgn.org/libsbgn/pd/0.1".equals(uri))
				{
					version = 1;
				} 
				else
				{
					version = -1;
				}
			}
		}
		
		public int getVersion() { return version; }
	};
	
	public static int getVersion(File file) throws SAXException, FileNotFoundException, IOException
	{
		XMLReader xr;	
		xr = XMLReaderFactory.createXMLReader();

		VersionHandler versionHandler = new VersionHandler();

		xr.setEntityResolver(null);		
		xr.setContentHandler(versionHandler);
		xr.setErrorHandler(versionHandler);
		xr.parse(new InputSource(
			InputStreamToReader.inputStreamToReader(
				new FileInputStream (file))));
	
		return versionHandler.getVersion();
	}	
}
