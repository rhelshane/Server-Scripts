#!/bin/bash
#This script automates the installation of GNS3.

IMAGE_DIR="/root/GNS3/Images"
APPLIANCE_DIR="/root/GNS3/Appliances"
PROJECT_DIR="/root/GNS3/Project"
GNS_USER="student88"
GNS_PASS="QED314"

function installGNS3()
{
  apt update -y
  apt upgrade -y
  apt install -y $(cat packagelist)
  pip3 install gns3-server==2.1.8
}

function installDynamips()
{
  dpkg --add-architecture i386
  apt update -y
  apt install dynamips:i386
}

function installUbridge()
{
  apt install -y libpcap
  git clone https://github.com/GNS3/ubridge.git
  cd ubridge
  make
  make install
  cd ..
}

function disableUFW()
{
  systemctl stop ufw
  systemctl disable ufw
}

function configureGNS3()
{
  mkdir /root/GNS3 /root/.config
  mkdir $IMAGE_DIR $APPLIANCE_DIR $PROJECT_DIR
  sed -i "s/___USER___/$GNS_USER/" GNS3.conf
  sed -i "s/___PASS___/$GNS_PASS/" GNS3.conf	
  cp GNS3.conf /root/.config/
}

installGNS3
installDynamips
installUbridge
disableUFW
configureGNS3
