<?xml version="1.0" encoding="UTF-8"?>
<!--
  Document   : yso2concept.xsl
  Author     : Ele, Hugo
  Created on : 
  Updated on : Feb 13, 2024
  Version    : v1.1

changes:
* cover ysometa:Concept when present as a RDF declaration or as value of a rdf:type property
* fixed issue with relations not being mapped
* filter out unwanted languages

-->

<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#" 
    xmlns:ysometa="http://www.yso.fi/onto/yso-meta/"

    xmlns:lib="http://example.org/lib"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"

    exclude-result-prefixes="xsl ysometa lib xs"
    >

    <xsl:param name="targetId"/>
    <xsl:output indent="yes" encoding="UTF-8"/>

    <!-- Portal languages (28) -->
    <xsl:param name="langs">en,pl,de,nl,fr,it,da,sv,el,fi,hu,cs,sl,et,pt,es,lt,lv,bg,ro,sk,hr,ga,mt,no,ca,ru,eu</xsl:param>

    <!-- Main template -->
    <xsl:template match="/rdf:RDF">

        <xsl:apply-templates select="ysometa:Concept[@rdf:about=$targetId] 
                                   | skos:Concept[@rdf:about=$targetId 
                                              and rdf:type/@rdf:resource='http://www.yso.fi/onto/yso-meta/Concept']"/>

    </xsl:template>

    <xsl:template match="ysometa:Concept | skos:Concept">
        <skos:Concept>

            <!-- Attribute mapping: rdf:about -> rdf:about -->
            <xsl:copy-of select="@rdf:about"/>

            <!-- Tag mapping: skos:prefLabel -> skos:prefLabel -->
            <xsl:apply-templates select="skos:prefLabel" mode="copy_literal"/>

            <!-- Tag mapping: skos:altLabel -> skos:altLabel -->
            <xsl:apply-templates select="skos:altLabel" mode="copy_literal"/>

            <!-- Tag mapping: skos:notation -> skos:notation -->
            <xsl:apply-templates select="skos:notation" mode="copy_literal"/>

            <!-- Tag mapping: skos:definition -> skos:note -->
            <xsl:for-each select="skos:definition">
                <skos:note>

                    <!-- Attribute mapping: xml:lang -> xml:lang -->
                    <xsl:copy-of select="@xml:lang"/>

                    <!-- Text content mapping -->
                    <xsl:copy-of select="text()"/>

                </skos:note>
            </xsl:for-each>

            <!-- Tag mapping: skos:broader -> skos:broader -->
            <xsl:apply-templates select="skos:broader" mode="copy_resource"/>

            <!-- Tag mapping: skos:narrower -> skos:narrower -->
            <!-- 
            <xsl:apply-templates select="skos:narrower" mode="copy_resource"/>
            -->

            <!-- Tag mapping: skos:related -> skos:related -->
            <xsl:apply-templates select="skos:related" mode="copy_resource"/>

            <!-- Tag mapping: skos:broadMatch -> skos:broadMatch -->
            <xsl:apply-templates select="skos:broadMatch" mode="copy_resource"/>

            <!-- Tag mapping: skos:narrowMatch -> skos:narrowMatch -->
            <!-- 
            <xsl:apply-templates select="skos:narrowMatch" mode="copy_resource"/>
             -->

            <!-- Tag mapping: skos:relatedMatch -> skos:relatedMatch -->
            <xsl:apply-templates select="skos:relatedMatch" mode="copy_resource"/>

            <!-- Tag mapping: skos:exactMatch -> skos:exactMatch -->
            <xsl:apply-templates select="skos:exactMatch" mode="copy_resource"/>

            <!-- Tag mapping: skos:closeMatch -> skos:closeMatch -->
            <xsl:apply-templates select="skos:closeMatch" mode="copy_resource"/>

            <!-- Tag mapping: skos:inScheme -> skos:inScheme -->
            <xsl:apply-templates select="skos:inScheme" mode="copy_resource"/>

        </skos:Concept>
    </xsl:template>


    <!-- Template for literals. We can't just copy: we'd get all context namespace declarations. -->
    <xsl:template match="*" mode="copy_literal">
        <xsl:if test="lib:isAcceptableLang(@xml:lang)">
	        <xsl:element name="{name()}" namespace="{namespace-uri()}">
	
	            <!-- Attribute mapping: xml:lang -> xml:lang -->
	            <xsl:copy-of select="@xml:lang"/>
	
	            <!-- Text content mapping -->
	            <xsl:copy-of select="text()"/>
	
	        </xsl:element>
	    </xsl:if>
    </xsl:template>

    <!-- Template for resources. -->
    <xsl:template match="*" mode="copy_resource">
        <xsl:element name="{name()}" namespace="{namespace-uri()}">
            <xsl:choose>

                <!-- Attribute mapping: rdf:resource -> rdf:resource -->
                <xsl:when test="@rdf:resource">
                    <xsl:copy-of select="@rdf:resource"/>
                </xsl:when>

                <!-- Attribute mapping: rdf:Description/rdf:about -> rdf:resource -->
                <xsl:otherwise>
                    <xsl:attribute name="rdf:resource">
                        <xsl:value-of select="*/@rdf:about"/>
                    </xsl:attribute>
                </xsl:otherwise>

            </xsl:choose>
        </xsl:element>
    </xsl:template>

<!--+++++++++++++++++++++++++++++ FUNCTIONS ++++++++++++++++++++++++++++++++-->

    <xsl:function name="lib:isAcceptableLang" as="xs:boolean">
        <xsl:param name="string"/>
        <xsl:sequence select="$string!='' and contains($langs,lower-case($string))"/>
    </xsl:function>

</xsl:stylesheet>
