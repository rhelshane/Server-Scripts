#!/bin/bash

# Disable IPv6
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf

# Package maintenance
apt remove lxd lxd-client ufw
apt update
apt upgrade

# Install Snaps
snap install lxd
snap install conjure-up --classic




