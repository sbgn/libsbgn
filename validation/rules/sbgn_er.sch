<?xml version="1.0" encoding="UTF-8"?>
<!-- 

Schematron validation for SBGN ER 

@author Martijn van Iersel, Augustin Luna
-->
<iso:schema    
  xmlns:iso="http://purl.oclc.org/dsdl/schematron"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  defaultPhase="basic"
  schemaVersion="0.1">
     
	<iso:ns prefix="sbgn" uri="http://sbgn.org/libsbgn/0.2"/>
	
	<iso:title>sbgn_validation</iso:title>
	<iso:p>p test 1</iso:p>
	
	<iso:phase id="sanity">
		<iso:active pattern="00000"/>	
	</iso:phase>
	
	<iso:phase id="basic"> 
		<iso:active pattern="00001"/>
		<iso:active pattern="00002"/>
		<iso:active pattern="er20001"/>
	</iso:phase>

	<iso:pattern name="sanity-check" id="00000">
		<iso:rule context="//*">
			<iso:let name="id" value="@id"/>
			<iso:assert test="false()" diagnostics="id">This assertion should always fail.</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	
	<iso:pattern name="check-id" id="00001">
		<iso:rule context="//*[@id]">
			<iso:let name="id" value="@id"/>
			<iso:assert 
			role="error"
			test="count(//@id[. = current()/@id]) = 1" diagnostics="id">ID needs to be unique.</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	
	<iso:pattern name="check-idref" id="00002">
		<iso:rule context="sbgn:arc">
			<iso:let name="target" value="@target"/>
			<iso:assert
			role="error"
			test="//*/@id[. = $target]">An arc target should be a glyph defined in the diagram.</iso:assert>
		</iso:rule> 
	</iso:pattern> 

	<iso:pattern name="check-arcgroup" id="er20001">
		<iso:rule context="sbgn:glyph[@class='interaction']">
			<iso:let name="id" value="@id"/>
			<iso:assert 
				id="check-arcgroup"
				role="error"
				test="parent::arcgroup" diagnostics="id">Parent of glyph with type interaction must be arcgroup
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	
	<iso:diagnostics>
		<iso:diagnostic id="id"><iso:value-of select="$id"/></iso:diagnostic> 		
		<iso:diagnostic id="parent"><iso:value-of select="$parent"/></iso:diagnostic> 		
		<iso:diagnostic id="source"><iso:value-of select="$source"/></iso:diagnostic> 		
		<iso:diagnostic id="class"><iso:value-of select="$class"/></iso:diagnostic> 
	</iso:diagnostics> 
</iso:schema>