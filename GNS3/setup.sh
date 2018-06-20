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

GNS_USER="student749"
GNS_PASS="vVx5611"
GNS_PORT="3082"
GNS_VERS="2.1.8"
SSH_PORT="22"

# Update packages via apt and install gns3-server via pip3
function installGNS3()
{
  apt update -y
  apt upgrade -y
  apt install -y $(cat packagelist)
  pip3 install gns3-server==$GNS_VERS
}


# Install the 32-bit version of dynamips (more stable)
function installDynamips()
{
  dpkg --add-architecture i386
  apt update -y
  apt install -y dynamips:i386
}


# Clone, build and install ubridge
function installUbridge()
{
  git clone https://github.com/GNS3/ubridge.git || echo "Error cloning ubridge."
  cd ubridge
  make
  make install
  cd $CURRENT_DIR
}


# Open ports in UFW
function configUFW()
{
  ufw allow $SSH_PORT
  ufw allow $GNS_PORT
  ufw allow 5000:6000/tcp
  ufw allow 5000:6000/udp
  ufw allow 10000:11000/tcp
  ufw allow 10000:11000/udp
  systemctl enable ufw
  ufw enable
}


# Update the GNS3 config file
function configureGNS3()
{
  mkdir $GNS_DIR $CONFIG_DIR $IMAGE_DIR $APPLIANCE_DIR $PROJECT_DIR || echo "Error making folders"
  sed -i "s/___USER___/$GNS_USER/" GNS3.conf
  sed -i "s/___PASS___/$GNS_PASS/" GNS3.conf	
  sed -i "s/___PORT___/$GNS_PORT/" GNS3.conf
  sed -i "s/___IMAGE_DIR___/$IMAGE_DIR/" GNS3.conf
  sed -i "s/___APPLIANCE_DIR___/$APPLIANCE_DIR/" GNS3.conf
  sed -i "s/___PROJECT_DIR___/$PROJECT_DIR/" GNS3.conf
  cp GNS3.conf $CONFIG_DIR || echo "Error copying GNS3.conf"
}


# Run the functions 
installGNS3
installDynamips
installUbridge
configUFW
configureGNS3
