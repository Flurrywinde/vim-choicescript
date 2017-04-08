# vim-choicescript

Hopefully one day this will be a plugin (once I learn how to make plugins). For now, it is simply three files to add to your .vim directory:

**after/ftplugin/choicescript.vim:** Choicescript indentation

**ftdetect/choicescript.vim:** Sets filetype to choicescript for *.txt files but only if they're in a scenes/ directory.

**syntax/choicescript.vim:** Choicescript syntax

**choicefuncs.vim:** A bunch of useful choicescript commands that load when the filetype is choicescript.

I am a newbie with vimscript, so if there are better ways to do these things, please let me know! For example, does there really need to be a separate indentation file, and does it have to be in the after/ directory? Things like this are still mysteries to me.

## New Vim Commands

### Automatically make \*labels for each option in a \*choice

*Ctrl-p in Insert mode, <space>mc (for "Make Choices") in Normal mode*

Run this after you've finished a \*choice block to automatically make \*labels for any \*gotos in the \#options. It will also add "[This option is yet to be written.]" to each, and the last one gets a \*goto back to the first label. 

This way, when you are testing your game and reach an unfinished \*choice, you won't get a bad label error anymore.

### Find Parent

*<space>fp in Normal mode*

Put cursor on a \*label. Then hit <space>fp, and it'll go to the \*goto that goes there. Only goes to first one it finds if there is more than one parent.

### Find Child

*<space>fc in Normal mode*

Put cursor on a \*goto. Then hit <space>fc, and it'll go to the corresponding \*label.

### Check Label

*<space>cl in Normal mode*

Say you just typed a \*goto but aren't sure if you've already used that label name already. This will tell you.

### Go to next unfinished area

*<space>uf in Normal mode*

This will jump to the next \*label that has "[This" on the next line. This works because "[This option is yet to be written.]" is automatically placed by MakeChoices.

### And more...

There's other stuff in choicefuncs.vim too, but these are things I either found I didn't use or are still experimental. Explore and use at your own risk!
