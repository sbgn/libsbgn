<?xml version="1.0" encoding="UTF-8"?>
<!-- 

Schematron validation for SBGN ER 

@author Martijn van Iersel, Augustin Luna
-->
<iso:schema    
  xmlns:iso="http://purl.oclc.org/dsdl/schematron"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  defaultPhase="basic"
  schemaVersion="0.2">
     
	<iso:ns prefix="sbgn" uri="http://sbgn.org/libsbgn/0.2"/>
	
	<iso:title>sbgn_er_validation</iso:title>

	<!--TODO: Syntax rule: state-variable/assignment -->
	
	<iso:phase id="sanity">
		<iso:active pattern="00000"/>	
	</iso:phase>
	
	<iso:phase id="basic"> 
		<iso:active pattern="00001"/>
		<iso:active pattern="00002"/>
		<iso:active pattern="er20001"/>
		<iso:active pattern="er10101"/>
		<iso:active pattern="er10102"/>
		<iso:active pattern="er10103"/>
		<iso:active pattern="er10104"/>
		<iso:active pattern="er10105"/>
		<iso:active pattern="er10106"/>
		<iso:active pattern="er10107"/>
		<iso:active pattern="er10108"/>
	</iso:phase>

	<iso:pattern name="sanity-check" id="00000">
		<iso:rule context="/*">
			<iso:assert id="sanity-check" test="false()">This assertion should always fail.</iso:assert>
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
			<iso:let name="parent-tag-name" value="../local-name()"/>
			<iso:assert 
				id="check-arcgroup"
				role="error"
				test="$parent-tag-name='arcgroup'" diagnostics="id">Parent of glyph with type interaction must be arcgroup.
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	
	<!-- START: Syntax Rules -->
	<iso:pattern name="check-assignment-arc" id="er10101">
		<iso:rule context="sbgn:arc[@class='assignment']">
			<iso:let name="source" value="@source"/>			
			<iso:let name="class" value="//sbgn:glyph[@id=$source]/@class"/>	
			<!-- FIX: state variable I(1)O(1) -->
			<iso:assert 
				id="check-assignment-source-class"
				role="error"
				see="sbgn-er-L1V1.2-3.3.1"				
				test="
				$class='state variable'" 
				diagnostics="source class">Incorrect source reference for arc with class "assignment"
			</iso:assert>
		</iso:rule> 
		<iso:rule context="sbgn:arc[@class='assignment']">
			<iso:let name="target" value="@target"/>			
			<iso:let name="port-class" value="//sbgn:port[@id=$target]/../@class"/>	
			<iso:assert 
				id="check-assignment-target-class"
				role="error"
				see="sbgn-er-L1V1.2-3.3.1"				
				test="
				$port-class='state variable'" 
				diagnostics="target port-class">Incorrect target reference for arc with class "assignment"
			</iso:assert>
		</iso:rule> 	
	</iso:pattern> 
	
	<iso:pattern name="check-interaction" id="er10102">
		<iso:rule context="sbgn:arc[@class='interaction']">
			<iso:let name="source" value="@source"/>			
			<iso:let name="class" value="//sbgn:glyph[@id=$source]/@class"/>	
			<iso:assert 
				id="check-interaction-source-class"
				role="error"
				see="sbgn-er-L1V1.2-3.3.1"				
				test="
				$class='entity' or 
				$class='outcome' or 
				$class='unit of information'" 
				diagnostics="source class">Incorrect source reference for arc with class "interaction"
			</iso:assert>
		</iso:rule> 
		<iso:rule context="sbgn:arc[@class='interaction']">
			<iso:let name="target" value="@target"/>			
			<iso:let name="port-class" value="//sbgn:port[@id=$target]/../@class"/>	
			<iso:assert 
				id="check-interaction-target-class"
				role="error"
				see="sbgn-er-L1V1.2-3.3.1"				
				test="
				$port-class='entity' or 
				$port-class='outcome' or 
				$port-class='unit of information'" 
				diagnostics="target port-class">Incorrect target reference for arc with class "interaction"
			</iso:assert>
		</iso:rule> 
		<!-- Number Limited Rules --> 
		<iso:rule context="sbgn:glyph[@class='outcome']">
			<iso:let name="id" value="@id"/>
			<iso:let name="port-id" value="./sbgn:port/@id"/>				
			<iso:let name="source-count" value="count(//sbgn:arc[(./@class = 'interaction') and (./@source = current()/sbgn:port/@id)])"/>				
			<iso:let name="target-count" value="count(//sbgn:arc[(./@class = 'interaction') and (./@target = current()/sbgn:port/@id)])"/>							
			<iso:assert 
				id="check-interaction-outcome-source_target-count-equals-1"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="($source-count = 1) and ($target-count = 1)"
				diagnostics="id port-id source-count target-count">The 'outcome' glyph can only be connected to one interaction glyph at the input or output. 
			</iso:assert>
		</iso:rule> 			
	</iso:pattern> 
	
	<iso:pattern name="check-modulation" id="er10103">
		<iso:rule context="sbgn:arc[@class='modulation']">
			<iso:let name="source" value="@source"/>			
			<iso:let name="class" value="//sbgn:glyph[@id=$source]/@class"/>	
			<!-- TODO: and or not delay I(1) -->
			<iso:assert 
				id="check-modulation-source-class"
				role="error"
				see="sbgn-er-L1V1.2-3.3.1"				
				test="
				$class='entity' or 
				$class='outcome' or 
				$class='and' or
				$class='or' or
				$class='not' or 	
				$class='delay' or 				
				$class='perturbing agent'" 
				diagnostics="source class">Incorrect source reference for arc with class "modulation"
			</iso:assert>
		</iso:rule> 
		<iso:rule context="sbgn:arc[@class='modulation']">
			<iso:let name="target" value="@target"/>			
			<iso:let name="port-class" value="//sbgn:port[@id=$target]/../@class"/>	
			<!-- TODO: This is probably wrong in the specification -->
			<iso:assert 
				id="check-modulation-target-class"
				role="error"
				see="sbgn-er-L1V1.2-3.3.1"				
				test="
				$port-class=''" 
				diagnostics="target port-class">Incorrect target reference for arc with class "modulation"
			</iso:assert>
		</iso:rule> 
		<!-- Number Limited Rules --> 
		<iso:rule context="sbgn:glyph[(@class='outcome') or (@class='and') or (@class='or') or (@class='not') or (@class='delay')]">
			<iso:let name="id" value="@id"/>
			<iso:let name="port-id" value="./sbgn:port/@id"/>				
			<iso:let name="source-count" value="count(//sbgn:arc[(./@class = 'modulation') and (./@source = current()/sbgn:port/@id)])"/>										
			<iso:assert 
				id="check-modulation-outcome_and_or_not_delay-source-count-equals-1"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="$source-count = 1"
				diagnostics="id port-id source-count">The 'outcome', 'and', 'or', 'not', and 'delay' glyphs can only be connected to one modulation glyph at the input. 
			</iso:assert>
		</iso:rule> 			
	</iso:pattern> 
		
	<iso:pattern name="check-stimulation" id="er10104">
		<iso:rule context="sbgn:arc[@class='stimulation']">
			<iso:let name="source" value="@source"/>			
			<iso:let name="class" value="//sbgn:glyph[@id=$source]/@class"/>	
			<!-- FIX: and or not delay I(1) -->
			<iso:assert 
				id="check-stimulation-source-class"
				role="error"
				see="sbgn-er-L1V1.2-3.3.1"				
				test="
				$class='entity' or 
				$class='outcome' or 
				$class='and' or
				$class='or' or
				$class='not' or 	
				$class='delay' or 				
				$class='perturbing agent'" 
				diagnostics="source class">Incorrect source reference for arc with class "stimulation"
			</iso:assert>
		</iso:rule> 
		<iso:rule context="sbgn:arc[@class='stimulation']">
			<iso:let name="target" value="@target"/>			
			<iso:let name="port-class" value="//sbgn:port[@id=$target]/../@class"/>	
			<iso:assert 
				id="check-stimulation-target-class"
				role="error"
				see="sbgn-er-L1V1.2-3.3.1"				
				test="
				$port-class='modulation' or
				$port-class='stimulation' or
				$port-class='inhibition' or
				$port-class='necessary stimulation' or
				$port-class='absolute stimulation' or
				$port-class='assignment' or
				$port-class='interaction' or
				$port-class='phenotype'" 
				diagnostics="target port-class">Incorrect target reference for arc with class "stimulation"
			</iso:assert>
		</iso:rule> 
		<!-- Number Limited Rules --> 
		<iso:rule context="sbgn:glyph[(@class='outcome') or (@class='and') or (@class='or') or (@class='not') or (@class='delay')]">
			<iso:let name="id" value="@id"/>
			<iso:let name="port-id" value="./sbgn:port/@id"/>				
			<iso:let name="source-count" value="count(//sbgn:arc[(./@class = 'stimulation') and (./@source = current()/sbgn:port/@id)])"/>										
			<iso:assert 
				id="check-stimulation-outcome_and_or_not_delay-source-count-equals-1"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="$source-count = 1"
				diagnostics="id port-id source-count">The 'outcome', 'and', 'or', 'not', and 'delay' glyphs can only be connected to one stimulation glyph at the input.
			</iso:assert>
		</iso:rule> 		
	</iso:pattern> 
	
	<iso:pattern name="check-inhibition" id="er10105">
		<iso:rule context="sbgn:arc[@class='inhibition']">
			<iso:let name="source" value="@source"/>			
			<iso:let name="class" value="//sbgn:glyph[@id=$source]/@class"/>	
			<!-- FIX: and or not delay I(1) -->
			<iso:assert 
				id="check-inhibition-source-class"
				role="error"
				see="sbgn-er-L1V1.2-3.3.1"				
				test="
				$class='entity' or 
				$class='outcome' or 
				$class='and' or
				$class='or' or
				$class='not' or 	
				$class='delay' or 				
				$class='perturbing agent'" 
				diagnostics="source class">Incorrect source reference for arc with class "inhibition"
			</iso:assert>
		</iso:rule> 
		<iso:rule context="sbgn:arc[@class='inhibition']">
			<iso:let name="target" value="@target"/>			
			<iso:let name="port-class" value="//sbgn:port[@id=$target]/../@class"/>	
			<iso:assert 
				id="check-inhibition-target-class"
				role="error"
				see="sbgn-er-L1V1.2-3.3.1"				
				test="
				$port-class='modulation' or
				$port-class='stimulation' or
				$port-class='inhibition' or
				$port-class='necessary stimulation' or
				$port-class='absolute stimulation' or
				$port-class='assignment' or
				$port-class='interaction' or
				$port-class='phenotype'" 
				diagnostics="target port-class">Incorrect target reference for arc with class "inhibition"
			</iso:assert>
		</iso:rule> 
		<!-- Number Limited Rules --> 
		<iso:rule context="sbgn:glyph[(@class='outcome') or (@class='and') or (@class='or') or (@class='not') or (@class='delay')]">
			<iso:let name="id" value="@id"/>
			<iso:let name="port-id" value="./sbgn:port/@id"/>				
			<iso:let name="source-count" value="count(//sbgn:arc[(./@class = 'inhibition') and (./@source = current()/sbgn:port/@id)])"/>										
			<iso:assert 
				id="check-inhibition-outcome_and_or_not_delay-source-count-equals-1"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="$source-count = 1"
				diagnostics="id port-id source-count">The 'outcome', 'and', 'or', 'not', and 'delay' glyphs can only be connected to one inhibition glyph at the input.
			</iso:assert>
		</iso:rule> 		
	</iso:pattern> 
	
	<iso:pattern name="check-necessary-stimulation" id="er10106">
		<iso:rule context="sbgn:arc[@class='necessary stimulation']">
			<iso:let name="source" value="@source"/>			
			<iso:let name="class" value="//sbgn:glyph[@id=$source]/@class"/>	
			<!-- FIX: and or not delay I(1) -->
			<iso:assert 
				id="check-necessary-stimulation-source-class"
				role="error"
				see="sbgn-er-L1V1.2-3.3.1"				
				test="
				$class='entity' or 
				$class='outcome' or 
				$class='and' or
				$class='or' or
				$class='not' or 	
				$class='delay' or 				
				$class='perturbing agent'" 
				diagnostics="source class">Incorrect source reference for arc with class "necessary stimulation"
			</iso:assert>
		</iso:rule> 
		<iso:rule context="sbgn:arc[@class='necessary stimulation']">
			<iso:let name="target" value="@target"/>			
			<iso:let name="port-class" value="//sbgn:port[@id=$target]/../@class"/>	
			<iso:assert 
				id="check-necessary-stimulation-target-class"
				role="error"
				see="sbgn-er-L1V1.2-3.3.1"				
				test="
				$port-class='modulation' or
				$port-class='stimulation' or
				$port-class='inhibition' or
				$port-class='necessary stimulation' or
				$port-class='absolute stimulation' or
				$port-class='assignment' or
				$port-class='interaction' or
				$port-class='phenotype'" 
				diagnostics="target port-class">Incorrect target reference for arc with class "necessary stimulation"
			</iso:assert>
		</iso:rule> 
		<!-- Number Limited Rules --> 
		<iso:rule context="sbgn:glyph[(@class='outcome') or (@class='and') or (@class='or') or (@class='not') or (@class='delay')]">
			<iso:let name="id" value="@id"/>
			<iso:let name="port-id" value="./sbgn:port/@id"/>				
			<iso:let name="source-count" value="count(//sbgn:arc[(./@class = 'necessary stimulation') and (./@source = current()/sbgn:port/@id)])"/>										
			<iso:assert 
				id="check-necessary_stimulation-outcome_and_or_not_delay-source-count-equals-1"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="$source-count = 1"
				diagnostics="id port-id source-count">The 'outcome', 'and', 'or', 'not', and 'delay' glyphs can only be connected to one necessary stimulation glyph at the input.
			</iso:assert>
		</iso:rule> 		
	</iso:pattern> 
	
	<iso:pattern name="check-absolute-stimulation" id="er10107">
		<iso:rule context="sbgn:arc[@class='absolute stimulation']">
			<iso:let name="source" value="@source"/>			
			<iso:let name="class" value="//sbgn:glyph[@id=$source]/@class"/>	
			<iso:assert 
				id="check-absolute-stimulation-source-class"
				role="error"
				see="sbgn-er-L1V1.2-3.3.1"				
				test="
				$class='entity' or 
				$class='outcome' or 
				$class='and' or
				$class='or' or
				$class='not' or 	
				$class='delay' or 				
				$class='perturbing agent'" 
				diagnostics="source class">Incorrect source reference for arc with class "absolute stimulation"
			</iso:assert>
		</iso:rule> 
		<iso:rule context="sbgn:arc[@class='absolute stimulation']">
			<iso:let name="target" value="@target"/>			
			<iso:let name="port-class" value="//sbgn:port[@id=$target]/../@class"/>	
			<iso:assert 
				id="check-absolute-stimulation-target-class"
				role="error"
				see="sbgn-er-L1V1.2-3.3.1"				
				test="
				$port-class='modulation' or
				$port-class='stimulation' or
				$port-class='inhibition' or
				$port-class='necessary stimulation' or
				$port-class='absolute stimulation' or
				$port-class='assignment' or
				$port-class='interaction' or
				$port-class='phenotype'" 
				diagnostics="target port-class">Incorrect target reference for arc with class "absolute stimulation"
			</iso:assert>
		</iso:rule> 
		<!-- Number Limited Rules --> 
		<iso:rule context="sbgn:glyph[(@class='outcome') or (@class='and') or (@class='or') or (@class='not') or (@class='delay')]">
			<iso:let name="id" value="@id"/>
			<iso:let name="port-id" value="./sbgn:port/@id"/>				
			<iso:let name="source-count" value="count(//sbgn:arc[(./@class = 'absolute stimulation') and (./@source = current()/sbgn:port/@id)])"/>										
			<iso:assert 
				id="check-absolute_stimulation-outcome_and_or_not_delay-source-count-equals-1"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="$source-count = 1"
				diagnostics="id port-id source-count">The 'outcome', 'and', 'or', 'not', and 'delay' glyphs can only be connected to one absolute stimulation glyph at the input.
			</iso:assert>
		</iso:rule>		
	</iso:pattern> 	
	
	<iso:pattern name="check-absolute-inhibition" id="er10108">
		<iso:rule context="sbgn:arc[@class='absolute inhibition']">
			<iso:let name="source" value="@source"/>			
			<iso:let name="class" value="//sbgn:glyph[@id=$source]/@class"/>	
			<!-- FIX: and or not delay I(1) -->
			<iso:assert 
				id="check-absolute-inhibition-source-class"
				role="error"
				see="sbgn-er-L1V1.2-3.3.1"				
				test="
				$class='entity' or 
				$class='outcome' or 
				$class='and' or
				$class='or' or
				$class='not' or 	
				$class='delay' or 				
				$class='perturbing agent'" 
				diagnostics="source class">Incorrect source reference for arc with class "absolute inhibition"
			</iso:assert>
		</iso:rule> 
		<iso:rule context="sbgn:arc[@class='absolute inhibition']">
			<iso:let name="target" value="@target"/>			
			<iso:let name="port-class" value="//sbgn:port[@id=$target]/../@class"/>	
			<iso:assert 
				id="check-absolute-inhibition-target-class"
				role="error"
				see="sbgn-er-L1V1.2-3.3.1"				
				test="
				$port-class='modulation' or
				$port-class='stimulation' or
				$port-class='inhibition' or
				$port-class='necessary stimulation' or
				$port-class='absolute stimulation' or
				$port-class='assignment' or
				$port-class='interaction' or
				$port-class='phenotype'" 
				diagnostics="target port-class">Incorrect target reference for arc with class "absolute inhibition"
			</iso:assert>
		</iso:rule> 
		<!-- Number Limited Rules --> 
		<iso:rule context="sbgn:glyph[(@class='outcome') or (@class='and') or (@class='or') or (@class='not') or (@class='delay')]">
			<iso:let name="id" value="@id"/>
			<iso:let name="port-id" value="./sbgn:port/@id"/>				
			<iso:let name="source-count" value="count(//sbgn:arc[(./@class = 'absolute inhibition') and (./@source = current()/sbgn:port/@id)])"/>										
			<iso:assert 
				id="check-absolute_inhibition-outcome_and_or_not_delay-source-count-equals-1"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="$source-count = 1"
				diagnostics="id port-id source-count">The 'outcome', 'and', 'or', 'not', and 'delay' glyphs can only be connected to one absolute inhibition glyph at the input.
			</iso:assert>
		</iso:rule>				
	</iso:pattern> 		
	
	<iso:pattern name="check-logic-arc" id="er10108">
		<iso:rule context="sbgn:arc[@class='logic arc']">
			<iso:let name="source" value="@source"/>			
			<iso:let name="class" value="//sbgn:glyph[@id=$source]/@class"/>	
			<!-- FIX: and or not delay I(1)O(1) -->
			<iso:assert 
				id="check-logic-arc-source-class"
				role="error"
				see="sbgn-er-L1V1.2-3.3.1"				
				test="
				$class='entity' or 
				$class='outcome' or 
				$class='and' or
				$class='or' or
				$class='not' or 	
				$class='delay' or 				
				$class='perturbing agent'" 
				diagnostics="source class">Incorrect source reference for arc with class "absolute inhibition"
			</iso:assert>
		</iso:rule> 
		<iso:rule context="sbgn:arc[@class='logic arc']">
			<iso:let name="target" value="@target"/>			
			<iso:let name="port-class" value="//sbgn:port[@id=$target]/../@class"/>	
			<iso:assert 
				id="check-logic-arc-target-class"
				role="error"
				see="sbgn-er-L1V1.2-3.3.1"				
				test="
				$port-class='and' or
				$port-class='or' or
				$port-class='not' or
				$port-class='delay'" 
				diagnostics="target port-class">Incorrect target reference for arc with class "logic arc"
			</iso:assert>
		</iso:rule> 
		<!-- Number Limited Rules --> 
		<iso:rule context="sbgn:glyph[(@class='outcome') or (@class='and') or (@class='or') or (@class='not') or (@class='delay')]">
			<iso:let name="id" value="@id"/>
			<iso:let name="port-id" value="./sbgn:port/@id"/>				
			<iso:let name="source-count" value="count(//sbgn:arc[(./@class = 'logic arc') and (./@source = current()/sbgn:port/@id)])"/>										
			<iso:assert 
				id="check-logic_arc-outcome_and_or_not_delay-source-count-equals-1"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="$source-count = 1"
				diagnostics="id port-id source-count">The 'outcome', 'and', 'or', 'not', and 'delay' glyphs can only be connected to one logic arc glyph at the input.
			</iso:assert>
		</iso:rule>		
		<iso:rule context="sbgn:glyph[(@class='not') or (@class='delay')]">
			<iso:let name="id" value="@id"/>
			<iso:let name="port-id" value="./sbgn:port/@id"/>				
			<iso:let name="target-count" value="count(//sbgn:arc[(./@class = 'logic arc') and (./@target = current()/sbgn:port/@id)])"/>										
			<iso:assert 
				id="check-logic_arc-not_delay-target-count-equals-1"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="$target-count = 1"
				diagnostics="id port-id target-count">The 'outcome', 'and', 'or', 'not', and 'delay' glyphs can only be connected to one logic arc glyph at the output.
			</iso:assert>
		</iso:rule>				
	</iso:pattern> 		
	<!-- END: Syntax Rules --> 
	
	<iso:diagnostics>
		<iso:diagnostic id="id"><iso:value-of select="$id"/></iso:diagnostic> 		
		<iso:diagnostic id="parent"><iso:value-of select="$parent"/></iso:diagnostic> 		
		<iso:diagnostic id="source"><iso:value-of select="$source"/></iso:diagnostic> 		
		<iso:diagnostic id="class"><iso:value-of select="$class"/></iso:diagnostic> 
		<iso:diagnostic id="source-count"><iso:value-of select="$source-count"/></iso:diagnostic> 
		<iso:diagnostic id="target-count"><iso:value-of select="$target-count"/></iso:diagnostic> 
		<iso:diagnostic id="target"><iso:value-of select="$target"/></iso:diagnostic> 
		<iso:diagnostic id="port-id"><iso:value-of select="$port-id"/></iso:diagnostic> 
		<iso:diagnostic id="port-class"><iso:value-of select="$port-class"/></iso:diagnostic> 
	</iso:diagnostics> 
</iso:schema>