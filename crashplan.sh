#!/bin/bash
# platform: os x
# applies to wan traffic only
# ¯\_(ツ)_/¯
CRASHPLAN_CONFIG_PATH="/Library/Application Support/CrashPlan/conf/my.service.xml"
CRASHPLAN_DAEMON_PATH="/Library/LaunchDaemons/com.crashplan.engine.plist"
​WAN_DEDUPE_THRESHOLD="104857600"
# 104857600 bytes (100MB)
​if [ -f "$CRASHPLAN_CONFIG_PATH" ] && [ -f "$CRASHPLAN_DAEMON_PATH" ]; then
    launchctl unload "$CRASHPLAN_DAEMON_PATH"
    sed -i ".bak" "s/<dataDeDupAutoMaxFileSizeForWan>[0-9][0-9]*<\/dataDeDupAutoMaxFileSizeForWan>/<dataDeDupAutoMaxFileSizeForWan>$WAN_DEDUPE_THRESHOLD<\/dataDeDupAutoMaxFileSizeForWan>/g" "$CRASHPLAN_CONFIG_PATH"
    launchctl load "$CRASHPLAN_DAEMON_PATH"
    currentUser=$(python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
    sudo -u "$currentUser" /Applications/CrashPlan.app/Contents/Helpers/CrashPlan\ menu\ bar.app/Contents/MacOS/./CrashPlan\ menu\ bar > /dev/null 2>&1 &
fi
