-- Créer une vue pour afficher les livres empruntés par un abonné spécifique
CREATE VIEW livres_empruntes AS
SELECT Ouvrages.titre, Abonnes.nom, Emprunts.date_emprunt, Emprunts.date_retour
FROM Emprunts
JOIN Ouvrages ON Emprunts.ouvrage_id = Ouvrages.id
JOIN Abonnes ON Emprunts.abonne_id = Abonnes.id
WHERE Emprunts.statut = 'emprunté';



-- Créer un trigger pour vérifier qu'un livre ne peut pas être emprunté si déjà réservé
CREATE OR REPLACE FUNCTION check_book_availability() 
RETURNS TRIGGER AS $$
BEGIN
  IF (SELECT COUNT(*) FROM Emprunts WHERE ouvrage_id = NEW.ouvrage_id AND statut = 'réservé') > 0 THEN
    RAISE EXCEPTION 'Le livre est déjà réservé.';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_availability
BEFORE INSERT ON Emprunts
FOR EACH ROW
EXECUTE FUNCTION check_book_availability();




-- Créer une fonction pour calculer le nombre de jours restant avant le retour d'un livre
CREATE OR REPLACE FUNCTION jours_restant(ouvrage_id INT) 
RETURNS INT AS $$
DECLARE
  date_retour DATE;
BEGIN
  SELECT date_retour INTO date_retour FROM Emprunts WHERE ouvrage_id = $1 AND statut = 'emprunté';
  RETURN (date_retour - CURRENT_DATE);
END;
$$ LANGUAGE plpgsql;

-- Utiliser la fonction pour afficher le nombre de jours restants pour un livre emprunté
SELECT titre, jours_restant(id) FROM Ouvrages WHERE id = 1;



--Sabrina
-- Rôle de bibliothécaire : accès en écriture aux ouvrages, gestion des emprunts
CREATE ROLE bibliothecaire_user LOGIN PASSWORD 'motdepasse';
GRANT SELECT, INSERT, UPDATE, DELETE ON Ouvrages TO bibliothecaire_user;
GRANT SELECT, INSERT, UPDATE ON Emprunts TO bibliothecaire_user;

--Hamid
-- Rôle de gestionnaire : tous les privilèges sur la base de données
CREATE ROLE gestionnaire_user LOGIN PASSWORD 'motdepasse';
GRANT ALL PRIVILEGES ON DATABASE bibliotheque TO gestionnaire_user;

--Cyril
-- Rôle d'administrateur : accès complet à la base
CREATE ROLE admin_user LOGIN PASSWORD 'admin123';
GRANT ALL PRIVILEGES ON DATABASE bibliotheque TO admin_user;


-- Assigner le rôle à un membre du personnel
UPDATE Personnel SET poste = 'Bibliothécaire' WHERE id = 1;
GRANT bibliothecaire_user TO 'nom_personnel' LOGIN;



-- Voir les rôles et privilèges d'un utilisateur
SELECT * FROM information_schema.role_table_grants WHERE grantee = 'nom_utilisateur';


--Requête pour lister les ouvrages internes
SELECT titre, auteur, edition
FROM Ouvrages
WHERE usage_interne = TRUE;


-- Les abonnés peuvent emprunter les ouvrages de toutes les bibliothèques du réseau
SELECT Ouvrages.titre, Bibliotheques.nom AS bibliotheque, Emprunts.date_emprunt, Emprunts.date_retour
FROM Emprunts
JOIN Ouvrages ON Emprunts.ouvrage_id = Ouvrages.id
JOIN Bibliotheques ON Emprunts.bibliotheque_id = Bibliotheques.id
WHERE Emprunts.abonne_id = 1;  -- Remplace 1 par l'ID de l'abonné



--Requête pour déterminer les ouvrages populaires (avec seuil de 7 emprunts)
SELECT Ouvrages.titre, COUNT(Emprunts.id) AS nombre_emprunts
FROM Emprunts
JOIN Ouvrages ON Emprunts.ouvrage_id = Ouvrages.id
GROUP BY Ouvrages.id
HAVING COUNT(Emprunts.id) >= 7;  



--Requête pour vérifier les emprunts en cours avec leurs prolongations
SELECT Ouvrages.titre, Abonnes.nom, Emprunts.date_emprunt, Emprunts.date_retour, Emprunts.prolongations
FROM Emprunts
JOIN Ouvrages ON Emprunts.ouvrage_id = Ouvrages.id
JOIN Abonnes ON Emprunts.abonne_id = Abonnes.id
WHERE Emprunts.statut = 'emprunté' AND Emprunts.prolongations < 2;




