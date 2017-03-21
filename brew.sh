#!/bin/sh
#Getting Username
user=``python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'``

#Modifying permissions and creating directories
chmod g+rwx /usr/local
chgrp admin /usr/local
mkdir /Library/Caches/Homebrew
chmod g+rwx /Library/Caches/Homebrew
chown -R $user /Library/Caches
chmod g+rwx /usr/local/bin
chgrp admin /usr/local/bin

#Downlading and installing Homebrew
cd /usr/local
git init -q
git config remote.origin.url https://github.com/Homebrew/homebrew
git fetch origin master:refs/remotes/origin/master -n
git reset --hard origin/master
chown -R $user $(ls | grep -v bin)
chown $user /usr/local/bin/brew
chgrp admin /usr/local/bin/brew

#Creating .bash_profile with new path but checking there isn't one already
if [ ! -f /Users/$user/.bash_profile ]; then
    sudo -u $user echo "PATH=/usr/local/bin:$PATH" >> /Users/$user/.bash_profile
fi
