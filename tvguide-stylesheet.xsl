<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="UTF-8" indent="yes" />


	<xsl:template name="tRoot" match="/tvguide-form" >
		<!-- add stylesheet declaration-->
		<xsl:processing-instruction name="xml-stylesheet">
				<xsl:text>type="text/xsl" href="tvguide-html.xsl"</xsl:text>
		</xsl:processing-instruction>
		

		<tvguide
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			xsi:schemaLocation="tvguide tvguide.xsd" >
			
			<xsl:for-each select="dates/date">
				<xsl:sort select="@year"   date-type="number" order="ascending" />
				<xsl:sort select="@month"  date-type="number" order="ascending" />
				<xsl:sort select="@day"    date-type="number" order="ascending" />

				<xsl:call-template name="tDate">
					<xsl:with-param name="year"   select="@year" />
					<xsl:with-param name="month"  select="@month" />
					<xsl:with-param name="day"    select="@day" />
				</xsl:call-template>

			</xsl:for-each><!-- date -->
		
		</tvguide>
	</xsl:template><!-- tRoot -->




	<xsl:template name="tDate" match="tvguide-form/dates/date">
		<xsl:param name="year"  />
		<xsl:param name="month" />
		<xsl:param name="day"   />

		<date year="{$year}" month="{$month}" day="{$day}">

			<xsl:for-each select="content">
				<xsl:variable name="contentID" select="./@id" />
				<xsl:variable name="channel" 
					select="//tvguide-form/channels/channel[@id = $contentID]" />
				<xsl:variable name="xmltvdata-path" 
					select="concat($channel/@file-src, '_', $year, '-', $month, '-', $day, '.xml')" />

				<xsl:call-template name="tChannel">
					<xsl:with-param name="xmltvdata-path" select="$xmltvdata-path" />
					<xsl:with-param name="logo-src" select="$channel/@logo-src" />
				</xsl:call-template>
			</xsl:for-each>


		</date>
	</xsl:template> <!-- tDate -->



	<xsl:template name="tChannel" >
		<xsl:param name="xmltvdata-path" />
		<xsl:param name="logo-src" />

		<xsl:variable name="xmltvdata-file" select="document($xmltvdata-path)" />

		<channel name="{$xmltvdata-file/tv/programme/@channel}" logo-src="{$logo-src}" >
			<xsl:for-each select="$xmltvdata-file/tv/programme">
				<xsl:sort select="@starttime" order="ascending" />

				<xsl:call-template name="tProgramme" />

			</xsl:for-each> <!-- programme -->

		</channel>
	
	</xsl:template><!-- tChannel -->



	<xsl:template name="tProgramme">
		<programme starttime="{@start}" stoptime="{@stop}">
	
			<xsl:if test="title">
				<title lang="{title/@lang}" ><xsl:value-of select="title"/></title>
			</xsl:if>
			<xsl:if test="sub-title">
				<sub-title lang="{sub-title/@lang}"><xsl:value-of select="sub-title" /></sub-title>
			</xsl:if>
			<xsl:if test="desc">
				<desc lang="{desc/@lang}"><xsl:value-of select="desc" /></desc>
			</xsl:if>
			<xsl:call-template name="tCredits" />
			<xsl:if test="prod-date">
				<prod-date><xsl:value-of select="prod-date" /></prod-date>
			</xsl:if>
			<xsl:if test="date">
				<prod-date><xsl:value-of select="date" /></prod-date>
			</xsl:if>
			<xsl:for-each select="category">
				<category lang="{./@lang}"><xsl:value-of select="." /></category>
			</xsl:for-each>	
			
			<xsl:for-each select="episode-num" >
				<xsl:if test="./@system = onscreen">
					<episode-num><xsl:value-of select="." /></episode-num>
				</xsl:if>
			</xsl:for-each>
			<xsl:if test="previously-shown">
				<xsl:choose>
					<xsl:when test="previously-shown/@start">
						<previously-shown start="previously-shown/@start" ><xsl:value-of select="previously-shown" /></previously-shown>
					</xsl:when>
					<xsl:otherwise>
						<previously-shown><xsl:value-of select="previously-shown" /></previously-shown>
					</xsl:otherwise>
				</xsl:choose>
				</xsl:if>
			
			<xsl:if test="star-rating">
				<star-rating><value><xsl:value-of select="star-rating/value" /></value></star-rating>
			</xsl:if>

		</programme>

	</xsl:template><!-- tProgramme -->




	<xsl:attribute-set name="attrsRole">
		<xsl:attribute name="role"><xsl:value-of select="./@role" /></xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="tCredits" >
		<xsl:if test="credits">	
			<credits>
				<xsl:for-each select="credits/director | credits/actor | credits/writer">
					<xsl:choose>
						<xsl:when test="@role" >
							<xsl:element name="{name(.)}" use-attribute-sets="attrsRole">
								<xsl:value-of select="." />
							</xsl:element>
						</xsl:when>
						<xsl:otherwise>
							<xsl:element name="{name(.)}">
								<xsl:value-of select="." />
							</xsl:element>

						</xsl:otherwise>
					</xsl:choose>

				</xsl:for-each> 
			</credits>
		</xsl:if>

	</xsl:template>



	<xsl:attribute-set name="attrsLang">
		<xsl:attribute name="lang"><xsl:value-of select="./@lang" /></xsl:attribute>
	</xsl:attribute-set>

	<xsl:template match="child::*">
		<xsl:choose>
			<xsl:when test="@lang">
				<xsl:element name="{name(.)}" use-attribute-sets="attrsLang"><xsl:value-of select="." /></xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{name(.)}"><xsl:value-of select="." /></xsl:element>

			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


</xsl:stylesheet>
