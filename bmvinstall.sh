apt-get update
apt-get -y install apache2 libapache2-mod-php php
cd /var/www/html
wget https://raw.githubusercontent.com/sean6541/file/master/VictronBMV.zip
unzip ./VictronBMV.zip
rm ./VictronBMV.zip
chmod -R 755 ./VictronBMV
mv ./VictronBMV/VictronBMV.conf /etc/apache2/sites-available
a2ensite VictronBMV
echo 'ALL ALL=NOPASSWD: /var/www/html/VictronBMV/runcat.sh' | EDITOR='tee -a' visudo
echo '@reboot stty -F /dev/ttyS0 speed 19200 raw -echo' | EDITOR='tee -a' crontab -e
echo 'Rebooting in 5 sec. Ctrl-C to cancel.'
sleep 5
reboot
