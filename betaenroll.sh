#!/bin/bash
# Enroll a computer in a beta program. This is used best when you want break up computers into groups for testing.
# Use with a reporting app to read the number and sort your computers
# For an example of that, refer to:
# https://gist.github.com/d/7a6cfabb74d896ca609bca9f62226463
# v 1.0
# Matthew Bodaly - March 2017
# v 1.1
# Matthew Bodaly - June 2017
# v 1.1.1
# Matthew Bodaly - August 2017
# Use case: All this script does is drop a text file with a value for use for sorting computers later.
# For instance, a smart group made of random number 1 would have about 10% of the total fleet.
if [! -d "/Library/Application\ Support/XXX/" ]
then
    echo "Directory does not exist."
    mkdir /Library/Application\ Support/XXX/
else
    echo "Directory exists."
fi
if [! -f "/Library/Application\ Support/XXX/beta1.txt" ]
then
    echo "File does not exist."
    touch "/Library/Application Support/XXX/beta1.txt"
    echo "I made the file"

else
    echo "Directory exists."
fi
    echo "Enabling Beta 1"
    echo "yes" > /Library/Application\ Support/XXX/beta1.txt
    echo "Beta 1 Now enabled"
