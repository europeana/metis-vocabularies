<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:skos="http://www.w3.org/2004/02/skos/core#">
    <xsl:param name="targetId"></xsl:param>
    <xsl:output indent="yes" encoding="UTF-8"></xsl:output>
    <xsl:template match="/rdf:RDF"><!-- Parent mapping: rdf:Description -> skos:Concept -->
        <xsl:for-each select="./rdf:Description[@rdf:about=$targetId]">
            <!-- This test is to ensure we are only getting the right types. -->
            <xsl:if test="rdf:type/@rdf:resource[.='http://www.w3.org/2004/02/skos/core#Concept']">
                <skos:Concept><!-- Attribute mapping: rdf:about -> rdf:about -->
                    <xsl:if test="@rdf:about">
                        <xsl:attribute name="rdf:about">
                            <xsl:value-of select="@rdf:about"></xsl:value-of>
                        </xsl:attribute>
                    </xsl:if><!-- Tag mapping: skos:narrower -> skos:narrower -->
                    <xsl:for-each select="./skos:narrower">
                        <skos:narrower><!-- Attribute mapping: rdf:resource -> rdf:resource -->
                            <xsl:if test="@rdf:resource">
                                <xsl:attribute name="rdf:resource">
                                    <xsl:value-of select="@rdf:resource"></xsl:value-of>
                                </xsl:attribute>
                            </xsl:if><!-- Certain skos relations may be defined in a skos:Concept sub-tag. -->
                            <xsl:if test="not (@rdf:resource) and ./skos:Concept[@rdf:about]">
                                <xsl:attribute name="rdf:resource">
                                    <xsl:value-of
                                            select="(./skos:Concept[@rdf:about])[1]/@rdf:about"></xsl:value-of>
                                </xsl:attribute>
                            </xsl:if><!-- Text content mapping (only content with non-space characters) -->
                            <xsl:for-each select="text()[normalize-space()]">
                                <xsl:if test="position() &gt; 1">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                                <xsl:value-of select="normalize-space(.)"></xsl:value-of>
                            </xsl:for-each>
                        </skos:narrower>
                    </xsl:for-each><!-- Tag mapping: skos:broader -> skos:broader -->
                    <xsl:for-each select="./skos:broader">
                        <skos:broader><!-- Attribute mapping: rdf:resource -> rdf:resource -->
                            <xsl:if test="@rdf:resource">
                                <xsl:attribute name="rdf:resource">
                                    <xsl:value-of select="@rdf:resource"></xsl:value-of>
                                </xsl:attribute>
                            </xsl:if><!-- Certain skos relations may be defined in a skos:Concept sub-tag. -->
                            <xsl:if test="not (@rdf:resource) and ./skos:Concept[@rdf:about]">
                                <xsl:attribute name="rdf:resource">
                                    <xsl:value-of
                                            select="(./skos:Concept[@rdf:about])[1]/@rdf:about"></xsl:value-of>
                                </xsl:attribute>
                            </xsl:if><!-- Text content mapping (only content with non-space characters) -->
                            <xsl:for-each select="text()[normalize-space()]">
                                <xsl:if test="position() &gt; 1">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                                <xsl:value-of select="normalize-space(.)"></xsl:value-of>
                            </xsl:for-each>
                        </skos:broader>
                    </xsl:for-each><!-- Tag mapping: skos:inScheme -> skos:inScheme -->
                    <xsl:for-each select="./skos:inScheme">
                        <skos:inScheme><!-- Attribute mapping: rdf:resource -> rdf:resource -->
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
                        </skos:inScheme>
                    </xsl:for-each><!-- Tag mapping: skos:prefLabel -> skos:prefLabel -->
                    <xsl:for-each select="./skos:prefLabel">
                        <skos:prefLabel><!-- Attribute mapping: xml:lang -> xml:lang -->
                            <xsl:if test="@xml:lang">
                                <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="@xml:lang"></xsl:value-of>
                                </xsl:attribute>
                            </xsl:if><!-- Text content mapping (only content with non-space characters) -->
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
</xsl:stylesheet>