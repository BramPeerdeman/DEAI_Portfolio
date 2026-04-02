-- =============================================================
--  SterSchema – Data Warehouse DDL  (SQLite)
--  Star schema: 5 dimension tables + 3 fact tables
-- =============================================================

PRAGMA foreign_keys = ON;

-- =============================================================
--  DIMENSION TABLES
-- =============================================================

-- DIM_Tijd (Time dimension)
-- Natural key: datum (ISO date string YYYY-MM-DD)
CREATE TABLE IF NOT EXISTS DIM_Tijd (
    datum       TEXT    NOT NULL,
    dag         INTEGER NOT NULL,
    maand       INTEGER NOT NULL,
    kwartaal    INTEGER NOT NULL,
    jaar        INTEGER NOT NULL,
    weekend     INTEGER NOT NULL CHECK (weekend IN (0, 1)),
    PRIMARY KEY (datum)
);

-- DIM_Product
-- Surrogate key: productnr (auto-increment)
-- Source: FIETS UNION ACCESSOIRE
CREATE TABLE IF NOT EXISTS DIM_Product (
    productnr       INTEGER PRIMARY KEY AUTOINCREMENT,
    type            TEXT    NOT NULL,
    naam            TEXT    NOT NULL,
    producttype     TEXT    NOT NULL CHECK (producttype IN ('Fiets', 'Accessoire')),
    standaardprijs  REAL    NOT NULL,
    inkoopprijs     REAL    NOT NULL,
    prijsklasse     TEXT    NOT NULL CHECK (prijsklasse IN ('Low', 'Mid', 'High')),
    kleur           TEXT,
    merk            TEXT
);

-- DIM_Klant (Customer dimension)
-- Natural key: klantnr (kept from source)
CREATE TABLE IF NOT EXISTS DIM_Klant (
    klantnr             INTEGER PRIMARY KEY,
    naam                TEXT    NOT NULL,
    adres               TEXT,
    woonplaats          TEXT,
    geslacht            TEXT,
    geboortedatum       TEXT,
    leeftijdscategorie  TEXT
);

-- DIM_Partner
-- Surrogate key: partnernr (auto-increment)
-- Source: LEVERANCIER UNION FABRIKANT
CREATE TABLE IF NOT EXISTS DIM_Partner (
    partnernr   INTEGER PRIMARY KEY AUTOINCREMENT,
    naam        TEXT    NOT NULL,
    partnertype TEXT    NOT NULL CHECK (partnertype IN ('Leverancier', 'Fabrikant')),
    locatie     TEXT
);

-- DIM_Medewerker (Employee / Mechanic dimension)
-- Natural key: monteurID (kept from source)
-- Geographic hierarchy denormalised: filiaal -> regio -> provincie
CREATE TABLE IF NOT EXISTS DIM_Medewerker (
    monteurID   INTEGER PRIMARY KEY,
    naam        TEXT    NOT NULL,
    uurloon     REAL    NOT NULL,
    woonplaats  TEXT,
    filiaal     TEXT,
    regio       TEXT,
    provincie   TEXT
);

-- =============================================================
--  FACT TABLES
-- =============================================================

-- FACT_Verkoop (Sales fact)
-- Grain: one row per sale transaction line
-- Measures: aantal, verkoopprijs, omzet (= aantal x verkoopprijs)
CREATE TABLE IF NOT EXISTS FACT_Verkoop (
    verkoop_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    productnr       INTEGER NOT NULL REFERENCES DIM_Product(productnr),
    klantnr         INTEGER NOT NULL REFERENCES DIM_Klant(klantnr),
    medewerkerID    INTEGER NOT NULL REFERENCES DIM_Medewerker(monteurID),
    datum           TEXT    NOT NULL REFERENCES DIM_Tijd(datum),
    aantal          INTEGER NOT NULL,
    verkoopprijs    REAL    NOT NULL,
    omzet           REAL    NOT NULL
);

-- FACT_Inkoop (Purchase fact)
-- Grain: one row per purchase transaction line
-- Measures: aantal, inkoopwaarde
CREATE TABLE IF NOT EXISTS FACT_Inkoop (
    inkoop_id       INTEGER PRIMARY KEY AUTOINCREMENT,
    productnr       INTEGER NOT NULL REFERENCES DIM_Product(productnr),
    partnernr       INTEGER NOT NULL REFERENCES DIM_Partner(partnernr),
    datum           TEXT    NOT NULL REFERENCES DIM_Tijd(datum),
    aantal          INTEGER NOT NULL,
    inkoopwaarde    REAL    NOT NULL
);

-- FACT_Onderhoud (Maintenance fact)
-- Grain: one row per maintenance appointment
-- Measures: begintijd, eindtijd (duur can be derived)
CREATE TABLE IF NOT EXISTS FACT_Onderhoud (
    onderhoud_id    INTEGER PRIMARY KEY AUTOINCREMENT,
    medewerkerID    INTEGER NOT NULL REFERENCES DIM_Medewerker(monteurID),
    klantnr         INTEGER          REFERENCES DIM_Klant(klantnr),  -- nullable: pre-sale maintenance has no customer yet
    datum           TEXT    NOT NULL REFERENCES DIM_Tijd(datum),
    begintijd       TEXT    NOT NULL,
    eindtijd        TEXT    NOT NULL
);

-- =============================================================
--  INDEXES
-- =============================================================

CREATE INDEX IF NOT EXISTS IDX_Verkoop_Product  ON FACT_Verkoop(productnr);
CREATE INDEX IF NOT EXISTS IDX_Verkoop_Klant    ON FACT_Verkoop(klantnr);
CREATE INDEX IF NOT EXISTS IDX_Verkoop_Medew    ON FACT_Verkoop(medewerkerID);
CREATE INDEX IF NOT EXISTS IDX_Verkoop_Datum    ON FACT_Verkoop(datum);

CREATE INDEX IF NOT EXISTS IDX_Inkoop_Product   ON FACT_Inkoop(productnr);
CREATE INDEX IF NOT EXISTS IDX_Inkoop_Partner   ON FACT_Inkoop(partnernr);
CREATE INDEX IF NOT EXISTS IDX_Inkoop_Datum     ON FACT_Inkoop(datum);

CREATE INDEX IF NOT EXISTS IDX_Onderhoud_Medew  ON FACT_Onderhoud(medewerkerID);
CREATE INDEX IF NOT EXISTS IDX_Onderhoud_Klant  ON FACT_Onderhoud(klantnr);
CREATE INDEX IF NOT EXISTS IDX_Onderhoud_Datum  ON FACT_Onderhoud(datum);

-- =============================================================
--  END OF SCRIPT
-- =============================================================