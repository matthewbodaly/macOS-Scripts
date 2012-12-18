#!/bin/bash
# Network Name Updater thingy
# Author : Matthew Bodaly
# Updated : 17 October 2012

# Disable Bonjour
launchctl unload -w /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist
# Make a folder to store resource files
mkdir /Library/Application\ Support/caspersupport
# Write the variable to a file in the resource folder
echo BELUS0356 > /Library/Application\ Support/caspersupport/assettag
# Backup the file that will be changed
cp /etc/hostconfig /Library/Application\ Support/caspersupport/hostconfig.bak
# Change the HostName to the variable
scutil --set HostName BELUS0356
# Change the ComputerName to the variable
scutil --set ComputerName BELUS0356
# Write the variable to the end of /etc/hostconfig. This uses the FQDN. If you have a FQDN... you should change this.
echo HOSTNAME=BELUS0356.apptio.lan >> /etc/hostconfig
# change the Bonjour name
systemsetup -setlocalsubnetname BELUS0356
#reenable Bonjour
launchctl load -w /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist
#unbind from AD


