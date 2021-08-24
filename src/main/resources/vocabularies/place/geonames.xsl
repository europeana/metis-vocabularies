<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0"
                xmlns:dcterms="http://purl.org/dc/terms/"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:wgs84_pos="http://www.w3.org/2003/01/geo/wgs84_pos#"
                xmlns:edm="http://www.europeana.eu/schemas/edm/"
                xmlns:owl="http://www.w3.org/2002/07/owl#"

                xmlns:gn="http://www.geonames.org/ontology#"
                xmlns:cc="http://creativecommons.org/ns#"
                xmlns:foaf="http://xmlns.com/foaf/0.1/"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"

                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:lib="http://example.org/lib"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="fn gn cc foaf rdfs xs lib"
                >

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    <xsl:param  name="targetId"/>

    <xsl:param name="langs">en,pl,de,nl,fr,it,da,sv,el,fi,hu,cs,sl,et,pt,es,lt,lv,bg,ro,sk,hr,ga,mt,no,ca,ru</xsl:param>

    <xsl:variable name="dbpedia"
                  select="'http(s)?://([a-z]+[.])?dbpedia[.]org/resource/.*'"/>

    <xsl:template match="/">
        <xsl:apply-templates select="rdf:RDF"/>
    </xsl:template>

    <xsl:template match="rdf:RDF">
        <xsl:apply-templates select="gn:Feature[@rdf:about=$targetId]"/>
    </xsl:template>

    <xsl:template match="gn:Feature">

        <xsl:element name="edm:Place">

            <xsl:copy-of select="@rdf:about"/>

            <!-- labels -->
            <xsl:call-template name="labels">
                <xsl:with-param name="pref" select="gn:name|gn:officialName"/>
                <xsl:with-param name="alt"  select="gn:alternateName|gn:colloquialName|gn:historicalName|gn:shortName"/>
            </xsl:call-template>

            <!-- coordinates -->
            <xsl:for-each select="wgs84_pos:lat">
                <xsl:element name="wgs84_pos:lat">
                    <xsl:copy-of select="text()"/>
                </xsl:element>
            </xsl:for-each>
            <xsl:for-each select="wgs84_pos:long">
                <xsl:element name="wgs84_pos:long">
                    <xsl:copy-of select="text()"/>
                </xsl:element>
            </xsl:for-each>

            <!-- hierarchy -->
            <xsl:for-each select="gn:parentFeature">
                <xsl:element name="dcterms:isPartOf">
                    <xsl:copy-of select="@rdf:resource"/>
                </xsl:element>
            </xsl:for-each>

            <!-- coreferencing -->
            <xsl:for-each select="owl:sameAs">
                <xsl:element name="owl:sameAs">
                    <xsl:copy-of select="@rdf:resource"/>
                </xsl:element>
            </xsl:for-each>

            <xsl:for-each select="rdfs:seeAlso">
                <xsl:variable name="ref" select="@rdf:resource"/>
                <xsl:if test="matches(string($ref),$dbpedia)">
                    <xsl:element name="owl:sameAs">
                        <xsl:attribute name="rdf:resource">
                            <xsl:copy-of select="replace($ref,'https://','http://')"/>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:if>
            </xsl:for-each>

        </xsl:element>

    </xsl:template>

    <!--                          LANGUAGE UTILS                             -->

    <xsl:template name="labels">
        <xsl:param name="pref"/>
        <xsl:param name="alt"/>

        <xsl:variable name="labels"
                      select="$pref[lib:isAcceptableLang(@xml:lang)]"/>

        <xsl:choose>
            <xsl:when test="$labels">
                <xsl:for-each select="$labels">
                    <xsl:element name="skos:prefLabel">
                        <xsl:copy-of select="@xml:lang"/>
                        <xsl:value-of select="."/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="$pref">
                    <xsl:element name="skos:prefLabel">
                        <xsl:copy-of select="@xml:lang"/>
                        <xsl:value-of select="."/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>

        <xsl:for-each select="$alt">
            <xsl:variable name="literal" select="text()"/>
            <xsl:variable name="lang"    select="@xml:lang"/>
            <xsl:if test="lib:isAcceptableLang($lang) 
                      and not($labels[text()=$literal and @xml:lang=$lang])">
                <xsl:element name="skos:altLabel">
                    <xsl:copy-of select="@xml:lang"/>
                    <xsl:value-of select="$literal" />
                </xsl:element>
            </xsl:if>
        </xsl:for-each>

    </xsl:template>

    <xsl:function name="lib:isAcceptableLang" as="xs:boolean">
        <xsl:param name="string"/>
        <xsl:sequence select="$string!='' and contains($langs,lower-case($string))"/>
    </xsl:function>

</xsl:stylesheet>
