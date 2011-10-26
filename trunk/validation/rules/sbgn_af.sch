<!-- 

Schematron validation for SBGN AF 

@author Augustin Luna
-->
<iso:schema    
  xmlns:iso="http://purl.oclc.org/dsdl/schematron"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  defaultPhase="basic"
  schemaVersion="0.1">
     
	<iso:ns prefix="sbgn" uri="http://sbgn.org/libsbgn/0.2"/>
	
	<iso:title>sbgn_af_validation</iso:title>
	
	<iso:phase id="sanity">
		<iso:active pattern="sanity-check"/>	
	</iso:phase>
	
	<iso:phase id="basic"> 
		<iso:active pattern="check-id"/>
		<iso:active pattern="check-idref"/>
		<iso:active pattern="check-positive-influence"/>
		<iso:active pattern="check-negative-influence"/>
		<iso:active pattern="check-unknown-influence"/>
		<iso:active pattern="check-necessary-stimulation"/>
		<iso:active pattern="check-logic-arc"/>
		<iso:active pattern="check-equivalence-arc"/>		
	</iso:phase>

	<iso:pattern id="sanity-check"> <!-- old id: 00000 -->
		<iso:rule context="/*">
			<iso:assert id="sanity-check" test="false()">This assertion should always fail.</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	
	<iso:pattern id="check-id"> <!-- old id: 00001 -->
		<iso:rule context="//*[@id]">
			<iso:let name="id" value="@id"/>
			<iso:assert 
			role="error"
			test="count(//@id[. = current()/@id]) = 1" diagnostics="id">ID needs to be unique.</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	
	<iso:pattern id="check-idref"> <!-- old id: 00002 -->
		<iso:rule context="sbgn:arc">
			<iso:let name="target" value="@target"/>
			<iso:assert
			role="error"
			test="//*/@id[. = $target]" diagnostics="target">An arc target should be a glyph defined in the diagram.</iso:assert>
		</iso:rule> 
	</iso:pattern> 

	<iso:pattern id="check-positive-influence"> <!-- old id: af10101 -->
		<iso:rule context="sbgn:arc[@class='positive influence']">
			<iso:let name="source" value="@source"/>			
			<iso:let name="source-class" value="//sbgn:glyph[@id=$source]/@class"/>			
			<iso:let name="target" value="@target"/>			
			<iso:let name="target-class" value="//sbgn:glyph[@id=$target]/@class"/>				
			<iso:let name="port-class" value="//sbgn:port[@id=$source]/../@class"/>				
			<iso:assert 
				id="check-positive-influence-source-class-activity-nodes"
				role="error"
				see="sbgn-af-L1V1.0-3.3.1"				
				test="
				$source-class='biological activity' or 
				$source-class='perturbation' or
				$port-class='and' or 
				$port-class='or' or 	
				$port-class='not' or 
				$port-class='delay'"
				diagnostics="source source-class port-class">Incorrect source reference for arc with class "positive influence"
			</iso:assert>
			<iso:assert 
				id="check-positive-influence-target-class"
				role="error"
				see="sbgn-af-L1V1.0-3.3.1"				
				test="
				$target-class='biological activity' or 
				$target-class='phenotype'" 
				diagnostics="target target-class port-class">Incorrect target reference for arc with class "positive influence"
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 

	<iso:pattern id="check-negative-influence"> <!-- old id: af10102 -->
		<iso:rule context="sbgn:arc[@class='negative influence']">
			<iso:let name="source" value="@source"/>			
			<iso:let name="source-class" value="//sbgn:glyph[@id=$source]/@class"/>
			<iso:let name="target" value="@target"/>			
			<iso:let name="target-class" value="//sbgn:glyph[@id=$target]/@class"/>				
			<iso:let name="port-class" value="//sbgn:port[@id=$source]/../@class"/>				
			<iso:assert 
				id="check-negative-influence-source-class"
				role="error"
				see="sbgn-af-L1V1.0-3.3.1"				
				test="
				$source-class='biological activity' or 
				$source-class='perturbation' or
				$port-class='and' or 
				$port-class='or' or 	
				$port-class='not' or 
				$port-class='delay'" 
				diagnostics="source source-class port-class">Incorrect source reference for arc with class "negative influence"
			</iso:assert>
			<iso:assert 
				id="check-negative-influence-target-class"
				role="error"
				see="sbgn-af-L1V1.0-3.3.1"				
				test="
				$target-class='biological activity' or 
				$target-class='phenotype'" 
				diagnostics="target target-class port-class">Incorrect target reference for arc with class "negative influence"
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	
	<iso:pattern id="check-unknown-influence"> <!-- old id: af10103 -->
		<iso:rule context="sbgn:arc[@class='unknown influence']">
			<iso:let name="source" value="@source"/>			
			<iso:let name="source-class" value="//sbgn:glyph[@id=$source]/@class"/>	
			<iso:let name="target" value="@target"/>			
			<iso:let name="target-class" value="//sbgn:glyph[@id=$target]/@class"/>				
			<iso:let name="port-class" value="//sbgn:port[@id=$source]/../@class"/>		
			<iso:assert 
				id="check-unknown-influence-source-class"
				role="error"
				see="sbgn-af-L1V1.0-3.3.1"				
				test="
				$source-class='biological activity' or 
				$source-class='perturbation' or
				$port-class='and' or 
				$port-class='or' or 	
				$port-class='not' or 
				$port-class='delay'" 
				diagnostics="source source-class port-class">Incorrect source reference for arc with class "unknown influence"
			</iso:assert>
			<iso:assert 
				id="check-unknown-influence-target-class"
				role="error"
				see="sbgn-af-L1V1.0-3.3.1"				
				test="
				$target-class='biological activity' or 
				$target-class='phenotype'" 
				diagnostics="target target-class">Incorrect target reference for arc with class "unknown influence"
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	
	<iso:pattern id="check-necessary-stimulation"> <!-- old id: af10104 -->
		<iso:rule context="sbgn:arc[@class='necessary stimulation']">
			<iso:let name="source" value="@source"/>			
			<iso:let name="source-class" value="//sbgn:glyph[@id=$source]/@class"/>	
			<iso:let name="target" value="@target"/>			
			<iso:let name="target-class" value="//sbgn:glyph[@id=$target]/@class"/>	
			<iso:let name="port-class" value="//sbgn:port[@id=$source]/../@class"/>					
			<iso:assert 
				id="check-necessary-stimulation-source-class"
				role="error"
				see="sbgn-af-L1V1.0-3.3.1"				
				test="
				$source-class='biological activity' or 
				$source-class='perturbation' or
				$port-class='and' or 
				$port-class='or' or 	
				$port-class='not' or 
				$port-class='delay'" 
				diagnostics="source source-class port-class">Incorrect source reference for arc with class "necessary stimulation"
			</iso:assert>
			<iso:assert 
				id="check-necessary-stimulation-target-class"
				role="error"
				see="sbgn-af-L1V1.0-3.3.1"				
				test="
				$target-class='biological activity' or 
				$target-class='phenotype'" 
				diagnostics="target target-class">Incorrect target reference for arc with class "necessary stimulation"
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	
	<iso:pattern id="check-logic-arc"> <!-- old id: af10105 -->
		<iso:rule context="sbgn:arc[@class='logic arc']">
			<iso:let name="source" value="@source"/>			
			<iso:let name="source-class" value="//sbgn:glyph[@id=$source]/@class"/>	
			<iso:let name="target" value="@target"/>			
			<iso:let name="target-class" value="//sbgn:glyph[@id=$target]/@class"/>	
			<iso:let name="port-class" value="//sbgn:port[@id=$target]/../@class"/>		
			<iso:assert 
				id="check-logic-arc-source-class"
				role="error"
				see="sbgn-af-L1V1.0-3.3.1"				
				test="
				$source-class='biological activity'" 
				diagnostics="source source-class">Incorrect source reference for arc with class "logic arc"
			</iso:assert>
			<iso:assert 
				id="check-logic-arc-target-class"
				role="error"
				see="sbgn-af-L1V1.0-3.3.1"				
				test="
				$port-class='and' or 
				$port-class='or' or
				$port-class='not' or
				$port-class='delay'" 
				diagnostics="target target-class port-class">Incorrect target reference for arc with class "logic arc"
			</iso:assert>
		</iso:rule> 
		<!-- Limited Number Rules -->
		<iso:rule context="sbgn:glyph[@class='not']">
			<iso:let name="id" value="@id"/>
			<iso:let name="port-id" value="./sbgn:port/@id"/>				
			<iso:let name="count" value="count(//sbgn:arc[(./@class = 'logic arc') and (./@target = current()/sbgn:port/@id)])"/>				
			<iso:assert 
				id="check-logic_arc-not-target-count-equals-1"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="$count = 1"
				diagnostics="id port-id count">'not' glyph can only be connected to one logic arc glyph. 
			</iso:assert>	
		</iso:rule>	
	</iso:pattern> 
	
	<iso:pattern id="check-equivalence-arc"> <!-- old id: af10106 -->
		<iso:rule context="sbgn:arc[@class='equivalence arc']">
			<iso:let name="source" value="@source"/>			
			<iso:let name="source-class" value="//sbgn:glyph[@id=$source]/@class"/>	
			<iso:let name="target" value="@target"/>			
			<iso:let name="target-class" value="//sbgn:glyph[@id=$target]/@class"/>	
			<iso:assert 
				id="check-equivalence-arc-source-class"
				role="error"
				see="sbgn-af-L1V1.0-3.3.1"				
				test="
				$source-class='biological activity'" 
				diagnostics="source source-class">Incorrect source reference for arc with class "equivalence arc"
			</iso:assert>
			<iso:assert 
				id="check-equivalence-arc-target-class"
				role="error"
				see="sbgn-af-L1V1.0-3.3.1"				
				test="
				$target-class='tag' or
				$target-class='submap'" 
				diagnostics="target target-class">Incorrect target reference for arc with class "equivalence arc"
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	
	<iso:diagnostics>
		<iso:diagnostic id="id"><iso:value-of select="$id"/></iso:diagnostic> 		
		<iso:diagnostic id="port-id"><iso:value-of select="$port-id"/></iso:diagnostic> 				
		<iso:diagnostic id="target"><iso:value-of select="$target"/></iso:diagnostic> 
		<iso:diagnostic id="source"><iso:value-of select="$source"/></iso:diagnostic> 		
		<iso:diagnostic id="class"><iso:value-of select="$class"/></iso:diagnostic> 
		<iso:diagnostic id="source-class"><iso:value-of select="$source-class"/></iso:diagnostic> 
		<iso:diagnostic id="target-class"><iso:value-of select="$target-class"/></iso:diagnostic> 		
		<iso:diagnostic id="port-class"><iso:value-of select="$port-class"/></iso:diagnostic> 
		<iso:diagnostic id="arc-count"><iso:value-of select="$arc-count"/></iso:diagnostic>
		<iso:diagnostic id="count"><iso:value-of select="$count"/></iso:diagnostic> 		
	</iso:diagnostics> 
</iso:schema>