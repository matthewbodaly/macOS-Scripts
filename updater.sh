#!/bin/bash
# Apptio Network Name Updater thingy
# v1.0
# Author : Matthew Bodaly
# Updated : 17 October 2012
 
mkdir /Library/Application\ Support/caspersupport
echo -n "Enter the name of this computer. Check the barcode"
read -e BELUS
echo $BELUS > /Library/Application\ Support/caspersupport/assettag
cp /etc/hostconfig /Library/Application\ Support/caspersupport/hostconfig.bak
scutil --set HostName $BELUS
scutil --set ComputerName $BELUS
echo HOSTNAME=$BELUS.apptio.lan >> /etc/hostconfig
