###############################################################################
### MySQL
### FROM mysql:8.0.24
FROM mysql/mysql-server:8.0.24
ENV MYSQL_DATABASE=demo-taskmngr-db
ENV MYSQL_ROOT_PASSWORD=password
ENV TZ=America/Mexico_City
COPY config/user.cnf /etc/mysql/my.cnf
COPY demo-taskmngr-db.sql /docker-entrypoint-initdb.d/
EXPOSE 3306