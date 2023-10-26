<?xml version="1.0" encoding="UTF-8"?>
<!--
  Document   : tgn.xsl
  Author     : Masa
  Created on : April 2, 2020
  Updated on : September 20, 2023
  Version    : v1.2

changes:
* added properties skos:altLabel, dcterms:isPartOf, wgs84_pos:lat, wgs84_pos:long, skos:note
* added conditions for processing prefLabels depending on the presence of language tags
* added filter to literals (when language tagged) so only the ones matching a list of languages are kept
-->

<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gvp="http://vocab.getty.edu/ontology#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:skos-xl="http://www.w3.org/2008/05/skos-xl#"
  xmlns:edm="http://www.europeana.eu/schemas/edm/"
  xmlns:schema="http://schema.org/"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:wgs84_pos="http://www.w3.org/2003/01/geo/wgs84_pos#"
  xmlns:lib="http://example.org/lib"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xsl gvp lib xs">

  <xsl:param name="targetId" />

  <!-- Portal languages (28) -->
  <xsl:param name="langs">en,pl,de,nl,fr,it,da,sv,el,fi,hu,cs,sl,et,pt,es,lt,lv,bg,ro,sk,hr,ga,mt,no,ca,ru,eu</xsl:param>

  <!-- Variables -->
  <xsl:variable name="prefLabelWithLangTag" select=".//skos:prefLabel/@xml:lang" />
  <xsl:variable name="EnPrefLabel" select=".//skos:prefLabel/@xml:lang='en'" />
  <xsl:variable name="targetLabel" select=".//gvp:prefLabelGVP/@rdf:resource" />

  <xsl:output indent="yes" encoding="UTF-8"></xsl:output>

  <!-- Main template -->
  <xsl:template match="/rdf:RDF">
    <xsl:for-each select="gvp:Subject">
      <xsl:if test="@rdf:about=$targetId">
        <!-- Parent mapping: gvp:Subject -> edm:Place -->
        <edm:Place>
          <!-- Attribute mapping: rdf:about -> rdf:about -->
          <xsl:copy-of select="@rdf:about" />
          <!-- Tag mapping: skos:prefLabel/skos-xl:literalForm -> skos:prefLabel -->
          <xsl:if test="$prefLabelWithLangTag">
            <xsl:apply-templates select=".//skos:prefLabel" />
          </xsl:if>
          <xsl:if test="not($prefLabelWithLangTag) or not($EnPrefLabel)">
            <xsl:apply-templates select="../skos-xl:Label[@rdf:about=$targetLabel]/skos-xl:literalForm" />
          </xsl:if>
          <!-- Tag mapping: skos:altLabel -> skos:altLabel -->
          <xsl:apply-templates select=".//skos:altLabel" />
          <!-- Tag mapping: skos:broader -> dcterms:isPartOf -->
          <xsl:apply-templates select=".//gvp:broaderPreferred" />
          <!-- Tag mapping: wgs84_pos:lat -> wgs84_pos:lat  -->
          <xsl:apply-templates select="../schema:Place/wgs84_pos:lat" />
          <!-- Tag mapping: schema:longitude -> wgs84_pos:long  -->
          <xsl:apply-templates select="../schema:Place/wgs84_pos:long" />
          <!-- Tag mapping: gvp:ScopeNote -> skos:note -->
          <xsl:apply-templates select="../gvp:ScopeNote/rdf:value" />
        </edm:Place>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- Template for skos:prefLabel -> skos:prefLabel (used for language tagged labels) -->
  <xsl:template match="skos:prefLabel">
    <xsl:if test="lib:isAcceptableLang(@xml:lang)">
      <xsl:element name="skos:prefLabel">
        <xsl:copy-of select="@xml:lang" />
        <xsl:copy-of select="text()" />
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <!-- Template for skos-xl:literalForm -> skos:prefLabel (used when there are no language tagged or English labels) -->
  <xsl:template match="skos-xl:Label[@rdf:about=$targetLabel]/skos-xl:literalForm">
    <xsl:element name="skos:prefLabel">
      <xsl:attribute name="xml:lang">
        <xsl:text>en</xsl:text>
      </xsl:attribute>
      <xsl:copy-of select="text()" />
    </xsl:element>
  </xsl:template>
  <!-- Template for skos:altLabel -->
  <xsl:template match="skos:altLabel">
    <xsl:if test="lib:isAcceptableLang(@xml:lang)">
      <xsl:element name="skos:altLabel">
        <xsl:copy-of select="@xml:lang" />
        <xsl:copy-of select="text()" />
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <!-- Template for dcterm:isPartOf -->
  <xsl:template match="gvp:broaderPreferred">
    <xsl:element name="dcterms:isPartOf">
      <xsl:copy-of select="@rdf:resource" />
    </xsl:element>
  </xsl:template>
  <!-- Template for wgs84_pos:lat -->
  <xsl:template match="schema:Place/wgs84_pos:lat">
    <xsl:element name="wgs84_pos:lat">
      <xsl:copy-of select="text()" />
    </xsl:element>
  </xsl:template>
  <!-- Template for wgs84_pos:long -->
  <xsl:template match="schema:Place/wgs84_pos:long">
    <xsl:element name="wgs84_pos:long">
      <xsl:copy-of select="text()" />
    </xsl:element>
  </xsl:template>
  <!-- Template for skos:note -->
  <xsl:template match="gvp:ScopeNote/rdf:value">
    <xsl:if test="lib:isAcceptableLang(@xml:lang)">
      <xsl:element name="skos:note">
        <xsl:copy-of select="@xml:lang" />
        <xsl:copy-of select="text()" />
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <!--+++++++++++++++++++++++++++++ FUNCTIONS ++++++++++++++++++++++++++++++++-->

  <xsl:function name="lib:isAcceptableLang" as="xs:boolean">
    <xsl:param name="string" />
    <xsl:sequence
      select="$string!='' and contains($langs,lower-case($string))" />
  </xsl:function>

</xsl:stylesheet>