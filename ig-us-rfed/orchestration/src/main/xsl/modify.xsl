<xsl:stylesheet version="FIX.5.0SP2"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:functx="http://www.functx.com"
    xmlns:fixr="http://fixprotocol.io/2020/orchestra/repository"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:java="java">
    <xsl:output method="xml" />
    <xsl:strip-space elements="*" />
    <xsl:output omit-xml-declaration="no" indent="yes" />
	<!-- this stylesheet modifies the orchestra file  -->
	
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

	<!-- Updates to meta data section-->
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


	<!-- Override message descriptions/documentation -->
	<xsl:template match="fixr:message[@name='QuoteRequest']/fixr:annotation/fixr:documentation/text()">
		<xsl:text>The message to request Quotes for an instrument. This message is commonly referred to as an Request For Quote (RFQ)</xsl:text>
	</xsl:template>

	<!-- Overrides field descriptions that are applicable on a per message basis-->

	<!-- These first overrides apply to multiple messages-->
	<xsl:template match="fixr:message[@name='NewOrderSingle'
										or @name='OrderCancelReplaceRequest'
										or @name='ExecutionReport']/fixr:structure/fixr:fieldRef[@id='44']/fixr:annotation/fixr:documentation/text()">
		<xsl:text>Required for limit and PreviouslyQuoted OrdTypes.</xsl:text>
	</xsl:template>
	<xsl:template match="fixr:message[@name='NewOrderSingle'
										or @name='OrderCancelReplaceRequest'
										or @name='ExecutionReport']/fixr:structure/fixr:fieldRef[@id='99']/fixr:annotation/fixr:documentation/text()">
		<xsl:text>Required for OrdType = "Stop".</xsl:text>
	</xsl:template>
	<xsl:template match="fixr:message[@name='NewOrderSingle'
										or @name='OrderCancelReplaceRequest'
										or @name='ExecutionReport']/fixr:structure/fixr:fieldRef[@id='59']/fixr:annotation/fixr:documentation/text()">
		<xsl:text></xsl:text>
	</xsl:template>
	<xsl:template match="fixr:message[@name='NewOrderSingle'
										or @name='OrderCancelReplaceRequest'
										or @name='ExecutionReport']/fixr:structure/fixr:fieldRef[@id='126']/fixr:annotation/fixr:documentation/text()">
		<xsl:text>Conditionally required if TimeInForce = GTD.</xsl:text>
	</xsl:template>

	<!-- NewOrderSingle overrides -->
	<xsl:template match="fixr:message[@name='NewOrderSingle']/fixr:structure/fixr:fieldRef[@id='1080']/fixr:annotation/fixr:documentation/text()">
		<xsl:text>Required if the order is contingent on another order executing first (i.e. OTO order)</xsl:text>
	</xsl:template>

	<!-- OrderCancelRequest overrides -->
	<xsl:template match="fixr:message[@name='OrderCancelRequest']/fixr:structure/fixr:componentRef[@id='1011']/fixr:annotation/fixr:documentation/text()">
		<xsl:text></xsl:text>
	</xsl:template>

	<!-- ExecutionReport overrides -->
	<xsl:template match="fixr:message[@name='ExecutionReport']/fixr:structure/fixr:fieldRef[@id='11']/fixr:annotation/fixr:documentation/text()">
		<xsl:text>Required when referring to orders that where electronically submitted over FIX or otherwise assigned a ClOrdID(11).</xsl:text>
	</xsl:template>
	<xsl:template match="fixr:message[@name='ExecutionReport']/fixr:structure/fixr:fieldRef[@id='32']/fixr:annotation/fixr:documentation/text()">
		<xsl:text>Quantity (e.g contracts) bought/sold on this (last) fill. Required if ExecType(150) = F (Trade).</xsl:text>
	</xsl:template>
	<xsl:template match="fixr:message[@name='ExecutionReport']/fixr:structure/fixr:fieldRef[@id='31']/fixr:annotation/fixr:documentation/text()">
		<xsl:text>Price of this (last) fill. Required if ExecType(150) = ExecType = F (Trade).</xsl:text>
	</xsl:template>
	<xsl:template match="fixr:message[@name='ExecutionReport']/fixr:structure/fixr:fieldRef[@id='151']/fixr:annotation/fixr:documentation/text()">
		<xsl:text>Quantity open for further execution. If the OrdStatus(39) is = 4 (Canceled), C (Expired) or 8 (Rejected) (in which case the order is no longer active) then LeavesQty(151) could be 0, otherwise LeavesQty(151) = OrderQty(38) - CumQty(14).</xsl:text>
	</xsl:template>
	<xsl:template match="fixr:message[@name='ExecutionReport']/fixr:structure/fixr:fieldRef[@id='19']/fixr:annotation/fixr:documentation/text()">
		<xsl:text/>
	</xsl:template>

	<!-- PositionReport overrides -->
	<xsl:template match="fixr:message[@name='PositionReport']/fixr:structure/fixr:fieldRef[@id='724']/fixr:annotation/fixr:documentation/text()">
		<xsl:text/>
	</xsl:template>

	<!-- RequestForPositionsAck overrides -->
	<xsl:template match="fixr:message[@name='RequestForPositionsAck']/fixr:structure/fixr:fieldRef[@id='912']/fixr:annotation/fixr:documentation/text()">
		<xsl:text>Indicates whether this message is the last report message in response to a RequestForPositions (35=AN) message</xsl:text>
	</xsl:template>



</xsl:stylesheet>
