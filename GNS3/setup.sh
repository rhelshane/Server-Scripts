#!/bin/bash
# GNS3 Server Configurator 06/20/2018
# This script automates the installation of a GNS3 Server on Ubuntu 18.04 LTS.
# Ensure the directories, credentials and ports specified in the variables below are 
# what you want.


# Declare variables
CURRENT_DIR=$(pwd)
GNS_DIR="$HOME/GNS3"
IMAGE_DIR="$HOME/GNS3/Images"
APPLIANCE_DIR="$HOME/GNS3/Appliances"
PROJECT_DIR="$HOME/GNS3/Project"
CONFIG_DIR="$HOME/.config"
LOG_FILE="install.log"

GNS_USER="student749"
GNS_PASS="vVx5611"
GNS_PORT="3082"
GNS_VERS="2.1.8"
SSH_PORT="22"

# Check whether package is installed and in path
function checkSuccess()
{
  which $1 >> /dev/null && echo "Success!"
} 

# Update packages via apt and install gns3-server via pip3
function installGNS3()
{
  echo "####### Installing GNS3" | tee -a $LOG_FILE
  apt-get update -y -q >> $LOG_FILE
  apt-get upgrade -y -q >> $LOG_FILE
  apt-get install -y -q $(cat packagelist) >> $LOG_FILE
  pip3 install -q gns3-server==$GNS_VERS >> $LOG_FILE
  checkSuccess gns3server
}


# Install the 32-bit version of dynamips (more stable)
function installDynamips()
{
  echo "###### Installing dynamips" | tee -a $LOG_FILE
  dpkg --add-architecture i386 >> $LOG_FILE
  apt-get update -y -q >> $LOG_FILE
  apt-get install -y -q dynamips:i386 >> $LOG_FILE
  checkSuccess dynamips
}


# Clone, build and install ubridge
function installUbridge()
{
  echo "###### Installing ubridge" | tee -a $LOG_FILE
  git clone -q https://github.com/GNS3/ubridge.git || echo "Error cloning ubridge."
  cd ubridge
  make >> $LOG_FILE
  make install >> $LOG_FILE
  cd $CURRENT_DIR
  checkSuccess ubridge
}


# Open ports in UFW
function configUFW()
{
  echo "###### Configuring UFW" | tee -a $LOG_FILE
  ufw allow $SSH_PORT >> $LOG_FILE
  ufw allow $GNS_PORT >> $LOG_FILE
  ufw allow 5000:6000/tcp >> $LOG_FILE
  ufw allow 5000:6000/udp >> $LOG_FILE
  ufw allow 10000:11000/tcp >> $LOG_FILE
  ufw allow 10000:11000/udp >> $LOG_FILE
  systemctl enable ufw >> $LOG_FILE
  ufw --force enable >> $LOG_FILE
}


# Update the GNS3 config file
function configureGNS3()
{
  echo "###### Configuring GNS3" | tee -a $LOG_FILE
  mkdir $GNS_DIR $CONFIG_DIR $IMAGE_DIR $APPLIANCE_DIR $PROJECT_DIR || echo "Error making folders"
  sed -i "s/___USER___/$GNS_USER/" GNS3.conf
  sed -i "s/___PASS___/$GNS_PASS/" GNS3.conf	
  sed -i "s/___PORT___/$GNS_PORT/" GNS3.conf
  sed -i "s@___IMAGE_DIR___@$IMAGE_DIR@" GNS3.conf
  sed -i "s@___APPLIANCE_DIR___@$APPLIANCE_DIR@" GNS3.conf
  sed -i "s@___PROJECT_DIR___@$PROJECT_DIR@" GNS3.conf
  cp GNS3.conf $CONFIG_DIR || echo "Error copying GNS3.conf"
}


# Run the functions 
installGNS3
installDynamips
installUbridge
configUFW
configureGNS3
