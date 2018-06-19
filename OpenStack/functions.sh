#!/bin/bash
#This function determines whether a package is installed.
function checkPackageInstalled()
{
  echo -e "Verifying $1 is installed...\c"
  return $(yum -q list installed $1 &>/dev/null)
}

#This function installs packages
function installPackage()
{
  echo -e "Installing $1...\c"	
  return $(yum -y install $1 &>/dev/null)
}

#This function removes packages
function removePackage()
{
  echo -e "Removing $1...\c" 
  return $(yum -y remove $1 &>/dev/null)
}

#This function updates packages
function updatePackages()
{
  echo -e "Updating packages... \c"
  return $(yum -y update &>/dev/null)
}

############## SERVICES 

#Enable services
function enableService()
{
  echo -e "Enabling $1... \c"
  return $(systemctl enable $1 &>/dev/null)
}

#Disable service
function disableService()
{
  echo -e "Disabling $1... \c"
  return $(systemctl disable $1 &>/dev/null)
}

#Start services
function startService()
{
  echo -e "Starting $1... \c"
  return $(systemctl start $1 &>/dev/null)
}

#Restart services
function restartService()
{
  echo -e "Restarting $1... \c"
  return $(systemctl restart $1 &>/dev/null)
}

#Stop services
function stopService()
{
  echo -e "Stopping $1... \c"
  return $(systemctl stop $1 &>/dev/null)
}

#Check services
function checkService()
{
  echo -e "Checking $1 status... \c"
  return $(systemctl status $1 &>/dev/null)
}

#Check SELinux
function checkSELinux()
{
  echo -e "Checking SELinux status... \c"
  return $(getenforce &>/dev/null)
}

#Disable SELinux
function enableSELinux()
{
  echo -e "Enabling SELinux... \c"
  return $(setenforce 1 &>/dev/null && sed -i 's/^SELINUX=.*$/SELINUX=enforcing/' /etc/sysconfig/selinux &>/dev/null)
}

#Disable SELinux
function disableSELinux()
{
  echo -e "Disabling SELinux... \c"
  return $(setenforce 0 &>/dev/null && sed -i 's/^SELINUX=.*$/SELINUX=permissive/' /etc/sysconfig/selinux &>/dev/null)
}

#Check exit code
function checkExit()
{
  if [ $? -eq 0 ]; then
    echo -e "\e[01;32mSuccess\e[0m"
  else
    echo -e "\e[01;31mFailure\e[0m"
  fi
}
