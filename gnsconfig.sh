#!/bin/bash

GNS_CONF="gns3_server.conf"
GNS_USERNAME="student88"
GNS_PASSWORD="QAX443z"
GNS_PORT="3080"

function packageManagement()
{
  apt update -y
  sudo apt upgrade -y 
  sudo apt install -y python-dev python3-dev \ 
    python-jsonschema python-psutil python3-setuptools \
    gcc libdpkg-perl dynamips libpcap-dev make  
  apt update -y 
  sudo apt upgrade
}

function gitPackages()
{
  git clone https://github.com/GNS3/gns3-server.git
  cd gns3-server.git
  python3 setup.py install
  cd ..
  git clone https://github.com/GNS3/ubridge.git
  cd ubridge
  make
  make install
}

function configGNS()
{
  cp /root/gns3-server/conf/$GNS_CONF /root/.config/GNS3/
  sed -i "s/^auth = False.*$/auth = True/" /root/.config/GNS3/$GNS_CONF
  sed -i "s/^user = gns3.*$/user = $GNS_USERNAME/" /root/.config/GNS3/$GNS_CONF
  sed -i "s/^password = gns3.*$/password = $GNS_PASSWORD/" /root/.config/GNS3/$GNS_CONF
}

function configUFW()
{
  sudo ufw allow $GNS_PORT
}

packageManagement
gitPackages
configGNS
configUFW
