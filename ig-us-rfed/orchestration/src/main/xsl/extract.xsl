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
    <!-- this is added to remove duplicates with differing case   -->
    <xsl:template
        match="fixr:codeSet[@id='221']/fixr:code[@deprecated]"/>
    <!-- remove bug -->
    <xsl:template
        match="fixr:codeSet[@name='NoStreamAssetAttributesCodeSet']"/>

    <!-- replace incorrect type -->
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

    <!-- filter out unsupported messages -->
    <xsl:template
        match="fixr:message[not(@msgType='8' or
                                @msgType='9' or
                                @msgType='AF' or
                                @msgType='AG' or
                                @msgType='AN' or
                                @msgType='AO' or
                                @msgType='AP' or
                                @msgType='D' or
                                @msgType='E' or
                                @msgType='F' or
                                @msgType='G' or
                                @msgType='H' or
                                @msgType='j' or
                                @msgType='R' or
                                @msgType='S' or
                                @msgType='x' or
                                @msgType='y' or
                                @msgType='Z') ]" />

    <!-- filter out unsupported codeSets -->
    <xsl:template
        match="fixr:codeSets/fixr:codeSet[(@id='35')]/fixr:code[not(@value='8' or
                                                                    @value='9' or
                                                                    @value='AF' or
                                                                    @value='AG' or
                                                                    @value='AN' or
                                                                    @value='AO' or
                                                                    @value='AP' or
                                                                    @value='D' or
                                                                    @value='E' or
                                                                    @value='F' or
                                                                    @value='G' or
                                                                    @value='H' or
                                                                    @value='j' or
                                                                    @value='K' or
                                                                    @value='N' or
                                                                    @value='R' or
                                                                    @value='S' or
                                                                    @value='V' or
                                                                    @value='W' or
                                                                    @value='x' or
                                                                    @value='X' or
                                                                    @value='y' or
                                                                    @value='Y' or
                                                                    @value='Z') ]"/>

    <!-- filter out unsupported codes -->
    <!-- RefOrderIDSourceCodeSet   -->
    <xsl:template
        match="fixr:codeSets/fixr:codeSet[(@id='1081')]/fixr:code[not(@name='OrderID' or
                                                                     @name='ClOrdID')]"/>
    
    <!-- InstrAttribTypeCodeSet  -->
    <xsl:template
        match="fixr:codeSets/fixr:codeSet[(@id='871')]/fixr:code[not(@id='871027' or
                                                                     @id='871115' or
                                                                     @id='871116' or
                                                                     @id='871120')]"/>
    <!-- SecurityIdSource Codeset restriction -->                                                            
    <xsl:template
        match="fixr:codeSets/fixr:codeSet[(@id='22')]/fixr:code[not(@id='22022')]"/>

    <!-- PosReqType  -->
    <xsl:template
            match="fixr:codeSets/fixr:codeSet[(@id='724')]/fixr:code[not(@id='724001')]"/>

    <!-- filter out unsupported components -->
    <xsl:template
        match="fixr:components/fixr:component[not(@id='1024' or
                                                        @id='1003' or
                                                        @id='1004' or
                                                        @id='1011' or
                                                        @id='1021' or
                                                        @id='1013' or
                                                        @id='1058' or
                                                        @id='2131')]" />
    <!-- filter out unsupported groups -->
    <xsl:template
        match="fixr:groups/fixr:group[not(@id='1012' or
                                                @id='1014' or
                                                @id='1015' or
                                                @id='1031' or
                                                @id='2071' or
                                                @id='2045' or
                                                @id='2047' or
                                                @id='2593' or
                                                @id='1073' or
                                                @id='2030' or
                                                @id='2031' or
                                                @id='2032' or
                                                @id='2033' or
                                                @id='2037' or
                                                @id='2041' or
                                                @id='2022' or
                                                @id='2055' or
                                                @id='2066' or
                                                @id='2073' or
                                                @id='2074' )]" />

    <!-- Parties Grp, filter out unsupported members -->
    <xsl:template
        match="fixr:groups/fixr:group[(@id='1012')]/fixr:groupRef" />
    <xsl:template
        match="fixr:groups/fixr:group[(@id='1012')]/fixr:componentRef[not(@id='448' or
                                                                                @id='449' or
                                                                                @id='452'
                                                                                )]" />

    <!-- PositionQty Grp, filter out unsupported members -->
    <xsl:template
        match="fixr:groups/fixr:group[(@id='1015')]/fixr:groupRef" />
    <xsl:template
        match="fixr:groups/fixr:group[(@id='1015')]/fixr:fieldRef[not(@id='703' or
                                                                            @id='704' or
                                                                            @id='705' or
                                                                            @id='706' or
                                                                            @id='20101' or
                                                                            @id='20102' or
                                                                            @id='20103' )]" />


    <!-- Root Parties Grp, filter out unsupported members -->
    <xsl:template
        match="fixr:groups/fixr:group[(@id='1031')]/fixr:groupRef" />
    <xsl:template
        match="fixr:groups/fixr:group[(@id='1031')]/fixr:componentRef[not(@id='1117' or
                                                                                @id='1118' or
                                                                                @id='1119'
                                                                                )]" />

    <!-- List Ord Grp, filter out unsupported members -->
    <xsl:template
        match="fixr:groups/fixr:group[(@id='2030')]/fixr:componentRef[not(@id='1003' or @id='1011' or @id='1013')]" />
    <xsl:template
        match="fixr:groups/fixr:group[(@id='2030')]/fixr:groupRef[not(@id='1073')]" />
    <xsl:template
        match="fixr:groups/fixr:group[(@id='2030')]/fixr:fieldRef[not(@id='11' or
                                                                            @id='67' or
                                                                            @id='1' or
                                                                            @id='54' or
                                                                            @id='60' or
                                                                            @id='38' or
                                                                            @id='40' or
                                                                            @id='44' or
                                                                            @id='99' or
                                                                            @id='15' or
                                                                            @id='117' or
                                                                            @id='59' or
                                                                            @id='126' or
                                                                            @id='58')]" />

    <!-- Sec List Grp, filter out unsupported members -->
    <xsl:template
        match="fixr:groups/fixr:group[(@id='2055')]/fixr:componentRef[not(@id='1003' or
                                                                          @id='1004' or
                                                                          @id='1058'
                                                                          )]" />
    <xsl:template
        match="fixr:groups/fixr:group[(@id='2055')]/fixr:groupRef[not(@id='2066')]" />
    <xsl:template
        match="fixr:groups/fixr:group[(@id='2055')]/fixr:fieldRef[not(@id='15' or
                                                                            @id='58'
                                                                            )]" />

    <!-- Instrument Market Data Req Grp, filter out unsupported members -->
    <xsl:template
        match="fixr:groups/fixr:group[(@id='2022')]/fixr:componentRef[not(@id='1003' or
                                                                          @id='1004')]" />
    <xsl:template
        match="fixr:groups/fixr:group[(@id='2022')]/fixr:fieldRef" />
    <xsl:template
        match="fixr:groups/fixr:group[(@id='2022')]/fixr:groupRef[not(@id='2066')]" />


    <!-- Instrument Market Data Full Grp, filter out unsupported members -->
    <xsl:template
        match="fixr:groups/fixr:group[(@id='2031')]/fixr:groupRef" />
    <xsl:template
        match="fixr:groups/fixr:group[(@id='2031')]/fixr:componentRef" />
    <xsl:template
        match="fixr:groups/fixr:group[(@id='2031')]/fixr:fieldRef[not(@id='269' or
                                                                            @id='278' or
                                                                            @id='270' or
                                                                            @id='423' or
                                                                            @id='273' or
                                                                            @id='1070' or
                                                                            @id='117'
                                                                        )]" />

    <!-- Instrument Market Data Incr Grp, filter out unsupported members -->
    <xsl:template
        match="fixr:groups/fixr:group[(@id='2032')]/fixr:groupRef" />
    <xsl:template
        match="fixr:groups/fixr:group[(@id='2032')]/fixr:componentRef" />
    <xsl:template
        match="fixr:groups/fixr:group[(@id='2032')]/fixr:fieldRef[not(@id='279' or
                                                                            @id='269' or
                                                                            @id='278' or
                                                                            @id='270' or
                                                                            @id='423' or
                                                                            @id='273' or
                                                                            @id='1070' or
                                                                            @id='117'
                                                                        )]" />

    <!-- OrderListStatGrp filter out unsupported members -->
    <xsl:template
        match="fixr:groups/fixr:group[(@id='2037')]/fixr:groupRef" />
    <xsl:template
        match="fixr:groups/fixr:group[(@id='2037')]/fixr:componentRef" />
    <xsl:template
        match="fixr:groups/fixr:group[(@id='2037')]/fixr:fieldRef[not(@id='11' or
                                                                            @id='14' or
                                                                            @id='39' or
                                                                            @id='151' or
                                                                            @id='84' or
                                                                            @id='6' or
                                                                            @id='58'
                                                                        )]" />

    <!-- QuotReqGrp or QuotReqRjctGrp or QuotCxlEntriesGrp, filter out unsupported
        members -->
    <xsl:template
        match="fixr:groups/fixr:group[(@id='2041' or @id='2045' or @id='2047')]/fixr:componentRef[not(@id='1003')]" />
    <xsl:template
        match="fixr:groups/fixr:group[(@id='2041' or @id='2045' or @id='2047')]/fixr:fieldRef" />
    <xsl:template
        match="fixr:groups/fixr:group[(@id='2041' or @id='2045' or @id='2047')]/fixr:groupRef" />

    <!-- Header -->
    <xsl:template
        match="fixr:components/fixr:component[@id='1024']/fixr:fieldRef[not(@id='35' or
                                                                                 @id='1128' or
                                                                                 @id='1129' or
                                                                                 @id='52'
                                                                                 )]" />
    <!-- Header exclude HopGrp -->
    <xsl:template
        match="fixr:components/fixr:component[@id='1024']/fixr:groupRef[(@id='2085')]" />

    <!-- PegInstructions Component -->
    <xsl:template
        match="fixr:components/fixr:component[@id='1013']/fixr:fieldRef[not(@id='211' or
                                                                                  @id='1094' or
                                                                                  @id='5008' or
                                                                                  @id='5009'
                                                                                  )]" />

    <!-- OrderQtyData Component -->
    <xsl:template
        match="fixr:components/fixr:component[@id='1011']/fixr:fieldRef[not(@id='38')]" />

    <!-- Instrument Extension Component -->
    <xsl:template
        match="fixr:components/fixr:component[@id='1004']/fixr:fieldRef" />
    <xsl:template
        match="fixr:components/fixr:component[@id='1004']/fixr:groupRef[not(@id='2074')]" />
    <xsl:template
        match="fixr:components/fixr:component[@id='1004']/fixr:componentRef" />

    <!-- Instrument Component -->
    <!-- NB 152 would be appropriate for Spread Bet, 38 for CFD - see FIX ROE -->
    <xsl:template
        match="fixr:components/fixr:component[@id='1003']/fixr:fieldRef[not(@id='55' or
                                                                                 @id='48' or
                                                                                 @id='22' or
                                                                                 @id='1151' or
                                                                                 @id='200' or
                                                                                 @id='541' or
                                                                                 @id='202' or
                                                                                 @id='231' or
                                                                                 @id='107' or
                                                                                 @id='1687'
                                                                                 )]" />
    <xsl:template
        match="fixr:components/fixr:component[@id='1003']/fixr:groupRef[not(@id='2071')]" />
    <xsl:template
        match="fixr:components/fixr:component[@id='1003']/fixr:componentRef" />

    <!-- Underlying Instrument Component -->
    <xsl:template
        match="fixr:components/fixr:component[@id='1021']/fixr:fieldRef[not(@id='311' or
                                                                                 @id='309' or
                                                                                 @id='305' or
                                                                                 @id='318'
                                                                                 )]" />
    <xsl:template
        match="fixr:components/fixr:component[@id='1021']/fixr:groupRef[not(@id='2073')]" />
    <xsl:template
        match="fixr:components/fixr:component[@id='1021']/fixr:componentRef" />

    <!-- only  BaseTradingRules in SecurityTradingRules  -->
    <xsl:template
        match="fixr:components/fixr:component[@id='1058']/fixr:componentRef[not(@id='2131')]" />
    <xsl:template
        match="fixr:components/fixr:component[@id='1058']/fixr:groupRef" />
    <!-- BaseTradingRules -->
    <xsl:template
        match="fixr:components/fixr:component[@id='2131']/fixr:componentRef"/>
    <xsl:template
        match="fixr:components/fixr:component[@id='2131']/fixr:groupRef"/>
    <xsl:template
        match="fixr:components/fixr:component[@id='2131']/fixr:fieldRef[not(@id='561')]" />


    <!-- New Order Single -->
    <xsl:template
        match="fixr:message[@msgType='D']/fixr:structure/fixr:componentRef[not(@id='1003' or
                                                                                     @id='1011' or
                                                                                     @id='1024')]" />
    <xsl:template
        match="fixr:message[@msgType='D']/fixr:structure/fixr:groupRef[not(@id='2045' or
                                                                                 @id='2593' or
                                                                                 @id='1073')]" />
    <xsl:template
        match="fixr:message[@msgType='D']/fixr:structure/fixr:fieldRef[not(@id='11' or
                                                                                 @id='1' or
                                                                                 @id='54' or
                                                                                 @id='60' or
                                                                                 @id='38' or
                                                                                 @id='40' or
                                                                                 @id='44' or
                                                                                 @id='99' or
                                                                                 @id='15' or
                                                                                 @id='117' or
                                                                                 @id='59' or
                                                                                 @id='126' or
                                                                                 @id='58' or
                                                                                 @id='1080' or
                                                                                 @id='1081')]" />

    <!-- Execution Report -->
    <xsl:template
        match="fixr:message[@msgType='8']/fixr:structure/fixr:groupRef[not(@id='1073')]" />
    <xsl:template
        match="fixr:message[@msgType='8']/fixr:structure/fixr:componentRef[not(@id='1024' or
                                                                                     @id='1003' or
                                                                                     @id='1011' or
                                                                                     @id='1021')]" />
    <xsl:template
        match="fixr:message[@msgType='8']/fixr:structure/fixr:fieldRef[not(@id='37' or
                                                                                 @id='198' or
                                                                                 @id='11' or
                                                                                 @id='41' or
                                                                                 @id='790' or
                                                                                 @id='584' or
                                                                                 @id='912' or
                                                                                 @id='66' or
                                                                                 @id='17' or
                                                                                 @id='19' or
                                                                                 @id='150' or
                                                                                 @id='39' or
                                                                                 @id='636' or
                                                                                 @id='103' or
                                                                                 @id='1' or
                                                                                 @id='54' or
                                                                                 @id='38' or
                                                                                 @id='40' or
                                                                                 @id='44' or
                                                                                 @id='99' or
                                                                                 @id='59' or
                                                                                 @id='126' or
                                                                                 @id='211' or
                                                                                 @id='1094' or
                                                                                 @id='5008' or
                                                                                 @id='5009' or
                                                                                 @id='15' or
                                                                                 @id='2593' or
                                                                                 @id='2594' or
                                                                                 @id='2595' or
                                                                                 @id='32' or
                                                                                 @id='31' or
                                                                                 @id='151' or
                                                                                 @id='14' or
                                                                                 @id='6' or
                                                                                 @id='60' or
                                                                                 @id='7' or
                                                                                 @id='58' or
                                                                                 @id='1385' or
                                                                                 @id='1080' or
                                                                                 @id='1081')]" />

    <!-- Business Message Reject -->
    <xsl:template
        match="fixr:message[@msgType='j']/fixr:structure/fixr:groupRef" />
    <xsl:template
        match="fixr:message[@msgType='j']/fixr:structure/fixr:componentRef[not(@id='1024')]" />
    <!-- remove "presence" attribute to make RefMsgType optional -->
    <xsl:template
        match="fixr:message[@msgType='j']/fixr:structure/fixr:fieldRef[@id='372']/@presence" />
    <xsl:template
        match="fixr:message[@msgType='j']/fixr:structure/fixr:fieldRef[not(@id='372' or
                                                                                 @id='379' or
                                                                                 @id='380' or
                                                                                 @id='58')]" />
                                                                                 
    <!-- New Order List -->
    <xsl:template
        match="fixr:message[@msgType='E']/fixr:structure/fixr:groupRef[not(@id='2030'or @id='1031')]" />
    <xsl:template
        match="fixr:message[@msgType='E']/fixr:structure/fixr:componentRef[not(@id='1024')]" />
    <xsl:template
        match="fixr:message[@msgType='E']/fixr:structure/fixr:fieldRef[not(@id='66' or
                                                                                 @id='394' or
                                                                                 @id='68' or
                                                                                 @id='1385')]" />

    <!-- List Cancel Request -->
    <xsl:template
        match="fixr:message[@msgType='K']/fixr:structure/fixr:groupRef[not(@id='1012')]" />
    <xsl:template
        match="fixr:message[@msgType='K']/fixr:structure/fixr:componentRef[not(@id='1024')]" />
    <xsl:template
        match="fixr:message[@msgType='K']/fixr:structure/fixr:fieldRef[not(@id='66' or
                                                                                 @id='1' or
                                                                                 @id='60' or
                                                                                 @id='58')]" />

    <!-- List Status -->
    <xsl:template
        match="fixr:message[@msgType='N']/fixr:structure/fixr:groupRef[not(@id='2037')]" />
    <xsl:template
        match="fixr:message[@msgType='N']/fixr:structure/fixr:componentRef[not(@id='1024')]" />
    <xsl:template
        match="fixr:message[@msgType='N']/fixr:structure/fixr:fieldRef[not(@id='66' or
                                                                                 @id='429' or
                                                                                 @id='82' or
                                                                                 @id='431' or
                                                                                 @id='83' or
                                                                                 @id='444' or
                                                                                 @id='60' or
                                                                                 @id='68')]" />

    <!-- Order Cancel Reject -->
    <xsl:template
        match="fixr:message[@msgType='9']/fixr:structure/fixr:groupRef" />
    <xsl:template
        match="fixr:message[@msgType='9']/fixr:structure/fixr:componentRef[not(@id='1024')]" />
    <xsl:template
        match="fixr:message[@msgType='9']/fixr:structure/fixr:fieldRef[not(@id='37' or
                                                                                 @id='11' or
                                                                                 @id='41' or
                                                                                 @id='39' or
                                                                                 @id='1' or
                                                                                 @id='60' or
                                                                                 @id='434' or
                                                                                 @id='102' or
                                                                                 @id='58')]" />

    <!-- Order Cancel Request -->
    <xsl:template
        match="fixr:message[@msgType='F']/fixr:structure/fixr:fieldRef[not(@id='37' or
                                                                                 @id='11' or
                                                                                 @id='41' or
                                                                                 @id='1' or
                                                                                 @id='54' or
                                                                                 @id='60' or
                                                                                 @id='40' or
                                                                                 @id='1385' or
                                                                                 @id='1080' or
                                                                                 @id='1081' or
                                                                                 @id='58')]" />
    <xsl:template
        match="fixr:message[@msgType='F']/fixr:structure/fixr:groupRef" />
    <xsl:template
        match="fixr:message[@msgType='F']/fixr:structure/fixr:componentRef[not(@id='1024' or
                                                                                     @id='1011' or
                                                                                     @id='1003')]" />

    <!-- Order Cancel Replace Request -->
    <xsl:template
        match="fixr:message[@msgType='G']/fixr:structure/fixr:groupRef[not(@id='1073')]" />
    <xsl:template
        match="fixr:message[@msgType='G']/fixr:structure/fixr:componentRef[not(@id='1024' or
                                                                                     @id='1003')]" />
    <xsl:template
        match="fixr:message[@msgType='G']/fixr:structure/fixr:fieldRef[not(@id='37' or
                                                                                 @id='11' or
                                                                                 @id='41' or
                                                                                 @id='1' or
                                                                                 @id='54' or
                                                                                 @id='60' or
                                                                                 @id='40' or
                                                                                 @id='44' or
                                                                                 @id='99' or
                                                                                 @id='59' or
                                                                                 @id='1080' or
                                                                                 @id='1081' or
                                                                                 @id='59' or
                                                                                 @id='126' or
                                                                                 @id='7' or
                                                                                 @id='58')]" />

    <!-- Quote - no groups -->
    <xsl:template
        match="fixr:message[@msgType='S']/fixr:structure/fixr:groupRef" />
    <!-- Quote - only following fields -->
    <!-- exclude fields from ExecRpt -->
    <!-- @id='131' QuoteReqID -->
    <!-- @id='390' BidID -->
    <!-- @id='1867' OfferID -->
    <!-- @id='537' QuoteType -->
    <!-- @id='132' BidPx -->
    <!-- @id='132' OfferPx -->
    <!-- @id='451' NetChgPrevDay -->
    <xsl:template
        match="fixr:message[@msgType='S']/fixr:structure/fixr:fieldRef[not(@id='131'  or
                                                                                 @id='390'  or
                                                                                 @id='1867' or
                                                                                 @id='537'  or
                                                                                 @id='132'  or
                                                                                 @id='133' or
                                                                                 @id='451')]" />
    <!-- remove "presence" attribute to make Instrument component optional -->
    <xsl:template
        match="fixr:message[@msgType='S']/fixr:structure/fixr:componentRef[@id='1003']/@presence" />

    <xsl:template
        match="fixr:message[@msgType='S']/fixr:structure/fixr:componentRef[not(@id='1024' or
                                                                                     @id='1003')]" />

    <!-- Quote Request -->
    <xsl:template
        match="fixr:message[@msgType='R']/fixr:structure/fixr:fieldRef[not(@id='131' or
                                                                                  @id='263')]" />
    <xsl:template
        match="fixr:message[@msgType='R']/fixr:structure/fixr:groupRef[not(@id='2045')]" />
    <xsl:template
        match="fixr:message[@msgType='R']/fixr:structure/fixr:componentRef[not(@id='1024')]" />

    <!-- Quote Request Reject -->
    <xsl:template
        match="fixr:message[@msgType='AG']/fixr:structure/fixr:fieldRef[not(@id='131' or
                                                                                  @id='658' or
                                                                                  @id='58')]" />
    <xsl:template
        match="fixr:message[@msgType='AG']/fixr:structure/fixr:groupRef[not(@id='2047')]" />
    <xsl:template
        match="fixr:message[@msgType='AG']/fixr:structure/fixr:componentRef[not(@id='1024')]" />

    <!-- Quote Cancel -->
    <xsl:template
        match="fixr:message[@msgType='Z']/fixr:structure/fixr:componentRef[not(@id='1024')]" />
    <xsl:template
        match="fixr:message[@msgType='Z']/fixr:structure/fixr:groupRef[not(@id='2041')]" />
    <xsl:template
        match="fixr:message[@msgType='Z']/fixr:structure/fixr:fieldRef[not(@id='131' or
                                                                                 @id='298')]" />

    <!-- Market Data Request -->
    <xsl:template
        match="fixr:message[@msgType='V']/fixr:structure/fixr:fieldRef[not(@id='262' or
                                                                                 @id='263' or
                                                                                 @id='264' or
                                                                                 @id='265'
                                                                                )]" />
    <xsl:template
        match="fixr:message[@msgType='V']/fixr:structure/fixr:groupRef[not(@id='2033' or
                                                                                 @id='2022')]" />
    <xsl:template
        match="fixr:message[@msgType='V']/fixr:structure/fixr:componentRef[not(@id='1024')]" />

    <!-- Market Data Snapshot -->
    <xsl:template
        match="fixr:message[@msgType='W']/fixr:structure/fixr:fieldRef[not(@id='262')]" />
    <xsl:template
        match="fixr:message[@msgType='W']/fixr:structure/fixr:groupRef[not(@id='2031')]" />
    <xsl:template
        match="fixr:message[@msgType='W']/fixr:structure/fixr:componentRef[not(@id='1024')]" />

    <!-- Market Data Incremental Refresh -->
    <xsl:template
        match="fixr:message[@msgType='X']/fixr:structure/fixr:fieldRef[not(@id='262')]" />
    <xsl:template
        match="fixr:message[@msgType='X']/fixr:structure/fixr:groupRef[not(@id='2032')]" />
    <xsl:template
        match="fixr:message[@msgType='X']/fixr:structure/fixr:componentRef[not(@id='1024')]" />

    <!-- Market Data Request Reject -->
    <xsl:template
        match="fixr:message[@msgType='Y']/fixr:structure/fixr:fieldRef[not(@id='262' or
                                                                                 @id='281' or
                                                                                 @id='58'
                                                                                 )]" />
    <xsl:template
        match="fixr:message[@msgType='Y']/fixr:structure/fixr:groupRef" />
    <xsl:template
        match="fixr:message[@msgType='Y']/fixr:structure/fixr:componentRef[not(@id='1024')]" />

    <!-- Security List Request -->
    <xsl:template
        match="fixr:message[@msgType='x']/fixr:structure/fixr:fieldRef[not(@id='320' or
                                                                                 @id='559' or
                                                                                 @id='263' or
                                                                                 @id='1'
                                                                                 )]" />
    <xsl:template
        match="fixr:message[@msgType='x']/fixr:structure/fixr:groupRef" />
    <xsl:template
        match="fixr:message[@msgType='x']/fixr:structure/fixr:componentRef[not(@id='1024' or
                                                                                     @id='1003')]" />
    <!-- Security List -->
    <xsl:template
        match="fixr:message[@msgType='y']/fixr:structure/fixr:fieldRef[not(@id='320' or
                                                                                 @id='322' or
                                                                                 @id='560' or
                                                                                 @id='393' or
                                                                                 @id='893')]" />
    <xsl:template
        match="fixr:message[@msgType='y']/fixr:structure/fixr:groupRef[not(@id='2055')]" />
    <xsl:template
        match="fixr:message[@msgType='y']/fixr:structure/fixr:componentRef[not(@id='1024')]" />

    <!-- PositionReport -->
    <xsl:template
        match="fixr:message[@msgType='AP']/fixr:structure/fixr:fieldRef[not(@id='2618' or
                                                                                 @id='721' or
                                                                                 @id='710' or
                                                                                 @id='724' or
                                                                                 @id='727' or
                                                                                 @id='728' or
                                                                                 @id='325' or
                                                                                 @id='715' or
                                                                                 @id='1' or
                                                                                 @id='120' or
                                                                                 @id='1011' or
                                                                                 @id='15' or
                                                                                 @id='730' or
                                                                                 @id='731' or
                                                                                 @id='58' or
                                                                                 @id='20101' or
                                                                                 @id='20102' or
                                                                                 @id='20103' or
                                                                                 @id='20104' or
                                                                                 @id='155' or
                                                                                   @id='912' )]" />
    <xsl:template
        match="fixr:message[@msgType='AP']/fixr:structure/fixr:groupRef[not( @id='1014'  or
                                                                                  @id='1015' )]" />
    <xsl:template
        match="fixr:message[@msgType='AP']/fixr:structure/fixr:componentRef[not(@id='1024' or
                                                                                 @id='1003' )]" />

    <!--OrderMassStatusRequest-->
    <xsl:template match="fixr:message[@msgType='AF']/fixr:structure/fixr:groupRef[not( @id='' )]"/>

    <xsl:template match="fixr:message[@msgType='AF']/fixr:structure/fixr:fieldRef[not(@id='1' or
                                                                                     @id='584' or
                                                                                     @id='585' )]"/>

    <xsl:template match="fixr:message[@msgType='AF']/fixr:structure/fixr:componentRef[not(@id='1024' )]" />

    <!--RequestForPositions-->
    <xsl:template match="fixr:message[@msgType='AN']/fixr:structure/fixr:groupRef[not( @id='' )]"/>

    <xsl:template match="fixr:message[@msgType='AN']/fixr:structure/fixr:fieldRef[not(@id='1' or
                                                                                     @id='263' or
                                                                                     @id='710' or
                                                                                     @id='715' or
                                                                                     @id='724' or
                                                                                     @id='60' )]"/>

    <xsl:template match="fixr:message[@msgType='AN']/fixr:structure/fixr:componentRef[not(@id='1024' )]" />

    <!--RequestForPositionsAck-->
    <xsl:template match="fixr:message[@msgType='AO']/fixr:structure/fixr:groupRef[not( @id='' )]"/>

    <xsl:template match="fixr:message[@msgType='AO']/fixr:structure/fixr:fieldRef[not(@id='1' or
                                                                                     @id='58' or
                                                                                     @id='710' or
                                                                                     @id='721' or
                                                                                     @id='727' or
                                                                                     @id='728' or
                                                                                     @id='729' or
                                                                                     @id='715' or
                                                                                     @id='912' )]"/>

    <xsl:template match="fixr:message[@msgType='AO']/fixr:structure/fixr:componentRef[not(@id='1024' )]" />

    <!--OrderStatusRequest-->
    <xsl:template match="fixr:message[@msgType='H']/fixr:structure/fixr:groupRef" />
    <xsl:template match="fixr:message[@msgType='H']/fixr:structure/fixr:fieldRef[not(@id='1' or
                                                                                     @id='37' or
                                                                                     @id='11' or
                                                                                     @id='790' or
                                                                                     @id='54' )]"/>
    <xsl:template match="fixr:message[@msgType='H']/fixr:structure/fixr:componentRef[not(@id='1024' or
                                                                                     @id='1003' )]" />

</xsl:stylesheet>
