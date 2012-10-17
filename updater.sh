#!/bin/bash
# Apptio Network Name Updater thingy
# v1.0
# Author : Matthew Bodaly
# Updated : 17 October 2012

# Make a folder to store resource files
mkdir /Library/Application\ Support/caspersupport
# Ask for the barcode of the computer
echo -n "Enter the name of this computer. Check the barcode"
# Set entry as a variable
read -e BELUS
# Write the variable to a file in the resource folder
echo $BELUS > /Library/Application\ Support/caspersupport/assettag
# Backup the file that will be changed
cp /etc/hostconfig /Library/Application\ Support/caspersupport/hostconfig.bak
# Change the HostName to the variable
scutil --set HostName $BELUS
# Change the ComputerName to the variable
scutil --set ComputerName $BELUS
# Write the variable to the end of /etc/hostconfig
echo HOSTNAME=$BELUS.apptio.lan >> /etc/hostconfig
