#!/bin/bash
# taken from getmacapps
# used to create a payload free package
# probably should do this another way
# v1 - Matthew Bodaly
# v1.5 will have more things
mkdir ~/getmacapps_temp
cd ~/getmacapps_temp

# Installing Firefox
curl -L -o Firefox.dmg "http://download.mozilla.org/?product=firefox-latest&os=osx&lang=en-US"
hdiutil mount -nobrowse Firefox.dmg
cp -R "/Volumes/Firefox/Firefox.app" /Applications
hdiutil unmount "/Volumes/Firefox"
rm Firefox.dmg
