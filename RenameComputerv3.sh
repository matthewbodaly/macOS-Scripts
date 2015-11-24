#!/bin/bash

################################## DOCUMENTATION ###################################
#
#            Name:  renamecomputer.sh
#     Description:  Renames computer to something that you want instead of say... the serial number.
#          Author: Matthew Bodaly https://github.com/matthewbodaly
#                   Serious credits to Elliot Jordan <elliot@lindegroup.com> as you might recognize the template
#         Created: 24 November 2015
#   Last Modified: 24 November 2015
#         Version:  1
#
################################## VARIABLES ###################################

COMPANY_NAME="Concur"

# Your company's logo, in PNG format. (For use in jamfHelper messages.)
# Use standard UNIX path format:  /path/to/file.png
LOGO_PNG="/Library/Application Support/Concur/concurlogo1.png"

# Your company's logo, in ICNS format. (For use in AppleScript messages.)
# Use colon-separated AppleScript path format, omit leading colon:  path:to:file.icns
LOGO_ICNS="Library:Application Support:Concur:concurlogo1.icns"

# The title of the message that will be displayed to the user. Not too long, or it'll get clipped.
PROMPT_HEADING="Rename This Computer"

# The body of the message that will be displayed to the user.
PROMPT_MESSAGE="This computer needs a new name. Please follow the $COMPANY_NAME IT naming method.

Click the Next button below, then enter the computer name."

# Path to jamfHelper.
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"

######################### DO NOT EDIT BELOW THIS LINE ##########################

######################## VALIDATION AND ERROR CHECKING #########################

# Make sure the custom logo has been received successfully if not, download it.
if [[ ! -f "/${LOGO_ICNS//://}" ]]; then
    echo "[ERROR] Custom icon not present: /${LOGO_ICNS//://}"
    sudo jamf policy -trigger logos
fi

# Get the logged in user's name
userName="$(/usr/bin/stat -f%Su /dev/console)"
currentUser=$(python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')

################################# MAIN PROCESS #################################

# Force an unbind
dsconfigad -force -remove -u user -p babytownfrolics

# Display a branded prompt explaining the prompt.
echo "Alerting user ${userName} about incoming prompt..."
"$jamfHelper" -windowType hud -windowPosition ur -lockHUD -icon "$LOGO_PNG" -heading "$PROMPT_HEADING" -description "$PROMPT_MESSAGE" -button1 "Next" -defaultButton 1 -startlaunchd

# Get the computername via a prompt
echo "Prompting ${userName} for the computer name..."
ComputerName="$(/usr/bin/osascript -e 'tell application "System Events" to display dialog "Please enter the computer name:" default answer "" with title "Computer Name" with text buttons {"OK"} default button 1 with icon file "'"${LOGO_ICNS//\"/\\\"}"'"' -e 'text returned of result')"

# Write the variable to a text file also. This can be called up elsewhere.
echo "Writing Variable"
echo $ComputerName > /Library/Application Support/Concur/assettag.txt

echo "Setting Variables"
# Change the HostName to the variable
# scutil --set HostName $ComputerName
# Change the localHostName to the variable
# scutil --set LocalHostName $ComputerName
# Change the ComputerName to the variable
# scutil --set ComputerName $ComputerName
# change the Bonjour name
# systemsetup -setlocalsubnetname $ComputerName
# Write the variable to the end of /etc/hostconfig. This uses the FQDN. If you have a FQDN... you should change this.
# echo HOSTNAME=$ComputerName.concur.concurtech.org >> /etc/hostconfig
sudo jamf setComputerName -name $ComputerName

# Run JAMF recon
# If this runs as part of the initial setup... could be a moot point. Keeping this in here for later.
# sudo jamf recon
