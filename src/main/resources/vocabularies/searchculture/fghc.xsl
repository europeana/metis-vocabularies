<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:edm="http://www.europeana.eu/schemas/edm/" xmlns:rdaGr2="http://rdvocab.info/ElementsGr2/" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:skos="http://www.w3.org/2004/02/skos/core#" version="1.0" xmlns:skosxl="http://www.w3.org/2008/05/skos-xl#">
  <xsl:param name="targetId"/>
  <xsl:output indent="yes" encoding="UTF-8"/>

  <!-- Main template -->
  <xsl:template match="/rdf:RDF">

    <!-- Parent mapping: skos:Concept -> skos:Concept -->
    <xsl:for-each select="./*">
      <xsl:if test="@rdf:about=$targetId">
        <edm:Agent>
          <!-- Attribute mapping: rdf:about -> rdf:about -->
          <xsl:copy-of select="@rdf:about"/>
          <!-- Tag mapping: skos:prefLabel -> skos:prefLabel -->
          <xsl:apply-templates select="./skos:prefLabel" mode="copy_literal" />
          <!-- Tag mapping: skos:altLabel -> skos:altLabel -->
          <xsl:apply-templates select="./skos:altLabel" mode="copy_literal" />
          <!-- Tag mapping: skos:note -> skos:note -->
          <xsl:apply-templates select="./skos:note" mode="copy_literal"/>
          <!-- Tag mapping: rdaGr2:dateOfBirth -> rdaGr2:dateOfBirth -->
          <xsl:apply-templates select="./rdaGr2:dateOfBirth" mode="copy_literal" />
          <!-- Tag mapping: rdaGr2:dateOfDeath -> rdaGr2:dateOfDeath -->
          <xsl:apply-templates select="./rdaGr2:dateOfDeath" mode="copy_literal" />
          <!-- Tag mapping: rdaGr2:placeOfBirth -> rdaGr2:placeOfBirth -->
          <xsl:apply-templates select="./rdaGr2:placeOfBirth" mode="copy_literal" />
          <!-- Tag mapping: rdaGr2:placeOfDeath -> rdaGr2:placeOfDeath -->
          <xsl:apply-templates select="./rdaGr2:placeOfDeath" mode="copy_literal" />
          <!-- Tag mapping: rdaGr2:professionOrOccupation -> rdaGr2:professionOrOccupation -->
          <xsl:apply-templates select="./rdaGr2:professionOrOccupation" mode="copy_resource" />
          <!-- Tag mapping: rdaGr2:professionOrOccupation -> rdaGr2:professionOrOccupation -->
          <xsl:apply-templates select="rdaGr2:professionOrOccupation/rdf:Description/rdfs:label"/>
          <!-- Tag mapping: owl:sameAs -> owl:sameAs -->
          <xsl:apply-templates select="./owl:sameAs" mode="copy_resource" />
        </edm:Agent>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- Template for rdaGr2:professionOrOccupation -->
  <xsl:template match="rdaGr2:professionOrOccupation/rdf:Description/rdfs:label">
    <xsl:element name="rdaGr2:professionOrOccupation">
      <!-- Attribute mapping: xml:lang -> xml:lang -->
      <xsl:copy-of select="@xml:lang" />
      <!-- Text content mapping -->
      <xsl:copy-of select="text()"/>
    </xsl:element>
  </xsl:template>

  <!-- Template for literals -->
  <xsl:template match="*" mode="copy_literal">
    <xsl:element name="{name()}">
      <!-- Attribute mapping: xml:lang -> xml:lang -->
      <xsl:copy-of select="@xml:lang" />
      <!-- Text content mapping -->
      <xsl:copy-of select="text()"/>
    </xsl:element>
  </xsl:template>

  <!-- Template for resources -->
  <xsl:template match="*" mode="copy_resource">
    <xsl:element name="{name()}">
      <xsl:choose>
        <!-- Attribute mapping: rdf:resource -> rdf:resource -->
        <xsl:when test="@rdf:resource">
          <xsl:copy-of select="@rdf:resource" />
        </xsl:when>
        <!-- Attribute mapping: rdf:Description/rdf:about -> rdf:resource -->
        <xsl:otherwise>
          <xsl:attribute name="rdf:resource">
            <xsl:value-of select="rdf:Description/@rdf:about"/>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
