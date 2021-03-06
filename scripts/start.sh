#!/bin/bash

#mysql has to be started this way as it doesn't work to call from /etc/init.d
#and files need to be touched to overcome overlay file system issues on Mac and Windows
find /var/lib/mysql -type f -exec touch {} \; && /usr/bin/mysqld_safe & 
sleep 10s
# Here we generate random passwords
HASHED_PASSWORD=`php /passwordHash.php $HACKAZON_PASSWORD`

#set DB password in db.php
sed -i "s/yourdbpass/$HACKAZON_PASSWORD/" /var/www/pointview/assets/config/db.php
sed -i "s/youradminpass/$HACKAZON_PASSWORD/" /var/www/pointview/assets/config/parameters.php

mysqladmin -u root password $MYSQL_PASSWORD
mysql -uroot -p$MYSQL_PASSWORD -e "CREATE DATABASE $HACKAZON_DB; GRANT ALL PRIVILEGES ON $HACKAZON_DB.* TO '$HACKAZON_USER'@'localhost' IDENTIFIED BY '$HACKAZON_PASSWORD'; FLUSH PRIVILEGES;"
mysql -uroot -p$MYSQL_PASSWORD $HACKAZON_DB < "/var/www/pointview/database/createdb.sql"
mysql -uroot -p$MYSQL_PASSWORD -e "UPDATE $HACKAZON_DB.tbl_users SET password='${HASHED_PASSWORD}' WHERE username='admin';"

killall mysqld
sleep 10s

supervisord -n
