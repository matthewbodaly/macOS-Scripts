#!/bin/bash

##############
# TempAdmin.sh
# This script will give a user 30 minutes of Admin level access.
# It is designed to create its own offline self-destruct mechanism.
# This probably isn't the best way to do it and this method copies fairly directly from
# https://www.jamf.com/jamf-nation/discussions/6990/temporary-admin-using-self-service
# v.1.1 - Matthew Bodaly May 2017
# yourfuneral ¯\_(ツ)_/¯
##############

# get currently logged in user #
loggedInUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; loggedInUser = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; loggedInUser = [loggedInUser,""][loggedInUser in [u"loginwindow", None, u""]]; sys.stdout.write(loggedInUser + "\n");'`

# create LaunchDaemon to remove admin rights #
echo "<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Disabled</key>
    <true/>
    <key>Label</key>
    <string>com.yourcompany.adminremove</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Library/Scripts/removeTempAdmin.sh</string>
    </array>
    <key>StartInterval</key>
    <integer>1800</integer>
</dict>
</plist>" > /Library/LaunchDaemons/com.yourcompany.adminremove.plist
#####

# create admin rights removal script #
# Changed the variable here from loggedInUser to USER to logically keep things
echo '#!/bin/bash
USER=`cat /var/somelogfolder/userToRemove`
/usr/sbin/dseditgroup -o edit -d $USER -t user admin
rm -f /var/somelogfolder/userToRemove
rm -f /Library/LaunchDaemons/com.yourcompany.adminremove.plist
rm -f /Library/Scripts/removeTempAdmin.sh
exit 0'  > /Library/Scripts/removeTempAdmin.sh
#####

# set the permission on the files just made
# These were originally set to 644 and 755 respectively
chown root:wheel /Library/LaunchDaemons/com.yourcompany.adminremove.plist
chmod 777 /Library/LaunchDaemons/com.yourcompany.adminremove.plist
chown root:wheel /Library/Scripts/removeTempAdmin.sh
chmod 777 /Library/Scripts/removeTempAdmin.sh

# enable and load the LaunchDaemon
defaults write /Library/LaunchDaemons/com.yourcompany.adminremove.plist Disabled -bool false
launchctl load -w /Library/LaunchDaemons/com.yourcompany.adminremove.plist

# build log files in /var/somelogfolder
mkdir /var/somelogfolder
TIME=`date "+Date:%m-%d-%Y TIME:%H:%M:%S"`
echo $TIME " by " $loggedInUser >> /var/somelogfolder/30minAdmin.txt

# note the user
echo $loggedInUser >> /var/somelogfolder/userToRemove

# give current logged user admin rights
/usr/sbin/dseditgroup -o edit -a $loggedInUser -t user admin

# notify
/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -icon /Applications/Utilities/Keychain\ Access.app/Contents/Resources/Keychain_Unlocked.png -heading 'Temporary Admin Rights Granted' -description "
Please use responsibly.
All administrative activity is logged.
Access expires in 30 minutes." -button1 'OK' > /dev/null 2>&1 &

exit 0
