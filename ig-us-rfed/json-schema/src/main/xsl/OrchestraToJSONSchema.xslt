<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:fn="http://www.w3.org/2005/xpath-functions" 
	xmlns:fixr="http://fixprotocol.io/2020/orchestra/repository"
	xmlns:dcterms="http://purl.org/dc/terms/" exclude-result-prefixes="fn">
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="debug">false</xsl:param>
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
		<xsl:if test="$debug='true'">
		    <xsl:message>
	processing fixr:component  <xsl:value-of select="@name"/>
		    </xsl:message>
	    </xsl:if>
	    <!-- components are normalised, written to a distinct file,  if the flag is set to 'true'  -->
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
    <!--  groups are always normalised -->
	<xsl:template match="fixr:group">		<xsl:variable name="filename" select="fn:concat($targetDirectory, $forwardSlash, $groupsDirectory, $forwardSlash, @name, '.json')"/>
		<xsl:result-document method="text" href="{$filename}">
		<xsl:if test="$debug='true'">
			<xsl:message>
	processing fixr:group  <xsl:value-of select="@name"/>
	    	</xsl:message>
	    </xsl:if>
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
	<!-- a file is written for each message -->
	<xsl:template match="fixr:messages">
		<xsl:apply-templates/>	
	</xsl:template>
	<xsl:template match="fixr:message">
		<xsl:variable name="filename" select="fn:concat($targetDirectory, $forwardSlash, $messagesDirectory, $forwardSlash, @name, @scenario, '.json')"/>
		<xsl:result-document method="text" href="{$filename}">
		<xsl:if test="$debug='true'">
			<xsl:message>
