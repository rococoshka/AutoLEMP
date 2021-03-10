#!/bin/sh

yourdomain="$1"

setup_site () {
printf "server{
	server_name $yourdomain www.$yourdomain;

	location ^~ /.well-known/acme-challenge {
		alias /var/lib/dehydrated/acme-challenges;
	}

	location / {
		try_files \$uri \$uri/ /index.php\$is_args\$args;

	}

	listen 443 ssl;

	ssl_certificate /var/lib/dehydrated/certs/$yourdomain/fullchain.pem;
	ssl_certificate_key /var/lib/dehydrated/certs/$yourdomain/privkey.pem;

	location = /favicon.ico { log_not_found off; access_log off; }
	location =/robots.txt { log_not_found off; access_log off; allow all; }
	location ~* \\.(css|gif|ico|jpeg|jpg|js|png)\$ {
		expires max;
		log_not_found off;
		}

        root /var/www/wordpress;
        index index.php;

        location ~ \\.php\$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
		fastcgi_intercept_errors on;
        }

        location ~ /\\.ht {
                deny all;
        }
	}


server{
        listen 80;
        server_name $yourdomain www.$yourdomain;
	return 301 https://\$host\$request_uri;
	}" > /etc/nginx/sites-enabled/$yourdomain.conf
}
