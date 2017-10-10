#!/bin/bash
# v1.0 / Logan Fink / 74bit / 28 April 2015
# v1.1 / Matthew Bodaly /  20 October 2016
# v1.5 / Matthew Bodaly / DoorDash / 10 October 2017
# Updated the method to get the current user
#
# This puts log files on the current users desktop so they can attach it to tickets
# Variables
currentUser=$(python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
dateStamp=$(date +%Y\.%m\.%d-%H%M)
logZipName="$dateStamp-logs.zip"
logOutputDirectory="/Users/$currentUser/Desktop/"

if [[ "$currentUser" -ne "" && -d "/Users/$currentUser/Desktop" ]]; then
  logOutputDirectory="/Users/$currentUser/Desktop/"
else
  logOutputDirectory="/Users/Shared/"
fi

# Logs to catch

zip -r "$logOutputDirectory$logZipName" /Library/Logs/DiagnosticReports/ /var/log/ -x '*.zip' '*.gz'
