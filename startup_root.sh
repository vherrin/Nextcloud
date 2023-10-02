 #!/bin/bash

PATH=/usr/local/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin:

#write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo "PATH=/usr/local/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin:" > mycron
echo "*/5 * * * * /usr/local/bin/php -d memory_limit=512M -f /var/www/html/cron.php > /var/www/html/cron.log 2>&1" >> mycron
echo "0 * * * * /var/www/html/occ maps:scan-photo > /var/www/html/occ.log 2>&1" >> mycron
echo "15 * * * * /var/www/html/occ preview:pre-generate > /var/www/html/preview.log 2>&1" >> mycron

#install new cron file
crontab -u www-data mycron
rm mycron

cron
ufw enable
ufw allow 'WWW Full'
ufw delete allow 'WWW'
a2enmod ssl
a2enmod headers
a2ensite default-ssl
a2enconf ssl-params
apache2ctl configtest

cp /media/share/certs/*.pem /etc/ssl/certs/
cp /media/share/certs/*.pem /etc/ssl/private/
cp /media/share/certs/*.pem /etc/ssl/

echo 'Finished and Restarting'

service apache2 restart