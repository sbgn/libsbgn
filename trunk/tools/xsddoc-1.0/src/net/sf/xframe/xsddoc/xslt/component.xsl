<?xml version="1.0" encoding="UTF-8"?>
<!--
This file is part of the xframe software package
hosted at http://xframe.sourceforge.net

Copyright (c) 2003 Kurt Riede.

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
-->
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:doc="http://xframe.sf.net/xsddoc/doc"
  xmlns:net.sf.xframe.xsddoc="http://xframe.sf.net/xsddoc/doc"
  version="1.0">
  <!--
    This transformation generates XML documentation of a schema component.
  -->
  <xsl:output indent="yes" version="1.0" method="xml" encoding="UTF-8"/>
  <!--
    Include xsddoc utilities templates.
  -->
  <xsl:include href="xmldoc.xsl"/>
  <!--
    Include model utilities templates.
  -->
  <xsl:include href="model.xsl"/>
  <!--
    Include xsddoc utilities templates.
  -->
  <xsl:include href="util.xsl"/>
  <!--
    The location of the schema to extract from.
  -->
  <xsl:param name="schemaLocation" select="'S:\BEA\XML\xsddoc\samples\stress\stress.xsd'"/>
  <!--
   Descriptive name of the schema.
  -->
  <xsl:param name="title" select="string('')"/>
  <!--
   Namespace of component to process.
  -->
  <xsl:param name="namespace" select="string('http://www.w3.org/2001/XMLSchema')"/>
  <!--
   Type of component to process.
  -->
  <xsl:param name="type" select="string('element')"/>
  <!--
    Name of component to process.
  -->
  <xsl:param name="name" select="string('schema')"/>
  <!--
    Whether to show sub types or not.
  -->
  <xsl:param name="hideSubTypes" select="string('false')"/>
  <!--
    Whether to show local usage or not.
  -->
  <xsl:param name="hideLocalUsage" select="string('false')"/>
  <!--
    Whether to show types in overview pages or not.
  -->
  <xsl:param name="hideTypes" select="string('false')"/>
  <!--
    Whether to show groups in overview pages or not.
  -->
  <xsl:param name="hideGroups" select="string('false')"/>
  <!--
    Whether to show attributes in overview pages or not.
  -->
  <xsl:param name="hideAttributes" select="string('false')"/>
  <!--
    Reference to main schema. FIXME reactivate this
  -->
  <xsl:variable name="mainSchema" select="/xs:schema"/>
  <!--
    Namespace of W3C XML Schema.
  -->
  <xsl:variable name="XMLSchemaNS" select="string('http://www.w3.org/2001/XMLSchema')"/>
  <!--
    Root template.
  -->
  <xsl:template match="/">
    <doc:xsddoc>
      <xsl:apply-templates select="*" mode="doc"/>
    </doc:xsddoc>
  </xsl:template>
  <!--
    Template for the schema tag, the root element.
  -->
  <xsl:template match="xs:schema" mode="doc">
    <xsl:param name="processedLocations" select="$schemaLocation"/>
    <xsl:choose>
      <xsl:when test="normalize-space(@targetNamespace) = normalize-space($namespace)">
        <xsl:variable name="component" select="xs:*[@name = $name and local-name() = $type]"/>
        <xsl:variable name="redefinedComponent" select="xs:redefine/xs:*[@name = $name and local-name() = $type]"/>
        <xsl:variable name="nestedComponent" select="./xs:*//*[string(@net.sf.xframe.xsddoc:xsddocid) != '']"/>
        <xsl:if test="$nestedComponent">
        </xsl:if>
        <xsl:choose>
          <xsl:when test="count($nestedComponent) > 0">
            <xsl:apply-templates select="$nestedComponent" mode="doc"/>
          </xsl:when>
          <xsl:when test="count($component | $redefinedComponent) > 0">
            <xsl:apply-templates select="$component | $redefinedComponent" mode="doc"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="xs:include | xs:redefine">
              <xsl:if test="not(contains($processedLocations, @schemaLocation))">
                <xsl:apply-templates select="document(@schemaLocation, .)/xs:schema" mode="doc">
                  <xsl:with-param name="processedLocations" select="concat($processedLocations, ' ', @schemaLocation)"/>
                </xsl:apply-templates>
              </xsl:if>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="xs:import">
          <xsl:if test="not(contains($processedLocations, @schemaLocation))">
            <xsl:apply-templates select="document(@schemaLocation, .)/xs:schema" mode="doc">
              <xsl:with-param name="processedLocations" select="concat($processedLocations, ' ', @schemaLocation)"/>
            </xsl:apply-templates>
          </xsl:if>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--
    Format elements
  -->
  <xsl:template match="xs:*" mode="doc">
    <xsl:variable name="ns">
      <xsl:choose>
        <xsl:when test="normalize-space(/xs:schema/@targetNamespace) = ''">
          <xsl:value-of select="string('noNamespace')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="/xs:schema/@targetNamespace"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <doc:component name="{@name}" namespace="{$ns}">
      <xsl:attribute name="type">
        <xsl:value-of select="local-name()"/>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="$type = 'element' or $type = 'complexType' or $type = 'simpleType'">
          <xsl:attribute name="final">
            <xsl:apply-templates select="@final"/>
          </xsl:attribute>
          <xsl:attribute name="block">
            <xsl:apply-templates select="@block"/>
          </xsl:attribute>
          <xsl:choose>
            <xsl:when test="@abstract">
              <xsl:attribute name="abstract"><xsl:value-of select="@abstract"/></xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="abstract">false</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$type = 'simpleType'">
          <!-- todo simple type documentation -->
        </xsl:when>
      </xsl:choose>
     <xsl:if test="$type = 'element'">
      <xsl:choose>
        <xsl:when test="@nillable">
          <xsl:attribute name="nillable"><xsl:value-of select="@nillable"/></xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="nillable">false</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="@substitutionGroup">
        <xsl:attribute name="substitutionGroup"><xsl:value-of select="@substitutionGroup"/></xsl:attribute>
        <xsl:variable name="prefix" select="substring-before(@substitutionGroup, ':')"/>
        <xsl:variable name="namespace" select="namespace::*[name() = $prefix]"/>
        <xsl:variable name="localname">
          <xsl:choose>
            <xsl:when test="contains(@substitutionGroup, ':')">
              <xsl:value-of select="substring-after(@substitutionGroup, ':')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@substitutionGroup"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="qname">
          <xsl:apply-templates select="." mode="resolve">
            <xsl:with-param name="qname" select="@substitutionGroup"/>
          </xsl:apply-templates>
        </xsl:variable>
        <xsl:variable name="folder">
          <xsl:call-template name="namespaceFolder">
            <xsl:with-param name="uri" select="../namespace::*[name() = $prefix]"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="refType">
          <xsl:apply-templates select="$mainSchema" mode="referenceType">
            <xsl:with-param name="qname" select="$qname"/>
            <xsl:with-param name="referer" select="@substitutionGroup"/>
          </xsl:apply-templates>
        </xsl:variable>
        <xsl:if test="string($refType) != ''">
          <xsl:attribute name="substitutionGroupHref">
            <xsl:value-of select="concat('../../', $folder, '/', $refType, '/', $localname, '.html')"/>
          </xsl:attribute>
        </xsl:if>
      </xsl:if>
    </xsl:if>
    <xsl:if test="$type = 'complexType'">
      <xsl:choose>
        <xsl:when test="@mixed">
          <xsl:attribute name="mixed"><xsl:value-of select="@mixed"/></xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="mixed">false</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
     </xsl:if>
     <xsl:if test="$type = 'complexType' or $type = 'simpleType'">
        <doc:superTypes>
          <xsl:apply-templates select="." mode="superTypes"/>
        </doc:superTypes>
        <xsl:if test="$hideSubTypes = 'false'">
          <doc:subTypes>
            <xsl:apply-templates select="." mode="subTypes"/>
          </doc:subTypes>
        </xsl:if>
        <doc:implementors>
          <xsl:apply-templates select="." mode="implementors"/>
        </doc:implementors>
      </xsl:if>
      <xsl:if test="$type = 'simpleType' or $type = 'complexType' or $type = 'element' or $type = 'group' or $type = 'attributeGroup'">
        <doc:model>
          <xsl:apply-templates select="." mode="contentModel"/>
        </doc:model>
      </xsl:if>
      <xsl:if test="$hideLocalUsage = 'false'">
        <doc:typeReference>
          <xsl:apply-templates select="." mode="localUsage"/>
        </doc:typeReference>
      </xsl:if>
      <xsl:apply-templates select="." mode="collectDocs"/>
      <doc:source>
        <xsl:apply-templates select="." mode="xmldoc">
          <xsl:with-param name="children" select="*"/>
        </xsl:apply-templates>
      </doc:source>
    </doc:component>
  </xsl:template>
  <!--
    Collect nested documentation.
  -->
  <xsl:template match="*" mode="collectDocs">
    <xsl:for-each select="xs:annotation/xs:documentation">
      <doc:documentation>
        <xsl:copy-of select="* | text()"/>
      </doc:documentation>
    </xsl:for-each>
    <xsl:apply-templates select="*[((local-name() != 'attribute') and (local-name() != 'element')) or (@name = '')]" mode="collectDocs"/>
  </xsl:template>
  <!--
    Recursive build list of all super types of a simpleType or a complexType.
  -->
  <xsl:template match="xs:complexType | xs:simpleType" mode="superTypes">
    <xsl:param name="processedLocations" select="$schemaLocation"/>
    <xsl:variable name="typeName" select="@name"/>
    <xsl:variable name="derivation" select="xs:complexContent/xs:restriction | xs:complexContent/xs:extension | xs:restriction | xs:extension"/>
    <xsl:choose>
      <xsl:when test="$derivation">
        <xsl:variable name="superTypeName" select="$derivation/@base"/>
        <xsl:variable name="superTypeQName">
          <xsl:apply-templates select="." mode="resolve">
            <xsl:with-param name="qname" select="$superTypeName"/>
          </xsl:apply-templates>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="string($superTypeQName) = concat('{', $XMLSchemaNS, '}anySimpleType')">
            <doc:type name="anySimpleType" namespace="{$XMLSchemaNS}"/>
          </xsl:when>
          <xsl:when test="$mainSchema/@targetNamespace != $XMLSchemaNS and contains(string($superTypeQName), concat('{', $XMLSchemaNS, '}'))">
            <doc:type name="{substring-after(string($superTypeQName), '}')}" namespace="{$XMLSchemaNS}"/>
          </xsl:when>
          <xsl:when test="local-name(..) = 'redefine'">
            <xsl:if test="not(contains($processedLocations, @schemaLocation))">
              <xsl:apply-templates select="document(../@schemaLocation)/xs:schema" mode="superTypes">
                <xsl:with-param name="qname" select="$superTypeQName"/>
                <xsl:with-param name="processedLocations" select="concat($processedLocations, ' ', @schemaLocation)"/>
              </xsl:apply-templates>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="/xs:schema" mode="superTypes">
              <xsl:with-param name="qname" select="$superTypeQName"/>
            </xsl:apply-templates>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!-- if no base type found and current type is not the base type, use ur-types -->
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="local-name() = 'complexType'">
            <xsl:if test="$typeName != 'anyType'">
              <doc:type name="anyType" namespace="{$XMLSchemaNS}"/>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$typeName != 'anySimpleType'">
              <doc:type name="anySimpleType" namespace="{$XMLSchemaNS}"/>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="nsFolder">
      <xsl:call-template name="namespaceFolder">
        <xsl:with-param name="uri" select="/xs:schema/@targetNamespace"/>
      </xsl:call-template>
    </xsl:variable>
    <doc:type name="{@name}" namespace="{/xs:schema/@targetNamespace}">
      <xsl:attribute name="derivation">
        <xsl:choose>
          <xsl:when test="$derivation">
            <xsl:value-of select="local-name($derivation)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>restriction</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="href">
        <xsl:value-of select="concat('../../', $nsFolder, '/', local-name(), '/', @name, '.html')"/>
      </xsl:attribute>
    </doc:type>
  </xsl:template>
  <!--
    Recursive find super type definition given by qname parameter in schema
    given by context in all included or imported schemas.
  -->
  <xsl:template match="xs:schema" mode="superTypes">
    <xsl:param name="qname"/>
    <xsl:param name="processedLocations" select="$schemaLocation"/>
    <xsl:variable name="superTypeDefinition" select="key('typeDefinitions', string($qname)) | key('typeRedefinitions', string($qname))"/>
    <xsl:choose>
      <!-- found: return type definition and terminate -->
      <xsl:when test="$superTypeDefinition">
        <xsl:apply-templates select="$superTypeDefinition" mode="superTypes"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- not found in this schema: recurse into all imported and included schema -->
        <xsl:for-each select="xs:import | xs:include">
          <xsl:if test="not(contains($processedLocations, @schemaLocation))">
            <xsl:apply-templates select="document(@schemaLocation, .)/xs:schema" mode="superTypes">
              <xsl:with-param name="qname" select="$qname"/>
              <xsl:with-param name="processedLocations" select="concat($processedLocations, ' ', @schemaLocation)"/>
            </xsl:apply-templates>
          </xsl:if>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--
    Find and format list of all derived types of a complexType.
    <p><b>How to</b></p>
    <p>Recurse type hierarchy and return derivation tree.</p>
  -->
  <xsl:template match="xs:complexType | xs:simpleType" mode="subTypes">
    <xsl:param name="schema" select="$mainSchema"/>
    <xsl:variable name="derivation" select="xs:complexContent/xs:restriction | xs:complexContent/xs:extension | xs:restriction | xs:extension"/>
    <xsl:variable name="nsFolder">
      <xsl:call-template name="namespaceFolder">
        <xsl:with-param name="uri" select="/xs:schema/@targetNamespace"/>
      </xsl:call-template>
    </xsl:variable>
    <doc:type name="{@name}" namespace="{/xs:schema/@targetNamespace}">
      <xsl:attribute name="derivation">
        <xsl:choose>
          <xsl:when test="$derivation">
            <xsl:value-of select="local-name($derivation)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>restriction</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="href">
        <xsl:value-of select="concat('../../', $nsFolder, '/', local-name(), '/', @name, '.html')"/>
      </xsl:attribute>
      <xsl:apply-templates select="$mainSchema" mode="subTypes">
        <xsl:with-param name="name" select="@name"/>
        <xsl:with-param name="namespace" select="/xs:schema/@targetNamespace"/>
      </xsl:apply-templates>
    </doc:type>
  </xsl:template>
  <!--
    Find derived types in a schema.
    <p><b>How to:</b></p><br/>
    <ul>
      <li>Given the namespace, find the namespace prefix and thus the correct
      prefixed name withing the current schema.</li>
      <li>use the key <code>derivedComplexTypeDefinitions</code> with the
      prefixed name to find derived types.
      <li>recurse into all included and imported schema.</li>
    </ul>
    <p>This template finds both, simple and complex type definitions.</p>
    @param name the local name of the base type
    @param namespace the namespace of the base type
  -->
  <xsl:template match="xs:schema" mode="subTypes">
    <xsl:param name="name"/>
    <xsl:param name="namespace"/>
    <xsl:param name="processedLocations" select="$schemaLocation"/>
    <xsl:variable name="prefix" select="name(namespace::*[. = $namespace])"/>
    <xsl:variable name="qname">
      <xsl:choose>
        <xsl:when test="string-length($prefix) &gt; 0">
          <xsl:value-of select="concat($prefix, ':', $name)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="string($name)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="typeDefinitions" select="key('derivedComplexTypeDefinitions', string($qname)) | key('derivedSimpleTypeDefinitions', string($qname))"/>
    <xsl:if test="$typeDefinitions">
      <xsl:apply-templates select="$typeDefinitions" mode="subTypes"/>
    </xsl:if>
    <xsl:for-each select="xs:import | xs:include">
      <xsl:if test="not(contains($processedLocations, @schemaLocation))">
        <xsl:apply-templates select="document(@schemaLocation, .)/xs:schema" mode="subTypes">
          <xsl:with-param name="name" select="$name"/>
          <xsl:with-param name="namespace" select="$namespace"/>
          <xsl:with-param name="processedLocations" select="concat($processedLocations, ' ', @schemaLocation)"/>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <!--
    Format sub-type entry (hierarchical list) for a complexType.
  -->
  <xsl:template match="xs:complexType | xs:simpleType" mode="subTypesEntry">
    <xsl:variable name="derivation" select="xs:complexContent/xs:restriction | xs:complexContent/xs:extension | xs:restriction | xs:extension"/>
    <xsl:variable name="nsFolder">
      <xsl:call-template name="namespaceFolder">
        <xsl:with-param name="uri" select="/xs:schema/@targetNamespace"/>
      </xsl:call-template>
    </xsl:variable>
    <doc:type name="{@name}" namespace="{/xs:schema/@targetNamespace}">
      <xsl:attribute name="derivation">
        <xsl:choose>
          <xsl:when test="$derivation">
            <xsl:value-of select="local-name($derivation)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>restriction</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="href">
        <xsl:value-of select="concat('../../', $nsFolder, '/', local-name(), '/', @name, '.html')"/>
      </xsl:attribute>
      <xsl:apply-templates select="." mode="subTypes"/>
    </doc:type>
  </xsl:template>
  <!--
    Find and format list of all implementors (elements or attributes).
  -->
  <xsl:template match="xs:complexType | xs:simpleType" mode="implementors">
    <xsl:param name="schema" select="$mainSchema"/>
    <xsl:apply-templates select="$schema" mode="implementors">
      <xsl:with-param name="qname" select="concat('{', /xs:schema/@targetNamespace, '}', @name)"/>
    </xsl:apply-templates>
  </xsl:template>
  <!--
    Recursive collect all implementors of a type given by qname parameter.
  -->
  <xsl:template match="xs:schema" mode="implementors">
    <xsl:param name="qname"/>
    <xsl:param name="processedLocations" select="$schemaLocation"/>
    <xsl:variable name="nsFolder">
      <xsl:call-template name="namespaceFolder">
        <xsl:with-param name="uri" select="@targetNamespace"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:for-each select="key('elementDeclarations', string($qname)) | key('attributeDeclarations', string($qname))">
      <doc:type name="{@name}" namespace="{/xs:schema/@targetNamespace}" href="{concat('../../', $nsFolder, '/', local-name(), '/', @name, '.html')}"/>
    </xsl:for-each>
    <xsl:for-each select="xs:import | xs:include">
      <xsl:if test="not(contains($processedLocations, @schemaLocation))">
        <xsl:apply-templates select="document(@schemaLocation, .)/xs:schema" mode="implementors">
          <xsl:with-param name="qname" select="$qname"/>
          <xsl:with-param name="processedLocations" select="concat($processedLocations, ' ', @schemaLocation)"/>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <!-- 
    Recursive collect local type usage.
  -->
  <xsl:template match="xs:element | xs:attribute | xs:group | xs:attributeGroup | xs:complexType | xs:simpleType" mode="localUsage">
    <xsl:apply-templates select="$mainSchema" mode="localUsage">
      <xsl:with-param name="qname" select="concat('{', /xs:schema/@targetNamespace, '}', @name)"/>
    </xsl:apply-templates>
  </xsl:template>
  <!--
    Recursive collect local type usage (@type or @base) in included and
    imported schemas.
    TODO: also collect in redefined components
    todo use keys
  -->
  <xsl:template match="xs:schema" mode="localUsage">
    <xsl:param name="qname"/>
    <xsl:param name="processedLocations" select="$schemaLocation"/>
    <xsl:variable name="prefix" select="name(namespace::*[. = substring-after(substring-before($qname, '}'), '{')])"/>
    <xsl:variable name="name" select="concat($prefix, ':', substring-after($qname, '}'))"/>
    <xsl:variable name="components" select="xs:element | xs:attribute | xs:group | xs:attributeGroup | xs:complexType | xs:simpleType"/>
    <xsl:variable name="ns" select="@targetNamespace"/>
    <xsl:for-each select="$components[./*//@type = $name or ./*//@base = $name or ./*//@ref = $name]">
      <xsl:variable name="component" select="."/>
      <xsl:variable name="nsFolder">
        <xsl:call-template name="namespaceFolder">
          <xsl:with-param name="uri" select="$ns"/>
        </xsl:call-template>
      </xsl:variable>
      <doc:type type="{local-name($component)}" name="{$component/@name}" namespace="{$ns}">
        <xsl:attribute name="href">
          <xsl:value-of select="concat('../../', $nsFolder, '/', local-name(), '/', $component/@name, '.html')"/>
        </xsl:attribute>
      </doc:type>
    </xsl:for-each>
    <xsl:for-each select="xs:import | xs:include">
      <xsl:if test="not(contains($processedLocations, @schemaLocation))">
        <xsl:apply-templates select="document(@schemaLocation, .)/xs:schema" mode="localUsage">
          <xsl:with-param name="qname" select="$qname"/>
          <xsl:with-param name="processedLocations" select="concat($processedLocations, ' ', @schemaLocation)"/>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <!--
    Possible values of the final attribute of elements and complexTypes.
  -->
  <xs:finalValues>
    <xs:value>extension</xs:value>
    <xs:value>restriction</xs:value>
  </xs:finalValues>
  <xsl:variable name="finalValues" select="document('')/*/xs:finalValues/xs:value" />
  <!--
  -->
  <xsl:template match="@final | @finalDefault">
    <xsl:variable name="final" select="concat(' ', normalize-space(), ' ')" />
    <xsl:call-template name="list">
      <xsl:with-param name="items" select="$finalValues[$final = ' #all ' or contains($final, concat(' ', ., ' '))]" />
    </xsl:call-template>
  </xsl:template>
  <!--
    Possible values of the final attribute of simpleTypes.
  -->
  <xs:simpleFinalValues>
    <xs:value>restriction</xs:value>
    <xs:value>list</xs:value>
    <xs:value>union</xs:value>
  </xs:simpleFinalValues>
  <xsl:variable name="simpleFinalValues" select="document('')/*/xs:simpleFinalValues/xs:value" />
  <!--
  -->
  <xsl:template match="@final | @finalDefault" mode="simple">
    <xsl:variable name="final" select="concat(' ', normalize-space(), ' ')" />
    <xsl:call-template name="list">
      <xsl:with-param name="items" select="$simpleFinalValues[$final = ' #all ' or contains($final, concat(' ', ., ' '))]" />
    </xsl:call-template>
  </xsl:template>
  <!--
    Possible values of the block attribute.
  -->
  <xs:blockValues>
    <xs:value>substitution</xs:value>
    <xs:value>extension</xs:value>
    <xs:value>restriction</xs:value>
  </xs:blockValues>
  <xsl:variable name="blockValues" select="document('')/*/xs:blockValues/xs:value" />
  <!--
  -->
  <xsl:template match="@block | @blockDefault">
    <xsl:variable name="block" select="concat(' ', normalize-space(), ' ')" />
    <xsl:call-template name="list">
      <xsl:with-param name="items" select="$blockValues[$block = ' #all ' or contains($block, concat(' ', ., ' '))]" />
    </xsl:call-template>
  </xsl:template>
  <!--
    Output list of values.
  -->
  <xsl:template name="list">
    <xsl:param name="items" />
    <xsl:for-each select="$items">
      <xsl:value-of select="." />
      <xsl:if test="position() != last()">, </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <!--
    Note about keys:
      Apach XalanJ2 has a bug with declaring multiple keys with the same name.
      See http://nagoya.apache.org/bugzilla/show_bug.cgi?id=15527
  -->
  <!--
    Type definitions keys.
  -->
  <xsl:key name="typeDefinitions" match="/xs:schema/xs:complexType | /xs:schema/xs:simpleType" use="concat('{', ../@targetNamespace, '}', @name)"/>
  <!--
    Type redefinitions keys.
  -->
  <xsl:key name="typeRedefinitions" match="/xs:schema/xs:redefine/xs:simpleType | /xs:schema/xs:redefine/xs:complexType" use="concat('{', ../../@targetNamespace, '}', @name)"/>
  <!--
    Attribute declarations key.
  -->
  <xsl:key name="attributeDeclarations" match="/xs:schema/xs:attribute" use="concat('{', ../@targetNamespace, '}', @name)"/>
  <!--
    Element declarations key.
  -->
  <xsl:key name="elementDeclarations" match="/xs:schema/xs:element" use="concat('{', ../@targetNamespace, '}', @name)"/>
  <!--
    Attribute group declarations key.
  -->
  <xsl:key name="attributeGroupDefinitions" match="/xs:schema/xs:attributeGroup" use="concat('{', ../@targetNamespace, '}', @name)"/>
  <!--
    Attribute group declarations key.
  -->
  <xsl:key name="attributeGroupRedefinitions" match="/xs:schema/xs:redefine/xs:attributeGroup" use="concat('{', ../../@targetNamespace, '}', @name)"/>
  <!--
    Group declarations key.
  -->
  <xsl:key name="modelGroupDefinitions" match="/xs:schema/xs:group" use="concat('{', ../@targetNamespace, '}', @name)"/>
  <!--
    Group redeclarations key.
  -->
  <xsl:key name="modelGroupRedefinitions" match="/xs:schema/xs:redefine/xs:group" use="concat('{', ../../@targetNamespace, '}', @name)"/>
  <!--
    Notation declarations key.
  -->
  <xsl:key name="notationDeclarations" match="/xs:schema/xs:notation" use="concat('{', ../@targetNamespace, '}', @name)"/>
  <!--
    Derived complex type definitions key.
  -->
  <xsl:key name="derivedComplexTypeDefinitions" match="/xs:schema/xs:complexType" use="xs:complexContent/xs:*/@base"/>
  <!--
    Derived simple type definitions key.
  -->
  <xsl:key name="derivedSimpleTypeDefinitions" match="/xs:schema/xs:simpleType" use="xs:*/@base"/>
</xsl:stylesheet>
<!-- Stylus Studio meta-information - (c) 2004-2005. Progress Software Corporation. All rights reserved.
<metaInformation>
<scenarios ><scenario default="yes" name="Scenario1" userelativepaths="yes" externalpreview="no" url="..\..\..\..\..\..\samples\stress\stress.xsd" htmlbaseurl="" outputurl="" processortype="xalan" useresolver="no" profilemode="0" profiledepth="" profilelength="" urlprofilexml="" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal" customvalidator="" ><parameterValue name="type" value="'complexType'"/><parameterValue name="name" value="'SameName'"/><parameterValue name="namespace" value="'http://xframe.sf.net/sample/stress'"/></scenario></scenarios><MapperMetaTag><MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/><MapperBlockPosition></MapperBlockPosition><TemplateContext></TemplateContext><MapperFilter side="source"></MapperFilter></MapperMetaTag>
</metaInformation>
-->