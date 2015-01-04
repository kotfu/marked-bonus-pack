# Marked Bonus Pack #

The Marked Bonus Pack is a collection of scripts, commands and services. Some work with multiple editors, some are specific to certain editors. The Services will generally work with any editor that has the necessary capabilities. The rest are organized in folders based on the application they work with.

## Installation and Usage

### Services

Put the Services in `~/Library/Services`, where ~ is your user's home folder. If you want hotkeys for the services, assign them in **System Preferences->Keyboard->Shortcuts->Services**.

### TextMate

Double-click on the Marked bundle to open it in TextMate's Bundle Editor. You can access the preview commands using Control-Command-M. There are two of these commands, one previews the current document and will watch the associated file for future changes, the other previews the current selection using a temporary file. The latter will not update automatically.

### Sublime Text 2

Copy the Marked.sublime-build file to `~/Library/Application Support/Sublime Text 2/Packages/User/`. It will show up in the "Build Systems" section of the **Tools** menu in Sublime. When selected, pressing Command-B will open the current file in Marked for preview. Once opened, changes to the file will be tracked automatically by Marked.

### Vim

Via [A Whole Lot of Bollocks](http://captainbollocks.tumblr.com/post/9858989188/linking-macvim-and-marked-app):

Add the following to your .vimrc file

	:nnoremap <leader>m :silent !open -a Marked\ 2.app '%:p'<cr>

**\m** (or your preferred leader) will now open the current file in Marked.

### Emacs ###

Via [Barry](http://spacebeast.com/blog/)

Add the following to your .emacs file

	(defun markdown-preview-file ()
	  "run Marked on the current file and revert the buffer"
	  (interactive)
	  (shell-command 
	   (format "open -a /Applications/Marked\ 2.app %s" 
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

To keep the 'Marked Preview.md' file synced with whatever note you're currently editing in Evernote, start the script by running `~/path/to/everwatch.rb` in Terminal. The script watches for changes to timestamps on any directory in Evernote's data folder. This shouldn't need to be adjusted. To update Marked, you'll need to have "~/Marked Preview.md" open and then hit "Command-S" in your Evernote note. The autosave on Evernote will work, but it takes longer. 

The HTML of the note is captured via AppleScript and run through `textutil` to remove the HTML formatting. This means that embedded images won't come through, but those probably would have broken anyway. The script is specifically expecting you to write your notes in Markdown. If you're not, I'm not sure why you'd want a Marked preview anyway...

Even with "Command-S" there's still a 4-5 second delay on the update, as it takes a bit for Evernote to write out to the file, the script to poll through and notice the change, the content to be pulled via AppleScript and written to the preview file and then for Marked to pick up on the change there. Considering all of that, 4-5 seconds isn't too bad. If someone can think of a faster way, I'm certainly open to it.

#### Scrivener/MarsEdit

Scrivener and MarsEdit support is now built into Marked 2.

#### Notational Velocity/nvALT

If you store your notes as plain text files in NV/nvALT, you can just open the notes folder in Marked 2 and it will always display a preview of the most-recently edited file.

Watcher script:

If you're using [Notational Velocity][nv] (or my fork, [nvALT][nvalt]), you can tell it to save your notes as text files on your drive. This script will watch these text files for updates, then display the contents of the most recently-edited note. It's a workable solution, at least until I get better integration worked into nvALT directly.

You need to configure the script to point to your chosen folder for note storage, and if you're using any unique extension, you'll need to add to or modify the list in the script. It should be pretty obvious what needs to be set if you look at the top of the script.

[nv]: http://notational.net
[nvalt]: http://brettterpstra.com/projects/nvalt
