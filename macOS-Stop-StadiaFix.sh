#!/bin/sh
#
# yourfuneral
# Stadia on the Mac works best when AirDrop is disabled and AWDL is disabled as well. Heres a script that disalbes the settings (so you don't have to use an app) and another one that will reenable the settings. 
# This script should be run with sudo permissions
# There's a fair bit in here that could be considered overkill and it will change system settings.
# If you have any of these values managed via JAMF or have a config manager that manages these settings, this script probably won't change the settings or if it does change settings, they will be reverted after a reboot.
# There's probably a better way to do this.
# 
### Variables and Prerequisites
loggedInUser=$( scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }' )
uuid=$( /usr/sbin/ioreg -d2 -c IOPlatformExpertDevice | awk -F '/IOPlatformUUID/{print $(NF-1)}' )
###
# Enable AirDrop
defaults write /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.NetworkBrowser.plist DisableAirDrop -bool NO

###
# Enable AWDL
ifconfig awdl0 up

### 
# Disable Handoff
# I'm not sure if this actually has much to do with interference and likely could be removed
defaults write "$loggedInUser/Library/Preferences/ByHost/com.apple.coreservices.useractivityd.plist" ActivityAdvertisingAllowed -bool yes
###
# Disable Location services
# You might want to double check this and the Time Zone settings after running this.
# You can run that command with "read" instead of write to verify the settings and it will show as 0. 1 Will show if it is enabled. 

/usr/bin/defaults write /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd LocationServicesEnabled -int 1


