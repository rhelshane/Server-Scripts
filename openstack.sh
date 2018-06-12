#!/bin/bash

INTERFACE="/etc/network/interfaces";
GRUBCONF="/etc/default/grub";
IPADDR="192.168.192.3";
NETMASK="255.255.255.0";
GATEWAY="192.168.192.2";
DNSA="1.1.1.1";
DNSB="8.8.8.8";

# Disable IPv6
function disableVersion6()
{
  echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
  echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
  echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf
}

# Disable Services
function disableUFW()
{
  systemctl stop ufw
  systemctl disable ufw
  systemctl mask ufw
}

# Configure IPv4
function configVersion4a()
{
  if [ -e "$INTERFACE" ]
  then 
    sed -i "s/^iface.*dhcp.*$/iface\ ens32\ inet\ static/g" $INTERFACE;
    echo "	address $IPADDR" >> $INTERFACE;
    echo "	netmask $NETMASK" >> $INTERFACE;
    echo "	gateway $GATEWAY" >> $INTERFACE;
    echo "	dns-nameservers $DNSA $DNSB" >> $INTERFACE;
  fi
}

# Package maintenance
function packages()
{
  apt remove -y lxd lxd-client ufw
  apt update -y
  apt full-upgrade -y
  apt autoremove -y
}

# Install Snaps
function snaps()
{
  snap install lxd
  snap install conjure-up --classic
}

# Initialize LXD
function configLXD()
{
  cat lxd_preseed.yml | lxd init --preseed
}


disableVersion6
disableUFW
packages
snaps
configLXD




