FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y curl python3 python3-pip \
	php7.4 php7.4-fpm php7.4-mysqli mariadb-client

COPY config/wp_www.conf /etc/php/7.4/fpm/pool.d/

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

RUN chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp \
	&& mkdir -p /run/php \
	&& chmod  755 /run/php

COPY --chmod=755 script/init_wp.py /usr/local/bin/init_wp.py

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["python3", "/usr/local/bin/init_wp.py"]
