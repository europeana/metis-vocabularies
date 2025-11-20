<?xml version="1.0" encoding="UTF-8"?>
<!--
  Document   : GTAA2EDM.xsl
  Author     : Masa
  Created on : August 2025
  Updated on : October 2025
  Version    : v1.1

  changes:
* Revision of mapping logic for selected entity types:
  - Type "Geographical name" remapped from skos:Concept to edm:Place
  - Type "Personal name" remapped from skos:Concept to edm:Agent
  - Other types remain mapped to skos:Concept
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:skosxl="http://www.w3.org/2008/05/skos-xl#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:edm="http://www.europeana.eu/schemas/edm/"
  xmlns:rdaGr2="http://rdvocab.info/ElementsGr2/"
  xmlns:bengthes="http://data.beeldengeluid.nl/schema/thes#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <xsl:param name="targetId"></xsl:param>
  <xsl:output indent="yes" encoding="UTF-8"></xsl:output>

  <!-- Main template -->
  <xsl:template match="/rdf:RDF">
    <xsl:for-each select="rdf:Description[@rdf:about=$targetId]">
      <!-- Condition based on skos:inScheme value defines EDM entity type -->
      <xsl:choose>
        <!-- Geographical names -> edm:Place -->
        <xsl:when test="skos:inScheme[@rdf:resource='http://data.beeldengeluid.nl/gtaa/GeografischeNamen']">
          <edm:Place>
            <!-- Attribute mapping: rdf:about -> rdf:about -->
            <xsl:copy-of select="@rdf:about" />
            <!-- Tag mapping: skos:prefLabel -> skos:prefLabel -->
            <xsl:choose>
              <!-- If skos:prefLabel exists, output it directly -->
              <xsl:when test="skos:prefLabel">
                <xsl:for-each select="skos:prefLabel">
                  <skos:prefLabel>
                    <xsl:if test="@xml:lang">
                      <xsl:attribute name="xml:lang">
                        <xsl:value-of select="@xml:lang"/>
                      </xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="."/>
                  </skos:prefLabel>
                </xsl:for-each>
              </xsl:when>
              <!-- Otherwise, fallback to skosxl:prefLabel -->
              <xsl:otherwise>
                <xsl:apply-templates select="skosxl:prefLabel/@rdf:resource"/>
              </xsl:otherwise>
            </xsl:choose>
            <!-- Tag mapping: skos:altLabel -> skos:altLabel -->
            <xsl:apply-templates select="skosxl:altLabel/@rdf:resource" />
            <!-- Tag mapping: skos:scopeNote -> skos:note -->
            <xsl:for-each select="skos:scopeNote">
              <skos:note xml:lang="{@xml:lang}">
                <xsl:value-of select="." />
              </skos:note>
            </xsl:for-each>
            <!-- Tag mapping: skos:exactMatch -> owl:sameAs  -->
            <xsl:for-each select="skos:exactMatch">
              <owl:sameAs rdf:resource="{@rdf:resource}"/>
            </xsl:for-each>
          </edm:Place>
        </xsl:when>
        <!-- Personal names -> edm:Agent -->
        <xsl:when test="skos:inScheme[@rdf:resource='http://data.beeldengeluid.nl/gtaa/Persoonsnamen']">
          <edm:Agent>
            <!-- Attribute mapping: rdf:about -> rdf:about -->
            <xsl:copy-of select="@rdf:about" />
            <!-- Tag mapping: skos:prefLabel -> skos:prefLabel -->
            <xsl:choose>
              <!-- If skos:prefLabel exists, output it directly -->
              <xsl:when test="skos:prefLabel">
                <xsl:for-each select="skos:prefLabel">
                  <skos:prefLabel>
                    <xsl:if test="@xml:lang">
                      <xsl:attribute name="xml:lang">
                        <xsl:value-of select="@xml:lang"/>
                      </xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="."/>
                  </skos:prefLabel>
                </xsl:for-each>
              </xsl:when>
              <!-- Otherwise, fallback to skosxl:prefLabel -->
              <xsl:otherwise>
                <xsl:apply-templates select="skosxl:prefLabel/@rdf:resource"/>
              </xsl:otherwise>
            </xsl:choose>
            <!-- Tag mapping: skos:altLabel -> skos:altLabel -->
            <xsl:apply-templates select="skosxl:altLabel/@rdf:resource" />
            <!-- Tag mapping: skos:scopeNote -> skos:note -->
            <xsl:for-each select="skos:scopeNote">
              <skos:note xml:lang="{@xml:lang}">
                <xsl:value-of select="." />
              </skos:note>
            </xsl:for-each>
            <!-- Tag mapping: bengthes:qualifier -> rdaGr2:professionOrOccupation -->
            <xsl:for-each select="bengthes:qualifier">
              <rdaGr2:professionOrOccupation xml:lang="{@xml:lang}">
                <xsl:value-of select="." />
              </rdaGr2:professionOrOccupation>
            </xsl:for-each>
            <!-- Tag mapping: skos:exactMatch -> owl:sameAs  -->
            <xsl:for-each select="skos:exactMatch">
              <owl:sameAs rdf:resource="{@rdf:resource}"/>
            </xsl:for-each>
          </edm:Agent>
        </xsl:when>
        <!-- All other types -> skos:Concept -->
        <xsl:otherwise>
          <skos:Concept>
            <!-- Attribute mapping: rdf:about -> rdf:about -->
            <xsl:copy-of select="@rdf:about" />
            <!-- Tag mapping: skos:prefLabel -> skos:prefLabel -->
            <xsl:choose>
              <!-- If skos:prefLabel exists, output it directly -->
              <xsl:when test="skos:prefLabel">
                <xsl:for-each select="skos:prefLabel">
                  <skos:prefLabel>
                    <xsl:if test="@xml:lang">
                      <xsl:attribute name="xml:lang">
                        <xsl:value-of select="@xml:lang"/>
                      </xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="."/>
                  </skos:prefLabel>
                </xsl:for-each>
              </xsl:when>
              <!-- Otherwise, fallback to skosxl:prefLabel -->
              <xsl:otherwise>
                <xsl:apply-templates select="skosxl:prefLabel/@rdf:resource"/>
              </xsl:otherwise>
            </xsl:choose>
            <!-- Tag mapping: skos:altLabel -> skos:altLabel -->
            <xsl:apply-templates select="skosxl:altLabel/@rdf:resource" />
            <!-- Tag mapping: skos:scopeNote -> skos:note -->
            <xsl:for-each select="skos:scopeNote">
              <skos:note xml:lang="{@xml:lang}">
                <xsl:value-of select="." />
              </skos:note>
            </xsl:for-each>
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
            <!-- Tag mapping: skos:broadMatch -> skos:broadMatch -->
            <xsl:for-each select="skos:broadMatch">
              <skos:broadMatch rdf:resource="{@rdf:resource}" />
            </xsl:for-each>
            <!-- Tag mapping: skos:narrowMatch -> skos:narrowMatch -->
            <xsl:for-each select="skos:narrowMatch">
              <skos:narrowMatch rdf:resource="{@rdf:resource}" />
            </xsl:for-each>
            <!-- Tag mapping: skos:relatedMatch -> skos:relatedMatch -->
            <xsl:for-each select="skos:relatedMatch">
              <skos:relatedMatch rdf:resource="{@rdf:resource}" />
            </xsl:for-each>
            <!-- Tag mapping: skos:closeMatch -> skos:closeMatch -->
            <xsl:for-each select="skos:closeMatch">
              <skos:closeMatch rdf:resource="{@rdf:resource}" />
            </xsl:for-each>
            <!-- Tag mapping: skos:exactMatch -> skos:exactMatch -->
            <xsl:for-each select="skos:exactMatch">
              <skos:exactMatch rdf:resource="{@rdf:resource}" />
            </xsl:for-each>
          </skos:Concept>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!-- Template for skos:prefLabel -->
  <xsl:template match="skosxl:prefLabel/@rdf:resource">
    <xsl:variable name="labelUri" select="." />
    <xsl:for-each
      select="/rdf:RDF/rdf:Description[@rdf:about=$labelUri]/skosxl:literalForm">
      <skos:prefLabel>
        <xsl:if test="@xml:lang">
          <xsl:attribute name="xml:lang">
            <xsl:value-of select="@xml:lang" />
          </xsl:attribute>
        </xsl:if>
        <xsl:value-of select="." />
      </skos:prefLabel>
    </xsl:for-each>
  </xsl:template>
  <!-- Template for skos:altLabel -->
  <xsl:template match="skosxl:altLabel/@rdf:resource">
    <xsl:variable name="labelUri" select="." />
    <xsl:for-each
      select="/rdf:RDF/rdf:Description[@rdf:about=$labelUri]/skosxl:literalForm">
      <skos:altLabel>
        <xsl:if test="@xml:lang">
          <xsl:attribute name="xml:lang">
            <xsl:value-of select="@xml:lang" />
          </xsl:attribute>
        </xsl:if>
        <xsl:value-of select="." />
      </skos:altLabel>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>