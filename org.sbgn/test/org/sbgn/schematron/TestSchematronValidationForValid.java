package org.sbgn.schematron;

import static org.junit.Assert.assertTrue;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameter;
import org.junit.runners.Parameterized.Parameters;
import org.xml.sax.SAXException;


@RunWith(Parameterized.class)
public class TestSchematronValidationForValid 
{
	static File testFilesBase = new File ("test-files");
	
	static String[] langShortNames = new String[] { "PD", "ER", "AF" };
	
    @Parameter
	public String testName;
    
    @Parameter(1)
    public File testFile;

    @Parameters(name = "{index} : {0}")
    public static Collection<Object[]> data() throws IOException {
      Collection<Object[]> data = new ArrayList<Object[]>();
      for (String lang : langShortNames)
      {
          File testFilesDir = new File (testFilesBase, lang);
          assertTrue("Could not find directory " + testFilesDir, testFilesDir.exists());
          assertTrue (testFilesDir.isDirectory());

          for (File f : testFilesDir.listFiles())
          {
                if (!f.getName().endsWith(".sbgn")) continue;

                // ignore the Reference Card .sbgn as these files will have many unconnected glyphs
                if(f.getName().contains("Reference")) continue;

                data.add(new Object[] { lang+": "+f.getName(), f});
                
            }

          }
      return data;
    }    
    
	@Test
	public void checkValidationIssues() throws IOException, ParserConfigurationException, TransformerException, SAXException
	{
      boolean validationSucceeded = true;
      for (Issue i : SchematronValidator.validate(testFile))
      {
          /* ignore rule pd10131: "EPNs should not be orphaned", 
           * We violate it in our test-cases to keep it simple. */
          if ("pd10131".equals(i.getRuleId())) continue;
          
          if (validationSucceeded)
          {
              System.out.println("===============");
              System.out.println(testFile);
              validationSucceeded = false;
          }
          System.out.println(i.getAboutId() + " " + i.getRuleId() + " " + i.getRuleDescription());
      }
      assertTrue("Expected none validation issues", validationSucceeded);
	}

}
