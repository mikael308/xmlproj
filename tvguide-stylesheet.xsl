<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="UTF-8" indent="yes" />

	<xsl:template name="tRoot" match="/xmltv" >
		<tvguide>
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






	<xsl:template name="tDate">
		<xsl:variable name="year"   select="@year" />
		<xsl:variable name="month"  select="@month" />
		<xsl:variable name="day"    select="@day" />

		<date year="{$year}" month="{$month}" day="{$day}">

			<xsl:for-each select="//xmltv/channels/channel">
				<xsl:variable name="xmltvdata-file" select="concat('./xmltvdata/', ., '_', $year, '-', $month, '-', $day, '.xml')" />	

				<xsl:call-template name="tChannel">
					<xsl:with-param name="xmltvdata-file" select="document($xmltvdata-file)" />
				</xsl:call-template> <!-- tChannel -->

			</xsl:for-each><!-- channel -->

		</date>
	</xsl:template> <!-- tDate -->

	<xsl:template name="tChannel" >
		<xsl:param name="xmltvdata-file" />

		<channel name="{($xmltvdata-file)/tv/programme/@channel}" logo-src="{@logo-src}" >
			<xsl:for-each select="$xmltvdata-file/tv/programme">
				<xsl:sort select="@starttime" order="ascending" />

				<xsl:call-template name="tProgramme" />

			</xsl:for-each> <!-- programme -->

		</channel>
	</xsl:template><!-- tChannel -->



	<xsl:template name="tProgramme">
		<programme starttime="{@start}" stoptime="{@stop}">
			<xsl:for-each select="category">
				<category lang="{@lang}"><xsl:value-of select="." /></category>

			</xsl:for-each>
			<xsl:if test="url">
				<url><xsl:value-of select="url" /></url>
			</xsl:if>
			<xsl:if test="date">
				<prod-date><xsl:value-of select="date" /></prod-date>
			</xsl:if>
			<xsl:if test="video">
				<video>
					<xsl:if test="video/quality">
						<quality><xsl:value-of select="video/quality" /></quality>
					</xsl:if>
					<xsl:if test="aspect">
						<aspect><xsl:value-of select="aspect" /></aspect>
					</xsl:if>
				</video>
			</xsl:if> <!-- video -->
			<xsl:if test="title">
				<xsl:choose>
					<xsl:when test="@lang">
						<title lang="{@lang}"><xsl:value-of select="." /></title>
					</xsl:when>
					<xsl:otherwise>
						<title><xsl:value-of select="." /></title>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:for-each select="sub-title">
				<sub-title><xsl:value-of select="sub-title" /></sub-title>
			</xsl:for-each>
			<xsl:for-each select="episode-num">
				<xsl:if test="@system = 'onscreen'">
					<episode-num><xsl:value-of select="." /></episode-num>
					
				</xsl:if>
			</xsl:for-each>
			<desc>
				<xsl:value-of select="desc" />
			</desc>

			<xsl:call-template name="tCredits" />

			<xsl:if test="country">
				<country><xsl:value-of select="country" /></country>
			</xsl:if>
			<xsl:if test="language">
				<language><xsl:value-of select="language" /></language>
			</xsl:if>
			<xsl:if test="orig-language">
				<language><xsl:value-of select="orig-language" /></language>
			</xsl:if>

			<xsl:if test="rating">
				<rating system="{rating/@system}">
					<value><xsl:value-of select="rating/value" /></value>
					<icon src="rating/icon/@src" />
				</rating>	
			</xsl:if> <!-- rating -->
			<xsl:if test="star-rating">
				<star-rating><xsl:value-of select="star-rating" /></star-rating>
			</xsl:if>
			

		</programme>
	</xsl:template><!-- tProgramme -->



	<xsl:template name="tCredits">
		<xsl:if test="credits">
			<credits>
				<xsl:for-each select="credits/*">
					<xsl:choose>
						<xsl:when test="@role" >
							<actor role="{@role}"><xsl:value-of select="." /></actor>
						</xsl:when>
						<xsl:otherwise>
							<xsl:element name="{name(.)}">
								<xsl:value-of select="." />
							</xsl:element>

						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each> <!-- credits child -->
			</credits>
		</xsl:if> <!-- credits -->

	</xsl:template>


</xsl:stylesheet>