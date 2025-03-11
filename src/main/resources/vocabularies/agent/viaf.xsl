<?xml version="1.0" encoding="UTF-8"?>
<!--
  Document   : VIAF_updated_v1.4.xsl
  Author     : Masa
  Updated on : February 2025
  Version    : v1.4

  Changes:
  * schema:name elements are mapped to skos:prefLabel (previously used only when skos:prefLabel was unavailable)
  * a condition is applied to xml:lang to ensure labels are selected based on a specific hierarchy of language relevance:
    1) two-letter portal languages (defined by the $code parameter) are prioritised first
    2) if no match is found, regional-code portal languages (from $langs) are considered next
    3) finally, if still unmatched, regional languages (from $regionalLangs) are used as a fallback
  * template for edm:Agent is expanded to include rdf:Description with rdf:type set to 'http://schema.org/Person'
  * template for owl:sameAs is expanded with nested handling for cases where rdf:Description contains @rdf:about that is relevant
  * template for skos:note is updated to include only values in languages defined by the $code and $langs parameters,
    ensuring that duplicate entries for the same language are excluded
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
  xmlns:gvp="http://vocab.getty.edu/oxmlns:ntology#"
  xmlns:lib="http://example.org/lib"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xsl gvp lib xs">
  <xsl:output indent="yes" encoding="UTF-8" />

  <!-- PARAMETERS -->
  <xsl:param name="targetId" />
  <!-- Lists of acceptable languages -->
  <xsl:param name="code">en,pl,de,nl,fr,it,da,sv,el,fi,hu,cs,sl,et,pt,es,lt,lv,bg,ro,sk,hr,ga,mt,no,ca,ru,eu</xsl:param>
  <xsl:param name="langs">en-GB,nl-NL,fr-FR,de-DE,es-ES,sv-SE,it-IT,fi-FI,da-DK,el-GR,cs-CZ,sk-SK,sl-SI,pt-PT,hu-HU,lt-LT,pl-PL,ro-RO,bg-BG,hr-HR,lv-LV,ga-IE,mt-MT,et-EE,no-NO,ca-ES,ru-RU,eu-ES</xsl:param>
  <xsl:param name="regionalLangs">en-US,en-AU,en-CA,en-IL,en-KR,fr-BE,fr-CA,fr-CH,de-x-std,es-AR,es-BO,es-VE,es-CL,es-CO,es-CR,es-DO,es-EC,es-SV,es-GT,es-HN,es-MX,es-NI,es-CU,it-VA,el-latn,pt-BR</xsl:param>

  <!-- MAIN TEMPLATE -->
  <xsl:template match="/rdf:RDF">
    <!-- Parent mapping: schema:Person -> edm:Agent -->
    <xsl:for-each select=".//schema:Person | .//rdf:Description[rdf:type/@rdf:resource='http://schema.org/Person']">
      <xsl:if test="@rdf:about=$targetId">
        <edm:Agent>
          <!-- Attribute mapping: rdf:about -> rdf:about -->
          <xsl:copy-of select="@rdf:about" />
          <!-- Tag mapping: schema:name -> skos:prefLabel -->
          <xsl:apply-templates select="schema:name" />
          <!-- Tag mapping: schema:alternateName -> skos:altLabel -->
          <xsl:apply-templates select="schema:alternateName" />
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
  <!-- Template for skos:prefLabel -->
  <xsl:template match="schema:name">
    <xsl:variable name="currentLang" select="@xml:lang" />
    <xsl:variable name="twoLetterCode" select="substring($currentLang, 1, 2)" />
    <xsl:variable name="matchingLabels" select="../schema:name[lib:isMatchingLang(@xml:lang, $code, $langs, $regionalLangs)]" />
    <xsl:variable name="sameGroupLabels" select="$matchingLabels[substring(@xml:lang, 1, 2) = $twoLetterCode]" />
    <xsl:choose>
      <!-- Check if there's a match with the two-letter portal languages ($code) -->
      <xsl:when test="$sameGroupLabels[lib:isMatchingLang(@xml:lang, $code, '', '')]">
        <xsl:if test="generate-id() = generate-id($sameGroupLabels[lib:isMatchingLang(@xml:lang, $code, '', '')][1])">
          <xsl:element name="skos:prefLabel">
            <xsl:copy-of select="@xml:lang" />
            <xsl:copy-of select="text()" />
          </xsl:element>
        </xsl:if>
      </xsl:when>
      <!-- Check if there's a match with the regional-code portal languages ($langs) -->
      <xsl:when test="$sameGroupLabels[lib:isMatchingLang(@xml:lang, '', $langs, '')]">
        <xsl:if test="generate-id() = generate-id($sameGroupLabels[lib:isMatchingLang(@xml:lang, '', $langs, '')][1])">
          <xsl:element name="skos:prefLabel">
            <xsl:copy-of select="@xml:lang" />
            <xsl:copy-of select="text()" />
          </xsl:element>
        </xsl:if>
      </xsl:when>
      <!-- Fall back to regional languages -->
      <xsl:otherwise>
        <xsl:if test="generate-id() = generate-id($sameGroupLabels[lib:isMatchingLang(@xml:lang, '', '', $regionalLangs)][1])">
          <xsl:element name="skos:prefLabel">
            <xsl:copy-of select="@xml:lang" />
            <xsl:copy-of select="text()" />
          </xsl:element>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- Template for skos:altLabel -->
  <xsl:template match="schema:alternateName">
    <xsl:variable name="currentLang" select="@xml:lang" />
    <xsl:variable name="twoLetterCode" select="substring($currentLang, 1, 2)" />
    <xsl:variable name="matchingLabels" select="../schema:alternateName[lib:isMatchingLang(@xml:lang, $code, $langs, $regionalLangs)]" />
    <xsl:variable name="sameGroupLabels" select="$matchingLabels[substring(@xml:lang, 1, 2) = $twoLetterCode]" />
    <xsl:choose>
      <!-- Check if there's a match with the two-letter portal languages ($code) -->
      <xsl:when test="$sameGroupLabels[lib:isMatchingLang(@xml:lang, $code, '', '')]">
        <xsl:if test="generate-id() = generate-id($sameGroupLabels[lib:isMatchingLang(@xml:lang, $code, '', '')][1])">
          <xsl:element name="skos:altLabel">
            <xsl:copy-of select="@xml:lang" />
            <xsl:copy-of select="text()" />
          </xsl:element>
        </xsl:if>
      </xsl:when>
      <!-- Check if there's a match with the regional-code portal languages ($langs) -->
      <xsl:when test="$sameGroupLabels[lib:isMatchingLang(@xml:lang, '', $langs, '')]">
        <xsl:if test="generate-id() = generate-id($sameGroupLabels[lib:isMatchingLang(@xml:lang, '', $langs, '')][1])">
          <xsl:element name="skos:altLabel">
            <xsl:copy-of select="@xml:lang" />
            <xsl:copy-of select="text()" />
          </xsl:element>
        </xsl:if>
      </xsl:when>
      <!-- Fall back to regional languages -->
      <xsl:otherwise>
        <xsl:if test="generate-id() = generate-id($sameGroupLabels[lib:isMatchingLang(@xml:lang, '', '', $regionalLangs)][1])">
          <xsl:element name="skos:altLabel">
            <xsl:copy-of select="@xml:lang" />
            <xsl:copy-of select="text()" />
          </xsl:element>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
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
      <!-- Handle rdf:resource attribute directly -->
      <xsl:choose>
        <xsl:when test="@rdf:resource">
          <xsl:attribute name="rdf:resource">
            <xsl:value-of select="@rdf:resource"/>
          </xsl:attribute>
        </xsl:when>
        <!-- Handle nested rdf:Description with rdf:about -->
        <xsl:when test="rdf:Description/@rdf:about">
          <xsl:attribute name="rdf:resource">
            <xsl:value-of select="rdf:Description/@rdf:about"/>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
  <!-- Template for skos:note -->
  <xsl:template match="schema:description">
    <xsl:variable name="currentLang" select="@xml:lang" />
    <xsl:choose>
      <!-- Check if @xml:lang is not empty, matches $code or $langs, and is the first instance per language -->
      <xsl:when test="$currentLang and lib:isMatchingLang($currentLang, $code, $langs, '') and generate-id() = generate-id(../schema:description[@xml:lang = $currentLang][1])">
        <xsl:element name="skos:note">
          <xsl:copy-of select="@xml:lang" />
          <xsl:copy-of select="text()" />
        </xsl:element>
      </xsl:when>
      <!-- If the condition is not met, do nothing -->
      <xsl:otherwise />
    </xsl:choose>
  </xsl:template>
  <!-- Template for edm:hasMet -->
  <xsl:template match="dbo:notableWork/rdf:Description">
    <xsl:element name="edm:hasMet">
      <xsl:attribute name="rdf:resource">
        <xsl:value-of select="@rdf:about"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
  <!--+++++++++++++++++++++++++++++ FUNCTIONS ++++++++++++++++++++++++++++++++-->
  <xsl:function name="lib:isMatchingLang" as="xs:boolean">
    <xsl:param name="lang" />
    <xsl:param name="code" />
    <xsl:param name="langs" />
    <xsl:param name="regionalLangs" />
    <!-- Check if the language is either portal supported or in one of the additional regional languages -->
    <xsl:sequence select="contains(concat(',', $code, ','), concat(',', $lang, ',')) or contains(concat(',', $langs, ','), concat(',', $lang, ',')) or contains(concat(',', $regionalLangs, ','), concat(',', $lang, ','))" />
  </xsl:function>
</xsl:stylesheet>