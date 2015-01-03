#!/usr/bin/env ruby
# everwatch.rb by Brett Terpstra, 2011
# Watch Evernote for updates and put the current content of the editor into a preview file for Marked.app
# <http://markedapp.com>

trap("SIGINT") { exit }

watch_folder = File.expand_path("~/Library/Application Support/Evernote/data")
marked_note = File.expand_path("~/Marked Preview.md")
counter = 0

while true do # repeat infinitely
  
  # read a list of files from the autosave folder
  files = Dir.glob( File.join( watch_folder, "*") )
  # build a hash of timestamps

  new_hash = files.collect {|f| [ f, File.stat(f).mtime.to_i ] }
  hash ||= new_hash
  # check for timestamp changes since the last loop
  diff_hash = new_hash - hash

  if diff_hash.empty? # if there's no change
    # if it's been less than 10 seconds, increment the counter
    # otherwise, set it to zero and wait for new changes
    counter = (counter < 10 && counter > 0) ? counter + 1 : 0
  else
    # store the new hash and start the 10 second change timer at 1
    hash = new_hash
    counter = 1
  end

  if counter > 0 # if the time is running
    # get the contents of the post and continued editor screens
    note = %x{ osascript <<APPLESCRIPT
        tell application "Evernote"
            if selection is not {} then
                set the_selection to selection
                return HTML content of item 1 of the_selection
            else
                return ""
            end if
        end tell
APPLESCRIPT}
    unless note == '' # if we got something back from the AppleScript
      # convert the contents to plain text
      txtnote = %x{echo '#{note}'|textutil -stdin -convert txt -stdout}
      # write the contents to the preview file
      watch_note = File.new("#{marked_note}",'w')
      watch_note.puts txtnote
      watch_note.close
    end
    # sleep an extra second on changes because Marked only
    # reads changes every 2 seconds
    sleep 1 
  end
    
  sleep 1

end