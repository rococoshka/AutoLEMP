#!/bin/bash

yourdomain="$1"

php_install() {
	apt update
	apt install --no-install-recommends -y php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip
}

nginx_light_install() {
	apt update
	apt install --no-install-recommends -y nginx-light
}

nginx_default() {
	printf "server {
	listen 80 default_server;
	listen [::]:80 default_server;

	server_tokens off;

	default_type \"text/html\";
	return 200 'Hello, do you want to see the puppies';
	}

server {
	listen 443 ssl default_server;
	listen [::]:443 ssl default_server;

	ssl_certificate default.crt;
	ssl_certificate_key default.key;

	server_tokens off;

	default_type \"text/html\";
	return 200 'Hello, do you want to see the puppies safely';
	}" > /etc/nginx/sites-enabled/default

}

letsencrypt() {
cd /etc/nginx/
openssl req -x509 -out default.crt -keyout default.key \
-newkey rsa:2048 -nodes -sha256 -subj '/CN=localhost' -extensions EXT -config <(printf "
[dn]
CN=localhost
[req]
distinguished_name = dn
[EXT]
subjectAltName=DNS:localhost
keyUsage=digitalSignature
extendedKeyUsage=serverAuth")
}
 
setup_default_site() {
nginx_default
letsencrypt
nginx -s reload
}

setup_dehydrated() {
cd /usr/bin
wget https://raw.githubusercontent.com/lukas2511/dehydrated/master/dehydrated
chmod +x dehydrated
cd~
mkdir /etc/dehydrated /var/lib/dehydrated /var/lib/dehydrated/acme-challenges  /etc/dehydrated/acme-challenges;
printf "BASEDIR=/var/lib/dehydrated
WELLKNOWN=\"\${BASEDIR}/acme-challenges\"
DOMAINS_TXT=\"/etc/dehydrated/domains.txt\"" > /etc/dehydrated/config
dehydrated --register --accept-terms
printf "$yourdomain www.$yourdomain" > /etc/dehydrated/domains.txt

}

setup_certificate_siteconf() {
printf "server {
	listen 80;
	server_name $yourdomain www.$yourdomain;
	location ^~ /.well-known/acme-challenge {
		alias /var/lib/dehydrated/acme-challenges;
		}
	location / {
		return 301 https://\$host\$request_uri; }
	}" > /etc/nginx/sites-enabled/$yourdomain.conf

nginx -s reload
dehydrated -c
}


dehydrate_update() {

printf "#!bin/bash

dehydrated -c -g" > /etc/cron.weekly/Dehydrated
chmod +x /etc/cron.weekly/Dehydrated
printf "#!/bin/sh

test \"\$1\" = \"deploy_cert\" || exit 0
nginx -s reload" > /etc/dehydrated/hook.sh
chmod +x /etc/dehydrated/hook.sh
}
#php_install
#nginx_light_install
#setup_default_site
setup_dehydrated
setup_certificate_siteconf
#dehydrate_update
