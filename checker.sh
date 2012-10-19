#!/bin/bash
BELUS=$(more /Library/Application\ Support/caspersupport/assettag)
LOCAL=$(scutil --get ComputerName)
if [ "$BELUS" != "$LOCAL" ];
then
# Change the HostName to the variable
	scutil --set HostName $BELUS;
# Change the ComputerName to the variable
	scutil --set ComputerName $BELUS;
fi