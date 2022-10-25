<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:edm="http://www.europeana.eu/schemas/edm/"
  xmlns:foaf="http://xmlns.com/foaf/0.1/"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:rdaGr2="http://rdvocab.info/ElementsGr2/"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:rdau="http://rdaregistry.info/Elements/u/"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#">
  <xsl:param name="targetId"/>
  <xsl:output indent="yes" encoding="UTF-8"/>

  <!-- Main template -->
  <xsl:template match="/rdf:RDF">
    <xsl:for-each select=".//*[@rdf:about=$targetId]">
      <!-- Condition to ensure we are only getting type Person -->
      <xsl:if test="./rdf:type/@rdf:resource='http://xmlns.com/foaf/0.1/Person' or ./rdf:type/@rdf:resource='http://schema.org/Person'">
        <!-- Parent mapping: KulturNav type:Person -> edm:Agent -->
        <edm:Agent>
          <!-- Attribute mapping: rdf:about -> rdf:about -->
          <xsl:attribute name="rdf:about">
            <xsl:value-of select="$targetId"/>
          </xsl:attribute>
          <!-- Tag mapping: skos:prefLabel -> skos:prefLabel -->
          <xsl:apply-templates select=".//skos:prefLabel"/>
          <!-- Tag mapping: skos:altLabel -> skos:altLabel -->
          <xsl:apply-templates select=".//skos:altLabel"/>
          <!-- Tag mapping: skos:note -> skos:note -->
          <xsl:apply-templates select=".//skos:note"/>
          <!-- Tag mapping: dcterms:identifier -> dc:identifier -->
          <xsl:apply-templates select=".//dcterms:identifier"/>
          <!-- Tag mapping: edm:isRelatedTo -> edm:isRelatedTo -->
          <xsl:apply-templates select=".//edm:isRelatedTo"/>
          <!-- Tag mapping: foaf:name -> foaf:name -->
          <xsl:apply-templates select=".//foaf:name"/>
          <!-- Tag mapping: rdau:P60492 -> rdaGr2:biographicalInformation -->
          <xsl:apply-templates select=".//rdau:P60492"/>
          <!-- Tag mapping: rdau:P60599 -> rdaGr2:dateOfBirth -->
          <xsl:apply-templates select=".//rdau:P60599"/>
          <!-- Tag mapping: rdau:P60598 -> rdaGr2:dateOfDeath -->
          <xsl:apply-templates select=".//rdau:P60598"/>
          <!-- Tag mapping: rdau:P60531 -> rdaGr2:gender -->
          <xsl:apply-templates select=".//rdau:P60531"/>
          <!-- Tag mapping: rdau:P60593 -> rdaGr2:placeOfBirth -->
          <xsl:apply-templates select=".//rdau:P60593"/>
          <!-- Tag mapping: rdau:P60592 -> rdaGr2:placeOfDeath -->
          <xsl:apply-templates select=".//rdau:P60592"/>
          <!-- Tag mapping: mads:fieldOfActivity -> rdaGr2:professionOrOccupation -->
          <xsl:apply-templates select=".//mads:fieldOfActivity"/>
          <!-- Tag mapping: owl:sameAs -> owl:sameAs -->
          <xsl:apply-templates select=".//owl:sameAs"/>
        </edm:Agent>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- Template for dc:identifier -->
  <xsl:template match="dcterms:identifier">
    <xsl:element name="dc:identifier">
      <xsl:copy-of select="node()"/>
    </xsl:element>
  </xsl:template>
  <!-- Template for rdaGr2:biographicalInformation -->
  <xsl:template match="rdau:P60492">
    <xsl:element name="rdaGr2:biographicalInformation">
      <xsl:copy-of select="@xml:lang"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>
  <!-- Template for rdaGr2:dateOfBirth -->
  <xsl:template match="rdau:P60599">
    <xsl:element name="rdaGr2:dateOfBirth">
      <xsl:copy-of select="@rdf:datatype"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>
  <!-- Template for rdaGr2:dateOfDeath -->
  <xsl:template match="rdau:P60598">
    <xsl:element name="rdaGr2:dateOfDeath">
      <xsl:copy-of select="@rdf:datatype"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>
  <!-- Template for rdaGr2:gender -->
  <xsl:template match="rdau:P60531">
    <xsl:element name="rdaGr2:gender">
      <xsl:copy-of select="@xml:lang"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>
  <!-- Template for rdaGr2:placeOfBirth -->
  <xsl:template match="rdau:P60593">
    <xsl:element name="rdaGr2:placeOfBirth">
      <xsl:copy-of select="@rdf:resource"/>
      <xsl:copy-of select="@xml:lang"/>
      <xsl:copy-of select="@rdf:datatype"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>
  <!-- Template for rdaGr2:placeOfDeath -->
  <xsl:template match="rdau:P60592">
    <xsl:element name="rdaGr2:placeOfDeath">
      <xsl:copy-of select="@rdf:resource"/>
      <xsl:copy-of select="@xml:lang"/>
      <xsl:copy-of select="@rdf:datatype"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>
  <!-- Template for rdaGr2:professionOrOccupation -->
  <xsl:template match="mads:fieldOfActivity">
    <xsl:element name="rdaGr2:professionOrOccupation">
      <xsl:copy-of select="@rdf:resource"/>
      <xsl:copy-of select="@xml:lang"/>
      <xsl:copy-of select="@rdf:datatype"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>
  <!-- Template for other tags -->
  <xsl:template match="*">
    <xsl:element name="{name()}">
      <xsl:copy-of select="@rdf:resource"/>
      <xsl:copy-of select="@xml:lang"/>
      <xsl:copy-of select="@rdf:datatype"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>