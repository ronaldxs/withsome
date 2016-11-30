#!/bin/sh

if zenity --question --text="Please press a button."; then
    zenity --info --text="You pressed Yes\!"
else
    zenity --error --text="You pressed No\!"
fi
