#!/bin/bash
#This script automates the installation of GNS3.

function managePackages()
{
  apt update -y
  apt upgrade -y
  apt install -y python-pip
  pip3 install gns3-server==2.1.3
}

function disableUFW()
{
  systemctl stop ufw
  systemctl disable ufw
}
managePackages
disableUFW
