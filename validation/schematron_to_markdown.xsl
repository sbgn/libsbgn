<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:iso="http://purl.oclc.org/dsdl/schematron">

  <xsl:output method="text" omit-xml-declaration="yes" indent="no" encoding="utf-8" />
  <xsl:strip-space elements="*"/>

  <!-- Ignore these elements -->
  <xsl:template match="//iso:ns" />
  <xsl:template match="//iso:title" />
  <xsl:template match="//iso:phase" />

  <!-- Extract text -->
  <xsl:template match="//iso:assert">
    <xsl:text># </xsl:text><xsl:value-of select="@id" />
    <xsl:text>: </xsl:text><xsl:value-of select="@name" /><xsl:text>&#xa;</xsl:text>

    <xsl:text>* Role: </xsl:text><xsl:value-of select="@role" /><xsl:text>&#xa;</xsl:text>
    <xsl:text>* See: </xsl:text><xsl:value-of select="@see" /><xsl:text>&#xa;</xsl:text>
    <xsl:text>* Diagnostics: </xsl:text><xsl:value-of select="text()" />

    <xsl:text>&#xa;</xsl:text>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

</xsl:stylesheet>