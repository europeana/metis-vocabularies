<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:schema="http://schema.org/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:edm="http://www.europeana.eu/schemas/edm/" xmlns:rdagr2="http://rdvocab.info/ElementsGr2/"
  xmlns:dbo="http://dbpedia.org/ontology/">
  <xsl:param name="targetId"></xsl:param>
  <xsl:output indent="yes" encoding="UTF-8"/>


  <xsl:template match="/rdf:RDF">

    <xsl:for-each select="./rdf:Description[@rdf:about=$targetId]">  <!--73857542 ; 90013374-->
      <xsl:if test="rdf:type/@rdf:resource[.='http://schema.org/Person']">
        <!-- Parent mapping: rdf:Description -> edm:Agent -->
        <edm:Agent>
          <!-- Attribute mapping: rdf:about -> rdf:about -->
          <xsl:if test="@rdf:about">
            <xsl:attribute name="rdf:about">
              <xsl:value-of select="@rdf:about"/>
            </xsl:attribute>
          </xsl:if>


          <!-- Tag mapping: skos:prefLabel -> skos:prefLabel OR if not available: schema:name -> skos:prefLabel-->
          <xsl:choose>
            <xsl:when test="./skos:prefLabel">
              <xsl:for-each select="./skos:prefLabel">
                <skos:prefLabel>
                  <!-- Attribute mapping: xml:lang -> xml:lang -->
                  <xsl:if test="@xml:lang">
                    <xsl:attribute name="xml:lang">
                      <xsl:value-of select="@xml:lang"/>
                    </xsl:attribute>
                  </xsl:if>
                  <!-- Text content mapping (only content with non-space characters) -->
                  <xsl:for-each select="text()[normalize-space()]">
                    <xsl:if test="position() &gt; 1">
                      <xsl:text> </xsl:text>
                    </xsl:if>
                    <xsl:value-of select="normalize-space(.)"/>
                  </xsl:for-each>
                </skos:prefLabel>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="./schema:name">
                <skos:prefLabel>
                  <!-- Attribute mapping: xml:lang -> xml:lang -->
                  <xsl:if test="@xml:lang">
                    <xsl:attribute name="xml:lang">
                      <xsl:value-of select="@xml:lang"/>
                    </xsl:attribute>
                  </xsl:if>
                  <!-- Text content mapping (only content with non-space characters) -->
                  <xsl:for-each select="text()[normalize-space()]">
                    <xsl:if test="position() &gt; 1">
                      <xsl:text> </xsl:text>
                    </xsl:if>
                    <xsl:value-of select="normalize-space(.)"/>
                  </xsl:for-each>
                </skos:prefLabel>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>


          <!-- Tag mapping: schema:alternateName -> skos:altLabel -->
          <xsl:for-each select="./schema:alternateName">
            <skos:altLabel>
              <!-- Text content mapping (only content with non-space characters) -->
              <xsl:for-each select="text()[normalize-space()]">
                <xsl:if test="position() &gt; 1">
                  <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:value-of select="normalize-space(.)"/>
              </xsl:for-each>
            </skos:altLabel>
          </xsl:for-each>

          <!-- Tag mapping: schema:birthDate -> rdagr2:dateOfBirth -->
          <xsl:for-each select="./schema:birthDate">
            <rdagr2:dateOfBirth>
              <!-- Text content mapping (only content with non-space characters) -->
              <xsl:for-each select="text()[normalize-space()]">
                <xsl:if test="position() &gt; 1">
                  <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:value-of select="normalize-space(.)"/>
              </xsl:for-each>
            </rdagr2:dateOfBirth>
          </xsl:for-each>

          <!-- Tag mapping: schema:deathDate -> rdagr2:dateOfDeath -->
          <xsl:for-each select="./schema:deathDate">
            <rdagr2:dateOfDeath>
              <!-- Text content mapping (only content with non-space characters) -->
              <xsl:for-each select="text()[normalize-space()]">
                <xsl:if test="position() &gt; 1">
                  <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:value-of select="normalize-space(.)"/>
              </xsl:for-each>
            </rdagr2:dateOfDeath>
          </xsl:for-each>

          <!-- Tag mapping: schema:sameAs -> owl:sameAs -->
          <xsl:for-each select="./schema:sameAs">
            <owl:sameAs>
              <!-- Attribute mapping: rdf:resource -> rdf:resource -->
              <xsl:if test="@rdf:resource">
                <xsl:attribute name="rdf:resource">
                  <xsl:value-of select="@rdf:resource"/>
                </xsl:attribute>
              </xsl:if>
              <!-- Text content mapping (only content with non-space characters) -->
              <xsl:for-each select="text()[normalize-space()]">
                <xsl:if test="position() &gt; 1">
                  <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:value-of select="normalize-space(.)"/>
              </xsl:for-each>
            </owl:sameAs>
          </xsl:for-each>


          <!-- Tag mapping: schema:description -> skos:note -->
          <xsl:for-each select="./schema:description">
            <skos:note>
              <xsl:if test="@xml:lang">
                <xsl:attribute name="xml:lang">
                  <xsl:value-of select="@xml:lang"/>
                </xsl:attribute>
              </xsl:if>
              <!-- Text content mapping (only content with non-space characters) -->
              <xsl:for-each select="text()[normalize-space()]">
                <xsl:if test="position() &gt; 1">
                  <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:value-of select="normalize-space(.)"/>
              </xsl:for-each>
            </skos:note>
          </xsl:for-each>

          <!-- Tag mapping: dbo:notableWork -> edm:hasMet -->
          <xsl:for-each select="./dbo:notableWork">
            <!-- Attribute mapping: rdf:resource -> rdf:resource -->
            <edm:hasMet>
              <xsl:attribute name="rdf:resource">
                <xsl:value-of select="@rdf:resource"/>
              </xsl:attribute>
            </edm:hasMet>
          </xsl:for-each>
        </edm:Agent>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>