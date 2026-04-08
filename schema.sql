-- ==========================================
-- GEDEELDE STAMGEGEVENS (Entiteiten)
-- ==========================================

CREATE TABLE Filiaal (
    filiaalnr INTEGER,
    naam TEXT,
    adres TEXT,
    provincie TEXT,

    PRIMARY KEY(filiaalnr)
);

CREATE TABLE Klant (
    klantnr INTEGER,
    naam TEXT,
    adres TEXT,
    woonplaats TEXT,
    geslacht CHAR(1),
    geboortedatum VARCHAR(10),

    PRIMARY KEY(klantnr)
);

CREATE TABLE Fabrikant (
    fabrikantnr INTEGER,
    naam TEXT,
    adres TEXT,
    plaats TEXT,

    PRIMARY KEY(fabrikantnr)
);

CREATE TABLE Leverancier (
    leveranciernr INTEGER,
    naam TEXT,
    adres TEXT,
    woonplaats TEXT,

    PRIMARY KEY(leveranciernr)
);

CREATE TABLE Monteur (
    monteurnr INTEGER,
    naam TEXT,
    woonplaats TEXT,
    uurloon REAL,
    filiaal INTEGER NOT NULL,

    PRIMARY KEY(monteurnr),
    FOREIGN KEY(filiaal) REFERENCES Filiaal(filiaalnr)
);

CREATE TABLE Fiets (
    fietsnr INTEGER,
    soort TEXT,
    merk TEXT,
    type TEXT,
    standaardprijs REAL,
    inkoopprijs REAL,
    kleur TEXT,
    fabrikant INTEGER NOT NULL,

    PRIMARY KEY(fietsnr),
    FOREIGN KEY(fabrikant) REFERENCES Fabrikant(fabrikantnr)
);

CREATE TABLE Accessoire (
    accessoirenr INTEGER,
    naam TEXT,
    standaardprijs REAL,
    inkoopprijs REAL,
    soort TEXT,
    leverancier INTEGER NOT NULL,

    PRIMARY KEY(accessoirenr),
    FOREIGN KEY(leverancier) REFERENCES Leverancier(leveranciernr)
);

-- ==========================================
-- TRANSACTIETABELLEN
-- ==========================================

-- Fietsverkoop
CREATE TABLE Fiets_Verkoop (
    fiets_verkoopnr INTEGER,
    datum VARCHAR(10),
    aantal INTEGER,
    verkoopprijs REAL,
    klant INTEGER NOT NULL,
    fiets INTEGER NOT NULL,
    monteur INTEGER NOT NULL,

    PRIMARY KEY(fiets_verkoopnr),
    FOREIGN KEY(klant) REFERENCES Klant(klantnr),
    FOREIGN KEY(fiets) REFERENCES Fiets(fietsnr),
    FOREIGN KEY(monteur) REFERENCES Monteur(monteurnr)
);

-- Accessoireverkoop
CREATE TABLE Accessoire_Verkoop (
    accessoire_verkoopnr INTEGER,
    datum VARCHAR(10),
    aantal INTEGER,
    verkoopprijs REAL,
    klant INTEGER NOT NULL,
    accessoire INTEGER NOT NULL,
    monteur INTEGER NOT NULL,

    PRIMARY KEY(accessoire_verkoopnr),
    FOREIGN KEY(klant) REFERENCES Klant(klantnr),
    FOREIGN KEY(accessoire) REFERENCES Accessoire(accessoirenr),
    FOREIGN KEY(monteur) REFERENCES Monteur(monteurnr)
);

-- Accessoire-inkoop (Foreign Keys aangepast naar de gedeelde tabellen)
CREATE TABLE Accessoire_Inkoop (
	inkoopnr INT,
	inkoopmaand INT,
	inkoopjaar INT,
	aantal INT,
	accessoire INT NOT NULL,

	PRIMARY KEY(inkoopnr),
	FOREIGN KEY(accessoire) REFERENCES Accessoire(accessoirenr)
);

-- Fietsinkoop (Foreign Keys aangepast naar de gedeelde tabellen)
CREATE TABLE Fiets_Inkoop (
	inkoopnr INT,
	inkoopmaand INT,
	inkoopjaar INT,
	aantal INT,
	fiets INT NOT NULL,

	PRIMARY KEY(inkoopnr),
	FOREIGN KEY(fiets) REFERENCES Fiets(fietsnr)
);

-- Onderhoud (Foreign Keys aangepast naar de gedeelde tabellen)
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