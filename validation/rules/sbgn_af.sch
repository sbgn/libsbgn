<?xml version="1.0" encoding="UTF-8"?>
<!-- 

Schematron validation for SBGN AF 

@author Augustin Luna
-->
<iso:schema    
  xmlns:iso="http://purl.oclc.org/dsdl/schematron"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  defaultPhase="basic"
  schemaVersion="0.1">
     
	<iso:ns prefix="sbgn" uri="http://sbgn.org/libsbgn/0.3"/>
	
	<iso:title>sbgn_af_validation</iso:title>
	
	<iso:phase id="sanity">
		<iso:active pattern="00000"/>	
	</iso:phase>
	
	<iso:phase id="basic"> 
		<iso:active pattern="00001"/>
		<iso:active pattern="00002"/>
		<iso:active pattern="af10101"/>
		<iso:active pattern="af10102"/>
		<iso:active pattern="af10103"/>
		<iso:active pattern="af10104"/>
		<iso:active pattern="af10109"/>
		<iso:active pattern="af10110"/>
		<iso:active pattern="af10111"/>
		<iso:active pattern="af10112"/>
		<iso:active pattern="af10113"/>
		<iso:active pattern="af10114"/>
	</iso:phase>

	<iso:pattern id="00000">
		<iso:rule context="/*">
			<iso:assert id="00000" name="sanity-check" test="false()">This assertion should always fail.</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	
	<iso:pattern id="00001">
		<iso:rule context="//*[@id]">
			<iso:let name="id" value="@id"/>
			<iso:assert 
id="00001"
role="error"
test="count(//@id[. = current()/@id]) = 1" diagnostics="id">
Error: Each SBGN element must have a unique ID. Duplicate ID detected in the diagram.
</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	
	<iso:pattern id="00002">
		<iso:rule context="sbgn:arc">
			<iso:let name="target" value="@target"/>
			<iso:assert
