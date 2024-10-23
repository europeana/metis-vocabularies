<?xml version="1.0" encoding="UTF-8"?>
<!--
  Document   : VIAF_updated_v1.3.xsl
  Author     : Masa
  Updated on : September 2024
  Version    : v1.3

  Changes:
  * schema:name elements are mapped to skos:prefLabel (previously used only when skos:prefLabel was unavailable)
  * condition is applied to xml:lang to ensure labels are selected based on a priority rule:
    1) two-letter portal languages (from $code) are prioritised first
    2) if no match is found, regional-code portal languages (from $langs) are considered next
    3) finally, if still unmatched, regional languages (from $regionalLangs) are used as a fallback
-->
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:schema="http://schema.org/"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:edm="http://www.europeana.eu/schemas/edm/"
    xmlns:dbo="http://dbpedia.org/ontology/"
    xmlns:rdagr2="http://rdvocab.info/ElementsGr2/"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xsl xs">
  <xsl:output indent="yes" encoding="UTF-8" />
  <xsl:param name="targetId" />
  <!-- Lists of acceptable languages -->
  <xsl:param name="code">en,pl,de,nl,fr,it,da,sv,el,fi,hu,cs,sl,et,pt,es,lt,lv,bg,ro,sk,hr,ga,mt,no,ca,ru,eu</xsl:param>
  <xsl:param name="langs">en-GB,nl-NL,fr-FR,de-DE,es-ES,sv-SE,it-IT,fi-FI,da-DK,el-GR,cs-CZ,sk-SK,sl-SI,pt-PT,hu-HU,lt-LT,pl-PL,ro-RO,bg-BG,hr-HR,lv-LV,ga-IE,mt-MT,et-EE,no-NO,ca-ES,ru-RU,eu-ES</xsl:param>
  <xsl:param name="regionalLangs">en-US,en-AU,en-CA,en-IL,en-KR,fr-BE,fr-CA,fr-CH,de-x-std,es-AR,es-BO,es-VE,es-CL,es-CO,es-CR,es-DO,es-EC,es-SV,es-GT,es-HN,es-MX,es-NI,es-CU,it-VA,el-latn,pt-BR</xsl:param>

  <!-- MAIN TEMPLATE -->
  <xsl:template match="/rdf:RDF">
    <!-- Parent mapping: schema:Person -> edm:Agent -->
    <xsl:for-each select=".//schema:Person">
      <xsl:if test="@rdf:about=$targetId">
        <edm:Agent>
          <!-- Attribute mapping: rdf:about -> rdf:about -->
          <xsl:copy-of select="@rdf:about" />
          <!-- Tag mapping: schema:name -> skos:prefLabel -->
          <xsl:call-template name="process-labels">
            <xsl:with-param name="labels" select="schema:name" />
            <xsl:with-param name="element-name" select="'skos:prefLabel'" />
          </xsl:call-template>
          <!-- Tag mapping: schema:alternateName -> skos:altLabel -->
          <xsl:call-template name="process-labels">
            <xsl:with-param name="labels" select="schema:alternateName" />
            <xsl:with-param name="element-name" select="'skos:altLabel'" />
          </xsl:call-template>
          <!-- Tag mapping: schema:birthDate -> rdagr2:dateOfBirth -->
          <xsl:apply-templates select="schema:birthDate" />
          <!-- Tag mapping: schema:deathDate -> rdagr2:dateOfDeath -->
          <xsl:apply-templates select="schema:deathDate" />
          <!-- Tag mapping: schema:sameAs -> owl:sameAs -->
          <xsl:apply-templates select="schema:sameAs" />
          <!-- Tag mapping: schema:description -> skos:note -->
          <xsl:apply-templates select="schema:description" />
          <!-- Tag mapping: dbo:notableWork -> edm:hasMet -->
          <xsl:apply-templates select="dbo:notableWork" />
        </edm:Agent>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- OTHER TEMPLATES -->
  <!-- Template for skos:prefLabel and skos:altLabel -->
  <xsl:template name="process-labels">
    <xsl:param name="labels" />
    <xsl:param name="element-name" />
    <!-- Grouping languages by the first two characters of @xml:lang, as VIAF uses 2-letter codes and applies the same approach for regional language variations -->
    <xsl:for-each-group select="$labels" group-by="substring(@xml:lang, 1, 2)">
      <xsl:variable name="group-lang" select="current-grouping-key()" />
      <!-- Selecting one label from each group based on priority rules -->
      <xsl:variable name="selected-label" select="
       (current-group()[@xml:lang = tokenize($code, ',')],
       current-group()[@xml:lang = tokenize($langs, ',')[starts-with(., $group-lang)]],
       current-group()[@xml:lang = tokenize($regionalLangs, ',')[starts-with(., $group-lang)]])[1]" />
      <xsl:if test="$selected-label">
        <xsl:element name="{$element-name}">
          <xsl:copy-of select="$selected-label/@xml:lang" />
          <xsl:value-of select="$selected-label" />
        </xsl:element>
      </xsl:if>
    </xsl:for-each-group>
  </xsl:template>
  <!-- Template for rdagr2:dateOfBirth -->
  <xsl:template match="schema:birthDate">
    <xsl:element name="rdagr2:dateOfBirth">
      <xsl:copy-of select="text()" />
    </xsl:element>
  </xsl:template>
  <!-- Template for rdagr2:dateOfDeath -->
  <xsl:template match="schema:deathDate">
    <xsl:element name="rdagr2:dateOfDeath">
      <xsl:copy-of select="text()" />
    </xsl:element>
  </xsl:template>
  <!-- Template for owl:sameAs -->
  <xsl:template match="schema:sameAs">
    <xsl:element name="owl:sameAs">
      <xsl:copy-of select="@rdf:resource" />
    </xsl:element>
  </xsl:template>
  <!-- Template for skos:note -->
  <xsl:template match="schema:description">
    <xsl:element name="skos:note">
      <xsl:copy-of select="text()" />
    </xsl:element>
  </xsl:template>
  <!-- Template for edm:hasMet -->
  <xsl:template match="dbo:notableWork/rdf:Description">
    <xsl:element name="edm:hasMet">
      <xsl:attribute name="rdf:resource">
        <xsl:value-of select="@rdf:about"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>