--Requête pour vérifier les transferts fréquents (par exemple, 5 transferts)
SELECT Ouvrages.titre, COUNT(Transferts.id) AS nombre_transferts
FROM Transferts
JOIN Ouvrages ON Transferts.ouvrage_id = Ouvrages.id
GROUP BY Ouvrages.id
HAVING COUNT(Transferts.id) >= 5;



SELECT titre, auteur, edition, nombre_pages, collection
FROM Ouvrages
WHERE id = 1;  -- Remplace 1 par l'ID de l'ouvrage




-- Archiver les prêts de plus de 1 mois
CREATE TABLE Archive_Emprunts AS 
SELECT * FROM Emprunts
WHERE date_emprunt < CURRENT_DATE - INTERVAL '1 month';

-- Supprimer les prêts archivés
DELETE FROM Emprunts
WHERE date_emprunt < CURRENT_DATE - INTERVAL '1 month';



-- calcul du temps moyen d'attente 
SELECT AVG(date_retour - date_emprunt) AS temps_moyen_attente
FROM Emprunts
WHERE statut = 'emprunté';




-- Vue : Ouvrages populaires par emprunt
CREATE VIEW ouvrages_populaires AS
SELECT Ouvrages.titre, COUNT(Emprunts.id) AS nombre_emprunts
FROM Emprunts
JOIN Ouvrages ON Emprunts.ouvrage_id = Ouvrages.id
GROUP BY Ouvrages.id
HAVING COUNT(Emprunts.id) > 5;  -- Remplace 5 par le seuil désiré
--et pour consulter la vue:
SELECT * FROM ouvrages_populaires;




-- Créer une fonction de trigger pour mettre à jour le nombre d'emprunts d’un abonné
CREATE OR REPLACE FUNCTION mettre_a_jour_nombre_emprunts()
RETURNS TRIGGER AS $$
BEGIN
  -- Mise à jour du nombre d'emprunts lors de l'ajout
  IF NEW.statut = 'emprunté' THEN
    UPDATE Abonnes
    SET nombre_emprunts = nombre_emprunts + 1
    WHERE id = NEW.abonne_id;
  END IF;

  -- Mise à jour du nombre d'emprunts lors du retour
  IF OLD.statut = 'emprunté' AND NEW.statut = 'retourné' THEN
    UPDATE Abonnes
    SET nombre_emprunts = nombre_emprunts - 1
    WHERE id = NEW.abonne_id;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Créer le trigger pour la table Emprunts
CREATE TRIGGER mise_a_jour_emprunts
AFTER INSERT OR UPDATE ON Emprunts
FOR EACH ROW
EXECUTE FUNCTION mettre_a_jour_nombre_emprunts();



--nombre d'emprunts par bibliothèque
CREATE VIEW emprunts_par_bibliotheque AS
SELECT Bibliotheques.nom AS bibliotheque, COUNT(Emprunts.id) AS nombre_emprunts
FROM Emprunts
JOIN Bibliotheques ON Emprunts.bibliotheque_id = Bibliotheques.id
GROUP BY Bibliotheques.id;
--requête pour consulter la vue:
SELECT * FROM emprunts_par_bibliotheque;



-- Créer une fonction de trigger pour limiter les prolongations
CREATE OR REPLACE FUNCTION limiter_prolongations()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.prolongations >= 2 THEN
    RAISE EXCEPTION 'Le livre ne peut être prolongé plus de 2 fois.';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Créer le trigger qui s'exécutera avant la mise à jour d'un emprunt
CREATE TRIGGER avant_prolongation
BEFORE UPDATE ON Emprunts
FOR EACH ROW
EXECUTE FUNCTION limiter_prolongations();



WITH RECURSIVE livres_recursifs AS (
  -- Sélectionner les livres de la collection initiale
  SELECT id, titre, collection, 1 AS niveau, ouvrage_associe_id
  FROM Ouvrages
  WHERE collection = 'Classiques Français'  -- Remplacer par la collection de ton choix
  UNION ALL
  -- Sélectionner les livres associés aux livres déjà trouvés
  SELECT o.id, o.titre, o.collection, lr.niveau + 1, o.ouvrage_associe_id
  FROM Ouvrages o
  JOIN livres_recursifs lr ON o.id = lr.ouvrage_associe_id
)
SELECT * FROM livres_recursifs;

