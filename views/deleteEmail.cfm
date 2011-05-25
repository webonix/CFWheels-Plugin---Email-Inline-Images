
<cfdirectory action="list" name="qrySpool" directory="#ExpandPath('/plugins/emailinlineimages/spool')#" filter="#PARAMS.spool#.*">
<cfloop query="qrySpool">
	<cffile action="delete" file="#qrySpool.directory#\#qrySpool.name#"  />
</cfloop>

<cfoutput>#redirectTo(params='view=#params.view#&name=#params.name#&page=viewEmails')#</cfoutput>