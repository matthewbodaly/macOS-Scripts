#!/bin/bash
# this gathers the history file and puts it somewhere common for future work
# this section will also be broken off into a separate script so I can have the future service call the script as well as self update
stat -f '%Su' /dev/console > /Library/Application\ Support/caspersupport/user
USER='python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'
cp -f /Users/$USER/.bash_history /Library/Application\ Support/caspersupport/history/$USER
chmod 777 /Library/Application\ Support/caspersupport/history/$USER
# this section reads the file and creates a new file with requested information
grep -F "sudo" /Library/Application\ Support/caspersupport/history/$USER >> /Library/Application\ Support/caspersupport/history/sudo
grep -F "ssh" /Library/Application\ Support/caspersupport/history/$USER >> /Library/Application\ Support/caspersupport/history/ssh
grep -F "jamf" /Library/Application\ Support/caspersupport/history/$USER >> /Library/Application\ Support/caspersupport/history/jamf
