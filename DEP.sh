#!/bin/sh
defaults write /Library/Preferences/com.apple.MCXDebug debugOutput -2
defaults write /Library/Preferences/com.apple.MCXDebug collateLogs 1
touch /var/db/MDM_EnableDebug
rm /var/db/.AppleSetupDone
rm -rf /var/db/ConfigurationProfiles/
rm /Library/Keychains/apsd.keychain
jamf removeFramework
shutdown -r now
# Reboot the machine and re-enroll via DEP

#* Log is written to: /Library/Logs/ManagedClient/ManagedClient.log
