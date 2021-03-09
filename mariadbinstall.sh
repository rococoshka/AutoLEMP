#!/bin/sh

install_packages() {
	apt update --no-install-recommends
	apt install -y mariadb-server
}

myisam_conf(){
	printf "[mysqld]
	skip-innodb
	default-storage-engine=MyISAM " > /etc/mysql/conf.d/myisam.cnf
	systemctl restart mysql
}

install_packages
myisam_conf

