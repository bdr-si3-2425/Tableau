INSERT INTO Bibliotheques (nom, adresse, telephone, email) VALUES
('Bibliothèque Centrale', '10 rue des Livres, Paris', '0123456789', 'contact@biblio-paris.fr'),
('Médiathèque Lyon', '20 place Bellecour, Lyon', '0456789123', 'contact@biblio-lyon.fr'),
('Bibliothèque Universitaire', '5 avenue du Savoir, Toulouse', '0567891234', 'contact@biblio-toulouse.fr'),
('Bibliothèque Régionale', '30 rue des Savoirs, Marseille', '0490123456', 'contact@biblio-marseille.fr'),
('Médiathèque de Lille', '12 avenue du Livre, Lille', '0323456789', 'contact@biblio-lille.fr');

INSERT INTO Abonnes (nom, prenom, email, telephone, adresse, bibliotheque_id) VALUES
('Durand', 'Alice', 'alice.durand@mail.com', '0612345678', '15 rue des Fleurs, Paris', 1),
('Martin', 'Paul', 'paul.martin@mail.com', '0623456789', '22 avenue des Champs, Lyon', 2),
('Bernard', 'Sophie', 'sophie.bernard@mail.com', '0634567890', '7 boulevard Saint-Michel, Toulouse', 3),
('Lemoine', 'Jean', 'jean.lemoine@mail.com', '0645678901', '10 place du Marché, Marseille', 4),
('Garcia', 'Emma', 'emma.garcia@mail.com', '0656789012', '5 rue Victor Hugo, Lille', 5);

INSERT INTO Participants (nom, prenom, email, telephone) VALUES
('Lemoine', 'Jean', 'jean.lemoine@mail.com', '0611111111'),
('Garcia', 'Emma', 'emma.garcia@mail.com', '0622222222'),
('Petit', 'Louis', 'louis.petit@mail.com', '0633333333'),
('Morel', 'Nina', 'nina.morel@mail.com', '0644444444'),
('Dubois', 'Luc', 'luc.dubois@mail.com', '0655555555');

INSERT INTO Evenements (bibliotheque_id, nom, date, theme, duree, lieu, organisateur) VALUES
(1, 'Conférence sur la littérature', '2025-03-15', 'Littérature', 120, 'Salle principale', 'Dr. Moreau'),
(2, 'Atelier d'écriture', '2025-04-10', 'Écriture', 90, 'Salle des ateliers', 'Mme Lefèvre'),
(3, 'Projection de film', '2025-05-20', 'Cinéma', 150, 'Amphithéâtre', 'M. Dubois'),
(4, 'Rencontre avec un auteur', '2025-06-05', 'Rencontre', 100, 'Salle de conférence', 'M. Lemoine'),
(5, 'Atelier BD', '2025-07-10', 'Bande Dessinée', 120, 'Salle des BD', 'Mme Garcia');

INSERT INTO Participe (participant_id, evenement_id) VALUES
(1, 1), (2, 1), (3, 2), (4, 3), (5, 4);

INSERT INTO Ouvrages (titre, auteur, collection, edition, nombre_pages, usage_interne) VALUES
('Encyclopédie Universelle', 'Collectif', 'Encyclopédies', 'Larousse', 2000, TRUE),
('Le Petit Prince', 'Antoine de Saint-Exupéry', 'Romans de poche', 'Gallimard', 96, TRUE),
('1984', 'George Orwell', 'Romans de poche', 'Gallimard', 328, FALSE),
('Les Misérables', 'Victor Hugo', 'Romans de poche', 'Folio', 1463, FALSE),
('Astérix et Obélix', 'René Goscinny', 'BD', 'Hachette', 48, FALSE),
('Tintin au Tibet', 'Hergé', 'BD', 'Casterman', 62, FALSE),
('L'Étranger', 'Albert Camus', 'Romans de poche', 'Folio', 123, FALSE),
('Harry Potter à l'école des sorciers', 'J.K. Rowling', 'Romans de poche', 'Gallimard', 320, FALSE);

INSERT INTO Exemplaires (ouvrage_id, bibliotheque_id, emplacement, disponible) VALUES
(1, 1, 'Section Encyclopédies - Rayon A1', TRUE),
(2, 1, 'Section Romans de poche - Rayon B1', TRUE),
(3, 2, 'Section Romans de poche - Rayon B3', TRUE),
(4, 3, 'Section Romans de poche - Rayon B5', FALSE),
(5, 3, 'Section BD - Rayon C2', TRUE),
(6, 4, 'Section BD - Rayon C3', TRUE),
(7, 5, 'Section Romans de poche - Rayon B2', TRUE),
(8, 2, 'Section Romans de poche - Rayon B4', TRUE);

INSERT INTO Reserve (abonne_id, exemplaire_id, date_reservation) VALUES
(1, 2, '2025-02-10'),
(2, 3, '2025-02-11'),
(3, 5, '2025-02-12'),
(4, 6, '2025-02-13'),
(5, 8, '2025-02-14');

INSERT INTO Loue (abonne_id, exemplaire_id, date_emprunt, date_retour) VALUES
(3, 4, '2025-02-05', NULL),
(5, 7, '2025-02-06', '2025-02-20');

INSERT INTO Transferts (exemplaire_id, bibliotheque_source_id, bibliotheque_destination_id, date_transfert) VALUES
(1, 1, 2, '2025-02-07'),
(3, 2, 3, '2025-02-08');

INSERT INTO S_abonne (abonne_id, bibliotheque_id, date_abonnement) VALUES
(1, 1, '2025-01-01'),
(2, 2, '2025-01-02'),
(3, 3, '2025-01-03'),
(4, 4, '2025-01-04'),
(5, 5, '2025-01-05');

INSERT INTO Personnel (nom, prenom, email, telephone, adresse, role, bibliotheque_id) VALUES
('Leroy', 'Camille', 'camille.leroy@mail.com', '0678901234', '3 rue du Savoir, Paris', 'gestionnaire', 1),
('Dubois', 'Luc', 'luc.dubois@mail.com', '0689012345', '8 place du Marché, Lyon', 'bibliothécaire', 2),
('Morel', 'Nina', 'nina.morel@mail.com', '0690123456', '12 boulevard Victor, Toulouse', 'administrateur', 3),
('Faure', 'Pierre', 'pierre.faure@mail.com', '0676543210', '25 rue du Lac, Marseille', 'bibliothécaire', 4),
('Bertrand', 'Julie', 'julie.bertrand@mail.com', '0665432109', '7 avenue du Nord, Lille', 'gestionnaire', 5);
