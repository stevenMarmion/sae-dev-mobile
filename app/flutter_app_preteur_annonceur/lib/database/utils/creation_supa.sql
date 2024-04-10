-- Création de la table ANNONCE
CREATE TABLE IF NOT EXISTS ANNONCE (
    idAnnonce SERIAL PRIMARY KEY,
    titreA VARCHAR NOT NULL,
    dateCreation DATE NOT NULL,
    IDU BIGINT NOT NULL,
    IDC BIGINT NOT NULL,
    idEtat BIGINT NOT NULL,
    dateCloture DATE NOT NULL,
    FOREIGN KEY (IDU) REFERENCES UTILISATEUR(identifiantUtilisateur),
    FOREIGN KEY (IDC) REFERENCES CATEGORIE(idCategorie),
    FOREIGN KEY (idEtat) REFERENCES ETAT(IDE)
);

-- Création de la table CATEGORIE
CREATE TABLE IF NOT EXISTS CATEGORIE (
    idCategorie SERIAL PRIMARY KEY,
    nomC VARCHAR NOT NULL,
    descriptionC VARCHAR
);

-- Insertion des données dans la table CATEGORIE
INSERT INTO CATEGORIE (nomC, descriptionC) VALUES
('Électronique', 'Téléphones, ordinateurs, appareils photo, etc.'),
('Électroménager', 'Réfrigérateurs, lave-linge, lave-vaisselle, etc.'),
('Outils et bricolage', 'Perceuses, scies, tournevis, etc.'),
('Sports et loisirs', 'Vélos, raquettes, matériel de camping, etc.'),
('Mode et accessoires', 'Vêtements, chaussures, sacs à main, etc.'),
('Maison et décoration', 'Meubles, luminaires, décoration, etc.'),
('Instruments de musique', 'Guitares, pianos, batterie, etc.'),
('Livres et divertissement', 'Romans, bandes dessinées, DVD, etc.'),
('Bébé et enfant', 'Poussettes, jouets, vêtements pour bébés, etc.'),
('Santé et bien-être', 'Équipement de fitness, produits de beauté, etc.');

-- Création de la table ETAT
CREATE TABLE IF NOT EXISTS ETAT (
    IDE SERIAL PRIMARY KEY,
    nomE VARCHAR NOT NULL
);

-- Insertion des données dans la table ETAT
INSERT INTO ETAT (nomE) VALUES
('Ouverte'),
('Pourvue'),
('Clôturée');

-- Création de la table UTILISATEUR
CREATE TABLE IF NOT EXISTS UTILISATEUR (
    identifiantUtilisateur SERIAL PRIMARY KEY,
    nomU VARCHAR NOT NULL,
    prenomU VARCHAR NOT NULL,
    ageU BIGINT NOT NULL,
    adresseMail VARCHAR NOT NULL,
    mdpU VARCHAR NOT NULL,
    pseudoU VARCHAR UNIQUE NOT NULL
);
