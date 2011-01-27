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
  exclude-result-prefixes="xs" version="1.0">
  <!--
    This transformation creates an index of a schema
  -->
  <xsl:output indent="no" version="1.0" method="xml" encoding="ISO-8859-1"/>
  <!--
    Include templates to document XML
  -->
  <xsl:include href="xmldoc.xsl"/>
  <!--
    Include xsddoc utilities templates.
  -->
  <xsl:include href="util.xsl"/>
  <!--
    The file name of the schema to extract from.
  -->
  <xsl:param name="schemaLocation" select="undefined"/>
  <!--
    The element name to extract.
  -->
  <xsl:param name="type" select="undefined"/>
  <!--
    The name attribute of the element to extract.
  -->
  <xsl:param name="name" select="undefined"/>
  <!--
    Reference to main schema.
  -->
  <xsl:variable name="mainSchema" select="/xs:schema"/>
  <!--
    Namespace prefix of target namespace
  -->
  <xsl:variable name="targetNamespacePrefix">
    <xsl:if test="/xs:schema/@targetNamespace">
      <xsl:value-of select="local-name(/xs:schema/namespace::*[normalize-space(.)=normalize-space(/xs:schema/@targetNamespace)])"/>
    </xsl:if>
  </xsl:variable>
  <!--
    Root template.
  -->
  <xsl:template match="/">
    <xsl:apply-templates select="*"/>
  </xsl:template>
  <!--
    Processing the schema tag, the root element of a schema.
  -->
  <xsl:template match="xs:schema">
    <doc:schema-summary>
      <xsl:apply-templates select="." mode="schema-summary"/>
    </doc:schema-summary>
  </xsl:template>
  <!--
     Create list of global declared namespaces.
   -->
  <xsl:template match="xs:schema" mode="schema-summary">
    <xsl:param name="processedLocations" select="$schemaLocation"/>
    <xsl:variable name="hasComponents">
      <xsl:apply-templates select="." mode="hasComponents"/>
    </xsl:variable>
    <xsl:if test="contains($hasComponents, 'true')">
      <xsl:apply-templates select="." mode="targetNamespace"/>
    </xsl:if>
    <xsl:apply-templates select="xs:include | xs:redefine | xs:import" mode="schema-summary">
      <xsl:with-param name="processedLocations" select="$processedLocations"/>
    </xsl:apply-templates>
  </xsl:template>
  <!--
  -->
  <xsl:template match="xs:include | xs:redefine" mode="schema-summary">
    <xsl:param name="processedLocations"/>
    <xsl:variable name="schemaLocation" select="@schemaLocation"/>
    <xsl:if test="not(contains($processedLocations, $schemaLocation))">
      <xsl:apply-templates select="document($schemaLocation)/xs:schema" mode="schema-summary">
        <xsl:with-param name="processedLocations" select="concat($processedLocations, ' ', $schemaLocation)"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>
  <!--
  -->
  <xsl:template match="xs:import" mode="schema-summary">
    <xsl:param name="processedLocations"/>
    <xsl:variable name="schemaLocation" select="@schemaLocation"/>
    <xsl:if test="not(contains($processedLocations, $schemaLocation))">
      <xsl:apply-templates select="document($schemaLocation)/xs:schema" mode="schema-summary">
        <xsl:with-param name="processedLocations" select="concat($processedLocations, ' ', $schemaLocation)"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>
  <!--
  -->
  <xsl:template match="xs:schema" mode="targetNamespace">
    <doc:namespace name="{@targetNamespace}">
      <xsl:attribute name="href">
        <xsl:call-template name="namespaceFolder">
          <xsl:with-param name="uri" select="@targetNamespace"/>
        </xsl:call-template>
        <xsl:text>/index.html</xsl:text>
      </xsl:attribute>
      <xsl:if test="xs:annotation/xs:documentation">
        <doc:documentation>
          <xsl:for-each select="xs:annotation/xs:documentation">
            <xsl:copy-of select="* | text()"/>
          </xsl:for-each>
        </doc:documentation>
      </xsl:if>
    </doc:namespace>
  </xsl:template>
</xsl:stylesheet>
