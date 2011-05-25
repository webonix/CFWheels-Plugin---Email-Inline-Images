<h1>View Email</h1>

<cfoutput>
	[
	#LinkTo(text="Delete", params='view=#params.view#&name=#params.name#&page=deleteEmail&spool=#PARAMS.spool#')# |
	#LinkTo(text="Send", params='view=#params.view#&name=#params.name#&page=sendEmail&spool=#PARAMS.spool#')# |
	#LinkTo(text="Back", params='view=#params.view#&name=#params.name#&page=viewEmails')#
	]
<br /><br />
</cfoutput>


<cffile action="read" file="#ExpandPath('/plugins/emailinlineimages/spool')#\#PARAMS.spool#.cfmail" variable="email" />

<cfset stEmail = StructNew() />
<cfset stEmail['body'] = '' />
<cfset fileCount = 0 />

<cfloop list="#email#" delimiters="#chr(13)#" index="line">
	<cfif Trim(line) NEQ "">
	<!--- <cfoutput>#htmlEditFormat(line)#<br /></cfoutput> --->
		<cfif FindNoCase('body:  ', line)>
			<cfset stEmail['body'] = stEmail['body'] & ReplaceNoCase(line, 'body:  ', '') />
		<cfelseif mid(line,2,4) EQ 'file'>
			<!--- <cfoutput>#htmlEditFormat(line)#<br /></cfoutput> --->
			<cfif mid(line,2,6) EQ 'file: '>
				<cfset fileCount= fileCount + 1 />
				<cfset stEmail["file#fileCount#"] = StructNew() />
			</cfif>
			<cfset stEmail["file#fileCount#"][Trim(ListFirst(line,':'))] = Replace(line, "#ListFirst(line,':')#: ", '') />
		<cfelse>
			<cfset stEmail[Trim(ListFirst(line,':'))] = Replace(line, "#ListFirst(line,':')#: ", '') />
		</cfif>
	</cfif>	
</cfloop>

<cfloop from="1" to="#fileCount#" index="fileNo">
	<cfset stEmail["file#fileNo#"]['src'] = Replace(stEmail["file#fileNo#"]['file'],ExpandPath('/'), '/') />
	<cfset stEmail["file#fileNo#"]['file-id'] = Replace(stEmail["file#fileNo#"]['file-id'], '<', 'cid:') />
	<cfset stEmail["file#fileNo#"]['file-id'] = Replace(stEmail["file#fileNo#"]['file-id'], '>', '') />
	<cfset stEmail["file#fileNo#"]['file-id'] = Trim(stEmail["file#fileNo#"]['file-id']) />
	<!--- src="cid:image1 --->
	
	<cfset stEmail['body'] = Replace(stEmail['body'], stEmail["file#fileNo#"]['file-id'], stEmail["file#fileNo#"]['src']) />
	
</cfloop>

<!--- <cfdump var="#stEmail#" label="stEmail" expand="true" />  --->

<cfoutput>
<strong>To: </strong>#stEmail['to']#<br />
<strong>From: </strong>#stEmail['from']#<br />
<strong>Subject: </strong>#stEmail['subject']#<br />
<hr>
#stEmail['body']#
<hr />
</cfoutput>


<cfoutput>
	[
	#LinkTo(text="Delete", params='view=#params.view#&name=#params.name#&page=deleteEmail&spool=#PARAMS.spool#')# |
	#LinkTo(text="Send", params='view=#params.view#&name=#params.name#&page=sendEmail&spool=#PARAMS.spool#')# |
	#LinkTo(text="Back", params='view=#params.view#&name=#params.name#&page=viewEmails')#
	]
</cfoutput>