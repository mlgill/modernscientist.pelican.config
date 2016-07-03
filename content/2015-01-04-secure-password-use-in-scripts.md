Title: Secure Password Use in Scripts
Date: 2015-01-04 19:48
Author: Michelle Gill
Slug: secure_password_use_in_scripts
Tags: mac, automation, shell

**NOTE:** If you're using passwords in shell scripts, see Daniel Jalkut's reply below about using OS X's built-in `security` command instead of his AppleScript library.

One of my goals for the new year[^resolution] is to be more security minded in my use of technology. This is a broad statement, but I have some very specific points in mind, including more regular use of a self-hosted VPN (the topic of a future blog post) and avoiding the bad habit of using passwords in shell scripts (the topic of this blog post).

The use of security credentials, such as a password, is an integral part of life with technology. For those of us who like to automate things, the need often arises to supply such credentials in a script. The simplest, and least secure, way to do this is to enter the password in the script in plain text form. Having done this myself and seen countless other people who are way better at this automation thing than me do the [same](http://www.macdrifter.com/2013/03/pause-timemachine-macro.html), I know it is easy to do. I'm certainly not here to lecture anyone about best practices, but there is another option and it's not that difficult to use. This method involves a little AppleScript and [Daniel Jalkut's](http://www.red-sweater.com) excellent utility, [Usable Keychain Scripting](http://www.red-sweater.com/blog/170/usable-keychain-scripting), with the latest version available [here](http://www.red-sweater.com/blog/2035/usable-keychain-scripting-for-lion). I don't see much mention of Usable Keychain Scripting online, so I thought a tutorial would be a handy way to start the new year.[^yosemite]

## Motivation for Usable Keychain Scripting

Daniel's blog posts explain his personal motivations for writing and updating Usable Keychain Scripting, but I first discovered the application when Apple removed keychain scripting from Lion, thus making it impossible to access keychain entries with AppleScript. His utility fills that niche for me, though as mentioned, I don't use it as often as I should.

The general idea is to create a specific keychain entry with a title and password in one of your keychains using Keychain Access[^1password]. Then the password contained in this entry is accessed using the AppleScript library provided by Usable Keychain Scripting. AppleScript can be called from many languages, including the shell, thus allowing the password to be retrieved when needed.[^security]

## Create a keychain password

The first step is to create a password entry in Keychain Access. The main consideration here is that although multiple keychain entries can have the same name, it's difficult (and more work) to distinguish between them in an AppleScript. Thus, it's best to ensure the entry has a unique name. 

Here's an example I created to mount the partitions on our Drobo, called KUPHOG-NAS:[^kuphog]

!["KUPHOG NAS drive password"][image1]

## Configure Usable Keychain Scripting

Before Usable Keychain Scripting can be called from a shell script, some setup is required. I find it easiest to do this in Script Editor. First, Usable Keychain Scripting has to be downloaded and installed in your computer's Applications directory, if this hasn't been done already. Next, the program's AppleScript dictionary has to be installed. This is done by opening the Script Editor's Library window (located in the Window menu) and then clicking on the plus sign. This opens a window to the Applications directory, where Usable Keychain Scripting should be selected. When finished, the program will appear in the Library window, like this:

!["AppleScript dictionary installation"][image2]

Then the Usable Keychain Scripting AppleScript library should be tested *within* Script Editor. This is important because your login password has to be entered the first time this AppleScript library is accessed, and the password entry window doesn't always work from a shell script.

Here's a sample AppleScript that accesses the password created for the Drobo above:

```applescript
tell application "Usable Keychain Scripting"
	set myPassword to password of first keychain item of keychain "/Users/mlgill/Library/Keychains/login.keychain" whose name is "KUPHOG-NAS"
end tell
```

As is probably obvious, this password was created in the login keychain for my account in Keychain Access. When this is the case, a simpler  alternative can also be used:

```applescript
tell application "Usable Keychain Scripting"
	set myPassword to password of first keychain item of the current keychain whose name is "KUPHOG-NAS"
end tell
```

When either of the AppleScripts is executed, the desired password will be returned. This indicates everything is working:

!["AppleScript test of Usable Keychain Scripting"][image3]

## Incorporating Usable Keychain Scripting in a shell script

The last step is using your new toy in a shell script. Continuing with the Drobo example, here's how to mount a drive partition from the command line:

```bash
#!/bin/sh

NAS_ADDRESS='KUPHOG-NAS'
USERNAME='Michelle'
NAS_MOUNTPOINT='TimeMachineBackup'

# Execute the AppleScript to retrieve the password
PASSWORD=`osascript << 'END'
tell application "Usable Keychain Scripting"
set myPassword to password of first keychain item of current keychain whose name is "KUPHOG-NAS"
end tell
END`

if [[ ! -e /Volumes/$NAS_MOUNTPOINT ]]; then
	mkdir /Volumes/$NAS_MOUNTPOINT
fi

mount_smbfs smb://$USERNAME:$PASSWORD@$NAS_ADDRESS/$NAS_MOUNTPOINT /Volumes/$NAS_MOUNTPOINT
```

That's it! Here's to a more secure 2015!

[image1]: {filename}/images/2015-01-04_secure_password_use_in_scripts_1.png "KUPHOG NAS drive password"
[image2]: {filename}/images/2015-01-04_secure_password_use_in_scripts_2.png "AppleScript dictionary installation"
[image3]: {filename}/images/2015-01-04_secure_password_use_in_scripts_3.png "AppleScript test of Usable Keychain Scripting"

[^resolution]: I dislike the absolutism of the word resolution, but call it that if you prefer.
[^yosemite]: Contrary to some discussion I've seen, Usable Keychain Scripting works on Yosemite (and presumably also Mavericks). It seems there are some changes to the syntax though.
[^1password]: I'd prefer to use 1Password for this task, but there is not a script library that works with 1Password that I know of.
[^security]: I can imagine there are insecurities associated with Usable Keychain Scripting, but it is certainly more secure than plain text. Use common sense here.
[^kuphog]: Yes, my husband and I named our Drobo after our allegiance to our alma mater. Rock Chalk, Jayhawk!

