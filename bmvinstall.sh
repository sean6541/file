#!/bin/bash
setup () {
  dir=$1
  echo 'Enter the serial device with the BMV connected to it:'
  read ttydev
  if [ $ttydev == '' ]
  then
    echo 'Error: No device specified.'
    exit 1
  fi
  ttydir='/dev/'$ttydev
  cd $dir
  wget https://raw.githubusercontent.com/sean6541/file/master/VictronBMV.zip
  unzip -j ./VictronBMV.zip
  rm ./VictronBMV.zip
  echo 'timeout 5 grep -a -m 1 PID -A 50 '$ttydir > ./runcat.sh
  (crontab -l 2>/dev/null; echo '@reboot stty -F '$ttydir' speed 19200 raw -echo') | crontab -
  echo 'ALL ALL=NOPASSWD: '$dir'/runcat.sh' | EDITOR='tee -a' visudo
  chmod -R 755 $dir
  echo 'Rebooting in 5 secs... (Ctrl-C to cancel)'
  sleep 5
  reboot
}
dir=''
echo 'Do you have a web server with PHP installed? (Y/N)'
read server
if [ $server == "Y" ] || [ $server == "y" ]
then
  echo 'Enter full path to your servers document dir (without trailing slash):'
  read docdir
  if [ $docdir != '' ]
  then
    dir=$docdir
    setup $dir
  else
    echo 'Error: No directory specified.'
    exit 1
  fi
else
  echo 'Would you like to install the Apache webserver and PHP? (Y/N)'
  read instapache
  if [ $instapache == 'Y' ] || [ $instapache == 'y' ]
  then
    apt-get update
    apt-get -y install apache2 libapache2-mod-php php
    dir='/var/www/html'
    setup $dir
  else
    echo 'Error: No directory specified and Apache not installed.'
    exit 1
  fi
fi
