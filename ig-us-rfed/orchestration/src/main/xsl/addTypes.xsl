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

</xsl:stylesheet>

