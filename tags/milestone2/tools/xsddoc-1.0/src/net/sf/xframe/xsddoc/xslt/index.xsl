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
  xmlns:xalan="http://xml.apache.org/xslt"
  exclude-result-prefixes="xs" version="1.0">
  <!--
    This transformation creates a frameset for the documentation
  -->
  <xsl:output indent="no" version="4.0" method="html" encoding="ISO-8859-1" xalan:indent-amount="2" omit-xml-declaration="yes" doctype-public="-//W3C//DTD HTML 4.01 Frameset//EN" doctype-system="http://www.w3.org/TR/html4/frameset.dtd"/>
  <!--
    Include xsddoc utilities templates.
  -->
  <xsl:include href="util.xsl"/>
  <!--
    The file name of the schema to extract from.
  -->
  <xsl:param name="schemaLocation" select="undefined"/>
  <!--
    Folder for current schema
  -->
  <xsl:variable name="nsFolder">
    <xsl:call-template name="namespaceFolder">
      <xsl:with-param name="uri" select="/xs:schema/@targetNamespace"/>
    </xsl:call-template>
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
    <html>
      <xsl:call-template name="xsddocComment"/>
      <head>
        <title>
          <xsl:text>Reference of Schema </xsl:text>
          <xsl:value-of select="/xs:schema/@targetNamespace"/>
        </title>
      </head>
      <frameset cols="20%,80%">
        <frameset rows="30%,70%">
          <frame name="namespaces" src="./overview-namespaces.html"/>
          <frame name="index" src="{concat('./', 'overview-all.html')}"/>
        </frameset>
        <frame name="content" src="./schema-summary.html"/>
      </frameset>
    </html>
  </xsl:template>
</xsl:stylesheet>
