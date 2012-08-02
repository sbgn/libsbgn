<?xml version="1.0" encoding="UTF-8"?>
<!-- 

Schematron validation for SBGN PD 

@author Augustin Luna
@version 21 May 2011
-->
<iso:schema    
  xmlns:iso="http://purl.oclc.org/dsdl/schematron"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  defaultPhase="basic"
  schemaVersion="0.1">
     
	<iso:ns prefix="sbgn" uri="http://sbgn.org/libsbgn/0.2"/>"/>
	
	<iso:title>sbgn_validation</iso:title>
	<iso:p>p test 1</iso:p>
	
	<iso:phase id="sanity">
		<iso:active pattern="00000"/>	
	</iso:phase>
	
	<iso:phase id="basic"> 
		<iso:active pattern="00001"/>
		<iso:active pattern="00002"/>
		<iso:active pattern="pd10101"/>
		<iso:active pattern="pd10102"/>
		<iso:active pattern="pd10103"/>
		<iso:active pattern="pd10104"/>
		<iso:active pattern="pd10105"/>
		<iso:active pattern="pd10106"/>
		<iso:active pattern="pd10107"/>
		<iso:active pattern="pd10108"/>
		<iso:active pattern="pd10109"/>
		<iso:active pattern="pd10110"/>
		<iso:active pattern="pd10111"/>
		<iso:active pattern="pd10112"/>

		<iso:active pattern="pd10124"/>
		<iso:active pattern="pd10125"/>
		<iso:active pattern="pd10126"/>
		<iso:active pattern="pd10127"/>
		<iso:active pattern="pd10128"/>
		<iso:active pattern="pd10129"/>
		<iso:active pattern="pd10130"/>
		<iso:active pattern="pd10131"/>
		<iso:active pattern="pd10132"/>
		<iso:active pattern="pd10133"/>
		<iso:active pattern="pd10134"/>
		<iso:active pattern="pd10140"/>
		<iso:active pattern="pd10141"/>		
		<iso:active pattern="pd10142"/>		
	</iso:phase>

	<iso:pattern id="00000">
		<iso:rule context="/*">
			<iso:assert id="00000" name="sanity-check" test="false()">This assertion should always fail. Timestamp: <iso:value-of select="current-time()"/> Namespace: <iso:value-of select="namespace-uri()"/></iso:assert>
		</iso:rule> 
	</iso:pattern> 
	
	<iso:pattern id="00001">
		<iso:rule context="//*[@id]">
			<iso:let name="id" value="@id"/>
			<iso:assert 
			name="check-id"
			id="00001"
			role="error"
			test="count(//@id[. = current()/@id]) = 1" diagnostics="id">ID needs to be unique.</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	
	<iso:pattern id="00002">
		<iso:rule context="sbgn:arc">
			<iso:let name="target" value="@target"/>
			<iso:assert
			name="check-idref"
			id="00002"
			role="error"
			test="//*/@id[. = $target]" diagnostics="target">An arc target should be a glyph defined in the diagram.</iso:assert>
		</iso:rule> 
	</iso:pattern> 

	<iso:pattern id="pd10101">
		<iso:rule context="sbgn:arc[@class='consumption']">
			<iso:let name="id" value="@id"/>
			<iso:let name="source" value="@source"/>			
			<iso:let name="class" value="//sbgn:glyph[@id=$source]/@class"/>	
			<iso:assert 
				id="pd10101"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="
				$class='macromolecule' or 
				$class='macromolecule multimer' or
				$class='simple chemical' or
				$class='unspecified entity' or 
				$class='complex multimer' or 	
				$class='complex' or 
				$class='nucleic acid feature' or 
				$class='simple chemical multimer' or 
				$class='nucleic acid feature multimer' or 
				$class='source and sink'" 
				diagnostics="id source class">Arc with class consumption must have source reference to glyph of EPN classes
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	<iso:pattern id="pd10102">
		<iso:rule context="sbgn:arc[@class='consumption']">
			<iso:let name="id" value="@id"/>
			<iso:let name="target" value="@target"/>			
			<iso:let name="port-class" value="//sbgn:port[@id=$target]/../@class"/>	
			<iso:assert 
				name="check-consumption-target-class"
				id="pd10102"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="
				$port-class='process' or 
				$port-class='omitted process' or
				$port-class='uncertain process' or
				$port-class='association' or
				$port-class='dissociation' or
				$port-class='phenotype'" 
				diagnostics="id target port-class">Arc with class consumption must have target reference to port on glyph with PN classes
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	<iso:pattern id="pd10103">
		<!-- Number Limited Rules --> 
		<iso:rule context="sbgn:glyph[@class='source and sink']">
			<iso:let name="id" value="@id"/>
			<iso:let name="count" value="count(//sbgn:arc[(./@class = 'consumption') and (./@source = $id)])"/>				
			<iso:assert 
				id="pd10103"
				name="check-consumption-source_and_sink-source-count-equals-1"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="$count &lt;= 1"
				diagnostics="id count">The 'source and sink' glyph can be connected to at most one consumption glyph. 
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	<iso:pattern id="pd10104">
		<iso:rule context="sbgn:glyph[@class='dissociation']">
			<iso:let name="id" value="@id"/>
			<iso:let name="port-id" value="./sbgn:port/@id"/>				
			<iso:let name="count" value="count(//sbgn:arc[(./@class = 'consumption') and (./@target = current()/sbgn:port/@id)])"/>				
			<iso:assert 
			    id="pd10104"
				name="check-consumption-dissociation-target-count-equals-1"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="$count = 1"
				diagnostics="id port-id count">The 'dissociation' glyph can only be connected to one consumption glyph. 
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 

	<iso:pattern id="pd10105">
		<iso:rule context="sbgn:arc[@class='production']">
			<iso:let name="id" value="@id"/>
			<iso:let name="source" value="@source"/>			
			<iso:let name="port-class" value="//sbgn:port[@id=$source]/../@class"/>
			<iso:assert 
				id="pd10105"
				name="check-production-source-class"
				see="sbgn-pd-L1V1.3-3.4.1"
				role="error"				
				test="
				$port-class='process' or 
				$port-class='omitted process' or
				$port-class='uncertain process' or
				$port-class='association' or
				$port-class='dissociation' or
				$port-class='phenotype'"  
				diagnostics="id source port-class">Arc with class production must have source reference to port on glyph with PN classes and target reference to glyph of EPN classes
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	<iso:pattern id="pd10106">
		<iso:rule context="sbgn:arc[@class='production']">
			<iso:let name="id" value="@id"/>
			<iso:let name="target" value="@target"/>			
			<iso:let name="class" value="//sbgn:glyph[@id=$target]/@class"/>	
			<iso:assert 
			    id="pd10106"
				name="check-production-target-class"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="
				$class='macromolecule' or 
				$class='macromolecule multimer' or 
				$class='simple chemical' or
				$class='unspecified entity' or 
				$class='complex multimer' or 				
				$class='complex' or 
				$class='nucleic acid feature' or 
				$class='simple chemical multimer' or 
				$class='nucleic acid feature multimer' or 
				$class='source and sink'"
				diagnostics="id target class">Arc with class production must have target reference to glyph of EPN classes
			</iso:assert>
		</iso:rule>	
	</iso:pattern> 
	<iso:pattern id="pd10107">
		<!-- Limited Number Rules -->
		<!-- TODO: Currently, assumes that sources originate from the same port -->
		<iso:rule context="sbgn:glyph[@class='source and sink']">
			<iso:let name="id" value="@id"/>
			<iso:let name="count" value="count(//sbgn:arc[(./@class = 'production') and (./@target = $id)])"/>				
			<iso:assert 
				id="pd10107"
				name="check-production-source_and_sink-target-count-equals-1"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="$count &lt;= 1"
				diagnostics="id count">The 'source and sink' glyph can be connected to at most one production glyph. 
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	<iso:pattern id="pd10108">
		<iso:rule context="sbgn:glyph[@class='association']">
			<iso:let name="id" value="@id"/>
			<iso:let name="port-id" value="./sbgn:port/@id"/>				
			<iso:let name="count" value="count(//sbgn:arc[(./@class = 'production') and (./@source = current()/sbgn:port/@id)])"/>				
			<iso:assert 
				id="pd10108"
				name="check-production-association-source-count-equals-1"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="$count = 1"
				diagnostics="id port-id count">The association glyph can only be connected to one production glyph. 
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 

	<iso:pattern id="pd10109">
		<iso:rule context="sbgn:arc[(@class='modulation') or (@class='stimulation') or
			(@class='catalysis') or (@class='inhibition') or (@class='necessary stimulation')]">
			<iso:let name="id" value="@id"/>
			<iso:let name="source" value="@source"/>			
			<iso:let name="class" value="//sbgn:glyph[@id=$source]/@class"/>	
			<iso:let name="port-class" value="//sbgn:port[@id=$source]/../@class"/>	
			<iso:assert 
				id="pd10109"
				name="check-modulation-source-class"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="(
				$class='unspecified entity' or 
				$class='simple chemical' or
				$class='macromolecule' or 
				$class='macromolecule multimer' or
				$class='nucleic acid feature' or 
				$class='simple chemical multimer' or 
				$class='nucleic acid feature multimer' or 
				$class='complex' or 
				$class='complex multimer' or 				
				$class='perturbing agent') or (
				$port-class='and' or 
				$port-class='or' or 
				$port-class='not')" 
				diagnostics="id source port-class class">Modulation arc must have source reference to glyph of EPN classes or a logical operator
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	<iso:pattern id="pd10110">
		<iso:rule context="sbgn:arc[(@class='modulation') or (@class='stimulation') or
			(@class='catalysis') or (@class='inhibition') or (@class='necessary stimulation')]">
			<iso:let name="id" value="@id"/>			
			<iso:let name="target" value="@target"/>			
			<iso:let name="target-class" value="//sbgn:glyph[@id=$target]/@class"/>	
			<iso:assert 
				id="pd10110"
				name="check-modulation-target-class"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="
				$target-class='process' or 
				$target-class='omitted process' or
				$target-class='uncertain process' or
				$target-class='association' or
				$target-class='dissociation' or
				$target-class='phenotype'" 
				diagnostics="id target target-class">Modulation arc must have target reference to PN classes
			</iso:assert><!-- added association / dissociation as allowed targets: possible mistake in spec -->
		</iso:rule> 
	</iso:pattern> 
	<iso:pattern id="pd10111">
		<!-- Limited Number Rules -->
		<iso:rule context="sbgn:glyph[(@class='and') or (@class='or') or (@class='not')]">
			<iso:let name="id" value="@id"/>
			<iso:let name="port-id" value="./sbgn:port/@id"/>				
			<iso:let name="count" value="count(//sbgn:arc[./@source = current()/sbgn:port/@id])"/>				
			<iso:assert 
				id="pd10111"
				name="check-and_or_not-source-count-equals-1"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="$count = 1"
				diagnostics="id port-id count">'and', 'or', and 'not' glyphs must be the source for exactly one arc. 
			</iso:assert>
		</iso:rule>
	</iso:pattern> 

	<iso:pattern id="pd10112">
		<iso:rule context="sbgn:map/sbgn:glyph[(@class = 'unspecified entity' or 
				@class = 'simple chemical' or 
				@class = 'macromolecule' or 
				@class = 'nucleic acid feature' or
				@class = 'simple chemical multimer' or 
				@class = 'macromolecule multimer' or 
				@class = 'nucleic acid feature multimer' or 
				@class = 'complex' or 
				@class = 'complex multimer' or 
				@class = 'source and sink' or
				@class = 'perturbing agent')]">
			<iso:let name="id" value="@id"/>
			<iso:let name="compartment-count" value="count(//sbgn:glyph[@class='compartment'])"/>
			<iso:assert 
				id="pd10112"
				name="check-compartment-ref"
				role="error"
				test="
				(($compartment-count = 0) and not (@compartmentRef)) or (($compartment-count &gt; 0) and @compartmentRef)"
				diagnostics="id">If there are compartments defined, top-level glyphs must have a compartmentRef."
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 

	<iso:pattern id="pd10124">
		<iso:rule context="sbgn:arc[@class='logic arc']">
			<iso:let name="id" value="@id"/>			
			<iso:let name="source" value="@source"/>			
			<iso:let name="class" value="//sbgn:glyph[@id=$source]/@class"/>	
			<iso:let name="port-class" value="//sbgn:port[@id=$source]/../@class"/>	
			<iso:assert 
				id="pd10124"
				name="check-logic-arc-source-class"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="
				$class='unspecified entity' or 
				$class='simple chemical' or
				$class='macromolecule' or 
				$class='macromolecule multimer' or
				$class='nucleic acid feature' or 
				$class='simple chemical multimer' or 
				$class='nucleic acid feature multimer' or 
				$class='complex' or 
				$class='complex multimer' or
				$port-class='and' or
				$port-class='or' or
				$port-class='not'" 
				diagnostics="id source class">Arc with class logic arc must have source reference to glyph of EPN classes, or logic gates
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	<iso:pattern id="pd10125">
		<iso:rule context="sbgn:arc[@class='logic arc']">
			<iso:let name="id" value="@id"/>
			<iso:let name="target" value="@target"/>			
			<iso:let name="port-class" value="//sbgn:port[@id=$target]/../@class"/>	
			<iso:assert 
				id="pd10125"
				name="check-logic-arc-target-class"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="$port-class='and' or
				$port-class='or' or
				$port-class='not'" 
				diagnostics="id target port-class">Arc with class logic arc must have target reference to  a logical operator
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	<iso:pattern id="pd10126">
		<!-- Limited Number Rules -->
		<iso:rule context="sbgn:glyph[@class='not']">
			<iso:let name="id" value="@id"/>
			<iso:let name="port-id" value="./sbgn:port/@id"/>				
			<iso:let name="count" value="count(//sbgn:arc[(./@class = 'logic arc') and (./@target = current()/sbgn:port/@id)])"/>				
			<iso:assert 
				id="pd10126"
				name="check-logic_arc-not-target-count-equals-1"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="$count = 1"
				diagnostics="id port-id count">The 'not' glyph can only be the target of one logic arc glyph. 
			</iso:assert>
		</iso:rule> 						
	</iso:pattern> 

	<iso:pattern id="pd10127">
		<iso:rule context="sbgn:arc[@class='equivalence arc']">
			<iso:let name="id" value="@id"/>
			<iso:let name="source" value="@source"/>			
			<iso:let name="class" value="//sbgn:glyph[@id=$source]/@class"/>	
			<iso:assert 
				id="pd10127"
				name="check-equivalence-arc-source-class"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="
				$class='unspecified entity' or 
				$class='simple chemical' or
				$class='macromolecule' or 
				$class='macromolecule multimer' or
				$class='nucleic acid feature' or 
				$class='simple chemical multimer' or 
				$class='nucleic acid feature multimer' or 
				$class='complex' or 
				$class='complex multimer' or 				
				$class='source and sink' or 
				$class='perturbing agent'" 
				diagnostics="id source class">Arc with class equivalence arc must have source reference to glyph of EPN classes
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	<iso:pattern id="pd10128">
		<iso:rule context="sbgn:arc[@class='equivalence arc']">
			<iso:let name="id" value="@id"/>
			<iso:let name="target" value="@target"/>			
			<iso:let name="class" value="//sbgn:glyph[@id=$target]/@class"/>	
			<iso:assert 
				id="pd10128"
				name="check-equivalence-arc-target-class"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="
				$class='tag' or
				$class='submap' or
				$class='terminal'" 
				diagnostics="id target class">Arc with class equivalence arc must have target reference to glyph of classes 'tag', 'submap' or 'terminal'
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 

	<iso:pattern id="pd10129">
		<iso:rule context="sbgn:glyph[@class='and']/sbgn:port/sbgn:state">
			<iso:let name="id" value="@id"/>	
			<iso:assert
				id="pd10129"
				name="state-var-unique"
				see="sbgn-pd-L1V1.3-3.5.1-1"
				role="error"
				test="count(../../sbgn:port/sbgn:state[@variable = current()/@variable]) &lt;= 2"
				diagnostics="id">All state variables associated with a Stateful Entity Pool Node should be unique and note duplicated within that node. 
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 

	<iso:pattern id="pd10130">
		<iso:rule context="sbgn:arc[@source = //sbgn:glyph[@class='complex']/sbgn:glyph/@id]">
			<iso:let name="id" value="//sbgn:glyph[@class='complex']/sbgn:glyph[not(@class='complex')]/@id"/>
			<iso:let name="class" value="@class"/>
			<iso:assert 
				id="pd10130"
				name="subunit-mod-arc-source"
				role="error"
				test="@class = 'modulation'"
				diagnostics="id class">[NOT SURE]
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	
	<iso:pattern id="pd10131">
		<iso:rule context="/sbgn:sbgn/sbgn:map/sbgn:glyph[
				@class = 'unspecified entity' or 
				@class = 'simple chemical' or 
				@class = 'macromolecule' or 
				@class = 'nucleic acid feature' or
				@class = 'simple chemical multimer' or 
				@class = 'macromolecule multimer' or 
				@class = 'nucleic acid feature multimer' or 
				@class = 'complex' or 
				@class = 'complex multimer' or 
				@class = 'source and sink' or
				@class = 'perturbing agent']
			">
			<iso:let name="id" value="@id"/>
			<iso:let name="class" value="//sbgn:arc[@source = $id or @target = $id]/@class"/>
			<iso:assert 
				id="pd10131"
				name="epns-must-connect"
				see="sbgn-pd-L1V1.3-3.5.1-3"
				role="error"
				test="//sbgn:arc[(
					@class = 'production' or
					@class = 'consumption' or 					
					@class = 'modulation' or 
					@class = 'stimulation' or 
					@class = 'catalysis' or 
					@class = 'inhibition' or 
					@class = 'necessary stimulation' or 
					@class = 'logic arc' or 
					@class = 'equivalence arc' or 
					@class = 'production') and (@source = $id or @target = $id)]"
				diagnostics="id class">EPNs should not be orphaned (i.e. they must be associated with at least one arc.)
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 

	<iso:pattern id="pd10132">
		<iso:rule context="sbgn:glyph[			
			@class='process' or 
			@class='omitted process' or
			@class='uncertain process' or
			@class='association' or
			@class='dissociation'
		]">
			<iso:let name="id" value="@id"/>
			<iso:let name="port-count" value="count(sbgn:port)"/>
			<iso:assert 
				id="pd10132"
				name="pns-port-count-eq-2"
				see="sbgn-pd-L1V1.3-3.5.2.1-1"
				role="error"
				test="$port-count = 2"
				diagnostics="id">All process nodes (with the exception of phenotype) must have a LHS and RHS.
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	
	<iso:pattern id="pd10133">
		<iso:rule context="sbgn:glyph[			
			@class='process' or 
			@class='omitted process' or
			@class='uncertain process' or
			@class='association' or
			@class='dissociation'
		]">
			<iso:let name="id" value="@id"/>
			<iso:let name="port-id-1" value="./sbgn:port[position() = 1]/@id"/>
			<iso:let name="port-id-2" value="./sbgn:port[position() = 2]/@id"/>
			<iso:let name="arc-count-1" value="count(//sbgn:arc[@source = $port-id-1])"/>
			<iso:let name="arc-count-distinct-1" value="count(distinct-values(//sbgn:arc[@source = $port-id-1]/@target))"/>			
			<iso:let name="arc-count-2" value="count(//sbgn:arc[@source = $port-id-2])"/>
			<iso:let name="arc-count-distinct-2" value="count(distinct-values(//sbgn:arc[@source = $port-id-2]/@target))"/>
			<iso:assert 
				id="pd10133"
				name="pns-arc-count-eq-2"
				see="sbgn-pd-L1V1.3-3.5.2.1-2,3"
				role="error"
				test="($arc-count-2 = $arc-count-distinct-2) and ($arc-count-1 = $arc-count-distinct-1)"
				diagnostics="id">All EPNs on the LHS of a process must be unique. 
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	
	<iso:pattern id="pd10134">
		<iso:rule context="/*">
			<iso:assert 
				id="pd10134"
				name="multiple-stoichiometries"
				see="sbgn-pd-L1V1.3-3.5.2.1-8"
				role="untestable"
				test="true()">If more than one set of stoichiometries can be applied to the flux arcs of the process then the stoichiometry of the flux arcs must be displayed.</iso:assert>
			<iso:assert 
				id="pd10135"
				name="undefined-unknown-stochiometry"
				see="sbgn-pd-L1V1.3-3.5.2.1-7"				
				role="unimplemented" 
				test="true()">If the stoichiometry is undefined or unknown this should be indicated by the use of a question mark ("?").</iso:assert>
		</iso:rule>
	</iso:pattern>
	
	<iso:pattern id="pd10140">
		<iso:rule context="sbgn:glyph">
			<iso:let name="id" value="@id"/>
			<iso:let name="class" value="@class"/>			
			<iso:assert 
				id="pd10140"
				name="check-glyph-class"
				role="error"
				see="sbgn-pd-L1V1.3-3.5.2.1-2,3"
				test="not($class='biological activity' or
				 $class='outcome' or
				 $class='variable value' or
				 $class='entity')"
				diagnostics="id class">This 'glyph class' is not allowed in Process Description
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	
	<iso:pattern id="pd10141">
		<iso:rule context="sbgn:glyph[@class='process']">
			<iso:let name="id" value="@id"/>
			<iso:let name="port-id" value="./sbgn:port/@id"/>				
			<iso:let name="count" value="count(//sbgn:arc[(./@target = current()/sbgn:port/@id) or (./@source = current()/sbgn:port/@id)])"/>				
			
			<iso:assert 
				id="pd10141"
				name="pns-port-count-eq-2"
				see="sbgn-pd-L1V1.3-3.5.2.1-1"
				role="error"
				test="($count &gt;= 2)"
				diagnostics="id count">All process nodes should have at least one input and at least one ouput pointing to the arcs 
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	
	<iso:pattern id="pd10142">
		<iso:rule context="sbgn:arc[@class='logic arc']">
			<iso:let name="id" value="@id"/>
			<iso:let name="source" value="@source"/>			
			<iso:let name="target" value="@target"/>			
			<iso:let name="port-class" value="//sbgn:port[@id=$source or @id=$target]/../@class"/>	
			<iso:assert 
				name="check-logic-arc--class"
				id="pd10142"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="
				$port-class='and' or 
				$port-class='or' or
				$port-class='not'" 
				diagnostics="id source port-class target">logic Arc must be connected to either 'OR', 'AND' or 'NOT'
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	
	<iso:diagnostics>
		<iso:diagnostic id="id"><iso:value-of select="$id"/></iso:diagnostic> 		
		<iso:diagnostic id="port-id"><iso:value-of select="$port-id"/></iso:diagnostic> 				
		<iso:diagnostic id="target"><iso:value-of select="$target"/></iso:diagnostic> 
		<iso:diagnostic id="target-class"><iso:value-of select="$target-class"/></iso:diagnostic> 
		<iso:diagnostic id="source"><iso:value-of select="$source"/></iso:diagnostic> 		
		<iso:diagnostic id="class"><iso:value-of select="$class"/></iso:diagnostic> 
		<iso:diagnostic id="port-class"><iso:value-of select="$port-class"/></iso:diagnostic> 
		<iso:diagnostic id="count"><iso:value-of select="$count"/></iso:diagnostic> 			
		<iso:diagnostic id="arc-count"><iso:value-of select="$arc-count"/></iso:diagnostic> 			
	</iso:diagnostics> 
</iso:schema>