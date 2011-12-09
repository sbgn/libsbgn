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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xalan="http://xml.apache.org/xslt" xmlns:doc="http://xframe.sf.net/xsddoc/doc">
  <!--
    This transformation creates an index of a schema
  -->
  <xsl:output indent="yes" version="4.0" method="xml" encoding="ISO-8859-1" xalan:indent-amount="2" />
  <!--
    Include xsddoc utilities templates.
  -->
  <xsl:include href="xmldoc.xsl"/>
  <!--
    Include xframe utilities templates.
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
    todo change to intermediate XML format
    todo also recurse included schemas
  -->
  <xsl:template match="xs:schema">
    <xsl:variable name="ns">
      <xsl:choose>
        <xsl:when test="normalize-space(@targetNamespace) = ''">
          <xsl:value-of select="string('noNamespace')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="/xs:schema/@targetNamespace"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <doc:schema-index namespace="{$ns}" href="./schema-summary.html">
      <xsl:for-each select="@*">
        <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
      </xsl:for-each>
      <xsl:call-template name="xsddocComment"/>
      <xsl:apply-templates select="." mode="overview"/>
      <xsl:if test="xs:annotation/xs:documentation">
        <doc:documentation>
          <xsl:for-each select="xs:annotation/xs:documentation">
            <xsl:copy-of select="* | text()"/>
          </xsl:for-each>
        </doc:documentation>
      </xsl:if>
    </doc:schema-index>
  </xsl:template>
  <!--
    process all schema components.
  -->
  <xsl:template match="xs:schema" mode="overview">
    <xsl:param name="processedLocations" select="/xs:schema/@targetNamespace"/>
    <xsl:param name="ignore"/>
    <xsl:apply-templates select="xs:element | xs:attribute | xs:complexType | xs:simpleType | xs:group | xs:attributeGroup" mode="doc">
      <xsl:with-param name="ignore" select="$ignore"/>
    </xsl:apply-templates>
    <xsl:for-each select="xs:element | xs:complexType">
      <xsl:apply-templates select=".//xs:element[(not (@ref)) and (not (@type))]" mode="doc">
        <xsl:with-param name="ignore" select="$ignore"/>
      </xsl:apply-templates>
    </xsl:for-each>
    <xsl:for-each select="xs:include | xs:redefine">
      <xsl:variable name="schemaLocation" select="@schemaLocation"/>
      <xsl:variable name="redefinedComponents">
        <xsl:call-template name="tostring">
          <xsl:with-param name="nodes" select="xs:element | xs:attribute | xs:complexType | xs:simpleType | xs:group | xs:attributeGroup"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:apply-templates select="xs:element | xs:attribute | xs:complexType | xs:simpleType | xs:group | xs:attributeGroup" mode="doc">
        <xsl:with-param name="ignore" select="$ignore"/>
      </xsl:apply-templates>
      <xsl:if test="not(contains($processedLocations, $schemaLocation))">
        <xsl:apply-templates select="document($schemaLocation)/xs:schema" mode="overview">
          <xsl:with-param name="processedLocations" select="concat($processedLocations, ' ', $schemaLocation)"/>
          <xsl:with-param name="ignore" select="$redefinedComponents"/>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <!--
    Create an index entry.
  -->
  <xsl:template match="*" mode="doc">
    <xsl:param name="ignore"/>
    <xsl:if test="string(@name) != '' and not(contains($ignore, concat('|', local-name(), ':', @name, '|')))">
      <xsl:variable name="hierarchy">
        <xsl:apply-templates select=".." mode="parent"/>
      </xsl:variable>
      <xsl:variable name="name">
        <xsl:choose>
          <xsl:when test="string($hierarchy) != ''">
            <xsl:value-of select="concat(string($hierarchy), @name)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat(local-name(), '/', @name)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <doc:component type="{substring-before($name, '/')}">
        <xsl:attribute name="name">
          <xsl:value-of select="substring-after($name, '/')"/>
        </xsl:attribute>
        <xsl:attribute name="href">
          <xsl:value-of select="concat($name, '.html')"/>
        </xsl:attribute>
        <xsl:if test="xs:annotation/xs:documentation">
          <doc:documentation>
            <xsl:for-each select="xs:annotation/xs:documentation">
              <xsl:copy-of select="* | text()"/>
            </xsl:for-each>
          </doc:documentation>
        </xsl:if>
      </doc:component>
    </xsl:if>
  </xsl:template>
  <!--
  -->
  <xsl:template match="*" mode="parent">
    <xsl:param name="parent"/>
    <xsl:choose>
      <xsl:when test="local-name() = 'schema'">
        <xsl:value-of select="$parent"/>
      </xsl:when>
      <xsl:when test="@name">
        <xsl:apply-templates select=".." mode="parent">
          <xsl:with-param name="parent">
            <xsl:if test="local-name(..) = 'schema'">
              <xsl:value-of select="concat(local-name(), '/')"/>
            </xsl:if>
            <xsl:value-of select="@name"/>
            <xsl:text>.</xsl:text>
            <xsl:value-of select="$parent"/>
          </xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select=".." mode="parent">
          <xsl:with-param name="parent" select="$parent"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--
  -->
  <xsl:template name="tostring">
    <xsl:param name="nodes"/>
    <xsl:for-each select="$nodes">
      <xsl:value-of select="concat('|', local-name(), ':', @name, '|')"/>
    </xsl:for-each>
  </xsl:template>
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
