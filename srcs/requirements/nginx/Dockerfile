FROM	debian:bullseye

RUN		apt update
RUN		apt install nginx curl openssl -y
RUN		mkdir -p /etc/nginx/ssl
RUN		openssl req -x509 -nodes -days 365 -newkey rsa:4096 -out /etc/nginx/ssl/vpeinado.42.fr.crt -keyout /etc/nginx/ssl/vpeinado.42.fr.key -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=vpeinado.42.fr"

RUN		mkdir -p /var/run/nginx

COPY	conf/nginx.conf /etc/nginx/nginx.conf

RUN		chmod 755 /var/www/html

RUN chown -R www-data:www-data /var/www/html

EXPOSE	443

CMD		["nginx","-g","daemon off;"]

