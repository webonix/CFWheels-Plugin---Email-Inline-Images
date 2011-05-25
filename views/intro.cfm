<cfoutput>
	<h1>Email Inline Images v#emailInlineImages.version#</h1>
<p>
Add images to emails so they can be embedded in the HTML.<br />
Images are to be stored in the images directory of your web root.
</p>

<p><pre>
&lt;cfset sendEmail(
       to='you@test.org',
       from='images@test.org',
       template="templates/testHTML",
       subject="embedded Image",
       images="email/test-image.gif",
       $deliver=[TRUE|FALSE]
)&gt;
</pre></p>

<p>
	In the image tag 'src' attribute, replace URL path with ''cid:' image id
	where images id are set as 'image' and sequence number,<br />
	e.g.<br />
	<pre>&lt;img alt="" width="945" height="118" src="cid:image1" /&gt;</pre>
</p>

<p>
If $deliver is set to FALSE this plugin will not send the email but save it to the spool directory within the plugin folder. You can then you the use the #LinkTo(text="Spool Viewer", params='view=#params.view#&name=#params.name#&page=viewEmails')#to review the output.
</p>
</cfoutput>

<cfoutput>
<h2>Spool Viewer</h2>

#LinkTo(text="View Emails", params='view=#params.view#&name=#params.name#&page=viewEmails')#
</cfoutput>

<cfoutput>
<h2>Uninstallation</h2>
<p>To uninstall this plugin, simply delete the <tt>/plugins/emailInlineImages-#emailInlineImages.version#.zip</tt> file.</p>

<h2>Credits</h2>
<p>This plugin was created by <a href="http://cfwheels.org/user/profile/249" target="_blank">AJ Mercer</a>.</p>

<h2>To Do</h2>
<p>
<ul>
	<li>Spool Viewer - send email for real [0.3]</li>
	<li>Spool Viewer - edit To/CC/BCC, Subject before sending [0.3]</li>
	<li>spool.cfm - handle file attachments [0.4]</li>
	<li>spool.cfm - handle multiple types [text|html] [0.4]</li>
	<li>viewEmails.cfm - make table look nice - jqGrid? [0.5]</li>
	<li>viewEmails.cfm - pagination [0.5]</li>
	<li>viewEmails.cfm - search [0.5]</li>
	<li>viewEmails.cfm - bulk delete [0.5]</li>
</ul>
#mailTo(emailAddress="ajmercer@gmail.com?subject=CFWHeels Email Inline Images Pluggin - Suggestion", name="Send Suggestions")#
</p>
</cfoutput>