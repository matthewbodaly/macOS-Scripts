#!/bin/sh

## Shell script for managed Apple Software Updates
## courtesy acdesigntech @ https://jamfnation.jamfsoftware.com/discussion.html?id=5404
## updated by C.Hirtle on 19 August 2013
## Updated by Kilodelta (Will Green) on 25 April 2014
## Updated by matthewbodaly (Matthew Bodaly) on 15 May 2014

## Read in the parameters
echo "Reading Paramaters"
mountPoint=$1
computerName=$2
username=$3
postpones=$4			# sets number of times user can postpone updates before forcing down
# NonSysCore1=$5			# sets policy name of non system update group
# NonSysCore2=$6			# sets policy name of non system update group
# NonSysCore3=$7			# sets policy name of non system update group
# NonSysCore4=$8			# sets policy name of non system update group
# NonSysCore5=$9			# sets policy name of non system update group
# NonSysCore6=$10			# sets policy name of non system update group
# NonSysCore7=$11			# sets policy name of non system update group

######### Set variables for the script ############
#Check that Cocoa Dialog and Terminal Notifier Exist, install if needed.
echo "Checking for Cocoa Dialog and Terminal Notifier..."
if [ ! -e /Library/Application\ Support/caspersupport/cocoaDialog.app/Contents/MacOS/cocoaDialog ]; then
	echo "Cocoa Dialog Missing - Triggering installalerts"
	jamf policy -trigger installalerts
elif [ ! -e /Library/Application\ Support/caspersupport/terminal-notifier.app/Contents/MacOS/terminal-notifier ]; then
	echo "Terminal Notifier Missing - Triggering installalerts"
	jamf policy -trigger installalerts
else
	echo "Cocoa Dialog and Terminal Notifier are installed!"
fi

# # Path to cocoaDialog and TerminalNotifier (customize to your own location)
cdPath="/Library/Application Support/caspersupport/cocoaDialog.app/Contents/MacOS/cocoaDialog"
tnPath="/Library/Application Support/caspersupport/terminal-notifier.app/Contents/MacOS/terminal-notifier"
echo "Variables: cdPath is $cdPath"
echo "Variables: tnPath is $tnPath"
# Get minor version of OS X
osVers=$( sw_vers -productVersion | cut -d. -f2 )
echo "Variables: OS X Minor Version is is 10.$osVers"

# Set correct icons for OS
echo "Variables: Setting Icons"
	#Set appropriate Software Update icon depending on OS version
	if [[ "$osVers" -lt 8 ]]; then
		swuIcon="/System/Library/CoreServices/Software Update.app/Contents/Resources/Software Update.icns"
	else
		swuIcon="/System/Library/CoreServices/Software Update.app/Contents/Resources/SoftwareUpdate.icns"
	fi
	echo "Variables: SWU Icon is $swuIcon"

	#Set appropriate Restart icon depending on OS version
	if [[ "$osVers" == "9" ]]; then
		restartIcon="/System/Library/CoreServices/loginwindow.app/Contents/Resources/Restart.tiff"
	else
		restartIcon="/System/Library/CoreServices/loginwindow.app/Contents/Resources/Restart.png"
	fi
	echo "Variables: restart icon is $restartIcon"

	# set Done icon for Mac OS
	doneIcon="/System/Library/CoreServices/Installer.app/Contents/PlugIns/Summary.bundle/Contents/Resources/Success.tiff"

	# set Caution icon for Mac OS
	cautionIcon="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertCautionIcon.icns"

# Set JSS Address
JSSAddress="https://vm-corpcsp01.apptio.lan:8443"
echo "Variables: JSS Address is $JSSAddress"

# JSS User with read permissions in the API
JSSAPIauth="JSSAPIuser:asimplepassword"
echo "Variables: JSS API User was set"

# Set Minutes for Restart
minToRestart="240"

# Get the group membership for the client
	#First, Get MAC Address using networksetup
	MAC=$( networksetup -getmacaddress en0 | awk '{ print $3 }' | sed 's/:/./g' )
	echo "Variables: Mac Address is $MAC"
	echo "Getting JSS Group Membership..."
	#Then, Use the JSS API to get the Mac's group memberships
	JSSGroups=$( curl -s -u $JSSAPIauth $JSSAddress/JSSResource/computers/macaddress/$MAC \
		| xpath //computer/groups_accounts/computer_group_memberships[1] \
			| sed -e 's/<computer_group_memberships>//g;s/<\/computer_group_memberships>//g;s/<group>//g;s/<\/group>/\n/g' )
	echo "Variables: JSS Group Membership is $JSSGroups"

