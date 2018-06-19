#!/bin/bash

source functions.sh

#Disable SELinux
checkSELinux
checkExit
disableSELinux
checkExit

#Update packages
updatePackages
checkExit

#Disable firewalld
checkService firewalld
checkExit
stopService firewalld
checkExit
disableService firewalld
checkExit
