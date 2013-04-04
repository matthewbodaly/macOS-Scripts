#!/bin/bash
# v1
# initial release
# 1.1
# added logfile creation and an MD5 check
# if the Casper Support folder exists. If it does not exist, create it
#sudo chmod 777 /Library/Application\ Support/caspersupport/
if [ -f /Library/Application\ Support/caspersupport ]
then
mkdir /Library/Application\ Support/caspersupport
echo "I created the Casper Support folder" > /Library/Application\ Support/caspersupport/redroverlog
else
echo "I didn't need to create the Casper Support folder because it already existed" > /Library/Application\ Support/caspersupport/redroverlog
fi
#if the History folder exists. If it does not exist, create it
if [ -f /Library/Application\ Support/caspersupport/history ]
then
mkdir /Library/Application\ Support/caspersupport/history
echo "I created the History folder" >> /Library/Application\ Support/caspersupport/redroverlog
else
echo "I didn't need to create the History folder because it already existed" >> /Library/Application\ Support/caspersupport/redroverlog
fi
# if the RedRover folder exists. If it does not exist, create it
if [ -f /Library/Application\ Support/RedRover/ ]
then
sudo mkdir /Library/Application\ Support/RedRover/
sudo mkdir /Library/Application\ Support/RedRover/history
sudo chmod 777 /Library/Application\ Support/RedRover/
echo "I created the RedRover folders" >> /Library/Application\ Support/caspersupport/redroverlog
else
echo "I didn't need to create the RedRover folders because it already existed" >> /Library/Application\ Support/caspersupport/redroverlog
fi
#this section downloads the script to be run
curl https://raw.github.com/matthewbodaly/rawrscripts/master/rrmd5 > /Library/Application\ Support/RedRover/rrmd5current
echo "I downloaded the MD5 from GitHub" >> /Library/Application\ Support/caspersupport/redroverlog
if [ -f /Library/Application\ Support/caspersupport/redrover.sh ]
then
curl https://raw.github.com/matthewbodaly/rawrscripts/master/redrover.sh > /Library/Application\ Support/caspersupport/redrover.sh
echo "I downloaded the script from GitHub" >> /Library/Application\ Support/caspersupport/redroverlog
else
echo "I didn't need to download the script from GitHub" >> /Library/Application\ Support/caspersupport/redroverlog
fi
md5 /Library/Application\ Support/caspersupport/redrover.sh > /Library/Application\ Support/caspersupport/redrovermd5
MD5=$(more /Library/Application\ Support/caspersupport/redrovermd5)
MD52=$(more /Library/Application\ Support/RedRover/rrmd5current)
if [ "$MD5" != "$MD52" ]
then
cp /Library/Application\ Support/caspersupport/redrover.sh /Library/Application\ Support/RedRover/redrover.sh
echo "I copied the latest script to the right place" >> /Library/Application\ Support/caspersupport/redroverlog
else
echo "I didn't need to copy anything" >> /Library/Application\ Support/caspersupport/redroverlog
fi
#this section creates the login hook to run the script every login
defaults write com.apple.loginwindow LoginHook /Library/Application\ Support/RedRover/redrover.sh
