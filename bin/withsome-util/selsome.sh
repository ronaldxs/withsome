#!/bin/bash

######################################################################
# Given list of paths, more or less expected to be sorted
# by some useful sort, present a numbered menu of the paths allowing
# a user to select some, one, all or none of the paths.
#
# Ronald Schmidt
# withsome Version/Version 0.10/0.15
#
######################################################################

selectsome ()
{
    local menu_count=${#@}
    local fmt="%${#menu_count}d) %s"

#    echo fmt is "$fmt"

    local PS3="$PS3"
    local -a selections
    local failed s

    if [ ! "$PS3" ] ; then
        PS3="Indicate your selection(s) from the above or 0 for none (default 1): "
    fi

    while (  [ "${#selections[@]}" -eq 0 ] ) 
    do
        local f i=1
	local IFS=' ' # not quite sure about lack of newline here
        for f in "$@"
        do
            printf "$fmt\n" $i "$f" 1>&2
            i=$((i +1))
        done

	if [ ${#menu_count} -gt 1 ] ; then
		printf "%${#menu_count}s)" "(A" 1>&2
	else
		echo -n 'A)' 1>&2
	fi
        echo " * All of the above" 1>&2

        if [ "$failed" ] ; then
           echo "Selection $failed was not a number between 0 and $menu_count" 1>&2 
        fi
        read -p "$PS3" -a selections

        if [ "${#selections[@]}" -eq 0 ] ; then
            selections=(1)
        fi

        unset failed

        for s in "${selections[@]}" ; do
            local d="$s"
            while ( [ "$d" -a "$d" != "${d#[0-9]}" ] ) ; do
                d="${d#[0-9]}"
            done
            if [ "$d" ] || [ "$s" -gt "$menu_count" ] ; then
		if [ "$s" == "a" ] || [ $s == "A" ] ; then
			selections=(`seq -s' ' 1 $menu_count`)
		else
			failed="$s"
			selections=()
		fi
                break
            fi
        done
    done

    for s in "${selections[@]}" ; do
        if [ "$s" -eq 0 ] ; then continue; fi
        echo "${@:$s:1}"
    done
}

#selectsome "$@"
