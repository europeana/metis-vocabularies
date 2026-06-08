<?xml version="1.0" encoding="UTF-8"?>
<!--
  Document   : countriesEU2place.xsl
  Author     : Masa
  Created on : May, 2026
  Updated on :
  Version    : v1.0
-->

<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:edm="http://www.europeana.eu/schemas/edm/"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:ogcgs="http://www.opengis.net/ont/geosparql#"
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
    <xsl:for-each select="rdf:Description">
      <xsl:if test="@rdf:about=$targetId">
        <!-- Parent mapping: rdf:Description -> edm:Place -->
        <edm:Place>
          <!-- Attribute mapping: rdf:about -> rdf:about -->
          <xsl:copy-of select="@rdf:about" />
          <!-- Tag mapping: skos:prefLabel -> skos:prefLabel -->
          <xsl:apply-templates select="skos:prefLabel" />
          <!-- Tag mapping: skos:altLabel -> skos:altLabel -->
          <xsl:apply-templates select="skos:altLabel" />
          <!-- Tag mapping: skos:hiddenLabel -> skos:hiddenLabel -->
          <xsl:apply-templates select="skos:hiddenLabel" />
          <!-- Tag mapping: ogcgs:sfWithin -> dcterms:isPartOf -->
          <xsl:apply-templates select="ogcgs:sfWithin" />
        </edm:Place>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- Template for labels -->
  <xsl:template match="skos:prefLabel | skos:altLabel | skos:hiddenLabel">
    <xsl:if test="@xml:lang and lib:isAcceptableLang(@xml:lang)">
      <xsl:element name="skos:{local-name()}">
        <xsl:copy-of select="@xml:lang"/>
        <xsl:value-of select="."/>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <!-- Template for ogcgs:sfWithin -->
  <xsl:template match="ogcgs:sfWithin">
    <xsl:element name="dcterms:isPartOf">
      <xsl:copy-of select="@rdf:resource"/>
    </xsl:element>
  </xsl:template>
  <!--+++++++++++++++++++++++++++++ FUNCTIONS ++++++++++++++++++++++++++++++++-->
  <xsl:function name="lib:isAcceptableLang" as="xs:boolean">
    <xsl:param name="string"/>
    <xsl:sequence select="$string!='' and contains($langs,lower-case($string))"/>
  </xsl:function>
</xsl:stylesheet>