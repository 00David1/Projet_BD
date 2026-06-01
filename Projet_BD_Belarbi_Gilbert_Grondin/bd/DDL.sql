-- =================================================================
-- PROJET ALSI61 - GESTION D'UN SYSTÈME D'INVESTISSEMENT FINANCIER
-- =================================================================

-- 1. Création et sélection de la base de données
CREATE DATABASE IF NOT EXISTS alsi_invest_bdd;
USE alsi_invest_bdd;

-- 2. Suppression des tables si elles existent (Ordre inverse des dépendances)
DROP TABLE IF EXISTS Transaction;
DROP TABLE IF EXISTS Actif;
DROP TABLE IF EXISTS Enveloppe;
DROP TABLE IF EXISTS Place_Boursiere;
DROP TABLE IF EXISTS Secteur;
DROP TABLE IF EXISTS Utilisateur;

-- 3. Création des tables (DDL)

CREATE TABLE Utilisateur (
    id_utilisateur INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL
);

CREATE TABLE Secteur (
    id_secteur INT AUTO_INCREMENT PRIMARY KEY,
    nom_secteur VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Place_Boursiere (
    id_place INT AUTO_INCREMENT PRIMARY KEY,
    nom_place VARCHAR(100) UNIQUE NOT NULL,
    devise VARCHAR(10) NOT NULL
);

CREATE TABLE Enveloppe (
    id_enveloppe INT AUTO_INCREMENT PRIMARY KEY,
    nom_enveloppe VARCHAR(50) NOT NULL,
    etablissement_bancaire VARCHAR(100) NOT NULL,
    date_ouverture DATE NOT NULL,
    id_utilisateur INT NOT NULL,
    CONSTRAINT fk_env_utilisateur FOREIGN KEY (id_utilisateur) 
        REFERENCES Utilisateur(id_utilisateur) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT chk_type_enveloppe CHECK (nom_enveloppe IN ('PEA', 'CTO', 'Assurance Vie'))
);

CREATE TABLE Actif (
    id_actif INT AUTO_INCREMENT PRIMARY KEY,
    ticker VARCHAR(10) UNIQUE NOT NULL,
    nom_actif VARCHAR(150) NOT NULL,
    type_actif VARCHAR(50) NOT NULL,
    id_secteur INT NOT NULL,
    id_place INT NOT NULL,
    CONSTRAINT fk_actif_secteur FOREIGN KEY (id_secteur) 
        REFERENCES Secteur(id_secteur) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    CONSTRAINT fk_actif_place FOREIGN KEY (id_place) 
        REFERENCES Place_Boursiere(id_place) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    CONSTRAINT chk_type_actif CHECK (type_actif IN ('Action', 'ETF', 'Obligation'))
);

CREATE TABLE Transaction (
    id_enveloppe INT NOT NULL,
    id_actif INT NOT NULL,
    date_transaction DATETIME NOT NULL,
    type_mouvement VARCHAR(10) NOT NULL,
    quantite DECIMAL(10,4) NOT NULL,
    prix_unitaire DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_enveloppe, id_actif, date_transaction),
    CONSTRAINT fk_trans_enveloppe FOREIGN KEY (id_enveloppe) 
        REFERENCES Enveloppe(id_enveloppe) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT fk_trans_actif FOREIGN KEY (id_actif) 
        REFERENCES Actif(id_actif) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT chk_mouvement CHECK (type_mouvement IN ('Achat', 'Vente')),
    CONSTRAINT chk_quantite CHECK (quantite > 0),
    CONSTRAINT chk_prix CHECK (prix_unitaire >= 0)
);
