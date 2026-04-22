<?xml version="1.0" encoding="UTF-8"?>
<!--
  Document   : Muziekschatten2edm.xsl
  Author     : Masa
  Created on : March, 2026
  Version    : v1.0
-->

<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:schema="http://schema.org/"
  xmlns:rdaGr2="http://rdvocab.info/ElementsGr2/"
  xmlns:som="https://data.muziekschatten.nl/som/"
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
        <!-- Person or Music Group -> edm:Agent -->
        <xsl:when test="rdf:type[@rdf:resource = ('http://schema.org/Person', 'http://schema.org/MusicGroup')]">
          <edm:Agent>
            <!-- Attribute mapping: rdf:about -> rdf:about -->
            <xsl:copy-of select="@rdf:about" />
            <!-- Tag mapping: schema:name | skos:prefLabel -> skos:prefLabel -->
            <xsl:apply-templates select="." mode="skos:prefLabel"/>
            <!-- Tag mapping: schema:birthDate | som:DGXSD -> rdaGr2:dateOfBirth -->
            <xsl:apply-templates select="(schema:birthDate | som:DGXSD) [1]"/>
            <!-- Tag mapping: schema:deathDate| som:DSXSD -> rdaGr2:dateOfDeath -->
            <xsl:apply-templates select="(schema:deathDate | som:DSXSD) [1]"/>
            <!-- Tag mapping: schema:foundingDate -> edm:begin -->
            <xsl:apply-templates select="schema:foundingDate"/>
            <!-- Tag mapping: schema:dissolutionDate -> edm:end -->
            <xsl:apply-templates select="schema:dissolutionDate"/>
            <!-- Tag mapping: schema:hasOccupation | som:ZKNMFZ -> rdaGr2:professionOrOccupation -->
            <xsl:apply-templates select="." mode="rdaGr2:professionOrOccupation"/>
            <!-- Tag mapping: owl:sameAs | som:WIKID | som:VIAF | som:GTAA | som:LCNAF -> owl:sameAs  -->
            <xsl:apply-templates select="." mode="owl:sameAs"/>
          </edm:Agent>
        </xsl:when>
        <!-- All other types -> skos:Concept -->
        <xsl:otherwise>
          <skos:Concept>
            <!-- Attribute mapping: rdf:about -> rdf:about -->
            <xsl:copy-of select="@rdf:about"/>
            <!-- Tag mapping: schema:name | skos:prefLabel -> skos:prefLabel -->
            <xsl:apply-templates select="." mode="skos:prefLabel"/>
            <!-- Tag mapping: skos:broader -> skos:broader -->
            <xsl:apply-templates select="skos:broader"/>
            <!-- Tag mapping: skos:narrower -> skos:narrower -->
            <xsl:apply-templates select="skos:narrower"/>
            <!-- Tag mapping: skos:related -> skos:related -->
            <xsl:apply-templates select="skos:related"/>
            <!-- Tag mapping: skos:broadMatch -> skos:broadMatch -->
            <xsl:apply-templates select="skos:broadMatch"/>
            <!-- Tag mapping: skos:narrowMatch -> skos:narrowMatch -->
            <xsl:apply-templates select="skos:narrowMatch"/>
            <!-- Tag mapping: skos:relatedMatch -> skos:relatedMatch -->
            <xsl:apply-templates select="skos:relatedMatch"/>
            <!-- Tag mapping: skos:exactMatch -> skos:exactMatch -->
            <xsl:apply-templates select="skos:exactMatch"/>
            <!-- Tag mapping: skos:closeMatch -> skos:closeMatch -->
            <xsl:apply-templates select="skos:closeMatch"/>
          </skos:Concept>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!-- Template for skos:prefLabel -->
  <xsl:template match="rdf:Description" mode="skos:prefLabel">
    <!-- Choose skos:prefLabel if it exists, otherwise schema:name -->
    <xsl:variable name="labels" select="if (skos:prefLabel) then skos:prefLabel[@xml:lang and lib:isAcceptableLang(@xml:lang)] | skos:prefLabel[not(@xml:lang)]
            else schema:name[@xml:lang and lib:isAcceptableLang(@xml:lang)] | schema:name[not(@xml:lang)]"/>
    <xsl:for-each select="$labels">
      <skos:prefLabel>
        <xsl:copy-of select="@xml:lang"/>
        <xsl:value-of select="."/>
      </skos:prefLabel>
    </xsl:for-each>
  </xsl:template>
  <!-- Template for rdaGr2:dateOfBirth -->
  <xsl:template match="(schema:birthDate | som:DGXSD) [1]">
    <rdaGr2:dateOfBirth>
      <xsl:value-of select="."/>
    </rdaGr2:dateOfBirth>
  </xsl:template>
  <!-- Template for rdaGr2:dateOfDeath -->
  <xsl:template match="(schema:deathDate | som:DSXSD) [1]">
    <rdaGr2:dateOfDeath>
      <xsl:value-of select="."/>
    </rdaGr2:dateOfDeath>
  </xsl:template>
  <!-- Template for edm:begin -->
  <xsl:template match="schema:foundingDate">
    <edm:begin>
      <xsl:value-of select="."/>
    </edm:begin>
  </xsl:template>
  <!-- Template for edm:end -->
  <xsl:template match="schema:dissolutionDate">
    <edm:end>
      <xsl:value-of select="."/>
    </edm:end>
  </xsl:template>
  <!-- Template for rdaGr2:professionOrOccupation -->
  <xsl:template match="rdf:Description" mode="rdaGr2:professionOrOccupation">
    <!-- Use schema:hasOccupation if present, otherwise som:ZKNMFZ -->
    <xsl:variable name="occupations" select="if (schema:hasOccupation) then schema:hasOccupation else som:ZKNMFZ"/>
    <xsl:for-each select="$occupations">
      <rdaGr2:professionOrOccupation>
        <xsl:value-of select="."/>
      </rdaGr2:professionOrOccupation>
    </xsl:for-each>
  </xsl:template>
  <!-- Template for owl:sameAs -->
  <xsl:template match="rdf:Description" mode="owl:sameAs">
    <!-- Use existing owl:sameAs if present, otherwise som:WIKID, som:VIAF, som:GTAA, som:LCNAF -->
    <xsl:variable name="sameAsNodes" select="if (owl:sameAs) then owl:sameAs else (som:WIKID | som:VIAF | som:GTAA | som:LCNAF)"/>
    <xsl:for-each select="$sameAsNodes">
      <owl:sameAs>
        <xsl:attribute name="rdf:resource">
          <xsl:choose>
            <xsl:when test="self::owl:sameAs">
              <xsl:value-of select="@rdf:resource"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="."/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </owl:sameAs>
    </xsl:for-each>
  </xsl:template>
  <!-- Template for skos:broader, skos:narrower, skos:related, skos:broadMatch, skos:narrowMatch, skos:exactMatch, skos:relatedMatch, skos:closeMatch -->
  <xsl:template match="skos:broader | skos:narrower | skos:related | skos:broadMatch | skos:narrowMatch | skos:exactMatch |skos:relatedMatch | skos:closeMatch">
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