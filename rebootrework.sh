#!/bin/sh
LOGPATH="/var/log/jamf.log"
NAME=`more /Library/Application\ Support/caspersupport/assettag`
/usr/sbin/jamf setComputerName -target / -name "$NAME"