<cfcomponent output="false" mixin="controller" environment="design,development"> <!--- dependency="someOtherPlugin" --->

	<cffunction name="init" returntype="any" access="public" output="false">
		<cfset this.version = "1.1.3,1.2">
		<cfreturn this>
	</cffunction>

	<cffunction name="sendEmail" returntype="any" access="public" output="false" hint="Sends an email using a template and an optional layout to wrap it in. Besides the Wheels-specific arguments documented here, you can also pass in any argument that is accepted by the `cfmail` tag as well as your own arguments to be used by the view."
		examples=
		'
			<!--- Get a member and send a welcome email, passing in a few custom variables to the template --->
			<cfset newMember = model("member").findByKey(params.member.id)>
			<cfset sendEmail(
				to=newMember.email,
				template="myemailtemplate",
				subject="Thank You for Becoming a Member",
				recipientName=newMember.name,
				startDate=newMember.startDate
			)>
		'
		categories="controller-request,miscellaneous" chapters="sending-email" functions="">
		<cfargument name="template" type="string" required="false" default="" hint="The path to the email template or two paths if you want to send a multipart email. if the `detectMultipart` argument is `false`, the template for the text version should be the first one in the list. This argument is also aliased as `templates`.">
		<cfargument name="from" type="string" required="false" default="" hint="Email address to send from.">
		<cfargument name="to" type="string" required="false" default="" hint="List of email addresses to send the email to.">
		<cfargument name="subject" type="string" required="false" default="" hint="The subject line of the email.">
		<cfargument name="layout" type="any" required="false" hint="Layout(s) to wrap the email template in. This argument is also aliased as `layouts`.">
		<cfargument name="file" type="string" required="false" default="" hint="A list of the names of the files to attach to the email. This will reference files stored in the `files` folder (or a path relative to it). This argument is also aliased as `files`.">
	<cfargument name="image" type="string" required="false" default="" hint="A list of the names of the images to embed to the (HTML) email. This will reference images stored in the `images` folder (or a path relative to it). This argument is also aliased as `images`.">
		<cfargument name="detectMultipart" type="boolean" required="false" hint="When set to `true` and multiple values are provided for the `template` argument, Wheels will detect which of the templates is text and which one is HTML (by counting the `<` characters).">
		<cfargument name="$deliver" type="boolean" required="false" default="true">
		<cfscript>
			var loc = {};
			$args(args=arguments, name="sendEmail", combine="template/templates/!,layout/layouts,file/files,image/images", required="template,from,to,subject");
	
			loc.nonPassThruArgs = "template,templates,layout,layouts,file,files,image,images,detectMultipart,$deliver";
			loc.mailTagArgs = "from,to,bcc,cc,charset,debug,failto,group,groupcasesensitive,mailerid,maxrows,mimeattach,password,port,priority,query,replyto,server,spoolenable,startrow,subject,timeout,type,username,useSSL,useTLS,wraptext";
			loc.deliver = arguments.$deliver;
	
			// if two templates but only one layout was passed in we set the same layout to be used on both
			if (ListLen(arguments.template) > 1 && ListLen(arguments.layout) == 1)
				arguments.layout = ListAppend(arguments.layout, arguments.layout);
	
			// set the variables that should be available to the email view template (i.e. the custom named arguments passed in by the developer)
			for (loc.key in arguments)
			{
				if (!ListFindNoCase(loc.nonPassThruArgs, loc.key) && !ListFindNoCase(loc.mailTagArgs, loc.key))
				{
					variables[loc.key] = arguments[loc.key];
					StructDelete(arguments, loc.key);
				}
			}
	
			// get the content of the email templates and store them as cfmailparts
			arguments.mailparts = [];
			loc.iEnd = ListLen(arguments.template);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				// include the email template and return it
				loc.content = $renderPage($template=ListGetAt(arguments.template, loc.i), $layout=ListGetAt(arguments.layout, loc.i));
				loc.mailpart = {};
				loc.mailpart.tagContent = loc.content;
				if (ArrayIsEmpty(arguments.mailparts))
				{
					ArrayAppend(arguments.mailparts, loc.mailpart);
				}
				else
				{
					// make sure the text version is the first one in the array
					loc.existingContentCount = ListLen(arguments.mailparts[1].tagContent, "<");
					loc.newContentCount = ListLen(loc.content, "<");
					if (loc.newContentCount < loc.existingContentCount)
						ArrayPrepend(arguments.mailparts, loc.mailpart);
					else
						ArrayAppend(arguments.mailparts, loc.mailpart);
					arguments.mailparts[1].type = "text";
					arguments.mailparts[2].type = "html";
				}
			}
	
			// figure out if the email should be sent as html or text when only one template is used and the developer did not specify the type explicitly
			if (ArrayLen(arguments.mailparts) == 1)
			{
				arguments.tagContent = arguments.mailparts[1].tagContent;
				StructDelete(arguments, "mailparts");
				if (arguments.detectMultipart && !StructKeyExists(arguments, "type"))
				{
					if (Find("<", arguments.tagContent) && Find(">", arguments.tagContent))
						arguments.type = "html";
					else
						arguments.type = "text";
				}
			}
	
			// attach files using the cfmailparam tag
			if (Len(arguments.file))
			{
				arguments.mailparams = [];
				loc.iEnd = ListLen(arguments.file);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					arguments.mailparams[loc.i] = {};
					arguments.mailparams[loc.i].file = ExpandPath(application.wheels.filePath) & "/" & ListGetAt(arguments.file, loc.i);
				}
			}
			
	// attach images using the cfmailparam tag
			if (Len(arguments.image))
			{
				if (! structKeyExists(arguments, 'mailparams'))
					arguments.mailparams = [];
					
				loc.iEnd = ListLen(arguments.image);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					loc.imageFilePath = ListGetAt(arguments.image, loc.i);
					loc.imageFileName = ListLast(loc.imageFilePath);
					
					arguments.mailparams[loc.i] = {};
					arguments.mailparams[loc.i].file = ExpandPath(application.wheels.imagePath) & "/" & loc.imageFilePath ;
					arguments.mailparams[loc.i].contentID = "image#loc.i#" ;
					//arguments.mailparams[loc.i].contentID = ListFirst(loc.imageFileName, '.') ;
					arguments.mailparams[loc.i].disposition = 'inline'; 
				}
			}
	
			// delete arguments that we don't want to pass through to the cfmail tag
			loc.iEnd = ListLen(loc.nonPassThruArgs);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				StructDelete(arguments, ListGetAt(loc.nonPassThruArgs, loc.i));
	
			// send the email using the cfmail tag
			if (loc.deliver)
				$mail(argumentCollection=arguments);
			else
				return arguments;
		</cfscript>
	</cffunction>

	<cffunction name="$createSpoolFile" access="public" output="false" returntype="any">
		<cfargument name="stEmail" type="struct" required="true">
		
		<cfset var filePathName = "#ExpandPath('/plugins/emailInlineImages/spool')#/mail#createUUID()#" />
		<cfsavecontent variable="spoolEmail">
			<cfinclude template="views/spool.cfm" />
		</cfsavecontent>
		
		<cffile action="write" file="#filePathName#.cfmail" output="#spoolEmail#" charset="utf-8">
		
		<cfwddx input="#stEmail#" output="spoolEmail" action="cfml2wddx">
		<cffile action="write" file="#filePathName#.xml" output="#spoolEmail#" charset="utf-8">

	</cffunction>
</cfcomponent>