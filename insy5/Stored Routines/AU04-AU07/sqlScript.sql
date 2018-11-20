-- Autor: MARM
-- Datum: 20120306
-- Zweck: Musterloesung fuer "Stored Routines"

-- Editor: Mario Fentler
-- Datum: 07-11-2018
-- Zweck: AU02

\c template1
DROP DATABASE restaurant;
CREATE DATABASE restaurant OWNER mario;
\c restaurant

DROP TABLE IF EXISTS kellner CASCADE;
CREATE TABLE kellner (
             knr         INTEGER,
             name        VARCHAR(255),
             PRIMARY KEY (knr)
             );

INSERT INTO kellner VALUES (1, 'Kellner1');
INSERT INTO kellner VALUES (2, 'Kellner2');
INSERT INTO kellner VALUES (3, 'Kellner3');

DROP TABLE IF EXISTS speise CASCADE;
CREATE TABLE speise (
             snr         INTEGER,
             bezeichnung VARCHAR(255),
             preis       DECIMAL(6,2),
             PRIMARY KEY (snr)
             );

INSERT INTO speise VALUES (1, 'Heisse Liebe',         3);
INSERT INTO speise VALUES (2, 'Schoko Palatschinken', 4);
INSERT INTO speise VALUES (3, 'Pute gebacken',        7);
INSERT INTO speise VALUES (4, 'Pute natur',           8);
INSERT INTO speise VALUES (5, 'Puten-Cordon',         9);
INSERT INTO speise VALUES (6, 'Menue fuer 2',        15);
INSERT INTO speise VALUES (7, 'Menue fuer 3',        19);
INSERT INTO speise VALUES (8, 'Menue fuer 4',        22);

DROP TABLE IF EXISTS rechnung CASCADE;
CREATE TABLE rechnung (
             rnr         INTEGER,
             datum       DATE,
             tisch       SMALLINT,
             status      CHAR(8),
             knr         INTEGER,
             PRIMARY KEY (rnr),
             FOREIGN KEY (knr) REFERENCES kellner (knr)
                               ON UPDATE CASCADE ON DELETE CASCADE
             );

INSERT INTO rechnung VALUES (1, '2013-03-07', 1, 'bezahlt', 1);
INSERT INTO rechnung VALUES (2, '2013-03-07', 2, 'offen', 2);
INSERT INTO rechnung VALUES (3, '2013-03-07', 1, 'gedruckt', 3);
INSERT INTO rechnung VALUES (4, '2013-03-07', 1, 'gedruckt', 1);
INSERT INTO rechnung VALUES (5, CURRENT_DATE, 1, 'bezahlt', 1);
INSERT INTO rechnung VALUES (6, '2013-03-07', 2, 'offen', 2);

DROP TABLE IF EXISTS bestellung CASCADE;
CREATE TABLE bestellung (
             anzahl      SMALLINT,
             rnr         INTEGER,
             snr         INTEGER,
             PRIMARY KEY (rnr, snr),
             FOREIGN KEY (rnr) REFERENCES rechnung (rnr)
                               ON UPDATE CASCADE ON DELETE CASCADE,
             FOREIGN KEY (snr) REFERENCES speise (snr)
                               ON UPDATE CASCADE ON DELETE CASCADE
             );

INSERT INTO bestellung VALUES (9, 1, 1);
INSERT INTO bestellung VALUES (1, 1, 4);
INSERT INTO bestellung VALUES (1, 1, 5);
INSERT INTO bestellung VALUES (1, 2, 7);
INSERT INTO bestellung VALUES (1, 3, 8);
INSERT INTO bestellung VALUES (9, 4, 1);
INSERT INTO bestellung VALUES (9, 5, 1);
INSERT INTO bestellung VALUES (9, 6, 2);

--AU02
-- Die Definition OR REPLACE bewirkt, dass keine Fehlermeldung ausgegeben wird, wenn eine gleichnamige Funktion existiert, die nun überschrieben werden soll. 
CREATE OR REPLACE FUNCTION preisErhoehungHelper(NUMERIC,INTEGER,INTEGER) RETURNS VOID AS $$
    UPDATE speise SET preis = preis + $2 WHERE preis <= $1;
    UPDATE speise SET preis = preis + preis * $3 / 100 WHERE preis > $1; $$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION preisErhoehung(INTEGER,INTEGER) RETURNS VOID AS $$
    SELECT * FROM preisErhoehungHelper((SELECT avg(preis) FROM speise),$1,$2);$$ LANGUAGE SQL;

SELECT * FROM speise;
-- preisErhoehung2(preisErhoehung für preise < durchschnitt, für preise > durchschnitt)
SELECT * FROM preisErhoehung(1,5);

SELECT * FROM speise;


-- AU03

-- umsatz(kellnerNr)
CREATE OR REPLACE FUNCTION umsatz(INTEGER) RETURNS NUMERIC AS $$
    SELECT SUM(speise.preis)
    FROM speise,rechnung,bestellung
    WHERE speise.snr = bestellung.snr
    AND rechnung.rnr = bestellung.rnr
    AND rechnung.status = 'bezahlt'
    AND rechnung.knr = $1
    AND rechnung.datum = CURRENT_DATE;
$$ LANGUAGE SQL;

-- dazu wurde bei den rechnungen das Datum noch auf das current Date gesetzt.
SELECT * FROM umsatz(1);

-- AU04 a/b
-- Erstelle eine weitere Funktion zur Berechnung der MWSt. Zeige von allen Speisen den Brutto-Preis
-- als Brutto und die darin enthaltene MWSt. als Spalte MWSt an. (AU04a)
--
CREATE OR REPLACE FUNCTION bruttoPreis(speise) RETURNS NUMERIC AS $$
    SELECT $1.preis * 1.2;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION mehrwertSteuer(speise) RETURNS NUMERIC AS $$
    SELECT $1.preis * 0.2;
