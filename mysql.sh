#!/bin/bash

source functions.sh 
source vars.sh

#Perform basic mariadb setup
function mariadbSetup ()
{
  mysqladmin -u root password "$SQL_PASS"
  mysql -u root -p"$SQL_PASS" -e "UPDATE mysql.user SET Password=PASSWORD('$SQL_ASS') WHERE User='root'"
  mysql -u root -p"$SQL_PASS" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
  mysql -u root -p"$SQL_PASS" -e "DELETE FROM mysql.user WHERE User=''"
  mysql -u root -p"$SQL_PASS" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
  mysql -u root -p"$SQL_PASS" -e "FLUSH PRIVILEGES"
  mysqladmin -u root password "$SQL_PASS"
  sed -i "s/^#bind-address.*$/bind-address=0.0.0.0/" /etc/my.cnf.d/mariadb-server.cnf
}

#Run through installation
TARGET='mariadb-server'
SERVICE="mariadb"

installPackage $TARGET
checkExit
checkPackageInstalled $TARGET
checkExit
enableService $SERVICE
checkExit
startService $SERVICE
checkExit
checkService $SERVICE
checkExit
mariadbSetup
checkExit
restartService $SERVICE
checkExit
checkService $SERVICE
checkExit

#Run through installation
TARGET='python2-mysql'

installPackage $TARGET
checkExit
checkPackageInstalled $TARGET
checkExit