processing fixr:message  <xsl:value-of select="@name"/>
	    	</xsl:message>
	    </xsl:if>
		
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
<xsl:apply-templates select="fixr:structure/fixr:componentRef[@presence='required']|fixr:structure/fixr:fieldRef[@presence='required']|fixr:structure/fixr:groupRef[@presence='required']" mode="required"/>
	]
}
		</xsl:result-document>
	</xsl:template>
	<!-- field refs result in references to distinct files or are an inline definition of the field -->
	<xsl:template match="fixr:fieldRef" mode="properties">
		<xsl:variable name="fieldId" select="@id"/>
		<xsl:variable name="fieldName" select="/fixr:repository/fixr:fields/fixr:field[@id=$fieldId]/@name"/>
		<xsl:variable name="fieldType" select="/fixr:repository/fixr:fields/fixr:field[@id=$fieldId]/@type"/>
	    <xsl:if test="$debug='true'">
	    	<xsl:message>
		processing fixr:fieldRef  <xsl:value-of select="$fieldName"/>
	    	</xsl:message>
	    </xsl:if>	

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
    <!-- the "required" mode is to list in the schema fields that are required according to the orchestration -->
	<xsl:template match="fixr:fieldRef" mode="required">
		<xsl:variable name="theId" select="@id"/>
		<!-- test for first position not last due to case in which required components may not have any required fields (and be the last thing in selection ) -->
		<xsl:if test="fn:position() != 1">,</xsl:if>"<xsl:value-of select="/fixr:repository/fixr:fields/fixr:field[@id=$theId]/@name"/>"
	</xsl:template>
	<xsl:template match="fixr:groupRef" mode="properties">
		<xsl:variable name="theId" select="@id"/>
		<xsl:variable name="theName" select="/fixr:repository/fixr:groups/fixr:group[@id=$theId]/@name"/>
	    <xsl:if test="$debug='true'">
	    	<xsl:message>
		processing group ref  <xsl:value-of select="$theId"/> <xsl:value-of select="$theName"/>
	    	</xsl:message>
	    </xsl:if>
		"<xsl:value-of select="$theName"/>" : {"$ref": "../<xsl:value-of select="$groupsDirectory"/>/<xsl:value-of select="$theName"/>.json"}<xsl:if test="fn:position() != fn:last()">, </xsl:if>
	    <xsl:if test="$debug='true'">
	    	<xsl:message>
		end processing group ref  <xsl:value-of select="$theId"/> <xsl:value-of select="$theName"/>
	    	</xsl:message>
	    </xsl:if>	
	</xsl:template>
	<!-- the "required" mode is to list in the schema groups that are required according to the orchestration -->
	<xsl:template match="fixr:groupRef" mode="required">
		<xsl:variable name="theId" select="@id"/>
		<!-- test for first position not last due to case in which required components may not have any required fields (and be the last thing in selection ) -->
		<xsl:if test="fn:position() != 1">,</xsl:if>"<xsl:value-of select="/fixr:repository/fixr:groups/fixr:group[@id=$theId]/@name"/>"
	</xsl:template>
	<!-- components are defined in discrete files if "$normaliseComponents='true'" -->
	<xsl:template match="fixr:componentRef" mode="properties">
		<xsl:variable name="theId" select="@id"/>
		<xsl:variable name="theName" select="/fixr:repository/fixr:components/fixr:component[@id=$theId]/@name"/>
	    <xsl:if test="$debug='true'">
	    	<xsl:message>
		processing component ref  <xsl:value-of select="$theId"/> <xsl:value-of select="$theName"/>
	    	</xsl:message>
	    </xsl:if>
		<xsl:choose>
			<xsl:when test="$normaliseComponents='true'">
		"<xsl:value-of select="$theName"/>" : {"$ref": "../<xsl:value-of select="$componentsDirectory"/>/<xsl:value-of select="$theName"/>.json"}<xsl:if test="fn:position() != fn:last()">, </xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="/fixr:repository/fixr:components/fixr:component[@id=$theId]/(fixr:fieldRef|fixr:groupRef|fixr:componentRef)" mode="properties"/><xsl:if test="fn:position() != fn:last()">, </xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	    <xsl:if test="$debug='true'">
		    <xsl:message>
		end processing component ref  <xsl:value-of select="$theId"/> <xsl:value-of select="$theName"/>
		    </xsl:message>
		</xsl:if>
	</xsl:template>
	<!-- the "required" mode is to list in the schema component that are required according to the orchestration, 
	     this cannot be described where the components are normalised -->
	<xsl:template match="fixr:componentRef" mode="required">
		<xsl:variable name="theId" select="@id"/>
        <xsl:variable name="theName" select="/fixr:repository/fixr:components/fixr:component[@id=$theId]/@name"/>
		<xsl:choose>
			<xsl:when test="$normaliseComponents='true'">
		"<xsl:value-of select="/fixr:repository/fixr:components/fixr:component[@id=$theId]/@name"/>"<xsl:if test="fn:position() != fn:last()">, </xsl:if>
			</xsl:when>
			<xsl:otherwise>
			<xsl:if test="$debug='true'">
		    <xsl:message>
		in required processing component ref  <xsl:value-of select="$theId"/> <xsl:value-of select="$theName"/>
		    </xsl:message>
		</xsl:if>
				<xsl:if test="/fixr:repository/fixr:components/fixr:component[@id=$theId]/(fixr:fieldRef[@presence='required']|fixr:groupRef[@presence='required']|fixr:componentRef[@presence='required'])" >
         <xsl:if test="fn:position() != 1">,</xsl:if><xsl:apply-templates select="/fixr:repository/fixr:components/fixr:component[@id=$theId]/(fixr:fieldRef[@presence='required']|fixr:groupRef[@presence='required']|fixr:componentRef[@presence='required'])" mode="required"/>	
		        </xsl:if>
		        <xsl:if test="$debug='true'">
				    <xsl:message>
		in required end processing component ref  <xsl:value-of select="$theId"/> <xsl:value-of select="$theName"/>
				    </xsl:message>
					<xsl:if test="fn:position() = fn:last()">
						<xsl:message>in required, this was last</xsl:message>
					</xsl:if>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- datatypes are mapped to the json schema types -->
	<xsl:template name="datatype">
		<xsl:param name="id"/>
		<xsl:variable name="fieldType" select="/fixr:repository/fixr:fields/fixr:field[@id=$id]/@type"/>
		<xsl:variable name="codesetType" select="/fixr:repository/fixr:codeSets/fixr:codeSet[@name=$fieldType]/@type"/>
		<xsl:variable name="type" select="$codesetType|$fieldType"/>
		<xsl:apply-templates select="/fixr:repository/fixr:datatypes/fixr:datatype[@name=$type]/fixr:mappedDatatype[@standard='JSON']/@*"/> 
	</xsl:template>
	<xsl:template match="@base">
			<!-- if the schema is intended to by used for a java binding via jsonschematopojo the Java Type can be specified
			     BigDecimal is used for number -->
			<xsl:if test="fn:current()='number' and $javaPackageName">"existingJavaType" : "java.math.BigDecimal",</xsl:if>
			"type": "<xsl:value-of select="fn:current()"/>"
	</xsl:template>
	<xsl:template match="@parameter">,
			<!-- if parameter contains "format":"date-time" then map the java type to java LocalDateTime, this is flawed as it can also be zoned time for FIX datatype TZTimestamp -->
<!-- 			<xsl:if test="fn:current()='&quot;format&quot;: &quot;date-time&quot;' and $javaPackageName">"existingJavaType" : "java.time.LocalDateTime",</xsl:if> -->
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
	<!-- enum template is used for codesets  -->
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
