<xsl:stylesheet version="FIX.5.0SP2" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com" xmlns:fixr="http://fixprotocol.io/2016/fixrepository" xmlns:dc="http://purl.org/dc/elements/1.1/">
<xsl:output method="xml"/>
<xsl:strip-space elements="*"/>
<xsl:output omit-xml-declaration="no" indent="yes"/>

  <xsl:param name="addFields">
		<fixr:field added="FIX.5.0SP2" id="1867" name="OfferID" type="String" addedEP="144" abbrName="OfrID" presence="optional" supported="supported">
			<fixr:annotation supported="supported">
				<fixr:documentation purpose="SYNOPSIS" supported="supported">
         Unique identifier for the ask side of the quote assigned by the quote issuer.
      </fixr:documentation>
			</fixr:annotation>
		</fixr:field>	
  </xsl:param>

  <xsl:param name="addFieldRefsToQuote">
					<fixr:fieldRef id="390" name="BidID" added="FIX.4.2" presence="optional" supported="supported">
						<fixr:annotation supported="supported">
							<fixr:documentation supported="supported">
         Required to relate the bid response
      </fixr:documentation>
						</fixr:annotation>
					</fixr:fieldRef>					
					<fixr:fieldRef id="1867" name="OfferID" added="FIX.5.0SP2" addedEP="144" presence="optional" supported="supported">
						<fixr:annotation supported="supported">
							<fixr:documentation supported="supported">
         Unique identifier for the ask side of the quote.
      </fixr:documentation>
						</fixr:annotation>
					</fixr:fieldRef>
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

 <xsl:template match="fixr:messages/fixr:message[@msgType='S']/fixr:structure/fixr:fieldRef[position()=last()]">	
	<xsl:call-template name="identity"/>
	<xsl:copy-of select="$addFieldRefsToQuote"/>
 </xsl:template>
	
</xsl:stylesheet>

