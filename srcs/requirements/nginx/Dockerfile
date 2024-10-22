# Utiliza la imagen base de Debian Bullseye
FROM debian:bullseye

# Actualiza la lista de paquetes para asegurar que estén actualizados
# Instala nginx (servidor web), curl (herramienta para transferencias de datos) y openssl (para manejo de certificados SSL)
# Crea un directorio en /etc/nginx/ssl para almacenar el certificado SSL
# Genera un certificado SSL autofirmado que será válido por 365 días:
#   -x509: indica que es un certificado X.509
#   -nodes: no encripta la clave privada
#   -days 365: el certificado será válido por 1 año
#   -newkey rsa:4096: crea una nueva clave RSA de 4096 bits
#   -out: especifica dónde se guarda el certificado
#   -keyout: especifica dónde se guarda la clave privada
#   -subj: define los campos del certificado (país, estado, ciudad, organización, unidad organizativa, nombre común)
# Crea el directorio /var/run/nginx, que es necesario para que nginx almacene archivos de procesos (PID)
RUN apt update && \
    apt install nginx curl openssl -y && \
    mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:4096 -out /etc/nginx/ssl/vpeinado.42.fr.crt -keyout /etc/nginx/ssl/vpeinado.42.fr.key -subj "/C=ES/ST=MADRID/L=MADRID/O=42/OU=42/CN=vpeinado.42.fr" && \
    mkdir -p /var/run/nginx

# Copia el archivo de configuración nginx.conf desde el directorio local conf hacia el contenedor en /etc/nginx/nginx.conf
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Cambia los permisos del directorio /var/www/html para permitir lectura y ejecución para todos los usuarios, pero escritura solo para el propietario
# y cambia el propietario y grupo del directorio /var/www/html a www-data, el usuario que utiliza Nginx
RUN chmod 755 /var/www/html && chown -R www-data:www-data /var/www/html


# Expone el puerto 443, que es el puerto utilizado para HTTPS
EXPOSE 443

# Comando que se ejecuta cuando el contenedor arranca. 
# Ejecuta Nginx en primer plano (no como daemon) para que docker pueda manejarlo como proceso principal del contenedor
CMD ["nginx","-g","daemon off;"]


