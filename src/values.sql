INSERT INTO Bibliotheques (id, nom, adresse, telephone, email) VALUES
('1','Bibliothèque Centrale', '10 rue des Livres, Paris', '0123456789', 'contact@biblio-paris.fr'),
('2','Médiathèque Lyon', '20 place Bellecour, Lyon', '0456789123', 'contact@biblio-lyon.fr'),
('3','Bibliothèque Universitaire', '5 avenue du Savoir, Toulouse', '0567891234', 'contact@biblio-toulouse.fr'),
('4','Bibliothèque Régionale', '30 rue des Savoirs, Marseille', '0490123456', 'contact@biblio-marseille.fr'),
('5','Médiathèque de Lille', '12 avenue du Livre, Lille', '0323456789', 'contact@biblio-lille.fr');

INSERT INTO Abonnes (id, nom, prenom, email, telephone, adresse, bibliotheque_id) VALUES
('1','Durand', 'Alice', 'alice.durand@mail.com', '0612345678', '15 rue des Fleurs, Paris', 1),
('2','Martin', 'Paul', 'paul.martin@mail.com', '0623456789', '22 avenue des Champs, Lyon', 2),
('3','Bernard', 'Sophie', 'sophie.bernard@mail.com', '0634567890', '7 boulevard Saint-Michel, Toulouse', 3),
('4','Lemoine', 'Jean', 'jean.lemoine@mail.com', '0645678901', '10 place du Marché, Marseille', 4),
('5','Garcia', 'Emma', 'emma.garcia@mail.com', '0656789012', '5 rue Victor Hugo, Lille', 5),
('6','Dulon','Alex','alex.dulon@mail.com','0602345678','15 rue des Dolines, Paris',1),
('7','Farat','Paul','paul.farat@mail.com','0652771278','15 rue des Palais, Paris',1);

INSERT INTO Participants (id, nom, prenom, email, telephone) VALUES
('1','Lemoine', 'Jean', 'jean.lemoine@mail.com', '0611111176'),
('2','Garcia', 'Emma', 'emma.garcia@mail.com', '0622222222'),
('3','Petit', 'Louis', 'louis.petit@mail.com', '0633333333'),
('4','Morel', 'Nina', 'nina.morel@mail.com', '0644444444'),
('5','Dubois', 'Luc', 'luc.dubois@mail.com', '0655555555');

INSERT INTO Evenements (id, bibliotheque_id, nom, date, theme, duree, lieu, organisateur) VALUES
('01',1, 'Conférence sur la littérature', '2025-03-15', 'Littérature', 120, 'Salle principale', 'Dr. Moreau'),
('02',2, 'Atelier d_écriture', '2025-04-10', 'Écriture', 90, 'Salle des ateliers', 'Mme Lefèvre'),
('03',3,'Projection de film', '2025-05-20', 'Cinéma', 150, 'Amphithéâtre', 'M. Dubois'),
('04',4,'Rencontre avec un auteur', '2025-06-05', 'Rencontre', 100, 'Salle de conférence', 'M. Lemoine'),
('05',5, 'Atelier BD', '2025-07-10', 'Bande Dessinée', 120, 'Salle des BD', 'Mme Garcia');

INSERT INTO Participe (participant_id, evenement_id) VALUES
(1, 1), (2, 1), (3, 2), (4, 3), (5, 4);

INSERT INTO Ouvrages (id, titre, auteur, collection, edition, nombre_pages, usage_interne) VALUES
('1','Encyclopédie Universelle', 'Collectif', 'Encyclopédies', 'Larousse', 2000, TRUE),
('2','Le Petit Prince', 'Antoine de Saint-Exupéry', 'Romans de poche', 'Gallimard', 96, TRUE),
('3','1984', 'George Orwell', 'Romans de poche', 'Gallimard', 328, FALSE),
('4','Les Misérables', 'Victor Hugo', 'Romans de poche', 'Folio', 1463, FALSE),
('5','Astérix et Obélix', 'René Goscinny', 'BD', 'Hachette', 48, FALSE),
('6','Tintin au Tibet', 'Hergé', 'BD', 'Casterman', 62, FALSE),
('7','L_Étranger', 'Albert Camus', 'Romans de poche', 'Folio', 123, FALSE),
('8','Harry Potter à l_école des sorciers', 'J.K. Rowling', 'Romans de poche', 'Gallimard', 320, FALSE);

INSERT INTO Exemplaires (id,ouvrage_id, bibliotheque_id, emplacement, disponible) VALUES
('01',1, 1, 'Section Encyclopédies - Rayon A1', TRUE),
('02',2, 1, 'Section Romans de poche - Rayon B1', TRUE),
('03',3, 2, 'Section Romans de poche - Rayon B3', TRUE),
('04',4, 3, 'Section Romans de poche - Rayon B5', FALSE),
('05',5, 3, 'Section BD - Rayon C2', TRUE),
('06',6, 4, 'Section BD - Rayon C3', TRUE),
('07',7, 5, 'Section Romans de poche - Rayon B2', TRUE),
('08',8, 2, 'Section Romans de poche - Rayon B4', TRUE);

INSERT INTO Reserve (abonne_id, exemplaire_id, date_reservation) VALUES
(1, 2, '2025-02-10'),
(2, 3, '2025-02-11'),
(3, 5, '2025-02-12'),
(4, 6, '2025-02-13'),
(5, 8, '2025-02-14');

INSERT INTO Loue (abonne_id, exemplaire_id, date_emprunt, date_retour) VALUES
(5,7,'2025-02-06','2025-02-20'),
(3,4,'2025-02-05','2025-02-28'),
(4,4,'2025-03-05','2025-03-28'),
(6,4,'2025-04-05','2025-03-29'),
(7,4,'2025-06-09','2025-07-28'),
(2,4,'2025-08-05','2025-08-13'),
(1,4,'2025-08-15','2025-09-01'),
(6,6,'2025-02-05','2025-02-28'),
(2,3,'2025-02-05','2025-02-28'),
(7,2,'2025-02-05','2025-02-28'),
(6,2,'2025-02-05',NULL),
(4,2,'2025-02-06',NULL);

INSERT INTO Transferts (id, exemplaire_id, bibliotheque_source_id, bibliotheque_destination_id, date_transfert) VALUES
(1,1, 1, 2, '2025-02-07'),
(2,3, 2, 3, '2025-02-08'),
(3,3, 1, 2, '2025-02-17'),
(4,3, 2, 2, '2025-02-25'),
(5,3, 2, 2, '2025-03-02'),
(6,3, 1, 2, '2025-03-05'),
(7,3, 1, 2, '2025-02-12'),
(8,3, 1, 2, '2025-02-15'),
(9,2, 3, 2, '2025-03-07'),
(10,4, 2, 2, '2025-03-09'),
(11,4, 1, 2, '2025-03-13'),
(12,1, 4, 2, '2025-03-11');


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
