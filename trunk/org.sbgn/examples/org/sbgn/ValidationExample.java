package org.sbgn;

import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.xml.bind.JAXBException;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;

import org.sbgn.schematron.Issue;
import org.sbgn.schematron.SchematronValidator;
import org.xml.sax.SAXException;

/**
 * This is an example that shows both low-level validation using XML Schema, 
 * and high-level validation using schematron.
 */
public class ValidationExample
{
	/**
	 * Low level validation using XML Schema.
	 * This will check if the XML is properly structured.
	 * @throws SAXException 
	 * @throws JAXBException 
	 * @throws IOException 
	 */
	public static void lowLevelExample(File f) throws JAXBException, SAXException, IOException
	{
		boolean isValid = SbgnUtil.isValid(f);
		
		if (isValid)
			System.out.println ("Validation succeeded");
		else
			System.out.println ("Validation failed");
	}
	
	/**
	 * High-level validation using schematron.
	 * This will check if the drawing rules of SBGN are fulfilled. 
	 * @throws SAXException 
	 * @throws TransformerException 
	 * @throws ParserConfigurationException 
	 * @throws IOException 
	 */
	public static void highLevelExample(File f) throws IOException, ParserConfigurationException, TransformerException, SAXException
	{
        // Export validation reports to file for debugging
        SchematronValidator.setSvrlDump(true);

		// validation will result in a list of issues
		List<Issue> issues = SchematronValidator.validate(f);

		// print each issue individually.
		System.out.println ("There are " + issues.size() + " validation problems"); 
		for (Issue issue : issues)
		{
			System.out.println (issue);
		}
	}
	
	public static void main (String[] args) throws JAXBException, SAXException, ParserConfigurationException, IOException, TransformerException
	{
        System.out.println("LOW LEVEL VALIDATION");
		File f = new File ("./test-files/PD/adh.sbgn");
		lowLevelExample(f);

        System.out.println("HIGH LEVEL VALIDATION");
        File f2 = new File ("./test-files/PD/multimer2.sbgn");
		highLevelExample(f2);
	}
}
