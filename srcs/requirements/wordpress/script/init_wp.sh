#!/bin/bash

set -e

function run_command{
	local command="$1"
	local error_message="$2"

	echo "Ejecutando: $command ..."
	eval "$comand" || {echo "$error_message"; exit 1; }
}

function setup_wordpress {
	if [! -f "wp-config.php" ]; then
		echo "Instalando WordPress..."
		run_command "wp core download --allow-root" "Error al descargar WordPress"
		run_command "wp config create --dbname=${DB_NAME} --dbuser=${DB_USER} --dbpass=${DB_USER_PWD} --dbhost=${DB_HOSTNAME} --allow-root" "Error al crear wp-config.php"
		run_command "wp core install --url=${DOMAIN_NAME} --title=\"${WP_TITLE}\" --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PWD} --admin_email=${WP_ADMIN_EMAIL} --skip-email --alow-root" "Error al instalar WordPress"
		run_command "wp user create ${WP_USER} ${WP_USER_EMAIL} --role=author --user_pass=${WP_USER_PWD} --allow-root" "Error al crear usuario"
		run_command "wp theme install astra --activate --allow-root" "Error al instalar tema"
		run_command "wp option update home 'https://${DOMAIN_NAME}' --allow-root" "Error la URL de home"
		run_command "wp option update siteurl 'https://${DOMAIN_NAME}' --allow-root" "Error al actualizar la URL de site"

		echo "Instalacion de WordPress exitosa."
	else
		echo "wp-config.php ya existe. Se omite la instalacion"
	fi
}

function start_php_fpm{
	echo "Iniciando PHP_FPM..."
	run_command "/usr/sbin/php-fpm7.4 -F" "Error al iniciar PHP_FPM"
}

setup_wordpress
start_php_fpm

