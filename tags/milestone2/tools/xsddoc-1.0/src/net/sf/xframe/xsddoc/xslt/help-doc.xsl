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
    This transformation creates the help page of the schema
    documentation.
  -->
  <xsl:output indent="no" version="1.0" method="xml" encoding="ISO-8859-1" />
  <!--
    Root template.
  -->
  <xsl:template match="/">
    <doc:help/>
  </xsl:template>
</xsl:stylesheet>
