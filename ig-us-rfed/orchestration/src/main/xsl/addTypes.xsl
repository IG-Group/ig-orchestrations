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
		<fixr:field added="FIX.5.0SP2" id="2593" name="NoOrderAttributes" type="NumInGroup" addedEP="222" abbrName="NoOrderAttributes" presence="optional" supported="supported">
			<fixr:annotation supported="supported">
				<fixr:documentation purpose="SYNOPSIS" supported="supported">
        Number of order attribute entries.
      </fixr:documentation>
			</fixr:annotation>
		</fixr:field>
		<fixr:field added="FIX.5.0SP2" id="2594" name="OrderAttributeType" type="int" addedEP="222" abbrName="OrderAttributeType" presence="optional" supported="supported">
			<fixr:annotation supported="supported">
				<fixr:documentation purpose="SYNOPSIS" supported="supported">
        The type of order attribute.
      </fixr:documentation>
			</fixr:annotation>
		</fixr:field>
		<fixr:field added="FIX.5.0SP2" id="2595" name="OrderAttributeValue" type="String`" addedEP="222" abbrName="OrderAttributeValue" presence="optional" supported="supported">
			<fixr:annotation supported="supported">
				<fixr:documentation purpose="SYNOPSIS" supported="supported">
        The value associated with the order attribute type specified in OrderAttributeType(2594).
      </fixr:documentation>
			</fixr:annotation>
		</fixr:field>			
  </xsl:param>
  
  <xsl:param name="addGroups">
	<fixr:group id="2152" added="FIX.5.0SP2" addedEP="222" name="OrderAttributeGroup" category="SingleGeneralOrderHandling" abbrName="OrderAttributeGrp">
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
		Used to specify what identifier, provided in order depth market data, to use when hitting (taking) a specific order
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
  
 <xsl:template match="node()|@*" name="identity">
 	<xsl:copy>
    	<xsl:apply-templates select="node()|@*"/>
  	</xsl:copy>
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

 <xsl:template match="fixr:messages/fixr:message[(@msgType='D' or @msgType='G' or @msgType='8')]/fixr:structure/fixr:groupRef[position()=last()]">	
	<xsl:call-template name="identity"/>
	<xsl:copy-of select="$addOrderAttributeGroupRef"/>
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
	
</xsl:stylesheet>

