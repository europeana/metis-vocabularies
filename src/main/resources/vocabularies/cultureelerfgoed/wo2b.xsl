<?xml version="1.0" encoding="UTF-8"?>
<!--
  Document   : WO2B2EDM.xsl
  Author     : Masa
  Created on : July 2025
  Updated on : July 2025
  Version    : v1.0
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:edm="http://www.europeana.eu/schemas/edm/"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdaGr2="http://rdvocab.info/ElementsGr2/"
  xmlns:schema="http://schema.org/"
  xmlns:wo2="https://data.niod.nl/organizationsWO2/">
  <xsl:param name="targetId"></xsl:param>
  <xsl:output indent="yes" encoding="UTF-8"></xsl:output>

  <!-- Main template -->
  <xsl:template match="/rdf:RDF">
    <xsl:for-each select="rdf:Description[@rdf:about=$targetId]">
      <!-- rdf:Description -> edm:Agent -->
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
        <!-- Tag mapping: schema:jobTitle -> rdaGr2:professionOrOccupation  -->
        <xsl:for-each select="schema:jobTitle">
          <rdaGr2:professionOrOccupation>
            <xsl:value-of select="."/>
          </rdaGr2:professionOrOccupation>
        </xsl:for-each>
        <!-- Tag mapping: schema:birthDate -> rdaGr2:dateOfBirth  -->
        <xsl:for-each select="schema:birthDate">
          <rdaGr2:dateOfBirth>
            <xsl:value-of select="."/>
          </rdaGr2:dateOfBirth>
        </xsl:for-each>
        <!-- Tag mapping: wo2:birthPlace -> rdaGr2:placeOfBirth  -->
        <xsl:for-each select="wo2:birthPlace">
          <rdaGr2:placeOfBirth>
            <xsl:value-of select="."/>
          </rdaGr2:placeOfBirth>
        </xsl:for-each>
        <!-- Tag mapping: schema:deathDate -> rdaGr2:dateOfDeath  -->
        <xsl:for-each select="schema:deathDate">
          <rdaGr2:dateOfDeath>
            <xsl:value-of select="."/>
          </rdaGr2:dateOfDeath>
        </xsl:for-each>
        <!-- Tag mapping: wo2:deathPlace -> rdaGr2:placeOfDeath  -->
        <xsl:for-each select="wo2:deathPlace">
          <rdaGr2:placeOfDeath>
            <xsl:value-of select="."/>
          </rdaGr2:placeOfDeath>
        </xsl:for-each>
        <!-- Tag mapping: skos:relatedMatch -> edm:isRelatedTo  -->
        <xsl:for-each select="skos:relatedMatch">
          <edm:isRelatedTo rdf:resource="{@rdf:resource}"/>
        </xsl:for-each>
        <!-- Tag mapping: skos:scopeNote -> rdaGr2:biographicalInformation -->
        <xsl:for-each select="skos:scopeNote">
          <rdaGr2:biographicalInformation xml:lang="{@xml:lang}">
            <xsl:value-of select="."/>
          </rdaGr2:biographicalInformation>
        </xsl:for-each>
        <!-- Tag mapping: schema:gender -> rdaGr2:gender -->
        <xsl:for-each select="schema:gender">
          <rdaGr2:gender>
            <xsl:if test="@xml:lang">
              <xsl:attribute name="xml:lang">
                <xsl:value-of select="@xml:lang"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="."/>
          </rdaGr2:gender>
        </xsl:for-each>
      </edm:Agent>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>