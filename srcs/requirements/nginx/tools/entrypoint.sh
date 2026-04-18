#!/bin/sh

if [ ! -f /etc/nginx/ssl/inception.crt ]; then
    echo "==> No SSL certificate found. Generating one for ${DOMAIN_NAME}..."
    
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -subj "/C=FI/ST=Uusimaa/L=Helsinki/O=42/OU=Hive/CN=${DOMAIN_NAME}"
        
    echo "==> SSL certificate generated successfully!"
else
    echo "==> SSL certificate already exists. Skipping generation."
fi

echo "==> Injecting domain name into NGINX configuration..."
sed -i "s/DOMAIN_NAME_PLACEHOLDER/$DOMAIN_NAME/g" /etc/nginx/nginx.conf

echo "==> Starting NGINX in the foreground..."

exec nginx -g "daemon off;"