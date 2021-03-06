<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:gvp="http://vocab.getty.edu/ontology#"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  >

  <xsl:param name="targetId"></xsl:param>
  <xsl:output indent="yes" encoding="UTF-8"></xsl:output>
  
  <xsl:template match="/rdf:RDF">
    <!-- Parent mapping: gvp:Subject -> skos:Concept -->
    <xsl:for-each select="./gvp:Subject">
      <xsl:if test="@rdf:about=$targetId">
        <skos:Concept>
          <!-- Attribute mapping: rdf:about -> rdf:about -->
          <xsl:if test="@rdf:about">
            <xsl:attribute name="rdf:about">
              <xsl:value-of select="@rdf:about"></xsl:value-of>
            </xsl:attribute>
          </xsl:if>
          <!-- Tag mapping: skos:narrower -> skos:narrower -->
          <xsl:for-each select="./skos:narrower">
            <skos:narrower>
              <!-- Attribute mapping: rdf:resource -> rdf:resource -->
              <xsl:if test="@rdf:resource">
                <xsl:attribute name="rdf:resource">
                  <xsl:value-of select="@rdf:resource"></xsl:value-of>
                </xsl:attribute>
              </xsl:if>
              <!-- Certain skos relations may be defined in a skos:Concept sub-tag. -->
              <xsl:if test="not (@rdf:resource) and ./skos:Concept[@rdf:about]">
                <xsl:attribute name="rdf:resource">
                  <xsl:value-of select="(./skos:Concept[@rdf:about])[1]/@rdf:about"></xsl:value-of>
                </xsl:attribute>
              </xsl:if>
              <!-- Text content mapping (only content with non-space characters) -->
              <xsl:for-each select="text()[normalize-space()]">
                <xsl:if test="position() &gt; 1">
                  <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:value-of select="normalize-space(.)"></xsl:value-of>
              </xsl:for-each>
            </skos:narrower>
          </xsl:for-each>
          <!-- Tag mapping: skos:broader -> skos:broader -->
          <xsl:for-each select="./skos:broader">
            <skos:broader>
              <!-- Attribute mapping: rdf:resource -> rdf:resource -->
              <xsl:if test="@rdf:resource">
                <xsl:attribute name="rdf:resource">
                  <xsl:value-of select="@rdf:resource"></xsl:value-of>
                </xsl:attribute>
              </xsl:if>
              <!-- Certain skos relations may be defined in a skos:Concept sub-tag. -->
              <xsl:if test="not (@rdf:resource) and ./skos:Concept[@rdf:about]">
                <xsl:attribute name="rdf:resource">
                  <xsl:value-of select="(./skos:Concept[@rdf:about])[1]/@rdf:about"></xsl:value-of>
                </xsl:attribute>
              </xsl:if>
              <!-- Text content mapping (only content with non-space characters) -->
              <xsl:for-each select="text()[normalize-space()]">
                <xsl:if test="position() &gt; 1">
                  <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:value-of select="normalize-space(.)"></xsl:value-of>
              </xsl:for-each>
            </skos:broader>
          </xsl:for-each>
          <!-- Tag mapping: skos:inScheme -> skos:inScheme -->
          <xsl:for-each select="./skos:inScheme">
            <skos:inScheme>
              <!-- Attribute mapping: rdf:resource -> rdf:resource -->
              <xsl:if test="@rdf:resource">
                <xsl:attribute name="rdf:resource">
                  <xsl:value-of select="@rdf:resource"></xsl:value-of>
                </xsl:attribute>
              </xsl:if>
              <!-- Text content mapping (only content with non-space characters) -->
              <xsl:for-each select="text()[normalize-space()]">
                <xsl:if test="position() &gt; 1">
                  <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:value-of select="normalize-space(.)"></xsl:value-of>
              </xsl:for-each>
            </skos:inScheme>
          </xsl:for-each>
          <!-- Tag mapping: skos:related -> skos:related -->
          <xsl:for-each select="./skos:related">
            <skos:related>
              <!-- Attribute mapping: rdf:resource -> rdf:resource -->
              <xsl:if test="@rdf:resource">
                <xsl:attribute name="rdf:resource">
                  <xsl:value-of select="@rdf:resource"></xsl:value-of>
                </xsl:attribute>
              </xsl:if>
              <!-- Certain skos relations may be defined in a skos:Concept sub-tag. -->
              <xsl:if test="not (@rdf:resource) and ./skos:Concept[@rdf:about]">
                <xsl:attribute name="rdf:resource">
                  <xsl:value-of select="(./skos:Concept[@rdf:about])[1]/@rdf:about"></xsl:value-of>
                </xsl:attribute>
              </xsl:if>
              <!-- Text content mapping (only content with non-space characters) -->
              <xsl:for-each select="text()[normalize-space()]">
                <xsl:if test="position() &gt; 1">
                  <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:value-of select="normalize-space(.)"></xsl:value-of>
              </xsl:for-each>
            </skos:related>
          </xsl:for-each>

          <!-- Tag mapping: skos:note -> skos:note -->
          <xsl:apply-templates select="skos:note"/>

		  <!-- Tag mapping: skos:altLabel -> skos:altLabel -->
          <xsl:for-each select="./skos:altLabel">
            <skos:altLabel>
              <!-- Attribute mapping: xml:lang -> xml:lang -->
              <xsl:if test="@xml:lang">
                <xsl:attribute name="xml:lang">
                  <xsl:value-of select="@xml:lang"></xsl:value-of>
                </xsl:attribute>
              </xsl:if>
              <!-- Text content mapping (only content with non-space characters) -->
              <xsl:for-each select="text()[normalize-space()]">
                <xsl:if test="position() &gt; 1">
                  <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:value-of select="normalize-space(.)"></xsl:value-of>
              </xsl:for-each>
            </skos:altLabel>
          </xsl:for-each>
          <!-- Tag mapping: skos:prefLabel -> skos:prefLabel -->
          <xsl:for-each select="./skos:prefLabel">
            <skos:prefLabel>
              <!-- Attribute mapping: xml:lang -> xml:lang -->
              <xsl:if test="@xml:lang">
                <xsl:attribute name="xml:lang">
                  <xsl:value-of select="@xml:lang"></xsl:value-of>
                </xsl:attribute>
              </xsl:if>
              <!-- Text content mapping (only content with non-space characters) -->
              <xsl:for-each select="text()[normalize-space()]">
                <xsl:if test="position() &gt; 1">
                  <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:value-of select="normalize-space(.)"></xsl:value-of>
              </xsl:for-each>
            </skos:prefLabel>
          </xsl:for-each>
        </skos:Concept>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="skos:note">
	<xsl:variable name="text" select="normalize-space(text())"/>
    <xsl:choose>
	  <xsl:when test="@rdf:resource">
	    <xsl:variable name="uri" select="@rdf:resource"/>
		<xsl:for-each select="/rdf:RDF/gvp:ScopeNote[@rdf:about=$uri]/rdf:value">
		  <skos:note>
			<xsl:copy-of select="@xml:lang"/>
			<xsl:value-of select="normalize-space(text())"/>
		  </skos:note>
		</xsl:for-each>
	  </xsl:when>
	  <xsl:when test="$text">
		  <skos:note>
			<xsl:copy-of select="@xml:lang"/>
			<xsl:value-of select="$text"/>
		  </skos:note>
	  </xsl:when>
	</xsl:choose>
  </xsl:template>

<!--
  <xsl:template match="skos:note">
    <xsl:choose>
	  <xsl:when test="@rdf:resource">
	    <xsl:variable name="uri" select="@rdf:resource"/>
	    <xsl:variable name="doc" select="document(concat($uri,'.rdf'))"/>
		<xsl:for-each select="$doc/rdf:RDF/gvp:ScopeNote[@rdf:about=$uri]/rdf:value">
		  <skos:note>
			<xsl:copy-of select="@xml:lang"/>
			<xsl:value-of select="normalize-space(text())"/>
		  </skos:note>
		</xsl:for-each>
	  </xsl:when>
	  <xsl:when test="text()">
		  <skos:note>
			<xsl:copy-of select="@xml:lang"/>
			<xsl:value-of select="normalize-space(text())"/>
		  </skos:note>
	  </xsl:when>
	</xsl:choose>
  </xsl:template>
 -->

</xsl:stylesheet>