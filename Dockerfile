FROM ubuntu:14.04
MAINTAINER Raul Benitez <raulbeni@gmail.com>
RUN apt-get update
RUN apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-client-5.6 mysql-server-5.6 apache2 libapache2-mod-php5 pwgen python-setuptools vim-tiny php5-mysql  php5-ldap unzip

# setup hackazon
RUN apt-get install -y supervisor
ADD ./scripts/start.sh /start.sh
ADD ./scripts/passwordHash.php /passwordHash.php
ADD ./scripts/foreground.sh /etc/apache2/foreground.sh
ADD ./configs/supervisord.conf /etc/supervisord.conf
ADD ./configs/000-default.conf /etc/apache2/sites-available/000-default.conf
RUN rm -rf /var/www/
ADD https://github.com/Piuliss/hackazon/archive/master.zip /hackazon-master.zip
RUN unzip /hackazon-master.zip -d hackazon
RUN mkdir /var/www/
RUN mv /hackazon/hackazon-master/ /var/www/pointview
RUN cp /var/www/pointview/assets/config/db.sample.php /var/www/pointview/assets/config/db.php
RUN cp /var/www/pointview/assets/config/email.sample.php /var/www/pointview/assets/config/email.php
ADD ./configs/parameters.php /var/www/pointview/assets/config/parameters.php
ADD ./configs/rest.php /var/www/pointview/assets/config/rest.php
ADD ./configs/createdb.sql /var/www/pointview/database/createdb.sql
RUN chown -R www-data:www-data /var/www/
RUN chown -R www-data:www-data /var/www/pointview/web/products_pictures/
RUN chown -R www-data:www-data /var/www/pointview/web/upload
RUN chown -R www-data:www-data /var/www/pointview/assets/config
RUN chmod 755 /start.sh
RUN chmod 755 /etc/apache2/foreground.sh
RUN a2enmod rewrite

EXPOSE 80
CMD ["/bin/bash", "/start.sh"]