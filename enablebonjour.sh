#!/bin/bash

# Set group name to check against
groupname=”domain users”

if [ "`/usr/bin/dsmemberutil checkmembership -U $@ -G $groupname`" == "user is a member of the group" ]; then
/usr/bin/dscl . merge /Groups/admin GroupMembership $@
filaunchctl load -w /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist