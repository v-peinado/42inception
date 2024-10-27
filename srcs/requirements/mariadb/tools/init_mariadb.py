import os
import subprocess

def run_command(command): 
    """Ejecuta un comando en la shell y maneja errores."""
    try: #try es un bloque de código que permite manejar excepciones
        result = subprocess.run(command, shell=True, check=True, capture_output=True, text=True) #subprocess.run() ejecuta un comando en la shell y devuelve un objeto con información sobre la ejecución del comando
        print(f"Comando ejecutado correctamente: {command}") #parametros de la función subprocess.run(): command es el comando a ejecutar, shell=True indica que se ejecutará en la shell, check=True indica que se lanzará una excepción si el comando devuelve un código de error, capture_output=True indica que se capturará la salida del comando, text=True indica que la salida del comando se devolverá como texto
        return result.stdout
    except subprocess.CalledProcessError as e: #subprocess.CalledProcessError es una excepción que se lanza cuando un proceso ejecutado con subprocess.run() devuelve un código de error
        print(f"Error al ejecutar {command}: {e.stderr}") #e.stderr es el mensaje de error que devuelve el proceso
        return None

def start_mariadb():
    """Inicia el servicio de MariaDB."""
    print("Iniciando el servicio MariaDB...")
    run_command("service mariadb start") #service es un comando de linux que permite iniciar, detener o reiniciar servicios

def create_database(DB_NAME, DB_ROOT, DB_ROOT_PWD, DB_USER, DB_USER_PWD):
    """Crea una base de datos y usuario si no existen."""
    print(f"Verificando la existencia de la base de datos {DB_NAME}...")
    if not os.path.isdir(f"/var/lib/mysql/{DB_NAME}"):
        print(f"Construyendo la base de datos {DB_NAME}...") #mysql es un cliente de MariaDB que permite ejecutar comandos SQL
        run_command(f"mysql -u {DB_ROOT} -p{DB_ROOT_PWD} -e 'CREATE DATABASE IF NOT EXISTS {DB_NAME};'") #-u indica el usuario, -p indica la contraseña, -e indica que se ejecutará un comando SQL
        run_command(f"mysql -e 'CREATE USER IF NOT EXISTS \"{DB_USER}\"@\"%\" IDENTIFIED BY \"{DB_USER_PWD}\";'") #% indica que el usuario puede conectarse desde cualquier host
        run_command(f"mysql -e 'GRANT ALL PRIVILEGES ON {DB_NAME}.* TO \"{DB_USER}\"@\"%\" WITH GRANT OPTION;'")
        run_command(f"mysql -u {DB_ROOT} -p{DB_ROOT_PWD} -e 'ALTER USER \"root\"@\"%\" IDENTIFIED BY \"{DB_ROOT_PWD}\";'")
        run_command("mysql -e 'FLUSH PRIVILEGES;'") #FLUSH PRIVILEGES es un comando SQL que recarga los privilegios de la base de datos
        print(f"Base de datos {DB_NAME} creada correctamente.")
    else:
        print(f"La base de datos {DB_NAME} ya existe.")

def stop_mariadb(DB_ROOT, DB_ROOT_PWD):
    """Apaga el servicio de MariaDB."""
    print("Apagando el servicio MariaDB...") #mysqladmin es un cliente de MariaDB que permite administrar el servidor
    run_command(f"mysqladmin -u {DB_ROOT} -p{DB_ROOT_PWD} shutdown") 

def start_mysqld():
    """Inicia el proceso mysqld."""
    print("Iniciando el servidor MariaDB mysqld...")
    run_command("mysqld") #mysqld es el daemon de MariaDB que se encarga de gestionar las conexiones a la base de datos

if __name__ == "__main__": #__name__ es indicador de que el script se está ejecutando como script principal, no se ejecutara lo que está dentro de este bloque si se importa el script
    # Variables de entorno en mayúsculas, si se importase el script, estas variables no se cargarían
    DB_NAME = os.getenv('DB_NAME') #os es una librería que permite acceder a las variables de entorno
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


