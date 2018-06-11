#!/bin/bash

apt remove lxd lxd-client ufw

echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf

echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf

echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf

apt update

apt upgrade

snap install lxd

lxd init
