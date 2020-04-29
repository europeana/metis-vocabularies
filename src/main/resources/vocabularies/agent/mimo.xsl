<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:skos="http://www.w3.org/2004/02/skos/core#"
        xmlns:rdaGr2="http://rdvocab.info/ElementsGr2/" xmlns:foaf="http://xmlns.com/foaf/0.1/"
        xmlns:edm="http://www.europeana.eu/schemas/edm/"
        xmlns:rdagr2="http://rdvocab.info/ElementsGr2/">
    <xsl:param name="targetId"></xsl:param>
    <xsl:output indent="yes" encoding="UTF-8"></xsl:output>
    <xsl:template match="/rdf:RDF">
        <!-- Parent mapping: skos:Concept -> edm:Agent -->
        <xsl:if test="./*[@rdf:about=$targetId]">
            <!-- Attribute mapping: rdf:about -> rdf:about -->
            <xsl:attribute name="rdf:about">
                <xsl:value-of select="$targetId"></xsl:value-of>
            </xsl:attribute>
            <edm:Agent>
                <xsl:for-each select="./*[@rdf:about=$targetId]">
                    <!-- Tag mapping: rdaGr2:dateOfBirth -> rdagr2:dateOfBirth -->
                    <xsl:for-each select="./rdaGr2:dateOfBirth">
                        <rdagr2:dateOfBirth>
                            <!-- Text content mapping (only content with non-space characters) -->
                            <xsl:for-each select="text()[normalize-space()]">
                                <xsl:if test="position() &gt; 1">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                                <xsl:value-of select="normalize-space(.)"></xsl:value-of>
                            </xsl:for-each>
                        </rdagr2:dateOfBirth>
                    </xsl:for-each>
                    <!-- Tag mapping: rdf:Description -> skos:note -->
                    <xsl:for-each select="./rdf:Description">
                        <skos:note>
                            <!-- Attribute mapping: rdf:about -> rdf:about -->
                            <xsl:if test="@rdf:about">
                                <xsl:attribute name="rdf:about">
                                    <xsl:value-of select="@rdf:about"></xsl:value-of>
                                </xsl:attribute>
                            </xsl:if>
                            <!-- Text content mapping (only content with non-space characters) -->
                            <xsl:for-each select="text()[normalize-space()]">
                                <xsl:if test="position() &gt; 1">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                                <xsl:value-of select="normalize-space(.)"></xsl:value-of>
                            </xsl:for-each>
                        </skos:note>
                    </xsl:for-each>
                    <!-- Tag mapping: foaf:name -> foaf:name -->
                    <xsl:for-each select="./foaf:name">
                        <foaf:name>
                            <!-- Text content mapping (only content with non-space characters) -->
                            <xsl:for-each select="text()[normalize-space()]">
                                <xsl:if test="position() &gt; 1">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                                <xsl:value-of select="normalize-space(.)"></xsl:value-of>
                            </xsl:for-each>
                        </foaf:name>
                    </xsl:for-each>
                    <!-- Tag mapping: rdaGr2:dateOfDeath -> rdagr2:dateOfDeath -->
                    <xsl:for-each select="./rdaGr2:dateOfDeath">
                        <rdagr2:dateOfDeath>
                            <!-- Text content mapping (only content with non-space characters) -->
                            <xsl:for-each select="text()[normalize-space()]">
                                <xsl:if test="position() &gt; 1">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                                <xsl:value-of select="normalize-space(.)"></xsl:value-of>
                            </xsl:for-each>
                        </rdagr2:dateOfDeath>
                    </xsl:for-each>
                    <!-- Tag mapping: rdaGr2:preferredNameForThePerson -> skos:prefLabel -->
                    <xsl:for-each select="./rdaGr2:preferredNameForThePerson">
                        <skos:prefLabel>
                            <!-- Text content mapping (only content with non-space characters) -->
                            <xsl:for-each select="text()[normalize-space()]">
                                <xsl:if test="position() &gt; 1">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                                <xsl:value-of select="normalize-space(.)"></xsl:value-of>
                            </xsl:for-each>
                        </skos:prefLabel>
                    </xsl:for-each>
                    <!-- Tag mapping: skos:prefLabel -> skos:prefLabel -->
                    <xsl:for-each select="./skos:prefLabel">
                        <skos:prefLabel>
                            <!-- Text content mapping (only content with non-space characters) -->
                            <xsl:for-each select="text()[normalize-space()]">
                                <xsl:if test="position() &gt; 1">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                                <xsl:value-of select="normalize-space(.)"></xsl:value-of>
                            </xsl:for-each>
                        </skos:prefLabel>
                    </xsl:for-each>
                </xsl:for-each>
            </edm:Agent>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>