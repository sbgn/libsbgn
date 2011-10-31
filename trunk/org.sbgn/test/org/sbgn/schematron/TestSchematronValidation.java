package org.sbgn.schematron;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;

import org.xml.sax.SAXException;

import junit.framework.TestCase;

public class TestSchematronValidation extends TestCase
{
	File rulesDir = new File("validation/rules/");
	File testFilesBase = new File ("test-files");
	File negTestFilesDir = new File("validation/error-test-files/");
	
	String[] langShortNames = new String[] { "PD", "ER", "AF" };
	
	public void testAllTestCases() throws IOException, ParserConfigurationException, TransformerException, SAXException
	{
		Map<File, List<Issue>> issuePerFile = new HashMap<File, List<Issue>>();
		
		for (String lang : langShortNames)
		{
			File testFilesDir = new File (testFilesBase, lang);
			assertTrue ("Could not find directory " + testFilesDir, testFilesDir.exists());
			assertTrue (testFilesDir.isDirectory());

			int issueNum = 0;
			
			for (File f : testFilesDir.listFiles())
			{
				if (!f.getName().endsWith(".sbgn")) continue;

				List<Issue> issues = SchematronValidator.validate(f);
				if (issues.size() > 0)
				{
					System.out.println ("===============");
					System.out.println (f);
					for (Issue i : issues)
					{
						issueNum++;
						System.out.println (i.getAboutId() + " " + i.getRuleId() + " " + i.getRuleDescription());
					}
				}
			}
			assertEquals ("Expected zero validation issues", 0, issueNum);
		
		}		
	}

	public void testNegativeTestCases() throws IOException, ParserConfigurationException, TransformerException, SAXException
	{
		for (String lang : new String[] { "AF", "PD"})
		{
			File testFilesDir = new File (negTestFilesDir, lang);
			assertTrue ("Could not find directory " + testFilesDir, testFilesDir.exists());
			assertTrue (testFilesDir.isDirectory());

			for (File f : testFilesDir.listFiles())
			{
				String name = f.getName();
				if (!name.endsWith(".sbgn")) continue;
				
				assertTrue ("Expected either 'pass' or 'fail' in file " + name, name.contains("pass") || name.contains("fail"));
				boolean isFail = name.contains("fail");
				String expectedRuleId = name.split("-")[0];
				
				boolean failedExpectedRule = false;
				List<Issue> issues = SchematronValidator.validate(f);
				System.out.println ("@@@@@@@@@@@@@@");
				System.out.println (f);
				for (Issue issue : issues)
				{
					System.out.println (issue.getAboutId() + " " + issue.getRuleId() + " " + issue.getRuleDescription());
					if (issue.getRuleId().equals(expectedRuleId))
						failedExpectedRule = true;
				}
				
				if (isFail)
					assertTrue ("Expected " + name + " to fail rule " + expectedRuleId + ", but it passed", failedExpectedRule);
				else
					assertFalse ("Expected " + name + " to pass rule " + expectedRuleId + ", but it failed", failedExpectedRule);
			}			
		}
	}

}
