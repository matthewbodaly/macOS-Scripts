#!/bin/bash
launchctl unload -w /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist
BELUS=$(more /Library/Application\ Support/caspersupport/assettag)
LOCAL=$(scutil --get ComputerName)
if [ "$BELUS" != "$LOCAL" ];
then
# Change the HostName to the variable
	scutil --set HostName $BELUS;
# Change the ComputerName to the variable
	scutil --set ComputerName $BELUS;
# change the Bonjour name
systemsetup -setlocalsubnetname $BELUS
fi
launchctl load -w /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist
