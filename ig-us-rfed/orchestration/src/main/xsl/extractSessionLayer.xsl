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

    <!-- filter out FIX Session Layer messages -->
    <xsl:template
        match="fixr:message[(@msgType='0' or
                             @msgType='1' or
                             @msgType='2' or
                             @msgType='3' or
                             @msgType='4' or
                             @msgType='5' or
                             @msgType='A') ]" />

    <!-- filter out FIX Session Layer fields -->
    <xsl:template match="fixr:fields/fixr:field[(   @id='7'
                                                    or @id='10'
                                                    or @id='16'
                                                    or @id='34'
                                                    or @id='36'
                                                    or @id='45'
                                                    or @id='95'
                                                    or @id='96'
                                                    or @id='98'
                                                    or @id='108'
                                                    or @id='112'
                                                    or @id='123'
                                                    or @id='141'
                                                    or @id='354'
                                                    or @id='355'
                                                    or @id='371'
                                                    or @id='373'
                                                    or @id='383'
                                                    or @id='464'
                                                    or @id='553'
                                                    or @id='554'
                                                    or @id='789'
                                                    or @id='925'
                                                    or @id='1130'
                                                    or @id='1131'
                                                    or @id='1137'
                                                    or @id='1400'
                                                    or @id='1401'
                                                    or @id='1402'
                                                    or @id='1403'
                                                    or @id='1404'
                                                    or @id='1406'
                                                    or @id='1407'
                                                    or @id='1408'
                                                    or @id='1409') ]" />

    <!-- Remove Session category -->
    <xsl:template match="fixr:categories/fixr:category[(@name='Session') ]" />

    <!-- Extract standard header fields apart from the following tags -->
    <xsl:template
            match="fixr:components/fixr:component[@id='1024']/fixr:fieldRef[not(@id='35' or
                                                                                @id='1128' or
                                                                                @id='1129' or
                                                                                @id='52')]" />


    <!-- Extract standard trailer component -->
    <xsl:template match="fixr:message/fixr:structure/fixr:componentRef[@id='1025']" />
    <xsl:template match="fixr:components/fixr:component[@id='1025']" />

</xsl:stylesheet>
