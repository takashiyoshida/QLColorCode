QLColorCode
===========
**Original project:** <http://code.google.com/p/qlcolorcode/>

**Warning:** since Mac OS X 10.10, the plugin should be installed in /Library/QuickLook to work correctly. Problem under investigation. 
 
This is a Quick Look plugin that renders source code with syntax highlighting,
using the [Highlight library](http://www.andre-simon.de).

To install the plugin, just drag it to `/Library/QuickLook` or `~/Library/QuickLook`.
You may need to create that folder if it doesn't already exist.

If you want to configure `QLColorCode`, there are several `defaults` commands 
that could be useful:

Setting the text encoding (default is `UTF-8`).  Two settings are required.  The
first sets Highlight's encoding, the second sets Webkit's:

    defaults write org.n8gray.QLColorCode textEncoding UTF-16
    defaults write org.n8gray.QLColorCode webkitTextEncoding UTF-16
    
Setting the font (default is `Menlo`):

    defaults write org.n8gray.QLColorCode font Monaco
    
the font size (default is `10`):

    defaults write org.n8gray.QLColorCode fontSizePoints 9
    
the color style (default is `edit-xcode`, see [all available themes](http://www.andre-simon.de/dokuwiki/doku.php?id=theme_examples)):

    defaults write org.n8gray.QLColorCode hlTheme ide-xcode
    
any extra command-line flags for Highlight (see below):

    defaults write org.n8gray.QLColorCode extraHLFlags '-l -W'
    
the maximum size (in bytes, deactivated by default) for previewed files:

    defaults write org.n8gray.QLColorCode maxFileSize 1000000

Here are some useful 'highlight' command-line flags (from the man page):

       -F, --reformat=<style>
              reformat output in given style.   <style>=[ansi,  gnu,  kr,
              java, linux]

       -J, --line-length=<num>
              line length before wrapping (see -W, -V)

       -j, --line-number-length=<num>
              line number length incl. left padding

       -l, --linenumbers
              print line numbers in output file

       -t  --replace-tabs=<num>
              replace tabs by num spaces

       -V, --wrap-simple
              wrap long lines without indenting function  parameters  and
              statements

       -W, --wrap
              wrap long lines

       -z, --zeroes
              fill leading space of line numbers with zeroes

       --kw-case=<upper|lower|capitalize>
              control case of case insensitive keywords

This version of the plugin use an external Highlight. By default, it uses `/opt/local/bin/highlight` but it can be changed:
    
    defaults write org.n8gray.QLColorCode pathHL /usr/local/bin/highlight 


Highlight can handle lots and lots of languages, but this plugin will only be 
invoked for file types that the OS knows are type "source-code".  Since the OS
only knows about a limited number of languages, I've added Universal Type 
Identifier (UTI) declarations for several "interesting" languages.  If I've 
missed your favorite language, take a look at the Info.plist file inside the
plugin bundle and look for the UTImportedTypeDeclarations section.  I
haven't added all the languages that Highlight can handle because it's rumored
that having two conflicting UTI declarations for the same file extension can
cause problems.  Note that if you do edit the Info.plist file you need to 
nudge the system to tell it something has changed.  Moving the plugin to the
desktop then back to its installed location should do the trick.

As an aside, by changing colorize.sh you can use this plugin to render any file
type that you can convert to HTML.  Have fun, and let me know if you do anything
cool!
