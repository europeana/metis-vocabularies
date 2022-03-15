<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:skos="http://www.w3.org/2004/02/skos/core#" version="1.0" xmlns:skosxl="http://www.w3.org/2008/05/skos-xl#">
  <xsl:param name="targetId"/>
  <xsl:output indent="yes" encoding="UTF-8"/>
  
  <!-- Main template -->
  <xsl:template match="/rdf:RDF">
    
    <!-- Parent mapping: * -> skos:Concept -->
    <xsl:for-each select="./*">
      <xsl:if test="@rdf:about=$targetId">
        <skos:Concept>
          
          <!-- Attribute mapping: rdf:about -> rdf:about -->
          <xsl:copy-of select="@rdf:about"/>
          
          <!-- Tag mapping: skos:prefLabel -> skos:prefLabel -->
          <xsl:apply-templates select="./skos:prefLabel" mode="copy_literal" />
          
          <!-- Tag mapping: skos:altLabel -> skos:altLabel -->
          <xsl:apply-templates select="./skos:altLabel" mode="copy_literal" />
                                        
          <!-- Tag mapping: skos:note -> skos:note -->
          <xsl:apply-templates select="./skos:note" mode="copy_literal" />
          
          <!-- Tag mapping: skos:broader -> skos:broader -->
          <xsl:apply-templates select="./skos:broader" mode="copy_resource" />
          
          <!-- Tag mapping: skos:narrower -> skos:narrower -->
          <xsl:apply-templates select="./skos:narrower" mode="copy_resource" />
          
          <!-- Tag mapping: skos:related -> skos:related -->
          <xsl:apply-templates select="./skos:related" mode="copy_resource" />
          
          <!-- Tag mapping: skos:broadMatch -> skos:broadMatch -->
          <xsl:apply-templates select="./skos:broadMatch" mode="copy_resource" />
          
          <!-- Tag mapping: skos:narrowMatch -> skos:narrowMatch -->
          <xsl:apply-templates select="./skos:narrowMatch" mode="copy_resource" />
          
          <!-- Tag mapping: skos:relatedMatch -> skos:relatedMatch -->
          <xsl:apply-templates select="./skos:relatedMatch" mode="copy_resource" />
          
          <!-- Tag mapping: skos:exactMatch -> skos:exactMatch -->
          <xsl:apply-templates select="./skos:exactMatch" mode="copy_resource" />
          
          <!-- Tag mapping: skos:closeMatch -> skos:closeMatch -->
          <xsl:apply-templates select="./skos:closeMatch" mode="copy_resource" />
          
          <!-- Tag mapping: skos:inScheme -> skos:inScheme -->
          <xsl:apply-templates select="./skos:inScheme" mode="copy_resource" />
          
        </skos:Concept>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
  <!-- Template for literals -->
  <xsl:template match="*" mode="copy_literal">
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      
      <!-- Attribute mapping: xml:lang -> xml:lang -->
      <xsl:copy-of select="@xml:lang" />
      
      <!-- Text content mapping -->
      <xsl:copy-of select="text()"/>
      
    </xsl:element>
  </xsl:template>
  
  <!-- Template for resources -->
  <xsl:template match="*" mode="copy_resource">
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
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