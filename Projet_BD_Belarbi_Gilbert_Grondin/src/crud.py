from mysql.connector import Error

# 1. LISTER
def lister_actifs(conn):
    print("\n--- Liste de tous les actifs ---")
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT id_actif, ticker, nom_actif, type_actif FROM Actif ORDER BY nom_actif")
        resultats = cursor.fetchall()
        
        if not resultats:
            print("Aucun actif trouve dans la base.")
        else:
            for row in resultats:
                print(f"ID: {row[0]} | Ticker: {row[1]} | Nom: {row[2]} | Type: {row[3]}")
    except Error as e:
        print(f"[ERREUR] Lors de la lecture : {e}")
    finally:
        if cursor: cursor.close()

# 2. AJOUTER
def ajouter_actif(conn):
    print("\n--- Ajouter un nouvel actif ---")
    ticker = input("Entrez le ticker (ex: AAPL) : ")
    nom = input("Entrez le nom de l'actif : ")
    type_actif = input("Type d'actif (Action, ETF, Obligation) : ")
    id_secteur = input("ID du secteur (1 a 5) : ")
    id_place = input("ID de la place boursiere (1 a 3) : ")
    
    try:
        cursor = conn.cursor()
        query = """INSERT INTO Actif (ticker, nom_actif, type_actif, id_secteur, id_place) 
                   VALUES (%s, %s, %s, %s, %s)"""
        values = (ticker, nom, type_actif, id_secteur, id_place)
        cursor.execute(query, values)
        conn.commit()
        print("[SUCCES] Actif ajoute avec succes !")
    except Error as e:
        print(f"[ERREUR] Lors de l'ajout : {e}")
    finally:
        if cursor: cursor.close()

# 3. RECHERCHER PAR MOT-CLÉ
def rechercher_actif(conn):
    print("\n--- Rechercher un actif ---")
    mot_cle = input("Entrez une partie du nom ou du ticker : ")
    
    try:
        cursor = conn.cursor()
        # Le % sert de joker (wildcard) en SQL pour chercher le mot n'importe où dans la chaîne
        query = "SELECT * FROM Actif WHERE nom_actif LIKE %s OR ticker LIKE %s"
        values = (f"%{mot_cle}%", f"%{mot_cle}%")
        cursor.execute(query, values)
        resultats = cursor.fetchall()
        
        if not resultats:
            print("Aucun resultat trouve.")
        else:
            for row in resultats:
                print(f"ID: {row[0]} | Ticker: {row[1]} | Nom: {row[2]}")
    except Error as e:
        print(f"[ERREUR] Lors de la recherche : {e}")
    finally:
        if cursor: cursor.close()

# 4. MODIFIER
def modifier_actif(conn):
    print("\n--- Modifier un actif ---")
    id_actif = input("Entrez l'ID de l'actif a modifier : ")
    nouveau_nom = input("Entrez le nouveau nom : ")
    
    try:
        cursor = conn.cursor()
        query = "UPDATE Actif SET nom_actif = %s WHERE id_actif = %s"
        values = (nouveau_nom, id_actif)
        cursor.execute(query, values)
        conn.commit()
        
        if cursor.rowcount > 0:
            print("[SUCCES] Actif mis a jour !")
        else:
            print("[INFO] Aucun actif trouve avec cet ID.")
    except Error as e:
        print(f"[ERREUR] Lors de la modification : {e}")
    finally:
        if cursor: cursor.close()

# 5. SUPPRIMER
def supprimer_actif(conn):
    print("\n--- Supprimer un actif ---")
    id_actif = input("Entrez l'ID de l'actif a supprimer : ")
    confirmation = input(f"Etes-vous sur de vouloir supprimer l'ID {id_actif} ? (o/n) : ")
    
    if confirmation.lower() == 'o':
        try:
            cursor = conn.cursor()
            query = "DELETE FROM Actif WHERE id_actif = %s"
            cursor.execute(query, (id_actif,))
            conn.commit()
            
            if cursor.rowcount > 0:
                print("[SUCCES] Actif supprime !")
            else:
                print("[INFO] Aucun actif trouve avec cet ID.")
        except Error as e:
            print(f"[ERREUR] Lors de la suppression : {e}")
        finally:
            if cursor: cursor.close()
    else:
        print("Suppression annulee.")

# 6. STATISTIQUES (Agrégation)
def afficher_statistiques(conn):
    print("\n--- Statistiques : Nombre d'actifs par Secteur ---")
    try:
        cursor = conn.cursor()
        query = """
        SELECT s.nom_secteur, COUNT(a.id_actif) AS total 
        FROM Secteur s 
        LEFT JOIN Actif a ON s.id_secteur = a.id_secteur 
        GROUP BY s.nom_secteur 
        ORDER BY total DESC
        """
        cursor.execute(query)
        resultats = cursor.fetchall()
        for row in resultats:
            print(f"Secteur {row[0]} : {row[1]} actif(s)")
    except Error as e:
        print(f"[ERREUR] Lors du calcul des stats : {e}")
    finally:
        if cursor: cursor.close()

# 7. DÉTAILS AVEC JOINTURES
def afficher_detail_actif(conn):
    print("\n--- Details complets d'un actif (Jointures) ---")
    id_actif = input("Entrez l'ID de l'actif pour voir ses details : ")
    
    try:
        cursor = conn.cursor()
        query = """
        SELECT a.nom_actif, a.ticker, a.type_actif, s.nom_secteur, p.nom_place, p.devise
        FROM Actif a
        INNER JOIN Secteur s ON a.id_secteur = s.id_secteur
        INNER JOIN Place_Boursiere p ON a.id_place = p.id_place
        WHERE a.id_actif = %s
        """
        cursor.execute(query, (id_actif,))
        resultat = cursor.fetchone()
        
        if resultat:
            print(f"\n--- FICHE DE L'ACTIF ---")
            print(f"Nom complet : {resultat[0]}")
            print(f"Ticker      : {resultat[1]}")
            print(f"Type        : {resultat[2]}")
            print(f"Secteur     : {resultat[3]}")
            print(f"Marche      : {resultat[4]} (Devise: {resultat[5]})")
            print("------------------------")
        else:
            print("[INFO] Aucun actif trouve avec cet ID.")
    except Error as e:
        print(f"[ERREUR] Lors de la recuperation des details : {e}")
    finally:
        if cursor: cursor.close()