id="00002"
role="error"
test="//*/@id[. = $target]" diagnostics="target">
Error: The target attribute of this arc references an ID that does not exist as a glyph in the diagram.
Ensure that all arc targets reference valid glyph IDs.
</iso:assert>
	</iso:pattern> 

	<iso:pattern id="af10101">
		<iso:rule context="sbgn:arc[(@class='positive influence') or (@class='negative influence') or 
			(@class='unknown influence') or (@class='necessary stimulation')]">
			<iso:let name="id" value="@id"/>
			<iso:let name="source" value="@source"/>			
			<iso:let name="source-class" value="//sbgn:glyph[@id=$source]/@class"/>			
			<iso:let name="port-class" value="//sbgn:port[@id=$source]/../@class"/>				
			<iso:assert 
				id="af10101"
				name="check-positive-influence-source-class-activity-nodes"
				role="error"
				see="sbgn-af-L1V1.0-3.3.1"				
				test="
				$source-class='biological activity' or 
				$source-class='perturbation' or
				$port-class='and' or 
				$port-class='or' or 	
				$port-class='not' or 
				$port-class='delay'"
				diagnostics="id source source-class port-class">Incorrect source reference for influence arc
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	<iso:pattern id="af10102">
		<iso:rule context="sbgn:arc[(@class='positive influence') or (@class='negative influence') or 
			(@class='unknown influence') or (@class='necessary stimulation')]">		
			<iso:let name="id" value="@id"/>
			<iso:let name="target" value="@target"/>			
			<iso:let name="target-class" value="//sbgn:glyph[@id=$target]/@class"/>				
			<iso:let name="port-class" value="//sbgn:port[@id=$target]/../@class"/>				
			<iso:assert
				id="af10102"
				name="check-positive-influence-target-class"
				role="error"
				see="sbgn-af-L1V1.0-3.3.1"				
				test="
				$target-class='biological activity' or 
				$target-class='phenotype'" 
				diagnostics="id target target-class port-class">IError: Influence arcs must target a valid node such as 'biological activity' or 'phenotype'.
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 


	<iso:pattern id="af10103">
		<iso:rule context="sbgn:arc">
			<iso:let name="id" value="@id"/>
			<iso:let name="class" value="@class"/>			
			<iso:assert 
				id="af10103"
				name="check-arc-class"
				role="error"
				see="sbgn-af-L1V1..."
				test="
				$class='logic arc' or 
				$class='equivalence arc' or 
				$class='positive influence' or
				$class='negative influence' or
				$class='necessary stimulation' or
				$class='unknown influence'
				"
				diagnostics="id class">Error: This arc class is not valid for SBGN Activity Flow diagrams.
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 

	<iso:pattern id="af10104">
		<iso:rule context="sbgn:glyph">
			<iso:let name="id" value="@id"/>
			<iso:let name="class" value="@class"/>			
			<iso:assert 
				id="af10104"
				name="check-glyph-class"
				role="error"
				see="sbgn-af-L1V1..."
				test="
				$class='biological activity' or 
				$class='and' or 
				$class='or' or
				$class='not' or
				$class='delay' or
				$class='tag' or
				$class='submap' or
				$class='terminal' or
				$class='unit of information' or
				$class='compartment' or
				$class='perturbation' or
				$class='phenotype'
				"
				diagnostics="id class">Error: This glyph class is not allowed in SBGN Activity Flow diagrams.
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 

	<iso:pattern id="af10109">
		<iso:rule context="sbgn:arc[@class='logic arc']">
			<iso:let name="id" value="@id"/>
			<iso:let name="source" value="@source"/>			
			<iso:let name="source-class" value="//sbgn:glyph[@id=$source]/@class"/>	
			<iso:assert 
				id="af10109"
				name="check-logic-arc-source-class"
				role="error"
				see="sbgn-af-L1V1.0-3.3.1"				
				test="
				$source-class='biological activity'" 
				diagnostics="id source source-class">Error: Logic arcs must originate from a 'biological activity' glyph.
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 

	<iso:pattern id="af10110">
		<iso:rule context="sbgn:arc[@class='logic arc']">
			<iso:let name="id" value="@id"/>
			<iso:let name="target" value="@target"/>			
			<iso:let name="target-class" value="//sbgn:glyph[@id=$target]/@class"/>	
			<iso:let name="port-class" value="//sbgn:port[@id=$target]/../@class"/>		
			<iso:assert 
				id="af10110"
				name="check-logic-arc-target-class"
				role="error"
				see="sbgn-af-L1V1.0-3.3.1"				
				test="
				$port-class='and' or 
				$port-class='or' or
				$port-class='not' or
				$port-class='delay'" 
				diagnostics="id target target-class port-class">Error: Logic arcs must target a logic operator glyph such as 'and', 'or', 'not', or 'delay'.
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	<!-- Limited Number Rules -->

	<iso:pattern id="af10111">
		<iso:rule context="sbgn:glyph[@class='not']">
			<iso:let name="id" value="@id"/>
			<iso:let name="port-id" value="./sbgn:port/@id"/>				
			<iso:let name="count" value="count(//sbgn:arc[(./@class = 'logic arc') and (./@target = current()/sbgn:port/@id)])"/>				
			<iso:assert 
				id="af10111"
				name="check-logic_arc-not-target-count-equals-1"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="$count = 1"
				diagnostics="id port-id count">Error: A 'not' logic glyph must have exactly one incoming logic arc connection.
		</iso:rule>	
	</iso:pattern> 
	
	<iso:pattern id="af10112">
		<iso:rule context="sbgn:arc[@class='equivalence arc']">
			<iso:let name="id" value="@id"/>
			<iso:let name="source" value="@source"/>			
			<iso:let name="source-class" value="//sbgn:glyph[@id=$source]/@class"/>	
			<iso:assert 
				id="af10112"
				name="check-equivalence-arc-source-class"
				role="error"
				see="sbgn-af-L1V1.0-3.3.1"				
				test="
				$source-class='biological activity' or
				$source-class='compartment'" 
				diagnostics="id source source-class">Error: Equivalence arcs must originate from a 'biological activity' or 'compartment' glyph.
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	<iso:pattern id="af10113">
		<iso:rule context="sbgn:arc[@class='equivalence arc']">
			<iso:let name="id" value="@id"/>
			<iso:let name="target" value="@target"/>			
			<iso:let name="target-class" value="//sbgn:glyph[@id=$target]/@class"/>	
			<iso:assert 
				id="af10113"
				name="check-equivalence-arc-target-class"
				role="error"
				see="sbgn-af-L1V1.0-3.3.1"				
				test="
				$target-class='tag' or
				$target-class='submap' or
				$target-class='terminal'" 
				diagnostics="id target target-class">Error: Equivalence arcs must target a 'tag', 'submap', or 'terminal' glyph.
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 

	<iso:pattern id="af10114">
		<iso:rule context="sbgn:map/sbgn:glyph[(@class='biological activity')]">
			<iso:let name="id" value="@id"/>
			<iso:let name="compartment-count" value="count(//sbgn:glyph[@class='compartment'])"/>
			<iso:assert 
				id="af10114"
				name="check-compartment-ref"
				role="error"
				test="
				(($compartment-count = 0) and not (@compartmentRef)) or (($compartment-count &gt; 0) and @compartmentRef)"
				diagnostics="id">Error: If compartments exist in the diagram, each top-level biological activity glyph must define a valid compartmentRef.
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