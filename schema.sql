CREATE TABLE Leverancier (
    leveranciernr INT,
    naam VARCHAR(45),
    adres VARCHAR(100),
    woonplaats VARCHAR(45),
    PRIMARY KEY(leveranciernr)
);

CREATE TABLE Fabrikant (
    fabrikantnr INT,
    naam VARCHAR(45),
    adres VARCHAR(100),
    plaats VARCHAR(45),
    PRIMARY KEY(fabrikantnr)
);

CREATE TABLE Filiaal (
    filiaalnr INT,
    naam VARCHAR(45),
    adres VARCHAR(100),
    provincie VARCHAR(20),
    PRIMARY KEY(filiaalnr)
);

CREATE TABLE Klant (
    klantnr INT,
    naam VARCHAR(45),
    adres VARCHAR(100),
    woonplaats VARCHAR(45),
    geslacht VARCHAR(45),
    geboortedatum DATE,
    PRIMARY KEY(klantnr)
);


CREATE TABLE Monteur (
    monteurnr INT,
    naam VARCHAR(45),
    woonplaats VARCHAR(45),
    uurloon FLOAT,
    filiaal INT NOT NULL,
    PRIMARY KEY(monteurnr),
    FOREIGN KEY(filiaal) REFERENCES Filiaal(filiaalnr)
);

CREATE TABLE Accessoire (
    accessoirenr INT,
    naam VARCHAR(45),
    standaardprijs FLOAT,
    inkoopprijs FLOAT,
    soort VARCHAR(45),
    leverancier INT NOT NULL,
    PRIMARY KEY(accessoirenr),
    FOREIGN KEY(leverancier) REFERENCES Leverancier(leveranciernr)
);

CREATE TABLE Fiets (
    fietsnr INT,
    soort VARCHAR(45),
    merk VARCHAR(45),
    type VARCHAR(45),
    standaardprijs FLOAT,
    inkoopprijs FLOAT,
    kleur VARCHAR(20),
    fabrikant INT NOT NULL,
    PRIMARY KEY(fietsnr),
    FOREIGN KEY(fabrikant) REFERENCES Fabrikant(fabrikantnr)
);


CREATE TABLE Fiets_Inkoop (
    inkoopnr INT,
    inkoopmaand INT,
    inkoopjaar INT,
    aantal INT,
    fietsnr INT NOT NULL,
    PRIMARY KEY(inkoopnr),
    FOREIGN KEY(fietsnr) REFERENCES Fiets(fietsnr)
);

CREATE TABLE Accessoire_Inkoop (
    inkoopnr INT,
    inkoopmaand INT,
    inkoopjaar INT,
    aantal INT,
    accessoirenr INT NOT NULL,
    PRIMARY KEY(inkoopnr),
    FOREIGN KEY(accessoirenr) REFERENCES Accessoire(accessoirenr)
);

CREATE TABLE Fiets_Verkoop (
    fiets_verkoopnr INT,
    datum DATE,
    aantal INT,
    verkoopprijs FLOAT,
    klant INT NOT NULL,
    fiets INT NOT NULL,
    monteur INT NOT NULL,
    PRIMARY KEY(fiets_verkoopnr),
    FOREIGN KEY(klant) REFERENCES Klant(klantnr),
    FOREIGN KEY(fiets) REFERENCES Fiets(fietsnr),
    FOREIGN KEY(monteur) REFERENCES Monteur(monteurnr)
);

CREATE TABLE Accessoire_Verkoop (
    accessoire_verkoopnr INT,
    datum DATE,
    aantal INT,
    verkoopprijs FLOAT,
    klant INT NOT NULL,
    accessoire INT NOT NULL,
    monteur INT NOT NULL,
    PRIMARY KEY(accessoire_verkoopnr),
    FOREIGN KEY(klant) REFERENCES Klant(klantnr),
    FOREIGN KEY(accessoire) REFERENCES Accessoire(accessoirenr),
    FOREIGN KEY(monteur) REFERENCES Monteur(monteurnr)
);

CREATE TABLE Onderhoud (
    onderhoudnr INT,
    datum DATE,
    starttijd TIME,
    eindtijd TIME,
    fiets INT NOT NULL,
    monteur INT NOT NULL,
    PRIMARY KEY(onderhoudnr),
    FOREIGN KEY(fiets) REFERENCES Fiets(fietsnr),
    FOREIGN KEY(monteur) REFERENCES Monteur(monteurnr)
);