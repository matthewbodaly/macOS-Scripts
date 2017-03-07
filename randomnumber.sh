#!/bin/bash
# Generate a random number. This is used best when you want break up computers into groups for testing. 
# Use with a reporting app to read the number and sort your computers
# For an example of that, refer to:
# https://gist.github.com/matthewbodaly/7a6cfabb74d896ca609bca9f62226463
# v 1.0
# Matthew Bodaly - March 2017
mkdir /Library/Application\ Support/XXX/
sudo echo $((1 + RANDOM % 3)) > /Library/Application\ Support/XXX/digit.txt
