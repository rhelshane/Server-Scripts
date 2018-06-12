#!/bin/bash

INTERFACE="/etc/network/interfaces";
IPADDR="192.168.192.3";
NETMASK="255.255.255.0";
GATEWAY="192.168.192.2";
DNSA="1.1.1.1";
DNSB="8.8.8.8";

# Disable IPv6
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf

if [ -e "$GRUBCONF" ]
then
  sed -i "s/^GRUB_CMDLINE_LINUX=\"\".*$/GRUB_CMDLINE_LINUX=\"ipv6.disable=1\"/g" $GRUBCONF;
fi

update-grub

# Disable Services
systemctl stop ufw
systemctl disable ufw
systemctl mask ufw

# Configure IPv4
if [ -e "$INTERFACE" ]
then 
  sed -i "s/^iface.*dhcp.*$/iface\ ens32\ inet\ static/g" $INTERFACE;
  echo "	address $IPADDR" >> $INTERFACE;
  echo "	netmask $NETMASK" >> $INTERFACE;
  echo "	gateway $GATEWAY" >> $INTERFACE;
  echo "	dns-nameservers $DNSA $DNSB" >> $INTERFACE;
fi

# Package maintenance
apt remove -y lxd lxd-client ufw
apt update -y
apt full-upgrade -y
apt autoremove -y

# Install Snaps
snap install lxd
snap install conjure-up --classic --edge

# Initialize LXD
cat lxd_preseed.yml | lxd init --preseed
lxc network set lxdbr0 ipv6.nat false
lxc network set lxdbr0 ipv6.address none

# Reboot
reboot