# Make sure there is a postponements limit set - if not, set to 5
if [[ "$postpones" != "" ]]; then
	## Run test to make sure we have a non floating point integer
	if [[ $(expr "$postpones" / "$postpones") == "1" ]]; then
		echo "Postpones set by parameter to $postpones and verified"
	else
		echo "Non integer, or a decimal value was passed. Setting reboot time to default (5)"
		postpones="5"
	fi
else
	postpones="5"
fi

# Create the timer if it doesn't exist, and get it's value.
if [ ! -e /Library/Application\ Support/caspersupport/.SoftwareUpdateTimer.txt ]; then
	echo "$postpones" > /Library/Application\ Support/caspersupport/.SoftwareUpdateTimer.txt
fi
Timer=`cat /Library/Application\ Support/caspersupport/.SoftwareUpdateTimer.txt`
echo "Variables: Timer is set to $Timer."

# Get the currently logged in user, if any.
LoggedInUser=`who | grep console | awk '{print $1}'`
echo "Variables: User Logged in is $LoggedInUser"

# Get lists for updates that require a restart and those that do not

	## Get updates list from SWU binary
	softwareupdate -l > /tmp/SWULIST

	## Process the actual lists we need from the Variable, for speed:
	UpdatesNoRestart=$( cat /tmp/SWULIST | grep recommended | grep -v restart )
	RestartRequired=$( cat /tmp/SWULIST| grep restart | grep -v '\*' | cut -d , -f 1 )
	UpdatesList=$( cat /tmp/SWULIST| grep recommended | grep -v '\*' | cut -d , -f 1 )

	echo "Variables: No Restart Updates are $UpdatesNoRestart"
	echo "Variables: Restart Required Updates are $RestartRequired"
	echo "All Reccomended Updates are $UpdatesList"

# Set NonSysCore groups from above into an array
NonSysCore=( '$NonSysCore1' '$NonSysCore2' '$NonSysCore3' '$NonSysCore4' '$NonSysCore5' '$NonSysCore6' '$NonSysCore7')
echo "NonSysCore groups are Set."

################ End Variable Set ################
#
################ Define Functions ################
##	Function to run when installations are complete
fDoneRestart ()
{
	echo "Entering fDoneRestart"
doneMSG="The installations have completed, but your Mac needs to reboot to finalize the updates.

Your Mac will automatically reboot in $minToRestart minutes. Begin to save any open work and close applications now."

##	Display initial message for 30 seconds before starting the progress bar countdown
"$cdPath" msgbox --title "Software Update > Complete" \
--text "Updates installed successfully" --informative-text "$doneMSG" \
--button1 "   OK   " --icon-file "$doneIcon" --posY top --width 450 --timeout 15

	##	Sub-function to (re)display the progressbar window. Developed to work around the fact that
	##	CD responds to Cmd+Q and will quit. The script continues the countdown. The sub-function
	##	causes the progress bar to reappear. When the countdown is done we quit all CD windows
	showProgress ()
	{

	##	Display progress bar
	"$cdPath" progressbar --title "Software Updates > Restart Imminent!" --text "Preparing to restart this Mac..."\
	--width 500 --height 90 --icon-file "$restartIcon" --icon-height 48 --icon-width 48 < /tmp/hpipe &

	##	Send progress through the named pipe
	exec 20<> /tmp/hpipe

	}

##	Close file descriptor 20 if in use, and remove any instance of /tmp/hpipe
exec 20>&-
rm -f /tmp/hpipe

##	Create the name pipe input for the progressbar
mkfifo /tmp/hpipe
sleep 0.2

## Run progress bar sub-function
showProgress

echo "100" >&20

timerSeconds=$((minToRestart*60))
startTime=$( date +"%s" )
stopTime=$((startTime+timerSeconds))
secsLeft=$timerSeconds
progLeft="100"

while [[ "$secsLeft" -gt 0 ]]; do
	sleep 1
	currTime=$( date +"%s" )
	progLeft=$((secsLeft*100/timerSeconds))
	secsLeft=$((stopTime-currTime))
	minRem=$((secsLeft/60))
	secRem=$((secsLeft%60))
	if [[ $(ps axc | grep "cocoaDialog") == "" ]]; then
		showProgress
	fi
	echo "$progLeft $minRem minutes, $secRem seconds until automatic reboot. Please save any work now." >&20
done

echo "Closing progress bar."
exec 20>&-
rm -f /tmp/hpipe

## Close cocoaDialog. This block is necessary for when multiple runs of the sub-function were called in the script
for process in $(ps axc | awk '/cocoaDialog/{print $1}'); do
	/usr/bin/osascript -e 'tell application "cocoaDialog" to quit'
done

##	Clean up by deleting the SWUList file in /tmp/
rm /tmp/SWULIST

##	Delay 1/2 second, then force reboot
sleep 0.5
shutdown -r now

}

