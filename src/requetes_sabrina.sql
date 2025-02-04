--empêcher qu'un livre emprunté soit prolongé plus de deux fois. 
CREATE OR REPLACE FUNCTION Limiter_prolongations()
RETURNS TRIGGER AS $$

BEGIN
    IF NEW.prolongations >= 2 THEN
        RAISE EXCEPTION 'Le livre ne peut être prolongé plus de 2 fois.';
    END IF;
    RETURN NEW;
END;

$$ LANGUAGE plpgsql;

CREATE TRIGGER avant_prolongation
BEFORE UPDATE ON Loue
FOR EACH ROW
EXECUTE FUNCTION Limiter_prolongations();



-- récupérer la liste des ouvrages les plus empruntés (empruntés plus de 5 fois)
CREATE VIEW ouvrages_populaires AS
SELECT Ouvrages.titre, COUNT(Loue.exemplaire_id) AS nombre_emprunts
FROM Loue
JOIN Ouvrages ON Loue.exemplaire_id = Ouvrages.id
GROUP BY Ouvrages.id
HAVING COUNT(Loue.exemplaire_id) > 5;
///test :)
SELECT * FROM ouvrages_populaires;




--afficher la liste des ouvrages ayant été transférés au moins 5 fois entre différentes bibliothèques
SELECT Ouvrages.titre, COUNT(Transfers.id) AS nombre_transferts
FROM Transfers
JOIN Ouvrages ON Transfers.exemplaire_id = Ouvrages.id
GROUP BY Ouvrages.id
HAVING COUNT(Transfers.id) >= 5;





--afficher la liste des livres actuellement empruntés mais pas encore retournés, à condition que l'abonné ait moins de 2 prolongations
SELECT Ouvrages.titre, Abonnes.nom, Loue.date_emprunt, Loue.date_retour, Loue.prolongations
FROM Loue
JOIN Ouvrages ON Loue.exemplaire_id = Ouvrages.id
JOIN Abonnes ON Loue.abonne_id = Abonnes.id
WHERE Loue.date_retour IS NULL AND Loue.prolongations < 2;





--afficher tous les livres empruntés par un abonné spécifique
SELECT Ouvrages.titre, Bibliotheques.nom AS bibliotheque, Loue.date_emprunt, Loue.date_retour
FROM Loue
JOIN Ouvrages ON Loue.exemplaire_id = Ouvrages.id
JOIN Exemplaires ON Loue.exemplaire_id = Exemplaires.id
JOIN Bibliotheques ON Exemplaires.bibliotheque_id = Bibliotheques.id
WHERE Loue.abonne_id = 1;





--fonction qui calcule le nombre de jours restants avant le retour prévu d'un exemplaire emprunté.
CREATE OR REPLACE FUNCTION jours_restants(exemplaire_id_param INT)
RETURNS INT AS $$
DECLARE
    date_retour DATE;
BEGIN
    SELECT Loue.date_retour INTO date_retour
    FROM Loue
    WHERE Loue.exemplaire_id = exemplaire_id_param AND Loue.date_retour IS NOT NULL
    ORDER BY Loue.date_retour DESC
    LIMIT 1;

    IF date_retour IS NOT NULL THEN
        RETURN GREATEST((date_retour - CURRENT_DATE), 0);  -- Retourne 0 si date de retour dépassée
    ELSE
        RETURN NULL;
    END IF;
END;
$$ LANGUAGE plpgsql;
SELECT jours_restants(4);




--trouver les ouvrages disponibles dans des bibliothèques autres que celle où l'abonné est inscrit et qui n'ont jamais été empruntés par cet abonné
SELECT o.id AS ouvrage_id, o.titre, e.id AS exemplaire_id, b.nom AS bibliotheque_actuelle
FROM Exemplaires e
JOIN Ouvrages o ON e.ouvrage_id = o.id
JOIN Bibliotheques b ON e.bibliotheque_id = b.id
WHERE e.disponible = TRUE
AND e.bibliotheque_id != (
    SELECT bibliotheque_id 
    FROM S_abonne 
    WHERE abonne_id = 2
)
AND e.ouvrage_id NOT IN (
    SELECT exemplaire_id
    FROM Loue
    WHERE abonne_id = 2
);






-- Quels abonnés ne respectent pas les délais de prêt et quelle est leur fréquence d’infraction ?
SELECT a.id AS abonne_id, a.nom, a.prenom, COUNT(*) AS infractions
FROM Loue l
JOIN Abonnes a ON l.abonne_id = a.id
WHERE l.date_retour IS NOT NULL 
AND l.date_retour > l.date_emprunt + INTERVAL '30 days'
GROUP BY a.id, a.nom, a.prenom
ORDER BY infractions DESC;










