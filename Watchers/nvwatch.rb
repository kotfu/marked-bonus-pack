#!/usr/bin/env ruby
# watch.rb by Brett Terpstra, 2011
# Watch Notational Velocity notes folder for changes and 
# update a preview file for Marked with most recently-modified file contents
# Requres that notes be stored as plain text and notes folder be customized below

trap("SIGINT") { exit }

watch_folder = "/Users/ttscoff/Dropbox/Notes/nvALT2.1"
watch_types = ['txt','md']
marked_note = File.expand_path("~/Marked Preview.md")

while true do # repeat infinitely
  files = []
  watch_types.each {|type|
    files += Dir.glob( File.join( watch_folder, "**", "*.#{type}" ) )
  } # collect a list of files of specified type
  new_hash = files.collect {|f| [ f, File.stat(f).mtime.to_i ] } # create a hash of timestamps
  hash ||= new_hash
  diff_hash = new_hash - hash # check for changes
  
  unless diff_hash.empty? # if changes were found in the timestamps
    hash = new_hash
    puts "changed"
    note_file = File.new("#{diff_hash[0][0]}",'r') # read the latest changed file from the hash
    note = note_file.read
    note_file.close
    watch_note = File.new("#{marked_note}",'w') # write its contents to the preview file
    watch_note.puts note
    watch_note.close
  end
  
  sleep 1
end