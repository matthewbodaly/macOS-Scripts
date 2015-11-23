#!/bin/sh
# deletes the lync keychain
# Written by Matthew Bodaly
# v. 1.0.1 27 July 2015
# v. 1.1 19 November 2015 - updated method of getting current user

# Variables
# Get the current user
USER=$(`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`)

# Payload
# Exit Lync
sudo killall -KILL "Microsoft Lync"
# Delete the keychain
rm -rF "/Users/$USER/Library/Keychains/*@*"
# Open Lync
open -a /Applications/Microsoft\ Lync.app/
