<?xml version="1.0" encoding="UTF-8"?>
<!--
  Document   : gnd_updated_v1.1.xsl
  Authors    : Eleftheria, Hugo
  Created on : ?
  Updated on : 27.01.2026

Changes:
* mapped gnd#NomenclatureInBiologyOrChemistry, gnd#HistoricSingleEventOrEra, gnd#Work &
gnd#ConferenseOrEvent to skos:Concept
* mapped gnd#Company to edm:Agent
* added 'xml:lang="de"' to literal values that are not lang tagged
* un-mapped skos:altLabel for CorporateBodies, Persons and TerritorialCorpBodiesOrAdminUnits
* mapped gndo:dateOfEstablishment to edm:begin for CorpBodies
* simplified mappings and replaced the switch with templates for easier maintenance
* adjusted prefLabel mapping for gnd#preferredNameForThePlaceOrGeographicName

-->
<!DOCTYPE xsl:stylesheet [
  <!ENTITY gnd "https://d-nb.info/standards/elementset/gnd#">
  ]>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gndo="https://d-nb.info/standards/elementset/gnd#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:edm="http://www.europeana.eu/schemas/edm/"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:rdagr2="http://rdvocab.info/ElementsGr2/"
  exclude-result-prefixes="gndo">

    <xsl:param name="targetId" />
    <xsl:output indent="yes" encoding="UTF-8" />

    <xsl:template match="/rdf:RDF">
        <xsl:apply-templates select="rdf:Description[@rdf:about = $targetId]" />
    </xsl:template>

    <!-- For 'corporate bodies' -->
    <xsl:template
      match="rdf:Description[rdf:type/@rdf:resource[
            . = '&gnd;CorporateBody'
         or . = '&gnd;Company'
         or . = '&gnd;SeriesOfConferenceOrEvent']]">
        <edm:Agent>
            <xsl:copy-of select="@rdf:about" />
            <!-- Tag mapping: gndo:preferredNameForTheCorporateBody -> skos:prefLabel -->
            <xsl:for-each select="gndo:preferredNameForTheCorporateBody">
                <skos:prefLabel>
                    <xsl:apply-templates select="." mode="label" />
                </skos:prefLabel>
            </xsl:for-each>
            <!-- Tag mapping: gndo:variantNameForTheCorporateBody -> skos:altLabel -->
            <!--
            <xsl:for-each select="gndo:variantNameForTheCorporateBody">
                <skos:altLabel>
                    <xsl:apply-templates select="." mode="label"/>
                </skos:altLabel>
            </xsl:for-each>
             -->
            <!-- Tag mapping: gndo:dateOfEstablishment -> edm:begin -->
            <xsl:for-each select="gndo:dateOfEstablishment">
                <edm:begin>
                    <xsl:apply-templates select="." mode="label" />
                </edm:begin>
            </xsl:for-each>
            <!-- Tag mapping: owl:sameAs -> owl:sameAs -->
            <xsl:copy-of select="owl:sameAs" copy-namespaces="no" />
        </edm:Agent>
    </xsl:template>


    <!-- For 'differentiated person' and 'royal or member of a royal house'. -->
    <xsl:template
      match="rdf:Description[rdf:type/@rdf:resource[
            . = '&gnd;DifferentiatedPerson'
         or . = '&gnd;RoyalOrMemberOfARoyalHouse']]">
        <edm:Agent>
            <xsl:copy-of select="@rdf:about" />
            <!-- Tag mapping: gndo:preferredNameForThePerson -> skos:prefLabel -->
            <xsl:for-each select="gndo:preferredNameForThePerson">
                <skos:prefLabel>
                    <xsl:apply-templates select="." mode="label" />
                </skos:prefLabel>
            </xsl:for-each>
            <!-- Tag mapping: gndo:dateOfBirth -> rdagr2:dateOfBirth -->
            <xsl:for-each select="gndo:dateOfBirth">
                <rdagr2:dateOfBirth>
                    <!-- Attribute mapping: rdf:datatype -> rdf:datatype -->
                    <xsl:copy-of select="@rdf:datatype" />
                    <!-- Text content mapping (only content with non-space characters) -->
                    <xsl:for-each select="text()[normalize-space()]">
                        <xsl:if test="position() &gt; 1">
                            <xsl:text> </xsl:text>
                        </xsl:if>
                        <xsl:value-of select="normalize-space(.)" />
                    </xsl:for-each>
                </rdagr2:dateOfBirth>
            </xsl:for-each>
            <!-- Tag mapping: gndo:dateOfDeath -> rdagr2:dateOfDeath -->
            <xsl:for-each select="gndo:dateOfDeath">
                <rdagr2:dateOfDeath>
                    <!-- Attribute mapping: rdf:datatype -> rdf:datatype -->
                    <xsl:copy-of select="@rdf:datatype" />
                    <!-- Text content mapping (only content with non-space characters) -->
                    <xsl:for-each select="text()[normalize-space()]">
                        <xsl:if test="position() &gt; 1">
                            <xsl:text> </xsl:text>
                        </xsl:if>
                        <xsl:value-of select="normalize-space(.)" />
                    </xsl:for-each>
                </rdagr2:dateOfDeath>
            </xsl:for-each>
            <xsl:copy-of select="owl:sameAs" copy-namespaces="no" />
        </edm:Agent>
    </xsl:template>


    <!-- For 'subject heading senso stricto' & 'historic single events or eras'. -->
    <xsl:template
      match="rdf:Description[rdf:type/@rdf:resource[
            . = '&gnd;SubjectHeadingSensoStricto'
         or . = '&gnd;HistoricSingleEventOrEra']]">
        <skos:Concept>
            <xsl:copy-of select="@rdf:about" />
            <!-- Tag mapping: gndo:preferredNameForTheSubjectHeading -> skos:prefLabel -->
            <xsl:for-each select="gndo:preferredNameForTheSubjectHeading">
                <skos:prefLabel>
                    <xsl:apply-templates select="." mode="label" />
                </skos:prefLabel>
            </xsl:for-each>
            <!-- Tag mapping: gndo:variantNameForTheSubjectHeading -> skos:altLabel -->
            <xsl:for-each select="gndo:variantNameForTheSubjectHeading">
                <skos:altLabel>
                    <xsl:apply-templates select="." mode="label" />
                </skos:altLabel>
            </xsl:for-each>
            <!-- Tag mapping: gndo:definition -> skos:note -->
            <xsl:for-each select="gndo:definition">
                <skos:note>
                    <xsl:apply-templates select="." mode="label" />
                </skos:note>
            </xsl:for-each>
            <xsl:copy-of select="skos:broadMatch" copy-namespaces="no" />
            <xsl:copy-of select="skos:closeMatch" copy-namespaces="no" />
            <!-- Tag mapping: owl:sameAs -> skos:exactMatch -->
            <xsl:for-each select="owl:sameAs">
                <skos:exactMatch>
                    <xsl:copy-of select="@rdf:resource" />
                </skos:exactMatch>
            </xsl:for-each>
        </skos:Concept>
    </xsl:template>


    <!-- For 'NomenclatureInBiologyOrChemistry'. -->
    <xsl:template
      match="rdf:Description[rdf:type/@rdf:resource[
            . = '&gnd;NomenclatureInBiologyOrChemistry']]">
        <skos:Concept>
            <xsl:copy-of select="@rdf:about" />
            <!-- Tag mapping: gndo:preferredNameForTheSubjectHeading -> skos:prefLabel -->
            <xsl:for-each select="gndo:preferredNameForTheSubjectHeading">
                <skos:prefLabel>
                    <xsl:apply-templates select="." mode="label" />
                </skos:prefLabel>
            </xsl:for-each>
            <xsl:copy-of select="skos:closeMatch" copy-namespaces="no" />
            <!-- Tag mapping: owl:sameAs -> skos:exactMatch -->
            <xsl:for-each select="owl:sameAs">
                <skos:exactMatch>
                    <xsl:copy-of select="@rdf:resource" />
                </skos:exactMatch>
            </xsl:for-each>
        </skos:Concept>
    </xsl:template>


    <!-- For 'Works'. -->
    <xsl:template match="rdf:Description[rdf:type/@rdf:resource[
            . = '&gnd;Work']]">
        <skos:Concept>
            <xsl:copy-of select="@rdf:about" />
            <xsl:for-each select="gndo:preferredNameForTheWork">
                <skos:prefLabel>
                    <xsl:apply-templates select="." mode="label" />
                </skos:prefLabel>
            </xsl:for-each>
            <!-- Tag mapping: gndo:biographicalOrHistoricalInformation -> skos:note -->
            <xsl:for-each select="gndo:biographicalOrHistoricalInformation">
                <skos:note>
                    <xsl:apply-templates select="." mode="label" />
                </skos:note>
            </xsl:for-each>
            <!-- Tag mapping: owl:sameAs -> skos:exactMatch -->
            <xsl:for-each select="owl:sameAs">
                <skos:exactMatch>
                    <xsl:copy-of select="@rdf:resource" />
                </skos:exactMatch>
            </xsl:for-each>
        </skos:Concept>
    </xsl:template>


    <!-- For 'Conference Or Event'. -->
    <xsl:template
      match="rdf:Description[rdf:type/@rdf:resource[
            . = '&gnd;ConferenceOrEvent']]">
        <skos:Concept>
            <xsl:copy-of select="@rdf:about" />
            <!-- Tag mapping: gndo:preferredNameForTheSubjectHeading -> skos:prefLabel -->
            <xsl:for-each select="gndo:preferredNameForTheSubjectHeading">
                <skos:prefLabel>
                    <xsl:apply-templates select="." mode="label" />
                </skos:prefLabel>
            </xsl:for-each>
            <!-- Tag mapping: gndo:variantNameForTheSubjectHeading -> skos:altLabel -->
            <xsl:for-each select="gndo:variantNameForTheSubjectHeading">
                <skos:altLabel>
                    <xsl:apply-templates select="." mode="label" />
                </skos:altLabel>
            </xsl:for-each>
            <!-- Tag mapping: gndo:definition -> skos:note -->
            <xsl:for-each select="gndo:definition">
                <skos:note>
                    <xsl:apply-templates select="." mode="label" />
                </skos:note>
            </xsl:for-each>
            <!-- Tag mapping: owl:sameAs -> skos:exactMatch -->
            <xsl:copy-of select="owl:sameAs" copy-namespaces="no" />
        </skos:Concept>
    </xsl:template>


    <!-- For 'territorial corporate body or administrative unit'. -->
    <xsl:template
      match="rdf:Description[rdf:type/@rdf:resource[
            . = '&gnd;TerritorialCorporateBodyOrAdministrativeUnit']]">
        <edm:Place>
            <xsl:copy-of select="@rdf:about" />
            <!-- Tag mapping: gndo:preferredNameForThePlaceOrGeographicName -> skos:prefLabel -->
            <xsl:for-each select="./gndo:preferredNameForThePlaceOrGeographicName">
                <skos:prefLabel>
                    <xsl:apply-templates select="." mode="label" />
                </skos:prefLabel>
            </xsl:for-each>
            <!-- Tag mapping: gndo:oldAuthorityNumber -> dc:identifier -->
            <xsl:for-each select="./gndo:oldAuthorityNumber">
                <dc:identifier>
                    <xsl:copy-of select="text()" />
                </dc:identifier>
            </xsl:for-each>
            <!-- Tag mapping: owl:sameAs -> owl:sameAs -->
            <xsl:copy-of select="owl:sameAs" copy-namespaces="no" />
        </edm:Place>
    </xsl:template>


    <!-- To cover unmapped entities -->
    <xsl:template match="rdf:Description" />
    <!-- to copy labels and set a default language to German -->
    <xsl:template match="node()" mode="label">
        <xsl:choose>
            <xsl:when test="@xml:lang">
                <xsl:copy-of select="@xml:lang" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="xml:lang">
                    <xsl:text>de</xsl:text>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:for-each select="text()[normalize-space()]">
            <xsl:if test="position() &gt; 1">
                <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:value-of select="normalize-space(.)" />
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>