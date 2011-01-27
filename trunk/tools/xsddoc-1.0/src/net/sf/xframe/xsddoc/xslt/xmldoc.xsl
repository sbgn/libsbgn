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
  exclude-result-prefixes="xs" version="1.0">
  <!--
    Format schema fragment as colored source.
  -->
  <xsl:template match="*" mode="xmldoc">
    <xsl:param name="children" select="*"/>
    <pre>
      <xsl:apply-templates select="." mode="xmldocHandler">
        <xsl:with-param name="children" select="$children"/>
      </xsl:apply-templates>
    </pre>
  </xsl:template>
  <!--
    Format schema fragment as colored source.
  -->
  <xsl:template match="*" mode="xmldocHandler">
    <xsl:param name="children" select="*"/>
    <xsl:param name="indent" select="string('')"/>
    <xsl:if test="local-name() != 'annotation'">
    <div class="code">
      <xsl:value-of select="$indent"/>
      <span class="oper">&lt;</span>
      <span class="elem">
        <xsl:value-of select="name()"/>
      </span>
      <xsl:variable name="instance" select="/xs:schema"/>
      <xsl:for-each select="@*[local-name() != 'xsddocid']">
        <xsl:apply-templates select="$instance" mode="attributesHandler">
          <xsl:with-param name="attribute" select="."/>
        </xsl:apply-templates>
      </xsl:for-each>
      <xsl:choose>
        <xsl:when test="count(*) > 0">
          <span class="oper">&gt;</span>
          <br/>
          <xsl:apply-templates select="$children" mode="xmldocHandler">
            <xsl:with-param name="indent" select="concat($indent, '  ')"/>
          </xsl:apply-templates>
          <xsl:value-of select="$indent"/>
          <span class="oper">&lt;/</span>
          <span class="elem">
            <xsl:value-of select="name()"/>
          </span>
          <span class="oper">&gt;</span>
          <br/>
        </xsl:when>
        <xsl:otherwise>
          <span class="oper">/&gt;</span>
          <br/>
        </xsl:otherwise>
      </xsl:choose>
    </div>
    </xsl:if>
  </xsl:template>
  <!--
    Format attributes with cross reference links.
    todo: recurse parents instead of only looking in root element
  -->
  <xsl:template match="xs:schema" mode="attributesHandler">
    <xsl:param name="attribute"/>
    <xsl:variable name="prefix" select="substring-before($attribute, ':')"/>
    <xsl:variable name="localname">
      <xsl:choose>
        <xsl:when test="contains($attribute, ':')">
          <xsl:value-of select="substring-after($attribute, ':')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$attribute"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="folder">
      <xsl:call-template name="namespaceFolder">
        <xsl:with-param name="uri" select="$attribute/../namespace::*[name() = $prefix]"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="qname">
      <xsl:apply-templates select="." mode="resolve">
        <xsl:with-param name="qname" select="$attribute"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="refType">
      <xsl:if test="name($attribute) = 'base' or name($attribute) = 'ref' or name($attribute) = 'type' or name($attribute) = 'itemType'">
        <xsl:apply-templates select="/xs:schema" mode="referenceType">
          <xsl:with-param name="qname" select="$qname"/>
          <xsl:with-param name="referer" select="$attribute"/>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:variable>
    <xsl:text> </xsl:text>
    <span class="attr">
      <xsl:value-of select="name($attribute)"/>
    </span>
    <span class="oper">
      <xsl:text>="</xsl:text>
    </span>
    <xsl:choose>
      <xsl:when test="string($refType) != ''">
        <a>
          <xsl:attribute name="href"><xsl:value-of select="concat('../../', $folder, '/', $refType, '/', $localname, '.html')"/></xsl:attribute>
          <span class="cont">
            <xsl:value-of select="$attribute"/>
          </span>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <span class="cont">
          <xsl:value-of select="$attribute"/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
    <span class="oper">
      <xsl:text>"</xsl:text>
    </span>
  </xsl:template>
  <!--
  -->
  <xsl:template name="reference">
    <span class="cont">
      <xsl:value-of select="."/>
    </span>
  </xsl:template>
  <!--
    ignore some attributes
  -->
  <xsl:template match="@doc:*">
  </xsl:template>
</xsl:stylesheet>
