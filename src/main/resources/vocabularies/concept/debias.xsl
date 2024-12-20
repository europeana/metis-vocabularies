<?xml version="1.0" encoding="UTF-8"?>
<!--
  Document   : debias2concept.xsl
  Author     : Hugo
  Created on : 13.12.2024
  Updated on : 13.12.2024
  Version    : 1.0

Changes:
-->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"

  xmlns:debias="http://data.europa.eu/c4p/ontology#"
  xmlns:dct="http://purl.org/dc/terms/"
  xmlns:euvoc="http://publications.europa.eu/ontology/euvoc#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:skosxl="http://www.w3.org/2008/05/skos-xl#"

  xmlns:lib="http://example.org/lib"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"

  exclude-result-prefixes="debias dct euvoc owl skosxl">

  <xsl:param name="targetId"/>
  <xsl:param name="fast" select="false()"/>

  <xsl:output indent="yes" encoding="UTF-8"/>

  <xsl:template match="rdf:RDF">
    <xsl:choose>
      <xsl:when test='$fast'>
        <xsl:apply-templates select="/rdf:RDF/skos:Concept[@rdf:about = $targetId]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="//skos:Concept[@rdf:about = $targetId]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="skos:Concept">
    <skos:Concept>

      <xsl:copy-of select="@rdf:about"/>

      <!-- skos:prefLabel -->
      <xsl:for-each select="dct:title">
        <skos:prefLabel>
          <xsl:copy-of select="@xml:lang"/>
          <xsl:copy-of select="text()"/>
        </skos:prefLabel>
      </xsl:for-each>

      <!-- skos:altLabel  -->
      <xsl:for-each select="debias:hasSuggestedTerm">
        <xsl:choose>
          <xsl:when test="@rdf:resource">
            <xsl:variable name="ref" select="@rdf:resource"/>
            <xsl:choose>
              <xsl:when test='$fast'>
                <xsl:apply-templates select="/rdf:RDF/debias:SuggestedTerm[@rdf:about=$ref]"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="//debias:SuggestedTerm[@rdf:about=$ref]"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="debias:SuggestedTerm"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>

      <!-- skos:hiddenLabel  -->
      <xsl:for-each select="debias:hasContentiousTerm">
        <xsl:choose>
          <xsl:when test="@rdf:resource">
            <xsl:variable name="ref" select="@rdf:resource"/>
            <xsl:choose>
              <xsl:when test='$fast'>
                <xsl:apply-templates select="/rdf:RDF/debias:ContentiousTerm[@rdf:about=$ref]"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="//debias:ContentiousTerm[@rdf:about=$ref]"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="debias:ContentiousTerm"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>

      <!-- skos:definition -->
      <xsl:for-each select="dct:description">
        <skos:definition>
          <xsl:copy-of select="@xml:lang"/>
          <xsl:copy-of select="text()"/>
        </skos:definition>
      </xsl:for-each>

      <!--  skos:scopeNote -->
      <!-- debias:hasContentiousTerm / debias:hasSuggestionNote / rdf:value -->
      <xsl:variable name="scopeNotes">
        <xsl:for-each select="debias:hasContentiousTerm">
          <xsl:choose>
            <xsl:when test="@rdf:resource">
              <xsl:variable name="ref" select="@rdf:resource"/>
              <xsl:choose>
                <xsl:when test='$fast'>
                  <xsl:apply-templates mode="scopeNote" select="/rdf:RDF/debias:ContentiousTerm[@rdf:about=$ref]"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates mode="scopeNote" select="//debias:ContentiousTerm[@rdf:about=$ref]"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates mode="scopeNote" select="debias:ContentiousTerm"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="scopeNotesSorted">
        <xsl:for-each select="$scopeNotes/skos:scopeNote">
          <xsl:sort select="@xml:lang"/>
          <xsl:sort select="text()"/>
          <xsl:copy-of select="."/>
        </xsl:for-each>
      </xsl:variable>
      <xsl:for-each select="$scopeNotesSorted/skos:scopeNote">
        <xsl:variable name="pos" select="position()"/>
        <xsl:if test="$pos = 1 or not(lib:sameLiteral(.,$scopeNotesSorted/skos:scopeNote[$pos -1]))">
          <xsl:copy-of select="."/>
        </xsl:if>
      </xsl:for-each>

      <!-- skos:note -->
      <xsl:for-each select="dct:source">
        <skos:note>
          <xsl:copy-of select="@xml:lang"/>
          <xsl:copy-of select="text()"/>
        </skos:note>
      </xsl:for-each>

      <!-- skos:inScheme -->
      <xsl:copy-of select="skos:inScheme" copy-namespaces="no"/>

    </skos:Concept>

  </xsl:template>


  <xsl:template match="debias:ContentiousTerm">
    <xsl:for-each select="skosxl:literalForm">
      <skos:hiddenLabel>
        <xsl:copy-of select="@xml:lang"/>
        <xsl:copy-of select="text()"/>
      </skos:hiddenLabel>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="debias:SuggestedTerm">
    <xsl:for-each select="skosxl:literalForm">
      <skos:altLabel>
        <xsl:copy-of select="@xml:lang"/>
        <xsl:copy-of select="text()"/>
      </skos:altLabel>
    </xsl:for-each>
  </xsl:template>

  <!-- debias:hasContentiousTerm / debias:hasSuggestionNote / rdf:value -->
  <xsl:template match="debias:ContentiousTerm" mode="scopeNote">
    <xsl:for-each select="debias:hasSuggestionNote">
      <xsl:choose>
        <xsl:when test="@rdf:resource">
          <xsl:variable name="ref" select="@rdf:resource"/>
          <xsl:choose>
            <xsl:when test='$fast'>
              <xsl:apply-templates mode="scopeNote" select="/rdf:RDF/debias:SuggestionNote[@rdf:about=$ref]"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates mode="scopeNote" select="//debias:SuggestionNote[@rdf:about=$ref]"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="scopeNote" select="debias:SuggestionNote"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="debias:SuggestionNote" mode="scopeNote">
    <xsl:for-each select="rdf:value">
      <skos:scopeNote>
        <xsl:copy-of select="@xml:lang"/>
        <xsl:copy-of select="text()"/>
      </skos:scopeNote>
    </xsl:for-each>
  </xsl:template>

  <xsl:function name="lib:sameLiteral" as="xs:boolean">
    <xsl:param name="elem1"/>
    <xsl:param name="elem2"/>
    <xsl:sequence select="($elem1/@xml:lang=$elem2/@xml:lang) and ($elem1/text()=$elem2/text())"/>
  </xsl:function>

</xsl:stylesheet>