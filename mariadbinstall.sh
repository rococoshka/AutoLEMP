#!bin/sh
homedir=`dirname $0`
#dbuser="$1"
#dbpassword="$2"
dbuser="'$1'"
dbpassword="'$2'"
install_packages() {
apt update
apt install -y mariadb-server
}
myisam_conf(){
touch /etc/mysql/conf.d/myisam.conf
printf "[mysqld]
skip-innodb
default-storage-engine=MyISAM " > /etc/mysql/conf.d/myisam.cnf
systemctl restart mysql
}

mariadbuser_conf(){
mysql_secure_installation
touch $homedir/user.sql
printf "GRANT ALL ON *.* TO $dbuser@'localhost' IDENTIFIED BY $dbpassword WITH GRANT OPTION;
FLUSH PRIVILEGES;
exit" > $homedir/user.sql
}
mysql  < $homedir/user.sql
install_packages
myisam_conf
mariadbuser_conf

