#!/bin/bash
# if the Casper Support folder exists. If it does not exist, create it
# need to create a wait loop to detect Internet connection before starting
# if the RedRover folder exists. If it does not exist, create it
if [ ! -d /Library/Application\ Support/RedRover/ ]
then
sudo mkdir /Library/Application\ Support/RedRover/
sudo mkdir /Library/Application\ Support/RedRover/history
sudo chmod 777 /Library/Application\ Support/RedRover/
echo "I created the RedRover folders" >> /Library/Application\ Support/RedRover/redroverlog
else
echo "I didn't need to create the RedRover folders because it already existed" >> /Library/Application\ Support/RedRover/redroverlog
fi
# this section downloads the MD5 to run
curl https://raw.github.com/matthewbodaly/rawrscripts/master/rrmd5 > /Library/Application\ Support/RedRover/rrmd5current
echo "I downloaded the MD5 from GitHub" >> /Library/Application\ Support/RedRover/redroverlog
# this section looks for the MD5 if the file is already on the computer, compares it, and downloads the latest version if needed
if [ ! -f /Library/Application\ Support/RedRover/redrovermd5]
then
curl https://raw.github.com/matthewbodaly/rawrscripts/master/redrover.sh > /Library/Application\ Support/RedRover/redrover.sh
md5 /Library/Application\ Support/RedRover/redrover.sh > /Library/Application\ Support/RedRover/redrovermd5
echo "I downloaded the script from GitHub" >> /Library/Application\ Support/RedRover/redroverlog
chmod +x /Library/Application\ Support/RedRover/redrover.sh
else
MD5=$(more /Library/Application\ Support/RedRover/redrovermd5)
MD52=$(more /Library/Application\ Support/RedRover/rrmd5current)
fi
# this section checks the two md5 files. if they are different, the file will download. If they are not, exit.
if [ "$MD5" != "$MD52" ]
then 
curl https://raw.github.com/matthewbodaly/rawrscripts/master/redrover.sh > /Library/Application\ Support/RedRover/redrover.sh
echo "I downloaded the script from GitHub" >> /Library/Application\ Support/RedRover/redroverlog
chmod +x /Library/Application\ Support/RedRover/redrover.sh
md5 /Library/Application\ Support/RedRover/redrover.sh > /Library/Application\ Support/RedRover/redrovermd5
fi
#this section creates the login hook to run the script every login
defaults write com.apple.loginwindow LoginHook /Library/Application\ Support/RedRover/redrover.sh
