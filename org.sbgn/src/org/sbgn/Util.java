package org.sbgn;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.StringWriter;
import java.io.Writer;
import java.nio.file.StandardCopyOption;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;

import org.xml.sax.InputSource;

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
			// possible exception [javax.xml.bind.JAXBException: "org.sbgn.bindings" doesn't
			// contain ObjectFactory.class or jaxb.index]
			ClassLoader classLoader = org.sbgn.bindings.ObjectFactory.class.getClassLoader();
			return JAXBContext.newInstance("org.sbgn.bindings", classLoader);
		}
	}

	public static void copyFile(File source, File destination) throws IOException
	{
		copyFile(new FileReader(source), destination);
	}

	public static void copyFile(Reader source, File destination)  throws IOException
	{
		FileWriter writer = new FileWriter(destination);
		copyFile(source, writer);
		writer.close();
	}

	public static void copyFile(InputSource source, File destination)  throws IOException
	{
		if (source.getCharacterStream() != null)
			copyFile(source.getCharacterStream(), new FileWriter(destination));
		else
			copyFile(source.getByteStream(), new FileWriter(destination));
	}
	
	public static void copyFile(InputSource source, Writer destination)  throws IOException
	{
		if (source.getCharacterStream() != null)
			copyFile(source.getCharacterStream(), destination);
		else
			copyFile(source.getByteStream(), destination);
	}

	public static void copyFile(InputStream source, Writer destination)  throws IOException
	{
		copyFile(new InputStreamReader(source), destination);
	}
	
	public static void copyFile(InputStream source, File destination)  throws IOException
	{
		java.nio.file.Files.copy(source, destination.toPath(), StandardCopyOption.REPLACE_EXISTING);
	}

	public static void copyFile(Reader source, Writer destination)  throws IOException
	{
		if (source == null) return;
		if (!source.ready()) return;
		if (destination == null) return;
		String current;		
		BufferedReader reader = new BufferedReader(source);
		while((current = reader.readLine()) != null)
		{
			
			destination.write(current);
			destination.write("\n");
		}		
		destination.flush();
	}
	
	public static String readString(File file)
	{
		String result = null;
		try
		{
			StringWriter writer = new StringWriter();
			copyFile(new FileReader(file), writer);
			result = writer.toString();
		}
		catch(Exception e)
		{
		}
		return result;
	}

}
