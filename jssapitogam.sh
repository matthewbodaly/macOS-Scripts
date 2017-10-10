#!/bin/bash
user="xxx"
pass="xxx"
response=$(curl https://jss.corp.doordash.com/JSSResource/computers/id/64 -u $user:$pass)
echo $response | /usr/bin/awk -F'<email_address>|</email_address>' '{print $2}'
