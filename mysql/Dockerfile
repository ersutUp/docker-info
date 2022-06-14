FROM mysql:5.7

COPY config-mysql.cnf db.sql ./

ENV MYSQL_ROOT_PASSWORD=zhiheiot MYSQL_DATABASE=zhihe

RUN mv ./config-mysql.cnf /etc/mysql/conf.d/ && \
	mv ./db.sql /docker-entrypoint-initdb.d/
	
EXPOSE 3306

CMD ["/usr/local/bin/docker-entrypoint.sh","mysqld"]