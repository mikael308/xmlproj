<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>



	<xsl:template name="tRoot" match="/tvguide">
		<html>
			<head>
				<title>TV-guide</title>
				<link rel="stylesheet" type="text/css" href="./css/main.css" />
			</head>
			<body>
				<xsl:call-template name="tHeader" 	/>
				<xsl:call-template name="tMain" 		/>
				<xsl:call-template name="tFooter" 	/>
			</body>

		</html>
	</xsl:template> <!-- tRoot -->



	<xsl:template name="tHeader">
		<header>
			<h1>TV-guide</h1>

			<div class="date">
				<xsl:value-of select="date/@year" />-<xsl:value-of select="date/@month" />-<xsl:value-of select="date/@day" />
			</div>
			<div class="date">
				<xsl:value-of select="date[last()]/@year" />-<xsl:value-of select="date[last()]/@month" />-<xsl:value-of select="date[last()]/@day" />
			</div>
			<hr />
		</header>
	</xsl:template>

	<xsl:template name="tMain" >
		<main>
			<xsl:for-each select="date">
				<xsl:call-template name="tArticle" />
			</xsl:for-each>
			
		</main>
	</xsl:template>

	<xsl:template name="tFooter">
		<footer>
			<hr />
			<p>&#169; mikael holmbom</p>
			<p>Mittuniversitet HT2015</p>
		</footer>
	</xsl:template>





	<xsl:template name="tArticle">
		<article>
			<div class="article-header">
				<h2><xsl:value-of select="@year" />-<xsl:value-of select="@month" />-<xsl:value-of select="@day" /></h2>
			</div>
			<div class="article-content">
				<xsl:apply-templates />
			</div>
			
		</article>
	</xsl:template> <!-- tArticle -->


	<xsl:template name="tChannel" match="channel">
		<div class="channel">
			<div class="channel-header">
				<img src="{@logo-src}" width="50" height="50">channellogo</img>

			</div>
			<div class="channel-content">
				<xsl:apply-templates />
			</div>

		</div>
	</xsl:template> <!-- tChannel -->


	<xsl:template name="tProgramme" match="programme">
		<fieldset class="programme">
			
			<legend>

				<div class="timespan">
					<xsl:value-of select="substring(@starttime, 9, 2)" />:<xsl:value-of select="substring(@starttime, 11, 2)" /> - <xsl:value-of select="substring(@stoptime, 9, 2)" />:<xsl:value-of select="substring(@stoptime, 11, 2)" />
				</div>
			</legend>

			<div class="programme-header">
				<div class="title"><xsl:value-of select="title" /></div>
				<xsl:if test="prod-date">
					<div class="prod-date">(<xsl:value-of select="prod-date" />)</div>
				</xsl:if>
				<xsl:if test="previously-shown">
					<div class="after-title"> (repris)</div>
				</xsl:if>
				<xsl:if test="premiere">
					<div class="after-title"><xsl:value-of select="premiere" /></div>
				</xsl:if>
				<xsl:if test="sub-title">
					<div class="sub-title"><xsl:value-of select="sub-title" /></div>
				</xsl:if>
			</div>

			<div class="programme-content">
				<xsl:if test="star-rating">
					<div class="rating">rating: <xsl:value-of select="star-rating" /></div>
				</xsl:if>
				<xsl:for-each select="category">
					<div class="category"><xsl:value-of select="." /> </div>
				</xsl:for-each>
				<div class="desc"><xsl:value-of select="desc" /></div>
				<xsl:call-template name="tCredits" />
			</div>
		
		</fieldset>
	</xsl:template> <!-- tProgramme -->



	<xsl:template name="tCredits" match="credits" >
		<div class="credits">
			<xsl:if test="credits/director">
				<div class="credit-section" >
					<div class="creditlabel">director:</div>
					<xsl:for-each select="credits/director">
						<div class="creditee {name(.)}"><xsl:value-of select="." /></div>
					</xsl:for-each>
				</div>
			</xsl:if>

			<xsl:if test="credits/writer">
				<div class="credit-section" >
					<div class="creditlabel">writer:</div>
					<xsl:for-each select="credits/writer">
						<div class="creditee {name(.)}"><xsl:value-of select="." /></div>
					</xsl:for-each>
				</div>
			</xsl:if>

			<xsl:if test="credits/actor">
				<div class="credit-section" >
						<div class="creditlabel">starring:</div>
					<xsl:for-each select="credits/actor">
						<div class="creditee {name(.)}"><xsl:value-of select="." /></div>
					</xsl:for-each>
				</div>
			</xsl:if>

		</div>
	</xsl:template> <!-- tCredits -->



</xsl:stylesheet>
