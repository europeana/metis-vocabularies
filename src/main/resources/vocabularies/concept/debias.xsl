<?xml version="1.0" encoding="UTF-8"?>
<!--
  Document   : debias2concept.xsl
  Author     : Hugo Manguinhas
  Created on : ?
  Updated on : 21.03.2025
  Version    : v1.3

Changes:
* support for external dereferencing
* generalised scanning for resources
* support for dereferencing of contentious terms as issues
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

  <xsl:output indent="yes" encoding="UTF-8"/>

  <xsl:template match="rdf:RDF">
    <xsl:variable name="root" select="/rdf:RDF"/>
    <xsl:variable name="node" select="lib:findResource($targetId,$root)"/>
    <xsl:choose>
      <xsl:when test="lib:isContentiousTerm($node)">
        <xsl:apply-templates select="lib:getResource($node/debias:hasContentiousIssue,$root)" mode="issue"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$node" mode="issue"/>
      </xsl:otherwise>
    </xsl:choose>


  </xsl:template>

  <xsl:template match="skos:Concept | rdf:Description" mode="issue">

    <skos:Concept>

      <xsl:attribute name="rdf:about" select="$targetId"/>

      <!-- skos:prefLabel -->
      <xsl:for-each select="dct:title">
        <skos:prefLabel>
          <xsl:copy-of select="@xml:lang"/>
          <xsl:copy-of select="text()"/>
        </skos:prefLabel>
      </xsl:for-each>

      <!-- skos:altLabel  -->
      <xsl:for-each select="debias:hasSuggestedTerm">
        <xsl:apply-templates select="lib:getResource(.,/rdf:RDF)"
          mode="sterm"/>
      </xsl:for-each>

      <!-- skos:hiddenLabel  -->
      <xsl:for-each select="debias:hasContentiousTerm">
        <xsl:apply-templates select="lib:getResource(.,/rdf:RDF)"
          mode="cterm"/>
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
          <xsl:variable name="contentiousTerm" select="lib:getResource(.,/rdf:RDF)"/>
          <xsl:for-each select="$contentiousTerm/debias:hasSuggestionNote">
            <xsl:variable name="suggestedTerm" select="lib:getResource(.,/rdf:RDF)"/>
            <xsl:for-each select="$suggestedTerm/rdf:value">
              <skos:scopeNote>
                <xsl:copy-of select="@xml:lang"/>
                <xsl:copy-of select="text()"/>
              </skos:scopeNote>
            </xsl:for-each>
          </xsl:for-each>
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


  <xsl:template match="debias:ContentiousTerm | rdf:Description" mode="cterm">
    <xsl:for-each select="skosxl:literalForm">
      <skos:hiddenLabel>
        <xsl:copy-of select="@xml:lang"/>
        <xsl:copy-of select="text()"/>
      </skos:hiddenLabel>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="debias:SuggestedTerm | rdf:Description" mode="sterm">
    <xsl:for-each select="skosxl:literalForm">
      <skos:altLabel>
        <xsl:copy-of select="@xml:lang"/>
        <xsl:copy-of select="text()"/>
      </skos:altLabel>
    </xsl:for-each>
  </xsl:template>


  <xsl:function name="lib:sameLiteral" as="xs:boolean">
    <xsl:param name="elem1"/>
    <xsl:param name="elem2"/>
    <xsl:sequence select="($elem1/@xml:lang=$elem2/@xml:lang) and ($elem1/text()=$elem2/text())"/>
  </xsl:function>

  <xsl:function name="lib:isContentiousTerm" as="xs:boolean">
    <xsl:param name="elem"/>

    <xsl:sequence select="($elem/name()='ContentiousTerm')
                           or ($elem/rdf:type/@rdf:resource='http://data.europa.eu/c4p/ontology#ContentiousTerm')"/>
  </xsl:function>

  <xsl:function name="lib:getResource">
    <xsl:param name="elem"/>
    <xsl:param name="root"/>

    <xsl:variable name="ref" select="$elem/@rdf:resource"/>
    <xsl:choose>
      <xsl:when test="$ref">
        <xsl:variable name="res" select="lib:findResource($ref,$root)"/>
        <xsl:choose>
          <xsl:when test='not($res)'>
            <xsl:sequence select="lib:getResourceExternal($ref)"/>
          </xsl:when>
          <xsl:when test='$res/rdf:type'>
            <xsl:sequence select="$res"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:sequence select="lib:getResourceExternal($res/@rdf:about)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="$elem/*"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="lib:findResource" as="node()*">
    <xsl:param name="ref"/>
    <xsl:param name="root"/>

    <xsl:variable name="res" select="$root/*[@rdf:about=$ref]"/>
    <xsl:choose>
      <xsl:when test='$res'>
        <xsl:sequence select="$res"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="$root//*[@rdf:about=$ref]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="lib:getResourceExternal">
    <xsl:param name="ref"/>

    <xsl:variable name="doc" select="document(lib:fixURL($ref))"/>
    <xsl:sequence select="lib:findResource($ref,$doc/rdf:RDF)"/>
  </xsl:function>

  <xsl:function name="lib:fixURL" as="xs:string">
    <xsl:param name="ref"/>
    <xsl:value-of select="replace($ref, 'http://data.europa.eu/c4p/data/'
                                          , 'https://publications.europa.eu/resource/authority/c4p/data/')"/>
  </xsl:function>

</xsl:stylesheet>