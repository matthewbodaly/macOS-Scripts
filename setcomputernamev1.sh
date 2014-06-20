#!/bin/sh
# This sets the computer name in JAMF to what is in the assettag file
LOGPATH="/var/log/jamf.log"
NAME=`more /Library/Application\ Support/caspersupport/assettag`
/usr/sbin/jamf setComputerName -target / -name "$NAME"
