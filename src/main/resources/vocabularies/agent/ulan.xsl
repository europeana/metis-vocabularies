<?xml version="1.0" encoding="UTF-8"?>
<!--
  Document   : ulan.xsl
  Author     : Masa
  Created on : April 2, 2020
  Updated on : July 13, 2023
  Version    : v1.1

changes:
* updated XPath expressions for processing skos:preflabel, skos:note, gvp:estStart, gvp:estEnd
* added properties (skos:altLabel, owl:sameAs)
* added filter to literals (when language tagged) so only the ones matching a list of languages are kept
-->

<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gvp="http://vocab.getty.edu/ontology#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:edm="http://www.europeana.eu/schemas/edm/"
  xmlns:schema="http://schema.org/"
  xmlns:rdagr2="http://rdvocab.info/ElementsGr2/"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:lib="http://example.org/lib"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xsl gvp lib xs">

  <xsl:param name="targetId"/>
  <xsl:param name="targetBio" select=".//gvp:biographyPreferred/@rdf:resource"/>
  <xsl:output indent="yes" encoding="UTF-8"></xsl:output>

  <!-- Portal languages (28) -->
  <xsl:param name="langs">en,pl,de,nl,fr,it,da,sv,el,fi,hu,cs,sl,et,pt,es,lt,lv,bg,ro,sk,hr,ga,mt,no,ca,ru,eu</xsl:param>

  <!-- Main template -->
  <xsl:template match="/rdf:RDF">
    <xsl:for-each select="gvp:Subject">
      <xsl:if test="@rdf:about=$targetId">
        <!-- Parent mapping: gvp:Subject -> edm:Agent -->
        <edm:Agent>
          <!-- Attribute mapping: rdf:about -> rdf:about -->
          <xsl:copy-of select="@rdf:about"/>
          <!-- Tag mapping: skos:prefLabel -> skos:prefLabel -->
          <xsl:apply-templates select=".//skos:prefLabel"/>
          <!-- Tag mapping: skos:altLabel -> skos:altLabel -->
          <xsl:apply-templates select=".//skos:altLabel"/>
          <!-- Tag mapping: skos:exactMatch -> owl:sameAs -->
          <xsl:apply-templates select=".//skos:exactMatch//skos:exactMatch"/>
          <!-- Tag mapping: gvp:ScopeNote -> skos:note -->
          <xsl:apply-templates select="../gvp:ScopeNote/rdf:value"/>
          <!-- Tag mapping: gvp:estStart -> rdagr2:dateOfBirth -->
          <xsl:apply-templates select="../gvp:Biography[@rdf:about=$targetBio]/gvp:estStart"/>
          <!-- Tag mapping: gvp:estEnd -> rdagr2:dateOfDeath -->
          <xsl:apply-templates select="../gvp:Biography[@rdf:about=$targetBio]/gvp:estEnd"/>
        </edm:Agent>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- Template for skos:prefLabel -->
  <xsl:template match="skos:prefLabel">
    <xsl:if test="lib:isAcceptableLang(@xml:lang) or not(@xml:lang)">
      <xsl:element name="skos:prefLabel">
        <xsl:copy-of select="@xml:lang"/>
        <xsl:copy-of select="text()"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <!-- Template for skos:altLabel -->
  <xsl:template match="skos:altLabel">
    <xsl:if test="lib:isAcceptableLang(@xml:lang)">
      <xsl:element name="skos:altLabel">
        <xsl:copy-of select="@xml:lang"/>
        <xsl:copy-of select="text()"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <!-- Template for owl:sameAs -->
  <xsl:template match="skos:exactMatch//skos:exactMatch">
    <xsl:element name="owl:sameAs">
      <xsl:copy-of select="@rdf:resource"/>
    </xsl:element>
  </xsl:template>
  <!-- Template for skos:note -->
  <xsl:template match="gvp:ScopeNote/rdf:value">
    <xsl:if test="lib:isAcceptableLang(@xml:lang)">
      <xsl:element name="skos:note">
        <xsl:copy-of select="@xml:lang"/>
        <xsl:copy-of select="text()"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <!-- Template for rdagr2:dateOfBirth -->
  <xsl:template match="gvp:Biography[@rdf:about=$targetBio]/gvp:estStart">
    <xsl:element name="rdagr2:dateOfBirth">
      <xsl:copy-of select="text()"/>
    </xsl:element>
  </xsl:template>
  <!-- Template for rdagr2:dateOfDeath -->
  <xsl:template match="gvp:Biography[@rdf:about=$targetBio]/gvp:estEnd">
    <xsl:element name="rdagr2:dateOfDeath">
      <xsl:copy-of select="text()"/>
    </xsl:element>
  </xsl:template>

  <!--+++++++++++++++++++++++++++++ FUNCTIONS ++++++++++++++++++++++++++++++++-->

  <xsl:function name="lib:isAcceptableLang" as="xs:boolean">
    <xsl:param name="string"/>
    <xsl:sequence select="$string!='' and contains($langs,lower-case($string))"/>
  </xsl:function>

</xsl:stylesheet>