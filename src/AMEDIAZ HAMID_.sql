CREATE VIEW emprunts_par_bibliotheque AS
SELECT Bibliotheques.nom AS bibliotheque, COUNT(Loue.exemplaire_id) AS nombre_emprunts
FROM Loue
JOIN Exemplaires ON Loue.exemplaire_id = Exemplaires.id
JOIN Bibliotheques ON Exemplaires.bibliotheque_id = Bibliotheques.id
GROUP BY Bibliotheques.id;

-- test :)
SELECT * FROM emprunts_par_bibliotheque;





CREATE OR REPLACE FUNCTION mettre_a_jour_nombre_emprunts()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.date_retour IS NULL THEN
        UPDATE Abonnes
        SET nombre_emprunts = nombre_emprunts + 1
        WHERE id = NEW.abonne_id;
    END IF;

    IF OLD.date_retour IS NULL AND NEW.date_retour IS NOT NULL THEN
        UPDATE Abonnes
        SET nombre_emprunts = nombre_emprunts - 1
        WHERE id = NEW.abonne_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER mise_a_jour_emprunts
AFTER INSERT OR UPDATE ON Loue
FOR EACH ROW
EXECUTE FUNCTION mettre_a_jour_nombre_emprunts();








CREATE TABLE Archive_Loue AS
SELECT * FROM Loue
WHERE date_emprunt < CURRENT_DATE - INTERVAL '1 month';

DELETE FROM Loue
WHERE date_emprunt < CURRENT_DATE - INTERVAL '1 month';






SELECT Ouvrages.titre, COUNT(Loue.exemplaire_id) AS nombre_emprunts
FROM Loue
JOIN Ouvrages ON Loue.exemplaire_id = Ouvrages.id
GROUP BY Ouvrages.id
HAVING COUNT(Loue.exemplaire_id) >= 7;






SELECT titre, auteur, edition
FROM Ouvrages
WHERE usage_interne = TRUE;








CREATE OR REPLACE FUNCTION check_book_availability()
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT COUNT(*) FROM Reserve WHERE exemplaire_id = NEW.exemplaire_id) > 0 THEN
        RAISE EXCEPTION 'Le livre est déjà réservé.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_availability
BEFORE INSERT ON Loue
FOR EACH ROW
EXECUTE FUNCTION check_book_availability();