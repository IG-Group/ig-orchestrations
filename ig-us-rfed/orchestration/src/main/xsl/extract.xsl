<xsl:stylesheet version="FIX.5.0SP2" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com" xmlns:fixr="http://fixprotocol.io/2016/fixrepository" xmlns:dc="http://purl.org/dc/elements/1.1/">
<xsl:output method="xml"/>
<xsl:strip-space elements="*"/>
<xsl:output omit-xml-declaration="no" indent="yes"/>

<xsl:template match="@* | node()">
  <xsl:copy>
    <xsl:apply-templates select="@* | node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="fixr:message[not(@msgType='8')]"/> <!--  or 
                                      @msgType='9' or 
                                      @msgType='D' or 
                                      @msgType='E' or 
                                      @msgType='F' or 
                                      @msgType='G' or 
                                      @msgType='H' or 
                                      @msgType='K' or 
                                      @msgType='Q' or 
                                      @msgType='R' or 
                                      @msgType='S' or 
                                      @msgType='Z' or 
                                      @msgType='c' or 
                                      @msgType='d' or 
                                      @msgType='e' or 
                                      @msgType='f' or 
                                      @msgType='j' or 
                                      @msgType='x' or 
                                      @msgType='y' or 
                                      @msgType='AF' or 
                                      @msgType='AG' or 
                                      @msgType='AN' or 
                                      @msgType='AO' or 
                                      @msgType='AP' or 
                                      @msgType='BP' )]"/> -->

<!-- filter out unneeded components -->
<xsl:template match="fixr:components/fixr:component[not(@id='1024' or 
                                                        @id='1003' or 
                                                        @id='1011')]" />
<!-- filter out unneeded groups -->
<xsl:template match="fixr:groups/fixr:group[not(@id='2071')]" />

<xsl:template match="fixr:message/fixr:structure/fixr:componentRef[not(@id='1024' or 
                                                                       @id='1003' or 
                                                                       @id='1011')]" />

<!-- Header  -->
<xsl:template match="fixr:components/fixr:component[@id='1024']/fixr:fieldRef[not(@id='35' or
                                                                                 @id='1128' or
                                                                                 @id='1129' or
                                                                                 @id='52'
                                                                                 )]" />
<xsl:template match="fixr:components/fixr:component[@id='1024']/fixr:groupRef[(@id='2085')]" />

<!-- Instrument  -->
<xsl:template match="fixr:components/fixr:component[@id='1003']/fixr:fieldRef[not(@id='55' or
                                                                                 @id='48' or
                                                                                 @id='22' or
                                                                                 @id='1151' or
                                                                                 @id='200' or
                                                                                 @id='541' or
                                                                                 @id='202' or
                                                                                 @id='231' or
                                                                                 @id='107'
                                                                                 )]" />
<!-- OrderQtyData Component -->
<xsl:template match="fixr:components/fixr:component[@id='1011']/fixr:fieldRef[not(@id='38')]" />
<!-- NB 152 would be appropriate for Spread Bet, 38 for CFD - see FIX ROE  -->                                                   

<xsl:template match="fixr:components/fixr:component[@id='1003']/fixr:groupRef[not(@id='2071')]" />
<xsl:template match="fixr:components/fixr:component[@id='1003']/fixr:componentRef[not(@id='99999')]" />

<xsl:template match="fixr:message/fixr:structure/fixr:groupRef[not(@id='2066' or
                                                                   @id='1073')]" />

<!-- exclude UndInstrmtGrp from ExecRpt -->
<xsl:template match="fixr:message[@msgType='8']/fixr:structure/fixr:groupRef[not(@id='1073')]"/>

<xsl:template match="fixr:message[@msgType='8']/fixr:structure/fixr:fieldRef[not(@id='37' or
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
                                                                                 @id='1385' or
                                                                                 @id='1080' or
                                                                                 @id='1081')]"/>

</xsl:stylesheet>

