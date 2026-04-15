-- =============================================================
--  SterSchema – Data Warehouse DDL  (SQLite)
--  Star schema: 5 dimension tables + 3 fact tables
-- =============================================================

PRAGMA foreign_keys = ON;

-- DIM_Tijd (Time dimension)
CREATE TABLE IF NOT EXISTS DIM_Tijd (
    datum       TEXT    NOT NULL,
    dag         INTEGER NOT NULL,
    maand       INTEGER NOT NULL,
    kwartaal    INTEGER NOT NULL,
    jaar        INTEGER NOT NULL,
    weekend     INTEGER NOT NULL CHECK (weekend IN (0, 1)),
    PRIMARY KEY (datum)
);

-- DIM_Product (Bron: Fiets UNION Accessoire)
CREATE TABLE IF NOT EXISTS DIM_Product (
    productnr       INTEGER PRIMARY KEY AUTOINCREMENT,
    type            TEXT    NOT NULL,
    naam            TEXT    NOT NULL,
    producttype     TEXT    NOT NULL CHECK (producttype IN ('Fiets', 'Accessoire')),
    standaardprijs  REAL    NOT NULL,
    inkoopprijs     REAL    NOT NULL,
    prijsklasse     TEXT    NOT NULL CHECK (prijsklasse IN ('Low', 'Mid', 'High')),
    kleur           TEXT,
    merk            TEXT,
    geldig_van      TEXT    NOT NULL DEFAULT '1900-01-01',
    geldig_tot      TEXT    NOT NULL DEFAULT '9999-12-31',
    is_actief       INTEGER NOT NULL DEFAULT 1
);

-- DIM_Klant (SCD Type 2)
CREATE TABLE IF NOT EXISTS DIM_Klant (
    surrogate_id        INTEGER PRIMARY KEY AUTOINCREMENT,
    klantnr             INTEGER NOT NULL,
    naam                TEXT    NOT NULL,
    adres               TEXT,
    woonplaats          TEXT,
    geslacht            TEXT,
    geboortedatum       TEXT,
    leeftijdscategorie  TEXT,
    geldig_van          TEXT    NOT NULL DEFAULT '1900-01-01',
    geldig_tot          TEXT    NOT NULL DEFAULT '9999-12-31',
    is_actief           INTEGER NOT NULL DEFAULT 1
);

-- DIM_Partner (Bron: Leverancier UNION Fabrikant)
CREATE TABLE IF NOT EXISTS DIM_Partner (
    partnernr   INTEGER PRIMARY KEY AUTOINCREMENT,
    naam        TEXT    NOT NULL,
    partnertype TEXT    NOT NULL CHECK (partnertype IN ('Leverancier', 'Fabrikant')),
    locatie     TEXT
);

-- DIM_Medewerker (Bron: Monteur + Filiaal)
CREATE TABLE IF NOT EXISTS DIM_Medewerker (
    monteurID   INTEGER PRIMARY KEY,
    naam        TEXT    NOT NULL,
    uurloon     REAL    NOT NULL,
    woonplaats  TEXT,
    filiaal     TEXT,
    regio       TEXT,
    provincie   TEXT
);

-- FACT_Verkoop 
CREATE TABLE IF NOT EXISTS FACT_Verkoop (
    verkoop_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    productnr       INTEGER NOT NULL REFERENCES DIM_Product(productnr),
    klantnr         INTEGER NOT NULL REFERENCES DIM_Klant(surrogate_id),
    medewerkerID    INTEGER NOT NULL REFERENCES DIM_Medewerker(monteurID),
    datum           TEXT    NOT NULL REFERENCES DIM_Tijd(datum),
    aantal          INTEGER NOT NULL,
    verkoopprijs    REAL    NOT NULL,
    omzet           REAL    NOT NULL
);

-- FACT_Inkoop
CREATE TABLE IF NOT EXISTS FACT_Inkoop (
    inkoop_id       INTEGER PRIMARY KEY AUTOINCREMENT,
    productnr       INTEGER NOT NULL REFERENCES DIM_Product(productnr),
    partnernr       INTEGER NOT NULL REFERENCES DIM_Partner(partnernr),
    datum           TEXT    NOT NULL REFERENCES DIM_Tijd(datum),
    aantal          INTEGER NOT NULL,
    inkoopwaarde    REAL    NOT NULL
);

-- FACT_Onderhoud
CREATE TABLE IF NOT EXISTS FACT_Onderhoud (
    onderhoud_id    INTEGER PRIMARY KEY AUTOINCREMENT,
    medewerkerID    INTEGER NOT NULL REFERENCES DIM_Medewerker(monteurID),
    klantnr         INTEGER          REFERENCES DIM_Klant(surrogate_id), 
    datum           TEXT    NOT NULL REFERENCES DIM_Tijd(datum),
    begintijd       TEXT    NOT NULL,
    eindtijd        TEXT    NOT NULL
);

-- KeyMapping Table (Onthoudt welke bron-ID bij welke DWH-ID hoort)
CREATE TABLE IF NOT EXISTS DWH_KeyMapping (
    mapping_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    dwh_table       TEXT    NOT NULL,
    source_table    TEXT    NOT NULL,
    source_key      INTEGER NOT NULL,
    dwh_surrogate   INTEGER NOT NULL,
    UNIQUE (dwh_table, source_table, source_key)
);