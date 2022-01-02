<xsl:stylesheet version="FIX.5.0SP2"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:functx="http://www.functx.com"
    xmlns:fixr="http://fixprotocol.io/2020/orchestra/repository"
    xmlns:dc="http://purl.org/dc/elements/1.1/">
    <xsl:output method="xml" />
    <xsl:strip-space elements="*" />
    <xsl:output omit-xml-declaration="no" indent="yes" />

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

	<!--  remove session messages -->
    <xsl:template
            match="fixr:message[(@msgType='0' or
                             @msgType='1' or
                             @msgType='2' or
                             @msgType='3' or
                             @msgType='4' or
                             @msgType='5' or
                             @msgType='A') ]" />

</xsl:stylesheet>
