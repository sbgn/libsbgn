package org.sbgn;

import java.util.HashMap;
import java.util.Map;

/**
 * Enumeration with all possible values for the class attribute of Glyphs in SBGN-ML. 
 * This includes both top-level glyphs and sub-glyphs.
 * <p>
 * The use of "zz" in the name GlyphClazz is not to be cute, 
 * but to correspond better with getClazz() and setClazz() methods on Glyph.
 */
public enum GlyphClazz
{    
	/* glyphs */
	UNSPECIFIED_ENTITY ("unspecified entity"),
	SIMPLE_CHEMICAL ("simple chemical"),
	MACROMOLECULE ("macromolecule"),
	NUCLEIC_ACID_FEATURE ("nucleic acid feature"),
	SIMPLE_CHEMICAL_MULTIMER ("simple chemical multimer"),
	MACROMOLECULE_MULTIMER ("macromolecule multimer"),
	NUCLEIC_ACID_FEATURE_MULTIMER ("nucleic acid feature multimer"),
	COMPLEX ("complex"),
	COMPLEX_MULTIMER ("complex multimer"),
	SOURCE_AND_SINK ("source and sink"),
	PERTURBATION ("perturbation"),
	BIOLOGICAL_ACTIVITY ("biological activity"),
	PERTURBING_AGENT ("perturbing agent"),
	COMPARTMENT ("compartment"),
	SUBMAP ("submap"),
	TAG ("tag"),
	TERMINAL ("terminal"),
	PROCESS ("process"),
	OMITTED_PROCESS ("omitted process"),
	UNCERTAIN_PROCESS ("uncertain process"),
	ASSOCIATION ("association"),
	DISSOCIATION ("dissociation"),
	PHENOTYPE ("phenotype"),
	AND ("and"),
	OR ("or"),
	NOT ("not"),
	STATE_VARIABLE ("state variable"),
	UNIT_OF_INFORMATION ("unit of information"),
	STOICHIOMETRY ("stoichiometry"),
	ENTITY ("entity"),
	OUTCOME ("outcome"),
	OBSERVABLE ("observable"),
	INTERACTION ("interaction"),
	INFLUENCE_TARGET ("influence target"),
	ANNOTATION ("annotation"),
	VARIABLE_VALUE ("variable value"),
	IMPLICIT_XOR ("implicit xor"),
	DELAY ("delay"),
	EXISTENCE ("existence"),
	LOCATION ("location"),
	CARDINALITY ("cardinality"),
	;

	private static Map<String, GlyphClazz> nameLookupMap = new HashMap<String, GlyphClazz>();

	static
	{
		for (GlyphClazz i : GlyphClazz.values())
		{
			nameLookupMap.put(i.clazz, i);
		}

	}
	
	private GlyphClazz (String clazz)
	{
		this.clazz = clazz;
	}

	private final String clazz;

	public String getClazz() { return clazz; }
	public String toString() { return clazz; }
	
	public static GlyphClazz fromClazz(String clazz)
	{
		return nameLookupMap.get(clazz);
	}
}
