# Marked Bonus Pack #

The Marked Bonus Pack is a collection of scripts, commands and services. Some work with multiple editors, some are specific to certain editors. The Services will generally work with any editor that has the necessary capabilities. The rest are organized in folders based on the application they work with.

## Installation and Usage

### Services

Put the Services in `~/Library/Services`, where ~ is your user's home folder. If you want hotkeys for the services, assign them in **System Preferences->Keyboard->Shortcuts->Services**.

### TextMate

Double-click on the Marked bundle to open it in TextMate's Bundle Editor. You can access the preview commands using Control-Command-M. There are two of these commands, one previews the current document and will watch the associated file for future changes, the other previews the current selection using a temporary file. The latter will not update automatically.

There's a third command for stripping header id's out of HTML documents. This can be done by setting "Compatibility Mode" in Marked Preferences, but this also causes other MultiMarkdown features to be disabled. To keep MultiMarkdown features and remove the auto-generated header ID's from the HTML output, use this command.

### Sublime Text 2

Copy the Marked.sublime-build file to `~/Library/Application Support/Sublime Text 2/Packages/User/`. It will show up in the "Build Systems" section of the **Tools** menu in Sublime. When selected, pressing Command-B will open the current file in Marked for preview. Once opened, changes to the file will be tracked automatically by Marked.

### Vim

Via [A Whole Lot of Bollocks](http://captainbollocks.tumblr.com/post/9858989188/linking-macvim-and-marked-app):

Add the following to your .vimrc file

	:nnoremap <leader>m :silent !open -a Marked.app '%:p'<cr>

**\m** (or your preferred leader) will now open the current file in Marked.

### Emacs ###

Via [Barry](http://spacebeast.com/blog/)

Add the following to your .emacs file

	(defun markdown-preview-file ()
	  "run Marked on the current file and revert the buffer"
	  (interactive)
	  (shell-command 
	   (format "open -a /Applications/Marked.app %s" 
	       (shell-quote-argument (buffer-file-name))))
	)
	(global-set-key "\C-cm" 'markdown-preview-file)

Command key is **Control-c m**

### AppleScript

There's one AppleScript included that performs essentially the same function as the Open in Marked Service, but with some special accommodations for [Notational Velocity](http://notational.net/) and [nvALT](http://brettterpstra.com/project/nvalt/). In order to use it, two configuration variables need to be edited at the top of the script. Open the .applescript file in AppleScript Editor and modify the `property` lines at the top, then save it as a compiled script (scpt) file. You can then run it from the AppleScript menu (enabled in the AppleScript Editor preferences), or from a hotkey-capable application like [FastScripts](http://www.red-sweater.com/fastscripts/).

The nvALT scripts do their best to figure out the file, but don't always work. The next version of nvALT should make this a lot easier.

### Watchers ###


More info: <http://brettterpstra.com/marked-scripts-nvalt-evernote-marsedit-scrivener/>

### Notes:

For all of these scripts (except for the Scrivener Droplet app), the easiest way to use them is to put them in a convenient folder (I use `~/scripts`) and run `chmod a+x path/to/script.rb` to make them executable. With the exception of the Scrivener script (`scrivwatch.rb`), you can then just type the path and script name and hit Enter (e.g. `~/scripts/everwatch.rb`). They will run and watch for changes in their specific application until you cancel the command by typing `Control-c`.

The scripts will create a file in your home directory (modifiable in the script) called 'Marked Preview.md'. Open that file in Marked; Marked will watch that file for changes that the scripts make.

You can create LaunchAgents for any of these (except, again, Scrivener) and run them automatically in the background if you know what you're doing. If you don't, you can still use an app like [Lingon](http://www.peterborgapps.com/lingon/) to do it.

#### Evernote

To keep the 'Marked Preview.md' file synced with whatever note you're currently editing in [Evernote][en], start the script by running `~/path/to/everwatch.rb` in Terminal. The script watches for changes to timestamps on any directory in Evernote's data folder. This shouldn't need to be adjusted. To update Marked, you'll need to have "~/Marked Preview.md" open and then hit "Command-S" in your Evernote note. The autosave on Evernote will work, but it takes longer. 

The HTML of the note is captured via AppleScript and run through `textutil` to remove the HTML formatting. This means that embedded images won't come through, but those probably would have broken anyway. The script is specifically expecting you to write your notes in Markdown. If you're not, I'm not sure why you'd want a Marked preview anyway...

Even with "Command-S" there's still a 4-5 second delay on the update, as it takes a bit for Evernote to write out to the file, the script to poll through and notice the change, the content to be pulled via AppleScript and written to the preview file and then for Marked to pick up on the change there. Considering all of that, 4-5 seconds isn't too bad. If someone can think of a faster way, I'm certainly open to it.

#### Scrivener

This script creates a folder in your home directory called "ScrivWatcher" which contains separate previews for each document opened. There is a cache directory for conversion speedup containing text versions of all of the sections in your document. The rendered Markdown file will open on its own in Marked when the script or droplet is run, and if it's not already open in Scrivener, Scrivener will launch and open that project as well.

The [Scrivener][scriv] script watches the RTF and XML files that Scrivener keeps within the project as you write. If you set Scrivener's preferences to auto-save 1 second after you stop typing, Marked will stay pretty snappy on the updates without any further intervention. The full document is compiled and displayed in the order set in the Scrivener binder.

To launch the script (assuming you made the script executable as detailed at the beginning of this section), open Terminal and type `path/to/scrivwatcher.rb /path/to/YourDocument.scriv`. Example: `~/scripts/scrivwatcher.rb ~/Documents/Thesis.scriv`. The script will take it from there and run until you interrupt with `Control-c`.

There is also a droplet bundled in the same folder. Running it will give you a small drop area to which you can drag a Scrivener project file (.scriv) and it will handle the rest.

The files Scrivener stores are Rich Text Format, so Marked can't view their contents directly. The script runs the most recently-edited file through `textutil` to convert from RTF to text. The converted files are cached and only updated when changed, allowing large documents to preview quickly on save.

#### MarsEdit

Thanks to Daniel Jalkut for an assist with this one. It watches the [MarsEdit][mars] autosave folder for any changes, and then uses AppleScript to get the full contents of the editor (post *and* continued) when one is detected. Because the autosave can be a bit slow on the draw, it continues updating every second for 10 seconds, whether there's a change or not. If no more changes are detected within 10 seconds, it chills out in the background until the next one is detected.

Run `marswatch.rb` to start polling for changes, open 'Marked Preview.md` from your home folder and Marked should start updating the preview automatically as you make changes in a MarsEdit post.

#### Notational Velocity/nvALT

If you're using [Notational Velocity][nv] (or my fork, [nvALT][nvalt]), you can tell it to save your notes as text files on your drive. This script will watch these text files for updates, then display the contents of the most recently-edited note. It's a workable solution, at least until I get better integration worked into nvALT directly.

You need to configure the script to point to your chosen folder for note storage, and if you're using any unique extension, you'll need to add to or modify the list in the script. It should be pretty obvious what needs to be set if you look at the top of the script.