#!/bin/sh
# ABOUT THIS PROGRAM
#
# NAME
# GiveAdminRightsToUser.sh -- Add User to Administrative Group.
#
# SYNOPSIS
# sudo GiveAdminRightsToUser.sh
# sudo GiveAdminRightsToUser.sh <mountPoint> <computerName><currentUsername> <AdminUser>
#
# If the $AdminUser parameter is specified (parameter 4), this is the User
# that will be assigned administrative privileges on the target machine.
#
# Example values: AdminUser=""AdminUser1"
#
# If no parameter is specified for parameter 4, the hardcoded value in the script will be used.
#
# DESCRIPTION
# This script will add the User that will have administrative access on the machine.
# This script should be run after a machine has been bound to Active Directory.
# Run it "at reboot" if you are using with Casper Imaging.
#
# The <timeout> value can be used with a hardcoded value in the script, or read in as a parameter.
# Since the Casper Suite defines the first three parameters as (1)Mount Point, (2) Computer
# Name and (3) username, we are using the fourth parameter ($4) as the passable parameter.
#
###########################################################################
#########################
#
# HISTORY
#
# Version: 1
#
# - Created by Cem Baykara on January 31st, 2011
# (tweaked Casper ResourcesKit script)
#
#
###########################################################################
#########################
#
# DEFINE VARIABLES & READ IN PARAMETERS
#
###########################################################################
#########################


# HARDCODED VALUE FOR "AdminUser" IS SET HERE
AdminUser=""


# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 4 AND, IF SO, ASSIGN TO
"AdminUser"
if [ "$4" != "" ] && [ "$AdminUser" == "" ]; then
AdminUser=$4
fi



###########################################################################
#########################
# 
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
###########################################################################
#########################

if [ "$AdminUser" == "" ]; then
echo "Error: No AdminUser is specified."
exit 1
fi

echo "Giving User the admin priviliges..."
/usr/sbin/dseditgroup -o edit -a "$AdminUser" -t user admin