#!/bin/bash
# v1.0 / Logan Fink / 74bit / 28 April 2015
# v1.1 / Matthew Bodaly /  20 October 2016
# v1.5 / Matthew Bodaly / DoorDash / 10 October 2017
# Updated the method to get the current user
#v1.6 / Matthew Bodaly / Outreach.io / 30 July 2024
#
# This puts log files on the current users desktop so they can attach it to tickets
# Variables
currentUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ { print $3 }' )
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
