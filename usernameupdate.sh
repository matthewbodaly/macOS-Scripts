#!/bin/bash
# Matthew Bodaly - 11 March 2024
#your funeral. There's probably a better way to do this.
loggedInUser=$(defaults read /Library/Preferences/com.apple.loginwindow lastUserName)
user_upn=$(/usr/bin/defaults read "/Users/$loggedInUser/Library/Preferences/com.jamf.connect.state.plist" DisplayName)
jamf recon -endUsername $user_upn
exit 0
