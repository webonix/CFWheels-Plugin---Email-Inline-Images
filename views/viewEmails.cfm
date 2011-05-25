<h1>View Emails</h1>


<cfdirectory directory="#ExpandPath('/plugins/emailinlineimages/spool')#" action="list" filter="*.xml" name="qrySpool" sort="DATELASTMODIFIED desc"  />

<cfset emails = ArrayNew(1) />

<cfloop query="qrySpool">
	<cffile action="read" file="#qrySpool.directory#\#qrySpool.name#" variable="email" />
	<cfwddx input="#email#" output="stEmail" action="wddx2cfml">
	
<!--- 		
	<cfset stEmail = StructNew() />
	
	<cfloop from="1" to="6" index="lineNo">
		<cfset line = ListGetAt(email, lineNo, chr(13)) />
		<cfset stEmail[Trim(ListFirst(line,':'))] = Replace(line, "#ListFirst(line,':')#: ", '') />
	</cfloop>
--->
	<cfset stEmail['sent'] = qrySpool.DATELASTMODIFIED />
	<cfset stEmail['name'] = ListFirst(qrySpool.name, '.') />
	
	<cfset ArrayAppend(emails, stEmail)>

</cfloop>

<cfoutput>
[
#LinkTo(text='Home', href='/')# |
#linkTo(text="Delete All Emails", controller="wheels", action="wheels", params="view=plugins&name=emailinlineimages&page=deleteAllEmails")#
]
</cfoutput>

<cfoutput><table border="1" cellpadding="2" cellspacing="0" width="100%">
<tr>
	<th>Sent</th>
	<th>To</th>
	<th>From</th>
	<th>Subject</th>
	<th>Action</th>
</tr>
<cfloop array="#emails#" index="stEmail">
	
<tr>
	<td>#stEmail.sent#</td>
	<td>#ListFirst(stEmail.to)#</td>
	<td>#stEmail.from#</td>
	<td>#Left(stEmail.subject, 50)#</td>
	<td>#LinkTo(text="View", params='view=#params.view#&name=#params.name#&page=viewEmail&spool=#stEmail.name#')# | #LinkTo(text="Del", params='view=#params.view#&name=#params.name#&page=deleteEmail&spool=#stEmail.name#')#</td>
</tr>
</cfloop>
</table></cfoutput>

<cfoutput>
<p>
[
#LinkTo(text='Home', href='/')# |
#linkTo(text="Delete All Emails", controller="wheels", action="wheels", params="view=plugins&name=emailinlineimages&page=deleteAllEmails")#
]
</p>
</cfoutput>

