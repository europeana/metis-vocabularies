<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:edm="http://www.europeana.eu/schemas/edm/"
        xmlns:dc="http://purl.org/dc/elements/1.1/"
        xmlns:dcterms="http://purl.org/dc/terms/"
        xmlns:foaf="http://xmlns.com/foaf/0.1/"
        xmlns:skos="http://www.w3.org/2004/02/skos/core#"
        xmlns:owl="http://www.w3.org/2002/07/owl#"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
        xmlns:rdaGr2="http://rdvocab.info/ElementsGr2/"

        xmlns:fn="http://www.w3.org/2005/xpath-functions"
        xmlns:doc="http://www.example.org/functions"
        xmlns:xs="http://www.w3.org/2001/XMLSchema"

        xmlns:wdt="http://www.wikidata.org/prop/direct/"
        xmlns:schema="http://schema.org/"

        xmlns:xalan="http://xml.apache.org/xalan"
        xmlns:lib="http://example.org/lib"

        exclude-result-prefixes="dcterms foaf wdt schema">

    <xsl:output indent="yes" encoding="UTF-8"/>

    <xsl:param name="targetId"/>

    <xsl:variable name="namespace" select="'http://www.wikidata.org/prop/direct/'"/>
    <!-- Portal languages (27) -->
    <xsl:variable name="langs">en,pl,de,nl,fr,it,da,sv,el,fi,hu,cs,sl,et,pt,es,lt,lv,bg,ro,sk,hr,ga,mt,no,ca,ru</xsl:variable>

    <xsl:template match="/">
        <xsl:apply-templates select="rdf:RDF"/>
    </xsl:template>

    <xsl:template match="rdf:RDF">
        <xsl:apply-templates select="rdf:Description[@rdf:about=$targetId]"/>
    </xsl:template>

    <xsl:template match="rdf:Description">
        <xsl:choose>

            <xsl:when test="count(*[fn:namespace-uri()!='http://www.wikidata.org/prop/'
                                and fn:name()!='rdf:type'])=0">
            </xsl:when>

                <!-- Agents: Individuals (real and fictional) -->

            <!-- instance of: Human (Q5), Fictional Human (Q15632617)
                            , Fictional Character (Q95074), Pen name (Q127843)
                            , Heteronym (Q1136342) -->
            <xsl:when test="wdt:P31[@rdf:resource='http://www.wikidata.org/entity/Q5'
                                 or @rdf:resource='http://www.wikidata.org/entity/Q15632617'
                                 or @rdf:resource='http://www.wikidata.org/entity/Q95074'
                                 or @rdf:resource='http://www.wikidata.org/entity/Q127843'
                                 or @rdf:resource='http://www.wikidata.org/entity/Q1136342']">
                <xsl:call-template name="AgentIndividual"/>
            </xsl:when>

            <!-- Agents: Organisations -->

            <!-- containing property: P571 (inception), P576 (dissolved)
                                    , P452 (industry), P159 (headquarters location)
                                    , P749 (parent organisation), P1128 (employees)
                                    , P1454 (legal form) -->
            <xsl:when test="wdt:P571 | wdt:P576 | wdt:P452 | wdt:P159
                          | wdt:P749 | wdt:P1128 | wdt:P1454">
                <xsl:call-template name="AgentOrganization"/>
            </xsl:when>

            <!-- instance of: Fashion label (Q1618899), Fashion House (Q3661311) -->
            <xsl:when test="wdt:P31[@rdf:resource='http://www.wikidata.org/entity/Q1618899'
                                 or @rdf:resource='http://www.wikidata.org/entity/Q3661311']">
                <xsl:call-template name="AgentOrganization"/>
            </xsl:when>

            <!-- Concepts -->

            <!-- everything else is mapped to concept -->
            <xsl:otherwise>
                <xsl:call-template name="Concept"/>
            </xsl:otherwise>

        </xsl:choose>

    </xsl:template>


    <!-- MAPPINGS FOR EACH CONTEXTUAL ENTITY -->

    <xsl:template name="AgentOrganization">
        <edm:Agent>
            <xsl:copy-of select="@rdf:about"/>

            <!-- labels -->
            <xsl:call-template name="labels">
                <xsl:with-param name="alt" select="skos:altLabel"/>
            </xsl:call-template>

            <!-- descriptions -->
            <xsl:for-each select="schema:description">
                <xsl:if test="contains($langs,@xml:lang)">
                    <xsl:element name="skos:note">
                        <xsl:copy-of select="@xml:lang"/>
                        <xsl:value-of select="."/>
                    </xsl:element>
                </xsl:if>
            </xsl:for-each>

            <!-- dates -->
            <xsl:for-each select="wdt:P571">
                <xsl:element name="rdaGr2:dateOfEstablishment">
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:for-each>
            <xsl:for-each select="wdt:P576">
                <xsl:element name="rdaGr2:dateOfTermination">
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:for-each>

        </edm:Agent>
    </xsl:template>

    <xsl:template name="AgentIndividual">
        <edm:Agent>
            <xsl:copy-of select="@rdf:about"/>

            <!-- labels -->
            <xsl:call-template name="labels">
                <xsl:with-param name="alt" select="skos:altLabel | wdt:P742
                                                 | wdt:P1477 | wdt:P2562"/>
            </xsl:call-template>

            <!-- description -->
            <xsl:for-each select="schema:description">
                <xsl:if test="contains($langs,@xml:lang)">
                    <xsl:element name="skos:note">
                        <xsl:copy-of select="@xml:lang"/>
                        <xsl:value-of select="."/>
                    </xsl:element>
                </xsl:if>
            </xsl:for-each>

            <!-- gender -->
            <xsl:for-each select="wdt:P21">
                <xsl:choose>
                    <xsl:when test="@rdf:resource='http://www.wikidata.org/entity/Q6581097'">
                        <xsl:element name="rdaGr2:gender" xml:lang="en">Male</xsl:element>
                    </xsl:when>
                    <xsl:when test="@rdf:resource='http://www.wikidata.org/entity/Q6581072'">
                        <xsl:element name="rdaGr2:gender" xml:lang="en">Female</xsl:element>
                    </xsl:when>
                    <xsl:when test="@rdf:resource='http://www.wikidata.org/entity/Q1052281'">
                        <xsl:element name="rdaGr2:gender" xml:lang="en">Transgender woman</xsl:element>
                    </xsl:when>
                    <xsl:when test="@rdf:resource='http://www.wikidata.org/entity/Q1097630'">
                        <xsl:element name="rdaGr2:gender" xml:lang="en">Intersex</xsl:element>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>

            <!-- places -->
            <xsl:for-each select="wdt:P19">
                <xsl:element name="rdaGr2:placeOfBirth">
                    <xsl:copy-of select="@rdf:resource"/>
                </xsl:element>
            </xsl:for-each>
            <xsl:for-each select="wdt:P20">
                <xsl:element name="rdaGr2:placeOfBirth">
                    <xsl:copy-of select="@rdf:resource"/>
                </xsl:element>
            </xsl:for-each>

            <!-- dates -->

            <xsl:for-each select="wdt:P569">
                <xsl:element name="rdaGr2:dateOfBirth">
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:for-each>
            <xsl:for-each select="wdt:P570">
                <xsl:element name="rdaGr2:dateOfDeath">
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:for-each>

            <!-- professions or occupations -->

            <xsl:for-each select="wdt:P39 | wdt:P97 | wdt:P101 | wdt:P106">
                <xsl:element name="rdaGr2:professionOrOccupation">
                    <xsl:copy-of select="@rdf:resource"/>
                </xsl:element>
            </xsl:for-each>

        </edm:Agent>
    </xsl:template>

    <xsl:template name="Concept">

        <skos:Concept>

            <xsl:copy-of select="@rdf:about"/>

            <!-- labels -->
            <xsl:call-template name="labels">
                <xsl:with-param name="alt" select="skos:altLabel"/>
            </xsl:call-template>

            <xsl:for-each select="schema:description">
                <xsl:if test="contains($langs,@xml:lang)">
                    <xsl:element name="skos:note">
                        <xsl:copy-of select="@xml:lang"/>
                        <xsl:value-of select="."/>
                    </xsl:element>
                </xsl:if>
            </xsl:for-each>

            <xsl:for-each select="wdt:P31 | wdt:P279 | wdt:P2445">
                <xsl:element name="skos:broader">
                    <xsl:copy-of select="@rdf:resource"/>
                </xsl:element>
            </xsl:for-each>

        </skos:Concept>

    </xsl:template>


    <!-- FUNCTIONS -->

    <xsl:template name="labels">
        <xsl:param name="alt"/>

        <xsl:variable name="labels"
                select="rdfs:label[contains($langs,@xml:lang)]"/>

        <xsl:for-each select="$labels">
            <xsl:element name="skos:prefLabel">
                <xsl:copy-of select="@xml:lang"/>
                <xsl:value-of select="."/>
            </xsl:element>
        </xsl:for-each>

        <xsl:for-each select="$alt">
            <xsl:variable name="literal" select="text()"/>
            <xsl:variable name="lang"    select="@xml:lang"/>
            <xsl:if test="contains($langs,$lang) and not($labels[text()=$literal and @xml:lang=$lang])">
                <xsl:element name="skos:altLabel">
                    <xsl:copy-of select="@xml:lang"/>
                    <xsl:value-of select="$literal" />
                </xsl:element>
            </xsl:if>
        </xsl:for-each>

    </xsl:template>

</xsl:stylesheet>
