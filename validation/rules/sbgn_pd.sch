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
     
	<iso:ns prefix="sbgn" uri="http://sbgn.org/libsbgn/0.2"/>
	
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
		<iso:active pattern="pd10131"/>
		<iso:active pattern="pd101XX"/>
		<iso:active pattern="pd10133"/>
		<iso:active pattern="pd10135"/>
		<iso:active pattern="pd10136"/>
		<iso:active pattern="pd99999"/>
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
			test="//*/@id[. = $target]" diagnostics="target">An arc target should be a glyph defined in the diagram.</iso:assert>
		</iso:rule> 
	</iso:pattern> 

	<iso:pattern name="check-consumption" id="pd10101">
		<iso:rule context="sbgn:arc[@class='consumption']">
			<iso:let name="source" value="@source"/>			
			<iso:let name="class" value="//sbgn:glyph[@id=$source]/@class"/>	
			<iso:assert 
				id="check-consumption-source-class"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="
				$class='macromolecule' or 
				$class='simple chemical' or
				$class='unspecified entity' or 
				$class='complex multimer' or 	
				$class='complex' or 
				$class='nucleic acid feature' or 
				$class='simple chemical multimer' or 
				$class='nucleic acid feature multimer' or 
				$class='source and sink'" 
				diagnostics="source class">Arc with class consumption must have source reference to glyph of EPN classes and target reference to port on glyph of PN classes
			</iso:assert>
		</iso:rule> 
		<iso:rule context="sbgn:arc[@class='consumption']">
			<iso:let name="target" value="@target"/>			
			<iso:let name="port-class" value="//sbgn:port[@id=$target]/../@class"/>	
			<iso:assert 
				id="check-consumption-target-class"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="
				$port-class='process' or 
				$port-class='omitted process' or
				$port-class='uncertain process' or
				$port-class='association' or
				$port-class='dissociation' or
				$port-class='phenotype'" 
				diagnostics="target port-class">Arc with class consumption must have target reference to port on glyph with PN classes and source reference to glyph of EPN classes
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 

	<iso:pattern name="check-production" id="pd10102">
		<iso:rule context="sbgn:arc[@class='production']">
			<iso:let name="source" value="@source"/>			
			<iso:let name="port-class" value="//sbgn:port[@id=$source]/../@class"/>
			<iso:assert 
				id="check-production-source-class"
				see="sbgn-pd-L1V1.3-3.4.1"
				role="error"				
				test="
				$port-class='process' or 
				$port-class='omitted process' or
				$port-class='uncertain process' or
				$port-class='association' or
				$port-class='dissociation' or
				$port-class='phenotype'"  
				diagnostics="source port-class">Arc with class production must have source reference to port on glyph with PN classes and target reference to glyph of EPN classes
			</iso:assert>
		</iso:rule> 
		<iso:rule context="sbgn:arc[@class='production']">
			<iso:let name="target" value="@target"/>			
			<iso:let name="class" value="//sbgn:glyph[@id=$target]/@class"/>	
			<iso:assert 
				id="check-production-target-class"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="
				$class='macromolecule' or 
				$class='simple chemical' or
				$class='unspecified entity' or 
				$class='complex multimer' or 				
				$class='complex' or 
				$class='nucleic acid feature' or 
				$class='simple chemical multimer' or 
				$class='nucleic acid feature multimer' or 
				$class='source and sink'"
				diagnostics="target class">Arc with class production must have target reference to glyph of EPN classes and source reference to port on glyph of PN classes
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 

	<iso:pattern name="check-modulation" id="pd10103">
		<iso:rule context="sbgn:arc[@class='modulation']">
			<iso:let name="source" value="@source"/>			
			<iso:let name="class" value="//sbgn:glyph[@id=$source]/@class"/>	
			<iso:let name="port-class" value="//sbgn:port[@id=$source]/../@class"/>	
			<iso:assert 
				id="check-modulation-source-class"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="(
				$class='unspecified entity' or 
				$class='simple chemical' or
				$class='macromolecule' or 
				$class='nucleic acid feature' or 
				$class='simple chemical multimer' or 
				$class='nucleic acid feature multimer' or 
				$class='complex' or 
				$class='complex multimer' or 				
				$class='perturbing agent') or (
				$port-class='and' or 
				$port-class='or' or 
				$port-class='not')" 
				diagnostics="source port-class class">Arc with class modulation must have source reference to glyph of EPN classes or a logical operator and target reference to port on glyph of PN classes
			</iso:assert>
		</iso:rule> 
		<iso:rule context="sbgn:arc[@class='modulation']">
			<iso:let name="target" value="@target"/>			
			<iso:let name="port-class" value="//sbgn:port[@id=$target]/../@class"/>	
			<iso:assert 
				id="check-modulation-target-class"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="
				$port-class='process' or 
				$port-class='omitted process' or
				$port-class='uncertain process' or
				$port-class='phenotype'" 
				diagnostics="target port-class">Arc with class modulation must have target reference to port on glyph with PN classes and source reference to glyph of EPN classes
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 

	<iso:pattern name="check-stimulation" id="pd10104">
		<iso:rule context="sbgn:arc[@class='stimulation']">
			<iso:let name="source" value="@source"/>			
			<iso:let name="class" value="//sbgn:glyph[@id=$source]/@class"/>	
			<iso:let name="port-class" value="//sbgn:port[@id=$source]/../@class"/>	
			<iso:assert 
				id="check-stimulation-source-class"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="(
				$class='unspecified entity' or 
				$class='simple chemical' or
				$class='macromolecule' or 
				$class='nucleic acid feature' or 
				$class='simple chemical multimer' or 
				$class='nucleic acid feature multimer' or 
				$class='complex' or 
				$class='complex multimer' or 				
				$class='perturbing agent') or (
				$port-class='and' or 
				$port-class='or' or 
				$port-class='not')" 				
				diagnostics="source port-class class">Arc with class stimulation must have source reference to glyph of EPN classes or a logical operator and target reference to port on glyph of PN classes
			</iso:assert>
		</iso:rule> 
		<iso:rule context="sbgn:arc[@class='stimulation']">
			<iso:let name="target" value="@target"/>			
			<iso:let name="port-class" value="//sbgn:port[@id=$target]/../@class"/>	
			<iso:assert 
				id="check-stimulation-target-class"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="
				$port-class='process' or 
				$port-class='omitted process' or
				$port-class='uncertain process' or
				$port-class='association' or
				$port-class='dissociation' or
				$port-class='phenotype'" 
				diagnostics="target port-class">Arc with class stimulation must have target reference to port on glyph with PN classes and source reference to glyph of EPN classes
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 

	<iso:pattern name="check-catalysis" id="pd10105">
		<iso:rule context="sbgn:arc[@class='catalysis']">
			<iso:let name="source" value="@source"/>			
			<iso:let name="class" value="//sbgn:glyph[@id=$source]/@class"/>	
			<iso:let name="port-class" value="//sbgn:port[@id=$source]/../@class"/>				
			<iso:assert 
				id="check-catalysis-source-class"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="(
				$class='unspecified entity' or 
				$class='simple chemical' or
				$class='macromolecule' or 
				$class='simple chemical multimer' or 
				$class='complex' or 
				$class='complex multimer') or (
				$port-class='and' or
				$port-class='or' or 
				$port-class='not')" 
				diagnostics="source port-class class">Arc with class catalysis must have source reference to glyph of EPN classes or a logical operator and target reference to port on glyph of PN classes
			</iso:assert>
		</iso:rule> 
		<iso:rule context="sbgn:arc[@class='catalysis']">
			<iso:let name="target" value="@target"/>			
			<iso:let name="port-class" value="//sbgn:port[@id=$target]/../@class"/>				
			<iso:assert 
				id="check-catalysis-target-class"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="
				$port-class='process' or 
				$port-class='omitted process' or
				$port-class='uncertain process' or
				$port-class='association' or
				$port-class='dissociation' or
				$port-class='phenotype'" 
				diagnostics="target port-class">Arc with class catalysis must have target reference to port on glyph with PN classes and source reference to glyph of EPN classes
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 

	<iso:pattern name="check-inhibition" id="pd10106">
		<iso:rule context="sbgn:arc[@class='inhibition']">
			<iso:let name="source" value="@source"/>			
			<iso:let name="class" value="//sbgn:glyph[@id=$source]/@class"/>
			<iso:let name="port-class" value="//sbgn:port[@id=$source]/../@class"/>				
			<iso:assert 
				id="check-inhibition-source-class"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="(
				$class='unspecified entity' or 
				$class='simple chemical' or
				$class='macromolecule' or 
				$class='nucleic acid feature' or 
				$class='simple chemical multimer' or 
				$class='nucleic acid feature multimer' or 
				$class='complex' or 
				$class='complex multimer' or 				
				$class='perturbing agent') or (
				$port-class='and' or
				$port-class='or' or 
				$port-class='not')" 
				diagnostics="source port-class class">Arc with class inhibition must have source reference to glyph of EPN classes or a logical operator and target reference to port on glyph of PN classes
			</iso:assert>
		</iso:rule> 
		<iso:rule context="sbgn:arc[@class='inhibition']">
			<iso:let name="target" value="@target"/>			
			<iso:let name="port-class" value="//sbgn:port[@id=$target]/../@class"/>	
			<iso:assert 
				id="check-inhibition-target-class"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="
				$port-class='process' or 
				$port-class='omitted process' or
				$port-class='uncertain process' or
				$port-class='association' or
				$port-class='dissociation' or
				$port-class='phenotype'" 
				diagnostics="target port-class">Arc with class inhibition must have target reference to port on glyph with PN classes and source reference to glyph of EPN classes
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 

	<iso:pattern name="check-necessary-stimulation" id="pd10107">
		<iso:rule context="sbgn:arc[@class='necessary stimulation']">
			<iso:let name="source" value="@source"/>			
			<iso:let name="class" value="//sbgn:glyph[@id=$source]/@class"/>	
			<iso:let name="port-class" value="//sbgn:port[@id=$source]/../@class"/>				
			<iso:assert 
				id="check-necessary-stimulation-source-class"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="(
				$class='unspecified entity' or 
				$class='simple chemical' or
				$class='macromolecule' or 
				$class='nucleic acid feature' or 
				$class='simple chemical multimer' or 
				$class='nucleic acid feature multimer' or 
				$class='complex' or 
				$class='complex multimer' or 				
				$class='perturbing agent') or (
				$port-class='and' or 
				$port-class='or' or
				$port-class='not')" 
				diagnostics="source port-class class">Arc with class necessary stimulation must have source reference to glyph of EPN classes or a logical operator and target reference to port on glyph of PN classes
			</iso:assert>
		</iso:rule> 
		<iso:rule context="sbgn:arc[@class='necessary stimulation']">
			<iso:let name="target" value="@target"/>			
			<iso:let name="port-class" value="//sbgn:port[@id=$target]/../@class"/>	
			<iso:assert 
				id="check-necessary-stimulation-target-class"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="
				$port-class='process' or 
				$port-class='omitted process' or
				$port-class='uncertain process' or
				$port-class='association' or
				$port-class='dissociation' or
				$port-class='phenotype'" 
				diagnostics="target port-class">Arc with class necessary stimulation must have target reference to port on glyph with PN classes and source reference to glyph of EPN classes
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 

	<iso:pattern name="check-logic-arc" id="pd10108">
		<iso:rule context="sbgn:arc[@class='logic arc']">
			<iso:let name="source" value="@source"/>			
			<iso:let name="class" value="//sbgn:glyph[@id=$source]/@class"/>	
			<iso:assert 
				id="check-logic-arc-source-class"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="
				$class='unspecified entity' or 
				$class='simple chemical' or
				$class='macromolecule' or 
				$class='nucleic acid feature' or 
				$class='simple chemical multimer' or 
				$class='nucleic acid feature multimer' or 
				$class='complex' or 
				$class='complex multimer'" 
				diagnostics="source class">Arc with class logic arc must have source reference to glyph of EPN classes and target reference to port on glyph of PN classes
			</iso:assert>
		</iso:rule> 
		<iso:rule context="sbgn:arc[@class='logic arc']">
			<iso:let name="target" value="@target"/>			
			<iso:let name="port-class" value="//sbgn:port[@id=$target]/../@class"/>	
			<iso:assert 
				id="check-logic-arc-target-class"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="
				$port-class='process' or 
				$port-class='omitted process' or
				$port-class='uncertain process' or
				$port-class='association' or
				$port-class='dissociation' or
				$port-class='phenotype' or
				$port-class='and' or
				$port-class='or' or
				$port-class='not'" 
				diagnostics="target port-class">Arc with class logic arc must have target reference to port on glyph with PN classes or a logical operator and source reference to glyph of EPN classes
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
		
	<iso:pattern name="check-equivalence-arc" id="pd10109">
		<iso:rule context="sbgn:arc[@class='equivalence arc']">
			<iso:let name="source" value="@source"/>			
			<iso:let name="class" value="//sbgn:glyph[@id=$source]/@class"/>	
			<iso:assert 
				id="check-equivalence-arc-source-class"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="
				$class='unspecified entity' or 
				$class='simple chemical' or
				$class='macromolecule' or 
				$class='nucleic acid feature' or 
				$class='simple chemical multimer' or 
				$class='nucleic acid feature multimer' or 
				$class='complex' or 
				$class='complex multimer' or 				
				$class='source and sink' or 
				$class='perturbing agent'" 
				diagnostics="source class">Arc with class equivalence arc must have source reference to glyph of EPN classes and target reference to port on glyph of PN classes
			</iso:assert>
		</iso:rule> 
		<iso:rule context="sbgn:arc[@class='equivalence arc']">
			<iso:let name="target" value="@target"/>			
			<iso:let name="class" value="//sbgn:glyph[@id=$target]/@class"/>	
			<iso:let name="port-class" value="//sbgn:port[@id=$target]/../@class"/>	
			<iso:assert 
				id="check-equivalence-arc-target-class"
				role="error"
				see="sbgn-pd-L1V1.3-3.4.1"				
				test="(
				$port-class='tag') or (
				$class='submap' or
				$class='process' or 
				$class='omitted process' or
				$class='uncertain process' or
				$class='association' or
				$class='dissociation' or
				$class='phenotype')" 
				diagnostics="target port-class class">Arc with class logic arc must have target reference to port on glyph with PN classes or 'tag' or 'submap' EPN classes and source reference to glyph of EPN classes
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 

	<iso:pattern name="state-var-unique" id="pd10131">
		<iso:rule context="sbgn:glyph[@class='and']/sbgn:port/sbgn:state">
			<iso:let name="id" value="@id"/>	
			<iso:assert
				id="state-var-unique"
				see="sbgn-pd-L1V1.3-3.5.1-1"
				role="error"
				test="count(../../sbgn:port/sbgn:state[@variable = current()/@variable]) &lt;= 2"
				diagnostics="id">All state variables associated with a Stateful Entity Pool Node should be unique and note duplicated within that node. 
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 

	<iso:pattern name="subunit-mod-arc" id="pd101XX">
		<iso:rule context="sbgn:arc[@source = //sbgn:glyph[@class='complex']/sbgn:glyph/@id]">
			<iso:let name="id" value="//sbgn:glyph[@class='complex']/sbgn:glyph[not(@class='complex')]/@id"/>
			<iso:let name="class" value="@class"/>
			<iso:assert 
				id="subunit-mod-arc-source"
				role="error"
				test="@class = 'modulation'"
				diagnostics="id class">[NOT SURE]
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	
	<iso:pattern name="epns-must-connect" id="pd10133">
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
				id="epns-must-connect"
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

	<iso:pattern name="pns-lhs-rhs-existence" id="pd10135">
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
				id="pns-port-count-eq-2"
				see="sbgn-pd-L1V1.3-3.5.2.1-1"
				role="error"
				test="$port-count = 2"
				diagnostics="id">All process nodes (with the exception of phenotype) must have a LHS and RHS.
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	
	<iso:pattern name="different-pn-substrates" id="pd10136">
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
				id="pns-arc-count-eq-2"
				see="sbgn-pd-L1V1.3-3.5.2.1-2,3"
				role="error"
				test="($arc-count-2 = $arc-count-distinct-2) and ($arc-count-1 = $arc-count-distinct-1)"
				diagnostics="id">All EPNs on the LHS of a process must be unique. 
			</iso:assert>
		</iso:rule> 
	</iso:pattern> 
	
	<iso:pattern name="unimplemented-untestable-rules" id="pd99999">
		<iso:rule context="/">
			<iso:assert 
				id="multiple-stoichiometries"
				see="sbgn-pd-L1V1.3-3.5.2.1-8"
				role="untestable"
				test="true()">If more than one set of stoichiometries can be applied to the flux arcs of the process then the stoichiometry of the flux arcs must be displayed.</iso:assert>
			<iso:assert 
				id="undefined-unknown-stochiometry"
				see="sbgn-pd-L1V1.3-3.5.2.1-7"				
				role="unimplemented" 
				test="true()">If the stoichiometry is undefined or unknown this should be indicated by the use of a question mark ("?").</iso:assert>
		</iso:rule>
	</iso:pattern>
	
	<iso:diagnostics>
		<iso:diagnostic id="id"><iso:value-of select="$id"/></iso:diagnostic> 		
		<iso:diagnostic id="port-id"><iso:value-of select="$port-id"/></iso:diagnostic> 				
		<iso:diagnostic id="target"><iso:value-of select="$target"/></iso:diagnostic> 
		<iso:diagnostic id="source"><iso:value-of select="$source"/></iso:diagnostic> 		
		<iso:diagnostic id="class"><iso:value-of select="$class"/></iso:diagnostic> 
		<iso:diagnostic id="port-class"><iso:value-of select="$port-class"/></iso:diagnostic> 
		<iso:diagnostic id="arc-count"><iso:value-of select="$arc-count"/></iso:diagnostic> 		
	</iso:diagnostics> 
</iso:schema>