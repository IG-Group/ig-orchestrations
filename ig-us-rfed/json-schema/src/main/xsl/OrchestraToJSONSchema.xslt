<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:fn="http://www.w3.org/2005/xpath-functions" 
	xmlns:fixr="http://fixprotocol.io/2016/fixrepository"
	xmlns:dcterms="http://purl.org/dc/terms/" exclude-result-prefixes="fn">
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="targetDirectory">target/generated-resources/definitions</xsl:param>
	<xsl:param name="javaPackageName"></xsl:param>
	<xsl:param name="useCodeNameForEnum">true</xsl:param>
	<xsl:param name="normaliseComponents">false</xsl:param>
	<xsl:variable name="forwardSlash">/</xsl:variable>
	<xsl:variable name="fieldsDirectory">fields</xsl:variable>
	<xsl:variable name="componentsDirectory">components</xsl:variable>
	<xsl:variable name="groupsDirectory">groups</xsl:variable>
	<xsl:variable name="messagesDirectory">messages</xsl:variable>
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="fixr:repository">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="fixr:protocol">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="fixr:components">
		<xsl:apply-templates/>	
	</xsl:template>
	<xsl:template match="fixr:fields">
		<xsl:apply-templates/>	
	</xsl:template>	
	<xsl:template match="fixr:field">
        <xsl:variable name="fieldType" select="@type"/>
        <!-- test if the field type is a code set, if so output an object for the enum -->
		<xsl:if test="/fixr:repository/fixr:codeSets/fixr:codeSet[@name=$fieldType]">
			<xsl:variable name="filename" select="fn:concat($targetDirectory, $forwardSlash, $fieldsDirectory, $forwardSlash, @name, '.json')"/>
			<xsl:result-document method="text" href="{$filename}">
			<xsl:variable name="codesetType" select="/fixr:repository/fixr:codeSets/fixr:codeSet[@name=$fieldType]/@type"/>
{ 
	"title"                : "<xsl:value-of select="@name"/>",
	"description"          : "JSON Schema for field <xsl:value-of select="@name"/>",
	<xsl:if test="$javaPackageName">
	"javaType" : "<xsl:value-of select="$javaPackageName"/>.<xsl:value-of select="$fieldsDirectory"/>.<xsl:value-of select="@name"/>",
	</xsl:if>
	<xsl:choose>
		<xsl:when test="$useCodeNameForEnum='true'">
			"type": "string"
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates select="/fixr:repository/fixr:datatypes/fixr:datatype[@name=$codesetType]/fixr:mappedDatatype[@standard='JSON']/@*"/> 
		</xsl:otherwise>
	</xsl:choose>
    <xsl:call-template name="enum"><xsl:with-param name="id" select="@id"/></xsl:call-template>
}
			</xsl:result-document>
		</xsl:if>		
	</xsl:template>	
	<xsl:template match="fixr:component">
		<xsl:if test="$normaliseComponents='true'">
			<xsl:variable name="filename" select="fn:concat($targetDirectory, $forwardSlash, $componentsDirectory, $forwardSlash, @name, '.json')"/>
			<xsl:result-document method="text" href="{$filename}">
{ 
	"title"                : "<xsl:value-of select="@name"/>",
	"description"          : "JSON Schema for component <xsl:value-of select="@name"/>",
	<xsl:if test="$javaPackageName">
	"javaType" : "<xsl:value-of select="$javaPackageName"/>.<xsl:value-of select="$componentsDirectory"/>.<xsl:value-of select="@name"/>",
	</xsl:if>
	"type"                 : "object",
	"properties"           : {
		<xsl:apply-templates select="fixr:fieldRef|fixr:groupRef|fixr:componentRef" mode="properties"/>
	},
	"required"             : [ 
		<xsl:apply-templates select="fixr:fieldRef[@presence='required']|fixr:groupRef[@presence='required']|fixr:componentRef[@presence='required']" mode="required"/>
	]
}
			</xsl:result-document>
		</xsl:if>
	</xsl:template>
	<xsl:template match="fixr:group">		<xsl:variable name="filename" select="fn:concat($targetDirectory, $forwardSlash, $groupsDirectory, $forwardSlash, @name, '.json')"/>
		<xsl:result-document method="text" href="{$filename}">
{ 
	"title"                : "<xsl:value-of select="@name"/>",
	"description"          : "JSON Schema for repeating group <xsl:value-of select="@name"/>",
	"type"                 : "array",
	"items"                : {
	    <xsl:if test="$javaPackageName">
        "javaType" : "<xsl:value-of select="$javaPackageName"/>.<xsl:value-of select="$groupsDirectory"/>.<xsl:value-of select="@name"/>",
	    </xsl:if>
		"type": "object",
		<xsl:apply-templates select="@*"/>
		"properties": {
			<xsl:apply-templates select="fixr:fieldRef|fixr:groupRef|fixr:componentRef" mode="properties"/>
		},
		"required"             : [ 
		<xsl:apply-templates select="fixr:fieldRef[@presence='required']|fixr:groupRef[@presence='required']|fixr:componentRef[@presence='required']" mode="required"/>
		]
	}
}
		</xsl:result-document>
	</xsl:template>
	<xsl:template match="fixr:messages">
		<xsl:apply-templates/>	
	</xsl:template>
	<xsl:template match="fixr:message">
		<xsl:variable name="filename" select="fn:concat($targetDirectory, $forwardSlash, $messagesDirectory, $forwardSlash, @name, @scenario, '.json')"/>
		<xsl:result-document method="text" href="{$filename}">
{ 
	"$schema"              : "http://json-schema.org/draft-04/schema#",
	"title"                : "<xsl:value-of select="@name"/>",
	"description"          : "JSON Schema for message <xsl:value-of select="@name"/>",
	<xsl:if test="$javaPackageName">
	"javaType" : "<xsl:value-of select="$javaPackageName"/>.<xsl:value-of select="$messagesDirectory"/>.<xsl:value-of select="@name"/>",
	</xsl:if>
	
	"type"                 : "object",
	"properties"           : {
			<xsl:apply-templates select="fixr:structure/fixr:fieldRef|fixr:structure/fixr:groupRef|fixr:structure/fixr:componentRef" mode="properties"/>
	},
	"required"             : [ 
			<xsl:apply-templates select="fixr:structure/fixr:componentRef[@presence='required']" mode="required"/>
			<xsl:apply-templates select="fixr:structure/fixr:fieldRef[@presence='required']|fixr:structure/fixr:groupRef[@presence='required']" mode="required"/>
	]
}
		</xsl:result-document>
	</xsl:template>
	<xsl:template match="fixr:fieldRef" mode="properties">
		<xsl:variable name="fieldId" select="@id"/>
		<xsl:variable name="fieldName" select="/fixr:repository/fixr:fields/fixr:field[@id=$fieldId]/@name"/>
		<xsl:variable name="fieldType" select="/fixr:repository/fixr:fields/fixr:field[@id=$fieldId]/@type"/>
		"<xsl:value-of select="$fieldName"/>": {  
		<xsl:choose>
			<xsl:when test="/fixr:repository/fixr:codeSets/fixr:codeSet[@name=$fieldType]">
			"$ref": "../<xsl:value-of select="$fieldsDirectory"/>/<xsl:value-of select="$fieldName"/>.json"
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="datatype"><xsl:with-param name="id" select="@id"/></xsl:call-template>
				<xsl:apply-templates select="@*"/>
			</xsl:otherwise>
		</xsl:choose>
		}<xsl:if test="fn:position() != fn:last()">, </xsl:if>
	</xsl:template>

	<xsl:template match="fixr:fieldRef" mode="required">
		<xsl:variable name="theId" select="@id"/>
		"<xsl:value-of select="/fixr:repository/fixr:fields/fixr:field[@id=$theId]/@name"/>"<xsl:if test="fn:position() != fn:last()">, </xsl:if>
	</xsl:template>
	<xsl:template match="fixr:groupRef" mode="required">
		<xsl:variable name="theId" select="@id"/>
		"<xsl:value-of select="/fixr:repository/fixr:groups/fixr:group[@id=$theId]/@name"/>"<xsl:if test="fn:position() != fn:last()">, </xsl:if>
	</xsl:template>
	<xsl:template match="fixr:groupRef" mode="properties">
		<xsl:variable name="theId" select="@id"/>
		<xsl:variable name="theName" select="/fixr:repository/fixr:groups/fixr:group[@id=$theId]/@name"/>
		"<xsl:value-of select="$theName"/>" : {"$ref": "../<xsl:value-of select="$groupsDirectory"/>/<xsl:value-of select="$theName"/>.json"}<xsl:if test="fn:position() != fn:last()">, </xsl:if>
	</xsl:template>
	<xsl:template match="fixr:componentRef" mode="properties">
		<xsl:variable name="theId" select="@id"/>
		<xsl:variable name="theName" select="/fixr:repository/fixr:components/fixr:component[@id=$theId]/@name"/>
		<xsl:choose>
			<xsl:when test="$normaliseComponents='true'">
		"<xsl:value-of select="$theName"/>" : {"$ref": "../<xsl:value-of select="$componentsDirectory"/>/<xsl:value-of select="$theName"/>.json"}<xsl:if test="fn:position() != fn:last()">, </xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="/fixr:repository/fixr:components/fixr:component[@id=$theId]/fixr:fieldRef|fixr:groupRef|fixr:componentRef" mode="properties"/><xsl:if test="fn:position() != fn:last()">, </xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="fixr:componentRef" mode="required">
		<xsl:variable name="theId" select="@id"/>
		<xsl:choose>
			<xsl:when test="$normaliseComponents='true'">
		"<xsl:value-of select="/fixr:repository/fixr:components/fixr:component[@id=$theId]/@name"/>"<xsl:if test="fn:position() != fn:last()">, </xsl:if>
			</xsl:when>
			<xsl:otherwise>
         <xsl:apply-templates select="/fixr:repository/fixr:components/fixr:component[@id=$theId]/fixr:fieldRef[@presence='required']|fixr:groupRef[@presence='required']|fixr:componentRef[@presence='required']" mode="required"/><xsl:if test="fn:position() != fn:last()">, </xsl:if>			
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="datatype">
		<xsl:param name="id"/>
		<xsl:variable name="fieldType" select="/fixr:repository/fixr:fields/fixr:field[@id=$id]/@type"/>
		<xsl:variable name="codesetType" select="/fixr:repository/fixr:codeSets/fixr:codeSet[@name=$fieldType]/@type"/>
		<xsl:variable name="type" select="$codesetType|$fieldType"/>
		<xsl:apply-templates select="/fixr:repository/fixr:datatypes/fixr:datatype[@name=$type]/fixr:mappedDatatype[@standard='JSON']/@*"/> 
	</xsl:template>
	<xsl:template match="@base">
			"type": "<xsl:value-of select="fn:current()"/>"
	</xsl:template>
	<xsl:template match="@parameter">,
			<xsl:value-of select="fn:current()"/>
	</xsl:template>
	<xsl:template match="@minInclusive">,
			"minimum": <xsl:value-of select="fn:current()"/>
	</xsl:template>
	<xsl:template match="@maxInclusive">,
			"maximum": <xsl:value-of select="fn:current()"/>
	</xsl:template>
	<xsl:template match="@implMinLength">,
			"minLength": <xsl:value-of select="fn:current()"/>
	</xsl:template>
	<xsl:template match="@implMaxLength">,
			"maxLength": <xsl:value-of select="fn:current()"/>
	</xsl:template>
	<xsl:template match="@implMinOccurs">
			"minItems": <xsl:value-of select="fn:current()"/>,
	</xsl:template>
	<xsl:template match="@implMaxOccurs">
			"maxItems": <xsl:value-of select="fn:current()"/>,
	</xsl:template>
	<xsl:template name="enum">
		<xsl:param name="id"/>
		<xsl:variable name="fieldType" select="/fixr:repository/fixr:fields/fixr:field[@id=$id]/@type"/>
		<xsl:variable name="codesetType" select="/fixr:repository/fixr:codeSets/fixr:codeSet[@name=$fieldType]/@type"/>
		<xsl:if test="/fixr:repository/fixr:codeSets/fixr:codeSet[@name=$fieldType]">,
			"enum": [
			<xsl:for-each select="/fixr:repository/fixr:codeSets/fixr:codeSet[@name=$fieldType]/fixr:code">
				<xsl:choose>
					<xsl:when test="$useCodeNameForEnum='true'">
						"<xsl:value-of select="@name"/>"
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$codesetType='int'"><xsl:value-of select="@value"/></xsl:when>
							<xsl:when test="$codesetType='NumInGroup'"><xsl:value-of select="@value"/></xsl:when>
							<xsl:otherwise>"<xsl:value-of select="@value"/>"</xsl:otherwise>
					   </xsl:choose>
				    </xsl:otherwise>
			    </xsl:choose>
		<xsl:if test="fn:position() != fn:last()">, </xsl:if>
		</xsl:for-each>
			]
		</xsl:if>
	</xsl:template>
	<xsl:template match="fixr:metadata"/>
	<xsl:template match="fixr:codeSets"/>
	<xsl:template match="fixr:abbreviations"/>
	<xsl:template match="fixr:datatypes"/>
	<xsl:template match="fixr:categories"/>
	<xsl:template match="fixr:sections"/>
	<xsl:template match="fixr:actors" mode="#all"/>
	<xsl:template match="fixr:annotation" mode="#all"/>
	<xsl:template match="fixr:responses" mode="#all"/>
	<xsl:template match="fixr:when" mode="#all"/>
	<xsl:template match="@*" mode="#all"/>
</xsl:stylesheet>
