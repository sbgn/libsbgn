package org.sbgn.schematron;

import static org.junit.Assert.*;

import java.io.File;
import java.io.IOException;
import java.util.*;

import javax.xml.bind.JAXBException;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameter;
import org.junit.runners.Parameterized.Parameters;
import org.sbgn.SbgnUtil;
import org.xml.sax.SAXException;

@RunWith(Parameterized.class)
public class TestSchematronValidationForNegative 
{
	private static File negTestFilesDir = new File("validation/error-test-files/");
	
	private static String[] langShortNames = new String[] { "PD", "ER", "AF" };

    @Parameter
    public String testCaseName;
    
    @Parameter(1)
    public File testFile;

    @Parameters(name = "{index} : {0}")
    public static Collection<Object[]> prepareTestCases() throws IOException {
      Collection<Object[]> testCases = new ArrayList<Object[]>();
      for (String lang : langShortNames)
      {
          File testFilesDir = new File (negTestFilesDir, lang);
          assertTrue ("Could not find directory " + testFilesDir, testFilesDir.exists());
          assertTrue (testFilesDir.isDirectory());

          for (File f : testFilesDir.listFiles())
          {
                if (!f.getName().endsWith(".sbgn")) continue;

                // ignore the Reference Card .sbgn as these files will have many unconnected glyphs
                if(f.getName().contains("Reference")) continue;

                testCases.add(new Object[] { lang+": "+f.getName(), f});
                
          }
      }
      return testCases;
    }    
    
    @Test
	public void checkIfValidationIssuesAreRaised() throws IOException, ParserConfigurationException, TransformerException, SAXException, JAXBException
	{
        System.out.println(testFile);

        System.out.println ("@@@@@@@@@@@@@@");
		System.out.println (testFile);
		assertTrue (testFile + " does not validate. All schematron test cases must pass low-level XSD validation", SbgnUtil.isValid(testFile));
		
		String name = testFile.getName();
		
		assertTrue ("Expected either 'pass' or 'fail' in file " + name, name.contains("pass") || name.contains("fail"));
		boolean isFail = name.contains("fail");
		String expectedRuleId = name.split("-")[0];
		
		boolean failedExpectedRule = false;

        // Export validation reports to file for debugging
        SchematronValidator.setSvrlDump(true);

		List<Issue> issues = SchematronValidator.validate(testFile);
		for (Issue issue : issues)
		{
            System.out.println("Issue: " + issue.toString());

			assertNotNull(issue.getRuleId());
			assertNotNull ("About id of " + issue.getRuleId() + " must not be null", issue.getAboutId());
			assertNotNull ("Rule description of " + issue.getRuleId() + " must not be null", issue.getRuleDescription());
			assertNotNull("Issue severity of " + issue.getRuleId() + " must not be null", issue.getSeverity());

			System.out.println (issue.getAboutId() + " " + issue.getRuleId() + " " + issue.getRuleDescription());
			if (issue.getRuleId().equals(expectedRuleId))
				failedExpectedRule = true;
		}
		
		if (isFail)
			assertTrue ("Expected " + name + " to fail rule " + expectedRuleId + ", but it passed", failedExpectedRule);
		else
			assertFalse("Expected " + name + " to pass rule " + expectedRuleId + ", but it failed", failedExpectedRule);
	}

}
