#!/bin/sh

yourdomain="$1"
dbuser="$2"
dbpassword="$3"

wpcli_install() {
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	php wp-cli.phar --info
	chmod +x wp-cli.phar
	sudo mv wp-cli.phar /usr/local/bin/wp
}

setup_wordpress(){
#	mysql_secure_installation
#	mysql -e "CREATE DATABASE wordpress; GRANT ALL ON wordpress.* TO '$dbuser'@'localhost' IDENTIFIED BY '$dbpassword'; FLUSH PRIVILEGES;"
#	mkdir /var/www/wordpress
#	wp core download --allow-root --path=/var/www/wordpress
	wp core config --path=/var/www/wordpress --allow-root --dbname=wordpress --dbuser=$dbuser --dbpass=$dbpassword --dbhost=localhost --dbprefix=wp_
}

#wpcli_install
setup_wordpress

