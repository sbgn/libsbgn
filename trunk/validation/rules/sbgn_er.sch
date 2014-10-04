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
		<iso:active pattern="er10109"/>
		<iso:active pattern="er10111"/>
	</iso:phase>

	<iso:pattern id="00000">
		<iso:rule context="/*">
			<iso:assert 
				id="00000" 
				name="sanity-check" 
				test="false()">This assertion should always fail.</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	
	<iso:pattern id="00001">
		<iso:rule context="//*[@id]">
			<iso:let name="id" value="@id"/>
			<iso:assert
			id="00001"
			role="error"
			test="count(//@id[. = current()/@id]) = 1" diagnostics="id">ID needs to be unique.</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	
	<iso:pattern id="00002">
		<iso:rule context="sbgn:arc">
			<iso:let name="target" value="@target"/>
			<iso:assert
			id="00002"
			role="error"
			test="//*/@id[. = $target]">An arc target should be a glyph defined in the diagram.</iso:assert>
		</iso:rule> 
	</iso:pattern> 

	<iso:pattern id="er20001">
		<iso:rule context="sbgn:glyph[@class='interaction']">
			<iso:let name="id" value="@id"/>
			<iso:let name="parent-tag-name" value="../local-name()"/>
			<iso:assert 
				id="er20001"
				name="check-arcgroup"
				role="error"
				test="$parent-tag-name='arcgroup'" diagnostics="id">Parent of glyph with type interaction must be arcgroup.
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	
	<!-- START: Syntax Rules -->
	<iso:pattern id="er10101">
		<iso:rule context="sbgn:arc[@class='assignment']">
			<iso:let name="source" value="@source"/>			
			<iso:let name="class" value="//sbgn:glyph[@id=$source]/@class"/>	
			<!-- FIX: state variable I(1)O(1) -->
			<iso:assert 
				id="er10101"
				name="check-assignment-source-class"
				role="error"
				see="sbgn-er-L1V1.2-3.3.1"				
				test="
				$class='variable value' or
				$class='implicit xor'" 
				diagnostics="source class">Incorrect source reference for arc with class "assignment"
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	<iso:pattern id="er10102">
		<iso:rule context="sbgn:arc[@class='assignment']">
			<iso:let name="id" value="@id"/>			
			<iso:let name="target" value="@target"/>			
			<iso:let name="target-class" value="//sbgn:glyph[@id=$target]/@class"/>	
			<iso:assert 
				id="er10102"
				name="check-assignment-target-class"
				role="error"
				see="sbgn-er-L1V1.2-3.3.1"				
				test="
				$target-class='state variable' or
				$target-class='existence' or
				$target-class='location' or
				$target-class='implicit xor'"
				diagnostics="id target target-class">Incorrect target reference for arc with class "assignment"
			</iso:assert>
		</iso:rule> 	
	</iso:pattern> 
	
	<iso:pattern id="er10103">
		<iso:rule context="sbgn:arc[@class='interaction']">
			<iso:let name="id" value="@id"/>	
			<iso:let name="source" value="@source"/>			
			<iso:let name="class" value="//sbgn:glyph[@id=$source]/@class"/>	
			<iso:assert 
				id="er10103"
				name="check-interaction-source-class"
				role="error"
				see="sbgn-er-L1V1.2-3.3.1"				
				test="
				$class='entity' or 
				$class='outcome' or 
				$class='unit of information' or
				$class='interaction'" 
				diagnostics="id source class">Incorrect source reference for arc with class "interaction"
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	<iso:pattern id="er10104">
		<iso:rule context="sbgn:arc[@class='interaction']">
			<iso:let name="id" value="@id"/>
			<iso:let name="target" value="@target"/>			
			<iso:let name="target-class" value="//sbgn:glyph[@id=$target]/@class"/>	
			<iso:assert 
				id="er10104"
				name="check-interaction-target-class"
				role="error"
				see="sbgn-er-L1V1.2-3.3.1"				
				test="
				$target-class='entity' or 
				$target-class='outcome' or 
				$target-class='unit of information'" 
				diagnostics="id target target-class">Incorrect target reference for arc with class "interaction"
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	<iso:pattern id="er10105">
		<!-- Number Limited Rules --> 
		<iso:rule context="sbgn:glyph[@class='outcome']">
			<iso:let name="id" value="@id"/>
			<iso:let name="port-id" value="./sbgn:port/@id"/>				
			<iso:let name="source-count" value="count(//sbgn:arc[(./@class = 'interaction') and (./@source = current()/sbgn:port/@id)])"/>				
			<iso:let name="target-count" value="count(//sbgn:arc[(./@class = 'interaction') and (./@target = current()/sbgn:port/@id)])"/>							
			<iso:assert 
				id="er10105"
				name="check-interaction-outcome-source_target-count-equals-1"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="($source-count &lt;= 1) and ($target-count &lt;= 1)"
				diagnostics="id port-id source-count target-count">The 'outcome' glyph can only be connected to one interaction glyph at the input or output. 
			</iso:assert>
		</iso:rule> 			
	</iso:pattern> 
	
	<iso:pattern id="er10106">
		<iso:rule context="sbgn:arc[(@class='modulation') or (@class='stimulation') or (@class='inhibition') or (@class='necessary stimulation') or (@class='absolute inhibition') or (@class='absolute stimulation')]">
			<iso:let name="id" value="@id"/>
			<iso:let name="source" value="@source"/>			
			<iso:let name="port-class" value="//sbgn:port[@id=$source]/../@class"/>	
			<iso:let name="class" value="//sbgn:glyph[@id=$source]/@class"/>	
			<iso:assert 
				id="er10106"
				name="check-influence-source-class"
				role="error"
				see="sbgn-er-L1V1.2-3.3.1"
				test="
				$class='entity' or 
				$class='outcome' or 
				$port-class='and' or
				$port-class='or' or
				$port-class='not' or 	
				$port-class='delay' or 				
				$class='perturbing agent'" 
				diagnostics="id source port-class class">Incorrect source reference for influence arc
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	<iso:pattern id="er10107">
		<iso:rule context="sbgn:arc[(@class='modulation') or (@class='stimulation') or (@class='inhibition') or (@class='necessary stimulation') or (@class='absolute inhibition') or (@class='absolute stimulation')]">
			<iso:let name="id" value="@id"/>
			<iso:let name="target" value="@target"/>			
			<iso:let name="class" value="//sbgn:glyph[@id=$target]/@class"/>	
			<iso:let name="port-class" value="//sbgn:port[@id=$target]/../@class"/>	
			<iso:assert 
				id="er10107"
				name="check-influence-target-class"
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
				$class='phenotype'" 
				diagnostics="id target port-class class">Incorrect target reference for influence arc
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 

	<iso:pattern id="er10108">
		<!-- Number Limited Rules --> 
		<iso:rule context="sbgn:glyph[(@class='outcome') or (@class='and') or (@class='or') or (@class='not') or (@class='delay')]">
			<iso:let name="id" value="@id"/>
			<iso:let name="port-id" value="./sbgn:port/@id"/>				
			<iso:let name="source-count" value="count(//sbgn:arc[./@source = current()/sbgn:port/@id])"/>										
			<iso:assert 
				id="er10108"
				name="check-modulation-outcome_and_or_not_delay-source-count-equals-1"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="$source-count &lt;= 1"
				diagnostics="id port-id source-count">The 'outcome', 'and', 'or', 'not', and 'delay' glyphs can only be connected to one arc at the input. 
			</iso:assert>
		</iso:rule> 			
	</iso:pattern> 
			
	<iso:pattern id="er10109">
		<iso:rule context="sbgn:arc[@class='logic arc']">
			<iso:let name="id" value="@id"/>
			<iso:let name="target" value="@target"/>			
			<iso:let name="port-class" value="//sbgn:port[@id=$target]/../@class"/>	
			<iso:assert 
				id="er10109"
				name="check-logic-arc-target-class"
				role="error"
				see="sbgn-er-L1V1.2-3.3.1"				
				test="
				$port-class='and' or
				$port-class='or' or
				$port-class='not' or
				$port-class='delay'" 
				diagnostics="id target port-class">Incorrect target reference for arc with class "logic arc"
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	<iso:pattern id="er10111">
		<iso:rule context="sbgn:glyph[(@class='not') or (@class='delay')]">
			<iso:let name="id" value="@id"/>
			<iso:let name="port-id" value="./sbgn:port/@id"/>				
			<iso:let name="target-count" value="count(//sbgn:arc[(./@class = 'logic arc') and (./@target = current()/sbgn:port/@id)])"/>										
			<iso:assert 
				id="er10111"
				name="check-logic_arc-not_delay-target-count-equals-1"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="$target-count &lt;= 1"
				diagnostics="id port-id target-count">The 'not', and 'delay' glyphs can only be connected to one logic arc glyph at the output.
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
		<iso:diagnostic id="target-class"><iso:value-of select="$target-class"/></iso:diagnostic> 
		<iso:diagnostic id="port-id"><iso:value-of select="$port-id"/></iso:diagnostic> 
		<iso:diagnostic id="port-class"><iso:value-of select="$port-class"/></iso:diagnostic> 
	</iso:diagnostics> 
</iso:schema>