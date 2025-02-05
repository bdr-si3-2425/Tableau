-- Rôle de bibliothécaire : accès en écriture aux ouvrages, gestion des emprunts
CREATE ROLE bibliothecaire_user LOGIN PASSWORD 'motdepasse';
GRANT SELECT, INSERT, UPDATE, DELETE ON Ouvrages TO bibliothecaire_user;
GRANT SELECT, INSERT, UPDATE ON Loue TO bibliothecaire_user;


-- Rôle de gestionnaire : tous les privilèges sur la base de données
CREATE ROLE gestionnaire_user LOGIN PASSWORD 'motdepasse';
GRANT ALL PRIVILEGES ON DATABASE bibliotheque TO gestionnaire_user;

-- Rôle d'administrateur : accès complet à la base
CREATE ROLE admin_user LOGIN PASSWORD 'admin123';
GRANT ALL PRIVILEGES ON DATABASE bibliotheque TO admin_user;



SELECT b1.nom AS bibliotheque_source, 
       b2.nom AS bibliotheque_destination, 
       COUNT(t.id) AS nombre_transferts
FROM Transferts t
JOIN Bibliotheques b1 ON t.bibliotheque_source_id = b1.id
JOIN Bibliotheques b2 ON t.bibliotheque_destination_id = b2.id
GROUP BY b1.nom, b2.nom
ORDER BY nombre_transferts DESC;




SELECT t.bibliotheque_source_id, 
       t.bibliotheque_destination_id, 
       STRING_AGG(t.exemplaire_id::TEXT, ', ') AS ouvrages_transferes, 
       COUNT(t.id) AS total_transferts
FROM Transferts t
WHERE t.date_transfert BETWEEN CURRENT_DATE - INTERVAL '30 days' AND CURRENT_DATE
GROUP BY t.bibliotheque_source_id, t.bibliotheque_destination_id;




CREATE VIEW livres_empruntes AS
SELECT Ouvrages.titre, Abonnes.nom, Abonnes.prenom, Loue.date_emprunt, Loue.date_retour
FROM Loue
JOIN Ouvrages ON Loue.exemplaire_id = Ouvrages.id
JOIN Abonnes ON Loue.abonne_id = Abonnes.id
WHERE Loue.date_retour IS NULL;



