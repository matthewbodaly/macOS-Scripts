#!/bin/bash
# Network Name Updater thingy
# Author : Matthew Bodaly
# Updated : 17 October 2012

# Disable Bonjour
# launchctl unload -w /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist
# Make a folder to store resource files
# mkdir /Library/Application\ Support/caspersupport
# Ask for the barcode of the computer
# echo -n "Enter the name of this computer. Check the barcode"
# Set entry as a variable
# read -e BELUS
# Write the variable to a file in the resource folder
CAT BELUS0804 > /Library/Application\ Support/caspersupport/assettag2
# Backup the file that will be changed
# cp /etc/hostconfig /Library/Application\ Support/caspersupport/hostconfig.bak
# Change the HostName to the variable
# scutil --set HostName BELUS0804
# Change the ComputerName to the variable
# scutil --set ComputerName BELUS0804
# Write the variable to the end of /etc/hostconfig. This uses the FQDN. If you have a FQDN... you should change this.
# echo HOSTNAME=BELUS0804.apptio.lan >> /etc/hostconfig
# change the Bonjour name
# systemsetup -setlocalsubnetname BELUS0804
# reenable Bonjour
# launchctl load -w /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist

