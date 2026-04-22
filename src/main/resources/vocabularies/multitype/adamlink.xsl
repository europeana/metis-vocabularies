<?xml version="1.0" encoding="UTF-8"?>
<!--
  Document   : Adamlink2edm.xsl
  Author     : Masa
  Created on : February, 2026
  Updated on :
  Version    : v1.0
-->

<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:wgs84_pos="http://www.w3.org/2003/01/geo/wgs84_pos#"
  xmlns:geo="http://www.opengis.net/ont/geosparql#"
  xmlns:schema="https://schema.org/"
  xmlns:hg="http://rdf.histograph.io/"
  xmlns:edm="http://www.europeana.eu/schemas/edm/"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:gvp="http://vocab.getty.edu/ontology#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:lib="http://example.org/lib"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xsl gvp lib xs">
  <xsl:param name="targetId"></xsl:param>
  <xsl:output indent="yes" encoding="UTF-8"></xsl:output>
  <!-- Portal languages (28) -->
  <xsl:param name="langs">en,pl,de,nl,fr,it,da,sv,el,fi,hu,cs,sl,et,pt,es,lt,lv,bg,ro,sk,hr,ga,mt,no,ca,ru,eu</xsl:param>

  <!-- Main template -->
  <xsl:template match="rdf:RDF">
    <xsl:apply-templates select="hg:Street | hg:Building | schema:Person [@rdf:about=$targetId]"/>
  </xsl:template>
  <!-- Parent mapping: hg:Street | hg:Building -> edm:Place -->
  <xsl:template match="hg:Street | hg:Building">
    <edm:Place>
      <!-- Attribute mapping: rdf:about -> rdf:about -->
      <xsl:copy-of select="@rdf:about"/>
      <!-- Tag mapping: skos:prefLabel -> skos:prefLabel -->
      <xsl:apply-templates select="skos:prefLabel"/>
      <!-- Tag mapping: skos:altLabel -> skos:altLabel -->
      <xsl:apply-templates select="skos:altLabel"/>
      <!-- Tag mapping: dcterms:isPartOf -> dcterms:isPartOf -->
      <xsl:for-each select="dcterms:isPartOf">
        <dcterms:isPartOf>
          <xsl:copy-of select="@rdf:resource"/>
        </dcterms:isPartOf>
      </xsl:for-each>
      <!-- Tag mapping: dcterms:hasPart -> dcterms:hasPart -->
      <xsl:for-each select="dcterms:hasPart">
        <dcterms:hasPart>
          <xsl:copy-of select="@rdf:resource"/>
        </dcterms:hasPart>
      </xsl:for-each>
      <!-- Tag mapping: geo:asWKT POINT -> wgs84_pos:lat and wgs84_pos:long -->
      <xsl:if test="contains(geo:hasGeometry/rdf:Description/geo:asWKT, 'POINT')">
        <xsl:variable name="coordinates" select="substring-before(substring-after(geo:hasGeometry/rdf:Description/geo:asWKT, 'POINT('), ')')"/>
        <xsl:variable name="longitude" select="substring-before($coordinates, ' ')"/>
        <xsl:variable name="latitude" select="substring-after($coordinates, ' ')"/>
        <wgs84_pos:long><xsl:value-of select="$longitude"/></wgs84_pos:long>
        <wgs84_pos:lat><xsl:value-of select="$latitude"/></wgs84_pos:lat>
      </xsl:if>
      <!-- Tag mapping: owl:sameAs -> owl:sameAs -->
      <xsl:for-each select="owl:sameAs">
        <owl:sameAs>
          <xsl:copy-of select="@rdf:resource"/>
        </owl:sameAs>
      </xsl:for-each>
    </edm:Place>
  </xsl:template>
  <!-- Parent mapping: schema:Person -> edm:Agent -->
  <xsl:template match="schema:Person">
    <edm:Agent>
      <!-- Attribute mapping: rdf:about -> rdf:about -->
      <xsl:copy-of select="@rdf:about"/>
      <!-- Tag mapping: skos:prefLabel -> skos:prefLabel -->
      <xsl:apply-templates select="skos:prefLabel"/>
      <!-- Tag mapping: skos:altLabel -> skos:altLabel -->
      <xsl:apply-templates select="skos:altLabel"/>
    </edm:Agent>
  </xsl:template>

  <!-- Template for skos:prefLabel, skos:altLabel -->
  <xsl:template match="skos:prefLabel | skos:altLabel">
    <xsl:choose>
      <!-- Option 1: element has xml:lang and it's acceptable -->
      <xsl:when test="@xml:lang and lib:isAcceptableLang(@xml:lang)">
        <xsl:element name="skos:{local-name()}">
          <xsl:copy-of select="@xml:lang"/>
          <xsl:value-of select="."/>
        </xsl:element>
      </xsl:when>
      <!-- Option 2: element has no xml:lang -->
      <xsl:otherwise>
        <xsl:element name="skos:{local-name()}">
          <xsl:value-of select="."/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--+++++++++++++++++++++++++++++ FUNCTIONS ++++++++++++++++++++++++++++++++-->
  <xsl:function name="lib:isAcceptableLang" as="xs:boolean">
    <xsl:param name="string"/>
    <xsl:sequence select="$string!='' and contains($langs,lower-case($string))"/>
  </xsl:function>
</xsl:stylesheet>