fUpdateInventory () {
	echo "Entering fUpdateInventory"

	#Sub-function to show recon progress
	fShowReconProgress ()
	{
	echo "Displaying Recon progress bar window."
	"$cdPath" progressbar \
		--indeterminate --title "Software Updates > Updating JSS" \
			--icon sync --width 450\
				--text "Contacting JSS..." < /tmp/hpipe &

	##	Send progress through the named pipe
	exec 30<> /tmp/hpipe

	}

	# Kill any leftover pipes, and make a new one
	exec 30>&-
	rm -f /tmp/hpipe
	mkfifo /tmp/hpipe
	sleep 0.2

	## Run the install recon sub-function
	fShowReconProgress

	# Run Recon, send progress to pipe
	/usr/sbin/jamf recon 2>&1 | while read line; do
		##	Re-run the sub-function to display the cocoaDialog window and progress
		##	if we are not seeing 2 items for CD in the process list
		if [[ $(ps axc | grep "cocoaDialog" | wc -l | sed 's/^ *//') != "1" ]]; then
			killall cocoaDialog
			fShowReconProgress
		fi
		echo "10 $line" >&30
	done

	# now turn off the progress bar by closing file descriptor 30
	echo "Closing progress bar."
	exec 30>&-
	rm -f /tmp/hpipe

	##	Close all instances of cocoaDialog
	echo "Closing all cocoaDialog windows."
	for process in $(ps axc | awk '/cocoaDialog/{print $1}'); do
		/usr/bin/osascript -e 'tell application "cocoaDialog" to quit'
	done

	##	Kickoff Restart
		fDoneRestart
}


fRunUpdates ()
{
	echo "Entering fRunUpdates"
	##	Sub-function to display both a button-less CD window and a progress bar
	##	This sub routine gets called by the enclosing function. It can also be called by
	##	the install process if it does not see 2 instances of CD running
	fShowInstallProgress ()
	{

	##	Display button-less window above progress bar, push to background. Yes, the weird line formatting below is normal.
	"$cdPath" msgbox --no-newline --title "Software Updates > Installing" --text "Software Updates are Now Installing" --informative-text "Corp IT are installing software updates on your Mac. Please do not shut down your Mac or put it to sleep until the installs finish.

IMPORTANT:
Some updates require a restart, so we recommend saving any important documents now. Your Mac will reboot $minToRestart minutes after the updates are complete." --icon-file "$swuIcon" --width 450 --height 184 --posY top &

	##	Display progress bar
	echo "Displaying progress bar window."
	"$cdPath" progressbar --title "Software Updates > Progress" --text "Downloading Update Files..." \
	--posX "center" --posY 210 --width 450 --float --icon installer < /tmp/hpipe &

	##	Send progress through the named pipe
	exec 10<> /tmp/hpipe

	}

##	Close file descriptor 10 if in use, and remove any instance of /tmp/hpipe
exec 10>&-
rm -f /tmp/hpipe

##	Create the name pipe input for the progressbar
mkfifo /tmp/hpipe
sleep 0.2

## Run the install progress sub-function (shows button-less CD window and progressbar)
fShowInstallProgress

##	Run softwareupdate in verbose mode for each selected update, parsing output to feed the progressbar
##	Set initial index loop value to 0; set initial update count value to 1; set variable for total updates count
	pkgTotal="${#UpdatesList[@]}"
	echo "Installing Updates..."
	softwareupdate --install --recommended --verbose 2>&1 | while read line; do
			##	Re-run the sub-function to display the cocoaDialog window and progress
			##	if we are not seeing 2 items for CD in the process list
			if [[ $(ps axc | grep "cocoaDialog" | wc -l | sed 's/^ *//') != "2" ]]; then
				killall cocoaDialog
				fShowInstallProgress
			fi
			pct=$( echo "$line" | awk '/Progress:/{print $NF}' | cut -d% -f1 )
			echo "$pct Installing Software Updates..." >&10
		done

echo "Closing progress bar."
exec 10>&-
rm -f /tmp/hpipe

##	Close all instances of cocoaDialog
echo "Closing all cocoaDialog windows."
for process in $(ps axc | awk '/cocoaDialog/{print $1}'); do
	/usr/bin/osascript -e 'tell application "cocoaDialog" to quit'
done

##	Kickoff Recon
	fUpdateInventory
}
################ End Functions ################

