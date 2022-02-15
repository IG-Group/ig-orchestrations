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

    <!-- Extract fields from Logon message  -->
    <xsl:template
            match="fixr:message[@msgType='A']/fixr:structure/fixr:componentRef[not(@id='1024' or
                                                                                   @id='1025')]" />
    <xsl:template
            match="fixr:message[@msgType='A']/fixr:structure/fixr:fieldRef[not(@id='98' or
                                                                                 @id='108' or
                                                                                 @id='141' or
                                                                                 @id='553' or
                                                                                 @id='554' or
                                                                                 @id='1137' or
                                                                                 @id='1409')]" />
    <xsl:template
            match="fixr:message[@msgType='A']/fixr:structure/fixr:groupRef" />

    <!-- Extract fields from Logout message  -->
    <xsl:template
            match="fixr:message[@msgType='5']/fixr:structure/fixr:componentRef[not(@id='1024' or
                                                                                   @id='1025')]" />
    <xsl:template
            match="fixr:message[@msgType='5']/fixr:structure/fixr:fieldRef[not(@id='58')]" />

    <!-- Extract fields from Session Reject message  -->
    <xsl:template
            match="fixr:message[@msgType='3']/fixr:structure/fixr:componentRef[not(@id='1024' or
                                                                                   @id='1025')]" />
    <xsl:template
            match="fixr:message[@msgType='3']/fixr:structure/fixr:fieldRef[not(@id='45' or
                                                                               @id='58' or
                                                                               @id='371' or
                                                                               @id='372' or
                                                                               @id='373')]" />

</xsl:stylesheet>
