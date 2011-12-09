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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:doc="http://xframe.sf.net/xsddoc/doc" exclude-result-prefixes="xs doc" version="1.0">
  <!--
    This transformation generates html from a XML schema documentation.
  -->
  <xsl:output indent="no" version="4.0" method="html" encoding="ISO-8859-1" omit-xml-declaration="yes" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" doctype-system="http://www.w3.org/TR/html4/loose.dtd"/>
  <!--
    Include templates to document XML
  -->
  <xsl:include href="xmldoc.xsl"/>
  <!--
    Include xsddoc utilities templates.
  -->
  <xsl:include href="util.xsl"/>
  <!--
    title parameter.
  -->
  <xsl:param name="doctitle"/>
  <!--
    header parameter.
  -->
  <xsl:param name="header"/>
  <!--
    footer parameter.
  -->
  <xsl:param name="footer"/>
  <!--
    bottom parameter.
  -->
  <xsl:param name="bottom"/>
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
    Root template.
  -->
  <xsl:template match="/">
    <xsl:apply-templates select="*"/>
  </xsl:template>
  <!--
    Template for the overview element, the root element of overview lists.
  -->
  <xsl:template match="doc:overview">
    <html>
      <xsl:call-template name="xsddocComment"/>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
        <link rel="stylesheet" type="text/css" href="../stylesheet.css" title="Style"/>
      </head>
      <body>
        <xsl:choose>
        <xsl:when test="@namespace">
          <a href="{@href}" target="content">
            <xsl:value-of select="@namespace"/>
          </a>
          <br/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>All components</xsl:text>
          <br/>
        </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="doc:component[@type = 'element']">
          <br/>
          <b>
            <xsl:text>elements</xsl:text>
          </b>
          <br/>
          <xsl:apply-templates select="doc:component[@type='element']" mode="overview">
            <xsl:sort select="@name"/>
          </xsl:apply-templates>
        </xsl:if>
        <xsl:if test="$hideAttributes = 'false' and doc:component[@type = 'attribute']">
          <br/>
          <b>
            <xsl:text>attributes</xsl:text>
          </b>
          <br/>
          <xsl:apply-templates select="doc:component[@type='attribute']" mode="overview">
            <xsl:sort select="@name"/>
          </xsl:apply-templates>
        </xsl:if>
        <xsl:if test="$hideTypes = 'false' and doc:component[@type = 'complexType']">
          <br/>
          <b>
            <xsl:text>complexTypes</xsl:text>
          </b>
          <br/>
          <xsl:apply-templates select="doc:component[@type='complexType']" mode="overview">
            <xsl:sort select="@name"/>
          </xsl:apply-templates>
        </xsl:if>
        <xsl:if test="$hideTypes = 'false' and doc:component[@type = 'simpleType']">
          <br/>
          <b>
            <xsl:text>simpleTypes</xsl:text>
          </b>
          <br/>
          <xsl:apply-templates select="doc:component[@type='simpleType']" mode="overview">
            <xsl:sort select="@name"/>
          </xsl:apply-templates>
        </xsl:if>
        <xsl:if test="$hideGroups = 'false' and doc:component[@type = 'group']">
          <br/>
          <b>
            <xsl:text>groups</xsl:text>
          </b>
          <br/>
          <xsl:apply-templates select="doc:component[@type='group']" mode="overview">
            <xsl:sort select="@name"/>
          </xsl:apply-templates>
        </xsl:if>
        <xsl:if test="$hideGroups = 'false' and doc:component[@type = 'attributeGroup']">
          <br/>
          <b>
            <xsl:text>attributeGroups</xsl:text>
          </b>
          <br/>
          <xsl:apply-templates select="doc:component[@type='attributeGroup']" mode="overview">
            <xsl:sort select="@name"/>
          </xsl:apply-templates>
        </xsl:if>
      </body>
    </html>
  </xsl:template>
  <!--
    Template for the overview of all elements.
  -->
  <xsl:template match="doc:overview-all">
    <html>
      <xsl:call-template name="xsddocComment"/>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
        <link rel="stylesheet" type="text/css" href="./stylesheet.css" title="Style"/>
      </head>
      <body>
        <xsl:choose>
        <xsl:when test="@namespace">
          <a href="{@href}" target="content">
            <xsl:value-of select="@namespace"/>
          </a>
          <br/>
        </xsl:when>
        <xsl:otherwise>
          <b><xsl:text>All components</xsl:text></b>
          <br/>
        </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="doc:component[@localtype = 'element']">
          <br/>
          <b>
            <xsl:text>elements</xsl:text>
          </b>
          <br/>
          <xsl:apply-templates select="doc:component[@localtype = 'element']" mode="overview-all">
            <xsl:sort select="@tag"/>
          </xsl:apply-templates>
        </xsl:if>
        <xsl:if test="$hideAttributes = 'false' and doc:component[@localtype = 'attribute']">
          <br/>
          <b>
            <xsl:text>attributes</xsl:text>
          </b>
          <br/>
          <xsl:apply-templates select="doc:component[@localtype = 'attribute']" mode="overview-all">
            <xsl:sort select="@tag"/>
          </xsl:apply-templates>
        </xsl:if>
        <xsl:if test="$hideTypes = 'false' and doc:component[@localtype = 'complexType']">
          <br/>
          <b>
            <xsl:text>complexTypes</xsl:text>
          </b>
          <br/>
          <xsl:apply-templates select="doc:component[@localtype = 'complexType']" mode="overview-all">
            <xsl:sort select="@tag"/>
          </xsl:apply-templates>
        </xsl:if>
        <xsl:if test="$hideTypes = 'false' and doc:component[@localtype = 'simpleType']">
          <br/>
          <b>
            <xsl:text>simpleTypes</xsl:text>
          </b>
          <br/>
          <xsl:apply-templates select="doc:component[@localtype = 'simpleType']" mode="overview-all">
            <xsl:sort select="@tag"/>
          </xsl:apply-templates>
        </xsl:if>
        <xsl:if test="$hideGroups = 'false' and doc:component[@localtype = 'group']">
          <br/>
          <b>
            <xsl:text>groups</xsl:text>
          </b>
          <br/>
          <xsl:apply-templates select="doc:component[@localtype = 'group']" mode="overview-all">
            <xsl:sort select="@tag"/>
          </xsl:apply-templates>
        </xsl:if>
        <xsl:if test="$hideGroups = 'false' and doc:component[@localtype = 'attributeGroup']">
          <br/>
          <b>
            <xsl:text>attributeGroups</xsl:text>
          </b>
          <br/>
          <xsl:apply-templates select="doc:component[@localtype = 'attributeGroup']" mode="overview">
            <xsl:sort select="@name"/>
          </xsl:apply-templates>
        </xsl:if>
      </body>
    </html>
  </xsl:template>
  <!--
    Template for the list entries in overviews.
  -->
  <xsl:template match="*" mode="overview">
    <a href="{@href}" target="content">
      <xsl:value-of select="@name"/>
    </a>
    <br/>
  </xsl:template>
  <!--
    Template for the list entries in overviews-all.
  -->
  <xsl:template match="*" mode="overview-all">
    <a href="{@href}" target="content">
      <xsl:value-of select="@tag"/>
    </a>
    <br/>
  </xsl:template>
  <!--
    Template for schema-summary pages
  -->
  <xsl:template match="doc:schema-summary">
    <html>
      <xsl:call-template name="xsddocComment"/>
      <head>
        <title>Namespaces Overview</title>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
        <link rel="stylesheet" type="text/css" href="./stylesheet.css" title="Style"/>
      </head>
      <body>
        <xsl:call-template name="navigationOverview"/>
        <h2>
          <xsl:value-of disable-output-escaping="yes" select="$doctitle"/>
        </h2>
        <p>
          <table border="1" cellpadding="3" cellspacing="0" width="100%">
            <tbody>
              <tr>
                <th colspan="2" class="TableHeadingColor" align="left">
                  <font size="+2">
                    <b>Namespaces</b>
                  </font>
                </th>
              </tr>
              <xsl:apply-templates select="doc:namespace" mode="schema-summary"/>
            </tbody>
          </table>
        </p>
        <br/>
        <hr/>
        <xsl:call-template name="navigationOverview"/>
        <xsl:call-template name="bottom"/>
      </body>
    </html>
  </xsl:template>
  <!--
    Template for schema-index pages
  -->
  <xsl:template match="doc:namespace" mode="schema-summary">
    <tr>
      <td width="30%">
        <a href="{@href}">
          <xsl:if test="normalize-space(@name) = ''">
            <xsl:text>noNamespace</xsl:text>
          </xsl:if>
          <xsl:value-of select="@name"/>
        </a>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="doc:documentation">
            <xsl:apply-templates select="doc:documentation" mode="short-documentation"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
  </xsl:template>
  <!--
    Overview namespaces.
  -->
  <xsl:template match="doc:overview-namespaces">
    <html>
      <head>
        <title>Namespaces Overview</title>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
        <link rel="stylesheet" type="text/css" href="./stylesheet.css" title="Style"/>
      </head>
      <body>
        <p>
          <font size="+1" class="FrameTitleFont">
            <b>
              <xsl:value-of disable-output-escaping="yes" select="$header"/>
            </b>
          </font>
        </p>
        <br/>
        <b>
          <xsl:text>Namespaces</xsl:text>
        </b>
        <br/>
        <font class="FrameItemFont">
          <xsl:apply-templates select="*" mode="overview-namespaces"/>
        </font>
      </body>
    </html>
  </xsl:template>
  <!--
  -->
  <xsl:template match="doc:namespace" mode="overview-namespaces">
    <a target="index" href="{@href}">
      <xsl:if test="normalize-space(@name) = ''">
        <xsl:text>noNamespace</xsl:text>
      </xsl:if>
      <xsl:value-of select="@name"/>
    </a>
    <br/>
  </xsl:template>
  <!--
    Template for schema-index pages
  -->
  <xsl:template match="doc:schema-index">
    <html>
      <xsl:call-template name="xsddocComment"/>
      <head>
        <title>Index of Namespace <xsl:value-of select="/xs:schema/@targetNamespace"/>
        </title>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
        <link rel="stylesheet" type="text/css" href="../stylesheet.css" title="Style"/>
      </head>
      <body>
        <xsl:call-template name="navigationNamespace"/>
        <p>
          <xsl:apply-templates select="." mode="properties"/>
        </p>
        <xsl:call-template name="navigationNamespace"/>
        <xsl:call-template name="bottom"/>
      </body>
    </html>
  </xsl:template>
  <!--
    Template for index of all components.
  -->
  <xsl:template match="doc:index-all">
    <html>
      <xsl:call-template name="xsddocComment"/>
      <head>
        <title>Index of all Namespace</title>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
        <link rel="stylesheet" type="text/css" href="./stylesheet.css" title="Style"/>
      </head>
      <body>
        <xsl:call-template name="navigationIndex"/>
        <p>
          <xsl:apply-templates select="doc:component" mode="index-all">
            <xsl:sort select="concat(@tag, '.', @namespace)"/>
          </xsl:apply-templates>
        </p>
        <hr/>
        <xsl:call-template name="navigationIndex"/>
        <xsl:call-template name="bottom"/>
      </body>
    </html>
  </xsl:template>
  <!--
     Format index entry in index-all.
   -->
  <xsl:template match="doc:component" mode="index-all">
    <xsl:variable name="base">
      <xsl:choose>
        <xsl:when test="contains(normalize-space(@name), '. ')">
	  <xsl:value-of select="substring-before(normalize-space(@name), concat('. ', @tag))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="string('')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <dl>
      <a href="{@href}">
        <b><xsl:value-of select="@tag"/></b>
      </a>
      <xsl:text> - </xsl:text>
      <xsl:if test="contains(@name, '.')">
        <xsl:text>nested element in </xsl:text>
      </xsl:if>
      <xsl:value-of select="@type"/>
      <xsl:choose>
        <xsl:when test="@namespace">
          <xsl:text> of namespace </xsl:text>
          <xsl:value-of select="@namespace"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text> in no namespace.</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <dd>
        <xsl:choose>
          <xsl:when test="doc:documentation">
            <xsl:apply-templates select="doc:documentation" mode="short-documentation"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </dd>
    </dl>
  </xsl:template>
  <!--
     Format description of schema component in schema indices.
   -->
  <xsl:template match="doc:schema-index" mode="properties">
    <h2>
      <xsl:text>namespace </xsl:text>
      <xsl:value-of select="@targetNamespace"/>
    </h2>
    <dl>
      <dt>See:</dt>
      <dd>
        <a href="#description">
          <b>Description</b>
        </a>
      </dd>
    </dl>
    <xsl:if test="doc:component[@type = 'element']">
      <table border="1" width="100%" cellpadding="3" cellspacing="0" summary="">
        <tr bgcolor="#CCCCFF" class="TableHeadingColor">
          <td colspan="2">
            <font size="+2">
              <b>Element Summary</b>
            </font>
          </td>
        </tr>
        <xsl:apply-templates select="doc:component[@type = 'element']" mode="doc-index">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
      </table>
    </xsl:if>
    <xsl:if test="$hideTypes = 'false' and doc:component[@type = 'complexType']">
      <p>
        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
      </p>
      <table border="1" width="100%" cellpadding="3" cellspacing="0" summary="">
        <tr bgcolor="#CCCCFF" class="TableHeadingColor">
          <td colspan="2">
            <font size="+2">
              <b>Complex Type Summary</b>
            </font>
          </td>
        </tr>
        <xsl:apply-templates select="doc:component[@type = 'complexType']" mode="doc-index">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
      </table>
    </xsl:if>
    <xsl:if test="$hideAttributes = 'false' and doc:component[@type = 'attribute']">
      <p>
        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
      </p>
      <table border="1" width="100%" cellpadding="3" cellspacing="0" summary="">
        <tr bgcolor="#CCCCFF" class="TableHeadingColor">
          <td colspan="2">
            <font size="+2">
              <b>Attribute Summary</b>
            </font>
          </td>
        </tr>
        <xsl:apply-templates select="doc:component[@type = 'attribute']" mode="doc-index">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
      </table>
    </xsl:if>
    <xsl:if test="$hideTypes = 'false' and doc:component[@type = 'simpleType']">
      <p>
        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
      </p>
      <table border="1" width="100%" cellpadding="3" cellspacing="0" summary="">
        <tr bgcolor="#CCCCFF" class="TableHeadingColor">
          <td colspan="2">
            <font size="+2">
              <b>Simple Type Summary</b>
            </font>
          </td>
        </tr>
        <xsl:apply-templates select="doc:component[@type = 'simpleType']" mode="doc-index">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
      </table>
    </xsl:if>
    <xsl:if test="$hideGroups = 'false' and doc:component[@type = 'group']">
      <p>
        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
      </p>
      <table border="1" width="100%" cellpadding="3" cellspacing="0" summary="">
        <tr bgcolor="#CCCCFF" class="TableHeadingColor">
          <td colspan="2">
            <font size="+2">
              <b>Group Summary</b>
            </font>
          </td>
        </tr>
        <xsl:apply-templates select="doc:component[@type = 'group']" mode="doc-index">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
      </table>
    </xsl:if>
    <xsl:if test="$hideGroups = 'false' and doc:component[@type = 'attributeGroup']">
      <p>
        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
      </p>
      <table border="1" width="100%" cellpadding="3" cellspacing="0" summary="">
        <tr bgcolor="#CCCCFF" class="TableHeadingColor">
          <td colspan="2">
            <font size="+2">
              <b>Attribute Group Summary</b>
            </font>
          </td>
        </tr>
        <xsl:apply-templates select="doc:component[@type = 'attributeGroup']" mode="doc-index">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
      </table>
    </xsl:if>
    <hr/>
    <a name="description"/>
    <h3>
      <xsl:text>Schema </xsl:text>
      <xsl:value-of select="@targetNamespace"/>
      <xsl:text> Description</xsl:text>
    </h3>
    <dl>
      <dt>Form</dt>
      <dd>
        <p>
          <xsl:choose>
            <xsl:when test="normalize-space(@elementFormDefault)='qualified'">
              <xsl:text>By default, local element declarations belong to this schema's target namespace.</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>By default, local element declarations have no namespace.</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </p>
        <p>
          <xsl:choose>
            <xsl:when test="normalize-space(@attributeFormDefault)='qualified'">
              <xsl:text>By default, local attribute declarations belong to this schema's target namespace.</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>By default, local attribute declarations have no namespace.</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </p>
      </dd>
    </dl>
    <xsl:if test="doc:documentation">
      <xsl:call-template name="documentation"/>
    </xsl:if>
  </xsl:template>
  <!--
    Create an index table entry on schema index pages.
  -->
  <xsl:template match="*" mode="doc-index">
    <tr bgcolor="white" class="TableRowColor">
      <td width="15%">
        <b>
          <a href="{@href}" target="content">
            <xsl:value-of select="@name"/>
          </a>
        </b>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="doc:documentation">
            <xsl:apply-templates select="doc:documentation" mode="short-documentation"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
  </xsl:template>
  <!--
    Template for the xsddoc element, the root element of schema component
    descriptions.
  -->
  <xsl:template match="doc:xsddoc">
    <html>
      <xsl:call-template name="xsddocComment"/>
      <head>
        <title>
          <xsl:value-of select="doc:component/@namespace"/>
        </title>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
        <link rel="stylesheet" type="text/css" href="../../stylesheet.css" title="Style"/>
      </head>
      <body>
        <xsl:call-template name="navigationComponent"/>
        <h2>
          <span class="smal">
            <xsl:value-of select="doc:component/@namespace"/>
          </span>
          <br/>
          <xsl:value-of select="doc:component/@type"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="doc:component/@name"/>
        </h2>
        <xsl:apply-templates select="doc:component/doc:superTypes"/>
        <xsl:if test="doc:component/doc:documentation">
          <xsl:for-each select="doc:component">
            <xsl:call-template name="documentation"/>
          </xsl:for-each>
        </xsl:if>
        <xsl:if test="doc:component/doc:error">
          <xsl:text>An error occured:</xsl:text>
          <br/>
          <pre>
            <xsl:apply-templates select="doc:component/doc:error/text()"/>
          </pre>
        </xsl:if>
        <dl>
          <dt>Properties</dt>
          <dd>
            <xsl:choose>
              <xsl:when test="@nillable = 'true'">
                <xsl:text>This component is nillable.</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>This component is not nillable.</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
                <br/>
            <xsl:if test="@abstract = 'true'">
              <xsl:text>This component is abstract.</xsl:text>
              <br/>
            </xsl:if>
            <xsl:if test="string(@final) != ''">
              <xsl:text>This component is final by: </xsl:text>
              <xsl:value-of select="@final"/>
              <xsl:text>.</xsl:text>
              <br/>
            </xsl:if>
            <xsl:if test="string(@block) != ''">
              <xsl:text>This component is blocked from derivation by: </xsl:text>
              <xsl:value-of select="@block"/>
              <xsl:text>.</xsl:text>
              <br/>
            </xsl:if>
            <xsl:if test="@mixed = 'true'">
              <xsl:text>This component allowes mixed content.</xsl:text>
              <br/>
            </xsl:if>
            <xsl:if test="@mixed = 'false'">
              <xsl:text>This component doesn't allow mixed content.</xsl:text>
              <br/>
            </xsl:if>
            <xsl:if test="@substitutionGroup">
              <xsl:text>This element is a substitution group for type </xsl:text>
              <tt>
                <xsl:choose>
                  <xsl:when test="@substitutionGroupHref">
                    <a href="{@substitutionGroupHref}"><xsl:value-of select="@substitutionGroup"/></a>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="@substitutionGroup"/>
                  </xsl:otherwise>
                </xsl:choose>
                </tt>
              <xsl:text>.</xsl:text>
              <br/>
            </xsl:if>
          </dd>
        </dl>
        <hr/>
        <xsl:apply-templates select="doc:component/doc:model"/>
        <xsl:apply-templates select="doc:component/doc:subTypes"/>
        <xsl:apply-templates select="doc:component/doc:implementors"/>
        <xsl:apply-templates select="doc:component/doc:typeReference"/>
        <xsl:apply-templates select="doc:component/doc:source"/>
        <hr/>
        <xsl:call-template name="navigationComponent"/>
        <xsl:call-template name="bottom"/>
      </body>
    </html>
  </xsl:template>
  <!--
    Format super types.
  -->
  <xsl:template match="doc:superTypes">
    <xsl:if test="doc:type">
      <dl>
        <dt>Super Types</dt>
      </dl>
      <pre>
        <xsl:call-template name="superType">
          <xsl:with-param name="types" select="*"/>
        </xsl:call-template>
      </pre>
      <hr/>
    </xsl:if>
  </xsl:template>
  <!--
    Recursive format super types.
  -->
  <xsl:template name="superType">
    <xsl:param name="types"/>
    <xsl:param name="indent" select="string('')"/>
    <xsl:for-each select="$types[position() = 1]">
      <xsl:if test="$indent">
        <xsl:value-of select="$indent"/>
        <xsl:text>+--</xsl:text>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="count($types) &gt; 1">
          <xsl:choose>
            <xsl:when test="@href">
              <a href="{@href}">
                <xsl:value-of select="concat('{', @namespace, '}', @name)"/>
              </a>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat('{', @namespace, '}', @name)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <b>
            <xsl:value-of select="concat('{', @namespace, '}', @name)"/>
          </b>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="@derivation">
        <xsl:text> (</xsl:text>
        <xsl:value-of select="@derivation"/>
        <xsl:text>)</xsl:text>
      </xsl:if>
      <br/>
    </xsl:for-each>
    <xsl:if test="count($types) &gt; 1">
      <xsl:variable name="newIndent">
        <xsl:choose>
          <xsl:when test="$indent">
            <xsl:value-of select="concat($indent, '     ')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat($indent, '  ')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test="$newIndent">
        <xsl:value-of select="$newIndent"/>
        <xsl:text>|</xsl:text>
        <br/>
      </xsl:if>
      <xsl:call-template name="superType">
        <xsl:with-param name="types" select="$types[position() &gt; 1]"/>
        <xsl:with-param name="indent" select="$newIndent"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <!--
    Format sub types.
  -->
  <xsl:template match="doc:subTypes">
    <xsl:if test="doc:type/*">
      <dl>
        <dt>Sub Types</dt>
      </dl>
      <pre>
        <xsl:apply-templates select="doc:type" mode="subType"/>
      </pre>
      <hr/>
    </xsl:if>
  </xsl:template>
  <!--
    Format sub types.
    todo: sort
  -->
  <xsl:template match="doc:type" mode="subType">
    <xsl:param name="indentBlk" select="string('')"/>
    <xsl:param name="indentTyp" select="string('')"/>
    <xsl:param name="indentSep" select="string('')"/>
    <xsl:if test="$indentBlk">
      <xsl:value-of select="$indentBlk"/>
      <br/>
    </xsl:if>
    <xsl:value-of select="$indentTyp"/>
    <xsl:choose>
      <xsl:when test="@href">
        <a href="{@href}">
          <xsl:value-of select="concat('{', @namespace, '}', @name)"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('{', @namespace, '}', @name)"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="@derivation">
      <xsl:text> (</xsl:text>
      <xsl:value-of select="@derivation"/>
      <xsl:text>)</xsl:text>
    </xsl:if>
    <br/>
    <xsl:if test="doc:type">
      <xsl:for-each select="doc:type">
        <xsl:sort select="@name"/>
        <xsl:apply-templates select="." mode="subType">
          <xsl:with-param name="indentBlk" select="concat($indentSep, '  |  ')"/>
          <xsl:with-param name="indentTyp">
            <xsl:choose>
              <xsl:when test="count(../*) &gt; position()">
                <xsl:value-of select="concat($indentSep, '  +--')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat($indentSep, '  +--')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="indentSep">
            <xsl:choose>
              <xsl:when test="count(../*) &gt; position()">
                <xsl:value-of select="concat($indentSep, '  |  ')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat($indentSep, '     ')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:apply-templates>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <!--
    Format implementors reference.
    todo: sort
  -->
  <xsl:template match="doc:implementors">
    <xsl:if test="doc:type">
      <dl>
        <dt>Implementors</dt>
        <dd>
          <xsl:apply-templates select="doc:type" mode="typeList"/>
        </dd>
      </dl>
      <hr/>
    </xsl:if>
  </xsl:template>
  <!--
    Format implementors reference.
    todo: sort
  -->
  <xsl:template match="doc:typeReference">
    <xsl:if test="doc:type">
      <dl>
        <dt>Local Usage</dt>
        <dd>
          <xsl:apply-templates select="doc:type" mode="typeList">
            <xsl:sort select="@name"/>
          </xsl:apply-templates>
        </dd>
      </dl>
      <hr/>
    </xsl:if>
  </xsl:template>
  <!--
    Format list of types.
  -->
  <xsl:template match="doc:type" mode="typeList">
    <xsl:if test="position() &gt; 1">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <a href="{@href}">
      <xsl:value-of select="@name"/>
    </a>
  </xsl:template>
  <!--
    Format documentation.
  -->
  <xsl:template name="documentation">
    <a name="documentation"/>
    <dl>
      <dt>Documentation</dt>
      <dd>
        <xsl:for-each select="doc:documentation">
          <xsl:choose>
            <xsl:when test="*">
              <xsl:apply-templates select="*|text()" mode="documentation"/>
            </xsl:when>
            <xsl:otherwise>
              <pre>
                <xsl:apply-templates select="*|text()" mode="documentation"/>
              </pre>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </dd>
    </dl>
    <xsl:if test="@source">
      <dl>
        <dt>See also</dt>
        <dd>
          <a href="{xs:annotation/xs:documentation/@source}" target="_blank">
            <xsl:value-of select="xs:annotation/xs:documentation/@source"/>
          </a>
        </dd>
      </dl>
    </xsl:if>
  </xsl:template>
  <!--
    Format schema source.
  -->
  <xsl:template match="xs:*" mode="doc">
    <xsl:apply-templates select="." mode="xmldoc">
      <xsl:with-param name="children" select="*[local-name() != 'annotation']"/>
    </xsl:apply-templates>
  </xsl:template>
  <!--
    Format content model.
  -->
  <xsl:template match="doc:model">
    <dl>
      <dt>Model</dt>
      <dd>
        <tt>
          <xsl:apply-templates select="." mode="model"/>
        </tt>
      </dd>
    </dl>
    <hr/>
    <xsl:variable name="nested" select="//doc:element"/>
    <xsl:if test="$nested">
      <br/>
      <a name="elements"/>
      <table border="1" cellpadding="3" cellspacing="0" width="100%">
        <tr bgcolor="#CCCCFF" class="TableHeadingColor">
          <td colspan="2">
            <font size="+2">
              <b>Nested Element Summary</b>
            </font>
          </td>
        </tr>
        <xsl:apply-templates select="$nested" mode="summary">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
      </table>
    </xsl:if>
    <xsl:if test="doc:attribute">
      <br/>
      <a name="attributes"/>
      <table border="1" cellpadding="3" cellspacing="0" width="100%">
        <tr bgcolor="#CCCCFF" class="TableHeadingColor">
          <td colspan="2">
            <font size="+2">
              <b>Attribute Summary</b>
            </font>
          </td>
        </tr>
        <xsl:apply-templates select="doc:attribute[not(@any)]" mode="summary">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
      </table>
    </xsl:if>
    <xsl:if test="doc:attribute">
      <br/>
      <table border="1" cellpadding="3" cellspacing="0" width="100%">
        <tr bgcolor="#CCCCFF" class="TableHeadingColor">
          <td colspan="2">
            <font size="+2">
              <b>Attribute Detail</b>
            </font>
          </td>
        </tr>
      </table>
      <xsl:apply-templates select="doc:attribute[not(@any)]" mode="detail">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>
  <!--
    Format the attribute model.
  -->
  <xsl:template match="doc:attribute" mode="detail">
    <a name="attr_{@name}"/>
    <h3>
      <xsl:value-of select="@name"/>
    </h3>
    <dl>
      <xsl:if test="doc:documentation">
        <dd>
          <xsl:apply-templates select="doc:documentation" mode="documentation"/>
        </dd>
        <br/>
      </xsl:if>
      <dl>
        <dt>Type:</dt>
        <dd>
          <xsl:choose>
            <xsl:when test="doc:simpleType">
              <xsl:text>based on </xsl:text>
              <code>
                <xsl:choose>
                  <xsl:when test="normalize-space(doc:*/doc:*/@href) != ''">
                    <a href="{doc:*/doc:*/@href}">
                      <xsl:value-of select="doc:*/doc:*/@base"/>
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="doc:*/doc:*/@base"/>
                  </xsl:otherwise>
                </xsl:choose>
              </code>
              <br/>
              <xsl:text>with </xsl:text>
              <xsl:value-of select="local-name(doc:*/doc:*)"/>
              <xsl:text>:</xsl:text>
              <br/>
              <xsl:apply-templates select="doc:*[local-name() != 'documentation']" mode="particle"/>
            </xsl:when>
            <xsl:when test="@href">
              <code>
                <a href="{@href}">
                  <xsl:value-of select="@type"/>
                </a>
              </code>
            </xsl:when>
            <xsl:when test="@type">
              <code>
                <xsl:value-of select="@type"/>
              </code>
            </xsl:when>
            <xsl:when test="doc:*">
              <xsl:apply-templates select="doc:*[local-name() != 'documentation']" mode="particle"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@type"/>
            </xsl:otherwise>
          </xsl:choose>
        </dd>
      </dl>
      <xsl:if test="string(@default) != ''">
        <dl>
          <dt>Default:</dt>
          <dd>
            <code>
              <xsl:value-of select="@default"/>
            </code>
          </dd>
        </dl>
      </xsl:if>
      <xsl:if test="string(@fixed) != ''">
        <dl>
          <dt>Fixed:</dt>
          <dd>
            <code>
              <xsl:value-of select="@fixed"/>
            </code>
          </dd>
        </dl>
      </xsl:if>
      <xsl:if test="string(@use) != ''">
        <dl>
          <dt>Use:</dt>
          <dd>
            <code>
              <xsl:value-of select="@use"/>
            </code>
          </dd>
        </dl>
      </xsl:if>
      <xsl:if test="string(@form) != ''">
        <dl>
          <dt>Form:</dt>
          <dd>
            <code>
              <xsl:value-of select="@form"/>
            </code>
          </dd>
        </dl>
      </xsl:if>
    </dl>
    <hr/>
  </xsl:template>
  <!--
    Format the attribute summary.
  -->
  <xsl:template match="doc:attribute" mode="summary">
    <tr bgcolor="white" class="TableRowColor">
      <td align="right" valign="top" width="1">
        <font size="-1">
          <code>
            <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
            <xsl:choose>
              <xsl:when test="@base">
                <i>
                  <xsl:value-of select="@base"/>
                </i>
              </xsl:when>
              <xsl:when test="@href">
                <a href="{@href}">
                  <xsl:value-of select="@type"/>
                </a>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@type"/>
              </xsl:otherwise>
            </xsl:choose>
          </code>
        </font>
      </td>
      <td>
        <code>
          <a href="#attr_{@name}">
            <xsl:value-of select="@name"/>
          </a>
        </code>
        <br/>
        <xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text>
        <xsl:apply-templates select="doc:*" mode="short-documentation"/>
      </td>
    </tr>
  </xsl:template>
  <!--
    Format the nested element summary.
  -->
  <xsl:template match="doc:element" mode="summary">
    <xsl:variable name="prefix" select="substring-before(@type, ':')"/>
    <xsl:variable name="ns" select="namespace::*[name() = $prefix]"/>
    <tr bgcolor="white" class="TableRowColor">
      <td align="right" valign="top" width="1">
        <font size="-1">
          <code>
            <xsl:choose>
              <xsl:when test="@type and ($ns = 'http://www.w3.org/2001/XMLSchema')">
                <xsl:value-of select="@type"/>
              </xsl:when>
              <xsl:when test="@type and @href">
                <a href="{@href}">
                  <xsl:value-of select="@type"/>
                </a>
              </xsl:when>
              <xsl:when test="@type">
                <xsl:value-of select="@type"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </code>
        </font>
      </td>
      <td>
        <code>
          <a href="{@href}">
            <xsl:value-of select="@name"/>
          </a>
        </code>
        <br/>
        <xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text>
        <xsl:apply-templates select="doc:*[position() = 1]" mode="short-documentation"/>
      </td>
    </tr>
  </xsl:template>
  <!--
    Format the nested element model.
  -->
  <xsl:template match="doc:element" mode="detail">
    <xsl:variable name="prefix" select="substring-before(@type, ':')"/>
    <xsl:variable name="ns" select="namespace::*[name() = $prefix]"/>
    <a name="elem_{@name}"/>
    <h3>
      <xsl:value-of select="@name"/>
    </h3>
    <dl>
      <xsl:if test="doc:documentation">
        <dd>
          <xsl:apply-templates select="doc:documentation" mode="documentation"/>
        </dd>
        <br/>
      </xsl:if>
      <xsl:if test="@type">
        <dl>
          <dt>Type:</dt>
          <dd>
            <code>
              <xsl:choose>
                <xsl:when test="@type and ($ns = 'http://www.w3.org/2001/XMLSchema')">
                  <xsl:value-of select="@type"/>
                </xsl:when>
                <xsl:when test="@type and @href">
                  <a href="{@href}">
                    <xsl:value-of select="@type"/>
                  </a>
                </xsl:when>
                <xsl:when test="@type">
                  <xsl:value-of select="@type"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </code>
          </dd>
        </dl>
      </xsl:if>
      <xsl:if test="@href">
        <dl>
          <dt>Details:</dt>
          <dd>
              <a href="{@href}">
                <xsl:value-of select="@name"/>
              </a>
          </dd>
        </dl>
      </xsl:if>
    </dl>
    <hr/>
  </xsl:template>
  <!--
    Format the model.
  -->
  <xsl:template match="doc:model" mode="model">
    <xsl:choose>
      <xsl:when test="../@type = 'complexType'">
        <xsl:text>&lt;...</xsl:text>
      </xsl:when>
      <xsl:when test="../@type = 'element'">
        <xsl:text>&lt;</xsl:text>
        <xsl:value-of select="../@name"/>
      </xsl:when>
    </xsl:choose>
    <xsl:apply-templates select="doc:attribute[@name] | doc:simpleContent/doc:*/doc:attribute | doc:simpleContent/doc:*/doc:attributeGroup" mode="particle">
      <xsl:with-param name="indent" select="string('  ')"/>
      <xsl:sort select="@name"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="doc:attribute[@any]" mode="particle">
      <xsl:with-param name="indent" select="string('  ')"/>
      <xsl:sort select="@any"/>
    </xsl:apply-templates>
    <xsl:if test="../@type = 'complexType' or ../@type = 'element'">
      <xsl:text>></xsl:text>
    </xsl:if>
    <br/>
    <xsl:apply-templates select="doc:sequence | doc:element | doc:choice | doc:all | doc:restriction | doc:list | doc:union | doc:type" mode="particle">
      <xsl:with-param name="indent" select="string('  ')"/>
    </xsl:apply-templates>
    <br/>
    <xsl:choose>
      <xsl:when test="../@type = 'complexType'">
        <xsl:value-of select="string('&lt;/...&gt;')"/>
      </xsl:when>
      <xsl:when test="../@type = 'element'">
        <xsl:value-of select="concat('&lt;/', ../@name, '&gt;')"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!--
    Format model of local elements.
  -->
  <xsl:template match="doc:element" mode="model">
    <a name="model_{@name}"/>
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:apply-templates select="doc:attribute[@name] | doc:simpleContent/doc:*/doc:attribute | doc:simpleContent/doc:*/doc:attributeGroup" mode="particle">
      <xsl:with-param name="indent" select="string('  ')"/>
      <xsl:sort select="@name"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="doc:attribute[@any]" mode="particle">
      <xsl:with-param name="indent" select="string('  ')"/>
      <xsl:sort select="@any"/>
    </xsl:apply-templates>
    <xsl:text>></xsl:text>
    <br/>
    <xsl:apply-templates select="doc:sequence | doc:element | doc:choice | doc:all | doc:restriction | doc:list | doc:union | doc:type" mode="particle">
      <xsl:with-param name="indent" select="string('  ')"/>
    </xsl:apply-templates>
    <br/>
    <xsl:value-of select="concat('&lt;/', @name, '&gt;')"/>
    <br/>
    <br/>
  </xsl:template>
  <!--
    Format attributes
  -->
  <xsl:template match="doc:attribute" mode="particle">
    <br/>
    <xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;</xsl:text>
    <xsl:choose>
      <xsl:when test="@type">
        <xsl:choose>
          <xsl:when test="@use = 'required'">
            <b>
              <xsl:apply-templates select="." mode="model-doc"/>
            </b>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="." mode="model-doc"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="doc:simpleType">
        <xsl:choose>
          <xsl:when test="@use = 'required'">
            <b>
              <xsl:apply-templates select="." mode="model-doc"/>
            </b>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="." mode="model-doc"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <i>
          <xsl:text>{</xsl:text>
          <xsl:value-of select="@any"/>
          <xsl:text>}</xsl:text>
        </i>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--
    Format attribute model.
  -->
  <xsl:template match="doc:attribute" mode="model-doc">
    <a href="#attr_{@name}">
      <xsl:value-of select="@name"/>
    </a>
    <xsl:text> = </xsl:text>
    <xsl:variable name="typeName">
      <xsl:choose>
        <xsl:when test="string(@type) != ''">
          <xsl:value-of select="@type"/>
        </xsl:when>
        <xsl:when test="string(@base) != ''">
          <xsl:value-of select="@base"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="doc:simpleType" mode="particle"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@base">
        <i>
          <xsl:value-of select="@base"/>
        </i>
      </xsl:when>
      <xsl:when test="@href">
        <a href="{@href}">
          <xsl:value-of select="$typeName"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$typeName"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="string(@default) != ''">
      <xsl:text> : </xsl:text>
      <xsl:value-of select="@default"/>
    </xsl:if>
  </xsl:template>
  <!--
    Ignore documentation inside of compositors.
  -->
  <xsl:template match="doc:documentation" mode="particle">
  </xsl:template>
  <!--
    Format simpleType model.
  -->
  <xsl:template match="doc:simpleType" mode="model-doc">
    <xsl:apply-templates select="doc:*" mode="model"/>
  </xsl:template>
  <!--
    Format sequence or group model.
  -->
  <xsl:template match="doc:sequence | doc:group" mode="particle">
    <xsl:param name="indent" select="string('')"/>
    <xsl:variable name="count" select="count(*[local-name() != 'documentation'])"/>
    <xsl:value-of select="$indent"/>
    <xsl:if test="$count &gt; 1">
      <xsl:text>(</xsl:text>
    </xsl:if>
    <xsl:for-each select="*">
      <xsl:apply-templates select="." mode="particle"/>
      <xsl:if test="position() &lt; $count">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:value-of select="$indent"/>
    <xsl:if test="$count &gt; 1">
      <xsl:text>)</xsl:text>
    </xsl:if>
    <xsl:value-of select="@occurs"/>
  </xsl:template>
  <!--
    Format choice model.
  -->
  <xsl:template match="doc:choice" mode="particle">
    <xsl:param name="indent" select="string('')"/>
    <xsl:variable name="count" select="count(*[local-name() != 'documentation'])"/>
    <xsl:value-of select="$indent"/>
    <xsl:if test="$count &gt; 1">
      <xsl:text>(</xsl:text>
    </xsl:if>
    <xsl:for-each select="*">
      <xsl:apply-templates select="." mode="particle"/>
      <xsl:if test="position() &lt; $count">
        <xsl:text> | </xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:if test="$count &gt; 1">
      <xsl:text>)</xsl:text>
    </xsl:if>
    <xsl:value-of select="@occurs"/>
    <xsl:text> </xsl:text>
  </xsl:template>
  <!--
    Format all model.
  -->
  <xsl:template match="doc:all" mode="particle">
    <xsl:param name="indent" select="string('')"/>
    <xsl:variable name="count" select="count(*[local-name() != 'documentation'])"/>
    <xsl:value-of select="$indent"/>
    <xsl:if test="$count &gt; 1">
      <xsl:text>(</xsl:text>
    </xsl:if>
    <xsl:for-each select="*">
      <xsl:apply-templates select="." mode="particle"/>
      <xsl:if test="position() &lt; $count">
        <xsl:text> ; </xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:if test="$count &gt; 1">
      <xsl:text>)</xsl:text>
    </xsl:if>
    <xsl:value-of select="@occurs"/>
    <xsl:text> </xsl:text>
  </xsl:template>
  <!--
    Format any model.
  -->
  <xsl:template match="doc:any" mode="particle">
    <xsl:param name="indent" select="string('')"/>
    <xsl:value-of select="$indent"/>
    <xsl:text>(</xsl:text>
    <i>
      <xsl:text>any element from </xsl:text>
      <xsl:choose>
        <!-- when the namespace is specified and the value is not ##any -->
        <xsl:when test="@namespace and not(@namespace = '##any') and not(@namespace = '')">
          <xsl:choose>
            <xsl:when test="@namespace = '##other'">
              <xsl:text>any other namespace</xsl:text>
            </xsl:when>
            <xsl:when test="@namespace = '##targetNamespace' or @namespace='##local'">
              <xsl:text>local namespace </xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>namespace </xsl:text>
              <xsl:value-of select="@namespace"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <!-- Either the namespace is not specified or its value is ##any -->
        <xsl:otherwise>
          <xsl:text>any namespace</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </i>
    <xsl:text>)</xsl:text>
    <xsl:value-of select="@occurs"/>
  </xsl:template>
  <!--
    Format element particles.
  -->
  <xsl:template match="doc:element | doc:type" mode="particle">
    <xsl:param name="separator" select="string(',')"/>
    <xsl:param name="indent" select="string('')"/>
    <xsl:param name="count"/>
    <xsl:choose>
      <xsl:when test="@name">
        <a href="{concat('#elem_', @name)}">
          <xsl:value-of select="@name"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@name"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="@occurs"/>
  </xsl:template>
  <!--
    Format complexType particles.
  -->
  <xsl:template match="doc:complexType" mode="particle">
    <xsl:text>...</xsl:text>
  </xsl:template>
  <!--
    simple type restriction documentation.
  -->
  <xsl:template match="doc:restriction" mode="particle">
    <xsl:if test="doc:enumeration">
      <xsl:choose>
        <xsl:when test="count(doc:enumeration) = 1">
          <xsl:text>'</xsl:text>
          <xsl:value-of select="doc:enumeration[position() = 1]/@value"/>
          <xsl:text>'</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>(</xsl:text>
          <xsl:text>'</xsl:text>
          <xsl:value-of select="doc:enumeration[position() = 1]/@value"/>
          <xsl:text>'</xsl:text>
          <xsl:if test="doc:enumeration[position() > 1]">
            <xsl:for-each select="doc:enumeration[position() > 1]">
              <xsl:text> | '</xsl:text>
              <xsl:value-of select="@value"/>
              <xsl:text>'</xsl:text>
            </xsl:for-each>
          </xsl:if>
          <xsl:text>)</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:if test="doc:pattern">
      <code>
        <xsl:value-of select="doc:pattern/@value"/>
      </code>
      <br/>
    </xsl:if>
    <xsl:if test="doc:totalDigits">
      <xsl:text>maximum number of digits: </xsl:text>
      <xsl:value-of select="doc:totalDigits/@value"/>
      <br/>
    </xsl:if>
    <xsl:if test="doc:length">
      <xsl:text>length: </xsl:text>
      <xsl:value-of select="doc:length/@value"/>
      <br/>
    </xsl:if>
    <xsl:if test="doc:minLength">
      <xsl:text>minimum length: </xsl:text>
      <xsl:value-of select="doc:minLength/@value"/>
      <br/>
    </xsl:if>
    <xsl:if test="doc:maxLength">
      <xsl:text>maximum length: </xsl:text>
      <xsl:value-of select="doc:maxLength/@value"/>
      <br/>
    </xsl:if>
    <xsl:if test="doc:whiteSpace">
      <xsl:text>attribute-value normalization: </xsl:text>
      <xsl:value-of select="doc:whiteSpace/@value"/>
      <br/>
    </xsl:if>
    <xsl:if test="doc:minExclusive">
      <xsl:text>exclusive lower bound: </xsl:text>
      <xsl:value-of select="doc:minExclusive/@value"/>
      <br/>
    </xsl:if>
    <xsl:if test="doc:maxExclusive">
      <xsl:text>exclusive upper bound: </xsl:text>
      <xsl:value-of select="doc:maxExclusive/@value"/>
      <br/>
    </xsl:if>
    <xsl:if test="doc:minInclusive">
      <xsl:text>inclusive lower bound: </xsl:text>
      <xsl:value-of select="doc:minInclusive/@value"/>
      <br/>
    </xsl:if>
    <xsl:if test="doc:maxInclusive">
      <xsl:text>inclusive upper bound: </xsl:text>
      <xsl:value-of select="doc:maxInclusive/@value"/>
      <br/>
    </xsl:if>
  </xsl:template>
  <!--
    simple type list documentation.
  -->
  <xsl:template match="doc:list" mode="particle">
    <xsl:text>List of </xsl:text>
    <xsl:choose>
      <xsl:when test="@itemType">
        <xsl:value-of select="@itemType"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="doc:simpleType/doc:*" mode="particle"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--
    simple type union documentation.
  -->
  <xsl:template match="doc:union" mode="particle">
    <xsl:text>(</xsl:text>
    <xsl:if test="@memberTypes">
      <xsl:value-of select="@memberTypes"/>
      <xsl:if test="doc:simpleType">
        <xsl:text> | </xsl:text>
      </xsl:if>
    </xsl:if>
    <xsl:apply-templates select="doc:simpleType[position() = 1]/doc:*" mode="particle"/>
    <xsl:for-each select="doc:simpleType[position() > 1]">
      <xsl:text> | </xsl:text>
      <xsl:apply-templates select="doc:*" mode="particle"/>
    </xsl:for-each>
    <xsl:text>)</xsl:text>
  </xsl:template>
  <!--
    Format documentation.
    If there is xhtml or other unknown XML inside, pass-thru this XML for later formatting.
    Else output as preformatted text with a <pre>pre</pre> tag.
  -->
  <xsl:template match="doc:documentation" mode="documentation">
    <xsl:if test="doc:documentation/@source">
      <xsl:attribute name="href"><xsl:value-of select="doc:documentation/@source"/></xsl:attribute>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="*|text()">
        <xsl:apply-templates select="*|text()"/>
      </xsl:when>
      <xsl:otherwise>
        <pre>
          <xsl:apply-templates select="*|text()"/>
        </pre>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--
  -->
  <xsl:template match="*" mode="documentation">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()|text()" mode="documentation"/>
    </xsl:copy>
  </xsl:template>
  <!--
  -->
  <xsl:template match="@*" mode="documentation">
    <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
  </xsl:template>
  <!--
  -->
  <xsl:template match="text()" mode="documentation">
    <xsl:value-of select="."/>
  </xsl:template>
  <!--
    Format doc:source.
  -->
  <xsl:template match="doc:source">
    <a name="source"/>
    <dl>
      <dt>Source</dt>
      <dd>
        <xsl:copy-of select="*"/>
      </dd>
    </dl>
  </xsl:template>
  <!--
    Format documentation as a short abstract (upto the first dot).
    If there is xhtml or other unknown XML inside, pass-thru this XML for later formatting.
    Else output as preformatted text with a <pre>pre</pre> tag.
  -->
  <xsl:template match="doc:documentation" mode="short-documentation">
    <xsl:call-template name="short-documentation">
      <xsl:with-param name="nodes" select="* | text()"/>
    </xsl:call-template>
    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
  </xsl:template>
  <!--
  -->
  <xsl:template name="short-documentation">
    <xsl:param name="nodes"/>
    <xsl:apply-templates select="$nodes[position() = 1]" mode="abstract">
      <xsl:with-param name="rest" select="$nodes[position() &gt; 1]"/>
    </xsl:apply-templates>
  </xsl:template>
  <!--
    Find and return all text upto the first dot.
  -->
  <xsl:template match="text()" mode="abstract">
    <xsl:param name="rest"/>
    <xsl:choose>
      <xsl:when test="contains(normalize-space(), '. ')">
        <xsl:value-of select="concat(substring-before(normalize-space(), '. '), '.')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="."/>
        <xsl:call-template name="short-documentation">
          <xsl:with-param name="nodes" select="$rest"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--
  -->
  <xsl:template match="*" mode="abstract">
    <xsl:param name="rest"/>
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="doc-attr"/>
      <xsl:call-template name="short-documentation">
        <xsl:with-param name="nodes" select="* | text()"/>
      </xsl:call-template>
      <xsl:choose>
        <xsl:when test="contains(., '.')">
                           </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="short-documentation">
            <xsl:with-param name="nodes" select="$rest"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
  <!--
  -->
  <xsl:template match="@*" mode="doc-attr">
    <xsl:attribute name="{name(.)}"><xsl:value-of select="."/></xsl:attribute>
  </xsl:template>
  <!--
    Navigation bar placed on top and bottom of overview page.
  -->
  <xsl:template name="navigationOverview">
    <xsl:call-template name="navigationHandler">
      <xsl:with-param name="rootFolder" select="'./'"/>
      <xsl:with-param name="namespaceFolder" select="/xs:schema/@targetNamespace"/>
      <xsl:with-param name="selected" select="'overview'"/>
    </xsl:call-template>
  </xsl:template>
  <!--
    Navigation bar placed on top and bottom of namespace page.
  -->
  <xsl:template name="navigationNamespace">
    <xsl:call-template name="navigationHandler">
      <xsl:with-param name="rootFolder" select="'../'"/>
      <xsl:with-param name="namespaceFolder" select="'./'"/>
      <xsl:with-param name="selected" select="'namespace'"/>
    </xsl:call-template>
  </xsl:template>
  <!--
    Navigation bar placed on top and bottom of component pages.
  -->
  <xsl:template name="navigationComponent">
    <xsl:call-template name="navigationHandler">
      <xsl:with-param name="rootFolder" select="'../../'"/>
      <xsl:with-param name="namespaceFolder" select="'../'"/>
      <xsl:with-param name="selected" select="'component'"/>
    </xsl:call-template>
  </xsl:template>
  <!--
    Navigation bar placed on top and bottom of index-all pages.
  -->
  <xsl:template name="navigationIndex">
    <xsl:call-template name="navigationHandler">
      <xsl:with-param name="rootFolder" select="'./'"/>
      <xsl:with-param name="namespaceFolder" select="'./'"/>
      <xsl:with-param name="selected" select="'index'"/>
    </xsl:call-template>
  </xsl:template>
  <!--
    Navigation bar placed on top and bottom of component pages.
  -->
  <xsl:template name="navigationHelp">
    <xsl:call-template name="navigationHandler">
      <xsl:with-param name="rootFolder" select="'./'"/>
      <xsl:with-param name="namespaceFolder" select="'./'"/>
      <xsl:with-param name="selected" select="'help'"/>
    </xsl:call-template>
  </xsl:template>
  <!--
    Navigation bar placed on top and bottom of page.
  -->
  <xsl:template name="navigationHandler">
    <xsl:param name="rootFolder" select="'../../'"/>
    <xsl:param name="namespaceFolder" select="'../'"/>
    <xsl:param name="selected" select="'overview'"/>
    <table width="100%" border="0" cellspacing="0" cellpadding="3">
      <tr>
        <td colspan="2" width="70%" class="NavBarCell1">
          <table border="0" cellpadding="0" cellspacing="3">
            <tr align="center" valign="top">
              <!-- Overview -->
              <td bgcolor="#EEEEFF">
                <xsl:choose>
                  <xsl:when test="starts-with($selected, 'overview')">
                    <xsl:attribute name="class">NavBarCell1Rev</xsl:attribute>
                    <font>
                      <xsl:choose>
                        <xsl:when test="starts-with($selected, 'overview')">
                          <xsl:attribute name="class">NavBarFont1Rev</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:attribute name="class">NavBarFont1</xsl:attribute>
                        </xsl:otherwise>
                      </xsl:choose>
                      <b>Overview</b>
                    </font>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="class">NavBarCell1</xsl:attribute>
                    <a href="{concat($rootFolder, 'schema-summary.html')}">
                      <font>
                        <xsl:choose>
                          <xsl:when test="starts-with($selected, 'overview')">
                            <xsl:attribute name="class">NavBarFont1Rev</xsl:attribute>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">NavBarFont1</xsl:attribute>
                          </xsl:otherwise>
                        </xsl:choose>
                        <b>Overview</b>
                      </font>
                    </a>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
              </td>
              <!-- Namespace -->
              <td bgcolor="#EEEEFF">
                <xsl:choose>
                  <xsl:when test="starts-with($selected, 'overview')">
                    <xsl:attribute name="class">NavBarCell1</xsl:attribute>
                    <font class="NavBarFont1">Namespace</font>
                  </xsl:when>
                  <xsl:when test="starts-with($selected, 'namespace')">
                    <xsl:attribute name="class">NavBarCell1Rev</xsl:attribute>
                    <font>
                      <xsl:attribute name="class">NavBarFont1Rev</xsl:attribute>
                      <b>Namespace</b>
                    </font>
                  </xsl:when>
                  <xsl:when test="starts-with($selected, 'component')">
                    <xsl:attribute name="class">NavBarCell1</xsl:attribute>
                    <a href="{concat($namespaceFolder, 'index.html')}">
                      <font>
                        <xsl:attribute name="class">NavBarFont1</xsl:attribute>
                        <b>Namespace</b>
                      </font>
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="class">NavBarCell1</xsl:attribute>
                    <font>
                      <xsl:attribute name="class">NavBarFont1</xsl:attribute>
                      <xsl:text>Namespace</xsl:text>
                    </font>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
              </td>
              <!-- Component -->
              <td bgcolor="#EEEEFF" class="NavBarCell1">
                <xsl:choose>
                  <xsl:when test="starts-with($selected, 'component')">
                    <xsl:attribute name="class">NavBarCell1Rev</xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="class">NavBarCell1</xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
                <font>
                  <xsl:choose>
                    <xsl:when test="starts-with($selected, 'component')">
                      <xsl:attribute name="class">NavBarFont1Rev</xsl:attribute>
                      <b>Component</b>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">NavBarFont1</xsl:attribute>
                      <xsl:text>Component</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </font>
                <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
              </td>
              <!-- Use -->
              <!--
              <td bgcolor="#EEEEFF" class="NavBarCell1">
                <font class="NavBarFont1">Use</font>
                <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
              </td>
              <td bgcolor="#EEEEFF" class="NavBarCell1">
                <a href="{'../namespace-tree.html'}">
                  <font class="NavBarFont1">
                    <b>Tree</b>
                  </font>
                </a>
                <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
              </td>
              <td bgcolor="#EEEEFF" class="NavBarCell1">
                <a href="{'../../index.html'}">
                  <font class="NavBarFont1">
                    <b>Index</b>
                  </font>
                </a>
                <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
              </td>
