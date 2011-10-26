package org.sbgn.schematron;

import org.xml.sax.Attributes;
import org.xml.sax.helpers.DefaultHandler;

import java.util.ArrayList;
import java.util.List;

/** 
 * Helper class to parse SVRL output.
 * This is a package-private implementation class.
 * based on code by Kumar Chandan, but heavily modified
 * <p>
 * This is an non-public implementation class that should 
 * only be used by org.sbgn.schematron.SchematronValidator. 
 **/
final class SVRLHandler extends DefaultHandler 
{
	private String roleAttribute;
	private String diagnosticAttribute;
	private String diagnosticId;
	private String message;
	private String ruleId;
	/**
	 * Static name for failed assertions.
	 */ 
	private static final String FAILED_ASSERT_ELT = "svrl:failed-assert";

	/**
	 * Static name for simple text
	 */
	private static final String TEXT_ELT = "svrl:text";

	/**
	 * Static name for diagnostic-reference.
	 */
	private static final String DIAGNOSTIC_REFERENCE_ELT = "svrl:diagnostic-reference";

	// class attributes -------------------------------------------------------------------------------

	/**
	 * StringBuffer to collect text/character data received from characters() callback
	 */
	private StringBuffer chars = new StringBuffer();
	
	/**
	 * An List to store (String) message of failed assertion found.
	 */
	private List<Issue> issues = new ArrayList<Issue>();

	/***
	 * indicate that the current parsed element is either FAILED_ASSERT_ELT or SUCCESSFUL_REPORT_ELT.
	 */
	private boolean underAssertorReport = false;

	// Handler methods --------------------------------------------------------------------------------

	/**
	 * {@inheritDoc}
	 */
	public void startElement(String uri, String localName, String rawName, Attributes attributes) {
		// detect svrl:failed-assert and svrl:successful-report element
		if (rawName.equals(FAILED_ASSERT_ELT)) 
		{	
			this.roleAttribute = attributes.getValue("role");
			this.ruleId = attributes.getValue("id");
			//if the role atrribute is not set, then consider the default as error
			if(this.roleAttribute == null) 
			{
				this.roleAttribute="Error";
			}
			underAssertorReport = true;
		} else if (rawName.equals(TEXT_ELT) && underAssertorReport == true) {
			// clean the buffer to start collecting text of svrl:text
			getCharacters();
		}
		else if (rawName.equals(DIAGNOSTIC_REFERENCE_ELT)) {
			diagnosticAttribute = attributes.getValue("diagnostic"); 
			// clean the buffer to start collecting text of diagnostic reference
			getCharacters();
		}
	}

	/**
	 * {@inheritDoc}
	 */
	public void endElement(String namespaceURL, String localName, String rawName) 
	{
		// reach the end of svrl:text and collect the text data
		if (rawName.equals(TEXT_ELT) && underAssertorReport == true) {
			//check the last element name to decide where to store the validation message
			message = getCharacters();
			underAssertorReport = false;
		}
		else if (rawName.equals (FAILED_ASSERT_ELT))
		{
			this.issues.add (new Issue(roleAttribute, ruleId, diagnosticId, message));
		}		
		else if(rawName.equals(DIAGNOSTIC_REFERENCE_ELT))
		{
			if("id".equals (diagnosticAttribute)) 
			{
				diagnosticId = getCharacters();
			}
		}
	}

	/**
	 * {@inheritDoc}
	 */
	public void characters(char[] ch, int start, int length) 
	{
		// print svrl:text text node if the lastElement is svrl:text
		this.chars.append (ch, start, length);
	}

	/**
	 * Return the collected text data so far and clean the buffer
	 * @return collected text data on the buffer
	 */
	private String getCharacters() {
		String retstr = this.chars.toString();
		this.chars.setLength(0);
		return retstr;
	}

	public List<Issue> getIssues()
	{
		return issues;
	}

}
