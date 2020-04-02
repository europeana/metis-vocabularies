<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:gndo="http://d-nb.info/standards/elementset/gnd#"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:skos="http://www.w3.org/2004/02/skos/core#"
        xmlns:edm="http://www.europeana.eu/schemas/edm/">
    <xsl:param name="targetId"></xsl:param>
    <xsl:output indent="yes" encoding="UTF-8"></xsl:output>
    <xsl:template match="/rdf:RDF"><!-- Parent mapping: rdf:Description -> edm:Place -->
        <xsl:for-each select="./rdf:Description[@rdf:about=$targetId]">
            <!-- This test is to ensure we are only getting the right types. -->
            <xsl:if test="rdf:type/@rdf:resource[.='http://d-nb.info/standards/elementset/gnd#TerritorialCorporateBodyOrAdministrativeUnit']">
                <edm:Place><!-- Attribute mapping: rdf:about -> rdf:about -->
                    <xsl:if test="@rdf:about">
                        <xsl:attribute name="rdf:about">
                            <xsl:value-of select="@rdf:about"></xsl:value-of>
                        </xsl:attribute>
                    </xsl:if><!-- Tag mapping: owl:sameAs -> owl:sameAs -->
                    <xsl:for-each select="./owl:sameAs">
                        <owl:sameAs><!-- Attribute mapping: rdf:resource -> rdf:resource -->
                            <xsl:if test="@rdf:resource">
                                <xsl:attribute name="rdf:resource">
                                    <xsl:value-of select="@rdf:resource"></xsl:value-of>
                                </xsl:attribute>
                            </xsl:if><!-- Text content mapping (only content with non-space characters) -->
                            <xsl:for-each select="text()[normalize-space()]">
                                <xsl:if test="position() &gt; 1">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                                <xsl:value-of select="normalize-space(.)"></xsl:value-of>
                            </xsl:for-each>
                        </owl:sameAs>
                    </xsl:for-each><!-- Tag mapping: gndo:oldAuthorityNumber -> owl:sameAs -->
                    <xsl:for-each select="./gndo:oldAuthorityNumber">
                        <owl:sameAs><!-- Text content mapping (only content with non-space characters) -->
                            <xsl:for-each select="text()[normalize-space()]">
                                <xsl:if test="position() &gt; 1">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                                <xsl:value-of select="normalize-space(.)"></xsl:value-of>
                            </xsl:for-each>
                        </owl:sameAs>
                    </xsl:for-each><!-- Tag mapping: gndo:gndIdentifier -> owl:sameAs -->
                    <xsl:for-each select="./gndo:gndIdentifier">
                        <owl:sameAs><!-- Text content mapping (only content with non-space characters) -->
                            <xsl:for-each select="text()[normalize-space()]">
                                <xsl:if test="position() &gt; 1">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                                <xsl:value-of select="normalize-space(.)"></xsl:value-of>
                            </xsl:for-each>
                        </owl:sameAs>
                    </xsl:for-each><!-- Tag mapping: gndo:preferredNameForThePlaceOrGeographicName -> skos:prefLabel -->
                    <xsl:for-each select="./gndo:preferredNameForThePlaceOrGeographicName">
                        <skos:prefLabel><!-- Text content mapping (only content with non-space characters) -->
                            <xsl:for-each select="text()[normalize-space()]">
                                <xsl:if test="position() &gt; 1">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                                <xsl:value-of select="normalize-space(.)"></xsl:value-of>
                            </xsl:for-each>
                        </skos:prefLabel>
                    </xsl:for-each><!-- Tag mapping: gndo:variantNameForThePlaceOrGeographicName -> skos:altLabel -->
                    <xsl:for-each select="./gndo:variantNameForThePlaceOrGeographicName">
                        <skos:altLabel><!-- Text content mapping (only content with non-space characters) -->
                            <xsl:for-each select="text()[normalize-space()]">
                                <xsl:if test="position() &gt; 1">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                                <xsl:value-of select="normalize-space(.)"></xsl:value-of>
                            </xsl:for-each>
                        </skos:altLabel>
                    </xsl:for-each>
                </edm:Place>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>