-->
              <!-- Index -->
              <td bgcolor="#EEEEFF">
                <xsl:choose>
                  <xsl:when test="starts-with($selected, 'index')">
                    <xsl:attribute name="class">NavBarCell1Rev</xsl:attribute>
                    <font>
                      <xsl:choose>
                        <xsl:when test="starts-with($selected, 'index')">
                          <xsl:attribute name="class">NavBarFont1Rev</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:attribute name="class">NavBarFont1</xsl:attribute>
                        </xsl:otherwise>
                      </xsl:choose>
                      <b>Index</b>
                    </font>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="class">NavBarCell1</xsl:attribute>
                    <a href="{concat($rootFolder, 'index-all.html')}">
                      <font>
                        <xsl:choose>
                          <xsl:when test="starts-with($selected, 'index')">
                            <xsl:attribute name="class">NavBarFont1Rev</xsl:attribute>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">NavBarFont1</xsl:attribute>
                          </xsl:otherwise>
                        </xsl:choose>
                        <b>Index</b>
                      </font>
                    </a>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
              </td>
              <!-- Help -->
              <td bgcolor="#EEEEFF">
                <xsl:choose>
                  <xsl:when test="starts-with($selected, 'help')">
                    <xsl:attribute name="class">NavBarCell1Rev</xsl:attribute>
                    <font>
                      <xsl:choose>
                        <xsl:when test="starts-with($selected, 'help')">
                          <xsl:attribute name="class">NavBarFont1Rev</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:attribute name="class">NavBarFont1</xsl:attribute>
                        </xsl:otherwise>
                      </xsl:choose>
                      <b>Help</b>
                    </font>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="class">NavBarCell1</xsl:attribute>
                    <a href="{concat($rootFolder, 'help-doc.html')}">
                      <font>
                        <xsl:choose>
                          <xsl:when test="starts-with($selected, 'help')">
                            <xsl:attribute name="class">NavBarFont1Rev</xsl:attribute>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">NavBarFont1</xsl:attribute>
                          </xsl:otherwise>
                        </xsl:choose>
                        <b>Help</b>
                      </font>
                    </a>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
              </td>
            </tr>
          </table>
        </td>
        <td align="right" valign="top" rowspan="3">
          <em>
            <b>
              <xsl:value-of disable-output-escaping="yes" select="$header"/>
            </b>
          </em>
        </td>
      </tr>
      <tr>
        <td class="NavBarCell2">
          <font size="-2">
            <xsl:text disable-output-escaping="yes">DETAILS:&amp;nbsp;</xsl:text>
            <xsl:if test="string($selected) = 'namespace' or string($selected) = 'component'">
              <a href="#documentation">
                <b>DOCUMENTATION</b>
              </a>
              <xsl:text disable-output-escaping="yes">&amp;nbsp;|&amp;nbsp;</xsl:text>
            </xsl:if>
            <xsl:if test="string($selected) = 'component'">
              <a href="#elements">
                <b>ELEMENTS</b>
              </a>
              <xsl:text disable-output-escaping="yes">&amp;nbsp;|&amp;nbsp;</xsl:text>
              <a href="#attributes">
                <b>ATTRIBUTES</b>
              </a>
              <xsl:text disable-output-escaping="yes">&amp;nbsp;|&amp;nbsp;</xsl:text>
              <a href="#source">
                <b>SOURCE</b>
              </a>
            </xsl:if>
          </font>
        </td>
        <td class="NavBarCell2">
          <font size="-2">
            <a href="{concat($rootFolder, 'index.html')}" target="_top">
              <b>FRAMES</b>
            </a><xsl:text disable-output-escaping="yes">&amp;nbsp;|&amp;nbsp;</xsl:text><a href="#" target="_top">
              <b>NO<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>FRAMES</b>
            </a>
          </font>
        </td>
      </tr>
    </table>
    <hr/>
  </xsl:template>
  <!--
    Default bottom.
  -->
  <xsl:template name="bottom">
    <xsl:choose>
      <xsl:when test="string($bottom) != ''">
        <font size="-1">
          <xsl:value-of disable-output-escaping="yes" select="$bottom"/>
        </font>
      </xsl:when>
      <xsl:otherwise>
        <font size="-1">
          <xsl:text>Submit a </xsl:text>
          <a target="_blank">
            <xsl:attribute name="href"><xsl:text disable-output-escaping="yes">http://sourceforge.net/tracker/?atid=454391&amp;amp;group_id=48863&amp;amp;func=browse</xsl:text></xsl:attribute>
            <xsl:text>bug</xsl:text>
          </a>
          <xsl:text> or a </xsl:text>
          <a target="_blank">
            <xsl:attribute name="href"><xsl:text disable-output-escaping="yes">http://sourceforge.net/tracker/?atid=454394&amp;amp;group_id=48863&amp;amp;func=browse</xsl:text></xsl:attribute>
            <xsl:text>feature</xsl:text>
          </a>
          <xsl:text>.</xsl:text>
          <br/>
          <xsl:text>Created by </xsl:text>
          <a target="_blank" href="http://xframe.sourceforge.net/xsddoc.html">xsddoc</a>
          <xsl:text>, a sub project of </xsl:text>
          <a href="http://xframe.sourceforge.net" target="_blank">xframe</a>
          <xsl:text>, hosted at </xsl:text>
          <a href="http://xframe.sourceforge.net" target="_blank">http://xframe.sourceforge.net</a>
          <xsl:text>.</xsl:text>
        </font>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="doc:help">
    <html>
      <xsl:call-template name="xsddocComment"/>
      <head>
        <title>Namespaces Overview</title>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
        <link rel="stylesheet" type="text/css" href="./stylesheet.css" title="Style"/>
      </head>
      <body>
        <xsl:call-template name="navigationHelp"/>
        <center>
          <h1>How This Namespace Documentation Is Organized</h1>
        </center>
        <h3>Overview</h3>
        <blockquote>
          <p>The Overview page is the front page of this XML-Schema
        document and provides a list of all namespaces with a summary for each.
        This page can also contain an overall description of the set of
        Namespaces.</p>
        </blockquote>
        <h3>Namespace</h3>
        <blockquote>
          <p>Each Namespace has a page that contains a list of its
        components, with a summary for each. This page can contain six
        categories:
        <ul>
              <li>Elements</li>
              <li>Attributes</li>
              <li>Complex Types</li>
              <li>simpleTypes</li>
              <li>Groups</li>
              <li>Attribute Groups</li>
            </ul>
          </p>
        </blockquote>
        <h3>Model in Element and ComplexType</h3>
        <blockquote>
          <p>Each Element and complexType has a model documentation
        where required attributes are marked bold, where the type of the
        attribute appears after the equal sign and where the (optional)
        default value is written after a colon.</p>
        </blockquote>
        <br/>
        <hr/>
        <xsl:call-template name="navigationHelp"/>
        <xsl:call-template name="bottom"/>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
