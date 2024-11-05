FROM debian:bullseye

RUN apt update && apt install -y curl php7.4 php7.4-fpm php7.4-mysqli mariadb-client

COPY config/wp_www.conf /etc/php/7.4/fpm/pool.d/

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

RUN chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp \
	&& mkdir -p /run/php \
	&& chmod  755 /run/php

COPY --chmod=755 script/init_wp.sh /usr/local/bin/init_wp.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["/bin/bash", "/usr/local/bin/init_wp.sh"]
