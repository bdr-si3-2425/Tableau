CREATE TABLE Bibliotheques (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255) NOT NULL,
    adresse TEXT NOT NULL,
    telephone VARCHAR(20),
    email VARCHAR(255)
);

CREATE TABLE Abonnes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255) NOT NULL,
    prenom VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    telephone VARCHAR(20),
    adresse TEXT,
    bibliotheque_id INT,
    FOREIGN KEY (bibliotheque_id) REFERENCES Bibliotheques(id)
);

CREATE TABLE Participants (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255) NOT NULL,
    prenom VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    telephone VARCHAR(20)
);

CREATE TABLE Evenements (
    id INT PRIMARY KEY AUTO_INCREMENT,
    bibliotheque_id INT,
    nom VARCHAR(255) NOT NULL,
    date DATE NOT NULL,
    theme VARCHAR(255),
    duree INT, --en minutes
    lieu VARCHAR(255),
    organisateur VARCHAR(255),
    FOREIGN KEY (bibliotheque_id) REFERENCES Bibliotheques(id)
);

CREATE TABLE Participe (
    participant_id INT,
    evenement_id INT,
    PRIMARY KEY (participant_id, evenement_id),
    FOREIGN KEY (participant_id) REFERENCES Participants(id),
    FOREIGN KEY (evenement_id) REFERENCES Evenements(id)
);

CREATE TABLE Ouvrages (
    id INT PRIMARY KEY AUTO_INCREMENT,
    titre VARCHAR(255) NOT NULL,
    auteur VARCHAR(255),
    collection VARCHAR(255),
    edition VARCHAR(255),
    nombre_pages INT,
    usage_interne BOOLEAN DEFAULT FALSE
);

CREATE TABLE Exemplaires (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ouvrage_id INT NOT NULL,
    bibliotheque_id INT NOT NULL,
    emplacement VARCHAR(255),
    disponible BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (ouvrage_id) REFERENCES Ouvrages(id),
    FOREIGN KEY (bibliotheque_id) REFERENCES Bibliotheques(id)
);

CREATE TABLE Reserve (
    abonne_id INT,
    exemplaire_id INT,
    date_reservation DATE NOT NULL,
    PRIMARY KEY (abonne_id, exemplaire_id),
    FOREIGN KEY (abonne_id) REFERENCES Abonnes(id),
    FOREIGN KEY (exemplaire_id) REFERENCES Exemplaires(id)
);

CREATE TABLE Loue (
    abonne_id INT,
    exemplaire_id INT,
    date_emprunt DATE NOT NULL,
    date_retour DATE,
    PRIMARY KEY (abonne_id, exemplaire_id),
    FOREIGN KEY (abonne_id) REFERENCES Abonnes(id),
    FOREIGN KEY (exemplaire_id) REFERENCES Exemplaires(id)
);

CREATE TABLE Transferts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    exemplaire_id INT NOT NULL,
    bibliotheque_source_id INT NOT NULL,
    bibliotheque_destination_id INT NOT NULL,
    date_transfert DATE NOT NULL,
    FOREIGN KEY (exemplaire_id) REFERENCES Exemplaires(id),
    FOREIGN KEY (bibliotheque_source_id) REFERENCES Bibliotheques(id),
    FOREIGN KEY (bibliotheque_destination_id) REFERENCES Bibliotheques(id)
);

CREATE TABLE S_abonne (
    abonne_id INT NOT NULL,
    bibliotheque_id INT NOT NULL,
    date_abonnement DATE NOT NULL,
    PRIMARY KEY (abonne_id, bibliotheque_id),
    FOREIGN KEY (abonne_id) REFERENCES Abonnes(id),
    FOREIGN KEY (bibliotheque_id) REFERENCES Bibliotheques(id)
);

CREATE TABLE Personnel (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255) NOT NULL,
    prenom VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    telephone VARCHAR(20),
    adresse TEXT,
    role ENUM('gestionnaire', 'administrateur', 'bibliothécaire') NOT NULL,
    bibliotheque_id INT,
    FOREIGN KEY (bibliotheque_id) REFERENCES Bibliotheques(id)
);

