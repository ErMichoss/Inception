FROM debian:bullseye

RUN apt update &&\
	apt install nginx curl open ssl -y && \
	mkdir -p /etc/nginx/ssl && \
	openssl req -x509 -nodes -days 365 -newkey rsa:4096 -out /etc/nginx/ssl/nicgonza.42.fr.crt -keyout /etc/nginx/ssl/nicgonza.42.fr.key -subj "/C=ES/ST=MADRID/L=MADRID/O=42/OU=42/CN=nicgonza.42.fr" && \
	mkdir -p /var/run/nginx
	
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
