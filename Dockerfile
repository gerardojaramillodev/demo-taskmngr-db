###############################################################################
### MySQL
FROM mysql:8.0.16
ENV MYSQL_DATABASE=demo-taskmngr-db
ENV MYSQL_ROOT_PASSWORD=password
ENV TZ=America/Mexico_City
COPY conf/user.cnf /etc/mysql/my.cnf
COPY demo-taskmngr-db.sql /docker-entrypoint-initdb.d/
EXPOSE 3306
###############################################################################
### PostgreSQL 
### FROM postgres:16.0-alpine
### ENV POSTGRES_DATABASE=demo-taskmngr-db
### ENV POSTGRES_PASSWORD=password
### COPY demo-taskmngr-db.sql /docker-entrypoint-initdb.d/
### EXPOSE 5432
