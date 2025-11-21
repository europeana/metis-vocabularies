<?xml version="1.0" encoding="UTF-8"?>
<!--
  Document   : WO2T2EDM.xsl
  Author     : Masa
  Created on : July 2025
  Updated on : October 2025
  Version    : v1.1

  changes:
* Revision of mapping logic for selected entity types:
  - Type "Corporation" remapped from skos:Concept to edm:Agent
  - Type "Event" remapped from skos:Concept to edm:TimeSpan
  - Type "Camp" remapped from skos:Concept to edm:Place
  - Type "Object" remains mapped to skos:Concept
  - Type "Location" remains mapped to edm:Place
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:wgs84_pos="http://www.w3.org/2003/01/geo/wgs84_pos#"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:edm="http://www.europeana.eu/schemas/edm/"
  xmlns:rdagr2="http://rdvocab.info/ElementsGr2/"
  xmlns:schema="http://schema.org/">
  <xsl:param name="targetId"></xsl:param>
  <xsl:output indent="yes" encoding="UTF-8"></xsl:output>

  <!-- Main template -->
  <xsl:template match="/rdf:RDF">
    <xsl:for-each select="rdf:Description[@rdf:about=$targetId]">
      <!-- Condition based on rdf:about attribute defines EDM entity type -->
      <xsl:choose>
        <!-- Locations and camps -> edm:Place -->
        <xsl:when test="contains(@rdf:about, 'locations') or contains(@rdf:about, 'kampen')">
          <edm:Place>
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
            <!-- Tag mapping: wgs84_pos:lat -> wgs84_pos:lat  -->
            <xsl:for-each select="wgs84_pos:lat">
              <wgs84_pos:lat>
                <xsl:value-of select="."/>
              </wgs84_pos:lat>
            </xsl:for-each>
            <!-- Tag mapping: wgs84_pos:long -> wgs84_pos:long  -->
            <xsl:for-each select="wgs84_pos:long">
              <wgs84_pos:long>
                <xsl:value-of select="."/>
              </wgs84_pos:long>
            </xsl:for-each>
            <!-- Tag mapping: skos:broader -> dcterms:isPartOf  -->
            <xsl:for-each select="skos:broader">
              <dcterms:isPartOf rdf:resource="{@rdf:resource}"/>
            </xsl:for-each>
            <!-- Tag mapping: skos:narorower -> dcterms:hasPart  -->
            <xsl:for-each select="skos:narrower">
              <dcterms:hasPart rdf:resource="{@rdf:resource}"/>
            </xsl:for-each>
            <!-- Tag mapping: skos:exactMatch -> owl:sameAs  -->
            <xsl:for-each select="skos:exactMatch">
              <owl:sameAs rdf:resource="{@rdf:resource}"/>
            </xsl:for-each>
            <!-- Tag mapping: skos:scopeNote -> skos:note -->
            <xsl:for-each select="skos:scopeNote">
              <skos:note xml:lang="{@xml:lang}">
                <xsl:value-of select="."/>
              </skos:note>
            </xsl:for-each>
          </edm:Place>
        </xsl:when>
        <!-- Corporations -> edm:Agent -->
        <xsl:when test="contains(@rdf:about, 'corporaties')">
          <edm:Agent>
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
            <!-- Tag mapping: skos:relatedMatch -> edm:isRelatedTo  -->
            <xsl:for-each select="skos:relatedMatch">
              <edm:isRelatedTo rdf:resource="{@rdf:resource}"/>
            </xsl:for-each>
            <!-- Tag mapping: skos:scopeNote -> skos:note -->
            <xsl:for-each select="skos:scopeNote">
              <skos:note xml:lang="{@xml:lang}">
                <xsl:value-of select="."/>
              </skos:note>
            </xsl:for-each>
            <!-- Tag mapping: skos:broader -> dcterms:isPartOf  -->
            <xsl:for-each select="skos:broader">
              <dcterms:isPartOf rdf:resource="{@rdf:resource}"/>
            </xsl:for-each>
            <!-- Tag mapping: skos:narorower -> dcterms:hasPart  -->
            <xsl:for-each select="skos:narrower">
              <dcterms:hasPart rdf:resource="{@rdf:resource}"/>
            </xsl:for-each>
          </edm:Agent>
        </xsl:when>
        <!-- Events -> edm:TimeSpan -->
        <xsl:when test="contains(@rdf:about, 'events')">
          <edm:TimeSpan>
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
                <xsl:value-of select="."/>
              </skos:note>
            </xsl:for-each>
            <!-- Tag mapping: skos:broader -> dcterms:isPartOf  -->
            <xsl:for-each select="skos:broader">
              <dcterms:isPartOf rdf:resource="{@rdf:resource}"/>
            </xsl:for-each>
            <!-- Tag mapping: skos:narorower -> dcterms:hasPart  -->
            <xsl:for-each select="skos:narrower">
              <dcterms:hasPart rdf:resource="{@rdf:resource}"/>
            </xsl:for-each>
            <!-- Tag mapping: schema:startDate -> edm:begin  -->
            <xsl:for-each select="schema:startDate">
              <edm:begin><xsl:value-of select="."/></edm:begin>
            </xsl:for-each>
            <!-- Tag mapping: schema:endDate -> edm:end  -->
            <xsl:for-each select="schema:endDate">
              <edm:end><xsl:value-of select="."/></edm:end>
            </xsl:for-each>
          </edm:TimeSpan>
        </xsl:when>
        <!-- All other types -> skos:Concept -->
        <xsl:otherwise>
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
                <xsl:value-of select="."/>
              </skos:note>
            </xsl:for-each>
            <!-- Tag mapping: skos:broader -> skos:broader -->
            <xsl:for-each select="skos:broader">
              <skos:broader rdf:resource="{@rdf:resource}"/>
            </xsl:for-each>
            <!-- Tag mapping: skos:narrower -> skos:narrower -->
            <xsl:for-each select="skos:narrower">
              <skos:narrower rdf:resource="{@rdf:resource}"/>
            </xsl:for-each>
            <!-- Tag mapping: skos:related -> skos:related -->
            <xsl:for-each select="skos:related">
              <skos:related rdf:resource="{@rdf:resource}"/>
            </xsl:for-each>
          </skos:Concept>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>