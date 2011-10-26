package org.sbgn.schematron;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;

import org.sbgn.SbgnUtil;
import org.xml.sax.SAXException;

import junit.framework.TestCase;

public class TestSchematronValidation extends TestCase
{
	File rulesDir = new File("validation/rules/");
	File testFilesBase = new File ("test-files");
	
	File fER = new File (rulesDir, "sbgn_er.sch");
	File fPD = new File (rulesDir, "sbgn_pd.sch");
	File fAF = new File (rulesDir, "sbgn_af.sch");

	private Map<String, File> schematronByLang = new HashMap<String, File>();
	
	String[] langShortNames = new String[] { "PD", "ER", "AF" };
	
	public void setUp()
	{
		schematronByLang.put("AF", fAF);
		schematronByLang.put("ER", fER);
		schematronByLang.put("PD", fPD);
	}
		
	public void testAllTestCases() throws IOException, ParserConfigurationException, TransformerException, SAXException
	{
		Map<File, List<Issue>> issuePerFile = new HashMap<File, List<Issue>>();
		
		for (String lang : langShortNames)
		{
			File sch = schematronByLang.get(lang);
			assertTrue ("Could not find file " + sch, sch.exists());
			File testFilesDir = new File (testFilesBase, lang);
			assertTrue ("Could not find directory " + testFilesDir, testFilesDir.exists());
			assertTrue (testFilesDir.isDirectory());
			
			for (File f : testFilesDir.listFiles())
			{
				if (!f.getName().endsWith(".sbgn")) continue;
				
				List<Issue> issues = SchematronValidator.validate(f, sch);				
				issuePerFile.put(f, issues);
			}			
		
		}
		
		for (File f : issuePerFile.keySet())
		{
			List<Issue> issues = issuePerFile.get(f);
			
			System.out.println ("==============================");
			System.out.println (f);
			for (Issue i : issues)
			{
				System.out.println (i.getRuleDescription() + " " + i.getRuleId() + " " + i.getAboutId() + " " + i.getSeverity());
			}
			System.out.println ("==============================");
		}

	}
}
