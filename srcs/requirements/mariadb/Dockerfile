FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y && \
	apt-get install mariadb-server -y

COPY config/my.conf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY script/init_mariadb.py /usr/local/bin/init_mariadb.py

RUN chmod -x /usr/local/bin/init_mariadb.py && \
	mkdir -p /run/mysqld && \
	chown -R mysql:mysql /run/mysqld && \
	chmod 777 /run /run/mysqld && \
	chown -R mysql:mysql /tmp /run

RUN apt-get install -y python3

EXPOSE 3306

ENTRYPOINT ["python3", "/usr/local/bin/init_mariadb.py"]
