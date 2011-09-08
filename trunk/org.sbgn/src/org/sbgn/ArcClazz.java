package org.sbgn;

import java.util.HashMap;
import java.util.Map;

/**
 * Enumeration with all possible values for the class attribute of Arcs in SBGN-ML. 
 * <p>
 * The use of "zz" in the name ArcClazz is not to be cute, 
 * but to correspond better with getClazz() and setClazz() methods on Arc.
 */
public enum ArcClazz
{
	/* arcs */
	PRODUCTION ("production"),
	CONSUMPTION ("consumption"),
	CATALYSIS ("catalysis"),
	MODULATION ("modulation"),
	STIMULATION ("stimulation"),
	INHIBITION ("inhibition"),
	ASSIGNMENT ("assignment"),
	INTERACTION ("interaction"),
	ABSOLUTE_INHIBITION ("absolute inhibition"),
	ABSOLUTE_STIMULATION ("absolute stimulation"),
	POSITIVE_INFLUENCE ("positive influence"),
	NEGATIVE_INFLUENCE ("negative influence"),
	UNKNOWN_INFLUENCE ("unknown influence"),
	EQUIVALENCE_ARC ("equivalence arc"),
	NECESSARY_STIMULATION ("necessary stimulation"),
	LOGIC_ARC ("logic arc"),

	;
	
	private static Map<String, ArcClazz> nameLookupMap = new HashMap<String, ArcClazz>();

	static
	{
		for (ArcClazz i : ArcClazz.values())
		{
			nameLookupMap.put(i.clazz, i);
		}

	}
	
	private ArcClazz (String clazz)
	{
		this.clazz = clazz;
	}

	public static ArcClazz fromClazz(String clazz)
	{
		return nameLookupMap.get(clazz);
	}
	
	private final String clazz;

	public String getClazz() { return clazz; }
	public String toString() { return clazz; }
}
