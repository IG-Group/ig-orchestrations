<xsl:stylesheet version="FIX.5.0SP2" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com"
                xmlns:fixr="http://fixprotocol.io/2016/fixrepository" xmlns:dc="http://purl.org/dc/elements/1.1/">
    <xsl:output method="xml"/>
    <xsl:strip-space elements="*"/>
    <xsl:output omit-xml-declaration="no" indent="yes"/>

    <xsl:param name="addFields">
        <fixr:field added="FIX.5.0SP2" id="1867" name="OfferID" type="String" addedEP="144" abbrName="OfrID"
                    presence="optional" supported="supported">
            <fixr:annotation supported="supported">
                <fixr:documentation purpose="SYNOPSIS" supported="supported">
                    Unique identifier for the ask side of the quote assigned by the quote issuer.
                </fixr:documentation>
            </fixr:annotation>
        </fixr:field>
        <fixr:field added="FIX.5.0SP2" id="2593" name="NoOrderAttributes" type="NumInGroup" addedEP="222"
                    abbrName="NoOrderAttributes" presence="optional" supported="supported">
            <fixr:annotation supported="supported">
                <fixr:documentation purpose="SYNOPSIS" supported="supported">
                    Number of order attribute entries.
                </fixr:documentation>
            </fixr:annotation>
        </fixr:field>
        <fixr:field added="FIX.5.0SP2" id="2594" name="OrderAttributeType" type="int" addedEP="222"
                    abbrName="OrderAttributeType" presence="optional" supported="supported">
            <fixr:annotation supported="supported">
                <fixr:documentation purpose="SYNOPSIS" supported="supported">
                    The type of order attribute.
                </fixr:documentation>
            </fixr:annotation>
        </fixr:field>
        <fixr:field added="FIX.5.0SP2" id="2595" name="OrderAttributeValue" type="String`" addedEP="222"
                    abbrName="OrderAttributeValue" presence="optional" supported="supported">
            <fixr:annotation supported="supported">
                <fixr:documentation purpose="SYNOPSIS" supported="supported">
                    The value associated with the order attribute type specified in OrderAttributeType(2594).
                </fixr:documentation>
            </fixr:annotation>
        </fixr:field>


        <fixr:field added="FIX.5.0SP2" id="2618" name="PositionID" type="String" addedEP="199"
                    abbrName="PositionID" presence="optional" supported="supported">
            <fixr:annotation supported="supported">
                <fixr:documentation purpose="SYNOPSIS" supported="supported">
                    Unique identifier for a position entity. Refer to PosMaintRptID(721) for a unique identifier of a position report message.
                </fixr:documentation>
            </fixr:annotation>
        </fixr:field>


        <fixr:field added="FIX.5.0SP2" id="20104" name="OpenPrice" type="Price" addedEP="222" abbrName="OpenPrice"
                    presence="optional" supported="supported">
            <fixr:annotation supported="supported">
                <fixr:documentation purpose="SYNOPSIS" supported="supported">
                    The price at which the Position was opened, will be reported in Currency (15)
                </fixr:documentation>
            </fixr:annotation>
        </fixr:field>

        <fixr:field added="FIX.5.0SP2" id="20101" name="OriginatingClientOrderRef" type="String" abbrName="OriginatingClientOrderRef"
					presence="optional" supported="supported">
            <fixr:annotation supported="supported">
                <fixr:documentation purpose="SYNOPSIS" supported="supported">
                    IG uses the custom tag OriginatingClientOrderRef to represent:
                    • the ClOrdID(11) from the client order which resulted in the position
                    • a reference from another channel such as web trade
                </fixr:documentation>
            </fixr:annotation>
        </fixr:field>

        <fixr:field added="FIX.5.0SP2" id="20102" name="OriginatingOrderIDRef" type="String" abbrName="OriginatingClientOrderRef"
					presence="optional" supported="supported">
            <fixr:annotation supported="supported">
                <fixr:documentation purpose="SYNOPSIS" supported="supported">
                    IG uses the custom tag OriginatingOrderIDRef to identify the IG Order ID of an order which has
                    resulted in opening the Position. The OriginatingOrderIDRef value corresponds to the value of
                    OrderId (37) on the Execution Report for the client order which resulted in opening the position
                </fixr:documentation>
            </fixr:annotation>
        </fixr:field>

        <fixr:field added="FIX.5.0SP2" id="20103" name="ClosingOrderIDRef" type="String" abbrName="OriginatingClientOrderRef"
					presence="optional" supported="supported">
            <fixr:annotation supported="supported">
                <fixr:documentation purpose="SYNOPSIS" supported="supported">
                    IG uses the custom tag ClosingOrderIDRef to identify the IG Order ID of an order which has resulted
                    in a close or part-close of a position. The ClosingOrderIDRef value corresponds to the value of
                    OrderId (37) on the Execution Report for the client order which resulted in the position change
                </fixr:documentation>
            </fixr:annotation>
        </fixr:field>


    </xsl:param>

    <xsl:param name="addGroups">
        <fixr:group id="2152" added="FIX.5.0SP2" addedEP="222" name="OrderAttributeGroup"
                    category="SingleGeneralOrderHandling" abbrName="OrderAttributeGrp">
            <fixr:numInGroup id="2593"/>
            <fixr:fieldRef id="2594" added="FIX.5.0SP2" addedEP="222">
                <fixr:annotation>
                    <fixr:documentation/>
                </fixr:annotation>
            </fixr:fieldRef>
            <fixr:fieldRef id="2595" added="FIX.5.0SP2" addedEP="222">
                <fixr:annotation>
                    <fixr:documentation/>
                </fixr:annotation>
            </fixr:fieldRef>
            <fixr:annotation>
                <fixr:documentation/>
            </fixr:annotation>
        </fixr:group>

    </xsl:param>

    <xsl:param name="addFieldRefsToQuote">
        <fixr:fieldRef id="390" added="FIX.4.2">
            <fixr:annotation supported="supported">
                <fixr:documentation supported="supported">
                    Required to relate the bid response
                </fixr:documentation>
            </fixr:annotation>
        </fixr:fieldRef>
        <fixr:fieldRef id="1867" added="FIX.5.0SP2">
            <fixr:annotation supported="supported">
                <fixr:documentation supported="supported">
                    Unique identifier for the ask side of the quote.
                </fixr:documentation>
            </fixr:annotation>
        </fixr:fieldRef>
        <fixr:fieldRef id="451">
            <fixr:annotation supported="supported">
                <fixr:documentation supported="supported">
                    Net Change added as IG Customisation
                </fixr:documentation>
            </fixr:annotation>
        </fixr:fieldRef>
    </xsl:param>


    <xsl:param name="addFieldRefsToQuoteRequest">
        <fixr:fieldRef id="263">
            <fixr:annotation supported="supported">
                <fixr:documentation supported="supported">
                    SubscriptionRequestType added as IG customisation
                </fixr:documentation>
            </fixr:annotation>
        </fixr:fieldRef>
    </xsl:param>


    <xsl:param name="addFieldRefsToExecRpt">
        <fixr:fieldRef id="1080" added="FIX.4.4">
            <fixr:annotation supported="supported">
                <fixr:documentation supported="supported">
                    The ID reference to the order being hit or taken.
                </fixr:documentation>
            </fixr:annotation>
        </fixr:fieldRef>
        <fixr:fieldRef id="1081" added="FIX.4.4">
            <fixr:annotation supported="supported">
                <fixr:documentation supported="supported">
                    Used to specify what identifier, provided in order depth market data, to use when hitting (taking) a
                    specific order
                </fixr:documentation>
            </fixr:annotation>
        </fixr:fieldRef>
    </xsl:param>

    <xsl:param name="addFieldRefsToListCancel">
        <fixr:fieldRef id="1">
            <fixr:annotation supported="supported">
                <fixr:documentation supported="supported">
                    Account added as IG customisation
                </fixr:documentation>
            </fixr:annotation>
        </fixr:fieldRef>
    </xsl:param>

    <xsl:param name="addOrderAttributeGroupRef">
        <fixr:groupRef id="2152" added="FIX.5.0SP2">
            <fixr:annotation>
                <fixr:documentation>
                    Order Attribute Group
                </fixr:documentation>
            </fixr:annotation>
        </fixr:groupRef>
    </xsl:param>

    <xsl:param name="addOrderAttributeGroupToGroup">
        <fixr:groupRef id="2152" added="FIX.5.0SP2"/>
    </xsl:param>

    <xsl:param name="addClOrdIDtoRefOrderIDSource">
        <fixr:code name="ClOrdID" id="1081099" value="C" sort="5" added="IG">
            <fixr:annotation>
                <fixr:documentation purpose="SYNOPSIS">
                    ClOrdID(11)
                </fixr:documentation>
            </fixr:annotation>
        </fixr:code>
    </xsl:param>

    <xsl:param name="addCustomMsgTypestoRefMsgType">
		<fixr:code name="AccountSummaryReportRequest" id="35500" value="UA" sort="500">
				<fixr:annotation>
					<fixr:documentation purpose="SYNOPSIS">
         AccountSummaryReportRequest
      </fixr:documentation>
					<fixr:documentation purpose="ELABORATION">
         The Account Summary Report Request message is used to request Account Summary Report
      </fixr:documentation>
				</fixr:annotation>
			</fixr:code>
	   <fixr:code name="ChartDataSubscriptionRequest" id="35501" value="UB" sort="501">
				<fixr:annotation>
					<fixr:documentation purpose="SYNOPSIS">
         ChartDataSubscriptionRequest
      </fixr:documentation>
					<fixr:documentation purpose="ELABORATION">
         The Chart Data Subscription Request message is used to subscribe to chart data
      </fixr:documentation>
				</fixr:annotation>
			</fixr:code>
	   <fixr:code name="HistoricCandleRequest" id="35502" value="UC" sort="502">
				<fixr:annotation>
					<fixr:documentation purpose="SYNOPSIS">
         HistoricCandleRequest
      </fixr:documentation>
					<fixr:documentation purpose="ELABORATION">
         The Historic Candle Request message is used to request historic data
      </fixr:documentation>
				</fixr:annotation>
			</fixr:code>
    </xsl:param>

    <xsl:template match="node()|@*" name="identity">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="fixr:fields/fixr:field[position()=last()]">
        <xsl:call-template name="identity"/>
        <xsl:copy-of select="$addFields"/>
    </xsl:template>

    <xsl:template match="fixr:fields/fixr:field[position()=last()]">
        <xsl:call-template name="identity"/>
        <xsl:copy-of select="$addFields"/>
    </xsl:template>

    <xsl:template match="fixr:groups/fixr:group[position()=last()]">
        <xsl:call-template name="identity"/>
        <xsl:copy-of select="$addGroups"/>
    </xsl:template>

    <xsl:template match="fixr:messages/fixr:message[@msgType='S']/fixr:structure/fixr:fieldRef[position()=last()]">
        <xsl:call-template name="identity"/>
        <xsl:copy-of select="$addFieldRefsToQuote"/>
    </xsl:template>

    <xsl:template match="fixr:messages/fixr:message[@msgType='K']/fixr:structure/fixr:fieldRef[position()=last()]">
        <xsl:call-template name="identity"/>
        <xsl:copy-of select="$addFieldRefsToListCancel"/>
    </xsl:template>

    <xsl:template match="fixr:messages/fixr:message[@msgType='R']/fixr:structure/fixr:fieldRef[position()=last()]">
        <xsl:call-template name="identity"/>
        <xsl:copy-of select="$addFieldRefsToQuoteRequest"/>
    </xsl:template>


    <xsl:template match="fixr:messages/fixr:message[@msgType='8']/fixr:structure/fixr:fieldRef[position()=last()]">
        <xsl:call-template name="identity"/>
        <xsl:copy-of select="$addFieldRefsToExecRpt"/>
    </xsl:template>

    <xsl:template
            match="fixr:messages/fixr:message[(@msgType='D' or @msgType='G' or @msgType='8')]/fixr:structure/fixr:groupRef[position()=last()]">
        <xsl:call-template name="identity"/>
        <xsl:copy-of select="$addOrderAttributeGroupRef"/>
    </xsl:template>

    <!-- adding  OrderAttributeGroup, note that it is placed after last componentRef -->
    <xsl:template match="fixr:groups/fixr:group[(@id='2030')]/fixr:componentRef[position()=last()]">
        <xsl:call-template name="identity"/>
        <xsl:copy-of select="$addOrderAttributeGroupToGroup"/>
    </xsl:template>

    <!--  RefOrderIdSource customisation -->
    <xsl:template match="fixr:codeSets/fixr:codeSet[(@id='1081')]/fixr:code[position()=last()]">
        <xsl:call-template name="identity"/>
        <xsl:copy-of select="$addClOrdIDtoRefOrderIDSource"/>
    </xsl:template>

 	<!--  RefMsgType customisation -->
    <xsl:template match="fixr:codeSets/fixr:codeSet[(@id='35')]/fixr:code[position()=last()]">
        <xsl:call-template name="identity"/>
        <xsl:copy-of select="$addCustomMsgTypestoRefMsgType"/>
    </xsl:template>    

    <xsl:template match="fixr:components/fixr:component[@id='1003']/fixr:fieldRef[@id='55']">
        <xsl:copy>
            <xsl:attribute name="presence">
                <xsl:value-of select="'required'"/>
            </xsl:attribute>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="fixr:components/fixr:component[@id='1011']/fixr:fieldRef[@id='38']">
        <xsl:copy>
            <xsl:attribute name="presence">
                <xsl:value-of select="'required'"/>
            </xsl:attribute>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>


    <xsl:param name="addFieldRefsToPositionReport">
        <fixr:fieldRef id="155" added="FIX.4.2">
            <fixr:annotation supported="supported">
                <fixr:documentation supported="supported">
                    Settlement currency fx rate
                </fixr:documentation>
            </fixr:annotation>
        </fixr:fieldRef>

        <fixr:fieldRef id="2618" added="FIX.5.0SP2"/>

        <fixr:fieldRef id="20104" added="FIX.4.2">
            <fixr:annotation supported="supported">
                <fixr:documentation supported="supported">
                    The price at which the Position was opened, will be reported in Currency
                </fixr:documentation>
            </fixr:annotation>
        </fixr:fieldRef>

        <fixr:fieldRef id="20101" added="FIX.5.0SP2">
            <fixr:annotation supported="supported">
                <fixr:documentation supported="supported">
                    IG uses the custom tag OriginatingClientOrderRef to represent:
                    • the ClOrdID(11) from the client order which resulted in the position
                    • a reference from another channel such as web trade
                </fixr:documentation>
            </fixr:annotation>
        </fixr:fieldRef>
        <fixr:fieldRef id="20102" added="FIX.5.0SP2">
            <fixr:annotation supported="supported">
                <fixr:documentation supported="supported">
                    IG uses the custom tag OriginatingOrderIDRef to identify the IG Order ID of an order which has
                    resulted in opening the Position. The OriginatingOrderIDRef value corresponds to the value of
                    OrderId (37) on the Execution Report for the client order which resulted in opening the position
                </fixr:documentation>
            </fixr:annotation>
        </fixr:fieldRef>
        <fixr:fieldRef id="20103" added="FIX.5.0SP2">
            <fixr:annotation supported="supported">
                <fixr:documentation purpose="SYNOPSIS" supported="supported">
                    IG uses the custom tag ClosingOrderIDRef to identify the IG Order ID of an order which has resulted
                    in a close or part-close of a position. The ClosingOrderIDRef value corresponds to the value of
                    OrderId (37) on the Execution Report for the client order which resulted in the position change
                </fixr:documentation>
            </fixr:annotation>
        </fixr:fieldRef>

    </xsl:param>


    <xsl:template match="fixr:messages/fixr:message[@msgType='AP']/fixr:structure/fixr:fieldRef[position()=last()]">
        <xsl:call-template name="identity"/>
        <xsl:copy-of select="$addFieldRefsToPositionReport"/>
    </xsl:template>

</xsl:stylesheet>

