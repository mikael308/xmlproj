(: 
	author Mikael Holmbom
	version 1.0 

	translates tvguide.xml to html format

:)

xquery version "3.0";


(: returns every creditee of type param credit-type from param credits :)
declare function local:getCreditees($credits, $credit-type)
{
	for $creditee in $credits/*
	where $creditee/name() = $credit-type
	return <div class="creditee {$credit-type}">{$creditee}</div>

};

(: returns every creditsection of type param creidit-type from param credits :)
declare function local:getCreditSections($credits, $credit-type)
{
	if ($credits/*/name() = $credit-type)
	then <div class="credit-section">
			<div class="creditlabel">{$credit-type}:</div>
			{local:getCreditees($credits, $credit-type)}
		</div> 
	else ()

};

(:  returns every credits of param credits :)
declare function local:getCredits($credits)
{
	local:getCreditSections($credits, "director"),
	local:getCreditSections($credits, "writer"),
	local:getCreditSections($credits, "actor")
};

(: returns every programme of param channel :)
declare function local:getProgrammes($channel)
{
	for $programme in $channel/programme
	return <fieldset class="programme">
		<legend>
			<div class="timespan">
				{substring(data($programme/@starttime), 1, 2)}:{substring(data($programme/@starttime), 3, 2)}
			</div>
		</legend>
		<div class="programme-header">
			<div class="header-topline">
				<div class="title">{data($programme/title)}</div>
				{
					if ($programme/prod-date)
					then <div class="prod-date">({data($programme/prod-date)})</div>
					else (),

					if ($programme/previously-shown)
					then <div class="after-title">(repris)</div>
					else (),

					if ($programme/premiere)
					then <div class="after-title">{data($programme/premiere)}</div>
					else ()
				}

				<div class="sub-title">{data($programme/sub-title)}</div>
				<hr />
			</div>
		</div>
		<div class="programme-content">
			{
				if ($programme/star-rating)
				then <div class="rating">{data($programme/star-rating)}</div>
				else (),

				for $cat in $programme/category
				return <div class="category">
					{data($cat)}
				</div>,

				if ($programme/desc)
				then <div class="desc">{data($programme/desc)}</div>
				else (),

				if ($programme/credits)
				then {local:getCredits($programme/credits)}
				else ()

			}

		</div>
	</fieldset>
};

(: returns every channel of param date :)
declare function local:getChannels($date)
{
	for $channel in $date/channel
	return <div class="channel">
		<div class="channel-header">
			<img width="50" height="50" src="{data($channel/@logo-src)}"></img>
		</div>
		<div class="div-content">
			{local:getProgrammes($channel)}
		</div>
	</div>

};

(: root of html page :)
declare function local:toHTML($tvguide)
{
	<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link rel="stylesheet" type="text/css" href="./css/main.css" />
	</head>
	<body>
		<header>
			{
				<div class="tvguide-logo">
					<img src="{data($tvguide/info/logo/@src)}"></img>
				</div>
			}
			<h1>TV-guide</h1>
			{data($tvguide/date[1]/@year)}-{data($tvguide/date[1]/@month)}-{data($tvguide/date[1]/@day)}
<br/>
			{data($tvguide/date[last()]/@year)}-{data($tvguide/date[last()]/@month)}-{data($tvguide/date[last()]/@day)}
			<hr />
		</header>
		<main>
			{
				for $date in $tvguide/date
				order by $date/year
				order by $date/month
				order by $date/day
				return <article>
					<div class="article-header">
						<h2>{data($date/@year)}-{data($date/@month)}-{data($date/@day)}</h2>
					</div>
					<div class="article-content">
						{local:getChannels($date)}
					</div>
				</article>

			}

		</main>
		<footer>
			<hr/>
			<p>&#169; mikael holmbom</p>
			<p>Mittuniversitetet</p>
		</footer>
	</body>
	</html>
	
};



let $tvguide := doc("tvguide.xml")/tvguide
	return local:toHTML($tvguide)
