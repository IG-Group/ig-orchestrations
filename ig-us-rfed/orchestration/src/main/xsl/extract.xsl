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

    <!-- filter unused categories -->
    <xsl:template
            match="fixr:categories/fixr:category[not(@name='Session' or
                                                     @name='BusinessReject' or
                                                     @name='AccountReporting' or
                                                     @name='PositionMaintenance' or
                                                     @name='QuotationNegotiation' or
                                                     @name='SecuritiesReferenceData' or
                                                     @name='OrderMassHandling' or
                                                     @name='ProgramTrading' or
                                                     @name='SingleGeneralOrderHandling')]"/>

    <!-- filter out deprecated codes -->
    <!-- this is added to remove duplicates with differing case   -->
    <xsl:template
        match="fixr:codeSet[@id='221']/fixr:code[@deprecated]"/>
    <!-- remove bug -->
    <xsl:template
        match="fixr:codeSet[@name='NoStreamAssetAttributesCodeSet']"/>

    <!-- Remove non-required MultipleCharValue data type, the pattern attribute includes Undefined control sequence '\s which is problematic for pandoc' -->
    <xsl:template
            match="fixr:datatypes/fixr:datatype[@name='MultipleCharValue'
                                              or @name='MultipleStringValue']"/>

    <!-- filter out fields not referenced by the rest of the code
        I generate this list through: (in ig-orchestrations/ig-us-rfed/orchestration/)

        fieldRef : direct reference to a field,
        numInGroup: implied reference to the repeating group count field

        grep -e fixr:fieldRef -e fixr:numInGroup target/generated-resources/xml/xslt/publishWithSessionLayer/OrchestraEP255.xml  |grep id |perl -ne '($id)=/id=\"(.*?)\"/; print "$id\n";'|sort -nu|while read field;do echo "or @id='$field'"; done

    	(Another filter of fields will be required to remove Session Layer fields if the session layer is subsequently extracted.)

    -->
	<xsl:template match="fixr:fields/fixr:field[not(
										   @id='1'
                                            or @id='6'
                                            or @id='7'
                                            or @id='8'
                                            or @id='9'
                                            or @id='10'
                                            or @id='11'
                                            or @id='14'
                                            or @id='15'
                                            or @id='16'
                                            or @id='17'
                                            or @id='19'
                                            or @id='22'
                                            or @id='31'
                                            or @id='32'
                                            or @id='35'
                                            or @id='36'
                                            or @id='37'
                                            or @id='38'
                                            or @id='39'
                                            or @id='40'
                                            or @id='41'
                                            or @id='43'
                                            or @id='44'
                                            or @id='45'
                                            or @id='48'
                                            or @id='49'
                                            or @id='52'
                                            or @id='54'
                                            or @id='55'
                                            or @id='56'
                                            or @id='58'
                                            or @id='59'
                                            or @id='60'
                                            or @id='66'
                                            or @id='67'
                                            or @id='68'
                                            or @id='73'
                                            or @id='84'
                                            or @id='91'
                                            or @id='98'
                                            or @id='99'
                                            or @id='102'
                                            or @id='103'
                                            or @id='107'
                                            or @id='108'
                                            or @id='112'
                                            or @id='117'
                                            or @id='120'
                                            or @id='122'
                                            or @id='123'
                                            or @id='126'
                                            or @id='131'
                                            or @id='132'
                                            or @id='133'
                                            or @id='141'
                                            or @id='146'
                                            or @id='150'
                                            or @id='151'
                                            or @id='155'
                                            or @id='198'
                                            or @id='200'
                                            or @id='202'
                                            or @id='211'
                                            or @id='231'
                                            or @id='263'
                                            or @id='295'
                                            or @id='305'
                                            or @id='309'
                                            or @id='311'
                                            or @id='318'
                                            or @id='320'
                                            or @id='322'
                                            or @id='325'
                                            or @id='354'
                                            or @id='355'
                                            or @id='371'
                                            or @id='372'
                                            or @id='373'
                                            or @id='378'
                                            or @id='379'
                                            or @id='380'
                                            or @id='390'
                                            or @id='393'
                                            or @id='394'
                                            or @id='434'
                                            or @id='447'
                                            or @id='448'
                                            or @id='451'
                                            or @id='452'
                                            or @id='453'
                                            or @id='454'
                                            or @id='455'
                                            or @id='456'
                                            or @id='457'
                                            or @id='458'
                                            or @id='459'
                                            or @id='537'
                                            or @id='541'
                                            or @id='559'
                                            or @id='560'
                                            or @id='561'
                                            or @id='584'
                                            or @id='585'
                                            or @id='636'
                                            or @id='658'
                                            or @id='702'
                                            or @id='703'
                                            or @id='704'
                                            or @id='705'
                                            or @id='706'
                                            or @id='707'
                                            or @id='708'
                                            or @id='710'
                                            or @id='711'
                                            or @id='715'
                                            or @id='721'
                                            or @id='724'
                                            or @id='727'
                                            or @id='728'
                                            or @id='729'
                                            or @id='730'
                                            or @id='731'
                                            or @id='753'
                                            or @id='790'
                                            or @id='870'
                                            or @id='871'
                                            or @id='872'
                                            or @id='893'
                                            or @id='900'
                                            or @id='912'
                                            or @id='1011'
                                            or @id='1055'
                                            or @id='1080'
                                            or @id='1081'
                                            or @id='1094'
                                            or @id='1116'
                                            or @id='1117'
                                            or @id='1118'
                                            or @id='1119'
                                            or @id='1128'
                                            or @id='1129'
                                            or @id='1130'
                                            or @id='1131'
                                            or @id='1137'
                                            or @id='1151'
                                            or @id='1385'
                                            or @id='1406'
                                            or @id='1409'
                                            or @id='1585'
                                            or @id='1643'
                                            or @id='1644'
                                            or @id='1645'
                                            or @id='1687'
                                            or @id='1699'
                                            or @id='1703'
                                            or @id='1704'
                                            or @id='1706'
                                            or @id='1867'
                                            or @id='2096'
                                            or @id='2097'
                                            or @id='2098'
                                            or @id='2099'
                                            or @id='2100'
                                            or @id='2376'
                                            or @id='2388'
                                            or @id='2593'
                                            or @id='2594'
                                            or @id='2595'
                                            or @id='2618'
                                            or @id='2876'
                                            or @id='2877'
                                            or @id='20104'
                                            or @id='20105'
                                            or @id='20106')]">
    </xsl:template>

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

    <!-- Set ClearingBusinessDate field within AccountSummaryReport as optional -->
    <xsl:template match="fixr:message[@msgType='CQ']/fixr:structure/fixr:fieldRef[@id='715']/@presence">
        <xsl:attribute name="presence">
            <xsl:value-of select="'optional'"/>
        </xsl:attribute>
    </xsl:template>
    
    <!-- Set Side field within OrderStatusRequest as optional -->
    <xsl:template match="fixr:message[@msgType='H']/fixr:structure/fixr:fieldRef[@id='54']/@presence">
        <xsl:attribute name="presence">
            <xsl:value-of select="'optional'"/>
        </xsl:attribute>
    </xsl:template>
    
    <!-- Set Currency field within Execution Report as optional -->
    <xsl:template match="fixr:message[@msgType='8']/fixr:structure/fixr:fieldRef[@id='15']/@presence">
        <xsl:attribute name="presence">
            <xsl:value-of select="'optional'"/>
        </xsl:attribute>
    </xsl:template>

    <!-- filter out unsupported messages -->
    <xsl:template
        match="fixr:message[not(@msgType='0' or
                                @msgType='1' or
                                @msgType='2' or
                                @msgType='3' or
                                @msgType='4' or
                                @msgType='5' or
                                @msgType='A' or
                                @msgType='8' or
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
                                @msgType='Z' or
                                @msgType='CQ' or
                                @msgType='UA' ) ]" />

    <!-- filter out unsupported codeSets 
    	I get the list by going in ig-orchestrations/ig-us-rfed/orchestration/target/generated-resources/xml/xslt
    	
    	and running 
    	
    	grep fixr:codeSet target/generated-resources/xml/xslt/publishWithSessionLayer/OrchestraEP255.xml |grep id|grep -f <(grep fixr:field target/generated-resources/xml/xslt/publishWithSessionLayer/OrchestraEP255.xml|grep type|perl -ne '($type)=/ type="(.*?)"/; print "name=\"$type\"\n"'|grep Set) | perl -ne '($id)=/id="(.*?)"/; print "or \@id='\''$id'\''\n"'
    	
    	after I have filtered out (or in) the fields I have excluded 

    	Another filtering of codeset will be required to remove Session Layer message code sets if the session layer is subsequently extracted.

    -->
    <xsl:template
        match="fixr:codeSets/fixr:codeSet[not(
										@id='22'
                                        or @id='35'
                                        or @id='39'
                                        or @id='40'
                                        or @id='54'
                                        or @id='59'
                                        or @id='102'
                                        or @id='103'
                                        or @id='150'
                                        or @id='263'
                                        or @id='325'
                                        or @id='378'
                                        or @id='380'
                                        or @id='394'
                                        or @id='423'
                                        or @id='434'
                                        or @id='447'
                                        or @id='452'
                                        or @id='537'
                                        or @id='559'
                                        or @id='560'
                                        or @id='585'
                                        or @id='636'
                                        or @id='658'
                                        or @id='703'
                                        or @id='706'
                                        or @id='707'
                                        or @id='724'
                                        or @id='728'
                                        or @id='729'
                                        or @id='731'
                                        or @id='871'
                                        or @id='893'
                                        or @id='912'
                                        or @id='1046'
                                        or @id='1081'
                                        or @id='1094'
                                        or @id='1128'
                                        or @id='1385'
                                        or @id='1644'
                                        or @id='1674'
                                        or @id='1585'
                                        or @id='1687'
                                        or @id='2594'
                                        or @id='10001')]">
	</xsl:template>
    <!-- filter out unsupported codes for message types-->
    <xsl:template
        match="fixr:codeSets/fixr:codeSet[(@id='35')]/fixr:code[not(@value='0' or
                                                                    @value='1' or
                                                                    @value='2' or
                                                                    @value='3' or
                                                                    @value='4' or
                                                                    @value='5' or
                                                                    @value='8' or
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
                                                                    @value='Z' or
                                                                    @value='CQ' or
                                                                    @value='UA' or
                                                                    @value='UB' or
                                                                    @value='UC' ) ]"/>

    <!-- filter out unsupported codes -->
    <!-- RefOrderIDSourceCodeSet   -->
    <xsl:template
        match="fixr:codeSets/fixr:codeSet[(@id='1081')]/fixr:code[not(@name='OrderID' or
                                                                     @name='ClOrdID')]"/>
    <!-- BidTypeCodeSet -->
    <xsl:template
        match="fixr:codeSets/fixr:codeSet[(@name='BidTypeCodeSet')]/fixr:code[not(@name='NoBiddingProcess')]"/>                                                                  
        
    <!-- ContingencyTypeCodeSet -->
    <xsl:template
        match="fixr:codeSets/fixr:codeSet[(@name='ContingencyTypeCodeSet')]/fixr:code[not(@name='OneTriggersTheOther')]"/>
        
    <!-- CxlRejReasonCodeSet -->
    <xsl:template
        match="fixr:codeSets/fixr:codeSet[(@name='CxlRejReasonCodeSet')]/fixr:code[not(@name='Other')]"/>  
        
    <!-- ExecRestatementReasonCodeSet -->
    <xsl:template
        match="fixr:codeSets/fixr:codeSet[(@name='ExecRestatementReasonCodeSet')]/fixr:code[not(@name='SystemStopLossSizeAdjustment' or
                                                                      							@name='SystemTakeProfitSizeAdjustment' or
                                                                      							@name='SystemTrailingStopAdjustment' or
                                                                      							@name='SystemOTOContingentAdjustment' or
                                                                      							@name='Other')]"/>
        
    <!-- ExecTypeCodeSet -->
    <xsl:template
        match="fixr:codeSets/fixr:codeSet[(@name='ExecTypeCodeSet')]/fixr:code[not(@name='New' or
         																			@name='Canceled' or 
         																			@name='Replaced' or 
         																			@name='Rejected' or 
        																			@name='Trade' or 
         																			@name='Rejected' or 
         																			@name='PendingCancel' or 
         																			@name='PendingReplace' or
         																			@name='Expired' or
       																			    @name='Restated' or
         																			@name='OrderStatus' or
         																			@name='DoneForDay')]"/> 
        
    <!-- MarginAmtTypeCodeSet  -->
    <xsl:template
        match="fixr:codeSets/fixr:codeSet[(@name='MarginAmtTypeCodeSet')]/fixr:code[not(@name='ControlledRiskMargin' or
        															  @name='TotalMargin' or
                                                                      @name='NonControlledRiskMargin')]"/>
                                                                     
    <!-- MassStatusReqTypeCodeSet  -->
    <xsl:template
        match="fixr:codeSets/fixr:codeSet[(@name='MassStatusReqTypeCodeSet')]/fixr:code[not(@name='StatusForOrdersForAPartyID')]"/>
        
    <!-- OrdRejReasonCodeSet  -->
    <xsl:template
        match="fixr:codeSets/fixr:codeSet[(@name='OrdRejReasonCodeSet')]/fixr:code[not(@name='OrderExceedsLimit' or
        																					@name='UnknownOrder' or
        																					@name='Other')]"/>
        																					
        																					
    <!-- OrdStatusCodeSet  -->
    <xsl:template
        match="fixr:codeSets/fixr:codeSet[(@name='OrdStatusCodeSet')]/fixr:code[not(@name='New' or
        																					@name='PartiallyFilled' or
        																					@name='Filled' or
        																					@name='Replaced' or
        																					@name='PendingCancel' or
        																					@name='Rejected' or
        																					@name='PendingNew' or
        																					@name='PendingReplace' or
        																					@name='Expired' or
        																					@name='Canceled')]"/>
        																					
    <!-- OrdTypeCodeSet  -->
    <xsl:template
        match="fixr:codeSets/fixr:codeSet[(@name='OrdTypeCodeSet')]/fixr:code[not(@name='Market' or
        																					@name='Limit' or
        																					@name='Stop' or
        																					@name='PreviouslyQuoted')]"/>
        																					
    <!-- OrderAttributeTypeCodeSet  -->
    <xsl:template
        match="fixr:codeSets/fixr:codeSet[(@name='OrderAttributeTypeCodeSet')]/fixr:code[not(@name='AttachedOrder')]"/>
         
    <!-- PartyRoleCodeSet  -->
    <xsl:template
        match="fixr:codeSets/fixr:codeSet[(@name='PartyRoleCodeSet')]/fixr:code[not(@name='CustomerAccount')]"/>
        
    <!-- PegPriceTypeCodeSet  -->
    <xsl:template
        match="fixr:codeSets/fixr:codeSet[(@name='PegPriceTypeCodeSet')]/fixr:code[not(@name='PrimaryPeg')]"/>
        
    <!-- PosAmtTypeCodeSet  -->
    <xsl:template
        match="fixr:codeSets/fixr:codeSet[(@name='PosAmtTypeCodeSet')]/fixr:code[not(@name='SettlementValue')]"/>
        
    <!-- PosReqStatusCodeSet  -->
    <xsl:template
        match="fixr:codeSets/fixr:codeSet[(@name='PosReqStatusCodeSet')]/fixr:code[not(@name='Completed' or
        																				@name='Rejected')]"/>	
    
    <!-- PosTypeCodeSet  -->
    <xsl:template
        match="fixr:codeSets/fixr:codeSet[(@name='PosTypeCodeSet')]/fixr:code[not(@name='TotalTransactionQty' or
        																				@name='NetDeltaQty')]"/>
        																				
    <!-- QuoteRequestRejectReasonCodeSet  -->
    <xsl:template
        match="fixr:codeSets/fixr:codeSet[(@name='QuoteRequestRejectReasonCodeSet')]/fixr:code[not(@name='UnknownSymbol' or
        																							@name='Other' or
        																							@name='NotAuthorizedToRequestQuote' or
        																							@name='QuoteRequestExceedsLimit')]"/>
        																							
    <!-- QuoteTypeCodeSet  -->
    <xsl:template
        match="fixr:codeSets/fixr:codeSet[(@name='QuoteTypeCodeSet')]/fixr:code[not(@name='Indicative' or
        																							@name='Tradeable')]"/>
        																							
    <!-- SecurityListRequestTypeCodeSet  -->
    <xsl:template
        match="fixr:codeSets/fixr:codeSet[(@name='SecurityListRequestTypeCodeSet')]/fixr:code[not(@name='AllSecurities')]"/>
        
    <!-- SideCodeSet  -->
    <xsl:template
        match="fixr:codeSets/fixr:codeSet[(@name='SideCodeSet')]/fixr:code[not(@name='Buy' or
        																		@name='Undisclosed' or
        																		@name='Sell')]"/>
        																		
    <!-- TimeInForceCodeSet  -->
    <xsl:template
        match="fixr:codeSets/fixr:codeSet[(@name='TimeInForceCodeSet')]/fixr:code[not(@name='GoodTillCancel' or
        																		@name='Day' or
        																		@name='AtTheClose' or
																				@name='GoodTillCrossing' or
																				@name='AtTheOpening' or
        																		@name='ImmediateOrCancel' or
        																		@name='FillOrKill' or
        																		@name='GoodTillDate')]"/>

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
                                                        @id='1025' or
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
                                                @id='2037' or
                                                @id='2041' or
                                                @id='2022' or
                                                @id='2055' or
                                                @id='2066' or
                                                @id='2073' or
                                                @id='2074' or
                                                @id='2177' or
                                                @id='2191' )]" />

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
                                                                            @id='706' )]" />


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

    <!-- CollateralAmountGrp -->
    <xsl:template
        match="fixr:groups/fixr:group[(@id='2191')]/fixr:componentRef" />
    <xsl:template
        match="fixr:groups/fixr:group[(@id='2191')]/fixr:fieldRef[not( @id='1704'
        															or @id='1706' )]" />
    <xsl:template
        match="fixr:groups/fixr:group[(@id='2191')]/fixr:groupRef" />

	<!-- MarginAmountGrp -->
    <xsl:template
        match="fixr:groups/fixr:group[(@id='2177')]/fixr:componentRef" />
    <xsl:template
        match="fixr:groups/fixr:group[(@id='2177')]/fixr:fieldRef[not( @id='1645'
        															or @id='1644' )]" />
    <xsl:template
        match="fixr:groups/fixr:group[(@id='2177')]/fixr:groupRef" />


    <!-- Header -->
    <xsl:template
            match="fixr:components/fixr:component[@id='1024']/fixr:fieldRef[not(@id='8' or
                                                                                 @id='9' or
                                                                                 @id='35' or
                                                                                 @id='1128' or
                                                                                 @id='1129' or
                                                                                 @id='43' or
                                                                                 @id='49' or
                                                                                 @id='52' or
                                                                                 @id='56' or
                                                                                 @id='91' or
                                                                                 @id='122' )]" />

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
                                                                                     @id='1024' or
                                                                                     @id='1025')]" />
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
                                                                                     @id='1025' or
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
                                                                                 @id='1081'or
                                                                                 @id='378')]" />

    <!-- Business Message Reject -->
    <xsl:template
        match="fixr:message[@msgType='j']/fixr:structure/fixr:groupRef" />
    <xsl:template
        match="fixr:message[@msgType='j']/fixr:structure/fixr:componentRef[not(@id='1024' or
                                                                               @id='1025')]" />
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
        match="fixr:message[@msgType='E']/fixr:structure/fixr:componentRef[not(@id='1024' or
                                                                                     @id='1025')]" />
    <xsl:template
        match="fixr:message[@msgType='E']/fixr:structure/fixr:fieldRef[not(@id='66' or
                                                                                 @id='394' or
                                                                                 @id='68' or
                                                                                 @id='1385')]" />

    <!-- List Cancel Request -->
    <xsl:template
        match="fixr:message[@msgType='K']/fixr:structure/fixr:groupRef[not(@id='1012')]" />
    <xsl:template
        match="fixr:message[@msgType='K']/fixr:structure/fixr:componentRef[not(@id='1024' or
                                                                                     @id='1025')]" />
    <xsl:template
        match="fixr:message[@msgType='K']/fixr:structure/fixr:fieldRef[not(@id='66' or
                                                                                 @id='1' or
                                                                                 @id='60' or
                                                                                 @id='58')]" />

    <!-- List Status -->
    <xsl:template
        match="fixr:message[@msgType='N']/fixr:structure/fixr:groupRef[not(@id='2037')]" />
    <xsl:template
        match="fixr:message[@msgType='N']/fixr:structure/fixr:componentRef[not(@id='1024' or
                                                                                     @id='1025')]" />
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
        match="fixr:message[@msgType='9']/fixr:structure/fixr:componentRef[not(@id='1024' or
                                                                                     @id='1025')]" />
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
                                                                                     @id='1025' or
                                                                                     @id='1011' or
                                                                                     @id='1003')]" />

    <!-- Order Cancel Replace Request -->
    <xsl:template
        match="fixr:message[@msgType='G']/fixr:structure/fixr:groupRef[not(@id='1073')]" />
    <xsl:template
        match="fixr:message[@msgType='G']/fixr:structure/fixr:componentRef[not(@id='1024' or
                                                                                     @id='1025' or
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
                                                                                     @id='1025' or
                                                                                     @id='1003')]" />

    <!-- Quote Request -->
    <xsl:template
        match="fixr:message[@msgType='R']/fixr:structure/fixr:fieldRef[not(@id='131' or
                                                                                  @id='263')]" />
    <xsl:template
        match="fixr:message[@msgType='R']/fixr:structure/fixr:groupRef[not(@id='2045')]" />
    <xsl:template
        match="fixr:message[@msgType='R']/fixr:structure/fixr:componentRef[not(@id='1024' or
                                                                                     @id='1025')]" />

    <!-- Quote Request Reject -->
    <xsl:template
        match="fixr:message[@msgType='AG']/fixr:structure/fixr:fieldRef[not(@id='131' or
                                                                                  @id='658' or
                                                                                  @id='58')]" />
    <xsl:template
        match="fixr:message[@msgType='AG']/fixr:structure/fixr:groupRef[not(@id='2047')]" />
    <xsl:template
        match="fixr:message[@msgType='AG']/fixr:structure/fixr:componentRef[not(@id='1024' or
                                                                                     @id='1025')]" />

    <!-- Quote Cancel -->
    <xsl:template
        match="fixr:message[@msgType='Z']/fixr:structure/fixr:componentRef[not(@id='1024' or
                                                                                     @id='1025')]" />
    <xsl:template
        match="fixr:message[@msgType='Z']/fixr:structure/fixr:groupRef[not(@id='2041')]" />
    <xsl:template
        match="fixr:message[@msgType='Z']/fixr:structure/fixr:fieldRef[not(@id='131')]" />

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
        match="fixr:message[@msgType='V']/fixr:structure/fixr:componentRef[not(@id='1024' or
                                                                                     @id='1025')]" />

    <!-- Market Data Snapshot -->
    <xsl:template
        match="fixr:message[@msgType='W']/fixr:structure/fixr:fieldRef[not(@id='262')]" />
    <xsl:template
        match="fixr:message[@msgType='W']/fixr:structure/fixr:groupRef[not(@id='2031')]" />
    <xsl:template
        match="fixr:message[@msgType='W']/fixr:structure/fixr:componentRef[not(@id='1024' or
                                                                                     @id='1025')]" />

    <!-- Market Data Incremental Refresh -->
    <xsl:template
        match="fixr:message[@msgType='X']/fixr:structure/fixr:fieldRef[not(@id='262')]" />
    <xsl:template
        match="fixr:message[@msgType='X']/fixr:structure/fixr:groupRef[not(@id='2032')]" />
    <xsl:template
        match="fixr:message[@msgType='X']/fixr:structure/fixr:componentRef[not(@id='1024' or
                                                                                     @id='1025')]" />

    <!-- Market Data Request Reject -->
    <xsl:template
        match="fixr:message[@msgType='Y']/fixr:structure/fixr:fieldRef[not(@id='262' or
                                                                                 @id='281' or
                                                                                 @id='58'
                                                                                 )]" />
    <xsl:template
        match="fixr:message[@msgType='Y']/fixr:structure/fixr:groupRef" />
    <xsl:template
        match="fixr:message[@msgType='Y']/fixr:structure/fixr:componentRef[not(@id='1024' or
                                                                                     @id='1025')]" />

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
                                                                                     @id='1025' or
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
        match="fixr:message[@msgType='y']/fixr:structure/fixr:componentRef[not(@id='1024' or
                                                                                     @id='1025')]" />

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
                                                                                 @id='20104' or
                                                                                 @id='155' or
                                                                                   @id='912' )]" />
    <xsl:template
        match="fixr:message[@msgType='AP']/fixr:structure/fixr:groupRef[not( @id='1014'  or
                                                                                  @id='1015' )]" />
    <xsl:template
        match="fixr:message[@msgType='AP']/fixr:structure/fixr:componentRef[not(@id='1024' or
                                                                                 @id='1025' or
                                                                                 @id='1003' )]" />

    <!--OrderMassStatusRequest-->
    <xsl:template match="fixr:message[@msgType='AF']/fixr:structure/fixr:groupRef[not( @id='' )]"/>

    <xsl:template match="fixr:message[@msgType='AF']/fixr:structure/fixr:fieldRef[not(@id='1' or
                                                                                     @id='584' or
                                                                                     @id='585' )]"/>

    <xsl:template match="fixr:message[@msgType='AF']/fixr:structure/fixr:componentRef[not(@id='1024' or
                                                                                     @id='1025' )]" />

    <!--RequestForPositions-->
    <xsl:template match="fixr:message[@msgType='AN']/fixr:structure/fixr:groupRef[not( @id='' )]"/>

    <xsl:template match="fixr:message[@msgType='AN']/fixr:structure/fixr:fieldRef[not(@id='1' or
                                                                                     @id='263' or
                                                                                     @id='710' or
                                                                                     @id='715' or
                                                                                     @id='724' or
                                                                                     @id='60' )]"/>

    <xsl:template match="fixr:message[@msgType='AN']/fixr:structure/fixr:componentRef[not(@id='1024' or
                                                                                     @id='1025' )]" />

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

    <xsl:template match="fixr:message[@msgType='AO']/fixr:structure/fixr:componentRef[not(@id='1024' or
                                                                                     @id='1025' )]" />

    <!--OrderStatusRequest-->
    <xsl:template match="fixr:message[@msgType='H']/fixr:structure/fixr:groupRef" />
    <xsl:template match="fixr:message[@msgType='H']/fixr:structure/fixr:fieldRef[not(@id='1' or
                                                                                     @id='37' or
                                                                                     @id='11' or
                                                                                     @id='790' or
                                                                                     @id='54' )]"/>
    <xsl:template match="fixr:message[@msgType='H']/fixr:structure/fixr:componentRef[not(@id='1024' or
                                                                                     @id='1025' or
                                                                                     @id='1003' )]" />
   <!--AccountSummaryReport-->
   <xsl:template match="fixr:message[@msgType='CQ']/fixr:structure/fixr:groupRef[not( @id='2177'
																					  or @id='1012'	
																					  or @id='2191' )]" />
   <xsl:template match="fixr:message[@msgType='CQ']/fixr:structure/fixr:fieldRef[not( @id='1699'
   																					  or @id='20105' 
   																					  or @id='20106'
   																					  or @id='715'
   																					  or @id='15'
   																					  or @id='900'
   																					  or @id='60'
   																					  or @id='58' )]"/>
   <xsl:template match="fixr:message[@msgType='CQ']/fixr:structure/fixr:componentRef[not(@id='1024' or
                                                                                     @id='1025')]" />

   <!--AccountSummaryReportRequest-->
   <xsl:template match="fixr:message[@msgType='UA']/fixr:structure/fixr:groupRef[not(@id='1012')]" />
   <xsl:template match="fixr:message[@msgType='UA']/fixr:structure/fixr:fieldRef[not( @id='20105' or
   																					  @id='263' )]"/>
   <xsl:template match="fixr:message[@msgType='UA']/fixr:structure/fixr:componentRef[not(@id='1024' or
                                                                                     @id='1025')]" />


</xsl:stylesheet>
