package org.sbgn.schematron;

/**
 * Describes one issue found during schematron validation.
 * One validation run may produce multiple issues.
 */
public class Issue
{
	public enum Severity { WARNING, ERROR };
	
	private final Severity severity;
	private final String message;
	private final String diagnosticId;
	private final String ruleId;
	
	Issue (String role, String ruleId, String diagnosticId, String message)
	{
		this.message = message.trim();
		this.diagnosticId = diagnosticId;
		this.ruleId = ruleId;
		severity = (role.equalsIgnoreCase("error") ? Severity.ERROR : Severity.WARNING); 
	}
	
	/** Severity of the issue, i.e.: is it an error, or a warning? */
	public Severity getSeverity() { return severity; }
	
	/** Human readable description of the issue */
	public String getRuleDescription() { return message; }

	/** identifier of the element that this issue is about */
	public String getAboutId() { return diagnosticId; }
	
	/** identifier of the issue */
	public String getRuleId() { return ruleId; }
	
	@Override
	public String toString() { return severity + " at id=" + diagnosticId + ": " + message; }
}
