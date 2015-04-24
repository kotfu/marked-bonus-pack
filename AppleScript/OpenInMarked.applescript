-- Open in Marked 2
-- Attempts to open the currently-edited document in Marked 2 for previewing
-- Based on ideas by Lri <https://gist.github.com/1077745>
-- with contributions from Donald Curtis <https://github.com/milkypostman>

---NV/nvALT configuation---------------------------------------------------
-- * Set NV/nvALT to store text files to disk
-- * Enter the full UNIX/POSIX path to your notes folder in nvNoteFolder
-- * Enter your default file extension (.txt,.md,etc.) in nvNoteExtension
-- It won't always work, but it will try. It's a temporary hack; 
-- nvALT will soon have an AppleScript command to access the file directly.
property nvNoteFolder : "/Users/username/pathtonotes/" -- include trailing slash
property nvNoteExtension : ".md" -- include leading dot
---------------------------------------------------------------------------on run {}
tell application "System Events"
	set frontApp to (name of first process whose frontmost is true)
end tell

set f to false
set flist to {}

--Marked 2 (if Marked 2 is foreground, hide Marked 2 and end script)
if frontApp is "Marked 2" then
	tell application "System Events" to set visible of process "Marked 2" to false
	return
	--Notational Velocity/nvALT
else if (frontApp is "Notational Velocity") or (frontApp is "nvALT") then
	try
		tell application "System Events" to tell process frontApp
			-- Grab the text in the search field, hopefully this will be the filename
			set p to value of text field 1 of group 1 of toolbar 1 of window 1
			try -- look for it in nvNoteFolder with the nvNoteExtension suffix
				set f to POSIX file (nvNoteFolder & p & nvNoteExtension) as alias
			end try
			if f is false then -- if we didn't get a bite...
				try -- attempt with .txt
					set f to POSIX file (nvNoteFolder & p & ".txt") as alias
				end try
			end if
			if f is false then -- report the failure
				set _res to display dialog "Couldn't open " & nvNoteFolder & p & nvNoteExtension & ". Check your property settings in the script." buttons {"OK"}
				return
			end if
		end tell
	on error errNO
		set _res to display dialog "Couldn't open " & nvNoteFolder & p & nvNoteExtension & ". Check your property settings in the script." buttons {"OK"}
		return
	end try
	--Finder (open selected file)
else if frontApp is "Finder" then
	tell application "Finder" to set flist to (get selection)
else if frontApp is "Emacs" then
	set emacsclient to false
	tell application "Finder"
		if exists POSIX file "/usr/local/bin/emacsclient" then
			set emacsclient to "/usr/local/bin/emacsclient"
		end if
	end tell
	if emacsclient is not false then
		set f to do shell script emacsclient & " -e '(first (delete nil (mapcar (function buffer-file-name) (buffer-list))))' | sed 's/^\"//' | sed 's/\"$//'" as string
		if f is not "nil" then
			set f to f as POSIX file as alias
		else
			set f to false
		end if
	end if
	--Byword (open current document)
else if frontApp is "Byword" then
	tell application frontApp to set f to file of document of window 1 as alias
else if frontApp is "TextEdit" then
	tell application frontApp to set f to path of document of window 1 as POSIX file
	--Fallback (attempt "path of document 1" and see if current app responds)
else if frontApp is "Mou" then
	tell application "System Events"
		set f to text 17 thru -1 of (value of attribute "AXDocument" of first window of process "Mou" as text)
	end tell
else if frontApp is "TextWrangler" then
	tell application frontApp to set f to file of document of window 1 as alias
else if frontApp is "DEVONthink Pro" then
	tell application "DEVONthink Pro" to set f to path of content record of think window 1
else
	tell application "System Events"
		tell process frontApp
			try
				set isScriptable to has scripting terminology
			on error
				set isScriptable to false
			end try
		end tell
	end tell
	if isScriptable then
		try
			tell application frontApp to set f to POSIX file (path of document 1 of window 1) as alias
		end try
		if f is false then
			try
				tell application frontApp to set f to POSIX file (path of first document) as alias
			end try
		end if
		if f is false then
			try
				tell application frontApp to set f to POSIX file (text 17 thru -1 of (get URL of document 1)) as alias -- BBEdit
			end try
		end if
	end if
end if

if f is false and flist is not {} then
	tell application "Marked 2"
		activate
		repeat with afile in flist
			open (afile as alias)
		end repeat
	end tell
else if f is not false then
	tell application "Marked 2"
		activate
		open f
	end tell
end if
end run