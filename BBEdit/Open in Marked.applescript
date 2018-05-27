-- Place in ~/Library/Application Support/BBEdit/Scripts
-- Use from the Script menu bar item while editing a Markdown document (must be saved first)
-- Assign a shortcut key in BBEedit Preferences->Menu Items
tell application "BBEdit" to set mdFile to file of document of window 1
tell application "Marked 2"
	activate
	open mdFile
end tell
