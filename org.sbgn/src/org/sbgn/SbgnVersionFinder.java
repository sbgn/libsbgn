package org.sbgn;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

import org.xml.sax.Attributes;
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
	static class VersionHandler extends DefaultHandler
	{
		private int version = -1;
		private Language lang = null;

		@Override
		public void startElement (String uri, String localName, String qName, Attributes attributes) throws SAXException
		{
			if ("sbgn".equals (qName))
			{
				if ("http://sbgn.org/libsbgn/0.3".equals(uri))
				{
					version = 3;
				} 
				else if ("http://sbgn.org/libsbgn/0.2".equals(uri))
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
			else if ("map".equals (qName))
			{
				String l = attributes.getValue("language");
				if (l != null)
				{
					lang = Language.fromString(l); 
				} else
				{
					l = attributes.getValue("version");
					if ( l!= null )
					{

						if (l.equals("http://identifiers.org/combine.specifications/sbgn.pd.level-1.version-1.3"))
						{
							lang = Language.fromString("process description");
						}
						else if (l.equals("http://identifiers.org/combine.specifications/sbgn.pd.level-1.version-1.2"))
						{
							lang = Language.fromString("process description");
						}
						else if (l.equals("http://identifiers.org/combine.specifications/sbgn.pd.level-1.version-1.1"))
						{
							lang = Language.fromString("process description");
						}
						else if (l.equals("http://identifiers.org/combine.specifications/sbgn.pd.level-1.version-1.0"))
						{
							lang = Language.fromString("process description");
						}
						else if (l.equals("http://identifiers.org/combine.specifications/sbgn.pd.level-1.version-1"))
						{
							lang = Language.fromString("process description");
						}
						else if (l.equals("http://identifiers.org/combine.specifications/sbgn.er.level-1.version-2"))
						{
							lang = Language.fromString("entity relationship");
						}
						else if (l.equals("http://identifiers.org/combine.specifications/sbgn.er.level-1.version-1.2"))
						{
							lang = Language.fromString("entity relationship");
						}
						else if (l.equals("http://identifiers.org/combine.specifications/sbgn.er.level-1.version-1.1"))
						{
							lang = Language.fromString("entity relationship");
						}
						else if (l.equals("http://identifiers.org/combine.specifications/sbgn.er.level-1.version-1.0"))
						{
							lang = Language.fromString("entity relationship");
						}
						else if (l.equals("http://identifiers.org/combine.specifications/sbgn.er.level-1.version-1"))
						{
							lang = Language.fromString("entity relationship");
						}
						else if (l.equals("http://identifiers.org/combine.specifications/sbgn.af.level-1.version-1.2"))
						{
							lang = Language.fromString("activity flow");
						}
						else if (l.equals("http://identifiers.org/combine.specifications/sbgn.af.level-1.version-1.0"))
						{
							lang = Language.fromString("activity flow");
						}
						else if (l.equals("http://identifiers.org/combine.specifications/sbgn.af.level-1.version-1"))
						{
							lang = Language.fromString("activity flow");
						}
					}
				}
			}
		}
		
		public int getVersion() { return version; }
		public Language getLanguage() { return lang; }
	};

	private static VersionHandler parse(File file) throws FileNotFoundException, IOException, SAXException
	{
		XMLReader xr;	
		xr = XMLReaderFactory.createXMLReader();

		VersionHandler versionHandler = new VersionHandler();

        //NOTE: Commented out setEntityResolver(null) results in NullPointerException
		//xr.setEntityResolver(null);
		xr.setContentHandler(versionHandler);
		xr.setErrorHandler(versionHandler);
		xr.parse(new InputSource(
			InputStreamToReader.inputStreamToReader(
				new FileInputStream (file))));
		
		return versionHandler;
	}
	
	public static int getVersion(File file) throws SAXException, FileNotFoundException, IOException
	{
		VersionHandler versionHandler = parse(file);
		return versionHandler.getVersion();
	}
	
	public static Language getLanguage(File file) throws FileNotFoundException, IOException, SAXException
	{
		VersionHandler versionHandler = parse(file);
		return versionHandler.getLanguage();
	}

}
