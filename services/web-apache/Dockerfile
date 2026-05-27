FROM php:8.2-apache

# Instalar extensión mysqli y curl (necesario para healthcheck)
RUN docker-php-ext-install mysqli && \
    apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

# Copiar contenido web
COPY html/ /var/www/html/
COPY php/  /var/www/html/

EXPOSE 80
