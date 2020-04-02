<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:gndo="http://d-nb.info/standards/elementset/gnd#"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:skos="http://www.w3.org/2004/02/skos/core#"
        xmlns:edm="http://www.europeana.eu/schemas/edm/"
        xmlns:rdagr2="http://rdvocab.info/ElementsGr2/">
    <xsl:param name="targetId"></xsl:param>
    <xsl:output indent="yes" encoding="UTF-8"></xsl:output>
    <xsl:template match="/rdf:RDF"><!-- Parent mapping: rdf:Description -> edm:Agent -->
        <xsl:for-each select="./rdf:Description[@rdf:about=$targetId]">
            <!-- This test is to ensure we are only getting the right types. -->
            <xsl:if test="rdf:type/@rdf:resource[.='http://d-nb.info/standards/elementset/gnd#RoyalOrMemberOfARoyalHouse']">
                <edm:Agent><!-- Attribute mapping: rdf:about -> rdf:about -->
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
                    </xsl:for-each><!-- Tag mapping: gndo:dateOfBirth -> rdagr2:dateOfBirth -->
                    <xsl:for-each select="./gndo:dateOfBirth">
                        <rdagr2:dateOfBirth><!-- Attribute mapping: rdf:datatype -> rdf:datatype -->
                            <xsl:if test="@rdf:datatype">
                                <xsl:attribute name="rdf:datatype">
                                    <xsl:value-of select="@rdf:datatype"></xsl:value-of>
                                </xsl:attribute>
                            </xsl:if><!-- Text content mapping (only content with non-space characters) -->
                            <xsl:for-each select="text()[normalize-space()]">
                                <xsl:if test="position() &gt; 1">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                                <xsl:value-of select="normalize-space(.)"></xsl:value-of>
                            </xsl:for-each>
                        </rdagr2:dateOfBirth>
                    </xsl:for-each><!-- Tag mapping: gndo:variantNameForThePerson -> skos:altLabel -->
                    <xsl:for-each select="./gndo:variantNameForThePerson">
                        <skos:altLabel><!-- Text content mapping (only content with non-space characters) -->
                            <xsl:for-each select="text()[normalize-space()]">
                                <xsl:if test="position() &gt; 1">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                                <xsl:value-of select="normalize-space(.)"></xsl:value-of>
                            </xsl:for-each>
                        </skos:altLabel>
                    </xsl:for-each><!-- Tag mapping: gndo:gender -> rdagr2:gender -->
                    <xsl:for-each select="./gndo:gender">
                        <rdagr2:gender><!-- Text content mapping (only content with non-space characters) -->
                            <xsl:for-each select="text()[normalize-space()]">
                                <xsl:if test="position() &gt; 1">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                                <xsl:value-of select="normalize-space(.)"></xsl:value-of>
                            </xsl:for-each>
                        </rdagr2:gender>
                    </xsl:for-each><!-- Tag mapping: gndo:dateOfDeath -> rdagr2:dateOfDeath -->
                    <xsl:for-each select="./gndo:dateOfDeath">
                        <rdagr2:dateOfDeath><!-- Text content mapping (only content with non-space characters) -->
                            <xsl:for-each select="text()[normalize-space()]">
                                <xsl:if test="position() &gt; 1">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                                <xsl:value-of select="normalize-space(.)"></xsl:value-of>
                            </xsl:for-each>
                        </rdagr2:dateOfDeath>
                    </xsl:for-each><!-- Tag mapping: gndo:preferredNameForThePerson -> skos:prefLabel -->
                    <xsl:for-each select="./gndo:preferredNameForThePerson">
                        <skos:prefLabel><!-- Text content mapping (only content with non-space characters) -->
                            <xsl:for-each select="text()[normalize-space()]">
                                <xsl:if test="position() &gt; 1">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                                <xsl:value-of select="normalize-space(.)"></xsl:value-of>
                            </xsl:for-each>
                        </skos:prefLabel>
                    </xsl:for-each><!-- Tag mapping: gndo:surname -> skos:altLabel -->
                    <xsl:for-each select="./gndo:surname">
                        <skos:altLabel><!-- Text content mapping (only content with non-space characters) -->
                            <xsl:for-each select="text()[normalize-space()]">
                                <xsl:if test="position() &gt; 1">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                                <xsl:value-of select="normalize-space(.)"></xsl:value-of>
                            </xsl:for-each>
                        </skos:altLabel>
                    </xsl:for-each>
                </edm:Agent>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>