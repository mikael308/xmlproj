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
	
			<xsl:apply-templates />

		</programme>

	</xsl:template><!-- tProgramme -->





	<xsl:template  match="credits">


		<credits>
			<xsl:for-each select="./*">
				<xsl:choose>
					<xsl:when test="@role" >
						<actor role="{@role}"><xsl:value-of select="." /></actor>
						<!-- TODO hur göra när det är <actor role="blabla">marlon</actor>
-->
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



	<xsl:template match="child::*">
		<xsl:choose>
			<xsl:when test="@lang">
				<xsl:element name="{name(.)}" use-attribute-sets="[klaatu]"><xsl:value-of select="." /></xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{name(.)}"><xsl:value-of select="." /></xsl:element>

			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>


</xsl:stylesheet>