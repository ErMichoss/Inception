#!/bin/bash

run_command(){
	command=$1
	echo "ejecutando: $command"
	eval $command
	if [ $? -ne 0]; then
		echo "Error al ejecutar $command"
		return 1
	fi
	return 0
}

start_mariadb(){
	echo "Iniciando MariaDB..."
	run_command "service mariadb start"
}

create_database(){
	DB_NAME=$1
	DB_ROOT=$2
	DB_ROOT_PWD=$3
	DB_USER=$4
	DB_USER_PWD=$5

	echo "verificando que la base de datos $DB_NAME exista...
	if [! -d "/var/lib/mysql/$DB_NAME" ]; then
		echo "Construyendo $DB_NAME..."
		run_command "mysql -u $DB_ROOT -p$DB_ROOT_PWD -e 'CREATE DATABASE IF NOT EXIST $DB_NAME;'"
		run_command "mysql -e 'CREATE USER IF NOT EXIST \"$DB_USER\"@\"%\" IDENTIFIED BY \"$DB_USER_PWD\";'"
		run_command "mysql -e 'GRANT ALL PRIVILEGES ON $DB_NAME.* TO \"$DB_USER\"@\"%\" WITH GRANT OPTION;'"
		run_command "mysql -u $DB_ROOT -p$DB_ROOT_PWD -e 'ALTER USER \"root\"@\"%\" IDENTIFIED BY \"$DB_ROOT_PWD\";'"
		run_command "mysql -e 'FLUSH PRIVILEGES;'"
		echo "$DB_NAME creada correctamente."
	else
		echo "$DB_NAME ya existe"
	fi 
}

stop_mariadb(){
	DB_ROOT=$1
	DB_ROOT_PWD=$2
	echo "Quitando el servicio MariaDB.."
	run_command "mysqladmin -u $DB_ROOT -p$DB_ROOT_PWD shutdown"
}

start_mysqld(){
	echo "Iniciando el servidor mysqld..."
	run_command "muslqd"
}

# Variables de entorno
DB_NAME=${DB_NAME}
DB_ROOT=${DB_ROOT}
DB_ROOT_PWD=${DB_ROOT_PWD}
DB_USER=${DB_USER}
DB_USER_PWD=${DB_USER_PWD}

echo "Iniciando el proceso de configuracion de MariaDB..."
start_mariadb
create_database "$DB_NAME" "$DB_ROOT" "$DB_ROOT_PWD" "$DB_USER" "$DB_USER_PWD"
stop_mariadb "$DB_ROOT" "$DB_ROOT_PWD"
start_mysqld
echo "Proceso completado. :D"
