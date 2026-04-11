FROM alpine:3.21.0

#TODO: probably can get rid of tzdata later on, but for now it is needed to set the timezone in the container to match the host timezone
RUN apk update && \
    apk add --no-cache mariadb mariadb-client su-exec tzdata && \
    mkdir -p /run/mysqld /var/lib/mysql var/log/mysql && \
    chown -R mysql:mysql /run/mysqld /var/lib/mysql var/log/mysql && \
    chmod 777 /run/mysqld

COPY ./conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf

COPY ./tools/entrypoint.sh /user/local/bin/entrypoint.sh
RUN chmod +x /user/local/bin/entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/user/local/bin/entrypoint.sh"]