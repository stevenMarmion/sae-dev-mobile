CREATE TABLE ETAT (
    ID_Etat INTEGER PRIMARY KEY,
    Nom_Etat TEXT,
    Description_Etat TEXT
);

INSERT INTO ETAT (ID_Etat, Nom_Etat, Description_Etat) VALUES
(1, 'Ouverte', 'Annonce ouverte'),
(2, 'Pourvue', 'Annonce pourvue'),
(3, 'Clôturée', 'Annonce clôturée');

CREATE TABLE CATEGORIE (
    ID_Categorie INTEGER PRIMARY KEY,
    Nom_Categorie TEXT,
    Description_Categorie TEXT
);

INSERT INTO CATEGORIE (ID_Categorie, Nom_Categorie, Description_Categorie) VALUES
(1, 'Électronique', 'Téléphones, ordinateurs, appareils photo, etc.'),
(2, 'Électroménager', 'Réfrigérateurs, lave-linge, lave-vaisselle, etc.'),
(3, 'Outils et bricolage', 'Perceuses, scies, tournevis, etc.'),
(4, 'Sports et loisirs', 'Vélos, raquettes, matériel de camping, etc.'),
(5, 'Mode et accessoires', 'Vêtements, chaussures, sacs à main, etc.'),
(6, 'Maison et décoration', 'Meubles, luminaires, décoration, etc.'),
(7, 'Instruments de musique', 'Guitares, pianos, batterie, etc.'),
(8, 'Livres et divertissement', 'Romans, bandes dessinées, DVD, etc.'),
(9, 'Bébé et enfant', 'Poussettes, jouets, vêtements pour bébés, etc.'),
(10, 'Santé et bien-être', 'Équipement de fitness, produits de beauté, etc.');

CREATE TABLE AnnonceLocale (
    ID_Annonce INTEGER PRIMARY KEY,
    Titre TEXT,
    Description TEXT,
    ID_Categorie INTEGER,
    ID_Etat INTEGER,
    Date_Creation DATE,
    Date_Cloture DATE,
    FOREIGN KEY (ID_Categorie) REFERENCES CATEGORIE(ID_Categorie),
    FOREIGN KEY (ID_Etat) REFERENCES ETAT(ID_Etat)
);

CREATE TABLE Bien (
    ID_Bien INTEGER PRIMARY KEY,
    Nom TEXT,
    ID_Categorie INTEGER,
    FOREIGN KEY (ID_Categorie) REFERENCES CATEGORIE(ID_Categorie)
);
