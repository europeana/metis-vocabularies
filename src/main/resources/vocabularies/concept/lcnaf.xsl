<?xml version="1.0" encoding="UTF-8"?>
<!--
  Document   : lcnaf.xsl
  Author     : DPS team
  Created on : March 10, 2022
  Updated on : May 7, 2024
  Version    : v1.1

changes:
* updated mapping for skos:prefLabel (madsrdf:authoritativeLabel with "En" language value is used instead of skos:preflabel)
* mapping of skos:altLabel has been excluded
* added condition for processing skos:closeMatch (Wikidata URIs are promoted from closeMatch to exactMatch)
-->

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#" version="1.0"
  xmlns:skosxl="http://www.w3.org/2008/05/skos-xl#"
  xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#">

  <xsl:param name="targetId" />
  <xsl:output indent="yes" encoding="UTF-8" />

  <!-- Main template -->
  <xsl:template match="/rdf:RDF">

    <!-- Parent mapping: * -> skos:Concept -->
    <xsl:for-each select="./*">
      <xsl:if test="@rdf:about=$targetId">
        <skos:Concept>
          <!-- Attribute mapping: rdf:about -> rdf:about -->
          <xsl:copy-of select="@rdf:about" />
          <!-- Tag mapping: madsrdf:authoritativeLabel -> skos:prefLabel -->
          <xsl:apply-templates select="./madsrdf:authoritativeLabel" />
          <!-- Tag mapping: skos:note -> skos:note -->
          <xsl:apply-templates select="./skos:note" mode="copy_literal" />
          <!-- Tag mapping: skos:broader -> skos:broader -->
          <xsl:apply-templates select="./skos:broader" mode="copy_resource" />
          <!-- Tag mapping: skos:narrower -> skos:narrower -->
          <xsl:apply-templates select="./skos:narrower" mode="copy_resource" />
          <!-- Tag mapping: skos:related -> skos:related -->
          <xsl:apply-templates select="./skos:related" mode="copy_resource" />
          <!-- Tag mapping: skos:broadMatch -> skos:broadMatch -->
          <xsl:apply-templates select="./skos:broadMatch" mode="copy_resource" />
          <!-- Tag mapping: skos:narrowMatch -> skos:narrowMatch -->
          <xsl:apply-templates select="./skos:narrowMatch" mode="copy_resource" />
          <!-- Tag mapping: skos:relatedMatch -> skos:relatedMatch -->
          <xsl:apply-templates select="./skos:relatedMatch" mode="copy_resource" />
          <!-- Tag mapping: skos:exactMatch -> skos:exactMatch -->
          <xsl:apply-templates select="./skos:exactMatch" mode="copy_resource" />
          <!-- Tag mapping: skos:closeMatch -> skos:closeMatch or skos:exactMatch for Wikidata URIs -->
          <xsl:apply-templates select="./skos:closeMatch" />
          <!-- Tag mapping: skos:inScheme -> skos:inScheme -->
          <xsl:apply-templates select="./skos:inScheme" mode="copy_resource" />
        </skos:Concept>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- Template for madsrdf:authoritativeLabel -> skos:prefLabel -->
  <xsl:template match="madsrdf:authoritativeLabel">
    <xsl:element name="skos:prefLabel">
      <xsl:attribute name="xml:lang">
        <xsl:text>en</xsl:text>
      </xsl:attribute>
      <xsl:copy-of select="text()" />
    </xsl:element>
  </xsl:template>

  <!-- Template for literals -->
  <xsl:template match="*" mode="copy_literal">
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <!-- Attribute mapping: xml:lang -> xml:lang -->
      <xsl:copy-of select="@xml:lang" />
      <!-- Text content mapping -->
      <xsl:copy-of
        select="text()" />
    </xsl:element>
  </xsl:template>

  <!-- Template for resources -->
  <xsl:template match="*" mode="copy_resource">
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:choose>
        <!-- Attribute mapping: rdf:resource -> rdf:resource -->
        <xsl:when test="@rdf:resource">
          <xsl:copy-of select="@rdf:resource" />
        </xsl:when>
        <!-- Attribute mapping: rdf:Description/rdf:about -> rdf:resource -->
        <xsl:otherwise>
          <xsl:attribute name="rdf:resource">
            <xsl:value-of select="rdf:Description/@rdf:about" />
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

  <!-- Template for skos:closeMatch -> skos:closeMatch or skos:exactMatch for Wikidata URIs -->
  <xsl:template match="skos:closeMatch">
    <xsl:choose>
      <xsl:when test="contains(rdf:Description/@rdf:about, 'www.wikidata.org/entity/')">
        <xsl:element name="skos:exactMatch">
          <xsl:attribute name="rdf:resource">
            <xsl:value-of select="rdf:Description/@rdf:about" />
          </xsl:attribute>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="skos:closeMatch">
          <xsl:attribute name="rdf:resource">
            <xsl:value-of select="rdf:Description/@rdf:about" />
          </xsl:attribute>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>