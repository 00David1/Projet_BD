-- =================================================================
-- PROJET ALSI61 - REQUÊTES SQL
-- BASE DE DONNÉES : alsi_invest_bdd
-- =================================================================

USE alsi_invest_bdd;  -- A changer si votre Shéma SQL porte un autre nom

-- -----------------------------------------------------------------
-- 7.1. Requêtes de base (SELECT, WHERE, ORDER BY)
-- -----------------------------------------------------------------

-- R1. Afficher la liste de tous les enregistrements de votre entité principale, triés par ordre alphabétique.
-- Explication : On liste tous les actifs financiers de la base, triés de A à Z selon leur nom.
SELECT * FROM Actif 
ORDER BY nom_actif ASC;

-- R2. Afficher les enregistrements satisfaisant un critère numérique.
-- Explication : On récupère toutes les transactions dont la quantité échangée dépasse 10 titres.
SELECT * FROM Transaction 
WHERE quantite > 10;

-- R3. Afficher les enregistrements liés à un identifiant passé en paramètre.
-- Explication : On affiche tous les actifs appartenant au secteur "Technologie" (en supposant que son id_secteur est 1).
SELECT * FROM Actif 
WHERE id_secteur = 1;

-- -----------------------------------------------------------------
-- 7.2. Requêtes avec jointures
-- -----------------------------------------------------------------

-- R4. Afficher les informations combinées de deux entités liées (INNER JOIN).
-- Explication : On associe chaque enveloppe à son propriétaire pour afficher le type de compte et le nom de l'utilisateur.
SELECT e.nom_enveloppe, e.etablissement_bancaire, u.nom, u.prenom
FROM Enveloppe e
INNER JOIN Utilisateur u ON e.id_utilisateur = u.id_utilisateur;

-- R5. Afficher tous les enregistrements d'une entité, même s'ils n'ont pas de correspondance dans une autre (LEFT JOIN).
-- Explication : On affiche tous les secteurs économiques enregistrés, y compris ceux (comme "Énergie") qui ne possèdent pas encore d'actifs associés dans notre base.
SELECT s.nom_secteur, a.nom_actif
FROM Secteur s
LEFT JOIN Actif a ON s.id_secteur = a.id_secteur;

-- R6. Afficher des informations agrégées combinant plusieurs tables.
-- Explication : On calcule la valeur totale brute (quantité * prix unitaire) des transactions réalisées par secteur d'activité.
SELECT s.nom_secteur, SUM(t.quantite * t.prix_unitaire) AS volume_financier_total
FROM Transaction t
INNER JOIN Actif a ON t.id_actif = a.id_actif
INNER JOIN Secteur s ON a.id_secteur = s.id_secteur
GROUP BY s.nom_secteur;

-- -----------------------------------------------------------------
-- 7.3. Requêtes avec agrégats (GROUP BY, HAVING)
-- -----------------------------------------------------------------

-- R7. Afficher le nombre d'enregistrements par catégorie, trié par ordre décroissant.
-- Explication : On compte le nombre d'actifs financiers disponibles dans chaque secteur économique.
SELECT s.nom_secteur, COUNT(a.id_actif) AS nombre_actifs
FROM Secteur s
LEFT JOIN Actif a ON s.id_secteur = a.id_secteur
GROUP BY s.nom_secteur
ORDER BY nombre_actifs DESC;

-- R8. Afficher les entités ayant un agrégat supérieur à un seuil donné.
-- Explication : On identifie les enveloppes (comptes) très actives, c'est-à-dire celles ayant enregistré plus de 2 transactions.
SELECT id_enveloppe, COUNT(*) AS nombre_transactions
FROM Transaction
GROUP BY id_enveloppe
HAVING COUNT(*) > 2;

-- R9. Calculer une moyenne ou une somme par groupe, en filtrant avec HAVING.
-- Explication : On calcule le montant moyen des achats pour chaque enveloppe, et on ne retient que celles dont le montant moyen dépasse 500 euros/dollars.
SELECT id_enveloppe, AVG(quantite * prix_unitaire) AS montant_moyen_achat
FROM Transaction
WHERE type_mouvement = 'Achat'
GROUP BY id_enveloppe
HAVING AVG(quantite * prix_unitaire) > 500;

-- R10. Afficher le maximum ou le minimum d'un attribut numérique par groupe.
-- Explication : On recherche le prix unitaire maximum auquel chaque actif a été négocié (acheté ou vendu) au cours du temps.
SELECT id_actif, MAX(prix_unitaire) AS prix_historique_max
FROM Transaction
GROUP BY id_actif;

-- -----------------------------------------------------------------
-- 7.4. Requêtes avancées (sous-requêtes, IN, NOT IN, EXISTS, NOT EXISTS)
-- Les requêtes R11 à R15 sont volontairement complexes.
-- -----------------------------------------------------------------

-- R11. Afficher les enregistrements dont une valeur est supérieure à la moyenne globale (sous-requête scalaire).
-- Explication : On affiche les transactions dont le prix unitaire est strictement supérieur à la moyenne des prix unitaires de toutes les transactions de la base.
SELECT *
FROM Transaction
WHERE prix_unitaire > (SELECT AVG(prix_unitaire) FROM Transaction);

-- R12. Afficher les entités qui ont satisfait une condition sur tous leurs éléments associés (ALL ou NOT EXISTS).
-- Explication : On affiche le nom des actifs qui n'ont JAMAIS fait l'objet d'une transaction de "Vente" (conservation totale).
SELECT a.nom_actif
FROM Actif a
WHERE NOT EXISTS (
    SELECT 1
    FROM Transaction t
    WHERE t.id_actif = a.id_actif AND t.type_mouvement = 'Vente'
);

-- R13. Afficher un classement avec départage sur plusieurs critères (ORDER BY multi-colonnes ou RANK()).
-- Explication : On crée un classement des actifs selon leur prix unitaire lors des transactions, du plus cher au moins cher. En cas d'égalité de prix, le départage se fait par ordre alphabétique du nom de l'actif.
SELECT a.nom_actif, t.prix_unitaire,
       RANK() OVER (ORDER BY t.prix_unitaire DESC, a.nom_actif ASC) as classement
FROM Transaction t
INNER JOIN Actif a ON t.id_actif = a.id_actif;

-- R14. Afficher les entités ayant participé à au moins deux catégories différentes (sous-requête avec COUNT DISTINCT).
-- Explication : On identifie les enveloppes (comptes) bien diversifiées, c'est-à-dire contenant des actifs provenant d'au moins 2 secteurs économiques différents.
SELECT t.id_enveloppe
FROM Transaction t
INNER JOIN Actif a ON t.id_actif = a.id_actif
GROUP BY t.id_enveloppe
HAVING COUNT(DISTINCT a.id_secteur) >= 2;

-- R15. Afficher, pour chaque groupe, l'élément ayant la valeur maximale d'un attribut. En cas d'égalité, afficher les deux.
-- Explication : Pour chaque enveloppe, on affiche la transaction qui a eu la plus grande quantité de titres échangés. L'utilisation d'une sous-requête corrélée permet d'afficher les doublons en cas d'égalité parfaite.
SELECT t1.id_enveloppe, t1.id_actif, t1.quantite
FROM Transaction t1
WHERE t1.quantite = (
    SELECT MAX(t2.quantite)
    FROM Transaction t2
    WHERE t2.id_enveloppe = t1.id_enveloppe
);