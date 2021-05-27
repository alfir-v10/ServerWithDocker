
FROM debian:buster

RUN apt-get update && apt-get install -y nginx mariadb-server \
	php-fpm php-cli wget openssl php-mysql php-mbstring

RUN mkdir -p /var/www/btweesites
RUN chmod -R 755 /var/www/btweesites

RUN mkdir -p /var/www/btweesites/download
RUN mkdir -p /var/www/btweesites/phpAdmin
RUN mkdir -p /var/www/btweesites/WordPress
RUN mkdir -p /var/www/btweesites/SSLkey
RUN mkdir -p /var/www/btweesites/configFiles

RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz -P /var/www/btweesites/download
RUN wget https://wordpress.org/latest.tar.gz -P /var/www/btweesites/download

RUN tar -xf /var/www/btweesites/download/phpMyAdmin-5.0.4-all-languages.tar.gz -C /var/www/btweesites/phpAdmin
RUN tar -xf /var/www/btweesites/download/latest.tar.gz -C /var/www/btweesites/WordPress

RUN rm -r /var/www/btweesites/download

RUN openssl req -x509 -nodes -days 365 --newkey rsa:2048 -subj "/C=en/ST=USA/L=New-York/CN=ALFA Corporation" --keyout /var/www/btweesites/SSLkey/btweeSSL.key  -out /var/www/btweesites/SSLkey/btweeSSL.crt

EXPOSE 80 443

RUN service mysql start && mysql --execute="CREATE DATABASE db; CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin'; GRANT ALL PRIVILEGES ON db.* TO 'admin'@'localhost'; FLUSH PRIVILEGES;"

COPY ./srcs/start.sh /var/www/btweesites/configFiles

COPY ./srcs/config_nginx /etc/nginx/sites-available/default
COPY ./srcs/wp-config.php /var/www/btweesites/WordPress/
COPY ./srcs/config.inc.php /var/www/btweesites/phpmyadmin/

CMD bash /var/www/btweesites/configFiles/start.sh

