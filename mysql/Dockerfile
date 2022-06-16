FROM mysql:5.7

COPY config-mysql.cnf *.sql ./

ENV MYSQL_ROOT_PASSWORD=zhiheiot MYSQL_DATABASE=zhihe

RUN mv ./config-mysql.cnf /etc/mysql/conf.d/ && \
	mv ./*.sql /docker-entrypoint-initdb.d/
	
EXPOSE 3306

CMD ["/usr/local/bin/docker-entrypoint.sh","mysqld"]