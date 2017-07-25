#!/bin/bash

WORKDIR=$(dirname $0)
APP="$WORKDIR/Install macOS Sierra-10.12.5.app"

if [[ -d "$APP" ]]; then
    logger -s "Starting  Sierra InPlace Upgrade..."

     "$APP/Contents/Resources/startosinstall" --applicationpath "$APP" --agreetolicense --rebootdelay 10 --nointeraction
     sleep 5

     logger -s "Shutting Down osinstallersetupd Process.."
     sudo killall "osinstallersetupd" 2>/dev/null

     logger -s "Beginning Authenticated Reboot..."
     /usr/bin/fdesetup authrestart -inputplist < "$WORKDIR/authrestart.plist"
else
    logger -s "$APP not found.  Aborting..."
    exit 1
fi

exit 0
#!/bin/bash
# This looks familiar to this: https://www.jamf.com/jamf-nation/discussions/22731/in-place-macos-sierra-upgrade-script#responseChild148130
# Variables
loggedInUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
AppPath="/Applications/Install macOS Sierra.app"
logger -s "Starting  Sierra InPlace Upgrade..."
"$AppPath/Contents/Resources/startosinstall" --agreetolicense --rebootdelay 10 --nointeraction
sleep 5
logger -s "Shutting Down osinstallersetupd Process.."
sudo killall "osinstallersetupd" 2>/dev/null
logger -s "Beginning Authenticated Reboot..."
/usr/bin/fdesetup authrestart -inputplist < "$WORKDIR/authrestart.plist"
#sudo -u "$loggedInUser" /Applications/Install\ macOS\ Sierra.app/Contents/Resources/startosinstall --applicationpath "$AppPath" --rebootdelay 10 --nointeraction
exit 0
