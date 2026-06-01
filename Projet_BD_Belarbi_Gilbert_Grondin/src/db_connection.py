import mysql.connector
from mysql.connector import Error

def get_connection():
    """
    Établit et retourne la connexion à la base de données MySQL.
    """
    try:
        conn = mysql.connector.connect(
            host='localhost',
            user='root',          # Change 'root' si ton utilisateur MySQL est différent
            password='',          # Mettre votre mot de passe MySQL ici s'il y en a un
            database='alsi_invest_bdd' # Mettre le bon nom de la base de données que tu as créée
        )
        if conn.is_connected():
            return conn
    except Error as e:
        print(f"Erreur lors de la connexion à MySQL: {e}")
        return None
