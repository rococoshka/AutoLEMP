#!/bin/sh

test "$#" = 1 || { echo "Usage: ${0##*/} site"; exit 1; }
SITE="$1"

install_packages() {
    apt update
    env DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
        mariadb nginx-light dehydrated php-fpm # todo: more php packages required by Wordpress?
}

is_innodb_active() {
    # todo
}

disable_innodb() {
    # todo
}

setup_mysql() {
    is_innodb_active || return 0
    disable_innodb
    systemctl restart mysql
}

setup_default_site() {
    # todo: https://cdnnow.ru/blog/defhost/
}

setup_site() {
    # todo: https://cdnnow.ru/blog/dehydrated/
}

setup_nginx() {
    setup_default_site
    setup_site
}

install_packages
setup_mysql
setup_nginx

## END ##