################ Check for Non-Apple Updates #######################
# Use echo and grep to find known-core (non system) software update groups. If these groups are found, run these installers silently since no restarts are required for these updates.
# Use an array to see which updates we take account of. The names of the array elements are also trigger names for each update.
# This way when there's a new software package to keep updated, we add the trigger name into the array, and the update policy to the JSS. Casper does the rest!
echo "Checking for NonSysCore updates..."
for (( i = 0; i < ${#NonSysCore[@]}; i++ ))
do
	CheckUpdate=`echo "$JSSGroups" | grep "${NonSysCore[$i]}"`
	if [ "$CheckUpdate" != "" ]; then
		jamf policy -trigger "${NonSysCore[$i]}"
	fi
done

################ End Check for Non-Apple Updates #######################
echo "Entering Core Script..."
## If there are no system updates, quit
if [ "$UpdatesNoRestart" == "" -a "$RestartRequired" == "" ]; then
	echo "No updates at this time"
	exit 0
fi

## If we get to this point and beyond, there are updates. Check to see if there is a timer file on the Mac. This file tells the script how many more times it is allowed to be canceled by the user before forcing updates to install
if [ ! -e /Library/Application\ Support/caspersupport/.SoftwareUpdateTimer.txt ]; then
	echo "$postpones" > /Library/Application\ Support/caspersupport/.SoftwareUpdateTimer.txt
fi

## if there is no one logged in, just run the updates
if [ "$LoggedInUser" == "" ]; then
	echo "No user logged in, apparently. Running SoftwareUpdate."
	softwareupdate --install --recommended
else
	if [ $Timer -gt 0 ]; then
		echo "Postpones are not exhausted. Line 148"
			## If someone is logged in and they have not canceled X times already, prompt them to install updates that require a restart and state how many more times they can press 'Postpone' before updates run automatically.
		if [ "$RestartRequired" != "" ]; then
			echo "Restart required is not null. Prompting user via CocoaDialog"
			cdResponse=`"$cdPath" msgbox --no-newline --title "Software Updates Available" --text "Your Mac Has Updates Pending That Requre A Restart" --informative-text "If you want to install these updates now, click Install. To postpone installing updates to a later time, click Postpone.

Updates available are:
$UpdatesList

You may choose to postpone the updates $Timer more times before your Mac will install them." --button1 "Install" --button2 "Postpone" --icon-file "$swuIcon" `
			echo "CocoaDialog result was $cdResponse";
			## If they click Install Updates then run the updates
			if [ "$cdResponse" == "1" ]; then
				fRunUpdates
			else
			## If no, then reduce the timer by 1. The script will run again the next day
				let CurrTimer=$Timer-1
				echo "User Postponed. Updating Timer file to $CurrTimer and exiting."
				echo "$CurrTimer" > /Library/Application\ Support/caspersupport/.SoftwareUpdateTimer.txt

				# Sanity Check: If timer is at 0, warn the user now and give them a chance to update before they are forced.
				if [[ $CurrTimer == "0" ]]; then
					cdResponse=`"$cdPath" msgbox --no-newline --title "Software Updates > Last Chance" --text "Are you sure about that?" --informative-text "If you postpone updates again, you WILL be forced to install them and reboot your Mac the next time you are prompted. You will not be able to postpone them again! That could prove be rather inconvenient.

Are you really sure you want to postpone again?" --button1 "Install Now" --button2 "Procrastinate" --icon-file "$cautionIcon" `
					echo "CocoaDialog Sanity check result was $cdResponse";
					if [[ $cdResponse == "1" ]]; then
						fRunUpdates
					elif [[ $cdResponse == "2" ]]; then
						"$tnPath" -title "Software Updates Postponed" \
								-message "Prepare yourself! Updates (and a forced reboot) are coming! They will install tomorrow." \
									-sender com.jamfsoftware.selfservice \
										-group 1441
					fi
				else
					"$tnPath" -title "Software Updates Postponed" \
						-subtitle "We'll ask again tomorrow" \
							-message "You may postpone for $CurrTimer more days" \
								-sender com.jamfsoftware.selfservice \
									-group 1441
				fi
				exit 1
			fi
		fi

## If Timer is already 0, force the updates - the user has been warned! To be nice, we'll tell them what's happening first.
	else
		echo "Postpones have been exhausted. Warning user and Forcing updates."
		"$cdPath" msgbox --no-newline --title "Software Updates Required" --text "Your Mac Has Updates Pending That Requre A Restart" --informative-text "Your Mac is required to install these updates now.

The updates are:
$UpdatesList

IMPORTANT:
You cannot postpone the updates any longer, and your Mac will restart when they complete.
Save your work now!" --button1 "   OK   " --icon-file "$swuIcon" --timeout 30
		fRunUpdates
	fi
fi

## Install updates that do not require a restart
if [ "$UpdatesNoRestart" != "" ]; then
	echo "Only updates do not require restart. Triggering softwareupdate"
	softwareupdate --install --recommended
	#Notify the user updates happened
	"$tnPath" -title "Updates Installed" \
		-message "IT has updated some software on your Mac. No restart is required." \
			-sender com.jamfsoftware.selfservice \
				-group 1441
fi
