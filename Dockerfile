FROM ubuntu:14.04
LABEL maintainer="Raul Benitez <raulbeni@gmail.com>"

# Install all packages in one layer and clean up
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    mysql-client-5.6 \
    mysql-server-5.6 \
    apache2 \
    libapache2-mod-php5 \
    php5-cli \
    pwgen \
    python-setuptools \
    vim-tiny \
    php5-mysql \
    php5-ldap \
    unzip \
    supervisor \
    wget \
    ca-certificates && \
    a2enmod rewrite && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Setup Apache and directories
RUN rm -rf /var/www/ && \
    mkdir -p /var/www/pointview/web/products_pictures/ /var/www/pointview/web/upload /var/www/pointview/assets/config

# Copy configuration files
COPY ./scripts/start.sh /start.sh
COPY ./scripts/passwordHash.php /passwordHash.php
COPY ./scripts/foreground.sh /etc/apache2/foreground.sh
COPY ./configs/supervisord.conf /etc/supervisord.conf
COPY ./configs/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY ./configs/parameters.php /var/www/pointview/assets/config/parameters.php
COPY ./configs/rest.php /var/www/pointview/assets/config/rest.php
COPY ./configs/createdb.sql /var/www/pointview/database/createdb.sql

# Download and extract Hackazon in one step
RUN wget -q https://github.com/Piuliss/hackazon/archive/master.zip -O /tmp/hackazon.zip && \
    unzip /tmp/hackazon.zip -d /tmp && \
    cp -r /tmp/hackazon-master/* /var/www/pointview/ && \
    cp /var/www/pointview/assets/config/db.sample.php /var/www/pointview/assets/config/db.php && \
    cp /var/www/pointview/assets/config/email.sample.php /var/www/pointview/assets/config/email.php && \
    rm -rf /tmp/hackazon* && \
    mkdir -p /var/www/pointview/assets/config/vuln/ && \
    chmod 755 /start.sh /etc/apache2/foreground.sh

# Copy vuln directory contents and overwrite destination
COPY ./configs/vuln/ /var/www/pointview/assets/config/vuln/

# Set proper permissions
RUN chown -R www-data:www-data /var/www/

EXPOSE 80
CMD ["/bin/bash", "/start.sh"]