<cfsetting enablecfoutputonly="true">

<cfset emailInlineImages = {} />
<cfset emailInlineImages.version = "0.2" />

<cfparam name="PARAMS.page" default="intro" />

<cfinclude template="views/#PARAMS.page#.cfm">


<cfsetting enablecfoutputonly="false">