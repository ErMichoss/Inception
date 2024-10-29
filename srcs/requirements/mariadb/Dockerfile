FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y && \
	apt-get install mariadb-server -y

COPY config/my.conf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY script/init_mariadb.sh /usr/local/bin/init_mariadb.sh

RUN chmod -x /usr/local/bin/init_mariadb.sh && \
	mkdir -p /var/run/mysqld && \
	chown -R mysql:mysql /var/run/mysqld && \
	chdmod 777 /var/run/mysqld && \
	chwon -R mysql:mysql /tmp /run/mysqld

EXPOSE 3306

ENTRYPOINT ["/bin/bash", "/usr/local/bin/init_mariadb.sh"]
