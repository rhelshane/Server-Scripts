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
  echo "Disabling IPv6"
  echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
  echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
  echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf
}

# Disable Services
function disableUFW()
{
  echo "Disabling UFW"
  systemctl stop ufw --quiet
  systemctl disable ufw --quiet
  systemctl mask ufw --quiet
}

# Configure IPv4
function configVersion4a()
{
  if [ -e "$INTERFACE" ]
  then 
    echo "Configuring IPv4"
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
  echo "Configuring packages"
  apt remove -qq -y lxd lxd-client ufw
  apt update -qq -y
  apt full-upgrade -qq -y 
  apt autoremove -qq -y
}

# Install Snaps
function snaps()
{
  echo "Configuring snaps"
  snap install lxd
  snap install conjure-up --classic
}

# Initialize LXD
function configLXD()
{
  echo "Configuring LXD"
  cat lxd_preseed.yml | lxd init --preseed
}


disableVersion6
disableUFW
packages
snaps
configLXD




