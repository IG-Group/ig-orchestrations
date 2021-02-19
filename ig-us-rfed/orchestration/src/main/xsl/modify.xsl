<xsl:stylesheet version="FIX.5.0SP2"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:functx="http://www.functx.com"
    xmlns:fixr="http://fixprotocol.io/2020/orchestra/repository"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:java="java"
    >
    <xsl:output method="xml" />
    <xsl:strip-space elements="*" />
    <xsl:output omit-xml-declaration="no" indent="yes" />
	<!-- this stylesheet modifies the orchestra file  -->
	
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

	<xsl:template match="fixr:metadata/dc:title/text()">
		<xsl:text>IG US FIX Orchestration</xsl:text>
	</xsl:template>
	<xsl:template match="fixr:metadata/dc:publisher/text()">
		<xsl:text>IG Group</xsl:text>
	</xsl:template>
	
	<xsl:template match="fixr:metadata/dc:date/text()">
		<!--  for the date see https://stackoverflow.com/questions/1575111/can-an-xslt-insert-the-current-date -->
		<xsl:text><xsl:value-of select="java:time.ZonedDateTime.now()"/></xsl:text>
	</xsl:template>	

	<xsl:template match="fixr:codeSets/fixr:codeSet[@name='SecurityIDSourceCodeSet']/fixr:code[@name='MarketplaceAssignedIdentifier']/fixr:annotation/fixr:documentation[@purpose='SYNOPSIS']/text()">
		<xsl:text>
			Stelios Changed me
		</xsl:text>
	</xsl:template>

	<xsl:template match="fixr:fields/fixr:field[@name='Side']/fixr:annotation/fixr:documentation[@purpose='SYNOPSIS']/text()">
		<xsl:text>
			Stelios Changed me was: Side description
		</xsl:text>
	</xsl:template>

</xsl:stylesheet>
