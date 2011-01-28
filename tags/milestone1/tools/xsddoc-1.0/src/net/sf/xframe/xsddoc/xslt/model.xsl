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
  exclude-result-prefixes="" version="1.0">
  <!--
    This transformation generates XML documentation of a conent model.
    Example (from http://www.w3.org/TR/xmlschema-1,
             3.2.2 XML Representation of Attribute Declaration Schema Components):
      <attribute 
        default = string 
        fixed = string 
        form = (qualified | unqualified)
        id = ID 
        name = NCName 
        ref = QName 
        type = QName 
        use = (optional | prohibited | required) : optional
        {any attributes with non-schema namespace . . .}>
        Content: (annotation?, (simpleType?))
      </attribute>
  -->
  <!--
    Reference to main schema.
  <xsl:variable name="mainSchema" select="/xs:schema"/>
  -->
  <!--
    xsddoc namespace uri.
  -->
  <xsl:variable name="docNS" select="string('http://xframe.sf.net/xsddoc/doc')"/>
  <!--
    - Collect content model for the three complex model defintion types
    - <code>complexType</code>, <code>element</code> and <code>group</code>.
    - 
    - <p>If an <code>element</code> declaration has a <code>type</code>
    - attribute, the corresponding type definition must be collected.
    - In all other cases all children of the content model must be collected.
    - </p>
  -->
  <xsl:template match="xs:simpleType | xs:complexType | xs:element | xs:attribute | xs:attributeGroup | xs:group" mode="contentModel">
    <xsl:choose>
      <xsl:when test="@type">
        <xsl:variable name="type">
          <xsl:apply-templates select="." mode="resolve">
            <xsl:with-param name="qname" select="@type"/>
          </xsl:apply-templates>
        </xsl:variable>
        <xsl:apply-templates select="$mainSchema" mode="typeModel">
          <xsl:with-param name="qname" select="$type"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="xs:*" mode="model"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--
    - Create occurs attribute of particles.
  -->
  <xsl:template match="xs:element | xs:any | xs:all | xs:sequence | xs:choice | xs:group" mode="occurs">
    <!-- resolve missing attributes -->
    <xsl:variable name="minOccurs">
      <xsl:choose>
        <xsl:when test="@minOccurs = 'unbounded'">*</xsl:when>
        <xsl:when test="@minOccurs">
          <xsl:value-of select="@minOccurs"/>
        </xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="maxOccurs">
      <xsl:choose>
        <xsl:when test="@maxOccurs = 'unbounded'">*</xsl:when>
        <xsl:when test="@maxOccurs">
          <xsl:value-of select="@maxOccurs"/>
        </xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- choose and return occurs -->
    <xsl:choose>
      <xsl:when test="$minOccurs = '0' and $maxOccurs = '1'">?</xsl:when>
      <xsl:when test="$minOccurs = '1' and $maxOccurs = '1'"></xsl:when>
      <xsl:when test="$minOccurs = '0' and $maxOccurs = '*'">*</xsl:when>
      <xsl:when test="$minOccurs = '1' and $maxOccurs = '*'">+</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('{', $minOccurs, ',', $maxOccurs, '}')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--
  -->
  <!--
    - Collect content model of particles.
    - 
    - <p>This template handles all schema compositors having occurance
    - attributes, the so called particles.</p>
  -->
  <xsl:template match="xs:element[count(xs:simpleType | xs:complexType) = 0] | xs:any | xs:all | xs:sequence | xs:choice" mode="model">
    <xsl:param name="prohibited" select="string('')"/>
    <xsl:param name="occurs"/>
    <!-- recurse model tree -->
    <xsl:element name="doc:{local-name()}">
      <xsl:attribute name="occurs">
        <xsl:choose>
          <xsl:when test="$occurs">
            <xsl:value-of select="$occurs"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="." mode="occurs"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:if test="@name">
        <xsl:attribute name="name">
          <xsl:value-of select="@name"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@type">
        <xsl:attribute name="type">
          <xsl:value-of select="@type"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="local-name() = 'any'">
        <xsl:attribute name="namespace">
          <xsl:choose>
            <xsl:when test="@namespace">
              <xsl:value-of select="@namespace" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="string('')" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="name">
          <xsl:text>*</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@type">
        <xsl:attribute name="name">
          <xsl:value-of select="@name"/>
        </xsl:attribute>
        <xsl:variable name="prefix" select="substring-before(@type, ':')"/>
        <xsl:variable name="namespace" select="namespace::*[name() = $prefix]"/>
        <xsl:variable name="localname">
          <xsl:choose>
            <xsl:when test="contains(@type, ':')">
              <xsl:value-of select="substring-after(@type, ':')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@type"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="qname">
          <xsl:apply-templates select="." mode="resolve">
            <xsl:with-param name="qname" select="@type"/>
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
            <xsl:with-param name="referer" select="@type"/>
          </xsl:apply-templates>
        </xsl:variable>
        <xsl:if test="string($refType) != ''">
          <xsl:attribute name="href">
            <xsl:value-of select="concat('../../', $folder, '/', $refType, '/', $localname, '.html')"/>
          </xsl:attribute>
          <xsl:attribute name="namespace">
            <xsl:value-of select="/xs:schema/@targetNamespace"/>
          </xsl:attribute>
        </xsl:if>
      </xsl:if>
      <xsl:if test="@ref">
        <xsl:variable name="prefix" select="substring-before(@ref, ':')"/>
        <xsl:variable name="namespace" select="namespace::*[name() = $prefix]"/>
        <xsl:variable name="localname">
          <xsl:choose>
            <xsl:when test="contains(@ref, ':')">
              <xsl:value-of select="substring-after(@ref, ':')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@ref"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:attribute name="name">
          <xsl:value-of select="$localname"/>
        </xsl:attribute>
        <xsl:variable name="folder">
          <xsl:call-template name="namespaceFolder">
            <xsl:with-param name="uri" select="../namespace::*[name() = $prefix]"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="qname">
          <xsl:apply-templates select="." mode="resolve">
            <xsl:with-param name="qname" select="@ref"/>
          </xsl:apply-templates>
        </xsl:variable>
        <xsl:variable name="refType">
          <xsl:apply-templates select="/xs:schema" mode="referenceType">
            <xsl:with-param name="qname" select="$qname"/>
            <xsl:with-param name="referer" select="@ref"/>
          </xsl:apply-templates>
        </xsl:variable>
        <xsl:if test="string($refType) != ''">
          <xsl:attribute name="href">
            <xsl:value-of select="concat('../../', $folder, '/element/', $localname, '.html')"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:attribute name="namespace">
          <xsl:value-of select="/xs:schema/@targetNamespace"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="xs:*" mode="model">
        <xsl:with-param name="prohibited" select="$prohibited"/>
      </xsl:apply-templates>
      <xsl:if test="xs:annotation/xs:documentation">
        <doc:documentation>
          <xsl:for-each select="xs:annotation/xs:documentation">
            <xsl:copy-of select="* | text()"/>
          </xsl:for-each>
        </doc:documentation>
      </xsl:if>
    </xsl:element>
  </xsl:template>
  <!--
    Recurse complexType.
  -->
  <xsl:template match="xs:complexType" mode="model">
    <xsl:param name="occurs"/>
    <xsl:param name="prohibited" select="string('')"/>
    <xsl:apply-templates select="xs:*" mode="model">
      <xsl:with-param name="occurs" select="$occurs"/>
      <xsl:with-param name="prohibited" select="$prohibited"/>
    </xsl:apply-templates>
  </xsl:template>
  <!--
    collect attribute group model.
  -->
  <xsl:template match="xs:attributeGroup" mode="model">
    <xsl:param name="prohibited" select="string('')"/>
    <xsl:variable name="redefine" select="ancestor::*[name() = 'xs:redefine']"/>
    <xsl:choose>
      <xsl:when test="$redefine and (string(@ref) != '') and position() = 1">
        <xsl:variable name="refQName">
          <xsl:apply-templates select="." mode="resolve">
            <xsl:with-param name="qname" select="@ref"/>
          </xsl:apply-templates>
        </xsl:variable>
        <xsl:apply-templates select="document($redefine/@schemaLocation, .)/xs:schema" mode="attributeGroup">
          <xsl:with-param name="qname" select="$refQName"/>
          <xsl:with-param name="prohibited" select="$prohibited"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="string(@ref) != ''">
        <xsl:variable name="qname">
          <xsl:apply-templates select="." mode="resolve">
            <xsl:with-param name="qname" select="@ref"/>
          </xsl:apply-templates>
        </xsl:variable>
        <xsl:apply-templates select="$mainSchema" mode="attributeGroup">
          <xsl:with-param name="qname" select="$qname"/>
          <xsl:with-param name="prohibited" select="$prohibited"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="xs:*" mode="model">
          <xsl:with-param name="prohibited" select="$prohibited"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--
  -->
  <xsl:template match="xs:schema" mode="attributeGroup">
    <xsl:param name="qname"/>
    <xsl:param name="prohibited" select="string('')"/>
    <xsl:variable name="attributeGroupDefinition" select="key('attributeGroupDefinitions', $qname)"/>
    <xsl:variable name="attributeGroupRedefinition" select="key('attributeGroupRedefinitions', $qname)"/>
    <xsl:choose>
      <xsl:when test="$attributeGroupDefinition">
        <xsl:apply-templates select="$attributeGroupDefinition" mode="model">
          <xsl:with-param name="prohibited" select="$prohibited"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$attributeGroupRedefinition">
        <xsl:apply-templates select="$attributeGroupRedefinition" mode="model">
          <xsl:with-param name="prohibited" select="$prohibited"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="xs:include | xs:import | xs:redefine">
          <xsl:apply-templates select="document(@schemaLocation)/xs:schema" mode="attributeGroup">
            <xsl:with-param name="qname" select="$qname"/>
            <xsl:with-param name="prohibited" select="$prohibited"/>
          </xsl:apply-templates>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--
  -->
  <xsl:template match="xs:attribute" mode="model">
    <xsl:param name="prohibited" select="string('')"/>
    <xsl:choose>
      <xsl:when test="@ref">
        <xsl:variable name="qname">
          <xsl:apply-templates select="." mode="resolve">
            <xsl:with-param name="qname" select="@ref"/>
          </xsl:apply-templates>
        </xsl:variable>
        <xsl:apply-templates select="$mainSchema" mode="attribute">
          <xsl:with-param name="qname" select="$qname"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="@name">
        <xsl:if test="string(@use) != 'prohibited' and not(contains($prohibited, concat('{', /xs:schema/@targetNamespace, '}', @name)))">
          <doc:attribute name="{@name}">
            <xsl:attribute name="use">
              <xsl:choose>
                <xsl:when test="string(@use) = ''">
                  <xsl:value-of select="'optional'"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="@use"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="fixed">
              <xsl:value-of select="@fixed"/>
            </xsl:attribute>
            <xsl:attribute name="default">
              <xsl:value-of select="@default"/>
            </xsl:attribute>
            <xsl:attribute name="form">
              <xsl:choose>
                <xsl:when test="string(@form) != ''">
                  <xsl:value-of select="@form"/>
                </xsl:when>
                <xsl:when test="string(/xs:schema/@attributeFormDefault) != ''">
                  <xsl:value-of select="/xs:schema/@attributeFormDefault"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>unqualified</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <xsl:choose>
              <xsl:when test="@type">
                <xsl:attribute name="type">
                  <xsl:value-of select="@type"/>
                </xsl:attribute>
                <xsl:variable name="prefix" select="substring-before(@type, ':')"/>
                <xsl:variable name="localname">
                  <xsl:choose>
                    <xsl:when test="contains(@type, ':')">
                      <xsl:value-of select="substring-after(@type, ':')"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="@type"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:variable name="qname">
                  <xsl:apply-templates select="." mode="resolve">
                    <xsl:with-param name="qname" select="@type"/>
                  </xsl:apply-templates>
                </xsl:variable>
                <xsl:variable name="folder">
                  <xsl:call-template name="namespaceFolder">
                    <xsl:with-param name="uri" select="namespace::*[name() = $prefix]"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="refType">
                  <xsl:apply-templates select="$mainSchema" mode="referenceType">
                    <xsl:with-param name="qname" select="$qname"/>
                    <xsl:with-param name="referer" select="@type"/>
                  </xsl:apply-templates>
                </xsl:variable>
                <xsl:if test="string($refType) != ''">
                  <xsl:attribute name="href">
                    <xsl:value-of select="concat('../../', $folder, '/', $refType, '/', $localname, '.html')"/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:when>
              <xsl:when test="xs:*">
                <xsl:attribute name="base">
                  <xsl:value-of select="xs:*/xs:*/@base"/>
                </xsl:attribute>
                <xsl:attribute name="href">
                  <xsl:value-of select="concat('#attr_', @name)"/>
                </xsl:attribute>
                <xsl:apply-templates select="xs:*" mode="model">
                  <xsl:with-param name="prohibited" select="$prohibited"/>
                </xsl:apply-templates>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="type">
                  <xsl:text>anySimpleType</xsl:text>
                </xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="xs:annotation/xs:documentation">
              <doc:documentation>
                <xsl:for-each select="xs:annotation/xs:documentation">
                  <xsl:copy-of select="* | text()"/>
                </xsl:for-each>
              </doc:documentation>
            </xsl:if>
          </doc:attribute>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!--
    extension or restriction model.
  -->
  <xsl:template match="xs:extension | xs:restriction" mode="model">
    <xsl:param name="prohibited" select="string('')"/>
    <xsl:variable name="prefix" select="substring-before(@base, ':')"/>
    <xsl:variable name="localname">
      <xsl:choose>
        <xsl:when test="contains(@base, ':')">
          <xsl:value-of select="substring-after(@base, ':')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@base"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="qname">
      <xsl:apply-templates select="." mode="resolve">
        <xsl:with-param name="qname" select="@base"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="folder">
      <xsl:call-template name="namespaceFolder">
        <xsl:with-param name="uri" select="namespace::*[name() = $prefix]"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="refType">
      <xsl:apply-templates select="$mainSchema" mode="referenceType">
        <xsl:with-param name="qname" select="$qname"/>
        <xsl:with-param name="referer" select="@base"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:element name="doc:{local-name()}">
      <xsl:if test="string($refType) != ''">
        <xsl:attribute name="href">
          <xsl:value-of select="concat('../../', $folder, '/', $refType, '/', $localname, '.html')"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="@*" mode="model"/>
      <xsl:apply-templates select="xs:*" mode="model">
        <xsl:with-param name="prohibited" select="$prohibited"/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>
  <!--
    default elements model.
  -->
  <xsl:template match="xs:schema" mode="model">
  </xsl:template>
  <!--
    nested elements.
  -->
  <xsl:template match="xs:element" mode="model" priority="-1">
    <xsl:param name="prohibited" select="string('')"/>
    <xsl:variable name="folder">
      <xsl:call-template name="namespaceFolder">
        <xsl:with-param name="uri" select="/xs:schema/@targetNamespace"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:element name="doc:element">
      <xsl:apply-templates select="@*" mode="model"/>
      <xsl:variable name="hierarchy">
        <xsl:apply-templates select="." mode="parent"/>
      </xsl:variable>
      <xsl:if test="@type">
        <xsl:attribute name="type">
          <xsl:value-of select="@type"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:attribute name="href">
        <xsl:value-of select="concat('../../', $folder, '/', $hierarchy, 'html')"/>
      </xsl:attribute>
      <xsl:if test="xs:annotation/xs:documentation">
        <doc:documentation>
          <xsl:for-each select="xs:annotation/xs:documentation">
            <xsl:copy-of select="* | text()"/>
          </xsl:for-each>
        </doc:documentation>
      </xsl:if>
      <xsl:if test="xs:simpleType">
        <xsl:apply-templates select="xs:simpleType" mode="model"/>
      </xsl:if>
    </xsl:element>
  </xsl:template>
  <!--
    collect hierarchy
  -->
  <xsl:template match="*" mode="hierarchy">
    <xsl:choose>
      <xsl:when test="@name">
        <xsl:apply-templates select=".." mode="hierarchy"/>
        <xsl:value-of select="concat(@name, '.')"/>
      </xsl:when>
      <xsl:when test="local-name(.) != 'schema'">
        <xsl:apply-templates select=".." mode="hierarchy"/>
      </xsl:when>
    </xsl:choose>
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
    default elements model.
  -->
  <xsl:template match="xs:*" mode="model" priority="-2">
    <xsl:param name="prohibited" select="string('')"/>
    <xsl:element name="doc:{local-name()}">
      <xsl:apply-templates select="@*" mode="model"/>
      <xsl:apply-templates select="xs:annotation" mode="model">
        <xsl:with-param name="prohibited" select="$prohibited"/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>
  <!--
    Ignore annotations in content model documentation.
  -->
  <xsl:template match="xs:annotation" mode="model">
  </xsl:template>
  <!--
    default attributes model.
  -->
  <xsl:template match="@*" mode="model">
    <xsl:attribute name="{name()}">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>
  <!--
    collect prohibited attribute names
  -->
  <xsl:template match="xs:*" mode="prohibited">
    <xsl:param name="prohibited" select="string('')"/>
    <xsl:variable name="newProhibited">
      <xsl:for-each select="xs:attribute[@name]">
        <xsl:if test="string(@use) = 'prohibited' or string(@type) != '' or xs:*">
          <xsl:value-of select="concat('{', /xs:schema/@targetNamespace, '}', @name)"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="concat($prohibited, string($newProhibited))"/>
  </xsl:template>
  <!--
    resolve any attribute references.
    (##any | ##other) | List of (anyURI | (##targetNamespace | ##local))
  -->
  <xsl:template match="xs:anyAttribute" mode="model">
    <xsl:choose>
      <xsl:when test="@namespace = '##any'">
        <doc:attribute any="any attribute from any namespace"/>
      </xsl:when>
      <xsl:when test="@namespace = '##other'">
        <doc:attribute any="any attribute from any other namespace than current namespace"/>
      </xsl:when>
      <xsl:otherwise>
        <doc:attribute>
          <xsl:attribute name="any">
            <xsl:text>any attribute from the namespaces </xsl:text>
            <xsl:if test="contains(@namespace, '##local')">
              <xsl:value-of select="/xs:schema/@targetNamespace"/>
            </xsl:if>
            <xsl:value-of select="substring-before(@namespace, '##local')"/>
            <xsl:value-of select="substring-after(@namespace, '##local')"/>
          </xsl:attribute>
        </doc:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--
    resolve attribute references
  -->
  <xsl:template match="xs:schema" mode="attribute">
    <xsl:param name="qname"/>
    <xsl:param name="prohibited" select="string('')"/>
    <xsl:variable name="attributeDeclaration" select="key('attributeDeclarations', $qname)"/>
    <xsl:choose>
      <xsl:when test="$attributeDeclaration">
        <xsl:apply-templates select="$attributeDeclaration" mode="model">
          <xsl:with-param name="prohibited" select="$prohibited"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="xs:include | xs:import | xs:redefine">
          <xsl:apply-templates select="document(@schemaLocation)/xs:schema" mode="attribute">
            <xsl:with-param name="qname" select="$qname"/>
            <xsl:with-param name="prohibited" select="$prohibited"/>
          </xsl:apply-templates>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--
    - Collect content model of an <code>complexContent</code>.
    - 
    - <p>With the <code>complexContent</code> element, content models are
    - derived by <code>extension</code> or <code>restriction</code>.
    - 
    - <p>A restricted content model must redefine all particles of the base
    - type, where only restrictions on their occurance are allowed. That means
    - the base type can be ignored when collectring the content model.</p>
    - 
    - <p>An extended content model is based on the content model of the base
    - type where particles can only be appended by the derived type. That means
    - the content model of the base type must be collected and afterwards the
    - content model of the derived type must be appended.</p>
  -->
  <xsl:template match="xs:complexContent" mode="model">
    <xsl:param name="prohibited" select="string('')"/>
    <xsl:variable name="derivation" select="xs:*"/>
    <xsl:variable name="newProhibited">
      <xsl:apply-templates select="xs:*" mode="prohibited">
        <xsl:with-param name="prohibited" select="$prohibited"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="baseType">
      <xsl:apply-templates select="." mode="resolve">
        <xsl:with-param name="qname" select="xs:*/@base"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="xs:restriction">
        <xsl:apply-templates select="$mainSchema" mode="attributesForType">
          <xsl:with-param name="qname" select="$baseType"/>
          <xsl:with-param name="prohibited" select="$newProhibited"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="xs:restriction/xs:*" mode="model">
          <xsl:with-param name="prohibited" select="$prohibited"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="xs:extension">
        <xsl:choose>
          <xsl:when test="ancestor::xs:redefine">
            <xsl:apply-templates select="document(ancestor::xs:redefine/@schemaLocation)/xs:schema" mode="typeModel">
              <xsl:with-param name="qname" select="$baseType"/>
              <xsl:with-param name="prohibited" select="$newProhibited"/>
            </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="$mainSchema" mode="typeModel">
              <xsl:with-param name="qname" select="$baseType"/>
              <xsl:with-param name="prohibited" select="$newProhibited"/>
            </xsl:apply-templates>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="xs:extension/xs:*" mode="model">
          <xsl:with-param name="prohibited" select="$prohibited"/>
        </xsl:apply-templates>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!--
    - Collect content model of a <code>simpleContent</code>.
  -->
  <xsl:template match="xs:simpleContent" mode="model">
    <xsl:param name="prohibited" select="string('')"/>
    <xsl:variable name="derivation" select="xs:*"/>
    <xsl:variable name="newProhibited">
      <xsl:apply-templates select="xs:*" mode="prohibited">
        <xsl:with-param name="prohibited" select="$prohibited"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="xs:restriction">
        <xsl:variable name="baseType">
          <xsl:apply-templates select="." mode="resolve">
            <xsl:with-param name="qname" select="xs:restriction/@base"/>
          </xsl:apply-templates>
        </xsl:variable>
        <xsl:apply-templates select="xs:restriction/xs:*" mode="model">
          <xsl:with-param name="prohibited" select="$newProhibited"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="$mainSchema" mode="attributesForType">
          <xsl:with-param name="qname" select="$baseType"/>
          <xsl:with-param name="prohibited" select="$newProhibited"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="xs:extension">
        <xsl:variable name="baseType">
          <xsl:apply-templates select="." mode="resolve">
            <xsl:with-param name="qname" select="xs:extension/@base"/>
          </xsl:apply-templates>
        </xsl:variable>
        <xsl:variable name="prefix" select="substring-before(xs:extension/@base, ':')"/>
        <xsl:variable name="localname">
          <xsl:choose>
            <xsl:when test="contains(xs:extension/@base, ':')">
              <xsl:value-of select="substring-after(xs:extension/@base, ':')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="xs:extension/@base"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="folder">
          <xsl:call-template name="namespaceFolder">
            <xsl:with-param name="uri" select="../namespace::*[name() = $prefix]"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:apply-templates select="xs:extension/xs:*" mode="model">
          <xsl:with-param name="prohibited" select="$prohibited"/>
        </xsl:apply-templates>
        <doc:type name="{$localname}" namespace="{/xs:schema/@targetNamespace}">
          <xsl:attribute name="href">
            <xsl:value-of select="concat('../../', $folder, '/simpleType/', $localname, '.html')"/>
          </xsl:attribute>
          <xsl:for-each select="xs:extension">
            <xsl:apply-templates select="xs:simpleType | xs:minExclusive | xs:minInclusive | xs:maxExclusive | xs:maxInclusive | xs:totalDigits | xs:fractionDigits | xs:length | xs:minLength | xs:maxLength | xs:enumeration | xs:whiteSpace | xs:pattern" mode="model">
              <xsl:with-param name="prohibited" select="$prohibited"/>
            </xsl:apply-templates>
          </xsl:for-each>
        </doc:type>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!--
    - Recursive collect attributes of type given by qname parameter in current
    - context.
  -->
  <xsl:template match="xs:schema" mode="attributesForType">
    <xsl:param name="qname"/>
    <xsl:param name="prohibited" select="string('')"/>
    <xsl:variable name="superTypeDefinition" select="key('typeDefinitions', string($qname)) | key('typeRedefinitions', string($qname))"/>
    <xsl:choose>
      <!-- found: return type definition and terminate -->
      <xsl:when test="$superTypeDefinition">
        <xsl:apply-templates select="$superTypeDefinition/xs:attribute" mode="model">
          <xsl:with-param name="prohibited" select="$prohibited"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="$superTypeDefinition/xs:attributeGroup" mode="model">
          <xsl:with-param name="prohibited" select="$prohibited"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="$superTypeDefinition/xs:complexContent/xs:*/xs:attribute" mode="model">
          <xsl:with-param name="prohibited" select="$prohibited"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="$superTypeDefinition/xs:complexContent/xs:*/xs:attributeGroup" mode="model">
          <xsl:with-param name="prohibited" select="$prohibited"/>
        </xsl:apply-templates>
        <xsl:variable name="newProhibited">
          <xsl:apply-templates select="$superTypeDefinition/xs:complexContent/xs:*" mode="prohibited">
            <xsl:with-param name="prohibited" select="$prohibited"/>
          </xsl:apply-templates>
        </xsl:variable>
        <xsl:for-each select="$superTypeDefinition/xs:complexContent/xs:*">
          <xsl:apply-templates select="$mainSchema" mode="attributesForType">
            <xsl:with-param name="qname">
              <xsl:apply-templates select="." mode="resolve">
                <xsl:with-param name="qname" select="@base"/>
              </xsl:apply-templates>
            </xsl:with-param>
            <xsl:with-param name="prohibited" select="$newProhibited"/>
          </xsl:apply-templates>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <!-- not found in this schema: recurse into all imported and included schema -->
        <xsl:for-each select="xs:import | xs:include | xs:redefine">
          <xsl:apply-templates select="document(@schemaLocation, .)/xs:schema" mode="attributesforType">
            <xsl:with-param name="qname" select="$qname"/>
            <xsl:with-param name="prohibited" select="$prohibited"/>
          </xsl:apply-templates>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--
    - Collect content model of groups.
    - 
    - <p>If the group element refers to a group definition, collect that
    - group, else collect all children of this group</p>
  -->
  <xsl:template match="xs:group" mode="model">
    <xsl:param name="occurs"/>
    <xsl:param name="prohibited" select="string('')"/>
    <xsl:variable name="redefine" select="ancestor::*[name() = 'xs:redefine']"/>
    <xsl:choose>
      <xsl:when test="$redefine and (string(@ref) != '')">
        <xsl:variable name="refQName">
          <xsl:apply-templates select="." mode="resolve">
            <xsl:with-param name="qname" select="@ref"/>
          </xsl:apply-templates>
        </xsl:variable>
        <xsl:variable name="localOccurs">
          <xsl:apply-templates select="." mode="occurs"/>
        </xsl:variable>
        <xsl:apply-templates select="document($redefine/@schemaLocation, .)/xs:schema" mode="groupModel">
          <xsl:with-param name="qname" select="$refQName"/>
          <xsl:with-param name="occurs" select="$localOccurs"/>
          <xsl:with-param name="prohibited" select="$prohibited"/>
          <xsl:with-param name="group" select="."/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="string(@ref) != ''">
        <xsl:variable name="refQName">
          <xsl:apply-templates select="." mode="resolve">
            <xsl:with-param name="qname" select="@ref"/>
          </xsl:apply-templates>
        </xsl:variable>
        <xsl:variable name="localOccurs">
          <xsl:apply-templates select="." mode="occurs"/>
        </xsl:variable>
        <xsl:apply-templates select="$mainSchema" mode="groupModel">
          <xsl:with-param name="qname" select="$refQName"/>
          <xsl:with-param name="occurs" select="$localOccurs"/>
          <xsl:with-param name="prohibited" select="$prohibited"/>
          <xsl:with-param name="group" select="."/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="xs:*" mode="model">
          <xsl:with-param name="occurs" select="$occurs"/>
          <xsl:with-param name="prohibited" select="$prohibited"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--
    - Recursive collect content model of group given by qname parameter in current
    - context.
    - 
    - <p>If no group definition was found in current schema, recursive try in all
    - included or imported schemas.</p>
  -->
  <!-- XXX FIXME -->
  <xsl:template match="xs:schema" mode="groupModel">
    <xsl:param name="qname"/>
    <xsl:param name="occurs"/>
    <xsl:param name="prohibited" select="string('')"/>
    <xsl:param name="group"/>
    <xsl:variable name="groupDefinition" select="key('modelGroupDefinitions', string($qname))"/>
    <xsl:variable name="groupRedefinition" select="key('modelGroupRedefinitions', string($qname))"/>
    <xsl:choose>
      <!-- try type definition in current file if available -->
      <xsl:when test="$groupDefinition">
        <xsl:apply-templates select="$groupDefinition" mode="model">
          <xsl:with-param name="occurs" select="$occurs"/>
          <xsl:with-param name="prohibited" select="$prohibited"/>
        </xsl:apply-templates>
      </xsl:when>
      <!-- try redefined group definition in current file -->
      <xsl:when test="$groupRedefinition">
        <xsl:apply-templates select="$groupRedefinition" mode="model">
          <xsl:with-param name="occurs" select="$occurs"/>
          <xsl:with-param name="prohibited" select="$prohibited"/>
        </xsl:apply-templates>
      </xsl:when>
      <!-- not found in this schema: recurse into all imported, included or redefined schema -->
      <xsl:otherwise>
        <xsl:for-each select="xs:import | xs:include | xs:redefine">
          <xsl:apply-templates select="document(@schemaLocation, .)/xs:schema" mode="groupModel">
            <xsl:with-param name="qname" select="$qname"/>
            <xsl:with-param name="occurs" select="$occurs"/>
            <xsl:with-param name="prohibited" select="$prohibited"/>
          </xsl:apply-templates>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--
    Recurse type references.
  -->
  <xsl:template match="xs:schema" mode="typeModel">
    <xsl:param name="qname"/>
    <xsl:param name="occurs"/>
    <xsl:param name="prohibited" select="string('')"/>
    <xsl:variable name="localTypeDefinition" select="key('typeDefinitions', string($qname)) | key('typeRedefinitions', string($qname))"/>
    <xsl:choose>
      <xsl:when test="count($localTypeDefinition) &gt; 0">
        <xsl:apply-templates select="$localTypeDefinition" mode="model">
          <xsl:with-param name="occurs" select="$occurs"/>
          <xsl:with-param name="prohibited" select="$prohibited"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <!-- not found in this schema: recurse into all imported and included schema -->
        <xsl:for-each select="xs:import | xs:include | xs:redefine">
          <xsl:apply-templates select="document(@schemaLocation, .)/xs:schema" mode="typeModel">
            <xsl:with-param name="qname" select="$qname"/>
            <xsl:with-param name="occurs" select="$occurs"/>
            <xsl:with-param name="prohibited" select="$prohibited"/>
          </xsl:apply-templates>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--
    Recurse element references.
  -->
  <xsl:template match="xs:schema" mode="elementModel">
    <xsl:param name="qname"/>
    <xsl:param name="occurs"/>
    <xsl:param name="prohibited" select="string('')"/>
    <xsl:variable name="localElementDeclaration" select="key('elementDeclaration', $qname)"/>
    <xsl:choose>
      <xsl:when test="count($localElementDeclaration) &gt; 0">
        <xsl:apply-templates select="$localElementDeclaration" mode="model">
          <xsl:with-param name="occurs" select="$occurs"/>
          <xsl:with-param name="prohibited" select="$prohibited"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <!-- not found in this schema: recurse into all imported and included schema -->
        <xsl:for-each select="xs:import | xs:include | xs:redefine">
          <xsl:apply-templates select="document(@schemaLocation, .)/xs:schema" mode="model">
            <xsl:with-param name="qname" select="$qname"/>
            <xsl:with-param name="occurs" select="$occurs"/>
            <xsl:with-param name="prohibited" select="$prohibited"/>
          </xsl:apply-templates>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--
    explicit default template for nodes.
  -->
  <xsl:template match="*">
    <xsl:apply-templates/>
  </xsl:template>
  <!--
    explicit default template for attributes and text.
  -->
  <xsl:template match="@*|text()">
    <xsl:value-of select="."/>
  </xsl:template>
</xsl:stylesheet>
