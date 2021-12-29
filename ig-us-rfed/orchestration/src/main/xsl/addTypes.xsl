<xsl:stylesheet version="FIX.5.0SP2"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:functx="http://www.functx.com"
	xmlns:fixr="http://fixprotocol.io/2020/orchestra/repository"
	xmlns:dc="http://purl.org/dc/elements/1.1/">
	<xsl:output method="xml" />
	<xsl:strip-space elements="*" />
	<xsl:output omit-xml-declaration="no" indent="yes" />

	<xsl:param name="addFields">

		<fixr:field added="IG" id="20101"
			name="OriginatingClientOrderRef" type="String"
			abbrName="OriginatingClientOrderRef" presence="optional"
			supported="supported">
			<fixr:annotation supported="supported">
				<fixr:documentation purpose="SYNOPSIS"
					supported="supported">
					IG uses the custom tag OriginatingClientOrderRef to represent:
					the ClOrdID(11) from the client order which resulted in	the position,
					a reference from another channel such as web trade
				</fixr:documentation>
			</fixr:annotation>
		</fixr:field>

		<fixr:field added="IG" id="20102"
			name="OriginatingOrderIDRef" type="String"
			abbrName="OriginatingClientOrderRef" presence="optional"
			supported="supported">
			<fixr:annotation supported="supported">
				<fixr:documentation purpose="SYNOPSIS"
					supported="supported">
					IG uses the custom tag OriginatingOrderIDRef to identify the IG Order ID of an order which has resulted in opening the
					Position. The OriginatingOrderIDRef value corresponds to the value ofOrderId (37) on the Execution Report for the client order which resulted in opening the position
				</fixr:documentation>
			</fixr:annotation>
		</fixr:field>

		<fixr:field added="IG" id="20103"
			name="ClosingOrderIDRef" type="String"
			abbrName="OriginatingClientOrderRef" presence="optional"
			supported="supported">
			<fixr:annotation supported="supported">
				<fixr:documentation purpose="SYNOPSIS"
					supported="supported">
					IG uses the custom tag ClosingOrderIDRef to identify the IG Order ID of an order which has resulted in a close or part-close of a position.
					The ClosingOrderIDRef value corresponds to the value of OrderId (37) on the Execution Report for the client order which resulted in the position change.
				</fixr:documentation>
			</fixr:annotation>
		</fixr:field>

		<fixr:field added="IG" id="20104" name="OpenPrice"
			type="Price" addedEP="222" abbrName="OpenPrice" presence="optional"
			supported="supported">
			<fixr:annotation supported="supported">
				<fixr:documentation purpose="SYNOPSIS"
					supported="supported">
					The price at which the Position was opened, will be reported in Currency (15)
				</fixr:documentation>
			</fixr:annotation>
		</fixr:field>
		
		<fixr:field added="IG" id="20105"
			name="AccountSummaryReportRequestID" type="String"
			abbrName="AccountSummaryReportRequestID" presence="required"
			supported="supported">
			<fixr:annotation supported="supported">
				<fixr:documentation purpose="SYNOPSIS"
					supported="supported">
					Used in the custom message AccountSummaryReportRequest
				</fixr:documentation>
			</fixr:annotation>
		</fixr:field>
		<fixr:field added="IG" id="20106" 
			name="AccountSummaryReportRequestResult" 
			type="AccountSummaryReportRequestResultCodeSet" 
		 	abbrName="AccountSummaryReportRequestResult" presence="required"
			supported="supported">
			<fixr:annotation>
				<fixr:documentation purpose="SYNOPSIS">
         			the result of an AccountSummaryReportRequest
      			</fixr:documentation>
			</fixr:annotation>
		</fixr:field>		
	</xsl:param>

	<xsl:param name="addGroups">
	</xsl:param>

	<xsl:param name="addFieldRefsToQuote">
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
	</xsl:param>

	<xsl:param name="addOrderAttributeGroupToListOrdGrp">
	</xsl:param>

	<xsl:param name="addToOrderAttributeType">
		<fixr:code name="AttachedOrder" id="2594016" value="1001"  added="IG">
			<fixr:annotation>
				<fixr:documentation purpose="SYNOPSIS">
					Indicates that the order is attached (or to be attached) to an existing position
				</fixr:documentation>
			</fixr:annotation>
		</fixr:code>
	</xsl:param>

	<xsl:template
			match="fixr:codeSets/fixr:codeSet[(@id='2594')]/fixr:code[position()=last()]">
		<xsl:call-template name="identity" />
		<xsl:copy-of select="$addToOrderAttributeType" />
	</xsl:template>

	<xsl:param name="addClOrdIDtoRefOrderIDSource">
		<fixr:code name="ClOrdID" id="1081099" value="C" sort="5"
			added="IG">
			<fixr:annotation>
				<fixr:documentation purpose="SYNOPSIS">
					ClOrdID(11)
				</fixr:documentation>
			</fixr:annotation>
		</fixr:code>
	</xsl:param>

	<xsl:param name="addCustomMsgTypestoRefMsgType">
		<fixr:code name="AccountSummaryReportRequest" id="35500"
			value="UA" sort="500">
			<fixr:annotation>
				<fixr:documentation purpose="SYNOPSIS">
					AccountSummaryReportRequest
				</fixr:documentation>
				<fixr:documentation purpose="ELABORATION">
					The Account Summary Report Request message is used to request Account Summary Report.
				</fixr:documentation>
			</fixr:annotation>
		</fixr:code>
		<fixr:code name="ChartDataSubscriptionRequest" id="35501"
			value="UB" sort="501">
			<fixr:annotation>
				<fixr:documentation purpose="SYNOPSIS">
					ChartDataSubscriptionRequest
				</fixr:documentation>
				<fixr:documentation purpose="ELABORATION">
					The Chart Data Subscription Request message is used to subscribe to chart data.
				</fixr:documentation>
			</fixr:annotation>
		</fixr:code>
		<fixr:code name="HistoricCandleRequest" id="35502"
			value="UC" sort="502">
			<fixr:annotation>
				<fixr:documentation purpose="SYNOPSIS">
					HistoricCandleRequest
				</fixr:documentation>
				<fixr:documentation purpose="ELABORATION">
					The Historic Candle Request message is used to request historic data.
				</fixr:documentation>
			</fixr:annotation>
		</fixr:code>
	</xsl:param>

	<xsl:param name="addCustomInstrAttribTypeToAttrbGrp">
			<fixr:code name="DealableCurrencies" id="871115" value="115" sort="114" added="IG">
				<fixr:annotation>
					<fixr:documentation purpose="SYNOPSIS">
						Dealable Currencies
					</fixr:documentation>
					<fixr:documentation purpose="ELABORATION">
						List of the  currencies in which an instrument can be dealt
					</fixr:documentation>
				</fixr:annotation>
			</fixr:code>
			<fixr:code name="MarketOrdersSupported" id="871116" value="116" sort="115" added="IG">
				<fixr:annotation>
					<fixr:documentation purpose="SYNOPSIS">
						Are Market orders supported
					</fixr:documentation>
					<fixr:documentation purpose="ELABORATION">
						Used to indicate whether the instrument supports market orders. InstrAttribValue will be ‘Y’ if market orders are supported.
					</fixr:documentation>
				</fixr:annotation>
			</fixr:code>
			<fixr:code name="MarketDataSupported" id="871120" value="120" sort="119" added="IG">
				<fixr:annotation>
					<fixr:documentation purpose="SYNOPSIS">
						Are Market Data Requests supported
					</fixr:documentation>
					<fixr:documentation purpose="ELABORATION">
						Used to indicate whether the requests for market data are supported for this instrument. InstrAttribValue will be ‘N’ if market data is not supported.
					</fixr:documentation>
				</fixr:annotation>
			</fixr:code>
	</xsl:param>
	
	<xsl:param name="addCustomMarginAmtType">
		<fixr:code name="ControlledRiskMargin" id="1644100" value="100" sort="100"  added="IG">
			<fixr:annotation>
				<fixr:documentation purpose="SYNOPSIS">
					ControlledRiskMargin
				</fixr:documentation>
			</fixr:annotation>
		</fixr:code>
		<fixr:code name="NonControlledRiskMargin" id="1644101" value="101" sort="101" added="IG">
			<fixr:annotation>
				<fixr:documentation purpose="SYNOPSIS">
					NonControlledRiskMargin
				</fixr:documentation>
			</fixr:annotation>
		</fixr:code>
	</xsl:param>

	<xsl:param name="addToExecRestatementReason">
		<fixr:code name="SystemStopLossSizeAdjustment" id="378019" value="100"  added="IG">
			<fixr:annotation>
				<fixr:documentation purpose="SYNOPSIS">
					When there is a change in an account's aggregate position of an instrument then an existing stop loss order is restated with its OrdQty updated by the system.
				</fixr:documentation>
			</fixr:annotation>
		</fixr:code>
		<fixr:code name="SystemTakeProfitSizeAdjustment" id="378020" value="101"  added="IG">
			<fixr:annotation>
				<fixr:documentation purpose="SYNOPSIS">
					When there is a change in an account's aggregate position of an instrument then an existing Take Profit order is restated with its OrdQty updated by the system.
				</fixr:documentation>
			</fixr:annotation>
		</fixr:code>
		<fixr:code name="SystemTrailingStopAdjustment" id="378021" value="102"  added="IG">
			<fixr:annotation>
				<fixr:documentation purpose="SYNOPSIS">
					In the event of a trailing stop price being updated by the system when pegged to a market price.
				</fixr:documentation>
			</fixr:annotation>
		</fixr:code>
		<fixr:code name="SystemOTOContingentAdjustment" id="378022" value="103"  added="IG">
			<fixr:annotation>
				<fixr:documentation purpose="SYNOPSIS">
					In the event of a contingent order being restated due to the associated OTO order executing.
					For example a resting order executes and its contingent stop order becomes working and is then restated.
				</fixr:documentation>
			</fixr:annotation>
		</fixr:code>
	</xsl:param>

	<xsl:param name="addFieldRefsToPositionReport">
		<fixr:fieldRef id="155" added="IG">
			<fixr:annotation supported="supported">
				<fixr:documentation supported="supported">
					Settlement currency FX rate
				</fixr:documentation>
			</fixr:annotation>
		</fixr:fieldRef>
		<fixr:fieldRef id="20104" added="IG">
			<fixr:annotation supported="supported">
				<fixr:documentation supported="supported">
					The price at which the Position was opened, will be reported in Currency.
				</fixr:documentation>
			</fixr:annotation>
		</fixr:fieldRef>
		<fixr:fieldRef id="20101" added="IG">
			<fixr:annotation supported="supported">
				<fixr:documentation supported="supported">
					IG uses the custom tag OriginatingClientOrderRef to represent:
					the ClOrdID(11) from the client order which resulted in the position,
					a reference from another channel such as web trade
				</fixr:documentation>
			</fixr:annotation>
		</fixr:fieldRef>
		<fixr:fieldRef id="20102" added="IG">
			<fixr:annotation supported="supported">
				<fixr:documentation supported="supported">
					IG uses the custom tag OriginatingOrderIDRef to identify the IG Order ID of an order which has resulted in opening the Position.
					The OriginatingOrderIDRef value corresponds to the value of OrderId (37)
					on the Execution Report for the client order which resulted in opening the position.
				</fixr:documentation>
			</fixr:annotation>
		</fixr:fieldRef>
		<fixr:fieldRef id="20103" added="IG">
			<fixr:annotation supported="supported">
				<fixr:documentation purpose="SYNOPSIS"
					supported="supported">
					IG uses the custom tag ClosingOrderIDRef to identify the IG Order ID of an order which has resulted in a close or part-close of a position.
					The ClosingOrderIDRef value corresponds to the value of OrderId (37) on the Execution Report for the client order which resulted in the position change.
				</fixr:documentation>
			</fixr:annotation>
		</fixr:fieldRef>
	</xsl:param>

	<xsl:param name="addFieldRefsToRequestForPositionsAck">
		<fixr:fieldRef id="912" added="IG">
			<fixr:annotation supported="supported">
				<fixr:documentation supported="supported">
               LastRptRequested. Indicates whether this message is the last report message in response to a request message, e.g. OrderMassStatusRequest(35=AF),
               TradeCaptureReportRequest(35=AD).
            </fixr:documentation>
			</fixr:annotation>
		</fixr:fieldRef>
	</xsl:param>

	<xsl:param name="addFieldRefsToAccountSummaryReport">
		<fixr:fieldRef id="20105" added="IG">
			<fixr:annotation supported="supported">
				<fixr:documentation supported="supported">
				AccountSummaryReportRequestID: the id of the request causing this AccountSummaryReport
            </fixr:documentation>
			</fixr:annotation>
		</fixr:fieldRef>
		<fixr:fieldRef id="20106" added="IG">
			<fixr:annotation supported="supported">
				<fixr:documentation supported="supported">
				AccountSummaryReportRequestResult
            </fixr:documentation>
			</fixr:annotation>
		</fixr:fieldRef>
		<fixr:fieldRef id="58" added="IG">
			<fixr:annotation supported="supported">
				<fixr:documentation supported="supported">
				Text: reason for rejection
            </fixr:documentation>
			</fixr:annotation>
		</fixr:fieldRef>
	</xsl:param>

	<xsl:template match="node()|@*" name="identity">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*" />
		</xsl:copy>
	</xsl:template>

	<xsl:template
		match="fixr:fields/fixr:field[position()=last()]">
		<xsl:call-template name="identity" />
		<xsl:copy-of select="$addFields" />
	</xsl:template>

	<xsl:template
		match="fixr:groups/fixr:group[position()=last()]">
		<xsl:call-template name="identity" />
		<xsl:copy-of select="$addGroups" />
	</xsl:template>

	<xsl:param name="addCodeSets">
		<fixr:codeSet name="AccountSummaryReportRequestResultCodeSet" id="10001" type="int" added="IG">
			<fixr:code name="ValidRequest" id="10001001" value="0" sort="0" added="IG">
				<fixr:annotation>
					<fixr:documentation purpose="SYNOPSIS">
					         Valid request
					      </fixr:documentation>
					<fixr:documentation purpose="ELABORATION">
	      			</fixr:documentation>
				</fixr:annotation>
			</fixr:code>
			<fixr:code name="InvalidOrUnsupportedRequest" id="10001002" value="1" sort="1" added="IG">
				<fixr:annotation>
					<fixr:documentation purpose="SYNOPSIS">
					         InvalidOrUnsupportedRequest
					      </fixr:documentation>
					<fixr:documentation purpose="ELABORATION">
	      			</fixr:documentation>
				</fixr:annotation>
			</fixr:code>
			<fixr:code name="UnknownAccount" id="10001003" value="2" sort="2" added="IG">
				<fixr:annotation>
					<fixr:documentation purpose="SYNOPSIS">
					         UnknownAccount
					      </fixr:documentation>
					<fixr:documentation purpose="ELABORATION">
	      			</fixr:documentation>
				</fixr:annotation>
			</fixr:code>
			<fixr:code name="Unauthorised" id="10001004" value="3" sort="3" added="IG">
				<fixr:annotation>
					<fixr:documentation purpose="SYNOPSIS">
					         Unauthorised
					      </fixr:documentation>
					<fixr:documentation purpose="ELABORATION">
	      			</fixr:documentation>
				</fixr:annotation>
			</fixr:code>
			<fixr:code name="NotSupported" id="10001005" value="4" sort="4" added="IG">
				<fixr:annotation>
					<fixr:documentation purpose="SYNOPSIS">
					         NotSupported
					      </fixr:documentation>
					<fixr:documentation purpose="ELABORATION">
	      			</fixr:documentation>
				</fixr:annotation>
			</fixr:code>
			<fixr:code name="Other" id="10001006" value="5" sort="5" added="IG">
				<fixr:annotation>
					<fixr:documentation purpose="SYNOPSIS">
					         Other error
					      </fixr:documentation>
					<fixr:documentation purpose="ELABORATION">
	      			</fixr:documentation>
				</fixr:annotation>
			</fixr:code>
		</fixr:codeSet>
	</xsl:param>

	<xsl:template
		match="fixr:codeSets/fixr:codeSet[position()=last()]">
		<xsl:call-template name="identity" />
		<xsl:copy-of select="$addCodeSets" />
	</xsl:template>

	<xsl:param name="addMessages">
	<fixr:message name="AccountSummaryReportRequest" id="10127" msgType="UA" category="AccountReporting" added="IG" abbrName="AcctSumRptReq">
			<fixr:structure>
				<!-- header -->
				<fixr:componentRef id="1024" presence="required" added="IG" >
					<fixr:annotation>
						<fixr:documentation>
         MsgType = UA
      </fixr:documentation>
					</fixr:annotation>
				</fixr:componentRef>
				<!-- AccountSummaryReportRequestID -->
				<fixr:fieldRef id="20105" presence="required" added="IG">
					<fixr:annotation>
						<fixr:documentation/>
					</fixr:annotation>
				</fixr:fieldRef>
				<!-- SubscriptionRequestType  -->
				<fixr:fieldRef id="263" presence="required" added="IG">
					<fixr:annotation>
						<fixr:documentation/>
					</fixr:annotation>
				</fixr:fieldRef>
				<!-- <fixr:group id="1012" added="FIX.4.3" name="Parties" category="Common" abbrName="Pty"> -->
				<fixr:groupRef id="1012" added="IG">
					<fixr:annotation>
					<fixr:documentation>
					         Insert here the set of "Parties" (firm identification) fields defined in "Common Components of Application Messages".
					      </fixr:documentation>
					</fixr:annotation>
				</fixr:groupRef>
				<!-- trailer -->
				<fixr:componentRef id="1025" added="IG">
					<fixr:annotation>
						<fixr:documentation/>
					</fixr:annotation>
				</fixr:componentRef>
			</fixr:structure>
			<fixr:annotation>
				<fixr:documentation purpose="SYNOPSIS">
					Used to request AccountSummaryReport(s) for account information. It can request a snapshot or a streaming update.
      		</fixr:documentation>
			</fixr:annotation>
		</fixr:message>		
	</xsl:param>

	<xsl:template
		match="fixr:messages/fixr:message[position()=last()]">
		<xsl:call-template name="identity" />
		<xsl:copy-of select="$addMessages" />
	</xsl:template>

	<xsl:template
		match="fixr:messages/fixr:message[@msgType='S']/fixr:structure/fixr:fieldRef[position()=last()]">
		<xsl:call-template name="identity" />
		<xsl:copy-of select="$addFieldRefsToQuote" />
	</xsl:template>

	<xsl:template
		match="fixr:messages/fixr:message[@msgType='K']/fixr:structure/fixr:fieldRef[position()=last()]">
		<xsl:call-template name="identity" />
		<xsl:copy-of select="$addFieldRefsToListCancel" />
	</xsl:template>

	<xsl:template
		match="fixr:messages/fixr:message[@msgType='R']/fixr:structure/fixr:fieldRef[position()=last()]">
		<xsl:call-template name="identity" />
		<xsl:copy-of select="$addFieldRefsToQuoteRequest" />
	</xsl:template>

	<xsl:template
		match="fixr:messages/fixr:message[@msgType='8']/fixr:structure/fixr:fieldRef[position()=last()]">
		<xsl:call-template name="identity" />
		<xsl:copy-of select="$addFieldRefsToExecRpt" />
	</xsl:template>

	<xsl:template
		match="fixr:messages/fixr:message[(@msgType='D' or @msgType='G' or @msgType='8')]/fixr:structure/fixr:groupRef[position()=last()]">
		<xsl:call-template name="identity" />
		<xsl:copy-of select="$addOrderAttributeGroupRef" />
	</xsl:template>

	<!-- adding OrderAttributeGroup, note that it is placed after last componentRef -->
	<xsl:template
		match="fixr:groups/fixr:group[(@id='2030')]/fixr:componentRef[position()=last()]">
		<xsl:call-template name="identity" />
		<xsl:copy-of select="$addOrderAttributeGroupToListOrdGrp" />
	</xsl:template>

	<!-- RefOrderIdSource customisation -->
	<xsl:template
		match="fixr:codeSets/fixr:codeSet[(@id='1081')]/fixr:code[position()=last()]">
		<xsl:call-template name="identity" />
		<xsl:copy-of select="$addClOrdIDtoRefOrderIDSource" />
	</xsl:template>

	<!-- RefMsgType customisation -->
	<xsl:template
		match="fixr:codeSets/fixr:codeSet[(@id='35')]/fixr:code[position()=last()]">
		<xsl:call-template name="identity" />
		<xsl:copy-of select="$addCustomMsgTypestoRefMsgType" />
	</xsl:template>

	<!-- InstrAttribType customisation -->
	<xsl:template
		match="fixr:codeSets/fixr:codeSet[(@id='871')]/fixr:code[position()=last()]">
		<xsl:call-template name="identity" />
		<xsl:copy-of select="$addCustomInstrAttribTypeToAttrbGrp" />
	</xsl:template>
	
	<!-- MarginAmtType customisation -->
	<xsl:template
		match="fixr:codeSets/fixr:codeSet[(@id='1644')]/fixr:code[position()=last()]">
		<xsl:call-template name="identity" />
		<xsl:copy-of select="$addCustomMarginAmtType" />
	</xsl:template>

	<!-- ExecRestatementReason customisation -->
	<xsl:template
			match="fixr:codeSets/fixr:codeSet[(@id='378')]/fixr:code[position()=last()]">
		<xsl:call-template name="identity" />
		<xsl:copy-of select="$addToExecRestatementReason" />
	</xsl:template>

	<!-- SecurityRequestResultCodeSet customisation. -->
	<xsl:template
		match="fixr:codeSets/fixr:codeSet[(@id='560')]/fixr:code[position()=last()]">
		<xsl:call-template name="identity" />
		<fixr:code name="RequestQuotaExceeded" id="560100" value="100" sort="100" >
			<fixr:annotation>
				<fixr:documentation purpose="SYNOPSIS">
         			A request quota has been exceeded. Try again later.
     			</fixr:documentation>
			</fixr:annotation>
		</fixr:code>
	</xsl:template>

	<xsl:template
		match="fixr:components/fixr:component[@id='1003']/fixr:fieldRef[@id='55']">
		<xsl:copy>
			<xsl:attribute name="presence">
                <xsl:value-of select="'required'" />
            </xsl:attribute>
			<xsl:apply-templates select="@*" />
			<xsl:apply-templates select="node()" />
		</xsl:copy>
	</xsl:template>

	<xsl:template
		match="fixr:components/fixr:component[@id='1011']/fixr:fieldRef[@id='38']">
		<xsl:copy>
			<xsl:attribute name="presence">
                <xsl:value-of select="'required'" />
            </xsl:attribute>
			<xsl:apply-templates select="@*" />
			<xsl:apply-templates select="node()" />
		</xsl:copy>
	</xsl:template>

	<xsl:template
		match="fixr:messages/fixr:message[@msgType='AP']/fixr:structure/fixr:fieldRef[position()=last()]">
		<xsl:call-template name="identity" />
		<xsl:copy-of select="$addFieldRefsToPositionReport" />
	</xsl:template>

	<xsl:template
			match="fixr:messages/fixr:message[@msgType='AO']/fixr:structure/fixr:fieldRef[position()=last()]">
		<xsl:call-template name="identity" />
		<xsl:copy-of select="$addFieldRefsToRequestForPositionsAck" />
	</xsl:template>
	
	<!-- AccountSummaryReport customization -->
	<xsl:template
			match="fixr:messages/fixr:message[@msgType='CQ']/fixr:structure/fixr:fieldRef[position()=last()]">
		<xsl:call-template name="identity" />
		<xsl:copy-of select="$addFieldRefsToAccountSummaryReport" />
	</xsl:template>
	
</xsl:stylesheet>
