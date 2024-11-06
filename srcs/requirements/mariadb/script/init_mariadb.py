import os
import subprocess

def run_command(command): 
    try:
        result = subprocess.run(command, shell=True, check=True, capture_output=True, text=True) #subprocess.run() ejecuta un comando en la shell y devuelve un objeto con información sobre la ejecución del comando
        print(f"Comando ejecutado correctamente: {command}")
        return result.stdout
    except subprocess.CalledProcessError as e:
        print(f"{e.stderr}")
        return None

def start_mariadb():
    run_command("service mariadb start")

def create_database(DB_NAME, DB_ROOT, DB_ROOT_PWD, DB_USER, DB_USER_PWD):
    print(f"Verificando si la base de datos existe")
    if not os.path.isdir(f"/var/lib/mysql/{DB_NAME}"):
        run_command(f"mysql -u {DB_ROOT} -p{DB_ROOT_PWD} -e 'CREATE DATABASE IF NOT EXISTS {DB_NAME};'")
        run_command(f"mysql -e 'CREATE USER IF NOT EXISTS \"{DB_USER}\"@\"%\" IDENTIFIED BY \"{DB_USER_PWD}\";'")
        run_command(f"mysql -e 'GRANT ALL PRIVILEGES ON {DB_NAME}.* TO \"{DB_USER}\"@\"%\" WITH GRANT OPTION;'")
        run_command(f"mysql -u {DB_ROOT} -p{DB_ROOT_PWD} -e 'ALTER USER \"root\"@\"%\" IDENTIFIED BY \"{DB_ROOT_PWD}\";'")
        run_command("mysql -e 'FLUSH PRIVILEGES;'")
    else:
        print(f"La base de datos {DB_NAME} ya existe.")

def stop_mariadb(DB_ROOT, DB_ROOT_PWD):
    run_command(f"mysqladmin -u {DB_ROOT} -p{DB_ROOT_PWD} shutdown") 

def start_mysqld():
    run_command("mysqld")

if __name__ == "__main__": 
    DB_NAME = os.getenv('DB_NAME')
    DB_ROOT = os.getenv('DB_ROOT')
    DB_ROOT_PWD = os.getenv('DB_ROOT_PWD')
    DB_USER = os.getenv('DB_USER')
    DB_USER_PWD = os.getenv('DB_USER_PWD')

    start_mariadb()
    create_database(DB_NAME, DB_ROOT, DB_ROOT_PWD, DB_USER, DB_USER_PWD)
    stop_mariadb(DB_ROOT, DB_ROOT_PWD)
    start_mysqld()
