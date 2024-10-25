import os
import subprocess

def run_command(command):
    """Ejecuta un comando en la shell y maneja errores."""
    try:
        result = subprocess.run(command, shell=True, check=True, capture_output=True, text=True)
        print(f"Comando ejecutado correctamente: {command}")
        return result.stdout
    except subprocess.CalledProcessError as e:
        print(f"Error al ejecutar {command}: {e.stderr}")
        return None

def start_mariadb():
    """Inicia el servicio de MariaDB."""
    print("Iniciando el servicio MariaDB...")
    run_command("service mariadb start")

def create_database(DB_NAME, DB_ROOT, DB_ROOT_PWD, DB_USER, DB_USER_PWD):
    """Crea una base de datos y usuario si no existen."""
    print(f"Verificando la existencia de la base de datos {DB_NAME}...")
    if not os.path.isdir(f"/var/lib/mysql/{DB_NAME}"):
        print(f"Construyendo la base de datos {DB_NAME}...")
        run_command(f"mysql -u {DB_ROOT} -p{DB_ROOT_PWD} -e 'CREATE DATABASE IF NOT EXISTS {DB_NAME};'")
        run_command(f"mysql -e 'CREATE USER IF NOT EXISTS \"{DB_USER}\"@\"%\" IDENTIFIED BY \"{DB_USER_PWD}\";'")
        run_command(f"mysql -e 'GRANT ALL PRIVILEGES ON {DB_NAME}.* TO \"{DB_USER}\"@\"%\" WITH GRANT OPTION;'")
        run_command("mysql -e 'FLUSH PRIVILEGES;'")
        print(f"Base de datos {DB_NAME} creada correctamente.")
    else:
        print(f"La base de datos {DB_NAME} ya existe.")

def stop_mariadb(DB_ROOT, DB_ROOT_PWD):
    """Apaga el servicio de MariaDB."""
    print("Apagando el servicio MariaDB...")
    run_command(f"mysqladmin -u {DB_ROOT} -p{DB_ROOT_PWD} shutdown")

def start_mysqld():
    """Inicia el proceso mysqld."""
    print("Iniciando el servidor MariaDB mysqld...")
    run_command("mysqld")

if __name__ == "__main__":
    # Variables de entorno en mayúsculas
    DB_NAME = os.getenv('DB_NAME')
    DB_ROOT = os.getenv('DB_ROOT')
    DB_ROOT_PWD = os.getenv('DB_ROOT_PWD')
    DB_USER = os.getenv('DB_USER')
    DB_USER_PWD = os.getenv('DB_USER_PWD')

    # Lógica principal
    print("Iniciando el proceso de configuración de MariaDB...")
    start_mariadb()
    create_database(DB_NAME, DB_ROOT, DB_ROOT_PWD, DB_USER, DB_USER_PWD)
    stop_mariadb(DB_ROOT, DB_ROOT_PWD)
    start_mysqld()
    print("Proceso completado.")


