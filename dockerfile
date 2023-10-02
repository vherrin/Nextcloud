FROM nextcloud:27
# FROM nextcloud:latest

RUN apt-get update
RUN apt-get install -y vim nano
RUN apt-get install -y cron && cron
RUN apt-get install -y smbclient
RUN apt-get install -y cifs-utils
RUN apt-get install -y ufw
RUN apt-get install -y net-tools
RUN apt-get install -y iputils-ping
RUN apt-get install -y imagemagick
RUN apt-get install -y ffmpeg
RUN mkdir /media/share

RUN openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 -subj \
    "/C=US/ST=Texas/L=Austin/O=HomeBase/CN=192.168.9.199" \
    -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt

# Add updates to apache for ssl 
RUN echo "SSLCipherSuite EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH\n\
SSLProtocol All -SSLv2 -SSLv3 -TLSv1 -TLSv1.1\n\
SSLHonorCipherOrder On\n\
Header always set X-Frame-Options DENY\n\
Header always set X-Content-Type-Options nosniff\n\
SSLCompression off\n\
SSLUseStapling on\n\
SSLStaplingCache \"shmcb:logs/stapling-cache(150000)\"\n\
SSLSessionTickets Off"\
>> /etc/apache2/conf-available/ssl-params.conf

RUN cp /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf.bak

RUN sed -i "s|ServerAdmin webmaster@localhost|ServerAdmin webmaster@localhost\n               ServerName localhost |g" /etc/apache2/sites-available/default-ssl.conf

RUN sed -i "s|/etc/ssl/certs/ssl-cert-snakeoil.pem| /media/share/certs/fullchain1.pem |g" /etc/apache2/sites-available/default-ssl.conf

RUN sed -i "s|/etc/ssl/private/ssl-cert-snakeoil.key| /media/share/certs/privkey1.pem |g" /etc/apache2/sites-available/default-ssl.conf

RUN sed -i "s|/DocumentRoot /var/www/html| ErrorDocument 400 \'https://atxfamjam.com:8070\' |g" /etc/apache2/sites-available/default-ssl.conf

RUN sed -i "s|/var/www/html| /var/www/html\n        ErrorDocument 400 \"https://atxfamjam.com:8070\" |g" /etc/apache2/sites-available/default-ssl.conf
