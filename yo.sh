#!/usr/bin/python

import subprocess
from SystemConfiguration import SCDynamicStoreCopyConsoleUser

current_user = SCDynamicStoreCopyConsoleUser(None, None, None)[0]
notification = '/Applications/Utilities/yo.app/Contents/MacOS/yo --title "IT Alert" --info "Updates required." --icon /Library/Application\ Support/CPE/share/DeathTaco.png'
cmd = ['/usr/bin/su', '-l', current_user, '-c', notification]
subprocess.call(cmd)
