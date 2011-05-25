<h1>Delete All Emails</h1>

<cfdirectory action="list" name="qrySpool" directory="#ExpandPath('/plugins/emailinlineimages/spool')#">
<cfloop query="qrySpool">
	<cffile action="delete" file="#qrySpool.directory#\#qrySpool.name#"  />
</cfloop>

<cfoutput>[#LinkTo(text='Home', href='/')#]</cfoutput>
