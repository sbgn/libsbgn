package org.sbgn;

/**
 * Enum representing the three languages of SBGN.
 */
public enum Language 
{
	AF ("activity flow"),
	ER ("entity relationship"),
	PD ("process description");
	
	private Language(String name) { this.name = name; }
	private final String name;
	
	/** String representation, suitable for use on the language attribute of the map element in SBGN-ML */
	public String getName() { return name; }
	
	public String toString() { return name; }
}
