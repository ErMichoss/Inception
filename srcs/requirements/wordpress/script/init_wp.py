import os
import subprocess

def run_command(command, error_message):
    try:
        result = subprocess.run(command, shell=True, check=True, capture_output=True, text=True)
        print(result.stdout)
    except subprocess.CalledProcessError as e:
        print(f"{error_message}: {e.stderr}")
        exit(1)

def setup_wordpress():
    if not os.path.isfile("wp-config.php"):
        print("Iniciando la instalación de WordPress...")

        run_command("wp core download --allow-root", "Error al descargar WordPress")

        run_command(
            f"wp config create --dbname={os.getenv('DB_NAME')} "
            f"--dbuser={os.getenv('DB_USER')} " 
            f"--dbpass={os.getenv('DB_USER_PWD')} "
            f"--dbhost={os.getenv('DB_HOSTNAME')} --allow-root",
            "Error al crear wp-config.php"
        )

        run_command(
            f"wp core install --url={os.getenv('DOMAIN_NAME')} "
            f"--title=\"{os.getenv('WP_TITLE')}\" "
            f"--admin_user={os.getenv('WP_ADMIN_USER')} "
            f"--admin_password={os.getenv('WP_ADMIN_PWD')} "
            f"--admin_email={os.getenv('WP_ADMIN_EMAIL')} "
            f"--skip-email --allow-root",
            "Error al instalar WP"
        )

        run_command(
            f"wp user create {os.getenv('WP_USER')} {os.getenv('WP_USER_EMAIL')} "
            f"--role=author --user_pass={os.getenv('WP_USER_PWD')} --allow-root",
            "Error al crear usuario"
        )

        run_command("wp theme install astra --activate --allow-root", "Error al instalar tema")

        run_command(
            f"wp option update home 'https://{os.getenv('DOMAIN_NAME')}' --allow-root",
            "Error al actualizar la URL de home"
        )
        run_command(
            f"wp option update siteurl 'https://{os.getenv('DOMAIN_NAME')}' --allow-root",
            "Error al actualizar la URL de site"
        )

        print("Instalación de WordPress completada con éxito.")
    else:
        print("wp-config.php ya existe. Se omite la instalación de WordPress.")

def start_php_fpm():
    print("Iniciando PHP-FPM...")
    run_command("/usr/sbin/php-fpm7.4 -F", "Error al iniciar PHP-FPM")

if __name__ == "__main__":
    setup_wordpress()
    start_php_fpm()
