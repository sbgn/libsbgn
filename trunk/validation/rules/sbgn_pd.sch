<?xml version="1.0" encoding="UTF-8"?>
<!-- 

Schematron validation for SBGN PD 

@author Augustin Luna
@version 9 October 2010
-->
<iso:schema    
  xmlns:iso="http://purl.oclc.org/dsdl/schematron"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  defaultPhase="#ALL"
  schemaVersion="0.1">
     
	<iso:ns prefix="sbgn" uri="http://sbgn.org/libsbgn/pd/0.1"/>
	<iso:ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
	
	<iso:title>sbgn_validation</iso:title>

	<iso:pattern name="check-id" id="check-id">
		<iso:rule context="//*[@id]">
			<iso:let name="id" value="@id"/>
			<iso:assert test="count(//@id[. = current()/@id]) = 1" diagnostics="id">ID needs to be unique.</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	
	<iso:pattern name="check-idref" id="check-idref">
		<iso:rule context="sbgn:arc">
			<iso:let name="target" value="@target"/>
			<iso:assert test="//*/@id[. = $target]" diagnostics="target">An arc target should be a glyph defined in the diagram.</iso:assert>
		</iso:rule> 
	</iso:pattern> 

	<iso:pattern name="check-consumption" id="check-consumption">
		<iso:rule context="sbgn:arc[@class='consumption']">
			<iso:let name="source" value="@source"/>			
			<iso:let name="class" value="//sbgn:glyph[@id=$source]/@class"/>	
			<iso:assert test="
				$class='simple chemical' or 
				$class='macromolecule'" 
				diagnostics="source class">Consumption arcs should be target glyphs of class simple chemical or macromolecule.
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	
	<iso:diagnostics>
		<iso:diagnostic id="id"><iso:value-of select="$id"/></iso:diagnostic> 				
		<iso:diagnostic id="target"><iso:value-of select="$target"/></iso:diagnostic> 
		<iso:diagnostic id="source"><iso:value-of select="$source"/></iso:diagnostic> 		
		<iso:diagnostic id="class"><iso:value-of select="$class"/></iso:diagnostic> 				
		</iso:diagnostics> 
</iso:schema>