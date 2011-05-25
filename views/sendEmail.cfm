<h1>Send Email</h1>

<cfoutput>
[
#LinkTo(text="Back", params='view=#params.view#&name=#params.name#&page=viewEmails')# |
#LinkTo(text="Delete", params='view=#params.view#&name=#params.name#&page=deleteEmail&spool=#PARAMS.spool#')#
]
</cfoutput>


<cffile action="read" file="#ExpandPath('/plugins/emailinlineimages/spool')#\#PARAMS.spool#.xml" variable="email" />
<cfwddx input="#email#" output="stEmail" action="wddx2cfml">


<!--- to="#stEmail.to#" cc="#stEmail.cc#" bcc="#stEmail.bcc#" --->
<cfmail to="amercer@psl.com.au" from="#stEmail.from#" subject="#stEmail.subject#" type="html">
	<cfloop array="#stEmail.MAILPARAMS#" index="stFile">
		<cfmailparam file="#stFile.file#" contentID="#stFile.contentID#" disposition="inline">
	</cfloop>
	#stEmail.TAGCONTENT#
</cfmail>

<p>Email Sent</p>

<cfoutput>
[
#LinkTo(text="Back", params='view=#params.view#&name=#params.name#&page=viewEmails')# |
#LinkTo(text="Delete", params='view=#params.view#&name=#params.name#&page=deleteEmail&spool=#PARAMS.spool#')#
]
</cfoutput>