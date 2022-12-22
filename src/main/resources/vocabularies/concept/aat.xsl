<?xml version="1.0" encoding="UTF-8"?>
<!--
  Document   : aat2concept.xsl
  Author     : Masa, Hugo
  Created on : November 17, 2022
  Updated on : December 9, 2022
  Version    : v1.2

changes:
* add filter to literals so that only the ones matching a list of languages are kept
* comment out skos:narrower and skos:inScheme relations
-->

<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gvp="http://vocab.getty.edu/ontology#"

  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"

  xmlns:lib="http://example.org/lib"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"

  exclude-result-prefixes="xsl gvp lib xs"
>

  <xsl:param name="targetId"></xsl:param>
  <xsl:output indent="yes" encoding="UTF-8"></xsl:output>

  <!-- Portal languages (28) -->
  <xsl:param name="langs">en,pl,de,nl,fr,it,da,sv,el,fi,hu,cs,sl,et,pt,es,lt,lv,bg,ro,sk,hr,ga,mt,no,ca,ru,eu</xsl:param>

  <!-- Main template -->
  <xsl:template match="/rdf:RDF">
    <xsl:for-each select="gvp:Subject">
      <xsl:if test="@rdf:about=$targetId">
        <!-- Parent mapping: gvp:Subject -> skos:Concept -->
        <skos:Concept>
          <!-- Attribute mapping: rdf:about -> rdf:about -->
          <xsl:copy-of select="@rdf:about"/>
          <!-- Tag mapping: skos:prefLabel -> skos:prefLabel -->
          <xsl:apply-templates select=".//skos:prefLabel"/>
          <!-- Tag mapping: skos:altLabel -> skos:altLabel -->
          <xsl:apply-templates select=".//skos:altLabel"/>
          <!-- Tag mapping: gvp:ScopeNote -> skos:note -->
          <xsl:apply-templates select="../gvp:ScopeNote/rdf:value"/>
          <!-- Tag mapping: skos:broader -> skos:broader -->
          <xsl:apply-templates select=".//skos:broader[@rdf:resource]"/>
          <!-- Tag mapping: skos:narrower -> skos:narrower -->
          <!--
          <xsl:apply-templates select=".//skos:narrower[@rdf:resource]"/>
          -->
          <!-- Tag mapping: skos:related -> skos:related -->
          <xsl:apply-templates select=".//skos:related[@rdf:resource]"/>
          <!-- Tag mapping: skos:exactMatch -> skos:exactMatch -->
          <xsl:apply-templates select=".//skos:exactMatch[@rdf:resource]"/>
          <!-- Tag mapping: skos:inScheme -> skos:inScheme -->
          <!--
          <xsl:apply-templates select=".//skos:inScheme[@rdf:resource]"/>
          -->
        </skos:Concept>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- Template for skos:prefLabel -->
  <xsl:template match="skos:prefLabel">
    <xsl:if test="lib:isAcceptableLang(@xml:lang)">
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
        <xsl:copy-of select="@xml:lang" />
        <xsl:copy-of select="text()"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <!-- Template for skos:broader -->
  <xsl:template match="skos:broader">
    <xsl:element name="skos:broader">
      <xsl:copy-of select="@rdf:resource" />
    </xsl:element>
  </xsl:template>

  <!-- Template for skos:narrower -->
  <!--
  <xsl:template match="skos:narrower">
      <xsl:element name="skos:narrower">
          <xsl:copy-of select="@rdf:resource" />
      </xsl:element>
  </xsl:template>
   -->

  <!-- Template for skos:exactMatch -->
  <xsl:template match="skos:exactMatch">
    <xsl:element name="skos:exactMatch">
      <xsl:copy-of select="@rdf:resource" />
    </xsl:element>
  </xsl:template>

  <!-- Template for skos:note -->
  <xsl:template match="gvp:ScopeNote/rdf:value">
    <xsl:if test="lib:isAcceptableLang(@xml:lang)">
      <xsl:element name="skos:note">
        <xsl:copy-of select="@xml:lang" />
        <xsl:copy-of select="text()"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <!-- Template for skos:inScheme -->
  <!--
  <xsl:template match="skos:inScheme">
      <xsl:element name="skos:inScheme">
          <xsl:copy-of select="@rdf:resource"/>
      </xsl:element>
  </xsl:template>
   -->

  <!--+++++++++++++++++++++++++++++ FUNCTIONS ++++++++++++++++++++++++++++++++-->

  <xsl:function name="lib:isAcceptableLang" as="xs:boolean">
    <xsl:param name="string"/>
    <xsl:sequence select="$string!='' and contains($langs,lower-case($string))"/>
  </xsl:function>

</xsl:stylesheet>
