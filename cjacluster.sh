#!/bin/sh
# quick setup of a JSS
# copy working files over to /tmp
# run updates
sudo apt-get -y update
# install needed packages
sudo apt-get install -y tomcat7
# copy the files over from the installer section FIRST
sudo cp /tmp/green.war /var/lib/tomcat7/webapps/
sudo cp /tmp/yellow.war /var/lib/tomcat7/webapps/
# change ownership just in case. Probably don't need to do this.
sudo chown -R tomcat7:tomcat7 /var/lib/tomcat7/
# remove the ROOT app
sudo rm -rf /var/lib/tomcat7/webapps/ROOT
# make directories for use later
sudo mkdir /var/lib/tomcat7/keystore
sudo mkdir /var/lib/tomcat7/logs/{yellow, green}
# restart tomcat
sudo service tomcat7 restart
# generate keystore. modify this as needed.
sudo keytool -genkey -alias tomcat -keyalg RSA -keypass "babytownfrolics" -dname "CN=ubuntu102.jamfsw.com, OU=MBSOFT, O=MB, L=xx, ST=XX, C=US" -keystore /var/lib/tomcat7/keystore/keystore.jks -validity 365 -keysize 2048 -ext san=dns:jss.jamfsw.com,ip:192.168.56.101,ip:192.168.56.102,ip:192.168.56.105
sudo keytool -certreq -keyalg RSA -alias tomcat -keystore /var/lib/tomcat7/keystore/keystore.jks -ext san=dns:jss.jamfsw.com,ip:192.168.56.101,ip:192.168.56.102,ip:192.168.56.105 -file /var/lib/tomcat7/keystore/certreq.csr
# show the CSR (so it can be copied
more /var/lib/tomcat7/keystore/certreq.csr
# make sure you copied the certs into the right spot. just sayin
# sudo cp /tmp/ca.pem /var/lib/tomcat7/keystore/
# sudo cp /tmp/webcert.pem /var/lib/tomcat7/keystore/

# could likely automate copying log4j.properties, server.xml files to the other computer after configuring the first one
# could likely also copy the keystore
# sudo keytool -import -alias root -keystore /var/lib/tomcat7/keystore/keystore.jks -trustcacerts -file /var/lib/tomcat7/keystore/ca.pem
# sudo keytool -import -alias tomcat -keystore /var/lib/tomcat7/keystore/keystore.jks -trustcacerts -file /var/lib/tomcat7/keystore/webcert.pem
