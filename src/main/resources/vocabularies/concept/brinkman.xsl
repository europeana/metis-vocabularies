<?xml version="1.0" encoding="UTF-8"?>
<!--
  Document   : Brinkman2concept.xsl
  Author     : Masa
  Created on : April, 2026
  Updated on : 
  Version    : v1.0
-->

<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:j.0="http://www.w3.org/2004/02/skos/core#"
  xmlns:j.1="http://schema.org/"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:gvp="http://vocab.getty.edu/ontology#"
  xmlns:lib="http://example.org/lib"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xsl gvp lib xs">
  <xsl:param name="targetId"></xsl:param>
  <xsl:output indent="yes" encoding="UTF-8"></xsl:output>
  <!-- Portal languages (28) -->
  <xsl:param name="langs">en,pl,de,nl,fr,it,da,sv,el,fi,hu,cs,sl,et,pt,es,lt,lv,bg,ro,sk,hr,ga,mt,no,ca,ru,eu</xsl:param>

  <!-- Main template -->
  <xsl:template match="rdf:RDF">
    <xsl:apply-templates select="j.0:Concept[@rdf:about=$targetId]"/>
  </xsl:template>
  <!-- Parent mapping: j.0:Concept -> skos:Concept -->
  <xsl:template match="j.0:Concept">
        <skos:Concept>
          <!-- Attribute mapping: rdf:about -> rdf:about -->
          <xsl:copy-of select="@rdf:about"/>
          <!-- Tag mapping: j.0:prefLabel -> skos:prefLabel -->
          <xsl:apply-templates select="skos:prefLabel"/>
          <!-- Tag mapping: j.0:altLabel -> skos:altLabel -->
          <xsl:apply-templates select="skos:altLabel"/>
          <!-- Tag mapping: j.0:broader -> skos:broader -->
          <xsl:apply-templates select="skos:broader[@rdf:resource]"/>
          <!-- Tag mapping: j.0:narrower -> skos:narrower -->
          <xsl:apply-templates select="skos:narrower[@rdf:resource]"/>
          <!-- Tag mapping: j.0:related -> skos:related -->
          <xsl:apply-templates select="skos:related[@rdf:resource]"/>
        </skos:Concept>
  </xsl:template>

  <!-- Template for skos:prefLabel, skos:altLabel -->
  <xsl:template match="skos:prefLabel | skos:altLabel">
    <xsl:if test="lib:isAcceptableLang(@xml:lang)">
      <xsl:element name="skos:{local-name()}">
        <xsl:copy-of select="@xml:lang"/>
        <xsl:value-of select="."/>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <!-- Template for skos:broader, skos:narrower, skos:related -->
  <xsl:template match="skos:broader | skos:narrower | skos:related">
    <xsl:element name="skos:{local-name()}">
      <xsl:copy-of select="@rdf:resource"/>
    </xsl:element>
  </xsl:template>
  <!--+++++++++++++++++++++++++++++ FUNCTIONS ++++++++++++++++++++++++++++++++-->
  <xsl:function name="lib:isAcceptableLang" as="xs:boolean">
    <xsl:param name="string"/>
    <xsl:sequence select="$string!='' and contains($langs,lower-case($string))"/>
  </xsl:function>
</xsl:stylesheet>