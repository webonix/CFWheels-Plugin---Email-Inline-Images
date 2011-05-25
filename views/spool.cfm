<cfoutput>type:  text/html; charset=UTF-8
server:  192.0.0.118:25
from:  #ARGUMENTS.stEmail.from#
to:  #ARGUMENTS.stEmail.to#
subject:  #ARGUMENTS.stEmail.subject#
X-Mailer:  PSL Accolade Tax register
<cfloop list="#ARGUMENTS.stEmail.TAGCONTENT#" index="line" delimiters="#chr(10)#">body:  #line#</cfloop>
<cfloop array="#ARGUMENTS.stEmail.MAILPARAMS#" index="stMailParam">
	<cfif StructkeyExists(stMailParam, 'DISPOSITION')>
		<cfset fileName = ListLast(stMailParam.file, '/') />
file:  #stMailParam.file#
file-type:  image/#ListLast(fileName, '.')#; name=#fileName#
file-disposition:  #stMailParam.disposition#
file-id:  <#stMailParam.contentid#>
remove:  false<cfelse>
	<!--- file attachment --->
	</cfif>
</cfloop>
</cfoutput>