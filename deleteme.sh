#!/bin/bash
# This script will check find out your ComputerName, compare with a known ComputerName, and ... if
# the computer is not the known, delete a user folder. I created this script to clean up after myself when
# I did a messy deploy
HOST=`scutil --get ComputerName`
if test "$HOST" != BELUS0689;
then
	if [ -f "/Users/mbodaly/Library/Preferences/org.mozilla.firefox.plist" ];
		then
   			echo "File exists"
   			rm -rf "/Users/mbodaly"
	fi
echo "No files found. I did nothing"
fi