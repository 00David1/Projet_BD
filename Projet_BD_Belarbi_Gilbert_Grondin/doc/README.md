PROJET ALSI61 - BASES DE DONNEES
GESTION D'UN SYSTEME D'INVESTISSEMENT FINANCIER
================================================================================

Equipe : BELARBI, GILBERT, GRONDIN
Niveau : INGE1-APP-BDML
Date de rendu : 31 mai 2026


### 1. INSTRUCTIONS DE LANCEMENT

PRÉREQUIS :
- Un serveur MySQL local (XAMPP, WAMP, ou installation native).
- Python 3 installé sur la machine.
- La bibliothèque Python 'mysql-connector-python' installée.

ÉTAPE 1 : Configuration de la base de données
1. Ouvrez MySQL Workbench.
2. Crée un nouveux Schéma nomé "compte" (Si vous shouaiter mettre un autre nom il faudra chager la première ligne du fichier DDL et DML)
3. Ouvrez le fichier `bd/DDL.sql`.
4. Exécutez l'intégralité du script pour créer la base `alsi_invest_bdd` et insérer le jeu de données initial.

ÉTAPE 2 : Configuration de l'application Python
1. Ouvrez le fichier `src/db_connection.py` dans un IDE.
2. Modifiez si besoin les variables de connexion (utilisateur 'root' et le mot de passe correspondant à votre configuration MySQL locale).

ÉTAPE 3 : Lancement de l'application
1. Ouvrez un terminal à la racine du projet (dossier contenant 'src/').
2. Installez le connecteur MySQL si ce n'est pas déjà fait :
   > pip install mysql-connector-python
3. Lancez l'application avec la commande :
   > python src/main.py
4. Naviguez dans le menu console à l'aide des numéros pour interagir avec la base de données.

### 2. DOMAINE CHOISI

Le domaine choisi pour ce projet est la "Gestion d'un Système d'Investissement 
Financier". Ce système permet de suivre et de gérer des portefeuilles boursiers. 
Il répertorie des utilisateurs qui possèdent différentes enveloppes d'investissement 
(PEA, CTO) dans lesquelles ils effectuent des transactions (achats/ventes) 
sur divers actifs financiers (Actions, ETF, Obligations). Ces actifs sont 
catégorisés par secteurs économiques et sont cotés sur des places boursières 
spécifiques.


### 3. REGLES METIERS

- Règle 1 : Un Utilisateur peut posséder une ou plusieurs Enveloppes, mais une 
            Enveloppe appartient à un et un seul Utilisateur.
- Règle 2 : Un Actif appartient à un et un seul Secteur économique, mais un 
            Secteur peut regrouper plusieurs Actifs.
- Règle 3 : Un Actif est coté sur une seule Place Boursière principale, mais une 
            Place Boursière permet de coter plusieurs Actifs.
- Règle 4 : Une Transaction représente un mouvement (achat ou vente). Elle lie 
            une Enveloppe et un Actif, et porte des attributs spécifiques : 
            la date de la transaction, le type, la quantité et le prix unitaire.


### 4. DICTIONNAIRE DES DONNEES

Table            | Attribut               | Type SQL      | Contraintes                | Description
-----------------|------------------------|---------------|----------------------------|--------------------------------------
Utilisateur      | id_utilisateur         | INT           | PK, AUTO_INCREMENT         | Identifiant unique de l'investisseur
Utilisateur      | nom                    | VARCHAR(100)  | NOT NULL                   | Nom de famille de l'utilisateur
Utilisateur      | prenom                 | VARCHAR(100)  | NOT NULL                   | Prénom de l'utilisateur
Utilisateur      | email                  | VARCHAR(150)  | UNIQUE, NOT NULL           | Adresse email de contact
Enveloppe        | id_enveloppe           | INT           | PK, AUTO_INCREMENT         | Identifiant unique du compte
Enveloppe        | nom_enveloppe          | VARCHAR(50)   | NOT NULL                   | Type de compte (PEA, CTO...)
Enveloppe        | etablissement_bancaire | VARCHAR(100)  | NOT NULL                   | Banque gérant l'enveloppe
Enveloppe        | date_ouverture         | DATE          | NOT NULL                   | Date d'ouverture du compte
Secteur          | id_secteur             | INT           | PK, AUTO_INCREMENT         | Identifiant unique du secteur
Secteur          | nom_secteur            | VARCHAR(100)  | UNIQUE, NOT NULL           | Nom du secteur (ex: Technologie)
Place_Boursiere  | id_place               | INT           | PK, AUTO_INCREMENT         | Identifiant de la place boursière
Place_Boursiere  | nom_place              | VARCHAR(100)  | UNIQUE, NOT NULL           | Nom (ex: Euronext Paris, NASDAQ)
Place_Boursiere  | devise                 | VARCHAR(10)   | NOT NULL                   | Devise de cotation (EUR, USD...)
Actif            | id_actif               | INT           | PK, AUTO_INCREMENT         | Identifiant unique de l'actif
Actif            | ticker                 | VARCHAR(10)   | UNIQUE, NOT NULL           | Symbole boursier (ex: AAPL, CW8)
Actif            | nom_actif              | VARCHAR(150)  | NOT NULL                   | Nom complet de l'entreprise ou ETF
Actif            | type_actif             | VARCHAR(50)   | NOT NULL                   | Catégorie (Action, ETF, Obligation)
Transaction      | date_transaction       | DATETIME      | PK                         | Date et heure de l'ordre exécuté
Transaction      | type_mouvement         | VARCHAR(10)   | NOT NULL                   | Sens de l'ordre (Achat ou Vente)
Transaction      | quantite               | DECIMAL(10,4) | NOT NULL                   | Nombre de titres échangés
Transaction      | prix_unitaire          | DECIMAL(10,2) | NOT NULL                   | Prix d'exécution d'un titre