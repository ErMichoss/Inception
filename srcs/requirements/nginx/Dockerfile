FROM debian:bullseye

RUN apt update &&\
	apt install nginx curl openssl -y && \
	mkdir -p /etc/nginx/ssl && \
	openssl req -x509 -nodes -days 365 -newkey rsa:4096 -out /etc/nginx/ssl/nicgonza.42.fr.crt -keyout /etc/nginx/ssl/nicgonza.42.fr.key -subj "/C=ES/ST=MADRID/L=MADRID/O=42/OU=42/CN=nicgonza.42.fr" && \
	mkdir -p /var/run/nginx

#COPY config/nginx.conf /etc/nginx/conf.d/nginx.conf
COPY config/nginx.conf /etc/nginx/sites-available/nginx.conf
RUN ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/

RUN chmod 755 /var/www/html && chown -R www-data:www-data /var/www/html

CMD ["nginx", "-g", "daemon off;"]
