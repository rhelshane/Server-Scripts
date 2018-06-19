#!/bin/bash

source functions.sh 
source vars.sh

TARGET="rabbitmq-server"

#Set password
function setRabbitMQPassword()
{
  echo -e "Setting Rabbit-MQ password to $1...\c" 	
  return $(rabbitmqctl change_password guest $1 &>/dev/null)
}

#Run through installation
installPackage $TARGET
checkExit
checkPackageInstalled $TARGET
checkExit
enableService $TARGET
checkExit
startService $TARGET
checkExit
checkService $TARGET
checkExit
setRabbitMQPassword $RABBITMQ_PASS
checkExit