$$ LANGUAGE SQL;

-- Die Ausgabe Brutto/MWSt soll auf zwei Nachkommastellen beschränkt werden (AU04b)
-- cast(zahl as decimal (vorkommastellen,nachkommastellen)) -> kürzt das Ergebnis
SELECT bezeichnung, preis AS "Netto",
    cast(bruttoPreis(speise.*) AS DECIMAL (12,2)) AS "Brutto", 
    cast(mehrwertSteuer(speise.*) AS DECIMAL(12,2)) AS "Mehrwertsteuer" 
    FROM speise;


-- AU05a
-- Erstelle eine Funktion zur Anzeige der Bezeichnungen der noch nie bestellten Speisen
-- 
CREATE OR REPLACE FUNCTION nochNieBestellteSpeisen() RETURNS SETOF TEXT AS $$
    SELECT speise.bezeichnung AS "Bezeichnung" FROM speise
    WHERE speise.snr NOT IN (SELECT snr FROM bestellung);
$$ LANGUAGE SQL;

SELECT * FROM nochNieBestellteSpeisen() AS "Noch nie bestellte Speisen - AU05a";

CREATE TABLE speisenHelper(
    Bezeichnung VARCHAR(255),
    Nettopreis DECIMAL(6,2)
);

-- AU05b
-- Erweitere die aufrufende SELECT-Anweisung so, dass das Ergebnis als Tabelle mit den Spaltenüberschriften "Bezeichnung" und "Nettopreis" angezeigt wird.
--
CREATE OR REPLACE FUNCTION nochNieBestellteSpeisen2() RETURNS SETOF speisenHelper AS $$
    SELECT speise.bezeichnung AS "Bezeichnung",speise.preis AS "Nettopreis" FROM speise
    WHERE speise.snr NOT IN (SELECT snr FROM bestellung)
$$ LANGUAGE SQL;

SELECT * FROM nochNieBestellteSpeisen2();

DROP FUNCTION nochNieBestellteSpeisen2();
DROP TABLE speisenHelper;

-- AU06
-- Erstelle zwei Funktionen die in der SELECT-Klausel eingebettet werden,
-- um damit zusätzliche Spalten je Kellner anzeigen zu können. 
-- Die aufrufende SELECT-Anweisung soll folgende Ausgabe produzieren:
--
-- Kellnername, Anzahl der Rechnungen, Status der spätesten Rechnung
--

CREATE TABLE kellnerHelper(
    Kellnername TEXT,
    AnzahlRechnungen BIGINT,
    StatusDerLetztenRechnung CHARACTER(255)
);

CREATE OR REPLACE FUNCTION anzahlRechnung(INTEGER) 
RETURNS BIGINT AS $$
SELECT COUNT(rechnung.rnr) 
FROM rechnung
WHERE rechnung.knr = $1;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION statusLetzteRechnung(INTEGER) RETURNS CHARACTER(255) AS $$
    SELECT rechnung.status FROM rechnung
    WHERE rechnung.knr = $1 AND rechnung.datum = (
        SELECT MAX(rechnung.datum)
        FROM rechnung WHERE rechnung.knr = $1
    );
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION kellnerDaten() RETURNS SETOF kellnerHelper AS $$
    SELECT kellner.name AS "Kellnername",
    anzahlRechnung(kellner.knr) AS "AnzahlRechnungen",
    statusletzteRechnung(kellner.knr) AS "StatusDerLetzenRechnung"
    FROM kellner;
$$ LANGUAGE SQL;

SELECT * FROM kellnerDaten();

DROP FUNCTION anzahlRechnung();
DROP FUNCTION statusLetzteRechnung();
DROP FUNCTION kellnerDaten();
DROP TABLE kellnerHelper;


-- AU07
--
-- Es soll eine Liste der Kellner und deren jeweiliger Tagesumsatz ausgegeben werden.
-- Dazu werden zuerst noch Dummy Daten eingetragen
--

INSERT INTO rechnung (rnr, datum, tisch, status, knr) VALUES(10, CURRENT_DATE, 3, 'bezahlt', 2);
INSERT INTO rechnung (rnr, datum, tisch, status, knr) VALUES(11, CURRENT_DATE, 4, 'bezahlt', 2);

INSERT INTO bestellung (anzahl, rnr, snr) VALUES (4, 10, 1);
INSERT INTO bestellung (anzahl, rnr, snr) VALUES (6, 10, 2);
INSERT INTO bestellung (anzahl, rnr, snr) VALUES (2, 11, 3);
INSERT INTO bestellung (anzahl, rnr, snr) VALUES (1, 10, 4);

CREATE TABLE tagesumsatzHelper(
    kellnername TEXT,
    tagesumsatz NUMERIC
);

-- Hier inner Joins da die Tabellen kombiniert werden müssen

CREATE OR REPLACE FUNCTION tagesumsatz() RETURNS SETOF tagesumsatzHelper AS $$
    SELECT kellner.name AS "kellnername",
    SUM(speise.preis) AS "tagesumsatz"
    FROM kellner
    INNER JOIN rechnung ON (rechnung.knr = kellner.knr)
    INNER JOIN bestellung ON (bestellung.rnr = rechnung.rnr)
    INNER JOIN speise ON (speise.snr = bestellung.snr)
    WHERE rechnung.datum = CURRENT_DATE AND
    rechnung.status = 'bezahlt'
    GROUP BY kellner.name;
$$ LANGUAGE SQL;

SELECT * FROM tagesumsatz();

DROP FUNCTION tagesumsatz();
DROP TABLE tagesumsatzHelper;

