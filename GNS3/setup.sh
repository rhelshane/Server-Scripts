#!/bin/bash
# GNS3 Server Configurator 06/20/2018
# This script automates the installation of a GNS3 Server on Ubuntu 18.04 LTS.
# Ensure the directories, credentials and ports specified in the variables below are 
# what you want.


# Declare variables
CURRENT_DIR=$(pwd)
IMAGE_DIR="$HOME/GNS3/Images"
APPLIANCE_DIR="$HOME/GNS3/Appliances"
PROJECT_DIR="$HOME/GNS3/Project"

GNS_USER="student749"
GNS_PASS="vVx5611"
GNS_PORT="3082"


# Update packages via apt and install gns3-server via pip3
function installGNS3()
{
  apt update -y
  apt upgrade -y
  apt install -y $(cat packagelist)
  pip3 install gns3-server==2.1.8
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
  git clone https://github.com/GNS3/ubridge.git
  cd ubridge
  make
  make install
  cd $CURRENT_DIR
}


# Open ports in UFW
function configUFW()
{

  ufw allow 22
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
  mkdir $HOME/GNS3 /root/.config
  mkdir $IMAGE_DIR $APPLIANCE_DIR $PROJECT_DIR
  sed -i "s/___USER___/$GNS_USER/" GNS3.conf
  sed -i "s/___PASS___/$GNS_PASS/" GNS3.conf	
  sed -i "s/___PORT___/$GNS_PORT/" GNS3.conf
  sed -i "s/___IMAGE_DIR___/$IMAGE_DIR/" GNS3.conf
  sed -i "s/___APPLIANCE_DIR___/$APPLIANCE_DIR/" GNS3.conf
  sed -i "s/___PROJECT_DIR___/$PROJECT_DIR/" GNS3.conf
  cp GNS3.conf $HOME/.config/
}


# Run the functions 
installGNS3
installDynamips
installUbridge
configUFW
configureGNS3
