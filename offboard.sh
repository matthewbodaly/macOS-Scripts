#!/bin/bash
#yourfuneral
# theres a better way to do this most likely and I need to add some verification in the end... anyways... this did the thing i wanted to at the time.
#this will offboard someone right quick.
# VARIABLES
now=$(date +"%F-%T")
password=$(openssl rand -base64 12)

#create logfile
touch ./$now.log
echo "Process started $now" >> ./$now.log
echo "Password used for this session is $password" >> ./$now.log
#ask for inputs
read -p "What is the email address to process?" email
echo "You entered $email"
echo "$email was entered" >> ./$now.log
read -p "What is the email address of the manager?" manager
echo "You entered $manager"
echo "$manager was entered as the manager"
# Verify Data to go here

#PROGRAM 
#Password Reset
gam update user $email password $password
echo "Password has been changed" >> ./$now.log
gam update user $email changepassword on
echo "Password changed on next login enabed right quick once" >> ./$now.log
sleep 2
echo "Waiting" >> ./$now.log
gam update user $email changepassword off
echo "Disabling password change" >> ./$now.log
#Backup Codes
gam user $email deprovision
echo "$email deprovisioned and oath tokens disabled" >> ./$now.log
gam user $email update backupcodes
echo "Generate a new set of backup codes" >> ./$now.log
#Delegates data goes here
#Disable and hide from the directory
gam user $email forward off
echo "Forwarding disabled" >> ./$now.log
gam user $email imap off
gam user $email pop off
echo "IMAP / POP disabled" >> ./$now.log
gam user $email gal off
echo "Removed from the GAL" >> ./$now.log
#Transfer data to manager
gam create datatransfer $email gdrive $manager
echo "$manager data transfer started" >> ./$now.log
#Transfer email to manager
gam user $email delegate to $manager
echo "$manager is now a delegate of $email" >> ./$now.log
#Transfer user to Former Employees OU
gam update org 'Former Employees' add users $email
echo "$email now in a new OU" >> ./$now.log
#Disable 2FA
gam user $email turnoff2sv
echo "2FA devices disabled" >> ./$now.log
#Remove user from all groups
gam user $email delete groups
echo "$email has been removed from all groups" >> ./$now.log
#Delete calendar
# gam calendar $email wipe
echo "Placeholder about the calendar" >> ./$now.log
exit 0
