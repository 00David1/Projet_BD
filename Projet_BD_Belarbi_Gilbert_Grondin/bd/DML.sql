-- =================================================================
-- Insertion des données de test (DML)
-- =================================================================

USE alsi_invest_bdd;  -- A changer si votre Shéma SQL porte un autre nom

-- Utilisateurs (L'équipe du projet) 
INSERT INTO Utilisateur (nom, prenom, email) VALUES
('Robert', 'Bob', 'bob.robert@example.com'),
('Martin', 'Pierre', 'martin.pierre@example.com'),
('Dupont', 'Jean', 'jean.dupont@example.com');

-- Secteurs économiques
INSERT INTO Secteur (nom_secteur) VALUES
('Technologie'),
('Santé'),
('Luxe'),
('Finance'),
('Énergie');

-- Places boursières
INSERT INTO Place_Boursiere (nom_place, devise) VALUES
('Euronext Paris', 'EUR'),
('NASDAQ', 'USD'),
('NYSE', 'USD');

-- Enveloppes (Comptes d'investissement)
INSERT INTO Enveloppe (nom_enveloppe, etablissement_bancaire, date_ouverture, id_utilisateur) VALUES
('PEA', 'Caisse Epargne', '2025-01-15', 1),
('PEA', 'Boursorama', '2024-05-20', 2),
('CTO', 'Boursorama', '2025-11-10', 1),
('CTO', 'Fortuneo', '2023-08-05', 3);

-- Actifs financiers
INSERT INTO Actif (ticker, nom_actif, type_actif, id_secteur, id_place) VALUES
('AAPL', 'Apple Inc.', 'Action', 1, 2),
('MC', 'LVMH', 'Action', 3, 1),
('SAN', 'Sanofi', 'Action', 2, 1),
('CW8', 'Amundi MSCI World', 'ETF', 4, 1),
('MSFT', 'Microsoft', 'Action', 1, 2);

-- Transactions (Historique d'achats et ventes)
INSERT INTO Transaction (id_enveloppe, id_actif, date_transaction, type_mouvement, quantite, prix_unitaire) VALUES
(1, 2, '2026-02-10 10:30:00', 'Achat', 5.0000, 850.20),
(1, 4, '2026-02-15 14:45:00', 'Achat', 10.0000, 485.50),
(2, 4, '2026-03-01 09:15:00', 'Achat', 15.0000, 490.10),
(3, 1, '2026-03-10 16:20:00', 'Achat', 20.0000, 175.30),
(3, 1, '2026-04-05 11:00:00', 'Vente', 5.0000, 185.00),
(4, 5, '2026-04-12 15:30:00', 'Achat', 8.0000, 410.75),
(1, 3, '2026-05-02 09:05:00', 'Achat', 30.0000, 92.40),
(2, 2, '2026-05-18 10:10:00', 'Achat', 2.0000, 840.00);