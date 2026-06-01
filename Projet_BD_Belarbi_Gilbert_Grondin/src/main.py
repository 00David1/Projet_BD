# Importation de notre fonction de connexion
from db_connection import get_connection

# Importation de toutes nos fonctions de base de données
import crud

def menu_principal():
    # 1. On tente de se connecter à la base
    conn = get_connection()
    if conn is None:
        print("Fermeture du programme (Impossible de se connecter a la base).")
        return

    # 2. Si la connexion réussit, on lance la boucle du menu
    while True:
        print("\n" + "="*50)
        print("   GESTIONNAIRE D'INVESTISSEMENT ALSI61   ")
        print("="*50)
        print("1. Lister tous les actifs")
        print("2. Ajouter un nouvel actif")
        print("3. Rechercher un actif par mot-cle")
        print("4. Modifier le nom d'un actif")
        print("5. Supprimer un actif")
        print("6. Afficher les statistiques globales (GROUP BY)")
        print("7. Details d'un actif (JOINTURES)")
        print("8. Quitter")
        print("="*50)
        
        choix = input("Votre choix (1-8) : ")
        
        if choix == '1':
            crud.lister_actifs(conn)
        elif choix == '2':
            crud.ajouter_actif(conn)
        elif choix == '3':
            crud.rechercher_actif(conn)
        elif choix == '4':
            crud.modifier_actif(conn)
        elif choix == '5':
            crud.supprimer_actif(conn)
        elif choix == '6':
            crud.afficher_statistiques(conn)
        elif choix == '7':
            crud.afficher_detail_actif(conn)
        elif choix == '8':
            print("Fermeture de l'application. A bientot !")
            conn.close() # On ferme la connexion
            break
        else:
            print("[INFO] Choix invalide, veuillez reessayer.")

if __name__ == '__main__':
    menu_principal()