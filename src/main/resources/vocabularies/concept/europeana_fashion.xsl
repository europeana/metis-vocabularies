<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    >

    <xsl:output indent="yes" encoding="UTF-8"/>

    <xsl:param name="targetId"/>

    <xsl:template match="/">
        <xsl:apply-templates select="rdf:RDF"/>
    </xsl:template>

    <xsl:template match="rdf:RDF">
        <xsl:apply-templates select="rdf:Description[@rdf:about=$targetId]"/>
    </xsl:template>

    <xsl:template match="rdf:Description">
        <skos:Concept>
            <xsl:copy-of select="@rdf:about"/>
            <xsl:copy-of select="skos:prefLabel"/>
            <xsl:copy-of select="skos:altLabel"/>
            <xsl:copy-of select="skos:broader"/>
            <xsl:copy-of select="skos:narrower"/>
            <xsl:copy-of select="skos:related"/>
            <xsl:copy-of select="skos:broadMatch"/>
            <xsl:copy-of select="skos:narrowMatch"/>
            <xsl:copy-of select="skos:relatedMatch"/>
            <xsl:copy-of select="skos:exactMatch"/>
            <xsl:copy-of select="skos:closeMatch"/>
            <xsl:copy-of select="skos:note"/>
            <xsl:apply-templates select="./skos:scopeNote"/>
            <xsl:copy-of select="skos:notation"/>
            <xsl:copy-of select="skos:inScheme"/>
        </skos:Concept>
    </xsl:template>

    <!-- Template for skos:scopeNote -->
    <xsl:template match="skos:scopeNote">
        <skos:note>
      
            <!-- Attribute mapping: xml:lang -> xml:lang -->
            <xsl:copy-of select="@xml:lang" />
      
            <!-- Text content mapping -->
            <xsl:copy-of select="text()"/>
      
        </skos:note>
    </xsl:template>

</xsl:stylesheet>