#!/usr/bin/env ruby
# scrivwatch.rb by Brett Terpstra, 2011
# Modifications to merge into one file for Markdown viewing in Marked by BooneJS, 2012
# Modified to use REXML and add titles by Brett Terpstra, 2012 <https://gist.github.com/1676667>
#
# Watch a Scrivener project for changes and update a preview file for Marked
# Usage: scrivwatch.rb /path/to/document.scriv
# <http://markedapp.com>

require 'fileutils'
require 'rexml/document'
$debug = false
$droplet = ENV['SW_DROPLET']
$titles_as_headers = false
$out = STDOUT

def check_running()
  newpid = %x{ps ax|grep Marked|grep -v grep|awk '{print $1}'}
  return newpid.empty? ? false : true
end

def get_children(ele,path,files,depth)
  ele.elements.each('*/BinderItem') do |child|
        # Ignore docs set to not include in compile
        includetag = REXML::XPath.first( child, "MetaData/IncludeInCompile" )
        if !includetag.nil? && includetag.text == "Yes"
          id = child.attributes["ID"]
          # passing type, would eventually use to control header/title output
          type = child.attributes["Type"]
          title = child.elements.to_a[0].text
          file = "#{path}/Files/Docs/#{id}.rtf"
          filepath = File.exists?(file) ? file : false
          files << { 'path' => filepath, 'title' => title, 'depth' => depth, 'type' => type }
        end
        get_children(child,path,files,depth+1)
  end
end

# Take the path to the scrivener file and open the internal XML file.
def get_rtf_file_array(scrivpath)
  scrivpath = File.expand_path(scrivpath)
  scrivx = File.basename("#{scrivpath}", ".scriv") + ".scrivx"
  scrivxpath = "#{scrivpath}/#{scrivx}"
  # handle cases where the package has been renamed after creation
  unless File.exists?(scrivxpath) 
    scrivxpath = %x{ls -1 #{scrivpath}/*.scrivx|head -n 1}.strip
  end
  files = []
  doc = REXML::Document.new File.new(scrivxpath)
  doc.elements.each('ScrivenerProject/Binder/BinderItem') do |ele|
    if ele.attributes['Type'] == "DraftFolder"
      get_children(ele,scrivpath,files,1)
    end    
  end

  return files
end

trap("SIGINT") { exit }

unless $droplet || $debug
  if (ARGV.length != 1 || ARGV[0] !~ /\.scriv\/?$/)
    puts "Usage: scrivwatch.rb /path/to/document.scriv"
    exit
  end
end

if $debug && ARGV.length == 0
  path = File.expand_path("~/Dropbox/ScrivTest.scriv")
else
  path = File.expand_path(ARGV[0].gsub(/\/$/,''))
end

sw_name = path.gsub(/.*?\/([^\/]+)\.scriv$/,"\\1")

$out.printf("Watching %s:\n",sw_name) unless $droplet

sw_target = File.expand_path("~/ScrivWatcher")
Dir.mkdir(sw_target) unless File.exists?(sw_target)

sw_cache_dir = File.expand_path("~/ScrivWatcher/cache")
Dir.mkdir(sw_cache_dir) unless File.exists?(sw_cache_dir)
sw_cache = File.expand_path("~/ScrivWatcher/cache/#{sw_name}")
# Clear cache
if File.exists?(sw_cache)
	File.delete(*Dir["#{sw_cache}/*"])
	Dir.rmdir(sw_cache) 
end
Dir.mkdir(sw_cache)

sw_note = "#{sw_target}/ScrivWatcher - #{sw_name}.md"

File.delete(sw_note)
FileUtils.touch(sw_note)
%x{open -a Scrivener "#{path}" && open -a /Applications/Marked.app "#{sw_note}"}

first = true
files = []

while true do # repeat infinitely
  unless check_running
    puts "Marked quit, exiting"
    exit
  end
  
  notetext = ""
  
  # tracking the xml file for ordering changes as well
  new_xml_time = File.stat(path).mtime.to_i
  xml_time ||= new_xml_time
  diff_xml_time = new_xml_time - xml_time

  unless diff_xml_time == 0 && first == false
  	files = get_rtf_file_array(path)
  end

  # track any file changes in folder
  new_hash = files.collect {|f| [ f['path'], File.stat(f['path']).mtime.to_i ] if f['path'] } # create a hash of timestamps
  hash ||= new_hash
  diff_hash = new_hash - hash # check for changes
  arr = [0,10,20,30,40,50,60,70,80,90,100]

  unless first == false && diff_hash.empty? && diff_xml_time == 0 # if changes were found in the timestamps
  	$out.print("change detected\n") unless first || $droplet
    hash = new_hash
    xml_time = new_xml_time
    cachefiles = []
    total = files.length
    current = 0
    files.each{ |f|
	  current += 1
      if f['path']
	      cachefile = sw_cache + "/" + File.basename(f['path'],'.rtf') + ".md"
	      if !File.exists?(cachefile) || (File.stat(f['path']).mtime.to_i > File.stat(cachefile).mtime.to_i)
	      	# $stdout.puts "Caching #{f['path']}" if $debug
	      	note = f['path'] ? %x{/usr/bin/textutil -convert txt -stdout "#{f['path']}"} : ''
	      	leader = ""
	      	if $titles_as_headers && !f['depth'].nil?
	      		f['depth'].times { leader += "#" }
	      		leader = "#{leader} #{f['title']}\n\n"
	      	end
	      	notetext = leader + note + "\n\n"
	      	File.open(cachefile,"w"){|cf| cf.puts notetext }
	      end
	      cachefiles.push(cachefile)
      	  unless $droplet
	      	  #progress bar
	      	  percent = (current * 100 / total).ceil
			  progress = arr.select{|item| item <= percent }.max
			  cache_message = first ? "Building cache:" : "Updating cache:"
			  $out.print("#{cache_message} [")
			  $out.print("=="*(progress/10))
			  $out.print("  "*(10-(progress/10))) unless progress == 100
			  $out.print("]")
			  $out.printf(" %d%%\r",percent)
	      	  $out.flush
	      end
	  end
    }
    $out.print("\n") unless $droplet
    first = false
    # write the result to the preview file
    $out.print("Concatenating #{cachefiles.length} sections to #{sw_note}...") unless $droplet
	File.open(sw_note,"w"){|f| f.puts cachefiles.map{|s| IO.read(s)} }
	$out.puts("Done.\nWatching...") unless $droplet
  end
  
  sleep 1
end