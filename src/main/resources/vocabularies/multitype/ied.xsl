<?xml version="1.0" encoding="UTF-8"?>
<!--
  Document   : IET2EDM.xsl
  Author     : Masa
  Created on : March 2026
  Version    : v1.0
-->

<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:wgs84_pos="http://www.w3.org/2003/01/geo/wgs84_pos#"
  xmlns:schema="https://data.indischherinneringscentrum.nl/schema/"
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
  <xsl:param name="langs">
    en,pl,de,nl,fr,it,da,sv,el,fi,hu,cs,sl,et,pt,es,lt,lv,bg,ro,sk,hr,ga,mt,no,ca,ru,eu</xsl:param>

  <!-- Main template -->
  <xsl:template match="/rdf:RDF">
    <xsl:for-each select="rdf:Description[@rdf:about=$targetId]">
      <!-- Condition based on rdf:type attribute defines EDM entity type -->
      <xsl:choose>
        <!-- Places -> edm:Place -->
        <xsl:when
          test="rdf:type[@rdf:resource = ('https://data.indischherinneringscentrum.nl/schema/Place')]">
          <edm:Place>
            <!-- Attribute mapping: rdf:about -> rdf:about -->
            <xsl:copy-of select="@rdf:about" />
            <!-- Tag mapping: skos:prefLabel -> skos:prefLabel -->
            <xsl:apply-templates select="skos:prefLabel" />
            <!-- Tag mapping: skos:altLabel -> skos:altLabel -->
            <xsl:apply-templates select="skos:altLabel" />
            <!-- Tag mapping: schema:latitude -> wgs84_pos:lat  -->
            <xsl:for-each select="schema:latitude">
              <wgs84_pos:lat>
                <xsl:value-of select="." />
              </wgs84_pos:lat>
            </xsl:for-each>
            <!-- Tag mapping: schema:longitude -> wgs84_pos:long  -->
            <xsl:for-each select="schema:longitude">
              <wgs84_pos:long>
                <xsl:value-of select="." />
              </wgs84_pos:long>
            </xsl:for-each>
            <!-- Tag mapping: skos:scopeNote -> skos:note -->
            <xsl:apply-templates select="skos:scopeNote" />
          </edm:Place>
        </xsl:when>
        <!-- Corporations -> edm:Agent -->
        <xsl:when
          test="rdf:type[@rdf:resource = ('https://data.indischherinneringscentrum.nl/schema/Organization')]">
          <edm:Agent>
            <!-- Attribute mapping: rdf:about -> rdf:about -->
            <xsl:copy-of select="@rdf:about" />
            <!-- Tag mapping: skos:prefLabel -> skos:prefLabel -->
            <xsl:apply-templates select="skos:prefLabel" />
            <!-- Tag mapping: skos:altLabel -> skos:altLabel -->
            <xsl:apply-templates select="skos:altLabel" />
            <!-- Tag mapping: schema:foundingDate | schema:foundingYear -> edm:begin -->
            <xsl:for-each select="(schema:foundingDate | schema:foundingYear) [1]">
              <edm:begin>
                <xsl:value-of select="." />
              </edm:begin>
            </xsl:for-each>
            <!-- Tag mapping: schema:dissolutionDate | schema:dissolutionYear -> edm:end -->
            <xsl:for-each select="(schema:dissolutionDate | schema:dissolutionYear) [1]">
              <edm:end>
                <xsl:value-of select="." />
              </edm:end>
            </xsl:for-each>
            <!-- Tag mapping: skos:scopeNote -> skos:note -->
            <xsl:apply-templates select="skos:scopeNote" />
          </edm:Agent>
        </xsl:when>
        <!-- Events -> edm:TimeSpan -->
        <xsl:when
          test="rdf:type[@rdf:resource = ('https://data.indischherinneringscentrum.nl/schema/Event')]">
          <edm:TimeSpan>
            <!-- Attribute mapping: rdf:about -> rdf:about -->
            <xsl:copy-of select="@rdf:about" />
            <!-- Tag mapping: skos:prefLabel -> skos:prefLabel -->
            <xsl:apply-templates select="skos:prefLabel" />
            <!-- Tag mapping: skos:altLabel -> skos:altLabel -->
            <xsl:apply-templates select="skos:altLabel" />
            <!-- Tag mapping: schema:startDate -> edm:begin  -->
            <xsl:for-each select="schema:startDate">
              <edm:begin>
                <xsl:value-of select="." />
              </edm:begin>
            </xsl:for-each>
            <!-- Tag mapping: schema:endDate -> edm:end  -->
            <xsl:for-each select="schema:endDate">
              <edm:end>
                <xsl:value-of select="." />
              </edm:end>
            </xsl:for-each>
            <!-- Tag mapping: skos:scopeNote -> skos:note -->
            <xsl:apply-templates select="skos:scopeNote" />
          </edm:TimeSpan>
        </xsl:when>
        <!-- All other types -> skos:Concept -->
        <xsl:otherwise>
          <skos:Concept>
            <!-- Attribute mapping: rdf:about -> rdf:about -->
            <xsl:copy-of select="@rdf:about" />
            <!-- Tag mapping: skos:prefLabel -> skos:prefLabel -->
            <xsl:apply-templates select="skos:prefLabel" />
            <!-- Tag mapping: if type ConceptScheme, dcterms:title -> skos:prefLabel -->
            <xsl:if test="rdf:type[@rdf:resource = 'http://www.w3.org/2004/02/skos/core#ConceptScheme']">
              <xsl:apply-templates select="dcterms:title" mode="asPrefLabel"/>
            </xsl:if>
            <!-- Tag mapping: skos:altLabel -> skos:altLabel -->
            <xsl:apply-templates select="skos:altLabel" />
            <!-- Tag mapping: skos:broader -> skos:broader -->
            <xsl:for-each select="skos:broader">
              <skos:broader rdf:resource="{@rdf:resource}" />
            </xsl:for-each>
            <!-- Tag mapping: skos:narrower -> skos:narrower -->
            <xsl:for-each select="skos:narrower">
              <skos:narrower rdf:resource="{@rdf:resource}" />
            </xsl:for-each>
            <!-- Tag mapping: skos:related -> skos:related -->
            <xsl:for-each select="skos:related">
              <skos:related rdf:resource="{@rdf:resource}" />
            </xsl:for-each>
            <!-- Tag mapping: skos:scopeNote -> skos:note -->
            <xsl:apply-templates select="skos:scopeNote" />
          </skos:Concept>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!-- Template for skos:prefLabel, skos:altLabel -->
  <xsl:template match="skos:prefLabel | skos:altLabel">
    <xsl:choose>
      <!-- Option 1: element has xml:lang and it's acceptable -->
      <xsl:when test="@xml:lang and lib:isAcceptableLang(@xml:lang)">
        <xsl:element name="skos:{local-name()}">
          <xsl:copy-of select="@xml:lang" />
          <xsl:value-of select="." />
        </xsl:element>
      </xsl:when>
      <!-- Option 2: element has no xml:lang -->
      <xsl:otherwise>
        <xsl:element name="skos:{local-name()}">
          <xsl:value-of select="." />
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- Template for dcterms:title -> skos:prefLabel (for ConceptScheme) -->
  <xsl:template match="dcterms:title" mode="asPrefLabel">
    <xsl:choose>
      <!-- Option 1: element has xml:lang and it's acceptable -->
      <xsl:when test="@xml:lang and lib:isAcceptableLang(@xml:lang)">
        <skos:prefLabel>
          <xsl:copy-of select="@xml:lang" />
          <xsl:value-of select="." />
        </skos:prefLabel>
      </xsl:when>
      <!-- Option 2: element has no xml:lang -->
      <xsl:otherwise>
        <skos:prefLabel>
          <xsl:value-of select="." />
        </skos:prefLabel>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- Template for skos:note -->
  <xsl:template match="skos:scopeNote">
    <xsl:choose>
      <!-- Option 1: element has xml:lang and it's acceptable -->
      <xsl:when test="@xml:lang and lib:isAcceptableLang(@xml:lang)">
        <xsl:element name="skos:note">
          <xsl:copy-of select="@xml:lang" />
          <xsl:value-of select="." />
        </xsl:element>
      </xsl:when>
      <!-- Option 2: element has no xml:lang -->
      <xsl:otherwise>
        <xsl:element name="skos:note">
          <xsl:value-of select="." />
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--+++++++++++++++++++++++++++++ FUNCTIONS ++++++++++++++++++++++++++++++++-->
  <xsl:function name="lib:isAcceptableLang" as="xs:boolean">
    <xsl:param name="string" />
    <xsl:sequence
      select="$string!='' and contains($langs,lower-case($string))" />
  </xsl:function>
</xsl:stylesheet>