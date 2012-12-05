#!/usr/bin/env zsh -f

# This code is licensed under the GPL v2.  See LICENSE.txt for details.

# colorize.sh
# QLColorCode
#
# Created by Nathaniel Gray on 11/27/07.
# Copyright 2007 Nathaniel Gray.

# Modified by Anthony Gelibert on 12/4/12.
# Copyright 2012 Anthony Gelibert.

# Expects   $1 = path to resources dir of bundle
#           $2 = name of file to colorize
#           $3 = 1 if you want enough for a thumbnail, 0 for the full file
#
# Produces HTML on stdout with exit code 0 on success

###############################################################################

# Fail immediately on failure of sub-command
setopt err_exit

rsrcDir=$1
target=$2
thumb=$3

function debug () {
    if [ "x$qlcc_debug" != "x" ]; then
        if [ "x$thumb" = "x0" ]; then
            echo "QLColorCode: $@" 1>&2
        fi;
    fi
}

debug Starting colorize.sh
cmd="${pathHL}"
cmdOpts=(-I -k "${font}" -K ${fontSizePoints} -q -s ${hlTheme} -u ${textEncoding} ${=extraHLFlags} --validate-input)

debug Setting reader
reader=(cat $target)

debug Handling special cases
case $target in
    *.graffle )
        # some omnigraffle files are XML and get passed to us.  Ignore them.
        exit 1
        ;;
    *.plist )
        lang=xml
        reader=(/usr/bin/plutil -convert xml1 -o - $target)
        ;;
    *.h )
        if grep -q "@interface" $target &> /dev/null; then
            lang=objc
        else
            lang=h
        fi
        ;;
    *.pde )
        lang=c
        ;;
    *.scpt )
        lang=applescript
        ;;
    * )
        if [[ ${target} = ?*.* ]]; then
            lang=${target##*.}
        else
            ftarget=$(file $target)
            debug $ftarget
            if [[ ! -z "$(echo $ftarget | grep -e "[shell|bash|expect] script")" ]]; then
                lang=sh
            elif [[ ! -z "$(echo $ftarget | grep -e "ruby")" ]]; then
                lang=ruby;
            elif [[ ! -z "$(echo $ftarget | grep "python")" ]]; then
                lang=py;
            else
                exit 102
            fi;
        fi
        ;;
esac
debug Resolved $target to language $lang

go4it () {
    debug Generating the preview
    local title="`basename ${target}`"
    if [ $thumb = "1" ]; then
        $reader | head -n 100 | head -c 20000 | $cmd -S $lang $cmdOpts && exit 0
    elif [ -n "$maxFileSize" ]; then
        $reader | head -c $maxFileSize | $cmd -T "${title}" -S $lang $cmdOpts && exit 0
    else
        $reader | $cmd -T "${title}" -S $lang $cmdOpts && exit 0
    fi
}

setopt no_err_exit
debug First try...
go4it
# Uh-oh, it didn't work.  Fall back to rendering the file as plain
debug First try failed, second try...
lang=txt
go4it
debug Reached the end of the file.  That should not happen.
exit 101
