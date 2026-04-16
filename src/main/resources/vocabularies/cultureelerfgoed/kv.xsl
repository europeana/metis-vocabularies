<?xml version="1.0" encoding="UTF-8"?>
<!--
  Document   : Koloniaalverleden2edm.xsl
  Author     : Masa
  Created on : February, 2026
  Updated on :
  Version    : v1.0
-->

<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:gvp="http://vocab.getty.edu/ontology#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:edm="http://www.europeana.eu/schemas/edm/"
  xmlns:lib="http://example.org/lib"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xsl gvp lib xs">
  <xsl:param name="targetId"></xsl:param>
  <xsl:output indent="yes" encoding="UTF-8"></xsl:output>
  <!-- Portal languages (28) -->
  <xsl:param name="langs">en,pl,de,nl,fr,it,da,sv,el,fi,hu,cs,sl,et,pt,es,lt,lv,bg,ro,sk,hr,ga,mt,no,ca,ru,eu</xsl:param>

  <!-- Main template -->
  <xsl:template match="/rdf:RDF">
    <xsl:for-each select="rdf:Description[@rdf:about=$targetId]">
      <!-- Condition based on rdf:type value defines EDM entity type -->
      <xsl:choose>
        <!-- SpatialThing -> edm:Place -->
        <xsl:when test="rdf:type[@rdf:resource='http://www.w3.org/2003/01/geo/wgs84_pos#SpatialThing']">
          <edm:Place>
            <!-- Attribute mapping: rdf:about -> rdf:about -->
            <xsl:copy-of select="@rdf:about" />
            <!-- Tag mapping: skos:prefLabel -> skos:prefLabel -->
            <xsl:apply-templates select="skos:prefLabel"/>
            <!-- Tag mapping: skos:altLabel -> skos:altLabel -->
            <xsl:apply-templates select="skos:altLabel"/>
            <!-- Tag mapping: skos:exactMatch -> owl:sameAs  -->
            <xsl:for-each select="skos:exactMatch">
              <owl:sameAs rdf:resource="{@rdf:resource}"/>
            </xsl:for-each>
          </edm:Place>
        </xsl:when>
        <!-- All other types -> skos:Concept -->
        <xsl:otherwise>
          <skos:Concept>
            <!-- Attribute mapping: rdf:about -> rdf:about -->
            <xsl:copy-of select="@rdf:about"/>
            <!-- Tag mapping: skos:prefLabel -> skos:prefLabel -->
            <xsl:apply-templates select="skos:prefLabel"/>
            <!-- Tag mapping: skos:altLabel -> skos:altLabel -->
            <xsl:apply-templates select="skos:altLabel"/>
            <!-- Tag mapping: skos:broader -> skos:broader -->
            <xsl:apply-templates select="skos:broader[@rdf:resource]"/>
            <!-- Tag mapping: skos:narrower -> skos:narrower -->
            <xsl:apply-templates select="skos:narrower[@rdf:resource]"/>
            <!-- Tag mapping: skos:related -> skos:related -->
            <xsl:apply-templates select="skos:related[@rdf:resource]"/>
            <!-- Tag mapping: skos:exactMatch -> skos:exactMatch -->
            <xsl:apply-templates select="skos:exactMatch[@rdf:resource]"/>
          </skos:Concept>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
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

  <!-- Template for skos:broader, skos:narrower, skos:related, skos:exactMatch -->
  <xsl:template match="skos:broader | skos:narrower | skos:related | skos:exactMatch">
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