#!/bin/bash

GNS_CONF="gns3_server.conf"
GNS_USERNAME="student88"
GNS_PASSWORD="QAX443z"
GNS_PORT="3080"

function packageManagement()
{
  apt update -y
  apt upgrade -y
  apt install -y $(cat packagelist)
  apt update -y
  apt upgrade -y
}

function gitPackages()
{
  git clone -b 2.1 https://github.com/GNS3/gns3-server.git
  cd gns3-server
  python3 setup.py install
  cd ..
  
  git clone https://github.com/GNS3/ubridge.git
  cd ubridge
  make
  make install
  cd ..
  
  git clone git://github.com/GNS3/dynamips
  cd dynamips
  mkdir build
  cmake ..
  make install
}
  
function configGNS()
{
  mkdir -p /root/.config/GNS3/
  cp /root/gns3-server/conf/$GNS_CONF /root/.config/GNS3/$GNS_CONF
  sed -i "s/^auth = False.*$/auth = True/" /root/.config/GNS3/$GNS_CONF
  sed -i "s/^user = gns3.*$/user = $GNS_USERNAME/" /root/.config/GNS3/$GNS_CONF
  sed -i "s/^password = gns3.*$/password = $GNS_PASSWORD/" /root/.config/GNS3/$GNS_CONF
  }
  
function configUFW()
{
  ufw allow $GNS_PORT
}
  
packageManagement
gitPackages
configGNS
configUFW
