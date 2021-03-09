#!/bin/sh

dbuser="$1"
dbpassword="$2"

mariadbuser_conf(){
	mysql_secure_installation
	mysql -e "GRANT ALL ON *.* TO '$dbuser'@'localhost' IDENTIFIED BY 'dbpassword' WITH GRANT OPTION; FLUSH PRIVILEGES; SHOW ENGINES;"
}

mariadbuser_conf

