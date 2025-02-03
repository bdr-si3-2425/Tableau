CREATE TABLE Archive_Emprunts (
    id SERIAL PRIMARY KEY,
    ouvrage_id INT,
    abonne_id INT,
    date_emprunt DATE,
    date_retour DATE,
    statut VARCHAR(50)
);

-- Créer une fonction pour archiver un emprunt dépassant la date de retour
CREATE OR REPLACE FUNCTION archiver_empreint_retard()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.date_retour < CURRENT_DATE AND NEW.statut = 'emprunté' THEN
    INSERT INTO Archive_Emprunts (ouvrage_id, abonne_id, date_emprunt, date_retour, statut)
    VALUES (NEW.ouvrage_id, NEW.abonne_id, NEW.date_emprunt, NEW.date_retour, NEW.statut);

    -- Supprimer l'emprunt de la table principale
    DELETE FROM Emprunts WHERE id = NEW.id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Créer un trigger pour vérifier les emprunts en retard et les archiver
CREATE TRIGGER archiver_empreint_retard_trigger
AFTER UPDATE ON Emprunts
FOR EACH ROW
EXECUTE FUNCTION archiver_empreint_retard();






CREATE VIEW historique_evenements AS
SELECT Evenements.nom, Evenements.date_evenement, Evenements.theme, Personnel.nom AS bibliothecaire
FROM Evenements
JOIN Bibliotheques ON Evenements.bibliotheque_id = Bibliotheques.id
JOIN Personnel ON Bibliotheques.id = Personnel.bibliotheque_id
WHERE Personnel.poste = 'Bibliothécaire';


SELECT * FROM historique_evenements;

