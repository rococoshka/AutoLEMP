# AutoLEMP
What does it do:
1)Install MariaDB and set MyISAM engine default.
2)Install php extension for wordpress
3)Install nginx-light 
4)Configure nginx default site
5)Configure nginx for your site (https) with wordpress (for php 7.2)
6)Auto-renewal ssl certificate
7)Install wp-cli
8)Install and cofigurate WordPress

How to use: run lemp_wp_install.sh script as a root user with 3 parametrs.
./lemp_wp_install.sh par1 par2 par3
par1 - your domain (example.com)
par2 - username for wordpress data base
par3 - password for wordpress data base

During the installation you need to answer the questions about security of your DB.
Recomendation: 'null', N, and rest answers is Y.

After script is worked open your site and continue installation of WordPress.

