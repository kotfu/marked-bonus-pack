# Marked Bonus Pack #

The Marked Bonus Pack is a collection of scripts, commands and services. Some
work with multiple editors, some are specific to certain editors. The Services
will generally work with any editor that has the necessary capabilities. The
rest are organized in folders based on the application they work with.

These items work with [Marked 2](http://marked2app.com). If you need support for
the original version of Marked, you will need to download [Marked Bonus Pack
1.5](https://github.com/kotfu/marked-bonus-pack/releases/tag/v1.5)

## Installation and Usage

Note that for some of the installation targets listed below — specifically
__Services__, __BBEdit__, __Sublime Text__, and __iA Writer__ — you can use
the provided
[install](./install) script.

### Services

Put the Services in `~/Library/Services`, where `~` is your user's home folder.
If you want hotkeys for the services, assign them in **System
Preferences->Keyboard->Shortcuts->Services**.

### BBEdit

Place `BBEdit/Open in Marked.applescript` in `~/Library/Application Support/BBEdit/Scripts/`.
Use from the Script menu bar item while editing a Markdown document (must be
saved first). You can assign a keyboard shortcut in BBEedit **Preferences->Menus
& Shortcuts**.

### TextMate

Double-click on the `Marked 2` bundle to open it in TextMate's Bundle Editor.
You can access the preview commands using `Control-Alt-M`. There are two of
these commands, one previews the current document and will watch the associated
file for future changes, the other previews the current selection using a
temporary file. The latter will not update automatically.

### Sublime Text

Copy the `Marked 2.sublime-build` file to `~/Library/Application Support/Sublime Text 3/Packages/User/`.
It will show up in the "Build Systems" section of the **Tools** menu in Sublime.
When selected, pressing `Command-B` will open the current file in Marked for
preview. Once opened, changes to the file will be tracked automatically by
Marked.

(This extension will also work with Sublime Text 2. Just copy
`Marked 2.sublime-build` to
`~/Library/Application Support/Sublime Text 2/Packages/User/`.)

### Vim

Via [A Whole Lot of Bollocks](http://captainbollocks.tumblr.com/post/9858989188/linking-macvim-and-marked-app).
Add the following to your .vimrc file:

	:nnoremap <leader>m :silent !open -a Marked\ 2.app '%:p'<cr>

**\m** (or your preferred leader) will now open the current file in Marked.

From [dixius99](https://github.com/dixius99):

You may prefer `:Marked` instead of using the leader key to launch Marked. To do that,
add the following to your .vimrc:

	command Marked :silent !open -a Marked\ 2.app '%:p'

The word right after "command" is what triggers the action. It can be anything
you want, but has to start with a capital letter.

### iA Writer

Via [stephenhowells](https://gist.github.com/stephenhowells/4599997):

Copy `iAWriter/Open in Marked.applescript` to `~/Library/Scripts/Applications/iA Writer/`. Run by clicking
the Script menu and selecting "Open in Marked" from the "iA Writer" section.

### Emacs

Via [Barry](http://spacebeast.com/blog/)

Install the `dot.emacs.txt` file in one of the following ways (depending on how
you have configured your emacs startup):

 1. Append the contents of `dot.emacs.txt` to `~/.emacs`
 2. Append the contents of `dot.emacs.txt` to `~/.emacs.d/init.el`
 3. Copy `dot.emacs.txt` to `~/.emacs.d/marked2.el` and ensure it is loaded by `~/.emacs.d/init.el`
 
See
[The Emacs Initialization File](http://www.gnu.org/software/emacs/manual/html_node/emacs/Init-File.html)
for more information about emacs startup.

Once installed, restart Emacs. Press `<Control>-C m` to preview the file
associated with the current buffer in Marked 2.

### Visual Studio Code

This project does not contain anything to help you integrate with
[Visual Studio Code](https://code.visualstudio.com/). However, Fabian
Morón Zirfas has created an
[Open in Marked Extension](https://marketplace.visualstudio.com/items?itemName=fmoronzirfas.open-in-marked). Once the extension is installed, you can open the current file in Marked 2
by typing `<Command>-<Shift>-P` and then typing `marked` to narrow the list
of commands, and then selecting "Open In Marked 2".

To bind it to a keyboard shortcut, select `Code`, `Preferences`, `Keyboard Shortcuts`
from the menu to open the keyboard shortcuts editor. Type `marked` to narrow the list
of commands, and then double-click on "Open in Marked 2". Type the keyboard shortcut
you want, and press `return`.

See [Key Bindings for Visual Studio Code](https://code.visualstudio.com/docs/getstarted/keybindings)
for more information on binding shortcuts to commands.

### AppleScript

There's one AppleScript included that performs essentially the same function as
the Open in Marked Service, but with some special accommodations for [Notational
Velocity](http://notational.net/) and
[nvALT](http://brettterpstra.com/project/nvalt/). In order to use it, two
configuration variables need to be edited at the top of the script. Open the
.applescript file in AppleScript Editor and modify the `property` lines at the
top, then save it as a compiled script (scpt) file. You can then run it from the
AppleScript menu (enabled in the AppleScript Editor preferences), or from a
hotkey-capable application like
[FastScripts](http://www.red-sweater.com/fastscripts/).

The nvALT scripts do their best to figure out the file, but don't always work.
The next version of nvALT should make this a lot easier.

### Watchers

Marked version 1 required some watcher scripts to work with Scrivener and
MarsEdit. Marked 2 has built in support for these applications, and no watcher
scripts are required.

More info: <http://brettterpstra.com/marked-scripts-nvalt-evernote-marsedit-scrivener/>

### Notes:

The easiest way to use these scripts is to put them in a convenient folder (I
use `~/scripts`) and run `chmod a+x path/to/script.rb` to make them executable.
You can then just type the path and script name and hit Enter (e.g.
`~/scripts/everwatch.rb`). They will run and watch for changes in their specific
application until you cancel the command by typing `Control-c`.

The scripts will create a file in your home directory (modifiable in the script)
called 'Marked Preview.md'. Open that file in Marked; Marked will watch that
file for changes that the scripts make.

You can create LaunchAgents for any of these and run them automatically in the
background if you know what you're doing. If you don't, you can still use an app
like [Lingon](http://www.peterborgapps.com/lingon/) to do it.

#### Evernote

To keep the 'Marked Preview.md' file synced with whatever note you're currently
editing in Evernote, start the script by running `~/path/to/everwatch.rb` in
Terminal. The script watches for changes to timestamps on any directory in
Evernote's data folder. This shouldn't need to be adjusted. To update Marked,
you'll need to have "~/Marked Preview.md" open and then hit "Command-S" in your
Evernote note. The autosave on Evernote will work, but it takes longer. 

The HTML of the note is captured via AppleScript and run through `textutil` to
remove the HTML formatting. This means that embedded images won't come through,
but those probably would have broken anyway. The script is specifically
expecting you to write your notes in Markdown. If you're not, I'm not sure why
you'd want a Marked preview anyway. Inline HTML works, but you have to watch
your quote marks very carefully. Evernote likes to convert the single and double
quote marks you type into "smart quotes", which Marked doesn't interpret as
HTML.

This watcher will not reliably if you have multiple Evernote user id's.

Even with "Command-S" there's still a 4-5 second delay on the update, as it
takes a bit for Evernote to write out to the file, the script to poll through
and notice the change, the content to be pulled via AppleScript and written to
the preview file and then for Marked to pick up on the change there. Considering
all of that, 4-5 seconds isn't too bad. If someone can think of a faster way,
I'm certainly open to it.

#### Notational Velocity/nvALT

If you store your notes as plain text files in NV/nvALT, you can just open the
notes folder in Marked 2 and it will always display a preview of the
most-recently edited file.

Watcher script:

If you're using [Notational Velocity][nv] (or my fork, [nvALT][nvalt]), you can
tell it to save your notes as text files on your drive. This script will watch
these text files for updates, then display the contents of the most
recently-edited note. It's a workable solution, at least until I get better
integration worked into nvALT directly.

You need to configure the script to point to your chosen folder for note
storage, and if you're using any unique extension, you'll need to add to or
modify the list in the script. It should be pretty obvious what needs to be set
if you look at the top of the script.

[nv]: http://notational.net
[nvalt]: http://brettterpstra.com/projects/nvalt
