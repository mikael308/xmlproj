<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="UTF-8" indent="yes" />




	<xsl:template name="tRoot" match="/xmltv" >
		<!-- add stylesheet declaration-->
		<xsl:processing-instruction name="xml-stylesheet">
				<xsl:text>type="text/xsl" href="tvguide-html.xsl"</xsl:text>
		</xsl:processing-instruction>

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
				<xsl:variable name="xmltvdata-path" select="concat('./xmltvdata/', ., '_', $year, '-', $month, '-', $day, '.xml')" />	

				<xsl:call-template name="tChannel">
					<xsl:with-param name="xmltvdata-path" select="$xmltvdata-path" />
				</xsl:call-template> <!-- tChannel -->

			</xsl:for-each><!-- channel -->

		</date>
	</xsl:template> <!-- tDate -->



	<xsl:template name="tChannel" >
		<xsl:param name="xmltvdata-path" />

		<xsl:variable name="xmltvdata-file" select="document($xmltvdata-path)" />

		<channel name="{$xmltvdata-file/tv/programme/@channel}" logo-src="{@logo-src}" >
			<xsl:for-each select="$xmltvdata-file/tv/programme">
				<xsl:sort select="@starttime" order="ascending" />

				<xsl:call-template name="tProgramme" />

			</xsl:for-each> <!-- programme -->

		</channel>
	
	</xsl:template><!-- tChannel -->



	<xsl:template name="tProgramme">
		<programme starttime="{@start}" stoptime="{@stop}">
	
			<xsl:apply-templates />

		</programme>

	</xsl:template><!-- tProgramme -->




	<xsl:attribute-set name="attrsRole">
		<xsl:attribute name="role"><xsl:value-of select="./@role" /></xsl:attribute>
	</xsl:attribute-set>

	<xsl:template  match="credits">

		<credits>
			<xsl:for-each select="./*">
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
