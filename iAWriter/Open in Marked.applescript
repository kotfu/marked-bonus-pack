-- Preview the currently active iA Writer document using Marked.
tell application "iA Writer"
  activate
	
	-- Ask iA Writer for it's active document.
	set the_document to document 1
	
	-- Save the document or prompt if not previously saved.
	save the_document
	
	-- If the file is saved, open it using Marked.
	tell application "Marked"
		set the_file to the_document's file
		open the_file
		-- Bring Marked forward so it becomes visible.
		activate
	end tell

end tell