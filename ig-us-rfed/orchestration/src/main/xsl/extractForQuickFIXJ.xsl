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

    <!-- filter out deprecated codes -->
    <!-- this is added to remove duplicates with differing case as these cause a problem with QFJ code generation"
         only remove this specific deprecated case to avoid problems with QuickFIX/J test compilation
         ..fixr:codeSet name="BenchmarkCurveNameCodeSet" id="221" type="String"..    -->
    <xsl:template
        match="fixr:codeSet[@id='221']/fixr:code[@deprecated]"/>
    <!-- remove bug -->
    <xsl:template
        match="fixr:codeSet[@name='NoStreamAssetAttributesCodeSet']"/>
    <!-- This group is not defined so references to it need to be removed to prevent QFJ null ptr exceptions -->
    <!-- fixr:groupRef added="FIX.5.0SP2" addedEP="254" id="2266" -->
    <!--     <fixr:component name="CollateralReinvestmentGrp" id="2266" category="Common" added="FIX.5.0SP2" addedEP="254" abbrName="CollRnvstmnt">     -->
	<xsl:template
        match="fixr:groupRef[@id='2266']"/>     
	<xsl:template
        match="fixr:component[@id='2266']"/>
	<xsl:template
        match="fixr:componentRef[@id='2266']"/>      
	<xsl:template
        match="fixr:componentRef[@id='2266']"/>      
	<!-- The following code has type "char" but is multi-character -->
	<!-- 	<fixr:code name="ManualOrderIdentifier" id="1081011" value="10" sort="10" added="FIX.5.0SP2" addedEP="253"> -->
	<xsl:template
        match="fixr:codeSet[@id='1081']/fixr:code[@id='1081011']"/> 
    
    <!-- replace incorrect type for NoStreamAssetAttributesCodeSet -->
    <xsl:template match="fixr:fields/fixr:field/@type">
        <xsl:attribute name="type">
            <xsl:choose>
                <xsl:when test=". = 'NoStreamAssetAttributesCodeSet'">
                    <xsl:attribute name="type">
                        <xsl:text>NumInGroup</xsl:text>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="." />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>

    <!-- filter out session layer messages -->
    <xsl:template
        match="fixr:message[(@msgType='0' or
                             @msgType='1' or
                             @msgType='2' or
                             @msgType='3' or
                             @msgType='4' or
                             @msgType='5' or
                             @msgType='A') ]" />

</xsl:stylesheet>
