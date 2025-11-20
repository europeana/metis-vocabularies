<?xml version="1.0" encoding="UTF-8"?>
<!--
  Document   : CHT2EDM.xsl
  Author     : Masa
  Created on : July 2025
  Updated on : July 2025
  Version    : v1.0
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <xsl:param name="targetId"></xsl:param>
  <xsl:output indent="yes" encoding="UTF-8"></xsl:output>

  <!-- Main template -->
  <xsl:template match="/rdf:RDF">
    <xsl:for-each select="rdf:Description[@rdf:about=$targetId]">
      <!-- rdf:Description -> skos:Concept -->
      <skos:Concept>
        <!-- Attribute mapping: rdf:about -> rdf:about -->
        <xsl:copy-of select="@rdf:about" />
        <!-- Tag mapping: skos:prefLabel -> skos:prefLabel -->
        <xsl:for-each select="skos:prefLabel">
          <skos:prefLabel xml:lang="{@xml:lang}">
            <xsl:value-of select="."/>
          </skos:prefLabel>
        </xsl:for-each>
        <!-- Tag mapping: skos:altLabel -> skos:altLabel -->
        <xsl:for-each select="skos:altLabel">
          <skos:altLabel xml:lang="{@xml:lang}">
            <xsl:value-of select="."/>
          </skos:altLabel>
        </xsl:for-each>
        <!-- Tag mapping: skos:scopeNote -> skos:note -->
        <xsl:for-each select="skos:scopeNote">
          <skos:note xml:lang="{@xml:lang}">
            <xsl:value-of select="." />
          </skos:note>
        </xsl:for-each>
        <!-- Tag mapping: skos:broader -> skos:broader -->
        <xsl:for-each select="skos:broader">
          <skos:broader rdf:resource="{@rdf:resource}" />
        </xsl:for-each>
        <!-- Tag mapping: skos:narrower -> skos:narrower -->
        <xsl:for-each select="skos:narrower">
          <skos:narrower rdf:resource="{@rdf:resource}" />
        </xsl:for-each>
        <!-- Tag mapping: skos:related -> skos:related -->
        <xsl:for-each select="skos:related">
          <skos:related rdf:resource="{@rdf:resource}" />
        </xsl:for-each>
        <!-- Tag mapping: skos:broadMatch -> skos:broadMatch -->
        <xsl:for-each select="skos:broadMatch">
          <skos:broadMatch rdf:resource="{@rdf:resource}" />
        </xsl:for-each>
        <!-- Tag mapping: skos:narrowMatch -> skos:narrowMatch -->
        <xsl:for-each select="skos:narrowMatch">
          <skos:narrowMatch rdf:resource="{@rdf:resource}" />
        </xsl:for-each>
        <!-- Tag mapping: skos:relatedMatch -> skos:relatedMatch -->
        <xsl:for-each select="skos:relatedMatch">
          <skos:relatedMatch rdf:resource="{@rdf:resource}" />
        </xsl:for-each>
        <!-- Tag mapping: skos:closeMatch -> skos:closeMatch -->
        <xsl:for-each select="skos:closeMatch">
          <skos:closeMatch rdf:resource="{@rdf:resource}" />
        </xsl:for-each>
        <!-- Tag mapping: skos:exactMatch -> skos:exactMatch -->
        <xsl:for-each select="skos:exactMatch">
          <skos:exactMatch rdf:resource="{@rdf:resource}" />
        </xsl:for-each>
      </skos:Concept>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>