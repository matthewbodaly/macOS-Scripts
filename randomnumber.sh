#!/bin/bash
# Generate a random number. This is used best when you want break up computers into groups for testing.
# Use with a reporting app to read the number and sort your computers
# For an example of that, refer to:
# https://gist.github.com/matthewbodaly/7a6cfabb74d896ca609bca9f62226463
# v 1.0
# Matthew Bodaly - March 2017
# v 1.1
# Matthew Bodaly - June 2017
# v 1.1.1
# Matthew Bodaly - July 2017
# Use case: All this script does is generate a random number between 1 and 10. From this point, an extension attribute (if you have Jamf Pro) reads the digit
# Once you have a random number, you can shard the fleet.
# For instance, a smart group made of random number 1 would have about 10% of the total fleet.
if [! -d "/Library/Application\ Support/XXX/" ]
then
    echo "Directory does not exist."
    mkdir /Library/Application\ Support/XXX/
else
    echo "Directory exists."
fi
if [! -f "/Library/Application\ Support/XXX/digit.txt" ]
then
    echo "file does not exist."
    touch /Library/Application\ Support/XXX/digit.txt
    echo "I made the file"
else
    echo "File exists."
fi
echo $((1 + RANDOM % 10)) > /Library/Application\ Support/XXX/digit.txt
